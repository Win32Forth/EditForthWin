#pragma once

#include <QList>
#include <QMutex>
#include <QObject>
#include <QString>

#include <atomic>

class QProcess;
class QThread;

// Launches fortharm64.exe or forthx64.exe --companion and carries eval / output messages on a named pipe.
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

    void sendKey(int key);
    void sendArm();
    void requestBreaks();
    void enableBreak(int index, bool on);
    void toggleBreak(const QString &name);
    void requestLast();
    void requestView(const QString &name);
    void requestTree(const QString &mode);
    void requestRunTo(int utf8Offset);
    bool signalBreak();
    QString forthPath() const;

public slots:
    void eval(const QString &line);
    void noteOutput(const QString &text);
    void noteDirectory(const QString &path);
    void noteStopped();
    void noteFailed(const QString &message);
    void noteDebug(bool armed, bool paused, int line, int off, int len, const QString &name,
                   const QString &path);
    void noteBreaks(const QString &text);
    void noteError(const QString &text);
    void noteEdit(const QString &path, int line);
    void noteLast(const QString &name);
    void noteVersion(const QString &text);

signals:
    void outputReceived(const QString &text);
    void directoryChanged(const QString &path);
    void engineStopped();
    void engineFailed(const QString &message);
    void debugReceived(bool armed, bool paused, int line, int off, int len, const QString &name,
                       const QString &path);
    void breaksReceived(const QString &text);
    void statusError(const QString &text);
    void editReceived(const QString &path, int line);
    void lastReceived(const QString &name);
    void versionReceived(const QString &text);

private:
    void post(const QByteArray &json);

    QProcess *m_proc = nullptr;
    QThread *m_reader = nullptr;
    QMutex m_mu;
    QList<QByteArray> m_outq;
    void *m_wake = nullptr;
    std::atomic<bool> m_stop{false};
};
