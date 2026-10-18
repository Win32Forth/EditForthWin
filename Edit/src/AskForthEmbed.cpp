#include "AskForthEmbed.h"

#include <QCoreApplication>
#include <QDateTime>
#include <QDir>
#include <QEventLoop>
#include <QFile>
#include <QFileInfo>
#include <QHash>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QPointer>
#include <QSaveFile>
#include <QSet>
#include <QStandardPaths>
#include <QStringDecoder>
#include <QTimer>
#include <QUrl>

#include <algorithm>
#include <cmath>

namespace AskForthEmbed {
QPointer<AskForthIndexer> g_indexer;
}

namespace {

constexpr int kChunkLines = 50;
constexpr int kChunkOverlap = 10;
constexpr int kChunkMaxChars = 4000;
constexpr int kMinChunkChars = 40;
constexpr int kBatch = 16;
constexpr qint64 kEmbedMaxBytes = 500000;
constexpr qint64 kKeywordMaxBytes = 400 * 1024;

const QStringList kStop = {QStringLiteral("the"), QStringLiteral("and"), QStringLiteral("for"),
                           QStringLiteral("with"), QStringLiteral("from"), QStringLiteral("this"),
                           QStringLiteral("that"), QStringLiteral("what"), QStringLiteral("how"),
                           QStringLiteral("write"), QStringLiteral("forth"), QStringLiteral("word"),
                           QStringLiteral("code"), QStringLiteral("please"), QStringLiteral("using"),
                           QStringLiteral("into"), QStringLiteral("then"), QStringLiteral("when"),
                           QStringLiteral("else"), QStringLiteral("true"), QStringLiteral("false"),
                           QStringLiteral("null"), QStringLiteral("stack"), QStringLiteral("comment")};

QString ollamaBase() { return QStringLiteral("http://127.0.0.1:11434"); }

QString referenceRoot() {
    return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
           QStringLiteral("/EditForthWin/Library/Reference");
}

QString indexDirectory() {
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) +
           QStringLiteral("/AskForthEmbedIndex");
}

QString indexFilePath() { return indexDirectory() + QStringLiteral("/library-embed-v1.json"); }

QString metaFilePath() { return indexDirectory() + QStringLiteral("/library-embed-v1.meta.json"); }

QString canonPath(const QString &path) {
    if (path.trimmed().isEmpty())
        return {};
    return QDir::cleanPath(QFileInfo(path).absoluteFilePath());
}

bool samePath(const QString &a, const QString &b) {
    return canonPath(a).compare(canonPath(b), Qt::CaseInsensitive) == 0;
}

bool samePathSet(const QStringList &a, const QStringList &b) {
    if (a.size() != b.size())
        return false;
    QSet<QString> keys;
    for (const QString &path : a)
        keys.insert(canonPath(path).toLower());
    for (const QString &path : b)
        if (!keys.contains(canonPath(path).toLower()))
            return false;
    return true;
}

bool skipDir(const QString &name) {
    static const QStringList skip = {
        QStringLiteral(".git"), QStringLiteral("DerivedData"), QStringLiteral("PI"),
        QStringLiteral("VED64"), QStringLiteral("__pycache__"), QStringLiteral("finetune"),
        QStringLiteral("Build"), QStringLiteral("build"), QStringLiteral(".build"),
        QStringLiteral("xcuserdata"), QStringLiteral("Pods"), QStringLiteral("node_modules"),
        QStringLiteral("models"), QStringLiteral("adapters"), QStringLiteral("fused_model")};
    for (const QString &s : skip)
        if (name.compare(s, Qt::CaseInsensitive) == 0)
            return true;
    return name.endsWith(QStringLiteral(".app"), Qt::CaseInsensitive);
}

bool sourceExt(const QString &ext) {
    static const QStringList ok = {QStringLiteral("fth"), QStringLiteral("fs"), QStringLiteral("4th"),
                                   QStringLiteral("f"),   QStringLiteral("txt"), QStringLiteral("md"),
                                   QStringLiteral("swift")};
    for (const QString &s : ok)
        if (ext.compare(s, Qt::CaseInsensitive) == 0)
            return true;
    return false;
}

bool skipEmbedName(const QString &name) {
    if (name.compare(QStringLiteral("HYPER.NDX"), Qt::CaseInsensitive) == 0)
        return true;
    if (name.endsWith(QStringLiteral(".emit.log"), Qt::CaseInsensitive))
        return true;
    return name.compare(QStringLiteral("Forth-2012-word-urls.json"), Qt::CaseInsensitive) == 0;
}

bool wordChar(QChar c) {
    return c.isLetterOrNumber() || QStringLiteral("_-?!'.+*/<>=@$").contains(c);
}

QStringList tokensOf(const QString &text) {
    QStringList tokens;
    QString cur;
    const auto take = [&] {
        const QString t = cur.toLower();
        cur.clear();
        if (t.size() < 2 || kStop.contains(t))
            return;
        bool digits = true;
        for (const QChar c : t)
            digits = digits && c.isDigit();
        if (!digits)
            tokens << t;
    };
    for (const QChar c : text) {
        if (wordChar(c))
            cur += c;
        else if (!cur.isEmpty())
            take();
    }
    if (!cur.isEmpty())
        take();
    tokens.removeDuplicates();
    std::sort(tokens.begin(), tokens.end(), [](const QString &a, const QString &b) {
        if (a.size() != b.size())
            return a.size() > b.size();
        return a < b;
    });
    return tokens;
}

int scoreText(const QString &lower, const QStringList &tokens) {
    int score = 0;
    for (const QString &token : tokens) {
        int hits = 0;
        int from = 0;
        while (hits < 8) {
            const int at = lower.indexOf(token, from);
            if (at < 0)
                break;
            ++hits;
            from = at + token.size();
        }
        if (hits == 0)
            continue;
        score += hits * qMax(1, token.size() / 2);
        if (lower.contains(QStringLiteral(": ") + token))
            score += 10;
    }
    return score;
}

QString keywordRootLabel(const QString &folder) {
    if (QFileInfo(referenceRoot()).isDir())
        return folder + QStringLiteral(" + Reference");
    return folder;
}

QStringList indexRoots(const QString &folder) {
    QStringList roots;
    const auto add = [&](const QString &path) {
        const QString canon = canonPath(path);
        if (canon.isEmpty() || !QFileInfo(canon).isDir())
            return;
        for (const QString &have : roots)
            if (have.compare(canon, Qt::CaseInsensitive) == 0)
                return;
        roots << canon;
    };
    add(folder);
    add(referenceRoot());
    return roots;
}

struct SourceFile {
    QString path;
    QString relativePath;
    qint64 mtime = 0;
    qint64 size = 0;
};

struct PendingChunk {
    QString id;
    int startLine = 1;
    int endLine = 1;
    QString text;
};

struct Chunk {
    QString id;
    QString relativePath;
    QString absolutePath;
    int startLine = 1;
    int endLine = 1;
    QString text;
    QVector<float> embedding;
    qint64 sourceMTime = 0;
    qint64 sourceSize = 0;
};

struct Store {
    int version = 1;
    QString model;
    int dimensions = 0;
    QStringList roots;
    QString builtAt;
    QVector<Chunk> chunks;
};

struct EmbedHit {
    QString path;
    int line = 1;
    QString text;
    float score = 0;
};

QString readText(const QString &path, qint64 maxBytes) {
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
        return {};
    if (file.size() <= 0 || file.size() > maxBytes)
        return {};
    const QByteArray data = file.readAll();
    QStringDecoder decoder(QStringDecoder::Utf8);
    QString text = decoder(data);
    if (decoder.hasError())
        text = QString::fromLatin1(data);
    text.replace(QStringLiteral("\r\n"), QStringLiteral("\n"));
    text.replace(QLatin1Char('\r'), QLatin1Char('\n'));
    return text;
}

QString chunkId(const QString &path, int startLine, int endLine, qint64 mtime, qint64 size) {
    const QByteArray raw = QStringLiteral("%1|%2|%3|%4|%5")
                               .arg(path)
                               .arg(startLine)
                               .arg(endLine)
                               .arg(mtime)
                               .arg(size)
                               .toUtf8();
    quint64 hash = 5381;
    for (char byte : raw)
        hash = (hash * 33) + static_cast<unsigned char>(byte);
    return QString::number(hash, 16);
}

QVector<PendingChunk> makePending(const SourceFile &file, const QString &text) {
    const QStringList lines = text.split(QLatin1Char('\n'), Qt::KeepEmptyParts);
    if (lines.isEmpty())
        return {};
    const int step = qMax(1, kChunkLines - kChunkOverlap);
    QVector<PendingChunk> chunks;
    int start = 0;
    while (start < lines.size()) {
        const int end = qMin(lines.size(), start + kChunkLines);
        QString body = lines.mid(start, end - start).join(QLatin1Char('\n')).trimmed();
        if (body.size() >= kMinChunkChars) {
            if (body.size() > kChunkMaxChars)
                body.truncate(kChunkMaxChars);
            PendingChunk pending;
            pending.startLine = start + 1;
            pending.endLine = end;
            pending.text = body;
            pending.id = chunkId(file.path, pending.startLine, pending.endLine, file.mtime, file.size);
            chunks.push_back(pending);
        }
        if (end >= lines.size())
            break;
        start += step;
    }
    return chunks;
}

void walkDir(const QString &dir, const QString &root, const QString &prefix, bool embedding, qint64 maxBytes,
             QVector<SourceFile> *out, QSet<QString> *seen, const std::atomic<bool> *cancel) {
    if (cancel != nullptr && cancel->load())
        return;
    const QFileInfoList entries =
        QDir(dir).entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot, QDir::Name);
    for (const QFileInfo &info : entries) {
        if (cancel != nullptr && cancel->load())
            return;
        if (info.isDir()) {
            if (!skipDir(info.fileName()))
                walkDir(info.absoluteFilePath(), root, prefix, embedding, maxBytes, out, seen, cancel);
            continue;
        }
        if (!sourceExt(info.suffix()))
            continue;
        if (embedding && skipEmbedName(info.fileName()))
            continue;
        if (info.size() <= 0 || info.size() > maxBytes)
            continue;
        const QString abs = QDir::cleanPath(info.absoluteFilePath());
        const QString key = abs.toLower();
        if (seen->contains(key))
            continue;
        seen->insert(key);
        QString rel = QDir::fromNativeSeparators(QDir(root).relativeFilePath(abs));
        if (!prefix.isEmpty() && !rel.startsWith(prefix, Qt::CaseInsensitive))
            rel = prefix + rel;
        SourceFile file;
        file.path = abs;
        file.relativePath = rel;
        const QDateTime modified = info.lastModified();
        file.mtime = modified.isValid() ? modified.toSecsSinceEpoch() : 0;
        file.size = info.size();
        out->push_back(file);
    }
}

QVector<SourceFile> collectSources(const QStringList &roots, bool embedding, qint64 maxBytes,
                                   const std::atomic<bool> *cancel) {
    QVector<SourceFile> out;
    QSet<QString> seen;
    for (const QString &root : roots) {
        const bool reference = QFileInfo(root).fileName().compare(QLatin1String("Reference"), Qt::CaseInsensitive) == 0;
        const QString prefix = reference ? QStringLiteral("Reference/") : QString();
        walkDir(root, root, prefix, embedding, maxBytes, &out, &seen, cancel);
        if (cancel != nullptr && cancel->load())
            break;
    }
    std::sort(out.begin(), out.end(), [](const SourceFile &a, const SourceFile &b) {
        return QString::compare(a.relativePath, b.relativePath, Qt::CaseInsensitive) < 0;
    });
    return out;
}

QVector<AskForthEmbed::Snippet> keywordSnippets(const QString &folder, const QString &query, int maxSnippets,
                                                int contextLines, const std::atomic<bool> &cancel) {
    QVector<AskForthEmbed::Snippet> snips;
    const QStringList tokens = tokensOf(query);
    if (tokens.isEmpty() || cancel.load())
        return snips;
    const int context = qBound(2, contextLines, 40);
    const QStringList roots = indexRoots(folder);
    const QVector<SourceFile> files = collectSources(roots, false, kKeywordMaxBytes, &cancel);
    for (const SourceFile &file : files) {
        if (cancel.load())
            return {};
        const QString text = readText(file.path, kKeywordMaxBytes);
        if (text.isEmpty())
            continue;
        const QString lower = text.toLower();
        const int score = scoreText(lower, tokens);
        if (score <= 0)
            continue;
        const QStringList lines = text.split(QLatin1Char('\n'), Qt::KeepEmptyParts);
        int best = 0;
        int bestHits = 0;
        for (int i = 0; i < lines.size(); ++i) {
            const QString low = lines.at(i).toLower();
            int hits = 0;
            for (const QString &token : tokens)
                if (low.contains(token))
                    ++hits;
            if (hits > bestHits) {
                bestHits = hits;
                best = i;
            }
        }
        if (bestHits <= 0)
            continue;
        const int start = qMax(0, best - context);
        const int end = qMin(lines.size() - 1, best + context);
        QString slice;
        for (int i = start; i <= end; ++i) {
            if (i != start)
                slice += QLatin1Char('\n');
            slice += lines.at(i);
        }
        if (slice.size() > 2000)
            slice.truncate(2000);
        AskForthEmbed::Snippet snip;
        snip.path = file.relativePath;
        snip.line = start + 1;
        snip.text = slice;
        snip.score = score;
        snips.push_back(snip);
    }
    std::sort(snips.begin(), snips.end(), [](const AskForthEmbed::Snippet &a, const AskForthEmbed::Snippet &b) {
        if (a.score != b.score)
            return a.score > b.score;
        return a.path < b.path;
    });
    QStringList seen;
    QVector<AskForthEmbed::Snippet> kept;
    const int limit = qMax(1, maxSnippets);
    for (const AskForthEmbed::Snippet &snip : snips) {
        const QString key = snip.path.toLower();
        if (seen.contains(key))
            continue;
        seen << key;
        kept << snip;
        if (kept.size() >= limit)
            break;
    }
    return kept;
}

bool writeFile(const QString &path, const QByteArray &data, QString *error) {
    QDir().mkpath(QFileInfo(path).absolutePath());
    QSaveFile file(path);
    if (!file.open(QIODevice::WriteOnly)) {
        *error = file.errorString();
        return false;
    }
    if (file.write(data) != data.size() || !file.commit()) {
        *error = file.errorString().isEmpty() ? QStringLiteral("could not save the embed index") : file.errorString();
        return false;
    }
    return true;
}

QJsonObject chunkJson(const Chunk &chunk) {
    QJsonObject obj;
    obj.insert(QStringLiteral("id"), chunk.id);
    obj.insert(QStringLiteral("relativePath"), chunk.relativePath);
    obj.insert(QStringLiteral("absolutePath"), chunk.absolutePath);
    obj.insert(QStringLiteral("startLine"), chunk.startLine);
    obj.insert(QStringLiteral("endLine"), chunk.endLine);
    obj.insert(QStringLiteral("text"), chunk.text);
    obj.insert(QStringLiteral("sourceMTime"), double(chunk.sourceMTime));
    obj.insert(QStringLiteral("sourceSize"), double(chunk.sourceSize));
    QJsonArray emb;
    for (float value : chunk.embedding)
        emb.append(double(value));
    obj.insert(QStringLiteral("embedding"), emb);
    return obj;
}

Chunk chunkFrom(const QJsonObject &obj) {
    Chunk chunk;
    chunk.id = obj.value(QStringLiteral("id")).toString();
    chunk.relativePath = obj.value(QStringLiteral("relativePath")).toString();
    chunk.absolutePath = obj.value(QStringLiteral("absolutePath")).toString();
    chunk.startLine = obj.value(QStringLiteral("startLine")).toInt(1);
    chunk.endLine = obj.value(QStringLiteral("endLine")).toInt(chunk.startLine);
    chunk.text = obj.value(QStringLiteral("text")).toString();
    chunk.sourceMTime = qint64(obj.value(QStringLiteral("sourceMTime")).toDouble());
    chunk.sourceSize = qint64(obj.value(QStringLiteral("sourceSize")).toDouble());
    const QJsonArray emb = obj.value(QStringLiteral("embedding")).toArray();
    chunk.embedding.reserve(emb.size());
    for (const QJsonValue &value : emb)
        chunk.embedding.push_back(float(value.toDouble()));
    return chunk;
}

bool loadStore(Store *store) {
    QFile file(indexFilePath());
    if (!file.open(QIODevice::ReadOnly))
        return false;
    const QJsonObject root = QJsonDocument::fromJson(file.readAll()).object();
    if (root.value(QStringLiteral("version")).toInt() != 1)
        return false;
    store->version = 1;
    store->model = root.value(QStringLiteral("model")).toString();
    store->dimensions = root.value(QStringLiteral("dimensions")).toInt();
    store->builtAt = root.value(QStringLiteral("builtAt")).toString();
    store->roots.clear();
    for (const QJsonValue &value : root.value(QStringLiteral("roots")).toArray())
        store->roots << value.toString();
    store->chunks.clear();
    const QJsonArray chunks = root.value(QStringLiteral("chunks")).toArray();
    store->chunks.reserve(chunks.size());
    for (const QJsonValue &value : chunks)
        store->chunks.push_back(chunkFrom(value.toObject()));
    return true;
}

bool saveStore(const Store &store, QString *error) {
    QJsonObject root;
    root.insert(QStringLiteral("version"), store.version);
    root.insert(QStringLiteral("model"), store.model);
    root.insert(QStringLiteral("dimensions"), store.dimensions);
    root.insert(QStringLiteral("builtAt"), store.builtAt);
    QJsonArray roots;
    for (const QString &path : store.roots)
        roots.append(path);
    root.insert(QStringLiteral("roots"), roots);
    QJsonArray chunks;
    for (const Chunk &chunk : store.chunks)
        chunks.append(chunkJson(chunk));
    root.insert(QStringLiteral("chunks"), chunks);
    if (!writeFile(indexFilePath(), QJsonDocument(root).toJson(QJsonDocument::Compact), error))
        return false;
    QJsonObject meta;
    meta.insert(QStringLiteral("version"), store.version);
    meta.insert(QStringLiteral("model"), store.model);
    meta.insert(QStringLiteral("chunks"), store.chunks.size());
    meta.insert(QStringLiteral("roots"), roots);
    meta.insert(QStringLiteral("builtAt"), store.builtAt);
    return writeFile(metaFilePath(), QJsonDocument(meta).toJson(QJsonDocument::Compact), error);
}

QVector<float> vectorFrom(const QJsonArray &values, QString *error) {
    QVector<float> out;
    out.reserve(values.size());
    for (const QJsonValue &value : values) {
        if (!value.isDouble()) {
            *error = QStringLiteral("non-numeric embedding component");
            return {};
        }
        out.push_back(float(value.toDouble()));
    }
    if (out.isEmpty())
        *error = QStringLiteral("The embedding model returned no vectors.");
    return out;
}

QVector<QVector<float>> embedBatch(const AskForthEmbed::Net &net, const QStringList &texts, QString *error,
                                   const std::atomic<bool> &cancel) {
    if (cancel.load()) {
        *error = QStringLiteral("cancelled");
        return {};
    }
    if (!net.exchange) {
        *error = QStringLiteral("no embedding connection");
        return {};
    }
    QJsonObject body;
    body.insert(QStringLiteral("model"), AskForthEmbed::embedModel());
    if (texts.size() == 1) {
        body.insert(QStringLiteral("input"), texts.at(0));
    } else {
        QJsonArray input;
        for (const QString &text : texts)
            input.append(text);
        body.insert(QStringLiteral("input"), input);
    }
    int status = 0;
    const QByteArray payload = net.exchange(QUrl(ollamaBase() + QStringLiteral("/api/embed")),
                                            QJsonDocument(body).toJson(QJsonDocument::Compact), 120000, &status, error);
    if (cancel.load()) {
        *error = QStringLiteral("cancelled");
        return {};
    }
    if (status < 200 || status >= 300) {
        if (error->isEmpty())
            *error = QStringLiteral("HTTP %1").arg(status);
        const QString detail = QString::fromUtf8(payload).trimmed();
        if (!detail.isEmpty())
            *error = error->isEmpty() ? detail.left(180) : *error + QStringLiteral(": ") + detail.left(180);
        return {};
    }
    const QJsonObject obj = QJsonDocument::fromJson(payload).object();
    if (obj.contains(QStringLiteral("error"))) {
        *error = obj.value(QStringLiteral("error")).toString().left(180);
        if (error->isEmpty())
            *error = QStringLiteral("embedding request failed");
        return {};
    }
    QVector<QVector<float>> vectors;
    const QJsonValue embeddings = obj.value(QStringLiteral("embeddings"));
    if (embeddings.isArray()) {
        const QJsonArray rows = embeddings.toArray();
        if (!rows.isEmpty() && rows.at(0).isArray()) {
            for (const QJsonValue &row : rows) {
                const QVector<float> vector = vectorFrom(row.toArray(), error);
                if (!error->isEmpty())
                    return {};
                vectors.push_back(vector);
            }
        } else if (!rows.isEmpty()) {
            const QVector<float> vector = vectorFrom(rows, error);
            if (!error->isEmpty())
                return {};
            vectors.push_back(vector);
        }
    } else if (obj.value(QStringLiteral("embedding")).isArray()) {
        const QVector<float> vector = vectorFrom(obj.value(QStringLiteral("embedding")).toArray(), error);
        if (!error->isEmpty())
            return {};
        vectors.push_back(vector);
    }
    if (vectors.isEmpty()) {
        *error = QStringLiteral("missing embeddings array");
        return {};
    }
    return vectors;
}

QVector<QVector<float>> embedTexts(const AskForthEmbed::Net &net, const QStringList &texts, QString *error,
                                   const std::atomic<bool> &cancel) {
    QVector<QVector<float>> out;
    int expected = -1;
    for (int i = 0; i < texts.size(); i += kBatch) {
        if (cancel.load()) {
            *error = QStringLiteral("cancelled");
            return {};
        }
        QStringList batch;
        for (int j = i; j < texts.size() && batch.size() < kBatch; ++j)
            batch << texts.at(j);
        const QVector<QVector<float>> vectors = embedBatch(net, batch, error, cancel);
        if (!error->isEmpty())
            return {};
        if (vectors.size() != batch.size()) {
            *error = QStringLiteral("embed count %1 != chunks %2").arg(vectors.size()).arg(batch.size());
            return {};
        }
        for (const QVector<float> &vector : vectors) {
            if (expected < 0)
                expected = vector.size();
            else if (vector.size() != expected) {
                *error = QStringLiteral("Embedding dimension mismatch (expected %1, got %2).")
                             .arg(expected)
                             .arg(vector.size());
                return {};
            }
            out.push_back(vector);
        }
    }
    return out;
}

float cosine(const QVector<float> &a, const QVector<float> &b) {
    if (a.size() != b.size() || a.isEmpty())
        return 0;
    double dot = 0;
    double na = 0;
    double nb = 0;
    for (int i = 0; i < a.size(); ++i) {
        const double x = a.at(i);
        const double y = b.at(i);
        dot += x * y;
        na += x * x;
        nb += y * y;
    }
    const double denom = std::sqrt(na) * std::sqrt(nb);
    if (denom <= 0)
        return 0;
    return float(dot / denom);
}

QVector<EmbedHit> searchStore(const Store &store, const QString &query, int topK, const AskForthEmbed::Net &net,
                              const std::atomic<bool> &cancel, QString *error) {
    QString trimmed = query.trimmed();
    if (trimmed.size() > 16000)
        trimmed.truncate(16000);
    if (trimmed.isEmpty() || store.chunks.isEmpty())
        return {};
    const QVector<QVector<float>> vectors =
        embedTexts(net, {QStringLiteral("search_query: ") + trimmed}, error, cancel);
    if (!error->isEmpty() || vectors.isEmpty()) {
        if (error->isEmpty())
            *error = QStringLiteral("The embedding model returned no vectors.");
        return {};
    }
    const QVector<float> &queryVector = vectors.at(0);
    if (store.dimensions > 0 && queryVector.size() != store.dimensions) {
        *error = QStringLiteral("Embedding dimension mismatch (expected %1, got %2).")
                     .arg(store.dimensions)
                     .arg(queryVector.size());
        return {};
    }
    QVector<EmbedHit> hits;
    hits.reserve(store.chunks.size());
    for (int i = 0; i < store.chunks.size(); ++i) {
        if ((i % 64) == 0 && cancel.load()) {
            *error = QStringLiteral("cancelled");
            return {};
        }
        const Chunk &chunk = store.chunks.at(i);
        EmbedHit hit;
        hit.path = chunk.relativePath;
        hit.line = chunk.startLine;
        hit.text = chunk.text;
        hit.score = cosine(queryVector, chunk.embedding);
        hits.push_back(hit);
    }
    std::sort(hits.begin(), hits.end(), [](const EmbedHit &a, const EmbedHit &b) {
        if (a.score != b.score)
            return a.score > b.score;
        return a.path < b.path;
    });
    const int k = qMax(1, topK);
    if (hits.size() > k)
        hits.resize(k);
    return hits;
}

QVector<AskForthEmbed::Snippet> hitsAsSnippets(const QVector<EmbedHit> &hits) {
    QVector<AskForthEmbed::Snippet> out;
    out.reserve(hits.size());
    for (const EmbedHit &hit : hits) {
        AskForthEmbed::Snippet snip;
        snip.path = hit.path;
        snip.line = hit.line;
        snip.text = hit.text;
        snip.score = qRound(double(hit.score) * 1000.0);
        out.push_back(snip);
    }
    return out;
}

QVector<AskForthEmbed::Snippet> mergeHybrid(const QVector<AskForthEmbed::Snippet> &keyword,
                                            const QVector<EmbedHit> &embedHits, int maxSnippets) {
    struct Acc {
        QString path;
        int startLine = 1;
        QString text;
        float embed = 0;
        float keyword = 0;
    };
    int maxKW = 0;
    for (const AskForthEmbed::Snippet &snip : keyword)
        maxKW = qMax(maxKW, snip.score);
    QHash<QString, Acc> byKey;
    const auto keyFor = [](const QString &path, int start) {
        const int bucket = (qMax(1, start) / 40) * 40;
        return path.toLower() + QLatin1Char('#') + QString::number(bucket);
    };
    for (const AskForthEmbed::Snippet &snip : keyword) {
        const QString key = keyFor(snip.path, snip.line);
        const float norm = maxKW > 0 ? float(snip.score) / float(maxKW) : 0;
        Acc &acc = byKey[key];
        if (acc.path.isEmpty()) {
            acc.path = snip.path;
            acc.startLine = snip.line;
            acc.text = snip.text;
            acc.keyword = norm;
        } else {
            acc.keyword = qMax(acc.keyword, norm);
            if (snip.text.size() > acc.text.size()) {
                acc.text = snip.text;
                acc.startLine = snip.line;
                acc.path = snip.path;
            }
        }
    }
    for (const EmbedHit &hit : embedHits) {
        const QString key = keyFor(hit.path, hit.line);
        Acc &acc = byKey[key];
        if (acc.path.isEmpty()) {
            acc.path = hit.path;
            acc.startLine = hit.line;
            acc.text = hit.text;
            acc.embed = hit.score;
        } else {
            acc.embed = qMax(acc.embed, hit.score);
            if (hit.text.size() > acc.text.size()) {
                acc.text = hit.text;
                acc.startLine = hit.line;
                acc.path = hit.path;
            }
        }
    }
    struct Ranked {
        float score;
        Acc acc;
    };
    QVector<Ranked> ranked;
    ranked.reserve(byKey.size());
    for (const Acc &acc : byKey) {
        float final = acc.keyword;
        if (acc.embed > 0 && acc.keyword > 0)
            final = 0.65f * acc.embed + 0.35f * acc.keyword;
        else if (acc.embed > 0)
            final = acc.embed;
        ranked.push_back(Ranked{final, acc});
    }
    std::sort(ranked.begin(), ranked.end(), [](const Ranked &a, const Ranked &b) {
        if (a.score != b.score)
            return a.score > b.score;
        return a.acc.path < b.acc.path;
    });
    QVector<AskForthEmbed::Snippet> out;
    const int limit = qMax(1, maxSnippets);
    for (const Ranked &row : ranked) {
        AskForthEmbed::Snippet snip;
        snip.path = row.acc.path;
        snip.line = row.acc.startLine;
        snip.text = row.acc.text;
        snip.score = qRound(double(row.score) * 1000.0);
        out.push_back(snip);
        if (out.size() >= limit)
            break;
    }
    return out;
}

QString ensureIndex(const QString &folder, bool force, const AskForthEmbed::Net &net, const std::atomic<bool> &cancel,
                    const std::function<void(const QString &)> &progress) {
    const QStringList roots = indexRoots(folder);
    if (roots.isEmpty())
        return QStringLiteral("No Library roots found to index.");
    if (cancel.load())
        return QStringLiteral("cancelled");
    const QVector<SourceFile> files = collectSources(roots, true, kEmbedMaxBytes, &cancel);
    if (cancel.load())
        return QStringLiteral("cancelled");

    Store previous;
    const bool loaded = !force && loadStore(&previous);
    const bool modelOk = loaded && previous.version == 1 && previous.model == AskForthEmbed::embedModel() &&
                         previous.dimensions > 0 && samePathSet(previous.roots, roots);
    struct Prior {
        qint64 mtime = 0;
        qint64 size = -1;
        QVector<int> indexes;
        bool conflict = false;
    };
    QHash<QString, Prior> prior;
    if (modelOk) {
        for (int i = 0; i < previous.chunks.size(); ++i) {
            const Chunk &chunk = previous.chunks.at(i);
            if (chunk.embedding.isEmpty())
                continue;
            Prior &entry = prior[chunk.absolutePath.toLower()];
            if (entry.size < 0) {
                entry.mtime = chunk.sourceMTime;
                entry.size = chunk.sourceSize;
            } else if (entry.mtime != chunk.sourceMTime || entry.size != chunk.sourceSize) {
                entry.conflict = true;
            }
            entry.indexes.push_back(i);
        }
    }

    QVector<Chunk> reused;
    struct Todo {
        SourceFile file;
        QVector<PendingChunk> chunks;
    };
    QVector<Todo> toEmbed;
    QSet<QString> yielding;
    for (const SourceFile &file : files) {
        if (cancel.load())
            return QStringLiteral("cancelled");
        if (file.size > 0 && file.size < kMinChunkChars)
            continue;
        const QString key = file.path.toLower();
        const auto found = prior.constFind(key);
        if (found != prior.cend() && !found->conflict && found->mtime == file.mtime && found->size == file.size &&
            !found->indexes.isEmpty()) {
            for (int index : found->indexes)
                reused.push_back(previous.chunks.at(index));
            yielding.insert(key);
            continue;
        }
        const QString text = readText(file.path, kEmbedMaxBytes);
        const QVector<PendingChunk> pending = makePending(file, text);
        if (pending.isEmpty())
            continue;
        yielding.insert(key);
        toEmbed.push_back(Todo{file, pending});
    }

    if (modelOk && toEmbed.isEmpty()) {
        QSet<QString> indexed;
        for (auto it = prior.cbegin(); it != prior.cend(); ++it)
            if (!it->conflict && !it->indexes.isEmpty())
                indexed.insert(it.key());
        if (indexed == yielding)
            return QStringLiteral("fresh");
    }

    progress(QStringLiteral("Scanning Library…"));
    progress(QStringLiteral("Found %1 source file(s).").arg(files.size()));
    int embedCount = 0;
    for (const Todo &todo : toEmbed)
        embedCount += todo.chunks.size();
    progress(QStringLiteral("Reusing %1 chunk(s); embedding %2 new…").arg(reused.size()).arg(embedCount));

    QVector<Chunk> fresh;
    int dimensions = modelOk ? previous.dimensions : 0;
    for (int fileIndex = 0; fileIndex < toEmbed.size(); ++fileIndex) {
        if (cancel.load())
            return QStringLiteral("cancelled");
        const Todo &todo = toEmbed.at(fileIndex);
        progress(QStringLiteral("Embedding %1 (%2/%3)…")
                     .arg(todo.file.relativePath)
                     .arg(fileIndex + 1)
                     .arg(toEmbed.size()));
        QStringList inputs;
        inputs.reserve(todo.chunks.size());
        for (const PendingChunk &pending : todo.chunks)
            inputs << QStringLiteral("search_document: ") + pending.text;
        QString error;
        const QVector<QVector<float>> vectors = embedTexts(net, inputs, &error, cancel);
        if (cancel.load() || error == QLatin1String("cancelled"))
            return QStringLiteral("cancelled");
        if (!error.isEmpty())
            return error;
        if (vectors.size() != todo.chunks.size())
            return QStringLiteral("embed count %1 != chunks %2 for %3")
                .arg(vectors.size())
                .arg(todo.chunks.size())
                .arg(todo.file.relativePath);
        for (int i = 0; i < todo.chunks.size(); ++i) {
            const QVector<float> &vector = vectors.at(i);
            if (dimensions == 0)
                dimensions = vector.size();
            else if (vector.size() != dimensions)
                return QStringLiteral("Embedding dimension mismatch (expected %1, got %2).")
                    .arg(dimensions)
                    .arg(vector.size());
            Chunk chunk;
            chunk.id = todo.chunks.at(i).id;
            chunk.relativePath = todo.file.relativePath;
            chunk.absolutePath = todo.file.path;
            chunk.startLine = todo.chunks.at(i).startLine;
            chunk.endLine = todo.chunks.at(i).endLine;
            chunk.text = todo.chunks.at(i).text;
            chunk.embedding = vector;
            chunk.sourceMTime = todo.file.mtime;
            chunk.sourceSize = todo.file.size;
            fresh.push_back(chunk);
        }
    }

    QVector<Chunk> all = reused + fresh;
    std::sort(all.begin(), all.end(), [](const Chunk &a, const Chunk &b) {
        if (a.relativePath != b.relativePath)
            return a.relativePath < b.relativePath;
        return a.startLine < b.startLine;
    });
    Store store;
    store.version = 1;
    store.model = AskForthEmbed::embedModel();
    store.dimensions = dimensions;
    store.roots = roots;
    store.builtAt = QDateTime::currentDateTimeUtc().toString(Qt::ISODate);
    store.chunks = all;
    QString error;
    if (!saveStore(store, &error))
        return error.isEmpty() ? QStringLiteral("could not save the embed index") : error;
    return {};
}

} // namespace

namespace AskForthEmbed {

QString embedModel() { return QStringLiteral("nomic-embed-text"); }

IndexStatus indexStatus(const QString &folder) {
    IndexStatus status;
    const bool indexExists = QFileInfo::exists(indexFilePath());
    QFile meta(metaFilePath());
    if (!meta.open(QIODevice::ReadOnly)) {
        status.fileExists = indexExists;
        return status;
    }
    const QJsonObject obj = QJsonDocument::fromJson(meta.readAll()).object();
    if (obj.value(QStringLiteral("version")).toInt() != 1) {
        status.fileExists = indexExists;
        return status;
    }
    status.fileExists = true;
    status.chunks = obj.value(QStringLiteral("chunks")).toInt();
    status.modelMatch = obj.value(QStringLiteral("model")).toString() == embedModel();
    QStringList have;
    for (const QJsonValue &value : obj.value(QStringLiteral("roots")).toArray())
        have << value.toString();
    status.rootsMatch = samePathSet(indexRoots(folder), have);
    return status;
}

QStringList modelNames(const QByteArray &tagsJson) {
    QStringList names;
    const QJsonArray models = QJsonDocument::fromJson(tagsJson).object().value(QStringLiteral("models")).toArray();
    for (const QJsonValue &value : models) {
        const QString name = value.toObject().value(QStringLiteral("name")).toString();
        if (!name.isEmpty())
            names << name;
    }
    return names;
}

bool hasModel(const QStringList &names, const QString &want) {
    const QString needle = want.toLower();
    const QString wantBase = needle.section(QLatin1Char(':'), 0, 0);
    for (const QString &name : names) {
        const QString have = name.toLower();
        if (have == needle || have.startsWith(needle + QLatin1Char(':')) || needle.startsWith(have + QLatin1Char(':')))
            return true;
        if (have.section(QLatin1Char(':'), 0, 0) == wantBase)
            return true;
    }
    return false;
}

QString libraryBanner(const QString &folder, bool reachable, const QStringList &names) {
    if (!reachable) {
        return QStringLiteral(
            "Library Hybrid/Semantic needs Ollama for nomic-embed-text. Install from https://ollama.com and leave it running.");
    }
    if (!hasModel(names, embedModel())) {
        return QStringLiteral(
            "Library Hybrid/Semantic will download \"nomic-embed-text\" (~274 MB) via Ollama when you open Ask Forth or Rebuild Index…");
    }
    const IndexStatus status = indexStatus(folder);
    if (!status.fileExists || status.chunks <= 0) {
        return QStringLiteral(
            "Library embed index not built yet — EditForthWin will build it in the background (Sample + Reference).");
    }
    if (!status.modelMatch || !status.rootsMatch) {
        return QStringLiteral(
                   "Library embed index is out of date (%1 chunks) — updating in the background (new or changed Library files).")
            .arg(status.chunks);
    }
    return {};
}

Result retrieve(const QString &folder, const QString &query, const QString &mode, int maxSnippets, int contextLines,
                const std::atomic<bool> &cancel, const Net &net) {
    Result result;
    const QString want = (mode == QLatin1String("semantic") || mode == QLatin1String("keyword"))
                             ? mode
                             : QStringLiteral("hybrid");
    result.rootLabel = keywordRootLabel(folder);
    result.modeLabel = want == QLatin1String("keyword") ? QStringLiteral("keyword") : want;
    if (query.trimmed().isEmpty() || cancel.load())
        return result;
    if (want == QLatin1String("keyword")) {
        result.snippets = keywordSnippets(folder, query, maxSnippets, contextLines, cancel);
        result.modeLabel = QStringLiteral("keyword");
        return result;
    }

    requestPrepare(folder, want, false);
    if (cancel.load())
        return {};

    Store store;
    const bool loaded = loadStore(&store);
    if (!loaded || store.chunks.isEmpty() || store.model != embedModel()) {
        result.snippets = keywordSnippets(folder, query, maxSnippets, contextLines, cancel);
        result.modeLabel = QStringLiteral("keyword (no embed index)");
        return result;
    }

    QString error;
    const int topK = want == QLatin1String("semantic") ? maxSnippets : qMax(maxSnippets * 2, 16);
    const QVector<EmbedHit> hits = searchStore(store, query, topK, net, cancel, &error);
    if (cancel.load() || error == QLatin1String("cancelled"))
        return {};
    if (!error.isEmpty()) {
        result.snippets = keywordSnippets(folder, query, maxSnippets, contextLines, cancel);
        result.modeLabel = QStringLiteral("keyword (embed failed)");
        return result;
    }
    if (want == QLatin1String("semantic")) {
        result.snippets = hitsAsSnippets(hits);
        result.modeLabel = QStringLiteral("embed");
        result.rootLabel = store.roots.isEmpty() ? QStringLiteral("embed-index") : store.roots.join(QStringLiteral(" + "));
        return result;
    }
    const QVector<Snippet> keyword = keywordSnippets(folder, query, maxSnippets, contextLines, cancel);
    if (cancel.load())
        return {};
    result.snippets = mergeHybrid(keyword, hits, maxSnippets);
    result.modeLabel = QStringLiteral("hybrid");
    return result;
}

void attachIndexer(AskForthIndexer *indexer) { g_indexer = indexer; }

void requestPrepare(const QString &folder, const QString &mode, bool force) {
    if (g_indexer.isNull())
        return;
    QMetaObject::invokeMethod(g_indexer.data(), "prepare", Qt::QueuedConnection, Q_ARG(QString, folder),
                              Q_ARG(QString, mode), Q_ARG(bool, force));
}

} // namespace AskForthEmbed

AskForthIndexer::AskForthIndexer(QObject *parent) : QObject(parent) {}

void AskForthIndexer::cancel() {
    m_cancel.store(true);
    m_forceAgain = false;
    if (m_reply != nullptr)
        m_reply->abort();
    if (m_loop != nullptr)
        m_loop->quit();
}

bool AskForthIndexer::exchange(const QUrl &url, const QByteArray &body, int timeoutMs, int *status, QByteArray *payload,
                               QString *error) {
    if (m_nam == nullptr)
        m_nam = new QNetworkAccessManager(this);
    *status = 0;
    payload->clear();
    error->clear();
    if (m_cancel.load()) {
        *error = QStringLiteral("cancelled");
        return false;
    }
    QNetworkRequest req{url};
    req.setTransferTimeout(timeoutMs);
    if (!body.isNull())
        req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));
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
    timer.start(qMax(1, timeoutMs));
    loop.exec();
    m_loop = nullptr;
    m_reply = nullptr;
    *status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    *payload = reply->readAll();
    if (m_cancel.load())
        *error = QStringLiteral("cancelled");
    else if (reply->error() != QNetworkReply::NoError && *status == 0)
        *error = reply->errorString();
    else if (*status < 200 || *status >= 300) {
        const QString detail = QString::fromUtf8(*payload).trimmed().left(160);
        *error = detail.isEmpty() ? QStringLiteral("HTTP %1").arg(*status)
                                  : QStringLiteral("HTTP %1: %2").arg(*status).arg(detail);
    }
    reply->deleteLater();
    return error->isEmpty();
}

bool AskForthIndexer::ping() {
    int status = 0;
    QByteArray payload;
    QString error;
    exchange(QUrl(ollamaBase() + QStringLiteral("/api/tags")), QByteArray(), 2000, &status, &payload, &error);
    return status == 200;
}

bool AskForthIndexer::modelInstalled(QString *error) {
    int status = 0;
    QByteArray payload;
    if (!exchange(QUrl(ollamaBase() + QStringLiteral("/api/tags")), QByteArray(), 5000, &status, &payload, error))
        return false;
    return AskForthEmbed::hasModel(AskForthEmbed::modelNames(payload), AskForthEmbed::embedModel());
}

bool AskForthIndexer::pullModel(QString *error) {
    if (m_nam == nullptr)
        m_nam = new QNetworkAccessManager(this);
    QJsonObject body;
    body.insert(QStringLiteral("model"), AskForthEmbed::embedModel());
    body.insert(QStringLiteral("stream"), true);
    QNetworkRequest req{QUrl(ollamaBase() + QStringLiteral("/api/pull"))};
    req.setHeader(QNetworkRequest::ContentTypeHeader, QStringLiteral("application/json"));
    req.setTransferTimeout(120000);
    QNetworkReply *reply = m_nam->post(req, QJsonDocument(body).toJson(QJsonDocument::Compact));
    m_reply = reply;
    QEventLoop loop;
    m_loop = &loop;
    QTimer timer;
    timer.setSingleShot(true);
    QByteArray pending;
    bool sawSuccess = false;
    QString pullError;
    const QString model = AskForthEmbed::embedModel();
    const auto takeLine = [&](const QByteArray &line) {
        const QJsonObject obj = QJsonDocument::fromJson(line.trimmed()).object();
        if (obj.isEmpty())
            return;
        const QString err = obj.value(QStringLiteral("error")).toString();
        if (!err.isEmpty()) {
            pullError = err.left(180);
            loop.quit();
            return;
        }
        const QString status = obj.value(QStringLiteral("status")).toString();
        const double total = obj.value(QStringLiteral("total")).toDouble();
        const double completed = obj.value(QStringLiteral("completed")).toDouble();
        if (total > 0) {
            const int pct = qMin(100, int((completed / total) * 100.0));
            emit activity(QStringLiteral("Downloading %1… %2%").arg(model).arg(pct), true);
        } else if (!status.isEmpty()) {
            emit activity(QStringLiteral("%1: %2").arg(model, status), true);
        }
        if (status == QLatin1String("success"))
            sawSuccess = true;
    };
    QObject::connect(reply, &QNetworkReply::readyRead, &loop, [&] {
        pending += reply->readAll();
        while (true) {
            const int nl = pending.indexOf('\n');
            if (nl < 0)
                break;
            const QByteArray line = pending.left(nl);
            pending.remove(0, nl + 1);
            takeLine(line);
        }
    });
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    QObject::connect(&timer, &QTimer::timeout, &loop, [&] {
        pullError = QStringLiteral("download timed out");
        reply->abort();
        loop.quit();
    });
    timer.start(3600000);
    loop.exec();
    if (!pending.trimmed().isEmpty())
        takeLine(pending);
    m_loop = nullptr;
    m_reply = nullptr;
    const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (!sawSuccess && status >= 200 && status < 300 && pullError.isEmpty() && !m_cancel.load()) {
        QString installedError;
        if (modelInstalled(&installedError))
            sawSuccess = true;
    }
    if (m_cancel.load())
        *error = QStringLiteral("cancelled");
    else if (!pullError.isEmpty())
        *error = pullError;
    else if (!sawSuccess)
        *error = status == 0 ? reply->errorString() : QStringLiteral("download did not report success");
    reply->deleteLater();
    if (sawSuccess && !m_cancel.load()) {
        emit activity(QStringLiteral("Downloaded %1.").arg(model), true);
        return true;
    }
    return false;
}

void AskForthIndexer::run(const QString &folder, bool force) {
    if (m_cancel.load())
        return;
    if (!ping()) {
        if (m_cancel.load())
            return;
        emit activity(QStringLiteral(
                          "Library Hybrid/Semantic needs Ollama for nomic-embed-text. Install from https://ollama.com and leave it running."),
                      false);
        return;
    }
    QString error;
    bool announced = false;
    if (!modelInstalled(&error)) {
        if (m_cancel.load() || error == QLatin1String("cancelled"))
            return;
        if (!error.isEmpty() && !ping()) {
            emit activity(QStringLiteral(
                              "Library Hybrid/Semantic needs Ollama for nomic-embed-text. Install from https://ollama.com and leave it running."),
                          false);
            return;
        }
        announced = true;
        emit activity(QStringLiteral("Downloading %1 for Library search…").arg(AskForthEmbed::embedModel()), true);
        if (!pullModel(&error)) {
            if (m_cancel.load() || error == QLatin1String("cancelled"))
                return;
            emit activity(QStringLiteral("Could not download %1: %2").arg(AskForthEmbed::embedModel(), error), false);
            return;
        }
    }
    if (m_cancel.load())
        return;
    AskForthEmbed::Net net;
    net.exchange = [this](const QUrl &url, const QByteArray &body, int timeoutMs, int *status, QString *err) {
        QByteArray payload;
        QString localError;
        int localStatus = 0;
        exchange(url, body, timeoutMs, &localStatus, &payload, &localError);
        if (status != nullptr)
            *status = localStatus;
        if (err != nullptr)
            *err = localError;
        return payload;
    };
    const QString result = ensureIndex(folder, force, net, m_cancel, [&](const QString &text) {
        announced = true;
        emit activity(text, true);
    });
    if (m_cancel.load() || result == QLatin1String("cancelled"))
        return;
    if (result == QLatin1String("fresh") || result.isEmpty()) {
        if (announced)
            emit activity(QString(), false);
        return;
    }
    emit activity(QStringLiteral("Library index failed: %1").arg(result.left(180)), false);
}

void AskForthIndexer::prepare(QString folder, QString mode, bool force) {
    if (m_running) {
        if (force)
            m_forceAgain = true;
        return;
    }
    if (!force && mode == QLatin1String("keyword"))
        return;
    m_running = true;
    m_cancel.store(false);
    run(folder, force);
    m_running = false;
    if (m_forceAgain && !m_cancel.load()) {
        m_forceAgain = false;
        prepare(folder, mode, true);
    }
}
