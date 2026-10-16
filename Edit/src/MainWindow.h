#pragma once

#include <QList>
#include <QMainWindow>
#include <QString>

class CodeEdit;
class DebugBar;
class ForthConsole;
class ForthFloat;
class ForthPipe;
class QShortcut;
class QSplitter;
class QTabWidget;
class QVBoxLayout;

// One workspace window: a tab per Forth source, line numbers, open and save.
class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = nullptr);

    void newFile();
    void openFile(const QString &path);
    int tabCount() const;

protected:
    void closeEvent(QCloseEvent *event) override;
    bool eventFilter(QObject *watched, QEvent *event) override;

private:
    CodeEdit *currentEdit() const;
    CodeEdit *editAt(int index) const;
    void addEditor(CodeEdit *edit, const QString &title);
    void wire(CodeEdit *edit);
    bool saveEdit(CodeEdit *edit);
    bool saveEditAs(CodeEdit *edit);
    bool maybeSave(CodeEdit *edit);
    void refreshTitle(CodeEdit *edit);
    void refreshStatus();
    void applyLineNumbers();
    void closeTab(int index);
    void presentSourceDialog(bool loadIntoForth);
    void openRequestedFile(const QString &text);
    void onDebug(bool armed, bool paused, int line, int off, int len, const QString &name,
                 const QString &path);
    void sendStep(int key);
    void armDebug();
    void pauseNow();
    void toggleCaretBreak();
    void updateDebugKeys();
    void clearHits();
    QString caretWord() const;
    QString resolveDebugPath(const QString &path) const;
    void showHit(int line, int off, int len, const QString &name, const QString &path);
    void toggleConsolePlace();
    void dockConsole();
    void undockConsole();
    void hideConsole();
    void ensureFloat();
    void syncConsoleChrome();
    void showAbout();

    QTabWidget *m_tabs = nullptr;
    QSplitter *m_split = nullptr;
    QWidget *m_bottom = nullptr;
    QVBoxLayout *m_bottomLayout = nullptr;
    DebugBar *m_debug = nullptr;
    ForthConsole *m_console = nullptr;
    ForthFloat *m_float = nullptr;
    ForthPipe *m_pipe = nullptr;
    QString m_forthDir;
    QAction *m_lineNumbersAction = nullptr;
    QShortcut *m_keyOver = nullptr;
    QShortcut *m_keyInto = nullptr;
    QShortcut *m_keyOut = nullptr;
    QShortcut *m_keyGo = nullptr;
    QShortcut *m_keyStop = nullptr;
    QShortcut *m_keyPause = nullptr;
    QShortcut *m_keyBreak = nullptr;
    QAction *m_dockAction = nullptr;
    QList<int> m_dockedSplit;
    bool m_docked = true;
    bool m_consoleHidden = false;
    bool m_connected = false;
    bool m_armed = false;
    bool m_paused = false;
    int m_untitled = 0;
    QString m_engineVersion;
    QString m_engineBuilt;
    QString m_consoleName;
};
