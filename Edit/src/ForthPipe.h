#pragma once

#include <QList>
#include <QMutex>
#include <QObject>
#include <QString>

#include <atomic>

class QProcess;
class QThread;

// Launches forth.exe --companion and carries eval / output messages on a named pipe.
// One thread owns the pipe. A synchronous read and write on the same handle from
// two threads deadlocks, and Return never reaches Forth.
class ForthPipe : public QObject {
    Q_OBJECT
public:
    explicit ForthPipe(QObject *parent = nullptr);
    ~ForthPipe() override;

    void start();
    void shutdown();
    bool stopping() const { return m_stop.load(); }
    void *wakeHandle() const { return m_wake; }
    QList<QByteArray> takeOutgoing();

public slots:
    void eval(const QString &line);
    void noteOutput(const QString &text);
    void noteDirectory(const QString &path);
    void noteStopped();
    void noteFailed(const QString &message);

signals:
    void outputReceived(const QString &text);
    void directoryChanged(const QString &path);
    void engineStopped();
    void engineFailed(const QString &message);

private:
    QString forthPath() const;
    void post(const QByteArray &json);

    QProcess *m_proc = nullptr;
    QThread *m_reader = nullptr;
    QMutex m_mu;
    QList<QByteArray> m_outq;
    void *m_wake = nullptr;
    std::atomic<bool> m_stop{false};
};
