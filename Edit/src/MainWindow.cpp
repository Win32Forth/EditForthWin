#include "MainWindow.h"

#include "CodeEdit.h"

#include <QAction>
#include <QCloseEvent>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QMenuBar>
#include <QMessageBox>
#include <QSettings>
#include <QStatusBar>
#include <QTabWidget>
#include <QTextCursor>
#include <QTextDocument>

namespace {
const char kPath[] = "path";

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
    setCentralWidget(m_tabs);
    connect(m_tabs, &QTabWidget::tabCloseRequested, this, &MainWindow::closeTab);
    connect(m_tabs, &QTabWidget::currentChanged, this, [this](int) { refreshStatus(); });

    auto *fileMenu = menuBar()->addMenu(QStringLiteral("&File"));
    fileMenu->addAction(QStringLiteral("&New"), QKeySequence::New, this, &MainWindow::newFile);
    fileMenu->addAction(QStringLiteral("&Open..."), QKeySequence::Open, this, [this] {
        const QString path = QFileDialog::getOpenFileName(
            this, QStringLiteral("Open"), QString(),
            QStringLiteral("Forth files (*.fth *.FTH *.fs *.4th);;All files (*.*)"));
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
