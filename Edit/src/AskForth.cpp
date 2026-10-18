#include "AskForth.h"

#include "CodeEdit.h"

#include <QCheckBox>
#include <QComboBox>
#include <QCoreApplication>
#include <QDesktopServices>
#include <QDialog>
#include <QDialogButtonBox>
#include <QDir>
#include <QDirIterator>
#include <QDoubleSpinBox>
#include <QEventLoop>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QFont>
#include <QFormLayout>
#include <QFrame>
#include <QHBoxLayout>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QLabel>
#include <QLineEdit>
#include <QListWidget>
#include <QListWidgetItem>
#include <QMessageBox>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QPlainTextEdit>
#include <QProcess>
#include <QPushButton>
#include <QRegularExpression>
#include <QSaveFile>
#include <QSettings>
#include <QShowEvent>
#include <QShortcut>
#include <QSizePolicy>
#include <QSplitter>
#include <QSignalBlocker>
#include <QSpinBox>
#include <QStyle>
#include <QStringList>
#include <QStandardPaths>
#include <QTextCursor>
#include <QThread>
#include <QTimer>
#include <QUrl>
#include <QUrlQuery>
#include <QVBoxLayout>
#include <QUuid>
#include <QVector>

#ifndef NOMINMAX
#define NOMINMAX
#endif
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#include <wincred.h>

#include <algorithm>
#include <atomic>

using Profile = AskForthPanel::Profile;

namespace {

constexpr int kMaxTokens = 8192;
constexpr int kWrap = 80;

QString userRoot() {
    return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
           QStringLiteral("/EditForthWin");
}

QString askDirectory() { return userRoot() + QStringLiteral("/AskForth"); }

QString defaultLibrary() { return userRoot() + QStringLiteral("/Library/Sample"); }

QString nextAskPath() {
    QDir().mkpath(askDirectory());
    for (int n = 1; n < 100000; ++n) {
        const QString path = askDirectory() + QStringLiteral("/AskForth-%1.fth").arg(n);
        if (!QFileInfo::exists(path))
            return path;
    }
    return askDirectory() + QStringLiteral("/AskForth-%1.fth")
                                .arg(QUuid::createUuid().toString(QUuid::WithoutBraces));
}

QString wrapLine(const QString &line, int width) {
    if (line.size() <= width)
        return line;
    QStringList rows;
    int i = 0;
    while (i < line.size()) {
        if (line.size() - i <= width) {
            rows << line.mid(i);
            break;
        }
        const int window = i + width;
        int space = line.lastIndexOf(QLatin1Char(' '), window - 1);
        if (space > i) {
            rows << line.mid(i, space - i);
            i = space + 1;
        } else {
            rows << line.mid(i, width);
            i += width;
        }
    }
    return rows.join(QLatin1Char('\n'));
}

QString wrapToWidth(const QString &text, int width) {
    const QStringList lines = text.split(QLatin1Char('\n'));
    QStringList out;
    out.reserve(lines.size());
    for (const QString &line : lines)
        out << wrapLine(line, width);
    return out.join(QLatin1Char('\n'));
}

double clampTemp(double v) { return qBound(0.0, v, 2.0); }

QString trimSlash(QString s) {
    while (s.endsWith(QLatin1Char('/')))
        s.chop(1);
    return s;
}

Profile makeProfile(const QString &name, const QString &provider, const QString &model,
                    const QString &base) {
    Profile p;
    p.id = QUuid::createUuid().toString(QUuid::WithoutBraces);
    p.name = name;
    p.provider = provider;
    p.model = model;
    p.base = base;
    p.temperature = 0.3;
    return p;
}

QJsonObject profileJson(const Profile &p) {
    QJsonObject o;
    o.insert(QStringLiteral("id"), p.id);
    o.insert(QStringLiteral("name"), p.name);
    o.insert(QStringLiteral("provider"), p.provider);
    o.insert(QStringLiteral("model"), p.model);
    o.insert(QStringLiteral("base"), p.base);
    o.insert(QStringLiteral("temperature"), p.temperature);
    return o;
}

Profile profileFrom(const QJsonObject &o) {
    Profile p;
    p.id = o.value(QStringLiteral("id")).toString();
    if (p.id.isEmpty())
        p.id = QUuid::createUuid().toString(QUuid::WithoutBraces);
    p.name = o.value(QStringLiteral("name")).toString();
    p.provider = o.value(QStringLiteral("provider")).toString(QStringLiteral("ollama"));
    p.model = o.value(QStringLiteral("model")).toString();
    p.base = o.value(QStringLiteral("base")).toString();
    p.temperature = clampTemp(o.value(QStringLiteral("temperature")).toDouble(0.3));
    return p;
}

std::wstring credTarget(const QString &id) {
    return (QStringLiteral("EditForthWin/AskForth/") + id).toStdWString();
}

bool saveKey(const QString &id, const QString &key) {
    const QByteArray blob = key.toUtf8();
    const std::wstring target = credTarget(id);
    CREDENTIALW cred = {};
    cred.Type = CRED_TYPE_GENERIC;
    cred.TargetName = const_cast<LPWSTR>(target.c_str());
    cred.CredentialBlobSize = static_cast<DWORD>(blob.size());
    cred.CredentialBlob = reinterpret_cast<LPBYTE>(const_cast<char *>(blob.constData()));
    cred.Persist = CRED_PERSIST_LOCAL_MACHINE;
    cred.UserName = const_cast<LPWSTR>(L"AskForth");
    return CredWriteW(&cred, 0) == TRUE;
}

void deleteKey(const QString &id) {
    const std::wstring target = credTarget(id);
    CredDeleteW(target.c_str(), CRED_TYPE_GENERIC, 0);
}

QString loadKey(const QString &id) {
    const std::wstring target = credTarget(id);
    PCREDENTIALW cred = nullptr;
    if (!CredReadW(target.c_str(), CRED_TYPE_GENERIC, 0, &cred) || cred == nullptr)
        return {};
    const QString key = QString::fromUtf8(reinterpret_cast<const char *>(cred->CredentialBlob),
                                          static_cast<int>(cred->CredentialBlobSize));
    CredFree(cred);
    return key;
}

QString resolveKey(const QString &id) {
    const QString saved = loadKey(id).trimmed();
    if (!saved.isEmpty())
        return saved;
    return qEnvironmentVariable("XAI_API_KEY").trimmed();
}

QVector<Profile> cannedProfiles() {
    QVector<Profile> list;
    list << makeProfile(QStringLiteral("Ollama gemma4:e4b"), QStringLiteral("ollama"),
                        QStringLiteral("gemma4:e4b"), QStringLiteral("http://127.0.0.1:11434"));
    list << makeProfile(QStringLiteral("SpaceXAI grok-4.7"), QStringLiteral("openai"),
                        QStringLiteral("grok-4.7"), QStringLiteral("https://api.x.ai/v1"));
    Profile mlx = makeProfile(QStringLiteral("Local mlx :1234"), QStringLiteral("openai"),
                              QStringLiteral("local-model"), QStringLiteral("http://127.0.0.1:1234/v1"));
    list << mlx;
    return list;
}

void ensureMlxKey(const QVector<Profile> &list) {
    for (const Profile &p : list) {
        if (p.provider == QLatin1String("openai") &&
            (p.base.contains(QStringLiteral("127.0.0.1:1234")) ||
             p.base.contains(QStringLiteral("localhost:1234"))) &&
            loadKey(p.id).isEmpty() && qEnvironmentVariable("XAI_API_KEY").trimmed().isEmpty())
            saveKey(p.id, QStringLiteral("local"));
    }
}

QVector<Profile> loadProfiles() {
    QSettings settings;
    QVector<Profile> list;
    const QByteArray raw = settings.value(QStringLiteral("aiAssistantModelProfiles")).toByteArray();
    const QJsonArray arr = QJsonDocument::fromJson(raw).array();
    for (const QJsonValue &v : arr) {
        if (v.isObject())
            list << profileFrom(v.toObject());
    }
    auto hasOllama = [&] {
        for (const Profile &p : list)
            if (p.provider == QLatin1String("ollama") && p.model == QLatin1String("gemma4:e4b"))
                return true;
        return false;
    };
    auto hasXai = [&] {
        for (const Profile &p : list)
            if (p.provider == QLatin1String("openai") && p.model == QLatin1String("grok-4.7") &&
                p.base.contains(QStringLiteral("api.x.ai")))
                return true;
        return false;
    };
    auto hasMlx = [&] {
        for (const Profile &p : list)
            if (p.base.contains(QStringLiteral("127.0.0.1:1234")) ||
                p.base.contains(QStringLiteral("localhost:1234")))
                return true;
        return false;
    };
    const QVector<Profile> seed = cannedProfiles();
    if (!hasOllama())
        list << seed.at(0);
    if (!hasXai())
        list << seed.at(1);
    if (!hasMlx())
        list << seed.at(2);
    ensureMlxKey(list);
    return list;
}

void saveProfiles(const QVector<Profile> &list) {
    QJsonArray arr;
    for (const Profile &p : list)
        arr.append(profileJson(p));
    QSettings().setValue(QStringLiteral("aiAssistantModelProfiles"),
                         QJsonDocument(arr).toJson(QJsonDocument::Compact));
}

QString joinUrl(QString base, const QString &suffix) {
    base = trimSlash(base);
    if (base.endsWith(suffix))
        return base;
    return base + suffix;
}

QString libraryBlock(const QString &folder, const QString &query, int maxSnippets, int maxChars, const QString &mode,
                     int contextLines, QString *note, const std::atomic<bool> &cancel, const AskForthEmbed::Net &net) {
    const AskForthEmbed::Result result =
        AskForthEmbed::retrieve(folder, query, mode, maxSnippets, contextLines, cancel, net);
    if (cancel.load())
        return {};
    if (result.snippets.isEmpty()) {
        *note = QStringLiteral(" · Library: no hits (%1)").arg(result.modeLabel);
        return {};
    }
    const QString rootLabel = result.rootLabel.isEmpty() ? folder : result.rootLabel;
    QString out = QStringLiteral(
                      "Library context (excerpts from %1; %2). Treat as authoritative for word names "
                      "and stack effects; answer from these excerpts when possible:\n")
                      .arg(rootLabel, result.modeLabel);
    QStringList names;
    int included = 0;
    for (const AskForthEmbed::Snippet &snip : result.snippets) {
        const QString header =
            QStringLiteral("\n--- %1:%2 (score %3) ---\n").arg(snip.path).arg(snip.line).arg(snip.score);
        if (out.size() + header.size() + snip.text.size() > maxChars)
            break;
        out += header;
        out += snip.text;
        if (!snip.text.endsWith(QLatin1Char('\n')))
            out += QLatin1Char('\n');
        ++included;
        if (names.size() < 4)
            names << snip.path;
    }
    if (included == 0) {
        *note = QStringLiteral(" · Library: no hits (%1)").arg(result.modeLabel);
        return {};
    }
    *note = QStringLiteral(" · Library %1 %2: %3").arg(included).arg(result.modeLabel, names.join(QStringLiteral(", ")));
    return out;
}

QString stripTags(QString html) {
    html.remove(QRegularExpression(QStringLiteral("<script\\b[^>]*>.*?</script>"),
                                   QRegularExpression::CaseInsensitiveOption |
                                       QRegularExpression::DotMatchesEverythingOption));
    html.remove(QRegularExpression(QStringLiteral("<style\\b[^>]*>.*?</style>"),
                                   QRegularExpression::CaseInsensitiveOption |
                                       QRegularExpression::DotMatchesEverythingOption));
    html.replace(QRegularExpression(QStringLiteral("<[^>]+>")), QStringLiteral(" "));
    html.replace(QStringLiteral("&nbsp;"), QStringLiteral(" "));
    html.replace(QStringLiteral("&amp;"), QStringLiteral("&"));
    html.replace(QStringLiteral("&lt;"), QStringLiteral("<"));
    html.replace(QStringLiteral("&gt;"), QStringLiteral(">"));
    html.replace(QStringLiteral("&quot;"), QStringLiteral("\""));
    html.replace(QStringLiteral("&#39;"), QStringLiteral("'"));
    html.replace(QRegularExpression(QStringLiteral("[ \\t]+")), QStringLiteral(" "));
    return html.trimmed();
}

QStringList extractUrls(const QString &text) {
    QStringList urls;
    QRegularExpression re(QStringLiteral("https?://[^\\s<>\"']+"),
                          QRegularExpression::CaseInsensitiveOption);
    auto it = re.globalMatch(text);
    while (it.hasNext() && urls.size() < 4) {
        QString url = it.next().captured(0);
        while (url.endsWith(QLatin1Char('.')) || url.endsWith(QLatin1Char(',')) ||
               url.endsWith(QLatin1Char(')')) )
            url.chop(1);
        if (!urls.contains(url))
            urls << url;
    }
    return urls;
}

QString systemPrompt(const QString &fileName, bool enhance) {
    QStringList lines = {
        QStringLiteral("You are a Forth programming assistant for EditForthWin (ANS-style ITC Forth on Windows, the sibling of EditForth / 64Forth)."),
        QStringLiteral("Prefer idiomatic Forth: clear stack comments ( a b -- c ), short words, and explanations that match classic Forth style."),
        QStringLiteral("When asked for code, return Forth source the user can paste inside a ```forth fenced block when possible."),
        QStringLiteral("Never invent ANS or EditForthWin word names, stack effects, or APIs. If you are unsure, say so and suggest looking in Library/Reference or forth-standard.org."),
        QStringLiteral("Stack comments must match real argument order (e.g. c-addr u for strings, not a single invented string cell)."),
        QStringLiteral("Be concise.")};
    if (!fileName.isEmpty())
        lines << QStringLiteral("The user is editing: %1.").arg(fileName);
    if (enhance) {
        lines << QStringLiteral("You are correcting Forth that failed or needs improvement after a real kernel eval.");
        lines << QStringLiteral("Prefer Library/Reference stack effects and Sample idioms when they match.");
        lines << QStringLiteral("Do not claim a fix unless the change is concrete; keep stack comments accurate.");
    }
    return lines.join(QLatin1Char('\n'));
}

QString askHeader(const Profile &profile, const QString &prompt, bool library, const QString &folder,
                  const QString &mode, int snippets, int lines, int chars, bool urls, bool web, bool tools) {
    QStringList rows;
    rows << QStringLiteral("\\\\ Ask Forth");
    const QString model = profile.model.trimmed().isEmpty() ? QStringLiteral("(none)") : profile.model.trimmed();
    rows << QStringLiteral("\\ Model: %1").arg(model);
    rows << QStringLiteral("\\ Temperature: %1").arg(QString::number(profile.temperature, 'f', 2));
    if (library) {
        rows << QStringLiteral("\\ Include Library context: on");
        rows << QStringLiteral("\\ Library: %1").arg(folder);
        rows << QStringLiteral("\\ Retrieve mode: %1").arg(mode);
        rows << QStringLiteral("\\ Max snippets: %1").arg(snippets);
        rows << QStringLiteral("\\ Context lines: %1").arg(lines);
        rows << QStringLiteral("\\ Max characters: %1").arg(chars);
    }
    if (urls)
        rows << QStringLiteral("\\ Fetch URLs in Prompt: on");
    if (web)
        rows << QStringLiteral("\\ Include web search: on");
    if (tools)
        rows << QStringLiteral("\\ Tool agent: on");
    rows << QStringLiteral("\\");
    rows << QStringLiteral("\\ Prompt:");
    const QStringList promptLines = prompt.split(QLatin1Char('\n'));
    for (const QString &line : promptLines)
        rows << QStringLiteral("\\ %1").arg(line);
    rows << QStringLiteral("{");
    rows << QString();
    rows << QString();
    return rows.join(QLatin1Char('\n'));
}

QString extractForth(const QString &text) {
    const int fence = text.indexOf(QStringLiteral("```"));
    if (fence < 0)
        return text.trimmed();
    int start = text.indexOf(QLatin1Char('\n'), fence);
    if (start < 0)
        return text.trimmed();
    ++start;
    const int end = text.indexOf(QStringLiteral("```"), start);
    if (end < 0)
        return text.mid(start).trimmed();
    return text.mid(start, end - start).trimmed();
}

QString modeDisplay(const QString &mode) {
    if (mode == QLatin1String("semantic"))
        return QStringLiteral("Semantic");
    if (mode == QLatin1String("keyword"))
        return QStringLiteral("Keyword");
    return QStringLiteral("Hybrid");
}

} // namespace

class AskForthPanel::Worker : public QObject {
    Q_OBJECT
public:
    Worker() = default;

public slots:
    void start(const QVariant &payload);
    void cancel();

signals:
    void statusText(const QString &text);
    void bodyChanged(const QString &full);
    void auditReady(const QString &comments);
    void toolLog(const QString &text);
    void agentDone(const QString &transcript, int exitCode);
    void finished(const QString &full, const QString &status);
    void failed(const QString &message);

private:
    struct Chat {
        QString content;
        QJsonArray calls;
        QString error;
    };
    void ensureNam();
    Chat chat(const QVariantMap &job, const QJsonArray &messages, const QJsonArray &tools, bool stream);
    QByteArray http(const QNetworkRequest &req, const QByteArray &body, int timeoutMs, int *status, QString *error);
    QString fetchPage(const QString &url, QString *error);
    QString searchWeb(const QString &prompt, QString *audit, QString *note);
    QString runTools(const QVariantMap &job, const QString &system, const QString &user, QString *note, QString *audit);
    AskForthEmbed::Net net();

    QNetworkAccessManager *m_nam = nullptr;
    QNetworkReply *m_reply = nullptr;
    QEventLoop *m_loop = nullptr;
    QProcess *m_proc = nullptr;
    std::atomic<bool> m_cancel{false};
};

void AskForthPanel::Worker::ensureNam() {
    if (m_nam == nullptr)
        m_nam = new QNetworkAccessManager(this);
}

AskForthEmbed::Net AskForthPanel::Worker::net() {
    AskForthEmbed::Net out;
    out.exchange = [this](const QUrl &url, const QByteArray &body, int timeoutMs, int *status, QString *error) {
        QNetworkRequest req{url};
        req.setTransferTimeout(timeoutMs);
        if (!body.isNull())
            req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));
        return http(req, body.isNull() ? QByteArray() : body, timeoutMs, status, error);
    };
    return out;
}

void AskForthPanel::Worker::cancel() {
    m_cancel.store(true);
    if (m_reply != nullptr)
        m_reply->abort();
    if (m_proc != nullptr)
        m_proc->kill();
    if (m_loop != nullptr)
        m_loop->quit();
}

QByteArray AskForthPanel::Worker::http(const QNetworkRequest &req, const QByteArray &body, int timeoutMs,
                                      int *status, QString *error) {
    ensureNam();
    QNetworkReply *reply = body.isNull() ? m_nam->get(req) : m_nam->post(req, body);
    m_reply = reply;
    QEventLoop loop;
    m_loop = &loop;
    QTimer timer;
    timer.setSingleShot(true);
    QObject::connect(&timer, &QTimer::timeout, &loop, [&] {
        reply->abort();
        loop.quit();
    });
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    timer.start(timeoutMs);
    loop.exec();
    m_loop = nullptr;
    m_reply = nullptr;
    *status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    const QByteArray data = reply->readAll();
    if (m_cancel.load())
        *error = QStringLiteral("cancelled");
    else if (reply->error() != QNetworkReply::NoError && *status == 0)
        *error = reply->errorString();
    reply->deleteLater();
    return data;
}

QString AskForthPanel::Worker::fetchPage(const QString &url, QString *error) {
    QNetworkRequest req{QUrl(url)};
    req.setTransferTimeout(15000);
    req.setRawHeader("User-Agent", "EditForthWin-AskForth/1.0");
    int status = 0;
    const QByteArray data = http(req, QByteArray(), 15000, &status, error);
    if (m_cancel.load())
        return {};
    if (status < 200 || status >= 300) {
        *error = QStringLiteral("HTTP %1").arg(status);
        return {};
    }
    QString text = stripTags(QString::fromUtf8(data.left(200000)));
    if (text.size() > 8000)
        text.truncate(8000);
    return text.trimmed();
}

QString AskForthPanel::Worker::searchWeb(const QString &prompt, QString *audit, QString *note) {
    QString query = prompt;
    query.remove(QRegularExpression(QStringLiteral("https?://\\S+"), QRegularExpression::CaseInsensitiveOption));
    query.replace(QRegularExpression(QStringLiteral("\\s+")), QStringLiteral(" "));
    query = query.trimmed();
    if (query.size() > 200)
        query.truncate(200);
    if (query.isEmpty()) {
        *note = QStringLiteral(" · Search: empty query");
        return {};
    }
    QNetworkRequest req{QUrl(QStringLiteral("https://lite.duckduckgo.com/lite/"))};
    req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/x-www-form-urlencoded"));
    req.setRawHeader("User-Agent", "EditForthWin-AskForth/1.0");
    QString error;
    int status = 0;
    const QByteArray body = QByteArray("q=") + QUrl::toPercentEncoding(query);
    const QString html = QString::fromUtf8(http(req, body, 15000, &status, &error));
    if (m_cancel.load())
        return {};
    if (html.contains(QStringLiteral("anomaly-modal"), Qt::CaseInsensitive) ||
        html.contains(QStringLiteral("bots use DuckDuckGo"), Qt::CaseInsensitive)) {
        *note = QStringLiteral(" · Search: blocked by DuckDuckGo");
        return {};
    }
    QRegularExpression linkRe(QStringLiteral("<a\\b([^>]*class=['\"]result-link['\"][^>]*)>(.*?)</a>"),
                              QRegularExpression::CaseInsensitiveOption |
                                  QRegularExpression::DotMatchesEverythingOption);
    QRegularExpression hrefRe(QStringLiteral("href=['\"]([^'\"]+)['\"]"),
                              QRegularExpression::CaseInsensitiveOption);
    QRegularExpression snipRe(QStringLiteral("<td[^>]*class=['\"]result-snippet['\"][^>]*>(.*?)</td>"),
                              QRegularExpression::CaseInsensitiveOption |
                                  QRegularExpression::DotMatchesEverythingOption);
    QVector<QRegularExpressionMatch> linkHits;
    auto lit = linkRe.globalMatch(html);
    while (lit.hasNext())
        linkHits << lit.next();
    QVector<QRegularExpressionMatch> snipHits;
    auto sit = snipRe.globalMatch(html);
    while (sit.hasNext())
        snipHits << sit.next();
    QStringList seen;
    QStringList auditLines;
    auditLines << QStringLiteral("\\ Web search: %1").arg(query);
    QString block = QStringLiteral(
                        "Web search results (fetched by EditForthWin via DuckDuckGo Lite for query \"%1\"; "
                        "prefer these when relevant; verify before inventing URLs):\n")
                        .arg(query);
    int n = 0;
    for (int i = 0; i < linkHits.size() && n < 5; ++i) {
        const QString attrs = linkHits.at(i).captured(1);
        const auto href = hrefRe.match(attrs);
        if (!href.hasMatch())
            continue;
        QString url = href.captured(1).trimmed();
        const int uddg = url.indexOf(QStringLiteral("uddg="));
        if (uddg >= 0) {
            QString enc = url.mid(uddg + 5);
            const int amp = enc.indexOf(QLatin1Char('&'));
            if (amp >= 0)
                enc.truncate(amp);
            const QString decoded = QUrl::fromPercentEncoding(enc.toUtf8());
            if (decoded.startsWith(QStringLiteral("http")))
                url = decoded;
        }
        if (!url.startsWith(QStringLiteral("http")) || seen.contains(url))
            continue;
        seen << url;
        QString title = stripTags(linkHits.at(i).captured(2)).simplified();
        if (title.isEmpty())
            continue;
        QString snippet;
        if (i < snipHits.size())
            snippet = stripTags(snipHits.at(i).captured(1)).simplified().left(400);
        ++n;
        block += QStringLiteral("\n%1. %2\n   %3\n").arg(n).arg(title, url);
        if (!snippet.isEmpty())
            block += QStringLiteral("   %1\n").arg(snippet);
        auditLines << QStringLiteral("\\   %1 — %2").arg(url, title);
    }
    if (n == 0) {
        *note = error.isEmpty() ? QStringLiteral(" · Search: no hits")
                                : QStringLiteral(" · Search: %1").arg(error);
        return {};
    }
    *audit = auditLines.join(QLatin1Char('\n'));
    *note = QStringLiteral(" · Search %1 hit(s)").arg(n);
    return block;
}

AskForthPanel::Worker::Chat AskForthPanel::Worker::chat(const QVariantMap &job, const QJsonArray &messages,
                                                       const QJsonArray &tools, bool stream) {
    Chat out;
    ensureNam();
    const QString provider = job.value(QStringLiteral("provider")).toString();
    const QString model = job.value(QStringLiteral("model")).toString();
    const QString base = job.value(QStringLiteral("base")).toString();
    const double temperature = job.value(QStringLiteral("temperature")).toDouble();
    QJsonObject body;
    body.insert(QStringLiteral("model"), model);
    body.insert(QStringLiteral("stream"), stream);
    body.insert(QStringLiteral("messages"), messages);
    body.insert(QStringLiteral("temperature"), temperature);
    if (!tools.isEmpty())
        body.insert(QStringLiteral("tools"), tools);
    QNetworkRequest req;
    req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));
    req.setTransferTimeout(600000);
    if (provider == QLatin1String("ollama")) {
        QJsonObject options;
        options.insert(QStringLiteral("num_predict"), kMaxTokens);
        options.insert(QStringLiteral("temperature"), temperature);
        body.insert(QStringLiteral("options"), options);
        req.setUrl(QUrl(joinUrl(base, QStringLiteral("/api/chat"))));
    } else {
        const QString key = job.value(QStringLiteral("key")).toString();
        if (key.isEmpty()) {
            out.error = QStringLiteral("no API key — set one in Ask Forth or export XAI_API_KEY");
            return out;
        }
        body.insert(QStringLiteral("max_tokens"), kMaxTokens);
        req.setUrl(QUrl(joinUrl(base, QStringLiteral("/chat/completions"))));
        req.setRawHeader("Authorization", QByteArray("Bearer ") + key.toUtf8());
    }
    QNetworkReply *reply = m_nam->post(req, QJsonDocument(body).toJson(QJsonDocument::Compact));
    m_reply = reply;
    QEventLoop loop;
    m_loop = &loop;
    QByteArray pending;
    QString assembled;
    QJsonArray calls;
    const auto takeLine = [&](QByteArray line) {
        line = line.trimmed();
        if (line.isEmpty())
            return;
        if (provider != QLatin1String("ollama")) {
            if (line.startsWith("data:")) {
                line = line.mid(5).trimmed();
                if (line == "[DONE]")
                    return;
            } else if (stream) {
                return;
            }
        }
        const QJsonObject obj = QJsonDocument::fromJson(line).object();
        if (provider == QLatin1String("ollama")) {
            const QJsonObject message = obj.value(QStringLiteral("message")).toObject();
            assembled += message.value(QStringLiteral("content")).toString();
            const QJsonArray raw = message.value(QStringLiteral("tool_calls")).toArray();
            for (const QJsonValue &v : raw)
                calls.append(v);
        } else {
            const QJsonArray choices = obj.value(QStringLiteral("choices")).toArray();
            if (choices.isEmpty())
                return;
            const QJsonObject delta = choices.at(0).toObject().value(QStringLiteral("delta")).toObject();
            const QJsonObject message = choices.at(0).toObject().value(QStringLiteral("message")).toObject();
            const QJsonObject src = delta.isEmpty() ? message : delta;
            assembled += src.value(QStringLiteral("content")).toString();
            const QJsonArray raw = src.value(QStringLiteral("tool_calls")).toArray();
            for (const QJsonValue &v : raw)
                calls.append(v);
        }
    };
    if (stream) {
        QObject::connect(reply, &QNetworkReply::readyRead, &loop, [&] {
            pending += reply->readAll();
            int nl = pending.indexOf('\n');
            while (nl >= 0) {
                takeLine(pending.left(nl));
                pending = pending.mid(nl + 1);
                nl = pending.indexOf('\n');
                if (!assembled.isEmpty())
                    emit bodyChanged(assembled);
            }
        });
    }
    QTimer timer;
    timer.setSingleShot(true);
    QObject::connect(&timer, &QTimer::timeout, &loop, [&] {
        reply->abort();
        loop.quit();
    });
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    timer.start(600000);
    loop.exec();
    m_loop = nullptr;
    m_reply = nullptr;
    pending += reply->readAll();
    if (!stream)
        takeLine(pending);
    else if (!pending.trimmed().isEmpty())
        takeLine(pending);
    const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    const QString errBody = QString::fromUtf8(pending.left(500));
    if (reply->error() != QNetworkReply::NoError && !m_cancel.load() && assembled.isEmpty()) {
        QString detail = reply->errorString();
        const QJsonObject err = QJsonDocument::fromJson(pending).object().value(QStringLiteral("error")).toObject();
        if (!err.value(QStringLiteral("message")).toString().isEmpty())
            detail = err.value(QStringLiteral("message")).toString();
        if (status > 0)
            out.error = QStringLiteral("Model request failed (HTTP %1): %2").arg(status).arg(detail.left(180));
        else
            out.error = QStringLiteral("Cannot reach the language model (%1).").arg(detail);
    }
    reply->deleteLater();
    Q_UNUSED(errBody);
    out.content = assembled;
    out.calls = calls;
    return out;
}

QString AskForthPanel::Worker::runTools(const QVariantMap &job, const QString &system, const QString &user,
                                       QString *note, QString *audit) {
    QJsonArray tools;
    const auto addTool = [&](const QString &name, const QString &desc, const QString &prop) {
        QJsonObject parameters;
        parameters.insert(QStringLiteral("type"), QStringLiteral("object"));
        QJsonObject properties;
        QJsonObject field;
        field.insert(QStringLiteral("type"), QStringLiteral("string"));
        properties.insert(prop, field);
        parameters.insert(QStringLiteral("properties"), properties);
        parameters.insert(QStringLiteral("required"), QJsonArray{prop});
        QJsonObject fn;
        fn.insert(QStringLiteral("name"), name);
        fn.insert(QStringLiteral("description"), desc);
        fn.insert(QStringLiteral("parameters"), parameters);
        QJsonObject tool;
        tool.insert(QStringLiteral("type"), QStringLiteral("function"));
        tool.insert(QStringLiteral("function"), fn);
        tools.append(tool);
    };
    addTool(QStringLiteral("web_search"), QStringLiteral("Search the web and return titles, URLs, and snippets."),
            QStringLiteral("query"));
    addTool(QStringLiteral("fetch_url"), QStringLiteral("Fetch one http(s) page and return plain text."),
            QStringLiteral("url"));
    addTool(QStringLiteral("library_search"),
            QStringLiteral("Search the Forth Library and Reference for excerpts."), QStringLiteral("query"));

    QJsonArray messages;
    if (!system.trimmed().isEmpty()) {
        QJsonObject sys;
        sys.insert(QStringLiteral("role"), QStringLiteral("system"));
        sys.insert(QStringLiteral("content"), system);
        messages.append(sys);
    }
    QJsonObject userMsg;
    userMsg.insert(QStringLiteral("role"), QStringLiteral("user"));
    userMsg.insert(QStringLiteral("content"), user);
    messages.append(userMsg);

    QString transcript;
    int calls = 0;
    QString last;
    for (int round = 0; round < 4; ++round) {
        if (m_cancel.load())
            return last;
        emit statusText(QStringLiteral("Tool agent round %1…").arg(round + 1));
        const Chat result = chat(job, messages, tools, false);
        if (!result.error.isEmpty()) {
            *note = QStringLiteral(" · Tools: %1").arg(result.error);
            return last;
        }
        if (result.calls.isEmpty()) {
            last = result.content;
            emit bodyChanged(last);
            break;
        }
        QJsonArray encoded;
        QJsonArray ids;
        for (const QJsonValue &v : result.calls) {
            const QJsonObject entry = v.toObject();
            const QJsonObject fn = entry.value(QStringLiteral("function")).toObject();
            const QString name = fn.value(QStringLiteral("name")).toString();
            QString args = fn.value(QStringLiteral("arguments")).toString();
            if (args.isEmpty() && fn.value(QStringLiteral("arguments")).isObject())
                args = QString::fromUtf8(QJsonDocument(fn.value(QStringLiteral("arguments")).toObject())
                                             .toJson(QJsonDocument::Compact));
            QString argText = args;
            const QJsonObject argObj = QJsonDocument::fromJson(args.toUtf8()).object();
            const QString query = argObj.value(QStringLiteral("query")).toString();
            const QString url = argObj.value(QStringLiteral("url")).toString();
            if (!query.isEmpty())
                argText = query;
            else if (!url.isEmpty())
                argText = url;
            transcript += QStringLiteral("→ %1(%2)\n").arg(name, argText.left(160));
            QString toolResult;
            if (name == QLatin1String("web_search")) {
                QString unusedAudit;
                QString unusedNote;
                toolResult = searchWeb(query.isEmpty() ? argText : query, &unusedAudit, &unusedNote);
            } else if (name == QLatin1String("fetch_url")) {
                QString error;
                toolResult = fetchPage(url.isEmpty() ? argText : url, &error);
                if (toolResult.isEmpty())
                    toolResult = error;
            } else if (name == QLatin1String("library_search")) {
                QString libNote;
                toolResult = libraryBlock(job.value(QStringLiteral("folder")).toString(),
                                           query.isEmpty() ? argText : query, 8, 8000,
                                           job.value(QStringLiteral("mode")).toString(),
                                           job.value(QStringLiteral("lines")).toInt(), &libNote, m_cancel, net());
            } else {
                toolResult = QStringLiteral("unknown tool");
            }
            if (toolResult.size() > 8000)
                toolResult.truncate(8000);
            transcript += QStringLiteral("← %1\n").arg(toolResult.left(240));
            ++calls;
            QJsonObject call;
            call.insert(QStringLiteral("result"), toolResult);
            call.insert(QStringLiteral("id"), entry.value(QStringLiteral("id")).toString(QStringLiteral("call_") + name));
            call.insert(QStringLiteral("name"), name);
            call.insert(QStringLiteral("arguments"), args.isEmpty() ? QStringLiteral("{}") : args);
            encoded.append(call);
        }
        emit toolLog(transcript);
        const QString provider = job.value(QStringLiteral("provider")).toString();
        QJsonObject assistant;
        assistant.insert(QStringLiteral("role"), QStringLiteral("assistant"));
        assistant.insert(QStringLiteral("content"), result.content);
        QJsonArray wireCalls;
        for (const QJsonValue &v : encoded) {
            const QJsonObject c = v.toObject();
            QJsonObject fn;
            fn.insert(QStringLiteral("name"), c.value(QStringLiteral("name")));
            if (provider == QLatin1String("ollama")) {
                const QJsonObject args = QJsonDocument::fromJson(c.value(QStringLiteral("arguments")).toString().toUtf8()).object();
                fn.insert(QStringLiteral("arguments"), args);
            } else {
                fn.insert(QStringLiteral("arguments"), c.value(QStringLiteral("arguments")).toString());
            }
            QJsonObject wire;
            wire.insert(QStringLiteral("type"), QStringLiteral("function"));
            wire.insert(QStringLiteral("id"), c.value(QStringLiteral("id")));
            wire.insert(QStringLiteral("function"), fn);
            wireCalls.append(wire);
        }
        assistant.insert(QStringLiteral("tool_calls"), wireCalls);
        messages.append(assistant);
        for (const QJsonValue &v : encoded) {
            const QJsonObject c = v.toObject();
            QJsonObject tool;
            tool.insert(QStringLiteral("role"), QStringLiteral("tool"));
            tool.insert(QStringLiteral("name"), c.value(QStringLiteral("name")));
            tool.insert(QStringLiteral("tool_call_id"), c.value(QStringLiteral("id")));
            tool.insert(QStringLiteral("content"), c.value(QStringLiteral("result")).toString());
            messages.append(tool);
        }
        last = result.content;
        Q_UNUSED(ids);
    }
    QStringList auditLines;
    auditLines << QStringLiteral("\\ Tool agent: %1 call(s)").arg(calls);
    const QStringList steps = transcript.split(QLatin1Char('\n'));
    for (const QString &step : steps) {
        if (step.startsWith(QStringLiteral("→ ")))
            auditLines << QStringLiteral("\\   %1").arg(step.mid(2).left(120));
    }
    *audit = auditLines.join(QLatin1Char('\n'));
    *note = QStringLiteral(" · Tools %1 call(s)").arg(calls);
    return last;
}

void AskForthPanel::Worker::start(const QVariant &payload) {
    m_cancel.store(false);
    const QVariantMap job = payload.toMap();
    const QString kind = job.value(QStringLiteral("kind")).toString();
    if (kind == QLatin1String("agent")) {
        const QString exe = job.value(QStringLiteral("exe")).toString();
        const QString source = job.value(QStringLiteral("source")).toString();
        if (exe.isEmpty() || !QFileInfo::exists(exe)) {
            emit failed(QStringLiteral("Could not find forth executable for --agent."));
            return;
        }
        const QString temp = QDir::temp().filePath(
            QStringLiteral("editforth-ask-%1.fth").arg(QUuid::createUuid().toString(QUuid::WithoutBraces)));
        QFile file(temp);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
            emit failed(QStringLiteral("Could not write the agent source file."));
            return;
        }
        file.write(source.toUtf8());
        file.close();
        QProcess proc;
        m_proc = &proc;
        proc.setProgram(exe);
        proc.setWorkingDirectory(job.value(QStringLiteral("dir")).toString());
        proc.setArguments({QStringLiteral("--agent"), QStringLiteral("-c"),
                           job.value(QStringLiteral("dir")).toString(), QStringLiteral("-f"), temp});
        proc.setProcessChannelMode(QProcess::MergedChannels);
        proc.start();
        proc.closeWriteChannel();
        if (!proc.waitForStarted(5000)) {
            m_proc = nullptr;
            QFile::remove(temp);
            emit failed(QStringLiteral("Failed to launch --agent (%1).").arg(proc.errorString()));
            return;
        }
        const int slice = 200;
        int waited = 0;
        while (proc.state() != QProcess::NotRunning && waited < 120000 && !m_cancel.load()) {
            proc.waitForFinished(slice);
            waited += slice;
            QCoreApplication::processEvents();
        }
        if (proc.state() != QProcess::NotRunning)
            proc.kill();
        proc.waitForFinished(2000);
        m_proc = nullptr;
        QFile::remove(temp);
        if (m_cancel.load()) {
            emit failed(QStringLiteral("cancelled"));
            return;
        }
        const QString transcript = QString::fromUtf8(proc.readAll()).trimmed();
        emit agentDone(transcript.isEmpty() ? QStringLiteral("(no transcript, exit %1)").arg(proc.exitCode())
                                            : transcript,
                       proc.exitCode());
        return;
    }

    const QString provider = job.value(QStringLiteral("provider")).toString();
    const QString base = job.value(QStringLiteral("base")).toString();
    emit statusText(provider == QLatin1String("ollama") ? QStringLiteral("Checking Ollama…")
                                                        : QStringLiteral("Checking the model server…"));
    QString error;
    int status = 0;
    if (provider == QLatin1String("ollama")) {
        QNetworkRequest ping{QUrl(joinUrl(base, QStringLiteral("/api/tags")))};
        ping.setTransferTimeout(2000);
        http(ping, QByteArray(), 2000, &status, &error);
        if (m_cancel.load()) {
            emit failed(QStringLiteral("cancelled"));
            return;
        }
        if (status != 200) {
            emit failed(QStringLiteral("Ollama is not reachable at 127.0.0.1:11434."));
            return;
        }
    } else {
        if (job.value(QStringLiteral("key")).toString().isEmpty()) {
            emit failed(QStringLiteral("No API key — open Models…, paste a key, and click Save (or export XAI_API_KEY)."));
            return;
        }
        QNetworkRequest ping{QUrl(joinUrl(base, QStringLiteral("/models")))};
        ping.setRawHeader("Authorization", QByteArray("Bearer ") + job.value(QStringLiteral("key")).toString().toUtf8());
        ping.setTransferTimeout(10000);
        http(ping, QByteArray(), 10000, &status, &error);
        if (m_cancel.load()) {
            emit failed(QStringLiteral("cancelled"));
            return;
        }
        if (status == 0) {
            emit failed(QStringLiteral("Cannot reach %1 (network). Check Base URL in Models… and connectivity.").arg(base));
            return;
        }
    }

    QString note;
    QString audit;
    QString context;
    const bool tools = job.value(QStringLiteral("tools")).toBool();
    const QString urlSource = job.value(QStringLiteral("urlSource")).toString();
    if (!tools && job.value(QStringLiteral("urls")).toBool()) {
        const QStringList urls = extractUrls(urlSource);
        if (!urls.isEmpty()) {
            emit statusText(QStringLiteral("Fetching URLs…"));
            QString block = QStringLiteral(
                "Web page context (fetched by EditForthWin from Prompt URLs; prefer facts from these pages when relevant):\n");
            int pages = 0;
            for (const QString &url : urls) {
                if (m_cancel.load()) {
                    emit failed(QStringLiteral("cancelled"));
                    return;
                }
                QString pageError;
                const QString page = fetchPage(url, &pageError);
                if (page.isEmpty())
                    continue;
                block += QStringLiteral("\n--- %1 ---\n%2\n").arg(url, page);
                ++pages;
            }
            if (pages > 0)
                context += block + QStringLiteral("\n");
            note += pages > 0 ? QStringLiteral(" · Web %1 page(s)").arg(pages)
                              : QStringLiteral(" · Web: fetch error(s)");
        }
    }
    if (!tools && job.value(QStringLiteral("web")).toBool()) {
        emit statusText(QStringLiteral("Searching the web…"));
        QString webAudit;
        QString webNote;
        const QString block = searchWeb(urlSource, &webAudit, &webNote);
        if (!block.isEmpty())
            context += block + QStringLiteral("\n");
        if (!webAudit.isEmpty())
            audit = webAudit;
        note += webNote;
    }
    bool searched = false;
    bool hits = false;
    if (job.value(QStringLiteral("library")).toBool()) {
        searched = true;
        emit statusText(QStringLiteral("Searching Library…"));
        QString libNote;
        const QString block = libraryBlock(job.value(QStringLiteral("folder")).toString(),
                                            job.value(QStringLiteral("rag")).toString(),
                                            job.value(QStringLiteral("snippets")).toInt(),
                                            job.value(QStringLiteral("chars")).toInt(),
                                            job.value(QStringLiteral("mode")).toString(),
                                            job.value(QStringLiteral("lines")).toInt(), &libNote, m_cancel, net());
        if (m_cancel.load()) {
            emit failed(QStringLiteral("cancelled"));
            return;
        }
        if (!block.isEmpty()) {
            context += block + QStringLiteral("\n");
            hits = true;
        }
        note += libNote;
    }
    if (!audit.isEmpty())
        emit auditReady(audit);

    QString system = job.value(QStringLiteral("system")).toString();
    if (searched && hits) {
        system += QStringLiteral(
            "\n\nLibrary context was retrieved for this request (Sample and/or Forth-2012 Reference excerpts).\n"
            "Ground your answer in that context: use the cited stack effects, word names, and sample idioms.\n"
            "Prefer quoting or paraphrasing stack diagrams from Reference over guessing.\n"
            "If the user asks for something not supported by the Library excerpts, say "
            "\"Not found in the provided Library context\" for that part, and label any extra suggestion clearly as unverified.\n"
            "When citing, mention path:line from the Library headers when helpful.");
    } else if (searched) {
        system += QStringLiteral(
            "\n\nLibrary search ran but returned no matching excerpts for this prompt.\n"
            "Do not invent standard stack effects or Library APIs. Say that Library context had no hits, "
            "give only carefully labeled general Forth advice, and prefer \"I don't know / not in Library\" "
            "over fabricating EditForthWin words.");
    }
    QString user = job.value(QStringLiteral("user")).toString();
    if (hits) {
        user = context +
               QStringLiteral("Instructions for this answer:\n"
                              "- Use the Library context above as the source of truth for word names and stack effects.\n"
                              "- If a needed fact is missing from that context, say it is not in the provided sources instead of inventing it.\n"
                              "- Put loadable Forth in a ```forth block when you provide code.\n\nUser request:\n") +
               user;
    } else if (searched) {
        const QString reminder = QStringLiteral(
            "Instructions for this answer:\n"
            "- Library search found no excerpts for this prompt.\n"
            "- Do not invent ANS/EditForthWin stack effects or APIs. Prefer saying you lack Library backing over fabricating a solution.\n\n");
        user = context + reminder + QStringLiteral("User request:\n") + user;
    } else if (!context.isEmpty()) {
        user = context + QStringLiteral("User request:\n") + user;
    }

    const QString fileName = job.value(QStringLiteral("file")).toString();
    emit statusText(tools ? QStringLiteral("Tool agent → %1…").arg(fileName)
                          : QStringLiteral("Streaming into %1…").arg(fileName));
    QString full;
    QString toolAudit;
    QString toolNote;
    if (tools) {
        full = runTools(job, system, user, &toolNote, &toolAudit);
        note += toolNote;
        if (!toolAudit.isEmpty())
            emit auditReady(toolAudit);
    } else {
        QJsonArray messages;
        if (!system.trimmed().isEmpty()) {
            QJsonObject sys;
            sys.insert(QStringLiteral("role"), QStringLiteral("system"));
            sys.insert(QStringLiteral("content"), system);
            messages.append(sys);
        }
        QJsonObject msg;
        msg.insert(QStringLiteral("role"), QStringLiteral("user"));
        msg.insert(QStringLiteral("content"), user);
        messages.append(msg);
        const Chat result = chat(job, messages, QJsonArray(), true);
        if (m_cancel.load()) {
            emit failed(QStringLiteral("cancelled"));
            return;
        }
        if (!result.error.isEmpty()) {
            emit failed(result.error);
            return;
        }
        full = result.content;
    }
    if (m_cancel.load()) {
        emit failed(QStringLiteral("cancelled"));
        return;
    }
    if (full.trimmed().isEmpty()) {
        emit failed(QStringLiteral("The model returned an empty reply."));
        return;
    }
    emit bodyChanged(full);
    emit finished(full.trimmed(), note);
}

namespace {

struct LibraryOpts {
    QString folder;
    int snippets = 12;
    int lines = 12;
    int chars = 16000;
    QString mode = QStringLiteral("hybrid");
};

LibraryOpts libraryOpts() {
    QSettings settings;
    LibraryOpts opts;
    opts.folder = settings.value(QStringLiteral("aiAssistantLibraryFolder"), defaultLibrary()).toString().trimmed();
    if (opts.folder.isEmpty())
        opts.folder = defaultLibrary();
    opts.snippets = qBound(1, settings.value(QStringLiteral("aiAssistantLibraryMaxSnippets"), 12).toInt(), 40);
    opts.lines = qBound(2, settings.value(QStringLiteral("aiAssistantLibraryContextLines"), 12).toInt(), 40);
    opts.chars = qBound(2000, settings.value(QStringLiteral("aiAssistantLibraryMaxChars"), 16000).toInt(), 64000);
    opts.mode = settings.value(QStringLiteral("aiAssistantLibraryRetrieveMode"), QStringLiteral("hybrid")).toString();
    if (opts.mode != QLatin1String("keyword") && opts.mode != QLatin1String("semantic"))
        opts.mode = QStringLiteral("hybrid");
    return opts;
}

void saveLibraryOpts(const LibraryOpts &opts) {
    QSettings settings;
    settings.setValue(QStringLiteral("aiAssistantLibraryFolder"), opts.folder);
    settings.setValue(QStringLiteral("aiAssistantLibraryMaxSnippets"), opts.snippets);
    settings.setValue(QStringLiteral("aiAssistantLibraryContextLines"), opts.lines);
    settings.setValue(QStringLiteral("aiAssistantLibraryMaxChars"), opts.chars);
    settings.setValue(QStringLiteral("aiAssistantLibraryRetrieveMode"), opts.mode);
}

QString leafName(const QString &path) {
    const QString leaf = QFileInfo(path).fileName();
    return leaf.isEmpty() ? QStringLiteral("Library") : leaf;
}

} // namespace

AskForthPanel::AskForthPanel(QWidget *parent) : QWidget(parent) {
    setMinimumWidth(280);
    m_nam = new QNetworkAccessManager(this);
    m_paint = new QTimer(this);
    m_paint->setSingleShot(true);
    m_paint->setInterval(40);
    connect(m_paint, &QTimer::timeout, this, [this] {
        if (m_bodyDirty && !m_stopped)
            applyStreamBody(m_pendingBody);
        m_bodyDirty = false;
    });
    m_thread = new QThread(this);
    m_worker = new Worker;
    m_worker->moveToThread(m_thread);
    connect(m_worker, &Worker::statusText, this, [this](const QString &text) {
        if (!m_stopped)
            setStatus(text);
    });
    connect(m_worker, &Worker::bodyChanged, this, [this](const QString &full) {
        if (m_stopped)
            return;
        m_reply = full;
        m_pendingBody = full;
        m_bodyDirty = true;
        if (m_phase == QLatin1String("ask"))
            m_ask->setText(QStringLiteral("Streaming…"));
        if (!m_paint->isActive())
            m_paint->start();
    });
    connect(m_worker, &Worker::auditReady, this, [this](const QString &comments) {
        if (!m_stopped)
            insertAudit(comments);
    });
    connect(m_worker, &Worker::toolLog, this, [this](const QString &text) {
        m_transcript->setPlainText(text);
    });
    connect(m_worker, &Worker::agentDone, this, [this](const QString &transcript, int code) {
        if (m_stopped)
            return;
        m_transcript->setPlainText(transcript);
        setStatus(QStringLiteral("Agent exit %1 — enhancing…").arg(code));
        startEnhance(transcript);
    });
    connect(m_worker, &Worker::finished, this, [this](const QString &full, const QString &note) {
        if (m_stopped)
            return;
        m_reply = full;
        m_paint->stop();
        applyStreamBody(full);
        saveAskFile();
        const QString name = QFileInfo(m_askPath).fileName();
        const QString done = m_phase == QLatin1String("enhance")
                                 ? QStringLiteral("Agent Enhanced Reply appended.")
                                 : QStringLiteral("Done.");
        setBusy(false, QStringLiteral("Ask"));
        setStatus(done + QStringLiteral(" · %1").arg(name) + note);
    });
    connect(m_worker, &Worker::failed, this, [this](const QString &message) {
        if (m_stopped || message == QLatin1String("cancelled"))
            return;
        m_paint->stop();
        if (!m_reply.isEmpty())
            applyStreamBody(m_reply);
        saveAskFile();
        setBusy(false, QStringLiteral("Ask"));
        setStatus(message);
    });
    m_thread->start();
    buildUi();
    m_indexThread = new QThread(this);
    m_indexer = new AskForthIndexer;
    m_indexer->moveToThread(m_indexThread);
    AskForthEmbed::attachIndexer(m_indexer);
    connect(m_indexer, &AskForthIndexer::activity, this, [this](const QString &text, bool busy) {
        if (busy) {
            m_indexNote = text;
            if (!text.trimmed().isEmpty())
                setBanner(text);
            return;
        }
        m_indexNote.clear();
        if (text.trimmed().isEmpty())
            refreshBanner();
        else
            setBanner(text);
    });
    m_indexThread->start();
    reloadProfiles();
}

AskForthPanel::~AskForthPanel() {
    if (m_thread != nullptr && m_thread->isRunning()) {
        QMetaObject::invokeMethod(m_worker, "cancel", Qt::QueuedConnection);
        m_thread->quit();
        m_thread->wait(8000);
    }
    delete m_worker;
    m_worker = nullptr;
    if (m_indexThread != nullptr && m_indexThread->isRunning()) {
        QMetaObject::invokeMethod(m_indexer, "cancel", Qt::QueuedConnection);
        m_indexThread->quit();
        m_indexThread->wait(8000);
    }
    AskForthEmbed::attachIndexer(nullptr);
    delete m_indexer;
    m_indexer = nullptr;
}

// Default height matches the old fixed Prompt. The real minimum is lower so the
// splitter between Ask and EditForthWin Agent can shrink it.
class PromptBox : public QPlainTextEdit {
public:
    explicit PromptBox(QWidget *parent) : QPlainTextEdit(parent) {}
    QSize sizeHint() const override { return QSize(200, 72); }
    QSize minimumSizeHint() const override { return QSize(80, 36); }
};

void AskForthPanel::showEvent(QShowEvent *event) {
    QWidget::showEvent(event);
    if (m_promptSplitReady || m_promptSplit == nullptr)
        return;
    QTimer::singleShot(0, this, [this] {
        if (m_promptSplitReady || m_promptSplit == nullptr)
            return;
        const int total = m_promptSplit->height();
        if (total < 160)
            return;
        m_promptSplitReady = true;
        const QByteArray state = QSettings().value(QStringLiteral("aiAssistantPromptSplit")).toByteArray();
        if (!state.isEmpty() && m_promptSplit->restoreState(state))
            return;
        const int top = qBound(120, 156, total - 140);
        m_promptSplit->setSizes({top, total - top});
    });
}

void AskForthPanel::buildUi() {
    // 2.15 text lines. Only the top document margin is added: a bottom margin
    // would show more of the next line.
    const auto helpBoxHeight = [](QPlainTextEdit *edit) {
        edit->ensurePolished();
        const int text = qRound(edit->fontMetrics().lineSpacing() * 2.15);
        const int top = qRound(edit->document()->documentMargin());
        int frame = edit->frameWidth();
        if (frame < 1)
            frame = edit->style()->pixelMetric(QStyle::PM_DefaultFrameWidth, nullptr, edit);
        return text + top + frame * 2;
    };
    auto *help = new QPlainTextEdit(this);
    help->setReadOnly(true);
    help->setFrameShape(QFrame::StyledPanel);
    help->setPlainText(QStringLiteral(
        "Type a Prompt and click Ask. The reply streams into Documents/EditForthWin/AskForth/AskForth-N.fth. "
        "Then click Agent Enhance Reply to append a second section. Library defaults to Library/Sample.\n\n"
        "Local Ask needs Ollama (https://ollama.com) and a chat model: ollama pull gemma4:e4b. "
        "SpaceXAI uses Models… and the XAI_API_KEY environment variable, or a key saved for that profile. "
        "Hybrid and Semantic Library search uses nomic-embed-text on local Ollama. Until that index is ready, the status line says keyword (no embed index)."));
    help->setLineWrapMode(QPlainTextEdit::WidgetWidth);
    help->setFixedHeight(helpBoxHeight(help));

    auto *title = new QLabel(QStringLiteral("Ask Forth"), this);
    QFont titleFont = title->font();
    titleFont.setBold(true);
    titleFont.setPointSize(titleFont.pointSize() + 1);
    title->setFont(titleFont);

    m_banner = new QLabel(this);
    m_banner->setWordWrap(true);
    m_banner->setStyleSheet(QStringLiteral("color: #9a4d00; background: #fff1e0; padding: 6px;"));
    m_banner->hide();

    m_models = new QComboBox(this);
    auto *models = new QPushButton(QStringLiteral("Models…"), this);
    connect(models, &QPushButton::clicked, this, &AskForthPanel::editModels);
    connect(m_models, qOverload<int>(&QComboBox::activated), this, &AskForthPanel::selectProfile);
    m_caption = new QLabel(this);
    m_caption->setWordWrap(true);

    m_library = new QCheckBox(QStringLiteral("Include Library context"), this);
    m_libraryButton = new QPushButton(this);
    m_urls = new QCheckBox(QStringLiteral("Fetch URLs in Prompt"), this);
    m_web = new QCheckBox(QStringLiteral("Include web search"), this);
    m_tools = new QCheckBox(QStringLiteral("Tool agent"), this);
    m_library->setToolTip(QStringLiteral(
        "Search Library/Sample plus Library/Reference. Hybrid and Semantic use a local nomic-embed-text index."));
    m_urls->setToolTip(QStringLiteral("Fetch http(s) links in the Prompt and add the page text. Ignored while Tool agent is on."));
    m_web->setToolTip(QStringLiteral("Search DuckDuckGo Lite. Default off. Ignored while Tool agent is on."));
    m_tools->setToolTip(QStringLiteral(
        "Let the model call web_search, fetch_url, or library_search. Needs a tools-capable model."));

    QSettings settings;
    m_library->setChecked(settings.value(QStringLiteral("aiAssistantIncludeLibrary"), true).toBool());
    m_urls->setChecked(settings.value(QStringLiteral("aiAssistantFetchURLs"), true).toBool());
    m_web->setChecked(settings.value(QStringLiteral("aiAssistantWebSearch"), false).toBool());
    m_tools->setChecked(settings.value(QStringLiteral("aiAssistantToolAgent"), false).toBool());
    m_web->setEnabled(!m_tools->isChecked());
    const auto persist = [](const QString &key, bool on) { QSettings().setValue(key, on); };
    connect(m_library, &QCheckBox::toggled, this, [=](bool on) {
        persist(QStringLiteral("aiAssistantIncludeLibrary"), on);
        refreshBanner();
    });
    connect(m_urls, &QCheckBox::toggled, this, [=](bool on) {
        persist(QStringLiteral("aiAssistantFetchURLs"), on);
    });
    connect(m_web, &QCheckBox::toggled, this, [=](bool on) {
        persist(QStringLiteral("aiAssistantWebSearch"), on);
    });
    connect(m_tools, &QCheckBox::toggled, this, [this](bool on) {
        QSettings().setValue(QStringLiteral("aiAssistantToolAgent"), on);
        m_web->setEnabled(!on);
    });
    connect(m_libraryButton, &QPushButton::clicked, this, &AskForthPanel::editLibrary);
    m_libraryButton->setText(leafName(libraryOpts().folder) + QStringLiteral("…"));

    m_capture = new QPushButton(QStringLiteral("Capture Selected to Prompt"), this);
    m_capture->setToolTip(QStringLiteral("Copy the editor selection into the Prompt."));
    connect(m_capture, &QPushButton::clicked, this, &AskForthPanel::captureSelection);
    auto *output = new QPushButton(QStringLiteral("Output"), this);
    output->setToolTip(QStringLiteral("Show the Ask Forth output folder."));
    connect(output, &QPushButton::clicked, this, &AskForthPanel::openOutputFolder);

    m_prompt = new PromptBox(this);
    m_prompt->setFont(QFont(QStringLiteral("Consolas"), 10));
    m_prompt->setPlaceholderText(QStringLiteral("Ask a Forth question…"));
    m_prompt->setMinimumHeight(36);
    m_prompt->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    connect(m_prompt, &QPlainTextEdit::textChanged, this, [this] {
        if (!m_busy)
            m_ask->setEnabled(!m_prompt->toPlainText().trimmed().isEmpty());
    });

    m_file = new QLabel(this);
    m_status = new QLabel(QStringLiteral(" "), this);
    m_status->setWordWrap(true);
    m_ask = new QPushButton(QStringLiteral("Ask"), this);
    m_ask->setEnabled(false);
    m_stopAsk = new QPushButton(QStringLiteral("Stop"), this);
    m_stopAsk->hide();
    connect(m_ask, &QPushButton::clicked, this, &AskForthPanel::ask);
    connect(m_stopAsk, &QPushButton::clicked, this, &AskForthPanel::stop);
    auto *askReturn = new QShortcut(QKeySequence(Qt::CTRL | Qt::Key_Return), m_prompt);
    connect(askReturn, &QShortcut::activated, this, &AskForthPanel::ask);

    auto *agentHelp = new QPlainTextEdit(this);
    agentHelp->setReadOnly(true);
    agentHelp->setFrameShape(QFrame::StyledPanel);
    agentHelp->setLineWrapMode(QPlainTextEdit::WidgetWidth);
    agentHelp->setFixedHeight(helpBoxHeight(agentHelp));
    agentHelp->setPlainText(QStringLiteral(
        "Agent Enhance Reply runs the latest reply in a headless EditForthWin --agent with Autoload, "
        "then appends an Agent Enhanced Reply section to the same file. Use INCLUDE on the status strip "
        "to load the edited file into the live console."));
    auto *agentTitle = new QLabel(QStringLiteral("EditForthWin Agent"), this);
    QFont agentFont = agentTitle->font();
    agentFont.setBold(true);
    agentTitle->setFont(agentFont);
    m_enhance = new QPushButton(QStringLiteral("Agent Enhance Reply"), this);
    m_enhance->setEnabled(false);
    m_stopEnhance = new QPushButton(QStringLiteral("Stop"), this);
    m_stopEnhance->hide();
    connect(m_enhance, &QPushButton::clicked, this, &AskForthPanel::enhance);
    connect(m_stopEnhance, &QPushButton::clicked, this, &AskForthPanel::stop);
    m_showTranscript = new QCheckBox(QStringLiteral("Show Agent Transcript"), this);
    m_showTranscript->setChecked(settings.value(QStringLiteral("aiAssistantShowAgentTranscript"), false).toBool());
    m_transcript = new QPlainTextEdit(this);
    m_transcript->setReadOnly(true);
    m_transcript->setFont(QFont(QStringLiteral("Consolas"), 9));
    m_transcriptBox = m_transcript;
    m_transcript->setVisible(m_showTranscript->isChecked());
    connect(m_showTranscript, &QCheckBox::toggled, this, [this](bool on) {
        QSettings().setValue(QStringLiteral("aiAssistantShowAgentTranscript"), on);
        m_transcript->setVisible(on);
    });

    auto *modelRow = new QHBoxLayout;
    modelRow->addWidget(new QLabel(QStringLiteral("Model"), this));
    modelRow->addWidget(m_models, 1);
    modelRow->addWidget(models);
    auto *libRow = new QHBoxLayout;
    libRow->addWidget(m_library, 1);
    libRow->addWidget(m_libraryButton);
    auto *promptRow = new QHBoxLayout;
    promptRow->addWidget(new QLabel(QStringLiteral("Prompt"), this));
    promptRow->addStretch(1);
    promptRow->addWidget(output);
    auto *statusRow = new QHBoxLayout;
    auto *statusCol = new QVBoxLayout;
    statusCol->addWidget(m_file);
    statusCol->addWidget(m_status);
    statusRow->addLayout(statusCol, 1);
    statusRow->addWidget(m_stopAsk);
    statusRow->addWidget(m_ask);
    auto *enhanceRow = new QHBoxLayout;
    enhanceRow->addWidget(m_enhance);
    enhanceRow->addWidget(m_stopEnhance);
    enhanceRow->addWidget(m_showTranscript, 1);

    auto *topPane = new QWidget(this);
    auto *topLayout = new QVBoxLayout(topPane);
    topLayout->setContentsMargins(0, 0, 0, 0);
    topLayout->addLayout(promptRow);
    topLayout->addWidget(m_prompt, 1);
    topLayout->addLayout(statusRow);
    topPane->setMinimumHeight(110);

    auto *bottomPane = new QWidget(this);
    auto *bottomLayout = new QVBoxLayout(bottomPane);
    bottomLayout->setContentsMargins(0, 0, 0, 0);
    bottomLayout->addWidget(agentTitle);
    bottomLayout->addWidget(agentHelp);
    bottomLayout->addLayout(enhanceRow);
    bottomLayout->addWidget(m_transcript, 1);
    bottomPane->setMinimumHeight(120);

    m_promptSplit = new QSplitter(Qt::Vertical, this);
    m_promptSplit->setChildrenCollapsible(false);
    m_promptSplit->setHandleWidth(8);
    m_promptSplit->setStyleSheet(QStringLiteral(
        "QSplitter::handle:vertical { background: palette(mid); }"));
    m_promptSplit->addWidget(topPane);
    m_promptSplit->addWidget(bottomPane);
    m_promptSplit->setStretchFactor(0, 0);
    m_promptSplit->setStretchFactor(1, 1);
    connect(m_promptSplit, &QSplitter::splitterMoved, this, [this] {
        if (m_promptSplit != nullptr)
            QSettings().setValue(QStringLiteral("aiAssistantPromptSplit"), m_promptSplit->saveState());
    });

    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(8, 8, 8, 8);
    box->addWidget(title);
    box->addWidget(help);
    box->addWidget(m_banner);
    box->addLayout(modelRow);
    box->addWidget(m_caption);
    box->addLayout(libRow);
    box->addWidget(m_urls);
    box->addWidget(m_web);
    box->addWidget(m_tools);
    box->addWidget(m_capture);
    box->addWidget(m_promptSplit, 1);

    m_esc = new QShortcut(QKeySequence(Qt::Key_Escape), this);
    m_esc->setContext(Qt::WidgetWithChildrenShortcut);
    m_esc->setEnabled(false);
    connect(m_esc, &QShortcut::activated, this, [this] {
        if (m_busy)
            stop();
    });
}

void AskForthPanel::prepareEnvironment() {
    refreshBanner();
    startIndex(false);
}

void AskForthPanel::startIndex(bool force) {
    const LibraryOpts opts = libraryOpts();
    AskForthEmbed::requestPrepare(opts.folder, opts.mode, force);
}

void AskForthPanel::appendPageUrl(const QString &url) {
    const QString text = url.trimmed();
    if (text.isEmpty())
        return;
    const QString existing = m_prompt->toPlainText().trimmed();
    if (existing.isEmpty())
        m_prompt->setPlainText(text);
    else if (!existing.contains(text))
        m_prompt->setPlainText(existing + QLatin1Char('\n') + text);
    setStatus(QStringLiteral("Added page URL to Prompt."));
}

void AskForthPanel::setForthExeFinder(const std::function<QString()> &finder) { m_exeFinder = finder; }

void AskForthPanel::setFileOpener(const std::function<CodeEdit *(const QString &)> &opener) { m_openFile = opener; }

void AskForthPanel::setSelectionSource(const std::function<QString()> &source) { m_selection = source; }

QString AskForthPanel::activeId() const {
    return m_models == nullptr ? QString() : m_models->currentData().toString();
}

void AskForthPanel::reloadProfiles() {
    const QVector<Profile> list = loadProfiles();
    saveProfiles(list);
    const QString current = QSettings().value(QStringLiteral("aiAssistantActiveProfileID")).toString();
    const QSignalBlocker block(m_models);
    m_models->clear();
    int select = 0;
    for (int i = 0; i < list.size(); ++i) {
        m_models->addItem(list.at(i).name, list.at(i).id);
        if (list.at(i).id == current)
            select = i;
    }
    m_models->setCurrentIndex(select);
    selectProfile(select);
}

void AskForthPanel::selectProfile(int index) {
    const QVector<Profile> list = loadProfiles();
    if (index < 0 || index >= list.size())
        return;
    const Profile &profile = list.at(index);
    QSettings().setValue(QStringLiteral("aiAssistantActiveProfileID"), profile.id);
    QString caption = profile.provider == QLatin1String("ollama") ? QStringLiteral("Ollama")
                                                                  : QStringLiteral("OpenAI-compatible");
    caption += QStringLiteral(" · %1").arg(profile.model);
    if (profile.provider != QLatin1String("ollama"))
        caption += QStringLiteral(" · %1").arg(profile.base);
    caption += QStringLiteral(" · temperature %1").arg(QString::number(profile.temperature, 'f', 2));
    m_caption->setText(caption);
    refreshBanner();
}

void AskForthPanel::setBanner(const QString &text) {
    m_banner->setText(text);
    m_banner->setVisible(!text.trimmed().isEmpty());
}

void AskForthPanel::setStatus(const QString &text) { m_status->setText(text.isEmpty() ? QStringLiteral(" ") : text); }

void AskForthPanel::setBusy(bool busy, const QString &askTitle) {
    m_busy = busy;
    if (!busy)
        m_phase.clear();
    m_ask->setText(askTitle);
    m_ask->setEnabled(!busy && !m_prompt->toPlainText().trimmed().isEmpty());
    m_enhance->setEnabled(!busy && !m_reply.trimmed().isEmpty());
    m_enhance->setText(QStringLiteral("Agent Enhance Reply"));
    m_capture->setEnabled(!busy);
    m_stopAsk->setVisible(busy && m_phase == QLatin1String("ask"));
    m_stopEnhance->setVisible(busy && m_phase != QLatin1String("ask"));
    m_models->setEnabled(!busy);
    if (m_esc != nullptr)
        m_esc->setEnabled(busy);
}

void AskForthPanel::finishBanner(const QString &chat) {
    if (!m_indexNote.trimmed().isEmpty()) {
        setBanner(m_indexNote);
        return;
    }
    const LibraryOpts opts = libraryOpts();
    const bool wantEmbed = m_library != nullptr && m_library->isChecked() && opts.mode != QLatin1String("keyword");
    if (!wantEmbed) {
        setBanner(chat);
        return;
    }
    QNetworkRequest req{QUrl(QStringLiteral("http://127.0.0.1:11434/api/tags"))};
    req.setTransferTimeout(2000);
    QNetworkReply *reply = m_nam->get(req);
    const QString folder = opts.folder;
    connect(reply, &QNetworkReply::finished, this, [this, reply, chat, folder] {
        reply->deleteLater();
        if (!m_indexNote.trimmed().isEmpty()) {
            setBanner(m_indexNote);
            return;
        }
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const bool reachable = reply->error() == QNetworkReply::NoError && status == 200;
        const QByteArray body = reachable ? reply->readAll() : QByteArray();
        QString lib = AskForthEmbed::libraryBanner(folder, reachable, AskForthEmbed::modelNames(body));
        if (!reachable && chat.contains(QStringLiteral("Ollama")))
            lib.clear();
        if (chat.isEmpty())
            setBanner(lib);
        else if (lib.isEmpty())
            setBanner(chat);
        else
            setBanner(chat + QLatin1Char('\n') + lib);
    });
}

void AskForthPanel::refreshBanner() {
    if (!m_indexNote.trimmed().isEmpty()) {
        setBanner(m_indexNote);
        return;
    }
    const QVector<Profile> list = loadProfiles();
    const QString id = activeId();
    Profile profile = list.isEmpty() ? Profile() : list.first();
    for (const Profile &item : list)
        if (item.id == id)
            profile = item;
    if (profile.provider == QLatin1String("ollama")) {
        QNetworkRequest req{QUrl(joinUrl(profile.base.isEmpty() ? QStringLiteral("http://127.0.0.1:11434") : profile.base,
                                        QStringLiteral("/api/tags")))};
        req.setTransferTimeout(2000);
        QNetworkReply *reply = m_nam->get(req);
        const QString model = profile.model;
        connect(reply, &QNetworkReply::finished, this, [this, reply, model] {
            reply->deleteLater();
            if (!m_indexNote.trimmed().isEmpty()) {
                setBanner(m_indexNote);
                return;
            }
            if (reply->error() != QNetworkReply::NoError) {
                finishBanner(QStringLiteral(
                    "Ask Forth needs Ollama. Install from https://ollama.com , start it, then run: ollama pull %1")
                                 .arg(model.isEmpty() ? QStringLiteral("gemma4:e4b") : model));
                return;
            }
            const QJsonArray models = QJsonDocument::fromJson(reply->readAll()).object()
                                          .value(QStringLiteral("models")).toArray();
            bool found = false;
            for (const QJsonValue &v : models) {
                const QString name = v.toObject().value(QStringLiteral("name")).toString();
                if (name == model || name.startsWith(model + QLatin1Char(':')) ||
                    model.startsWith(name + QLatin1Char(':')))
                    found = true;
            }
            if (!found)
                finishBanner(QStringLiteral("Ollama is running, but \"%1\" is not installed. Run: ollama pull %1").arg(model));
            else
                finishBanner(QString());
        });
        return;
    }
    if (resolveKey(profile.id).isEmpty()) {
        finishBanner(QStringLiteral(
            "No API key for this profile. Open Models…, paste a key, and click Save. "
            "Or set XAI_API_KEY before launching the editor."));
        return;
    }
    QNetworkRequest req{QUrl(joinUrl(profile.base, QStringLiteral("/models")))};
    req.setRawHeader("Authorization", QByteArray("Bearer ") + resolveKey(profile.id).toUtf8());
    req.setTransferTimeout(8000);
    QNetworkReply *reply = m_nam->get(req);
    const QString base = profile.base;
    connect(reply, &QNetworkReply::finished, this, [this, reply, base] {
        reply->deleteLater();
        if (!m_indexNote.trimmed().isEmpty()) {
            setBanner(m_indexNote);
            return;
        }
        const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        if (status == 0)
            finishBanner(QStringLiteral("Cannot reach %1. Check Base URL in Models… and the network.").arg(base));
        else
            finishBanner(QString());
    });
}

void AskForthPanel::captureSelection() {
    const QString text = m_selection ? m_selection().trimmed() : QString();
    if (text.isEmpty()) {
        setStatus(QStringLiteral("Select text in the editor first."));
        return;
    }
    m_prompt->setPlainText(text);
    setStatus(QStringLiteral("Using selection (%1 characters).").arg(text.size()));
}

void AskForthPanel::openOutputFolder() {
    QDir().mkpath(askDirectory());
    QDesktopServices::openUrl(QUrl::fromLocalFile(askDirectory()));
}

void AskForthPanel::editLibrary() {
    LibraryOpts opts = libraryOpts();
    QDialog dialog(this);
    dialog.setWindowTitle(QStringLiteral("Ask Forth Library"));
    auto *folder = new QLineEdit(opts.folder, &dialog);
    auto *browse = new QPushButton(QStringLiteral("Browse…"), &dialog);
    connect(browse, &QPushButton::clicked, &dialog, [folder, &dialog] {
        const QString dir = QFileDialog::getExistingDirectory(&dialog, QStringLiteral("Library folder"), folder->text());
        if (!dir.isEmpty())
            folder->setText(dir);
    });
    auto *mode = new QComboBox(&dialog);
    mode->addItem(QStringLiteral("Hybrid"), QStringLiteral("hybrid"));
    mode->addItem(QStringLiteral("Semantic"), QStringLiteral("semantic"));
    mode->addItem(QStringLiteral("Keyword"), QStringLiteral("keyword"));
    const int modeIndex = mode->findData(opts.mode);
    mode->setCurrentIndex(modeIndex < 0 ? 0 : modeIndex);
    auto *snippets = new QSpinBox(&dialog);
    snippets->setRange(1, 40);
    snippets->setValue(opts.snippets);
    auto *lines = new QSpinBox(&dialog);
    lines->setRange(2, 40);
    lines->setValue(opts.lines);
    auto *chars = new QSpinBox(&dialog);
    chars->setRange(2000, 64000);
    chars->setSingleStep(1000);
    chars->setValue(opts.chars);
    auto *note = new QLabel(QStringLiteral(
        "Hybrid blends nomic-embed-text similarity with keyword scores. Semantic uses the embed index only. "
        "Keyword stays on token search. The index is built on local Ollama (~274 MB) and includes Library/Reference. "
        "Until it is ready, Ask falls back to keyword and the status line says so."),
                            &dialog);
    note->setWordWrap(true);
    auto *indexStatus = new QLabel(&dialog);
    indexStatus->setWordWrap(true);
    if (m_indexer != nullptr) {
        connect(m_indexer, &AskForthIndexer::activity, &dialog, [indexStatus](const QString &text, bool) {
            if (!text.trimmed().isEmpty())
                indexStatus->setText(text);
        });
    }
    auto *rebuild = new QPushButton(QStringLiteral("Rebuild Index…"), &dialog);
    rebuild->setToolTip(QStringLiteral(
        "Download nomic-embed-text if it is missing, then re-embed Sample and Reference in the background."));
    auto *folderRow = new QHBoxLayout;
    folderRow->addWidget(folder, 1);
    folderRow->addWidget(browse);
    auto *form = new QFormLayout;
    form->addRow(QStringLiteral("Folder"), folderRow);
    form->addRow(QStringLiteral("Retrieve"), mode);
    form->addRow(QStringLiteral("Max snippets"), snippets);
    form->addRow(QStringLiteral("Context lines"), lines);
    form->addRow(QStringLiteral("Max characters"), chars);
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Save | QDialogButtonBox::Cancel, &dialog);
    connect(buttons, &QDialogButtonBox::accepted, &dialog, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dialog, &QDialog::reject);
    const auto apply = [&] {
        opts.folder = folder->text().trimmed();
        opts.mode = mode->currentData().toString();
        opts.snippets = snippets->value();
        opts.lines = lines->value();
        opts.chars = chars->value();
        saveLibraryOpts(opts);
        m_libraryButton->setText(leafName(opts.folder) + QStringLiteral("…"));
    };
    connect(rebuild, &QPushButton::clicked, &dialog, [&] {
        apply();
        startIndex(true);
    });
    auto *layout = new QVBoxLayout(&dialog);
    layout->addLayout(form);
    layout->addWidget(note);
    layout->addWidget(rebuild);
    layout->addWidget(indexStatus);
    layout->addWidget(buttons);
    if (dialog.exec() != QDialog::Accepted)
        return;
    apply();
    refreshBanner();
    startIndex(false);
}

void AskForthPanel::editModels() {
    QVector<Profile> list = loadProfiles();
    QDialog dialog(this);
    dialog.setWindowTitle(QStringLiteral("Ask Forth models"));
    dialog.resize(640, 420);
    auto *names = new QListWidget(&dialog);
    auto *name = new QLineEdit(&dialog);
    auto *provider = new QComboBox(&dialog);
    provider->addItem(QStringLiteral("Ollama"), QStringLiteral("ollama"));
    provider->addItem(QStringLiteral("OpenAI-compatible"), QStringLiteral("openai"));
    auto *model = new QLineEdit(&dialog);
    auto *base = new QLineEdit(&dialog);
    auto *temperature = new QDoubleSpinBox(&dialog);
    temperature->setRange(0, 2);
    temperature->setDecimals(2);
    temperature->setSingleStep(0.1);
    auto *key = new QLineEdit(&dialog);
    key->setEchoMode(QLineEdit::Password);
    auto *keyStatus = new QLabel(&dialog);
    keyStatus->setWordWrap(true);
    auto *saveKeyButton = new QPushButton(QStringLiteral("Save key"), &dialog);
    auto *clearKey = new QPushButton(QStringLiteral("Clear key"), &dialog);
    auto *add = new QPushButton(QStringLiteral("Add"), &dialog);
    auto *remove = new QPushButton(QStringLiteral("Delete"), &dialog);

    const auto fillList = [&](const QString &selectId) {
        names->clear();
        int select = 0;
        for (int i = 0; i < list.size(); ++i) {
            auto *item = new QListWidgetItem(list.at(i).name);
            item->setData(Qt::UserRole, list.at(i).id);
            names->addItem(item);
            if (list.at(i).id == selectId)
                select = i;
        }
        names->setCurrentRow(select);
    };
    const auto selected = [&]() -> Profile * {
        const int row = names->currentRow();
        if (row < 0 || row >= list.size())
            return nullptr;
        return &list[row];
    };
    const auto showKeyStatus = [&](const Profile &profile) {
        if (profile.provider == QLatin1String("ollama")) {
            keyStatus->setText(QStringLiteral("Ollama does not use an API key."));
            return;
        }
        if (!loadKey(profile.id).isEmpty())
            keyStatus->setText(QStringLiteral("A key is saved in Windows Credential Manager."));
        else if (!qEnvironmentVariable("XAI_API_KEY").trimmed().isEmpty())
            keyStatus->setText(QStringLiteral("No saved key. Ask will use XAI_API_KEY from the environment."));
        else
            keyStatus->setText(QStringLiteral("No key saved."));
    };
    const auto loadForm = [&] {
        Profile *profile = selected();
        if (profile == nullptr)
            return;
        name->setText(profile->name);
        const int providerIndex = provider->findData(profile->provider);
        provider->setCurrentIndex(providerIndex < 0 ? 0 : providerIndex);
        model->setText(profile->model);
        base->setText(profile->base);
        temperature->setValue(profile->temperature);
        key->clear();
        const bool openai = profile->provider == QLatin1String("openai");
        base->setEnabled(openai);
        key->setEnabled(openai);
        saveKeyButton->setEnabled(openai);
        clearKey->setEnabled(openai);
        showKeyStatus(*profile);
    };
    const auto storeForm = [&] {
        Profile *profile = selected();
        if (profile == nullptr)
            return;
        profile->name = name->text().trimmed().isEmpty() ? QStringLiteral("Profile") : name->text().trimmed();
        profile->provider = provider->currentData().toString();
        profile->model = model->text().trimmed();
        profile->base = base->text().trimmed();
        profile->temperature = temperature->value();
        if (names->currentItem() != nullptr)
            names->currentItem()->setText(profile->name);
    };

    connect(names, &QListWidget::currentRowChanged, &dialog, [&](int) {
        loadForm();
    });
    connect(provider, qOverload<int>(&QComboBox::activated), &dialog, [&](int) { storeForm(); loadForm(); });
    connect(add, &QPushButton::clicked, &dialog, [&] {
        storeForm();
        list << makeProfile(QStringLiteral("New profile"), QStringLiteral("ollama"),
                            QStringLiteral("gemma4:e4b"), QStringLiteral("http://127.0.0.1:11434"));
        fillList(list.last().id);
    });
    connect(remove, &QPushButton::clicked, &dialog, [&] {
        if (list.size() < 2)
            return;
        const int row = names->currentRow();
        if (row < 0)
            return;
        deleteKey(list.at(row).id);
        list.removeAt(row);
        fillList(list.first().id);
    });
    connect(saveKeyButton, &QPushButton::clicked, &dialog, [&] {
        Profile *profile = selected();
        if (profile == nullptr)
            return;
        const QString text = key->text().trimmed();
        if (text.isEmpty()) {
            keyStatus->setText(QStringLiteral("Paste a key first."));
            return;
        }
        if (!saveKey(profile->id, text)) {
            keyStatus->setText(QStringLiteral("Could not save the key in Credential Manager."));
            return;
        }
        key->clear();
        showKeyStatus(*profile);
    });
    connect(clearKey, &QPushButton::clicked, &dialog, [&] {
        Profile *profile = selected();
        if (profile == nullptr)
            return;
        deleteKey(profile->id);
        key->clear();
        showKeyStatus(*profile);
    });

    fillList(activeId());
    loadForm();
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Save | QDialogButtonBox::Cancel, &dialog);
    connect(buttons, &QDialogButtonBox::accepted, &dialog, [&] {
        storeForm();
        dialog.accept();
    });
    connect(buttons, &QDialogButtonBox::rejected, &dialog, &QDialog::reject);
    auto *side = new QVBoxLayout;
    side->addWidget(add);
    side->addWidget(remove);
    side->addStretch(1);
    auto *left = new QVBoxLayout;
    left->addWidget(new QLabel(QStringLiteral("Profiles"), &dialog));
    left->addWidget(names, 1);
    left->addLayout(side);
    auto *form = new QFormLayout;
    form->addRow(QStringLiteral("Name"), name);
    form->addRow(QStringLiteral("Provider"), provider);
    form->addRow(QStringLiteral("Model"), model);
    form->addRow(QStringLiteral("Base URL"), base);
    form->addRow(QStringLiteral("Temperature"), temperature);
    form->addRow(QStringLiteral("API key"), key);
    auto *keyRow = new QHBoxLayout;
    keyRow->addWidget(saveKeyButton);
    keyRow->addWidget(clearKey);
    keyRow->addStretch(1);
    auto *right = new QVBoxLayout;
    right->addLayout(form);
    right->addLayout(keyRow);
    right->addWidget(keyStatus);
    right->addStretch(1);
    auto *columns = new QHBoxLayout;
    columns->addLayout(left, 1);
    columns->addLayout(right, 2);
    auto *intro = new QLabel(QStringLiteral(
        "Saved profiles for Ollama and OpenAI-compatible endpoints. SpaceXAI uses base URL "
        "https://api.x.ai/v1 and model grok-4.7. Keys are stored in Windows Credential Manager, not in settings."),
                             &dialog);
    intro->setWordWrap(true);
    auto *layout = new QVBoxLayout(&dialog);
    layout->addWidget(intro);
    layout->addLayout(columns, 1);
    layout->addWidget(buttons);
    if (dialog.exec() != QDialog::Accepted)
        return;
    saveProfiles(list);
    reloadProfiles();
}

Profile AskForthPanel::profileById(const QString &id) const {
    const QVector<Profile> list = loadProfiles();
    for (const Profile &profile : list)
        if (profile.id == id)
            return profile;
    return list.isEmpty() ? Profile() : list.first();
}

void AskForthPanel::applyStreamBody(const QString &full) {
    if (m_edit.isNull())
        return;
    const QString current = m_edit->toPlainText();
    const int start = qBound(0, m_bodyStart, current.size());
    const QString prefix = current.left(start);
    const int cursor = m_edit->textCursor().position();
    const bool follow = cursor >= current.size() - 1;
    m_edit->setPlainText(prefix + wrapToWidth(full, kWrap));
    m_edit->document()->setModified(true);
    QTextCursor caret = m_edit->textCursor();
    caret.setPosition(follow ? m_edit->toPlainText().size() : qMin(cursor, start));
    m_edit->setTextCursor(caret);
    if (follow)
        m_edit->ensureCursorVisible();
    m_file->setText(QStringLiteral("Output: %1").arg(QFileInfo(m_askPath).fileName()));
}

void AskForthPanel::insertAudit(const QString &comments) {
    if (m_edit.isNull() || comments.trimmed().isEmpty())
        return;
    const QString current = m_edit->toPlainText();
    const int start = qBound(0, m_bodyStart, current.size());
    const QString block = comments.trimmed() + QStringLiteral("\n\n");
    m_edit->setPlainText(current.left(start) + block + current.mid(start));
    m_edit->document()->setModified(true);
    m_bodyStart = start + block.size();
}

void AskForthPanel::saveAskFile() {
    if (m_edit.isNull() || m_askPath.isEmpty())
        return;
    QSaveFile file(m_askPath);
    if (!file.open(QIODevice::WriteOnly))
        return;
    file.write(m_edit->toPlainText().toUtf8());
    if (file.commit())
        m_edit->document()->setModified(false);
}

bool AskForthPanel::beginStreamFile(const QString &header) {
    const QString path = nextAskPath();
    QSaveFile file(path);
    if (!file.open(QIODevice::WriteOnly)) {
        setStatus(QStringLiteral("Could not create AskForth file."));
        return false;
    }
    file.write(header.toUtf8());
    if (!file.commit()) {
        setStatus(QStringLiteral("Could not create AskForth file."));
        return false;
    }
    if (!m_openFile) {
        setStatus(QStringLiteral("Could not open AskForth file."));
        return false;
    }
    CodeEdit *edit = m_openFile(path);
    if (edit == nullptr) {
        setStatus(QStringLiteral("Could not open AskForth file."));
        return false;
    }
    m_edit = edit;
    m_askPath = path;
    m_bodyStart = edit->toPlainText().size();
    m_reply.clear();
    m_file->setText(QStringLiteral("Output: %1").arg(QFileInfo(path).fileName()));
    return true;
}

QVariantMap AskForthPanel::jobFor(const Profile &profile, const QString &system, const QString &user,
                                 const QString &rag, bool enhance) const {
    const LibraryOpts opts = libraryOpts();
    QVariantMap job;
    job.insert(QStringLiteral("kind"), QStringLiteral("complete"));
    job.insert(QStringLiteral("provider"), profile.provider);
    job.insert(QStringLiteral("model"), profile.model);
    job.insert(QStringLiteral("base"), profile.base);
    job.insert(QStringLiteral("temperature"), profile.temperature);
    job.insert(QStringLiteral("key"), resolveKey(profile.id));
    job.insert(QStringLiteral("system"), system);
    job.insert(QStringLiteral("user"), user);
    job.insert(QStringLiteral("rag"), rag);
    job.insert(QStringLiteral("urlSource"), m_prompt->toPlainText());
    job.insert(QStringLiteral("library"), m_library->isChecked());
    job.insert(QStringLiteral("urls"), m_urls->isChecked());
    job.insert(QStringLiteral("web"), m_web->isChecked() && !m_tools->isChecked());
    job.insert(QStringLiteral("tools"), m_tools->isChecked());
    job.insert(QStringLiteral("folder"), opts.folder);
    job.insert(QStringLiteral("snippets"), opts.snippets);
    job.insert(QStringLiteral("lines"), opts.lines);
    job.insert(QStringLiteral("chars"), opts.chars);
    job.insert(QStringLiteral("mode"), opts.mode);
    job.insert(QStringLiteral("file"), QFileInfo(m_askPath).fileName());
    Q_UNUSED(enhance);
    return job;
}

void AskForthPanel::launch(const QVariantMap &job) {
    QMetaObject::invokeMethod(m_worker, "start", Qt::QueuedConnection, Q_ARG(QVariant, QVariant(job)));
}

void AskForthPanel::ask() {
    if (m_busy)
        return;
    const QString prompt = m_prompt->toPlainText().trimmed();
    if (prompt.isEmpty()) {
        setStatus(QStringLiteral("Enter a question or capture editor context first."));
        return;
    }
    const Profile profile = profileById(activeId());
    if (profile.provider == QLatin1String("openai") && resolveKey(profile.id).isEmpty()) {
        setStatus(QStringLiteral("No API key — open Models…, paste a key, and click Save (or export XAI_API_KEY)."));
        return;
    }
    const LibraryOpts opts = libraryOpts();
    const QString header = askHeader(profile, prompt, m_library->isChecked(), opts.folder, modeDisplay(opts.mode),
                                    opts.snippets, opts.lines, opts.chars, m_urls->isChecked(),
                                    m_web->isChecked(), m_tools->isChecked());
    if (!beginStreamFile(header))
        return;
    m_transcript->clear();
    m_stopped = false;
    m_phase = QStringLiteral("ask");
    setBusy(true, QStringLiteral("Asking…"));
    setStatus(QStringLiteral("Asking %1 (%2)…")
                  .arg(profile.provider == QLatin1String("ollama") ? QStringLiteral("Ollama")
                                                                  : QStringLiteral("OpenAI-compat"),
                       profile.model));
    launch(jobFor(profile, systemPrompt(QString(), false), prompt, prompt, false));
}

void AskForthPanel::enhance() {
    if (m_busy)
        return;
    const QString source = extractForth(m_reply);
    if (source.isEmpty()) {
        setStatus(QStringLiteral("No Forth source in reply to evaluate."));
        return;
    }
    const QString exe = m_exeFinder ? m_exeFinder() : QString();
    m_stopped = false;
    m_phase = QStringLiteral("agent");
    setBusy(true, QStringLiteral("Ask"));
    m_enhance->setText(QStringLiteral("Evaluating…"));
    m_transcript->clear();
    setStatus(QStringLiteral("Running EditForthWin --agent on reply…"));
    QVariantMap job;
    job.insert(QStringLiteral("kind"), QStringLiteral("agent"));
    job.insert(QStringLiteral("exe"), exe);
    job.insert(QStringLiteral("dir"), m_askPath.isEmpty() ? userRoot() : QFileInfo(m_askPath).absolutePath());
    job.insert(QStringLiteral("source"), source);
    launch(job);
}

void AskForthPanel::startEnhance(const QString &transcript) {
    if (m_edit.isNull()) {
        setBusy(false, QStringLiteral("Ask"));
        setStatus(QStringLiteral("No AskForth file to append — Ask first."));
        return;
    }
    const QString marker = QStringLiteral("\n\nAgent Enhanced Reply\n\n");
    m_edit->setPlainText(m_edit->toPlainText() + marker);
    m_edit->document()->setModified(true);
    m_bodyStart = m_edit->toPlainText().size();
    const QString prior = m_reply;
    m_reply.clear();
    m_phase = QStringLiteral("enhance");
    m_enhance->setText(QStringLiteral("Enhancing…"));
    const Profile profile = profileById(activeId());
    const QString fileName = QFileInfo(m_askPath).fileName();
    QStringList parts;
    parts << QStringLiteral("The previous Forth answer was evaluated with a headless EditForthWin --agent process.");
    parts << QStringLiteral("Fix the Forth so it works on EditForthWin (ANS-style ITC). Prefer a single ```forth fenced block with the corrected source. Briefly note what you changed.");
    const QString prompt = m_prompt->toPlainText().trimmed();
    if (!prompt.isEmpty())
        parts << QStringLiteral("Original request / context:\n") + prompt;
    if (!prior.trimmed().isEmpty())
        parts << QStringLiteral("Previous answer:\n") + prior;
    parts << QStringLiteral("Agent transcript:\n") + transcript;
    const QString user = parts.join(QStringLiteral("\n\n"));
    launch(jobFor(profile, systemPrompt(fileName, true), user,
                  QStringList{prompt, prior, transcript}.join(QLatin1Char('\n')), true));
}

void AskForthPanel::stop() {
    if (!m_busy)
        return;
    m_stopped = true;
    QMetaObject::invokeMethod(m_worker, "cancel", Qt::QueuedConnection);
    m_paint->stop();
    if (!m_reply.isEmpty())
        applyStreamBody(m_reply);
    saveAskFile();
    setBusy(false, QStringLiteral("Ask"));
    setStatus(QStringLiteral("Stopped."));
}

#include "AskForth.moc"

