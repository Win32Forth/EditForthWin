#include "MainWindow.h"

#include "CodeEdit.h"
#include "DebugBar.h"
#include "ForthConsole.h"
#include "ForthPipe.h"

#include <QAction>
#include <QCloseEvent>
#include <QEvent>
#include <QDir>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QHBoxLayout>
#include <QLabel>
#include <QMenuBar>
#include <QPushButton>
#include <QMessageBox>
#include <QSettings>
#include <QShortcut>
#include <QSplitter>
#include <QStringList>
#include <QStandardPaths>
#include <QStatusBar>
#include <QTabWidget>
#include <QTextBlock>
#include <QVBoxLayout>
#include <QTextCursor>
#include <QTextDocument>

#include <functional>

namespace {
const char kPath[] = "path";

// EditForth open panels: Forth source (.fth .fs .4th .f) plus plain text (.txt).
const QString kSourceFilter =
    QStringLiteral("Forth files (*.fth *.fs *.4th *.f *.txt);;All files (*.*)");

bool isBye(const QString &line) {
    return line.trimmed().compare(QLatin1String("BYE"), Qt::CaseInsensitive) == 0;
}

// Whole line is one of these words. A name after the word is a normal eval.
enum class BareSource { None, Edit, Load };

BareSource bareSource(const QString &line) {
    const QString word = line.trimmed();
    if (word.compare(QLatin1String("EDIT"), Qt::CaseInsensitive) == 0)
        return BareSource::Edit;
    if (word.compare(QLatin1String("FLOAD"), Qt::CaseInsensitive) == 0)
        return BareSource::Load;
    if (word.compare(QLatin1String("INCLUDE"), Qt::CaseInsensitive) == 0)
        return BareSource::Load;
    return BareSource::None;
}

// INCLUDE "path" — the quotes are the filespec delimiters. Backslashes stay literal.
QString includedLine(const QString &path) {
    return QStringLiteral("INCLUDE \"%1\"").arg(path);
}

QString tabLabel(const CodeEdit *edit) {
    const QString path = edit->property(kPath).toString();
    QString name = path.isEmpty() ? edit->property("title").toString() : QFileInfo(path).fileName();
    if (edit->document()->isModified())
        name += QLatin1Char('*');
    return name;
}
}

// Floating Forth console. Closing it hides the transcript and leaves Forth running.
class ForthFloat : public QWidget {
public:
    std::function<void()> onDock;
    std::function<void()> onUserHide;
    bool quiet = false;
    QLabel *engine = nullptr;
    QLabel *mark = nullptr;
    QVBoxLayout *body = nullptr;

    ForthFloat() : QWidget(nullptr, Qt::Window) {
        setWindowTitle(QStringLiteral("Forth"));
        setMinimumSize(320, 160);
        setAttribute(Qt::WA_QuitOnClose, false);
        engine = new QLabel(QStringLiteral("Engine down"), this);
        mark = new QLabel(QStringLiteral("debugging"), this);
        mark->setStyleSheet(QStringLiteral("color: #c46200; font-weight: 600;"));
        mark->hide();
        auto *dock = new QPushButton(QStringLiteral("Dock"), this);
        connect(dock, &QPushButton::clicked, this, [this] {
            if (onDock)
                onDock();
        });
        auto *bar = new QHBoxLayout;
        bar->setContentsMargins(8, 4, 8, 4);
        bar->addWidget(engine);
        bar->addWidget(mark);
        bar->addStretch(1);
        bar->addWidget(dock);
        body = new QVBoxLayout(this);
        body->setContentsMargins(0, 0, 0, 0);
        body->setSpacing(0);
        body->addLayout(bar);
    }

    void setStatus(bool connected, bool armed) {
        engine->setText(connected ? QStringLiteral("Engine connected")
                                  : QStringLiteral("Engine down"));
        engine->setStyleSheet(connected ? QStringLiteral("color: #1b7a32; font-weight: 600;")
                                        : QStringLiteral("color: #666666;"));
        mark->setVisible(armed);
    }

    void closeQuietly() {
        quiet = true;
        hide();
        quiet = false;
    }

protected:
    void closeEvent(QCloseEvent *event) override {
        if (quiet) {
            event->accept();
            return;
        }
        event->ignore();
        hide();
        if (onUserHide)
            onUserHide();
    }
};

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent) {
    setWindowTitle(QStringLiteral("EditForthWin"));
    setMinimumSize(640, 420);

    m_tabs = new QTabWidget(this);
    m_tabs->setDocumentMode(true);
    m_tabs->setTabsClosable(true);
    m_tabs->setMovable(true);

    m_console = new ForthConsole(this);
    m_debug = new DebugBar(this);
    m_pipe = new ForthPipe(this);
    connect(m_console, &ForthConsole::submitted, this, [this](const QString &line) {
        if (isBye(line)) {
            close();
            if (isVisible())
                m_console->retractSubmit();
            return;
        }
        if (m_armed) {
            m_console->retractSubmit();
            m_debug->setError(QStringLiteral("debugger paused - use Step, Continue, or Stop"));
            return;
        }
        const BareSource bare = bareSource(line);
        if (bare != BareSource::None) {
            presentSourceDialog(bare == BareSource::Load);
            return;
        }
        m_pipe->eval(line);
    });
    m_forthDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
                 QStringLiteral("/EditForthWin");
    connect(m_pipe, &ForthPipe::directoryChanged, this, [this](const QString &path) {
        if (!path.isEmpty())
            m_forthDir = path;
        if (!m_connected) {
            m_connected = true;
            m_debug->setConnected(true);
            updateDebugKeys();
            syncConsoleChrome();
        }
    });
    connect(m_pipe, &ForthPipe::outputReceived, this, [this](const QString &text) {
        if (!m_connected) {
            m_connected = true;
            m_debug->setConnected(true);
            updateDebugKeys();
            syncConsoleChrome();
        }
        m_console->setEngineAlive(true);
        m_console->appendOutput(text);
    });
    connect(m_pipe, &ForthPipe::engineStopped, this, [this] {
        m_connected = false;
        m_armed = false;
        m_paused = false;
        m_console->setEngineAlive(false);
        m_console->setInputLocked(false);
        m_debug->setConnected(false);
        m_debug->setError(QString());
        m_debug->setNote(QString());
        clearHits();
        updateDebugKeys();
        syncConsoleChrome();
        m_console->appendOutput(QStringLiteral("\nForth stopped.\n"));
    });
    connect(m_pipe, &ForthPipe::engineFailed, this, [this](const QString &message) {
        m_connected = false;
        m_armed = false;
        m_paused = false;
        m_console->setEngineAlive(false);
        m_console->setInputLocked(false);
        m_debug->setConnected(false);
        clearHits();
        updateDebugKeys();
        syncConsoleChrome();
        m_console->appendOutput(message + QLatin1Char('\n'));
    });
    connect(m_pipe, &ForthPipe::debugReceived, this, &MainWindow::onDebug);
    connect(m_pipe, &ForthPipe::breaksReceived, m_debug, &DebugBar::setBreaks);
    connect(m_pipe, &ForthPipe::statusError, m_debug, &DebugBar::setError);
    connect(m_pipe, &ForthPipe::editReceived, this, &MainWindow::openRequestedFile);
    connect(m_debug, &DebugBar::pauseRequested, this, &MainWindow::pauseNow);
    connect(m_debug, &DebugBar::breakpointsRequested, m_pipe, &ForthPipe::requestBreaks);
    connect(m_debug, &DebugBar::armRequested, this, &MainWindow::armDebug);
    connect(m_debug, &DebugBar::stepOverRequested, this, [this] { sendStep(32); });
    connect(m_debug, &DebugBar::stepIntoRequested, this, [this] { sendStep(105); });
    connect(m_debug, &DebugBar::stepOutRequested, this, [this] { sendStep(33554450); });
    connect(m_debug, &DebugBar::continueRequested, this, [this] { sendStep(103); });
    connect(m_debug, &DebugBar::stopRequested, this, [this] { sendStep(113); });
    connect(m_debug, &DebugBar::toggleCaretRequested, this, &MainWindow::toggleCaretBreak);
    connect(m_debug, &DebugBar::breakEnableRequested, m_pipe, &ForthPipe::enableBreak);
    connect(m_debug, &DebugBar::dockToggleRequested, this, &MainWindow::toggleConsolePlace);

    m_bottom = new QWidget(this);
    m_bottomLayout = new QVBoxLayout(m_bottom);
    m_bottomLayout->setContentsMargins(0, 0, 0, 0);
    m_bottomLayout->setSpacing(0);
    m_bottomLayout->addWidget(m_debug);
    m_bottomLayout->addWidget(m_console, 1);

    m_split = new QSplitter(Qt::Vertical, this);
    m_split->addWidget(m_tabs);
    m_split->addWidget(m_bottom);
    m_split->setStretchFactor(0, 3);
    m_split->setStretchFactor(1, 1);
    m_split->setSizes({480, 220});
    m_console->setMinimumHeight(80);
    setCentralWidget(m_split);
    connect(m_tabs, &QTabWidget::tabCloseRequested, this, &MainWindow::closeTab);
    connect(m_tabs, &QTabWidget::currentChanged, this, [this](int) { refreshStatus(); });

    auto *fileMenu = menuBar()->addMenu(QStringLiteral("&File"));
    fileMenu->addAction(QStringLiteral("&New"), QKeySequence::New, this, &MainWindow::newFile);
    fileMenu->addAction(QStringLiteral("&Open..."), QKeySequence::Open, this, [this] {
        const QString path = QFileDialog::getOpenFileName(
            this, QStringLiteral("Open"), m_forthDir, kSourceFilter);
        if (!path.isEmpty())
            openFile(path);
    });
    fileMenu->addAction(QStringLiteral("&Save"), QKeySequence::Save, this, [this] {
        if (CodeEdit *edit = currentEdit())
            saveEdit(edit);
    });
    fileMenu->addAction(QStringLiteral("Save &As..."), QKeySequence::SaveAs, this, [this] {
        if (CodeEdit *edit = currentEdit())
            saveEditAs(edit);
    });
    fileMenu->addSeparator();
    fileMenu->addAction(QStringLiteral("&Close"), QKeySequence::Close, this, [this] {
        closeTab(m_tabs->currentIndex());
    });
    fileMenu->addSeparator();
    fileMenu->addAction(QStringLiteral("E&xit"), QKeySequence::Quit, this, &QWidget::close);

    auto *viewMenu = menuBar()->addMenu(QStringLiteral("&View"));
    m_lineNumbersAction = viewMenu->addAction(QStringLiteral("Show &Line Numbers"));
    m_lineNumbersAction->setCheckable(true);
    QSettings settings;
    m_lineNumbersAction->setChecked(settings.value(QStringLiteral("showLineNumbers"), true).toBool());
    connect(m_lineNumbersAction, &QAction::toggled, this, [this](bool on) {
        QSettings().setValue(QStringLiteral("showLineNumbers"), on);
        applyLineNumbers();
    });
    m_dockAction = viewMenu->addAction(QStringLiteral("Undock Forth Console"));
    connect(m_dockAction, &QAction::triggered, this, &MainWindow::toggleConsolePlace);

    statusBar();

    const auto windowKey = [this](const QKeySequence &seq) {
        auto *key = new QShortcut(seq, this);
        key->setContext(Qt::WindowShortcut);
        key->setEnabled(false);
        return key;
    };
    m_keyOver = windowKey(QKeySequence(Qt::Key_F6));
    m_keyInto = windowKey(QKeySequence(Qt::Key_F7));
    m_keyOut = windowKey(QKeySequence(Qt::Key_F8));
    m_keyGo = windowKey(QKeySequence(Qt::Key_F5));
    m_keyStop = windowKey(QKeySequence(Qt::Key_Escape));
    m_keyPause = windowKey(QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_Y));
    m_keyBreak = windowKey(QKeySequence(Qt::Key_F9));
    connect(m_keyOver, &QShortcut::activated, this, [this] { sendStep(32); });
    connect(m_keyInto, &QShortcut::activated, this, [this] { sendStep(105); });
    connect(m_keyOut, &QShortcut::activated, this, [this] { sendStep(33554450); });
    connect(m_keyGo, &QShortcut::activated, this, [this] { sendStep(103); });
    connect(m_keyStop, &QShortcut::activated, this, [this] { sendStep(113); });
    connect(m_keyPause, &QShortcut::activated, this, &MainWindow::pauseNow);
    connect(m_keyBreak, &QShortcut::activated, this, &MainWindow::toggleCaretBreak);
    updateDebugKeys();
    m_debug->installEventFilter(this);
    if (!settings.value(QStringLiteral("forthDocked"), true).toBool())
        undockConsole();
    else
        syncConsoleChrome();

    const QByteArray geo = settings.value(QStringLiteral("geometry")).toByteArray();
    if (!geo.isEmpty())
        restoreGeometry(geo);
    m_pipe->start();
}

void MainWindow::openRequestedFile(const QString &text) {
    QString start = text;
    const bool dialog = start.isEmpty() || start.endsWith(QLatin1Char('\\')) ||
                        start.endsWith(QLatin1Char('/'));
    if (!dialog) {
        openFile(start);
        return;
    }
    if (start.endsWith(QLatin1Char('\\')) || start.endsWith(QLatin1Char('/')))
        start.chop(1);
    if (start.isEmpty())
        start = m_forthDir;
    const QString path = QFileDialog::getOpenFileName(
        this, QStringLiteral("EDIT"), start, kSourceFilter);
    if (!path.isEmpty())
        openFile(path);
}

void MainWindow::presentSourceDialog(bool loadIntoForth) {
    const QString path = QFileDialog::getOpenFileName(
        this, loadIntoForth ? QStringLiteral("FLOAD") : QStringLiteral("EDIT"),
        m_forthDir, kSourceFilter);
    if (loadIntoForth && !path.isEmpty()) {
        if (path.size() > 255 || path.contains(QLatin1Char('"'))) {
            QMessageBox::warning(this, QStringLiteral("EditForthWin"),
                                 QStringLiteral("That path cannot be FLOADed."));
            m_pipe->eval(QString());
            return;
        }
        m_pipe->eval(includedLine(path));
        return;
    }
    if (!path.isEmpty())
        openFile(path);
    m_pipe->eval(QString());
}

void MainWindow::newFile() {
    auto *edit = new CodeEdit;
    ++m_untitled;
    const QString title = m_untitled == 1 ? QStringLiteral("Untitled")
                                          : QStringLiteral("Untitled %1").arg(m_untitled);
    edit->setProperty("title", title);
    edit->setLineNumbersVisible(m_lineNumbersAction->isChecked());
    addEditor(edit, title);
}

void MainWindow::openFile(const QString &path) {
    const QString canonical = QFileInfo(path).absoluteFilePath();
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (editAt(i)->property(kPath).toString().compare(canonical, Qt::CaseInsensitive) == 0) {
            m_tabs->setCurrentIndex(i);
            return;
        }
    }
    QFile file(canonical);
    if (!file.open(QIODevice::ReadOnly)) {
        QMessageBox::warning(this, QStringLiteral("EditForthWin"),
                             QStringLiteral("Can't open %1").arg(canonical));
        return;
    }
    auto *edit = new CodeEdit;
    edit->setPlainText(QString::fromUtf8(file.readAll()));
    edit->document()->setModified(false);
    edit->setProperty(kPath, canonical);
    edit->setLineNumbersVisible(m_lineNumbersAction->isChecked());
    addEditor(edit, QFileInfo(canonical).fileName());
}

int MainWindow::tabCount() const { return m_tabs->count(); }

void MainWindow::closeEvent(QCloseEvent *event) {
    for (int i = 0; i < m_tabs->count(); ++i) {
        m_tabs->setCurrentIndex(i);
        if (!maybeSave(editAt(i))) {
            event->ignore();
            return;
        }
    }
    if (m_float != nullptr) {
        QSettings().setValue(QStringLiteral("undockedGeometry"), m_float->saveGeometry());
        m_console->setParent(m_bottom);
        m_float->closeQuietly();
        delete m_float;
        m_float = nullptr;
    }
    if (m_pipe != nullptr)
        m_pipe->shutdown();
    QSettings().setValue(QStringLiteral("geometry"), saveGeometry());
    event->accept();
}

bool MainWindow::eventFilter(QObject *watched, QEvent *event) {
    if (watched == m_debug && !m_docked && event->type() == QEvent::Resize) {
        const int height = qMax(m_debug->height(), 1);
        if (m_bottom->maximumHeight() != height)
            m_bottom->setMaximumHeight(height);
    }
    return QMainWindow::eventFilter(watched, event);
}

void MainWindow::toggleConsolePlace() {
    if (m_consoleHidden || m_docked)
        undockConsole();
    else
        dockConsole();
}

void MainWindow::ensureFloat() {
    if (m_float != nullptr)
        return;
    m_float = new ForthFloat;
    m_float->onDock = [this] { dockConsole(); };
    m_float->onUserHide = [this] { hideConsole(); };
    const QByteArray geo = QSettings().value(QStringLiteral("undockedGeometry")).toByteArray();
    if (!geo.isEmpty())
        m_float->restoreGeometry(geo);
    else
        m_float->resize(640, 380);
    m_float->setStatus(m_connected, m_armed);
}

void MainWindow::dockConsole() {
    if (m_docked && !m_consoleHidden)
        return;
    if (m_float != nullptr)
        QSettings().setValue(QStringLiteral("undockedGeometry"), m_float->saveGeometry());
    m_bottomLayout->addWidget(m_console, 1);
    m_console->setMinimumHeight(80);
    m_console->show();
    m_docked = true;
    m_consoleHidden = false;
    QSettings().setValue(QStringLiteral("forthDocked"), true);
    if (m_float != nullptr)
        m_float->closeQuietly();
    if (m_dockedSplit.size() == 2)
        m_split->setSizes(m_dockedSplit);
    syncConsoleChrome();
    m_console->setFocus();
}

void MainWindow::undockConsole() {
    if (!m_docked && !m_consoleHidden && m_float != nullptr && m_float->isVisible())
        return;
    if (m_docked)
        m_dockedSplit = m_split->sizes();
    ensureFloat();
    m_float->body->addWidget(m_console, 1);
    m_console->show();
    m_docked = false;
    m_consoleHidden = false;
    QSettings().setValue(QStringLiteral("forthDocked"), false);
    m_float->show();
    m_float->raise();
    m_float->activateWindow();
    syncConsoleChrome();
    m_console->setFocus();
}

void MainWindow::hideConsole() {
    if (m_consoleHidden)
        return;
    if (m_docked)
        m_dockedSplit = m_split->sizes();
    if (m_float != nullptr)
        QSettings().setValue(QStringLiteral("undockedGeometry"), m_float->saveGeometry());
    m_docked = false;
    m_consoleHidden = true;
    QSettings().setValue(QStringLiteral("forthDocked"), false);
    if (m_float != nullptr)
        m_float->closeQuietly();
    syncConsoleChrome();
}

void MainWindow::syncConsoleChrome() {
    using Place = DebugBar::ConsolePlace;
    const Place place = m_consoleHidden ? Place::Hidden : m_docked ? Place::Docked : Place::Floating;
    m_debug->setConsolePlace(place);
    if (m_dockAction != nullptr) {
        const QString text = place == Place::Floating  ? QStringLiteral("Dock Forth Console")
                            : place == Place::Hidden   ? QStringLiteral("Unhide Forth Console")
                                                       : QStringLiteral("Undock Forth Console");
        m_dockAction->setText(text);
    }
    if (m_float != nullptr)
        m_float->setStatus(m_connected, m_armed);
    if (m_docked)
        m_bottom->setMaximumHeight(QWIDGETSIZE_MAX);
    else
        m_bottom->setMaximumHeight(qMax(m_debug->sizeHint().height(), 1));
}

CodeEdit *MainWindow::currentEdit() const { return editAt(m_tabs->currentIndex()); }

CodeEdit *MainWindow::editAt(int index) const {
    return qobject_cast<CodeEdit *>(m_tabs->widget(index));
}

void MainWindow::addEditor(CodeEdit *edit, const QString &title) {
    wire(edit);
    const int index = m_tabs->addTab(edit, title);
    m_tabs->setCurrentIndex(index);
    edit->setFocus();
    refreshStatus();
}

void MainWindow::wire(CodeEdit *edit) {
    connect(edit->document(), &QTextDocument::modificationChanged, this, [this, edit] {
        refreshTitle(edit);
    });
    connect(edit, &CodeEdit::cursorPositionChanged, this, [this, edit] {
        if (edit == currentEdit())
            refreshStatus();
    });
}

bool MainWindow::saveEdit(CodeEdit *edit) {
    if (edit->property(kPath).toString().isEmpty())
        return saveEditAs(edit);
    QFile file(edit->property(kPath).toString());
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        QMessageBox::warning(this, QStringLiteral("EditForthWin"),
                             QStringLiteral("Can't save %1").arg(file.fileName()));
        return false;
    }
    file.write(edit->toPlainText().toUtf8());
    edit->document()->setModified(false);
    refreshTitle(edit);
    return true;
}

bool MainWindow::saveEditAs(CodeEdit *edit) {
    QString path = QFileDialog::getSaveFileName(
        this, QStringLiteral("Save As"), edit->property(kPath).toString(),
        QStringLiteral("Forth files (*.fth);;All files (*.*)"));
    if (path.isEmpty())
        return false;
    edit->setProperty(kPath, QFileInfo(path).absoluteFilePath());
    return saveEdit(edit);
}

bool MainWindow::maybeSave(CodeEdit *edit) {
    if (!edit || !edit->document()->isModified())
        return true;
    const auto answer = QMessageBox::warning(
        this, QStringLiteral("EditForthWin"),
        QStringLiteral("%1 has unsaved changes.").arg(tabLabel(edit).remove('*')),
        QMessageBox::Save | QMessageBox::Discard | QMessageBox::Cancel);
    if (answer == QMessageBox::Save)
        return saveEdit(edit);
    return answer == QMessageBox::Discard;
}

void MainWindow::refreshTitle(CodeEdit *edit) {
    const int index = m_tabs->indexOf(edit);
    if (index >= 0)
        m_tabs->setTabText(index, tabLabel(edit));
    if (edit == currentEdit())
        refreshStatus();
}

void MainWindow::refreshStatus() {
    CodeEdit *edit = currentEdit();
    if (!edit) {
        statusBar()->clearMessage();
        return;
    }
    const QTextCursor cursor = edit->textCursor();
    const QString path = edit->property(kPath).toString();
    const QString where = path.isEmpty() ? edit->property("title").toString() : path;
    statusBar()->showMessage(
        QStringLiteral("%1    Ln %2, Col %3").arg(where).arg(cursor.blockNumber() + 1).arg(cursor.columnNumber() + 1));
}

void MainWindow::applyLineNumbers() {
    const bool on = m_lineNumbersAction->isChecked();
    for (int i = 0; i < m_tabs->count(); ++i)
        editAt(i)->setLineNumbersVisible(on);
}

void MainWindow::closeTab(int index) {
    CodeEdit *edit = editAt(index);
    if (!edit)
        return;
    if (!maybeSave(edit))
        return;
    m_tabs->removeTab(index);
    edit->deleteLater();
    if (m_tabs->count() == 0)
        newFile();
}

void MainWindow::onDebug(bool armed, bool paused, int line, int off, int len, const QString &name,
                         const QString &path) {
    m_connected = true;
    m_armed = armed;
    m_paused = paused && armed;
    m_console->setEngineAlive(true);
    m_console->setInputLocked(m_armed);
    m_debug->setConnected(true);
    m_debug->setDebug(m_armed, m_paused, name);
    m_debug->setError(QString());
    updateDebugKeys();
    syncConsoleChrome();
    clearHits();
    if (!m_paused) {
        m_debug->setNote(QString());
        return;
    }
    showHit(line, off, len, name, path);
}

void MainWindow::sendStep(int key) {
    if (!m_paused)
        return;
    m_paused = false;
    m_debug->setDebug(m_armed, false, QString());
    updateDebugKeys();
    m_pipe->sendKey(key);
}

void MainWindow::armDebug() {
    if (!m_connected)
        return;
    if (m_paused) {
        m_paused = false;
        m_debug->setDebug(m_armed, false, QString());
        m_debug->setError(QString());
        updateDebugKeys();
        m_pipe->sendArm();
        return;
    }
    if (m_armed)
        return;
    const QString word = caretWord();
    if (word.isEmpty() || word.contains(QLatin1Char('"'))) {
        m_debug->setError(QStringLiteral("Arm needs a word at the caret."));
        return;
    }
    m_debug->setError(QString());
    m_pipe->eval(QStringLiteral("BPGO %1").arg(word));
}

void MainWindow::pauseNow() {
    if (!m_connected)
        return;
    if (!m_pipe->signalBreak())
        m_debug->setError(QStringLiteral("Pause could not reach Forth."));
}

void MainWindow::toggleCaretBreak() {
    if (!m_connected)
        return;
    const QString word = caretWord();
    if (word.isEmpty() || word.contains(QLatin1Char('"'))) {
        m_debug->setError(QStringLiteral("Break needs a word at the caret."));
        return;
    }
    m_debug->setError(QString());
    m_pipe->toggleBreak(word);
}

void MainWindow::updateDebugKeys() {
    const bool step = m_paused;
    m_keyOver->setEnabled(step);
    m_keyInto->setEnabled(step);
    m_keyOut->setEnabled(step);
    m_keyGo->setEnabled(step);
    m_keyStop->setEnabled(step);
    m_keyPause->setEnabled(m_connected);
    m_keyBreak->setEnabled(m_connected);
}

void MainWindow::clearHits() {
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (CodeEdit *edit = editAt(i))
            edit->clearDebugHit();
    }
}

QString MainWindow::caretWord() const {
    const CodeEdit *edit = currentEdit();
    if (edit == nullptr)
        return {};
    const QString text = edit->textCursor().block().text();
    if (text.isEmpty())
        return {};
    int i = edit->textCursor().positionInBlock();
    if (i > text.size())
        i = text.size();
    if (i == text.size()) {
        if (i == 0 || text.at(i - 1).isSpace())
            return {};
        --i;
    } else if (text.at(i).isSpace()) {
        return {};
    }
    int start = i;
    int end = i + 1;
    while (start > 0 && !text.at(start - 1).isSpace())
        --start;
    while (end < text.size() && !text.at(end).isSpace())
        ++end;
    return text.mid(start, end - start);
}

QString MainWindow::resolveDebugPath(const QString &path) const {
    if (path.isEmpty())
        return {};
    const QFileInfo given(path);
    if (given.isAbsolute())
        return given.exists() ? given.absoluteFilePath() : QString();
    QStringList roots;
    if (!m_forthDir.isEmpty())
        roots << m_forthDir;
    const QString docs = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
                         QStringLiteral("/EditForthWin");
    roots << docs << QDir(docs).filePath(QStringLiteral("Library"));
    for (const QString &root : roots) {
        const QFileInfo candidate(QDir(root).filePath(path));
        if (candidate.isFile())
            return candidate.absoluteFilePath();
    }
    return {};
}

void MainWindow::showHit(int line, int off, int len, const QString &name, const QString &path) {
    const QString resolved = resolveDebugPath(path);
    if (resolved.isEmpty()) {
        m_debug->setNote(QString());
        return;
    }
    openFile(resolved);
    CodeEdit *edit = currentEdit();
    if (edit == nullptr ||
        edit->property(kPath).toString().compare(resolved, Qt::CaseInsensitive) != 0) {
        m_debug->setNote(QString());
        return;
    }
    const bool dirty = edit->document()->isModified();
    if (dirty && off > 0 && len > 0) {
        m_debug->setNote(QStringLiteral(
            "debug highlight: buffer has unsaved edits - using the word name, not the file span"));
    } else {
        m_debug->setNote(QString());
    }
    edit->showDebugHit(line, off, len, name, !dirty && off > 0 && len > 0);
}
