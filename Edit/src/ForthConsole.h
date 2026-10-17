#pragma once

#include <QPlainTextEdit>
#include <QStringList>

// Docked Forth transcript. Engine output is protected. The tail is the input line.
class ForthConsole : public QPlainTextEdit {
    Q_OBJECT
public:
    explicit ForthConsole(QWidget *parent = nullptr);

    void appendOutput(const QString &text);
    void fillInput(const QString &text);
    void clearDisplay();
    void setPointSize(int points);
    void setEngineAlive(bool alive);
    // While the stepper is armed, copy and navigation stay. Typing does not.
    void setInputLocked(bool locked);
    // Put the line just submitted back into the input area.
    void retractSubmit();

signals:
    void submitted(const QString &line);
    void viewWordRequested(const QString &word);

protected:
    void keyPressEvent(QKeyEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void insertFromMimeData(const QMimeData *source) override;

private:
    void replaceInput(const QString &text);
    void submit();
    bool inputOnly(const QTextCursor &cursor) const;

    int m_prot = 0;
    int m_commit_at = -1;
    int m_commit_n = 0;
    bool m_alive = false;
    bool m_locked = false;
    QStringList m_history;
    int m_history_at = -1;
    QString m_history_saved;
};
