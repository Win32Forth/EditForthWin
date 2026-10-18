#include "MainWindow.h"

#include "AskForth.h"
#include "CodeEdit.h"
#include "DebugBar.h"
#include "DiskDiff.h"
#include "FindBar.h"
#include "FolderSearch.h"
#include "ForthConsole.h"
#include "ForthPipe.h"
#include "WebTab.h"

#include <QAction>
#include <QActionGroup>
#include <QApplication>
#include <QCloseEvent>
#include <QComboBox>
#include <QDesktopServices>
#include <QDialog>
#include <QDialogButtonBox>
#include <QPlainTextEdit>
#include <QEvent>
#include <QDir>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QHBoxLayout>
#include <QInputDialog>
#include <QLabel>
#include <QMenuBar>
#include <QPushButton>
#include <QMessageBox>
#include <QSettings>
#include <QSignalBlocker>
#include <QStringList>
#include <QShortcut>
#include <QSplitter>
#include <QStandardPaths>
#include <QStatusBar>
#include <QTabWidget>
#include <QTextBlock>
#include <QUrl>
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

// Uppercase stem, non-alnum collapsed to one underscore, edges stripped.
QString moduleMarker(const QString &path) {
    const QString stem = QFileInfo(path).completeBaseName().toUpper();
    QString out;
    bool gap = false;
    for (const QChar c : stem) {
        if (c.isLetterOrNumber()) {
            if (gap && !out.isEmpty())
                out += QLatin1Char('_');
            gap = false;
            out += c;
        } else {
            gap = true;
        }
    }
    if (out.isEmpty())
        out = QStringLiteral("UNTITLED");
    return out + QStringLiteral("_MODULE");
}

QString userFolder() {
    return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
           QStringLiteral("/EditForthWin");
}

bool browseSaved(const QString &path) {
    const QStringList paths = QSettings().value(QStringLiteral("browsePaths")).toStringList();
    return paths.contains(path, Qt::CaseInsensitive);
}

void storeBrowse(const QString &path, bool on) {
    QStringList paths = QSettings().value(QStringLiteral("browsePaths")).toStringList();
    paths.removeIf([&path](const QString &item) {
        return item.compare(path, Qt::CaseInsensitive) == 0;
    });
    if (on)
        paths.append(path);
    QSettings().setValue(QStringLiteral("browsePaths"), paths);
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
    connect(m_console, &ForthConsole::viewWordRequested, this, &MainWindow::viewWord);
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
        const QString shown = consumeStartup(text);
        if (!shown.isEmpty())
            m_console->appendOutput(shown);
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
        refreshViewBanners();
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
        refreshViewBanners();
        updateDebugKeys();
        syncConsoleChrome();
        m_console->appendOutput(message + QLatin1Char('\n'));
    });
    connect(m_pipe, &ForthPipe::debugReceived, this, &MainWindow::onDebug);
    connect(m_pipe, &ForthPipe::breaksReceived, m_debug, &DebugBar::setBreaks);
    connect(m_pipe, &ForthPipe::statusError, m_debug, &DebugBar::setError);
    connect(m_pipe, &ForthPipe::editReceived, this, &MainWindow::openRequestedFile);
    connect(m_pipe, &ForthPipe::lastReceived, this, &MainWindow::onLastName);
    connect(m_pipe, &ForthPipe::versionReceived, this, [this](const QString &text) {
        const QStringList lines = text.split(QLatin1Char('\n'));
        m_engineVersion = lines.value(0).trimmed();
        m_engineBuilt = lines.value(1).trimmed();
        const QString consoleName = lines.value(2).trimmed();
        if (!consoleName.isEmpty()) {
            m_consoleName = consoleName;
            m_console->setAccessibleName(consoleName);
            if (m_float != nullptr)
                m_float->setWindowTitle(consoleName);
        }
    });
    connect(m_debug, &DebugBar::includeRequested, this, &MainWindow::includeCurrent);
    connect(m_debug, &DebugBar::runRequested, this, [this] { prepareRun(RunKind::Execute); });
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

    m_find = new FindBar(this);
    m_find->hide();

    m_right = new QWidget(this);
    m_splitPick = new QComboBox(m_right);
    auto *closeSplit = new QPushButton(QStringLiteral("Close Split"), m_right);
    auto *splitBar = new QHBoxLayout;
    splitBar->setContentsMargins(6, 4, 6, 4);
    splitBar->addWidget(m_splitPick, 1);
    splitBar->addWidget(closeSplit);
    m_splitEdit = new CodeEdit;
    auto *splitPane = new EditorPane(m_splitEdit, m_right);
    auto *rightLayout = new QVBoxLayout(m_right);
    rightLayout->setContentsMargins(0, 0, 0, 0);
    rightLayout->setSpacing(0);
    rightLayout->addLayout(splitBar);
    rightLayout->addWidget(splitPane, 1);
    m_right->hide();
    connect(closeSplit, &QPushButton::clicked, this, &MainWindow::detachSplit);
    connect(m_splitPick, qOverload<int>(&QComboBox::activated), this, [this](int index) {
        const auto raw = static_cast<quintptr>(m_splitPick->itemData(index).toULongLong());
        attachSplit(reinterpret_cast<CodeEdit *>(raw));
    });
    connect(m_splitEdit, &CodeEdit::viewWordRequested, this, &MainWindow::viewWord);
    connect(m_splitEdit, &CodeEdit::breakWordRequested, this, &MainWindow::breakWord);
    connect(m_splitEdit, &CodeEdit::runToRequested, this, &MainWindow::runToHere);
    connect(m_splitEdit, &CodeEdit::browseChanged, this, [this](bool on) { noteBrowse(m_splitEdit, on); });

    m_editors = new QSplitter(Qt::Horizontal, this);
    m_editors->addWidget(m_tabs);
    m_editors->addWidget(m_right);
    m_askPanel = new AskForthPanel(m_editors);
    m_askPanel->setForthExeFinder([this] { return m_pipe->forthPath(); });
    m_askPanel->setFileOpener([this](const QString &path) -> CodeEdit * {
        openFile(path);
        const QString canonical = QFileInfo(path).absoluteFilePath();
        for (int i = 0; i < m_tabs->count(); ++i) {
            CodeEdit *edit = editAt(i);
            if (edit != nullptr &&
                edit->property(kPath).toString().compare(canonical, Qt::CaseInsensitive) == 0)
                return edit;
        }
        return nullptr;
    });
    m_askPanel->setSelectionSource([this] {
        CodeEdit *edit = nullptr;
        for (QWidget *widget = QApplication::focusWidget(); widget != nullptr;
             widget = widget->parentWidget()) {
            if (auto *found = qobject_cast<CodeEdit *>(widget)) {
                edit = found;
                break;
            }
        }
        if (edit == nullptr)
            edit = currentEdit();
        if (edit == nullptr)
            return QString();
        QString text = edit->textCursor().selectedText();
        text.replace(QChar(0x2029), QLatin1Char('\n'));
        return text;
    });
    m_editors->addWidget(m_askPanel);
    m_editors->setStretchFactor(0, 1);
    m_editors->setStretchFactor(1, 1);
    m_editors->setStretchFactor(2, 0);
    m_askPanel->hide();

    auto *top = new QWidget(this);
    auto *topLayout = new QVBoxLayout(top);
    topLayout->setContentsMargins(0, 0, 0, 0);
    topLayout->setSpacing(0);
    topLayout->addWidget(m_find);
    topLayout->addWidget(m_editors, 1);

    m_bottom = new QWidget(this);
    m_bottomLayout = new QVBoxLayout(m_bottom);
    m_bottomLayout->setContentsMargins(0, 0, 0, 0);
    m_bottomLayout->setSpacing(0);
    m_bottomLayout->addWidget(m_debug);
    m_bottomLayout->addWidget(m_console, 1);

    m_split = new QSplitter(Qt::Vertical, this);
    m_split->addWidget(top);
    m_split->addWidget(m_bottom);
    m_split->setStretchFactor(0, 3);
    m_split->setStretchFactor(1, 1);
    m_split->setSizes({480, 220});
    m_console->setMinimumHeight(80);
    setCentralWidget(m_split);
    connect(m_tabs, &QTabWidget::tabCloseRequested, this, &MainWindow::closeTab);
    connect(m_tabs, &QTabWidget::currentChanged, this, [this](int) {
        refreshStatus();
        syncTabChrome();
    });
    connect(qApp, &QApplication::focusChanged, this, [this](QWidget *, QWidget *now) {
        for (QWidget *widget = now; widget != nullptr; widget = widget->parentWidget()) {
            if (auto *edit = qobject_cast<CodeEdit *>(widget)) {
                m_find->attach(edit);
                break;
            }
        }
    });

    QSettings settings;
    m_pointSize = qBound(9, settings.value(QStringLiteral("editorPointSize"), 13).toInt(), 32);
    m_wrapMode = settings.value(QStringLiteral("wrapMode"), QStringLiteral("off")).toString();
    if (m_wrapMode != QLatin1String("window") && m_wrapMode != QLatin1String("column"))
        m_wrapMode = QStringLiteral("off");
    m_wrapColumn = qBound(40, settings.value(QStringLiteral("wrapColumn"), 80).toInt(), 300);
    applyEditorChrome(m_splitEdit);
    m_console->setPointSize(m_pointSize);

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
    m_compareAction = fileMenu->addAction(QStringLiteral("Compare with Disk"), this,
                                          &MainWindow::compareWithDisk);
    m_compareAction->setEnabled(false);
    fileMenu->addSeparator();
    fileMenu->addAction(QStringLiteral("&Close"), QKeySequence::Close, this, [this] {
        closeTab(m_tabs->currentIndex());
    });
    fileMenu->addSeparator();
    fileMenu->addAction(QStringLiteral("E&xit"), QKeySequence::Quit, this, &QWidget::close);

    auto *editMenu = menuBar()->addMenu(QStringLiteral("&Edit"));
    editMenu->addAction(QStringLiteral("&Find"), QKeySequence::Find, this, [this] { showFind(false); });
    auto *replaceItem = editMenu->addAction(QStringLiteral("Find and &Replace"), this, [this] {
        showFind(true);
    });
    replaceItem->setShortcuts({QKeySequence(Qt::CTRL | Qt::Key_H),
                               QKeySequence(Qt::CTRL | Qt::ALT | Qt::Key_F)});
    auto *findNext = editMenu->addAction(QStringLiteral("Find &Next"), this, [this] {
        showFind(false);
        m_find->findNext();
    });
    findNext->setShortcuts({QKeySequence(Qt::CTRL | Qt::Key_G), QKeySequence(Qt::Key_F3)});
    auto *findPrev = editMenu->addAction(QStringLiteral("Find &Previous"), this, [this] {
        showFind(false);
        m_find->findPrevious();
    });
    findPrev->setShortcuts(
        {QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_G), QKeySequence(Qt::SHIFT | Qt::Key_F3)});
    editMenu->addAction(QStringLiteral("Use Selection for Find"), this, [this] {
        if (CodeEdit *edit = currentEdit())
            m_find->attach(edit);
        m_find->useSelection();
    });
    editMenu->addAction(QStringLiteral("&Replace"), this, [this] {
        showFind(true);
        m_find->replaceSelection();
    });
    editMenu->addAction(QStringLiteral("Replace and Find Next"), this, [this] {
        showFind(true);
        m_find->replaceOne();
    });
    editMenu->addAction(QStringLiteral("Replace &All"), this, [this] {
        showFind(true);
        m_find->replaceAll();
    });
    editMenu->addSeparator();
    editMenu->addAction(QStringLiteral("Search in &Folders..."),
                        QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_F), this,
                        &MainWindow::searchInFolders);

    auto *viewMenu = menuBar()->addMenu(QStringLiteral("&View"));
    m_browseAction = viewMenu->addAction(QStringLiteral("Browse Mode"));
    m_browseAction->setCheckable(true);
    m_browseAction->setShortcut(QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_B));
    connect(m_browseAction, &QAction::toggled, this, &MainWindow::toggleBrowse);
    auto *allowEdit = new QShortcut(QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_E), this);
    allowEdit->setContext(Qt::WindowShortcut);
    connect(allowEdit, &QShortcut::activated, this, [this] {
        CodeEdit *edit = nullptr;
        for (QWidget *widget = QApplication::focusWidget(); widget != nullptr;
             widget = widget->parentWidget()) {
            if (auto *found = qobject_cast<CodeEdit *>(widget)) {
                edit = found;
                break;
            }
        }
        if (edit == nullptr)
            edit = currentEdit();
        if (edit != nullptr)
            edit->setBrowse(false);
    });
    m_showConsoleAction = viewMenu->addAction(QStringLiteral("Show Forth Console"));
    m_showConsoleAction->setCheckable(true);
    m_showConsoleAction->setChecked(true);
    connect(m_showConsoleAction, &QAction::toggled, this, [this](bool on) {
        if (on) {
            if (m_consoleHidden)
                dockConsole();
        } else if (!m_consoleHidden) {
            hideConsole();
        }
    });
    m_lineNumbersAction = viewMenu->addAction(QStringLiteral("Show &Line Numbers"));
    m_lineNumbersAction->setCheckable(true);
    m_lineNumbersAction->setChecked(settings.value(QStringLiteral("showLineNumbers"), true).toBool());
    connect(m_lineNumbersAction, &QAction::toggled, this, [this](bool on) {
        QSettings().setValue(QStringLiteral("showLineNumbers"), on);
        applyLineNumbers();
    });
    m_askAction = viewMenu->addAction(QStringLiteral("Ask Forth"));
    m_askAction->setCheckable(true);
    m_askAction->setShortcut(QKeySequence(Qt::CTRL | Qt::ALT | Qt::Key_A));
    connect(m_askAction, &QAction::toggled, this, &MainWindow::showAskPanel);
    m_askToggle = new QPushButton(QStringLiteral("Show"), menuBar());
    m_askToggle->setFlat(true);
    m_askToggle->setFocusPolicy(Qt::NoFocus);
    m_askToggle->setToolTip(QStringLiteral("Show or hide Ask Forth (Ctrl+Alt+A)"));
    m_askToggle->setFixedHeight(menuBar()->fontMetrics().height() + 8);
    menuBar()->setCornerWidget(m_askToggle, Qt::TopRightCorner);
    connect(m_askToggle, &QPushButton::clicked, this, [this] {
        if (m_askAction != nullptr)
            m_askAction->setChecked(!m_askAction->isChecked());
    });
    m_askAction->setChecked(settings.value(QStringLiteral("showAIAssistant"), false).toBool());
    viewMenu->addAction(QStringLiteral("Open Web Page"), this, &MainWindow::openWebPage);
    m_splitAction = viewMenu->addAction(QStringLiteral("Split Editor"), this, &MainWindow::toggleSplit);
    auto *wrapMenu = viewMenu->addMenu(QStringLiteral("Wrap at Column"));
    auto *wrapGroup = new QActionGroup(this);
    wrapGroup->setExclusive(true);
    const auto addWrap = [&](const QString &text, QAction **slot) {
        *slot = wrapMenu->addAction(text);
        (*slot)->setCheckable(true);
        wrapGroup->addAction(*slot);
    };
    addWrap(QStringLiteral("Off"), &m_wrapOff);
    addWrap(QStringLiteral("Window"), &m_wrapWindow);
    addWrap(QStringLiteral("60"), &m_wrap60);
    addWrap(QStringLiteral("80"), &m_wrap80);
    addWrap(QStringLiteral("100"), &m_wrap100);
    addWrap(QStringLiteral("Other..."), &m_wrapOther);
    connect(m_wrapOff, &QAction::triggered, this, [this] { setWrapMode(QStringLiteral("off"), m_wrapColumn); });
    connect(m_wrapWindow, &QAction::triggered, this, [this] {
        setWrapMode(QStringLiteral("window"), m_wrapColumn);
    });
    connect(m_wrap60, &QAction::triggered, this, [this] { setWrapMode(QStringLiteral("column"), 60); });
    connect(m_wrap80, &QAction::triggered, this, [this] { setWrapMode(QStringLiteral("column"), 80); });
    connect(m_wrap100, &QAction::triggered, this, [this] { setWrapMode(QStringLiteral("column"), 100); });
    connect(m_wrapOther, &QAction::triggered, this, [this] {
        bool ok = false;
        const int columns = QInputDialog::getInt(this, QStringLiteral("Wrap at Column"),
                                                  QStringLiteral("Columns"), m_wrapColumn, 40, 300, 1, &ok);
        if (ok)
            setWrapMode(QStringLiteral("column"), columns);
        else
            syncWrapChecks();
    });
    syncWrapChecks();
    m_dockAction = viewMenu->addAction(QStringLiteral("Undock Forth Console"));
    connect(m_dockAction, &QAction::triggered, this, &MainWindow::toggleConsolePlace);

    auto *formatMenu = menuBar()->addMenu(QStringLiteral("F&ormat"));
    auto *bigger = formatMenu->addAction(QStringLiteral("&Bigger"), this, [this] {
        setPointSize(m_pointSize + 1);
    });
    bigger->setShortcuts({QKeySequence::ZoomIn, QKeySequence(Qt::CTRL | Qt::Key_Plus),
                          QKeySequence(Qt::CTRL | Qt::Key_Equal)});
    auto *smaller = formatMenu->addAction(QStringLiteral("&Smaller"), this, [this] {
        setPointSize(m_pointSize - 1);
    });
    smaller->setShortcuts({QKeySequence::ZoomOut, QKeySequence(Qt::CTRL | Qt::Key_Minus)});
    formatMenu->addAction(QStringLiteral("&Reset Size"), this, [this] { setPointSize(13); });

    auto *debugMenu = menuBar()->addMenu(QStringLiteral("&Debug"));
    m_actBreak = debugMenu->addAction(QStringLiteral("Toggle &Breakpoint"),
                                      QKeySequence(Qt::CTRL | Qt::Key_Backslash), this,
                                      &MainWindow::toggleCaretBreak);
    m_actPause = debugMenu->addAction(QStringLiteral("Break &Now"),
                                      QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_Y), this,
                                      &MainWindow::pauseNow);

    auto *forthMenu = menuBar()->addMenu(QStringLiteral("F&orth"));
    m_actInclude = forthMenu->addAction(QStringLiteral("&INCLUDE Current File"),
                                        QKeySequence(Qt::Key_F4), this, &MainWindow::includeCurrent);
    m_actRun = forthMenu->addAction(QStringLiteral("&RUN LAST"), QKeySequence(Qt::Key_F5), this, [this] {
        if (m_paused)
            sendStep(103);
        else
            prepareRun(RunKind::Execute);
    });
    m_actDebug = forthMenu->addAction(QStringLiteral("&DEBUG LAST"),
                                      QKeySequence(Qt::CTRL | Qt::Key_F5), this, [this] {
                                          prepareRun(RunKind::Debug);
                                      });
    m_actBpgo = forthMenu->addAction(QStringLiteral("&BPGO LAST"),
                                     QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_F5), this, [this] {
                                         prepareRun(RunKind::Bpgo);
                                     });
    auto *emitItem = forthMenu->addAction(QStringLiteral("EMIT Current (later pass)"));
    emitItem->setEnabled(false);
    emitItem->setStatusTip(QStringLiteral("The stand-alone emitter is a later pass."));
    forthMenu->addSeparator();
    forthMenu->addAction(QStringLiteral("&FLOAD..."), QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_L),
                         this, &MainWindow::floadDialog);
    forthMenu->addAction(QStringLiteral("&CHDIR..."), this, &MainWindow::chdirDialog);
    forthMenu->addAction(QStringLiteral("Open &File..."), this, [this] {
        const QString path = QFileDialog::getOpenFileName(
            this, QStringLiteral("Open"), m_forthDir, kSourceFilter);
        if (!path.isEmpty())
            openFile(path);
    });
    forthMenu->addAction(QStringLiteral("C&LS"), this, [this] { m_console->clearDisplay(); });
    forthMenu->addSeparator();
    forthMenu->addAction(QStringLiteral("&Update User Data"), this, [this] {
        if (!m_connected) {
            m_debug->setError(QStringLiteral("Forth is not connected"));
            return;
        }
        m_pipe->requestTree(QString());
    });
    forthMenu->addAction(QStringLiteral("&Restore Shipped Files..."), this, &MainWindow::restoreShipped);
    forthMenu->addSeparator();
    forthMenu->addAction(QStringLiteral("Show &Library"), this, [this] { showUserFolder(QStringLiteral("Library")); });
    forthMenu->addAction(QStringLiteral("Show &AutoLoad"), this, [this] { showUserFolder(QStringLiteral("AutoLoad")); });
    forthMenu->addAction(QStringLiteral("Show &Docs"), this, [this] { showUserFolder(QStringLiteral("Docs")); });
    forthMenu->addAction(QStringLiteral("Show &Config"), this, [this] { showUserFolder(QStringLiteral("Config")); });

    auto *helpMenu = menuBar()->addMenu(QStringLiteral("&Help"));
    helpMenu->addAction(QStringLiteral("EditForthWin Startup &Messages"), this,
                        &MainWindow::showStartupMessages);
    helpMenu->addAction(QStringLiteral("&About EditForthWin"), this, &MainWindow::showAbout);

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
    m_keyStop = windowKey(QKeySequence(Qt::Key_Escape));
    m_keyBreak = windowKey(QKeySequence(Qt::Key_F9));
    connect(m_keyOver, &QShortcut::activated, this, [this] { sendStep(32); });
    connect(m_keyInto, &QShortcut::activated, this, [this] { sendStep(105); });
    connect(m_keyOut, &QShortcut::activated, this, [this] { sendStep(33554450); });
    connect(m_keyStop, &QShortcut::activated, this, [this] { sendStep(113); });
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

void MainWindow::openRequestedFile(const QString &text, int line) {
    QString start = text;
    const bool dialog = start.isEmpty() || start.endsWith(QLatin1Char('\\')) ||
                        start.endsWith(QLatin1Char('/'));
    if (!dialog) {
        openFile(start);
        if (line > 0) {
            if (CodeEdit *edit = currentEdit())
                edit->gotoLine(line);
        }
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
    applyEditorChrome(edit);
    addEditor(edit, title);
}

void MainWindow::openFile(const QString &path) {
    const QString canonical = QFileInfo(path).absoluteFilePath();
    for (int i = 0; i < m_tabs->count(); ++i) {
        CodeEdit *existing = editAt(i);
        if (existing == nullptr)
            continue;
        if (existing->property(kPath).toString().compare(canonical, Qt::CaseInsensitive) == 0) {
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
    applyEditorChrome(edit);
    edit->setBrowse(browseSaved(canonical));
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
    if (!m_consoleName.isEmpty())
        m_float->setWindowTitle(m_consoleName);
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
    if (m_showConsoleAction != nullptr) {
        const QSignalBlocker block(m_showConsoleAction);
        m_showConsoleAction->setChecked(!m_consoleHidden);
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
    QWidget *page = m_tabs->widget(index);
    if (auto *pane = qobject_cast<EditorPane *>(page))
        return pane->edit();
    return qobject_cast<CodeEdit *>(page);
}

void MainWindow::addEditor(CodeEdit *edit, const QString &title) {
    wire(edit);
    auto *pane = new EditorPane(edit);
    pane->setDebugState(m_armed, m_paused);
    edit->setDebugFocusLock(m_armed && edit->browse());
    const int index = m_tabs->addTab(pane, title);
    m_tabs->setCurrentIndex(index);
    if (m_armed)
        focusConsole();
    else
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
    connect(edit, &CodeEdit::viewWordRequested, this, &MainWindow::viewWord);
    connect(edit, &CodeEdit::breakWordRequested, this, &MainWindow::breakWord);
    connect(edit, &CodeEdit::runToRequested, this, &MainWindow::runToHere);
    connect(edit, &CodeEdit::browseChanged, this, [this, edit](bool on) { noteBrowse(edit, on); });
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
    int index = -1;
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (editAt(i) == edit) {
            index = i;
            break;
        }
    }
    if (index >= 0)
        m_tabs->setTabText(index, tabLabel(edit));
    if (edit == currentEdit())
        refreshStatus();
    refreshSplitList();
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
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (CodeEdit *edit = editAt(i))
            edit->setLineNumbersVisible(on);
    }
    if (m_splitEdit != nullptr)
        m_splitEdit->setLineNumbersVisible(on);
}

void MainWindow::closeTab(int index) {
    QWidget *widget = m_tabs->widget(index);
    if (widget == nullptr)
        return;
    CodeEdit *edit = editAt(index);
    if (edit != nullptr) {
        if (!maybeSave(edit))
            return;
        if (edit == m_splitSource)
            detachSplit();
    }
    m_tabs->removeTab(index);
    widget->deleteLater();
    if (m_tabs->count() == 0)
        newFile();
    refreshSplitList();
    syncTabChrome();
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
    refreshViewBanners();
    clearHits();
    if (!m_paused) {
        m_debug->setNote(QString());
        if (m_armed)
            focusConsole();
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
    refreshViewBanners();
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

QString MainWindow::consumeStartup(const QString &text) {
    if (!m_captureStartup)
        return text;
    m_startupPartial += text;
    QString visible;
    while (true) {
        const int nl = m_startupPartial.indexOf(QLatin1Char('\n'));
        if (nl < 0)
            break;
        QString line = m_startupPartial.left(nl);
        m_startupPartial.remove(0, nl + 1);
        if (line.endsWith(QLatin1Char('\r')))
            line.chop(1);
        const bool cold = line.startsWith(QLatin1String("Loading: ")) ||
                          line.startsWith(QLatin1String("Finished Loading: "));
        if (cold) {
            if (!m_startupLog.isEmpty())
                m_startupLog += QLatin1Char('\n');
            m_startupLog += line;
            continue;
        }
        visible += line;
        visible += QLatin1Char('\n');
        if (line.startsWith(QLatin1String("=== EditForthWin "))) {
            m_captureStartup = false;
            visible += m_startupPartial;
            m_startupPartial.clear();
            break;
        }
    }
    return visible;
}

void MainWindow::showStartupMessages() {
    auto *dlg = new QDialog(this);
    dlg->setAttribute(Qt::WA_DeleteOnClose);
    dlg->setWindowTitle(QStringLiteral("EditForthWin Startup Messages"));
    dlg->resize(640, 320);
    auto *text = new QPlainTextEdit(dlg);
    text->setReadOnly(true);
    text->setLineWrapMode(QPlainTextEdit::NoWrap);
    text->setFont(m_console->font());
    text->setPlainText(m_startupLog.isEmpty()
                           ? QStringLiteral("No startup messages were captured.")
                           : m_startupLog);
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Close, dlg);
    connect(buttons, &QDialogButtonBox::rejected, dlg, &QDialog::close);
    auto *layout = new QVBoxLayout(dlg);
    layout->addWidget(text);
    layout->addWidget(buttons);
    dlg->open();
}

void MainWindow::showAbout() {
    QString body = QStringLiteral("EditForthWin");
    if (m_engineVersion.isEmpty()) {
        body += QStringLiteral("\n\nThe Forth engine has not reported its version yet.");
    } else {
        body += QStringLiteral("\n\nEngine %1").arg(m_engineVersion);
        if (!m_engineBuilt.isEmpty())
            body += QStringLiteral("\n%1").arg(m_engineBuilt);
    }
    QMessageBox::about(this, QStringLiteral("About EditForthWin"), body);
}

void MainWindow::updateDebugKeys() {
    const bool step = m_paused;
    const bool idle = m_connected && !m_armed;
    m_keyOver->setEnabled(step);
    m_keyInto->setEnabled(step);
    m_keyOut->setEnabled(step);
    m_keyStop->setEnabled(step);
    m_keyBreak->setEnabled(m_connected);
    if (m_actRun != nullptr)
        m_actRun->setEnabled(m_connected);
    if (m_actPause != nullptr)
        m_actPause->setEnabled(m_connected);
    if (m_actBreak != nullptr)
        m_actBreak->setEnabled(m_connected);
    if (m_actInclude != nullptr)
        m_actInclude->setEnabled(idle);
    if (m_actDebug != nullptr)
        m_actDebug->setEnabled(idle);
    if (m_actBpgo != nullptr)
        m_actBpgo->setEnabled(idle);
}

void MainWindow::clearHits() {
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (CodeEdit *edit = editAt(i))
            edit->clearDebugHit();
    }
    if (m_splitEdit != nullptr)
        m_splitEdit->clearDebugHit();
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
    // Forth counts file bytes. The editor buffer has LF only, so a CRLF
    // source (hyper.fth) must drop one byte per CR before this offset.
    int spanOff = off;
    const bool useSpan = !dirty && off >= 0 && len > 0;
    if (useSpan && off > 0 && !edit->toPlainText().toUtf8().contains('\r')) {
        QFile file(resolved);
        if (file.open(QIODevice::ReadOnly)) {
            const QByteArray prefix = file.read(static_cast<qint64>(off));
            if (prefix.size() == off)
                spanOff = off - prefix.count('\r');
        }
    }
    // A file opened from the debugger is read-only until its own Edit button.
    // The caret stays in the Forth console so a key cannot change this file.
    edit->setBrowse(true);
    edit->showDebugHit(line, spanOff, len, name, useSpan);
    if (m_splitSource == edit && m_splitEdit != nullptr)
        m_splitEdit->showDebugHit(line, spanOff, len, name, useSpan);
    focusConsole();
}

bool forthIdle(DebugBar *debug, bool connected, bool armed) {
    if (!connected) {
        debug->setError(QStringLiteral("Forth is not connected"));
        return false;
    }
    if (armed) {
        debug->setError(QStringLiteral("debugger paused - use Step, Continue, or Stop"));
        return false;
    }
    return true;
}

bool pathAccepts(const QString &path) {
    return path.size() <= 255 && !path.contains(QLatin1Char('"'));
}

void MainWindow::includeCurrent() {
    if (!forthIdle(m_debug, m_connected, m_armed))
        return;
    CodeEdit *edit = currentEdit();
    if (edit == nullptr) {
        m_debug->setError(QStringLiteral("INCLUDE needs a source tab."));
        return;
    }
    if (edit->document()->isModified() && !saveEdit(edit))
        return;
    const QString path = edit->property(kPath).toString();
    if (path.isEmpty()) {
        m_debug->setError(QStringLiteral("Save the file before INCLUDE."));
        return;
    }
    if (!pathAccepts(path)) {
        m_debug->setError(QStringLiteral("That path cannot be INCLUDEd."));
        return;
    }
    m_debug->setError(QString());
    m_pipe->eval(QStringLiteral("ANEW %1 %2").arg(moduleMarker(path), includedLine(path)));
}

void MainWindow::prepareRun(RunKind kind) {
    if (!forthIdle(m_debug, m_connected, m_armed))
        return;
    m_pendingRun = kind;
    const QString word = caretWord();
    if (!word.isEmpty()) {
        fillRun(word);
        return;
    }
    m_waitingLast = true;
    m_pipe->requestLast();
}

void MainWindow::fillRun(const QString &name) {
    QString line = name;
    if (m_pendingRun == RunKind::Debug)
        line = QStringLiteral("DEBUG %1").arg(name);
    else if (m_pendingRun == RunKind::Bpgo)
        line = QStringLiteral("BPGO %1").arg(name);
    if (m_consoleHidden)
        dockConsole();
    else if (!m_docked && m_float != nullptr)
        m_float->show();
    m_debug->setError(QString());
    m_console->fillInput(line);
}

void MainWindow::onLastName(const QString &name) {
    if (!m_waitingLast)
        return;
    m_waitingLast = false;
    const QString word = name.trimmed();
    if (word.isEmpty()) {
        m_debug->setError(QStringLiteral("LAST has no name"));
        return;
    }
    fillRun(word);
}

void MainWindow::viewWord(const QString &word) {
    const QString name = word.trimmed();
    if (name.isEmpty() || name.contains(QLatin1Char(' ')) || name.contains(QLatin1Char('"'))) {
        m_debug->setError(QStringLiteral("VIEW needs a single token"));
        return;
    }
    if (!m_connected) {
        m_debug->setError(QStringLiteral("Forth is not connected"));
        return;
    }
    m_debug->setError(QString());
    m_pipe->requestView(name);
}

void MainWindow::breakWord(const QString &word) {
    if (!m_connected) {
        m_debug->setError(QStringLiteral("Forth is not connected"));
        return;
    }
    if (word.isEmpty() || word.contains(QLatin1Char('"'))) {
        m_debug->setError(QStringLiteral("Break needs a word at the caret."));
        return;
    }
    m_debug->setError(QString());
    m_pipe->toggleBreak(word);
}

void MainWindow::runToHere(int utf8Offset) {
    if (!m_paused) {
        m_debug->setError(QStringLiteral("Run to Here needs a pause"));
        return;
    }
    m_debug->setError(QString());
    m_pipe->requestRunTo(utf8Offset);
}

void MainWindow::showFind(bool replace) {
    CodeEdit *edit = currentEdit();
    if (edit == nullptr) {
        statusBar()->showMessage(QStringLiteral("Find needs a source tab."));
        return;
    }
    m_find->attach(edit);
    if (replace)
        m_find->showReplace();
    else
        m_find->showFind();
}

void MainWindow::revealLine(const QString &path, int line, int column) {
    openFile(path);
    CodeEdit *edit = currentEdit();
    if (edit == nullptr)
        return;
    const QString canonical = QFileInfo(path).absoluteFilePath();
    if (edit->property(kPath).toString().compare(canonical, Qt::CaseInsensitive) != 0)
        return;
    if (line > 0)
        edit->gotoLine(line, column > 0 ? column : 1);
}

void MainWindow::searchInFolders() {
    SearchRequest request;
    QString start = m_forthDir;
    if (CodeEdit *edit = currentEdit()) {
        const QString path = edit->property(kPath).toString();
        if (!path.isEmpty())
            start = QFileInfo(path).absolutePath();
    }
    if (!runFolderSearchDialog(this, start, &request))
        return;
    QApplication::setOverrideCursor(Qt::WaitCursor);
    const SearchOutcome outcome = searchFolders(request);
    QApplication::restoreOverrideCursor();
    QString summary = QStringLiteral("%1 hit%2 in %3 file%4")
                          .arg(outcome.hits.size())
                          .arg(outcome.hits.size() == 1 ? QString() : QStringLiteral("s"))
                          .arg(outcome.filesScanned)
                          .arg(outcome.filesScanned == 1 ? QString() : QStringLiteral("s"));
    if (outcome.truncated)
        summary += QStringLiteral(" (stopped at 5000)");
    auto *results = new SearchResults(summary, outcome.hits);
    connect(results, &SearchResults::openHit, this, [this](const QString &path, int line, int column) {
        revealLine(path, line, column);
    });
    const int index = m_tabs->addTab(results, QStringLiteral("Search"));
    m_tabs->setCurrentIndex(index);
    syncTabChrome();
}

void MainWindow::compareWithDisk() {
    CodeEdit *edit = currentEdit();
    if (edit == nullptr)
        return;
    const QString path = edit->property(kPath).toString();
    if (path.isEmpty())
        return;
    auto *view = new DiskDiffView(path, edit->toPlainText());
    connect(view, &DiskDiffView::openLine, this, [this](const QString &file, int line) {
        revealLine(file, line, 1);
    });
    const int index = m_tabs->addTab(view, QStringLiteral("Compare: %1").arg(QFileInfo(path).fileName()));
    m_tabs->setCurrentIndex(index);
    syncTabChrome();
}

void MainWindow::showEvent(QShowEvent *event) {
    QMainWindow::showEvent(event);
    if (m_askPanel != nullptr && m_askPanel->isVisible()) {
        const QList<int> sizes = m_editors->sizes();
        if (sizes.size() == 3 && sizes.first() < 200)
            showAskPanel(true);
    }
}

void MainWindow::showAskPanel(bool on) {
    if (m_askPanel == nullptr)
        return;
    m_askPanel->setVisible(on);
    if (m_askToggle != nullptr)
        m_askToggle->setText(on ? QStringLiteral("Hide") : QStringLiteral("Show"));
    QSettings().setValue(QStringLiteral("showAIAssistant"), on);
    if (!on)
        return;
    m_askPanel->prepareEnvironment();
    QList<int> sizes = m_editors->sizes();
    if (sizes.size() < 3)
        return;
    const int total = qMax(m_editors->width(), sizes[0] + sizes[1] + sizes[2]);
    if (total < 640)
        return;
    const int ask = 360;
    const int mid = m_right != nullptr && m_right->isVisible() ? qBound(160, sizes[1], total / 2) : 0;
    const int left = total - mid - ask;
    if (left < 240)
        return;
    m_editors->setSizes({left, mid, ask});
}

void MainWindow::openWebPage() {
    auto *tab = new WebTab;
    connect(tab, &WebTab::sendToAskForth, this, [this](const QString &url) {
        if (m_askAction != nullptr)
            m_askAction->setChecked(true);
        if (m_askPanel != nullptr)
            m_askPanel->appendPageUrl(url);
    });
    const int index = m_tabs->addTab(tab, QStringLiteral("Web"));
    m_tabs->setCurrentIndex(index);
    syncTabChrome();
}

void MainWindow::floadDialog() {
    if (!forthIdle(m_debug, m_connected, m_armed))
        return;
    const QString path = QFileDialog::getOpenFileName(
        this, QStringLiteral("FLOAD"), m_forthDir, kSourceFilter);
    if (path.isEmpty())
        return;
    if (!pathAccepts(path)) {
        QMessageBox::warning(this, QStringLiteral("EditForthWin"),
                             QStringLiteral("That path cannot be FLOADed."));
        return;
    }
    m_pipe->eval(includedLine(path));
}

void MainWindow::chdirDialog() {
    if (!forthIdle(m_debug, m_connected, m_armed))
        return;
    const QString path = QFileDialog::getExistingDirectory(this, QStringLiteral("CHDIR"), m_forthDir);
    if (path.isEmpty())
        return;
    if (!pathAccepts(path)) {
        QMessageBox::warning(this, QStringLiteral("EditForthWin"),
                             QStringLiteral("That path cannot be used with CHDIR."));
        return;
    }
    m_pipe->eval(QStringLiteral("CHDIR \"%1\"").arg(path));
}

void MainWindow::restoreShipped() {
    if (!forthIdle(m_debug, m_connected, m_armed))
        return;
    QMessageBox box(this);
    box.setWindowTitle(QStringLiteral("EditForthWin"));
    box.setText(QStringLiteral("Restore the shipped Library, AutoLoad, and Docs?"));
    box.setInformativeText(QStringLiteral(
        "Rename keeps your current Documents\\EditForthWin folder under a new name. "
        "Replace overwrites Library, AutoLoad, and Docs. Config is left as it is."));
    auto *rename = box.addButton(QStringLiteral("Rename EditForthWin"), QMessageBox::AcceptRole);
    auto *replace = box.addButton(QStringLiteral("Replace EditForthWin"), QMessageBox::DestructiveRole);
    box.addButton(QMessageBox::Cancel);
    box.exec();
    if (box.clickedButton() == rename) {
        m_pipe->requestTree(QStringLiteral("rename"));
        return;
    }
    if (box.clickedButton() != replace)
        return;
    const auto sure = QMessageBox::warning(
        this, QStringLiteral("EditForthWin"),
        QStringLiteral("Replace Library, AutoLoad, and Docs with the shipped copies?"),
        QMessageBox::Yes | QMessageBox::No, QMessageBox::No);
    if (sure == QMessageBox::Yes)
        m_pipe->requestTree(QStringLiteral("replace"));
}

void MainWindow::showUserFolder(const QString &child) {
    const QString path = QDir(userFolder()).filePath(child);
    QDesktopServices::openUrl(QUrl::fromLocalFile(path));
}

void MainWindow::toggleBrowse(bool on) {
    CodeEdit *edit = currentEdit();
    if (edit == nullptr)
        return;
    edit->setBrowse(on);
}

void MainWindow::noteBrowse(CodeEdit *edit, bool on) {
    if (edit == nullptr)
        return;
    edit->setDebugFocusLock(m_armed && on);
    if (edit == m_splitEdit) {
        if (m_splitSource != nullptr && m_splitSource->browse() != on)
            m_splitSource->setBrowse(on);
        return;
    }
    const QString path = edit->property(kPath).toString();
    if (!path.isEmpty())
        storeBrowse(path, on);
    if (m_splitSource == edit && m_splitEdit != nullptr && m_splitEdit->browse() != on)
        m_splitEdit->setBrowse(on);
    if (edit == currentEdit())
        syncTabChrome();
}

void MainWindow::refreshViewBanners() {
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (CodeEdit *edit = editAt(i))
            edit->setDebugFocusLock(m_armed && edit->browse());
        if (auto *pane = qobject_cast<EditorPane *>(m_tabs->widget(i)))
            pane->setDebugState(m_armed, m_paused);
    }
    if (m_splitEdit != nullptr) {
        m_splitEdit->setDebugFocusLock(m_armed && m_splitEdit->browse());
        if (auto *pane = qobject_cast<EditorPane *>(m_splitEdit->parentWidget()))
            pane->setDebugState(m_armed, m_paused);
    }
}

void MainWindow::focusConsole() {
    if (m_console == nullptr || m_consoleHidden)
        return;
    if (!m_docked && m_float != nullptr && !m_float->isVisible())
        return;
    m_console->setFocus();
}

void MainWindow::setPointSize(int points) {
    m_pointSize = qBound(9, points, 32);
    QSettings().setValue(QStringLiteral("editorPointSize"), m_pointSize);
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (CodeEdit *edit = editAt(i))
            edit->setPointSize(m_pointSize);
    }
    if (m_splitEdit != nullptr)
        m_splitEdit->setPointSize(m_pointSize);
    if (m_console != nullptr)
        m_console->setPointSize(m_pointSize);
}

void MainWindow::setWrapMode(const QString &mode, int column) {
    m_wrapMode = mode;
    m_wrapColumn = qBound(40, column, 300);
    QSettings settings;
    settings.setValue(QStringLiteral("wrapMode"), m_wrapMode);
    settings.setValue(QStringLiteral("wrapColumn"), m_wrapColumn);
    for (int i = 0; i < m_tabs->count(); ++i) {
        if (CodeEdit *edit = editAt(i))
            edit->setWrap(m_wrapMode, m_wrapColumn);
    }
    if (m_splitEdit != nullptr)
        m_splitEdit->setWrap(m_wrapMode, m_wrapColumn);
    syncWrapChecks();
}

void MainWindow::syncWrapChecks() {
    if (m_wrapOff == nullptr)
        return;
    const QSignalBlocker off(m_wrapOff);
    const QSignalBlocker window(m_wrapWindow);
    const QSignalBlocker c60(m_wrap60);
    const QSignalBlocker c80(m_wrap80);
    const QSignalBlocker c100(m_wrap100);
    const QSignalBlocker other(m_wrapOther);
    const bool column = m_wrapMode == QLatin1String("column");
    m_wrapOff->setChecked(m_wrapMode == QLatin1String("off"));
    m_wrapWindow->setChecked(m_wrapMode == QLatin1String("window"));
    m_wrap60->setChecked(column && m_wrapColumn == 60);
    m_wrap80->setChecked(column && m_wrapColumn == 80);
    m_wrap100->setChecked(column && m_wrapColumn == 100);
    m_wrapOther->setChecked(column && m_wrapColumn != 60 && m_wrapColumn != 80 && m_wrapColumn != 100);
}

void MainWindow::toggleSplit() {
    if (m_right != nullptr && m_right->isVisible()) {
        detachSplit();
        return;
    }
    CodeEdit *edit = currentEdit();
    if (edit == nullptr) {
        statusBar()->showMessage(QStringLiteral("Split needs a source tab."));
        return;
    }
    attachSplit(edit);
}

void MainWindow::attachSplit(CodeEdit *source) {
    if (source == nullptr || m_splitEdit == nullptr)
        return;
    if (m_splitEdit->document() != source->document())
        m_splitEdit->setDocument(source->document());
    m_splitSource = source;
    m_splitEdit->setBrowse(source->browse());
    applyEditorChrome(m_splitEdit);
    m_right->show();
    if (m_splitAction != nullptr)
        m_splitAction->setText(QStringLiteral("Close Split"));
    refreshSplitList();
}

void MainWindow::detachSplit() {
    if (m_splitEdit == nullptr)
        return;
    if (m_splitEdit->document() == nullptr || m_splitEdit->document()->parent() != m_splitEdit) {
        auto *fresh = new QTextDocument(m_splitEdit);
        m_splitEdit->setDocument(fresh);
    }
    m_splitSource = nullptr;
    if (m_right != nullptr)
        m_right->hide();
    if (m_splitAction != nullptr)
        m_splitAction->setText(QStringLiteral("Split Editor"));
}

void MainWindow::refreshSplitList() {
    if (m_splitPick == nullptr)
        return;
    const QSignalBlocker block(m_splitPick);
    m_splitPick->clear();
    int select = -1;
    for (int i = 0; i < m_tabs->count(); ++i) {
        CodeEdit *edit = editAt(i);
        if (edit == nullptr)
            continue;
        m_splitPick->addItem(m_tabs->tabText(i), QVariant::fromValue(static_cast<qulonglong>(
                                                     reinterpret_cast<quintptr>(edit))));
        if (edit == m_splitSource)
            select = m_splitPick->count() - 1;
    }
    if (select >= 0)
        m_splitPick->setCurrentIndex(select);
}

void MainWindow::syncTabChrome() {
    CodeEdit *edit = currentEdit();
    if (m_compareAction != nullptr)
        m_compareAction->setEnabled(edit != nullptr && !edit->property(kPath).toString().isEmpty());
    if (m_browseAction != nullptr) {
        const QSignalBlocker block(m_browseAction);
        const bool on = edit != nullptr && edit->browse();
        m_browseAction->setEnabled(edit != nullptr);
        m_browseAction->setChecked(on);
        m_browseAction->setText(on ? QStringLiteral("Allow Editing") : QStringLiteral("Browse Mode"));
    }
    if (edit != nullptr && m_find != nullptr)
        m_find->attach(edit);
}

void MainWindow::applyEditorChrome(CodeEdit *edit) {
    if (edit == nullptr)
        return;
    edit->setPointSize(m_pointSize);
    edit->setWrap(m_wrapMode, m_wrapColumn);
    const bool numbers = m_lineNumbersAction == nullptr || m_lineNumbersAction->isChecked();
    edit->setLineNumbersVisible(numbers);
}
