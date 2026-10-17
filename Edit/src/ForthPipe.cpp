#include "ForthPipe.h"

#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMutexLocker>
#include <QProcess>
#include <QThread>

#include <string>

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

namespace {

QByteArray message(const char *op, const QString &text) {
    QJsonObject obj;
    obj.insert(QStringLiteral("op"), QString::fromLatin1(op));
    if (!text.isNull())
        obj.insert(QStringLiteral("text"), text);
    return QJsonDocument(obj).toJson(QJsonDocument::Compact);
}

HANDLE openPipe(const QString &name, const ForthPipe *owner) {
    const std::wstring path = (QStringLiteral("\\\\.\\pipe\\") + name).toStdWString();
    for (int i = 0; i < 80; i++) {
        if (owner->stopping())
            return INVALID_HANDLE_VALUE;
        HANDLE handle = CreateFileW(path.c_str(), GENERIC_READ | GENERIC_WRITE, 0, NULL,
                                    OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);
        if (handle != INVALID_HANDLE_VALUE) {
            DWORD mode = PIPE_READMODE_BYTE;
            SetNamedPipeHandleState(handle, &mode, NULL, NULL);
            return handle;
        }
        Sleep(100);
    }
    return INVALID_HANDLE_VALUE;
}

bool writeAll(HANDLE handle, const QByteArray &bytes) {
    OVERLAPPED ov;
    memset(&ov, 0, sizeof ov);
    ov.hEvent = CreateEventW(NULL, TRUE, FALSE, NULL);
    if (ov.hEvent == NULL)
        return false;
    const char *p = bytes.constData();
    int left = bytes.size();
    bool ok = true;
    while (left > 0) {
        ResetEvent(ov.hEvent);
        DWORD wrote = 0;
        if (!WriteFile(handle, p, static_cast<DWORD>(left), &wrote, &ov)) {
            if (GetLastError() != ERROR_IO_PENDING ||
                !GetOverlappedResult(handle, &ov, &wrote, TRUE)) {
                ok = false;
                break;
            }
        }
        if (wrote == 0) {
            ok = false;
            break;
        }
        p += wrote;
        left -= static_cast<int>(wrote);
    }
    CloseHandle(ov.hEvent);
    return ok;
}

void flushOutgoing(ForthPipe *owner, HANDLE handle) {
    const QList<QByteArray> batch = owner->takeOutgoing();
    for (const QByteArray &frame : batch) {
        if (!writeAll(handle, frame))
            return;
    }
}

class PipeReader : public QThread {
public:
    ForthPipe *owner = nullptr;
    QString name;

    void run() override {
        HANDLE handle = openPipe(name, owner);
        if (handle == INVALID_HANDLE_VALUE) {
            if (!owner->stopping())
                QMetaObject::invokeMethod(owner, "noteFailed", Qt::QueuedConnection,
                                          Q_ARG(QString, QStringLiteral("Forth pipe did not open.")));
            return;
        }

        OVERLAPPED ov;
        memset(&ov, 0, sizeof ov);
        ov.hEvent = CreateEventW(NULL, TRUE, FALSE, NULL);
        unsigned char hdr[4];
        QByteArray body;
        char *dst = reinterpret_cast<char *>(hdr);
        int need = 4;
        int got = 0;
        bool readingBody = false;
        bool readPending = false;
        bool told = false;
        HANDLE wake = static_cast<HANDLE>(owner->wakeHandle());

        auto startRead = [&]() -> bool {
            if (got >= need)
                return true;
            ResetEvent(ov.hEvent);
            DWORD n = 0;
            if (ReadFile(handle, dst + got, static_cast<DWORD>(need - got), &n, &ov)) {
                got += static_cast<int>(n);
                readPending = false;
                return true;
            }
            if (GetLastError() == ERROR_IO_PENDING) {
                readPending = true;
                return true;
            }
            return false;
        };

        flushOutgoing(owner, handle);
        while (!owner->stopping()) {
            if (!readPending && got < need && !startRead())
                break;
            if (got >= need) {
                readPending = false;
                if (!readingBody) {
                    const unsigned n = hdr[0] | (hdr[1] << 8) | (hdr[2] << 16) | (hdr[3] << 24);
                    if (n == 0 || n > 4u * 1024u * 1024u)
                        break;
                    body.resize(static_cast<int>(n));
                    dst = body.data();
                    need = static_cast<int>(n);
                    got = 0;
                    readingBody = true;
                    continue;
                }
                const QJsonObject obj = QJsonDocument::fromJson(body).object();
                const QString op = obj.value(QStringLiteral("op")).toString();
                if (op == QLatin1String("out"))
                    QMetaObject::invokeMethod(owner, "noteOutput", Qt::QueuedConnection,
                                              Q_ARG(QString, obj.value(QStringLiteral("text")).toString()));
                else if (op == QLatin1String("cwd"))
                    QMetaObject::invokeMethod(owner, "noteDirectory", Qt::QueuedConnection,
                                              Q_ARG(QString, obj.value(QStringLiteral("text")).toString()));
                else if (op == QLatin1String("bye")) {
                    QMetaObject::invokeMethod(owner, "noteStopped", Qt::QueuedConnection);
                    told = true;
                    break;
                } else if (op == QLatin1String("debug")) {
                    const bool armed = obj.value(QStringLiteral("armed")).toInt() != 0;
                    const bool paused = obj.value(QStringLiteral("paused")).toInt() != 0;
                    const int line = obj.value(QStringLiteral("line")).toInt();
                    const int off = obj.value(QStringLiteral("off")).toInt();
                    const int len = obj.value(QStringLiteral("len")).toInt();
                    const QString name = obj.value(QStringLiteral("name")).toString();
                    const QString path = obj.value(QStringLiteral("path")).toString();
                    QMetaObject::invokeMethod(owner, "noteDebug", Qt::QueuedConnection,
                                              Q_ARG(bool, armed), Q_ARG(bool, paused), Q_ARG(int, line),
                                              Q_ARG(int, off), Q_ARG(int, len), Q_ARG(QString, name),
                                              Q_ARG(QString, path));
                } else if (op == QLatin1String("breaks")) {
                    QMetaObject::invokeMethod(owner, "noteBreaks", Qt::QueuedConnection,
                                              Q_ARG(QString, obj.value(QStringLiteral("text")).toString()));
                } else if (op == QLatin1String("err")) {
                    QMetaObject::invokeMethod(owner, "noteError", Qt::QueuedConnection,
                                              Q_ARG(QString, obj.value(QStringLiteral("text")).toString()));
                } else if (op == QLatin1String("edit")) {
                    QMetaObject::invokeMethod(
                        owner, "noteEdit", Qt::QueuedConnection,
                        Q_ARG(QString, obj.value(QStringLiteral("text")).toString()),
                        Q_ARG(int, obj.value(QStringLiteral("line")).toInt()));
                } else if (op == QLatin1String("last")) {
                    QMetaObject::invokeMethod(owner, "noteLast", Qt::QueuedConnection,
                                              Q_ARG(QString, obj.value(QStringLiteral("text")).toString()));
                } else if (op == QLatin1String("version")) {
                    QMetaObject::invokeMethod(owner, "noteVersion", Qt::QueuedConnection,
                                              Q_ARG(QString, obj.value(QStringLiteral("text")).toString()));
                }
                dst = reinterpret_cast<char *>(hdr);
                need = 4;
                got = 0;
                readingBody = false;
                continue;
            }

            HANDLE waits[2] = {ov.hEvent, wake};
            const DWORD w = WaitForMultipleObjects(2, waits, FALSE, INFINITE);
            if (w == WAIT_OBJECT_0) {
                DWORD n = 0;
                if (!GetOverlappedResult(handle, &ov, &n, FALSE) || n == 0)
                    break;
                got += static_cast<int>(n);
                readPending = false;
            } else if (w == WAIT_OBJECT_0 + 1) {
                flushOutgoing(owner, handle);
            } else {
                break;
            }
        }

        CancelIoEx(handle, NULL);
        if (readPending) {
            DWORD n = 0;
            GetOverlappedResult(handle, &ov, &n, TRUE);
        }
        CloseHandle(ov.hEvent);
        CloseHandle(handle);
        if (!told && !owner->stopping())
            QMetaObject::invokeMethod(owner, "noteStopped", Qt::QueuedConnection);
    }
};

} // namespace

ForthPipe::ForthPipe(QObject *parent) : QObject(parent) {}

ForthPipe::~ForthPipe() { shutdown(); }

QString ForthPipe::forthPath() const {
#if defined(_M_X64)
    const QString forthName = QStringLiteral("forthx64.exe");
    const QString archForth = QStringLiteral("Forth/build/x64/forthx64.exe");
    const QString archRel = QStringLiteral("../../../Forth/build/x64/forthx64.exe");
#else
    const QString forthName = QStringLiteral("fortharm64.exe");
    const QString archForth = QStringLiteral("Forth/build/arm64/fortharm64.exe");
    const QString archRel = QStringLiteral("../../../Forth/build/arm64/fortharm64.exe");
#endif
    const QStringList candidates = {
        QDir(QCoreApplication::applicationDirPath()).filePath(forthName),
        QDir(QCoreApplication::applicationDirPath()).filePath(archRel),
        QDir::current().filePath(archForth),
    };
    for (const QString &path : candidates) {
        if (QFileInfo::exists(path))
            return QFileInfo(path).absoluteFilePath();
    }
    return candidates.last();
}

QList<QByteArray> ForthPipe::takeOutgoing() {
    QMutexLocker lock(&m_mu);
    QList<QByteArray> batch = m_outq;
    m_outq.clear();
    return batch;
}

void ForthPipe::noteVersion(const QString &text) {
    emit versionReceived(text);
}

void ForthPipe::post(const QByteArray &json) {
    QByteArray frame(4 + json.size(), '\0');
    const unsigned n = static_cast<unsigned>(json.size());
    frame[0] = static_cast<char>(n);
    frame[1] = static_cast<char>(n >> 8);
    frame[2] = static_cast<char>(n >> 16);
    frame[3] = static_cast<char>(n >> 24);
    memcpy(frame.data() + 4, json.constData(), json.size());
    QMutexLocker lock(&m_mu);
    m_outq.append(frame);
    if (m_wake != nullptr)
        SetEvent(static_cast<HANDLE>(m_wake));
}

void ForthPipe::start() {
    if (m_proc != nullptr)
        return;
    const QString path = forthPath();
    if (!QFileInfo::exists(path)) {
        emit engineFailed(QStringLiteral("Can't find %1.").arg(QFileInfo(path).fileName()));
        return;
    }
    m_stop = false;
    if (m_wake == nullptr)
        m_wake = CreateEventW(NULL, FALSE, FALSE, NULL);
    const QString pipeName = QStringLiteral("EditForthWin-%1").arg(QCoreApplication::applicationPid());
    m_proc = new QProcess(this);
    m_proc->setWorkingDirectory(QDir::currentPath());
    m_proc->start(path, {QStringLiteral("--companion"), pipeName});
    if (!m_proc->waitForStarted(5000)) {
        emit engineFailed(QStringLiteral("%1 did not start.").arg(QFileInfo(path).fileName()));
        m_proc->deleteLater();
        m_proc = nullptr;
        return;
    }
    auto *reader = new PipeReader;
    reader->owner = this;
    reader->name = pipeName;
    m_reader = reader;
    reader->start();
}

void ForthPipe::shutdown() {
    if (m_stop.load() && m_proc == nullptr && m_reader == nullptr)
        return;
    m_stop = true;
    post(message("quit", QString()));
    if (m_wake != nullptr)
        SetEvent(static_cast<HANDLE>(m_wake));
    if (m_proc != nullptr) {
        if (!m_proc->waitForFinished(1500))
            m_proc->kill();
        m_proc->deleteLater();
        m_proc = nullptr;
    }
    if (m_reader != nullptr) {
        m_reader->wait(1500);
        delete m_reader;
        m_reader = nullptr;
    }
    if (m_wake != nullptr) {
        CloseHandle(static_cast<HANDLE>(m_wake));
        m_wake = nullptr;
    }
}

void ForthPipe::eval(const QString &line) { post(message("eval", line)); }

void ForthPipe::sendKey(int key) { post(message("key", QString::number(key))); }

void ForthPipe::sendArm() { post(message("arm", QString())); }

void ForthPipe::requestBreaks() { post(message("breaks", QString())); }

void ForthPipe::enableBreak(int index, bool on) {
    post(message("break-en", QStringLiteral("%1,%2").arg(index).arg(on ? 1 : 0)));
}

void ForthPipe::toggleBreak(const QString &name) { post(message("break-toggle", name)); }

void ForthPipe::requestLast() { post(message("last", QString())); }

void ForthPipe::requestView(const QString &name) { post(message("view", name)); }

void ForthPipe::requestTree(const QString &mode) { post(message("tree", mode)); }

void ForthPipe::requestRunTo(int utf8Offset) { post(message("runto", QString::number(utf8Offset))); }

void ForthPipe::noteEdit(const QString &path, int line) { emit editReceived(path, line); }

void ForthPipe::noteLast(const QString &name) { emit lastReceived(name); }

bool ForthPipe::signalBreak() {
    const std::wstring name =
        QStringLiteral("Local\\EditForthWin-%1-break").arg(QCoreApplication::applicationPid()).toStdWString();
    HANDLE event = OpenEventW(EVENT_MODIFY_STATE, FALSE, name.c_str());
    if (event == NULL)
        return false;
    SetEvent(event);
    CloseHandle(event);
    return true;
}

void ForthPipe::noteOutput(const QString &text) { emit outputReceived(text); }

void ForthPipe::noteDirectory(const QString &path) { emit directoryChanged(path); }

void ForthPipe::noteStopped() { emit engineStopped(); }

void ForthPipe::noteFailed(const QString &message) { emit engineFailed(message); }

void ForthPipe::noteDebug(bool armed, bool paused, int line, int off, int len, const QString &name,
                          const QString &path) {
    emit debugReceived(armed, paused, line, off, len, name, path);
}

void ForthPipe::noteBreaks(const QString &text) { emit breaksReceived(text); }

void ForthPipe::noteError(const QString &text) { emit statusError(text); }
