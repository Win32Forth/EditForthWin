#pragma once

#include <QList>
#include <QMainWindow>
#include <QString>

class AskForthPanel;
class CodeEdit;
class DebugBar;
class FindBar;
class ForthConsole;
class ForthFloat;
class ForthPipe;
class QComboBox;
class QPushButton;
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
    void showEvent(QShowEvent *event) override;
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
    void openRequestedFile(const QString &text, int line);
    void includeCurrent();
    enum class RunKind { Execute, Debug, Bpgo };
    void prepareRun(RunKind kind);
    void fillRun(const QString &name);
    void onLastName(const QString &name);
    void viewWord(const QString &word);
    void breakWord(const QString &word);
    void runToHere(int utf8Offset);
    void showFind(bool replace);
    void revealLine(const QString &path, int line, int column);
    void searchInFolders();
    void compareWithDisk();
    void openWebPage();
    void showAskPanel(bool on);
    void floadDialog();
    void chdirDialog();
    void restoreShipped();
    void showUserFolder(const QString &child);
    void toggleBrowse(bool on);
    void noteBrowse(CodeEdit *edit, bool on);
    void refreshViewBanners();
    void focusConsole();
    void setPointSize(int points);
    void setWrapMode(const QString &mode, int column);
    void syncWrapChecks();
    void toggleSplit();
    void attachSplit(CodeEdit *source);
    void detachSplit();
    void refreshSplitList();
    void syncTabChrome();
    void applyEditorChrome(CodeEdit *edit);
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
    void showStartupMessages();
    QString consumeStartup(const QString &text);

    QTabWidget *m_tabs = nullptr;
    QSplitter *m_split = nullptr;
    QSplitter *m_editors = nullptr;
    QWidget *m_right = nullptr;
    AskForthPanel *m_askPanel = nullptr;
    QAction *m_askAction = nullptr;
    QPushButton *m_askToggle = nullptr;
    QComboBox *m_splitPick = nullptr;
    CodeEdit *m_splitEdit = nullptr;
    CodeEdit *m_splitSource = nullptr;
    FindBar *m_find = nullptr;
    QWidget *m_bottom = nullptr;
    QVBoxLayout *m_bottomLayout = nullptr;
    DebugBar *m_debug = nullptr;
    ForthConsole *m_console = nullptr;
    ForthFloat *m_float = nullptr;
    ForthPipe *m_pipe = nullptr;
    QString m_forthDir;
    QAction *m_lineNumbersAction = nullptr;
    QAction *m_compareAction = nullptr;
    QAction *m_browseAction = nullptr;
    QAction *m_showConsoleAction = nullptr;
    QAction *m_splitAction = nullptr;
    QAction *m_wrapOff = nullptr;
    QAction *m_wrapWindow = nullptr;
    QAction *m_wrap60 = nullptr;
    QAction *m_wrap80 = nullptr;
    QAction *m_wrap100 = nullptr;
    QAction *m_wrapOther = nullptr;
    QAction *m_actInclude = nullptr;
    QAction *m_actRun = nullptr;
    QAction *m_actDebug = nullptr;
    QAction *m_actBpgo = nullptr;
    QAction *m_actPause = nullptr;
    QAction *m_actBreak = nullptr;
    QShortcut *m_keyOver = nullptr;
    QShortcut *m_keyInto = nullptr;
    QShortcut *m_keyOut = nullptr;
    QShortcut *m_keyStop = nullptr;
    QShortcut *m_keyBreak = nullptr;
    QAction *m_dockAction = nullptr;
    QList<int> m_dockedSplit;
    bool m_docked = true;
    bool m_consoleHidden = false;
    bool m_connected = false;
    bool m_armed = false;
    bool m_paused = false;
    bool m_waitingLast = false;
    RunKind m_pendingRun = RunKind::Execute;
    int m_pointSize = 13;
    int m_wrapColumn = 80;
    QString m_wrapMode = QStringLiteral("off");
    int m_untitled = 0;
    QString m_engineVersion;
    QString m_engineBuilt;
    QString m_consoleName;
    bool m_captureStartup = true;
    QString m_startupPartial;
    QString m_startupLog;
};
