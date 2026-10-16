#pragma once

#include <QWidget>

class QLabel;
class QPushButton;
class QDialog;

// Status strip plus the debug toolbar. The breakpoints list is a separate window.
class DebugBar : public QWidget {
    Q_OBJECT
public:
    explicit DebugBar(QWidget *parent = nullptr);

    void setConnected(bool connected);
    void setDebug(bool armed, bool paused, const QString &name);
    void setError(const QString &text);
    void setNote(const QString &text);
    void setBreaks(const QString &text);
    enum class ConsolePlace { Docked, Floating, Hidden };
    void setConsolePlace(ConsolePlace place);

signals:
    void pauseRequested();
    void breakpointsRequested();
    void armRequested();
    void stepOverRequested();
    void stepIntoRequested();
    void stepOutRequested();
    void continueRequested();
    void stopRequested();
    void toggleCaretRequested();
    void breakEnableRequested(int index, bool on);
    void dockToggleRequested();

private:
    void apply();
    void showBreaks();

    bool m_connected = false;
    bool m_armed = false;
    bool m_paused = false;
    QString m_breakText;

    QLabel *m_engine = nullptr;
    QLabel *m_mark = nullptr;
    QLabel *m_word = nullptr;
    QLabel *m_hint = nullptr;
    QLabel *m_error = nullptr;
    QLabel *m_note = nullptr;
    QWidget *m_tools = nullptr;
    QPushButton *m_pause = nullptr;
    QPushButton *m_arm = nullptr;
    QPushButton *m_over = nullptr;
    QPushButton *m_into = nullptr;
    QPushButton *m_out = nullptr;
    QPushButton *m_go = nullptr;
    QPushButton *m_stop = nullptr;
    QPushButton *m_dock = nullptr;
    QDialog *m_breaks = nullptr;
};
