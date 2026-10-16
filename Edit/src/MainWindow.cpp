#include "MainWindow.h"

#include "CodeEdit.h"
#include "ForthConsole.h"
#include "ForthPipe.h"

#include <QAction>
#include <QCloseEvent>
#include <QDir>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QMenuBar>
#include <QMessageBox>
#include <QSettings>
#include <QSplitter>
#include <QStandardPaths>
#include <QStatusBar>
#include <QTabWidget>
#include <QTextCursor>
#include <QTextDocument>

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

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent) {
    setWindowTitle(QStringLiteral("EditForthWin"));
    setMinimumSize(640, 420);

    m_tabs = new QTabWidget(this);
    m_tabs->setDocumentMode(true);
    m_tabs->setTabsClosable(true);
    m_tabs->setMovable(true);

    m_console = new ForthConsole(this);
    m_pipe = new ForthPipe(this);
    connect(m_console, &ForthConsole::submitted, this, [this](const QString &line) {
        if (isBye(line)) {
            close();
            if (isVisible())
                m_console->retractSubmit();
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
    });
    connect(m_pipe, &ForthPipe::outputReceived, m_console, [this](const QString &text) {
        m_console->setEngineAlive(true);
        m_console->appendOutput(text);
    });
    connect(m_pipe, &ForthPipe::engineStopped, m_console, [this] {
        m_console->setEngineAlive(false);
        m_console->appendOutput(QStringLiteral("\nForth stopped.\n"));
    });
    connect(m_pipe, &ForthPipe::engineFailed, m_console, [this](const QString &message) {
        m_console->setEngineAlive(false);
        m_console->appendOutput(message + QLatin1Char('\n'));
    });

    auto *split = new QSplitter(Qt::Vertical, this);
    split->addWidget(m_tabs);
    split->addWidget(m_console);
    split->setStretchFactor(0, 3);
    split->setStretchFactor(1, 1);
    split->setSizes({520, 160});
    m_console->setMinimumHeight(80);
    setCentralWidget(split);
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

    statusBar();

    const QByteArray geo = settings.value(QStringLiteral("geometry")).toByteArray();
    if (!geo.isEmpty())
        restoreGeometry(geo);
    m_pipe->start();
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
    if (m_pipe != nullptr)
        m_pipe->shutdown();
    QSettings().setValue(QStringLiteral("geometry"), saveGeometry());
    event->accept();
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
