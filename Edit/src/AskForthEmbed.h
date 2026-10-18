#pragma once

#include <QByteArray>
#include <QObject>
#include <QString>
#include <QStringList>
#include <QUrl>
#include <QVector>

#include <atomic>
#include <functional>

class AskForthIndexer;
class QEventLoop;
class QNetworkAccessManager;
class QNetworkReply;

// Local Ollama embeddings for Ask Forth Library search. Chat may use
// SpaceXAI or another server; nomic-embed-text always stays on
// http://127.0.0.1:11434. The index is built on a background thread.
// Ask does not wait for the first build.

namespace AskForthEmbed {

QString embedModel();

struct Snippet {
    QString path;
    int line = 1;
    QString text;
    int score = 0;
};

struct Result {
    QVector<Snippet> snippets;
    QString rootLabel;
    QString modeLabel;
};

// body == null QByteArray means GET. A POST body is not null.
struct Net {
    std::function<QByteArray(const QUrl &url, const QByteArray &body, int timeoutMs, int *status, QString *error)>
        exchange;
};

struct IndexStatus {
    bool fileExists = false;
    bool modelMatch = false;
    bool rootsMatch = false;
    int chunks = 0;
};

IndexStatus indexStatus(const QString &folder);
QStringList modelNames(const QByteArray &tagsJson);
bool hasModel(const QStringList &names, const QString &want);
QString libraryBanner(const QString &folder, bool reachable, const QStringList &names);

Result retrieve(const QString &folder, const QString &query, const QString &mode, int maxSnippets,
                int contextLines, const std::atomic<bool> &cancel, const Net &net);

void attachIndexer(AskForthIndexer *indexer);
void requestPrepare(const QString &folder, const QString &mode, bool force);

} // namespace AskForthEmbed

class AskForthIndexer : public QObject {
    Q_OBJECT
public:
    explicit AskForthIndexer(QObject *parent = nullptr);

public slots:
    void prepare(QString folder, QString mode, bool force);
    void cancel();

signals:
    void activity(const QString &text, bool busy);

private:
    bool exchange(const QUrl &url, const QByteArray &body, int timeoutMs, int *status, QByteArray *payload,
                  QString *error);
    bool ping();
    bool modelInstalled(QString *error);
    bool pullModel(QString *error);
    void run(const QString &folder, bool force);

    QNetworkAccessManager *m_nam = nullptr;
    QNetworkReply *m_reply = nullptr;
    QEventLoop *m_loop = nullptr;
    std::atomic<bool> m_cancel{false};
    bool m_running = false;
    bool m_forceAgain = false;
};
