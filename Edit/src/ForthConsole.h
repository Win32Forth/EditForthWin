#pragma once

#include <QPlainTextEdit>
#include <QStringList>

// Docked Forth transcript. Engine output is protected. The tail is the input line.
class ForthConsole : public QPlainTextEdit {
    Q_OBJECT
public:
    explicit ForthConsole(QWidget *parent = nullptr);

    void appendOutput(const QString &text);
    void setEngineAlive(bool alive);

signals:
    void submitted(const QString &line);

protected:
    void keyPressEvent(QKeyEvent *event) override;
    void insertFromMimeData(const QMimeData *source) override;

private:
    void replaceInput(const QString &text);
    void submit();
    bool inputOnly(const QTextCursor &cursor) const;

    int m_prot = 0;
    bool m_alive = false;
    QStringList m_history;
    int m_history_at = -1;
    QString m_history_saved;
};
