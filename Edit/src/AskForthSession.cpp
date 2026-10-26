#include "AskForthSession.h"

namespace AskForthSession {
namespace {

const QString kLive = QStringLiteral("\\ --- live ---");
const QString kDraft = QStringLiteral("\\ --- earlier draft ---");
constexpr int kContextCap = 16000;

QString normalize(const QString &text) {
    QString out = text;
    out.replace(QStringLiteral("\r\n"), QStringLiteral("\n"));
    out.replace(QLatin1Char('\r'), QLatin1Char('\n'));
    return out;
}

QStringList splitLines(const QString &text) {
    return text.split(QLatin1Char('\n'), Qt::KeepEmptyParts);
}

QString trimNewlines(QString text) {
    while (text.startsWith(QLatin1Char('\n')))
        text.remove(0, 1);
    while (text.endsWith(QLatin1Char('\n')))
        text.chop(1);
    return text;
}

QString sanitizeHeader(const QString &text) {
    return normalize(text).replace(QLatin1Char('{'), QStringLiteral("(brace)"));
}

bool isExact(const QString &line, const QString &marker) {
    return line.trimmed() == marker;
}

bool isAgentNote(const QString &line) {
    return line.trimmed().startsWith(QStringLiteral("\\ Agent enhance:"));
}

bool isPromptStart(const QString &line) {
    const QString trimmed = line.trimmed();
    const QString prefix = QStringLiteral("\\ Prompt");
    if (!trimmed.startsWith(prefix))
        return false;
    const QString rest = trimmed.mid(prefix.size());
    if (rest == QLatin1String(":"))
        return true;
    if (!rest.startsWith(QLatin1Char(' ')))
        return false;
    const QString after = rest.mid(1);
    if (!after.endsWith(QLatin1Char(':')))
        return false;
    const QString number = after.left(after.size() - 1);
    if (number.isEmpty())
        return false;
    for (const QChar ch : number) {
        if (!ch.isDigit())
            return false;
    }
    return true;
}

QString referenceLabel(const QString &path) {
    const QString trimmed = path.trimmed();
    return trimmed.isEmpty() ? QStringLiteral("(none)") : trimmed;
}

QString parseReferenceLine(const QString &line) {
    const QString prefix = QStringLiteral("\\ Reference:");
    if (!line.startsWith(prefix))
        return QString();
    const QString value = line.mid(prefix.size()).trimmed();
    if (value.isEmpty() || value == QLatin1String("(none)"))
        return QString();
    return value;
}

QString promptBodyLine(const QString &line) {
    if (line == QLatin1String("\\"))
        return QString();
    if (line.startsWith(QStringLiteral("\\ ")))
        return line.mid(2);
    return QString();
}

bool hasPromptBody(const QString &line) {
    return line == QLatin1String("\\") || line.startsWith(QStringLiteral("\\ "));
}

QString storedPromptLine(const QString &rawLine) {
    const QString safe = sanitizeHeader(rawLine).replace(QLatin1Char('\n'), QLatin1Char(' '));
    if (safe.isEmpty())
        return QStringLiteral("\\");
    const QString line = QStringLiteral("\\ ") + safe;
    if (isPromptStart(line) || isAgentNote(line))
        return QStringLiteral("\\  ") + safe;
    return line;
}

QString storedNoteLine(const QString &note) {
    QString line = note.trimmed();
    if (line.isEmpty())
        return QStringLiteral("\\ Agent enhance: status=unknown");
    if (!line.startsWith(QLatin1Char('\\')))
        line = QStringLiteral("\\ ") + line;
    return sanitizeHeader(line);
}

QVector<Entry> parseEntries(const QStringList &header) {
    QVector<Entry> entries;
    int i = 0;
    while (i < header.size()) {
        const QString line = header.at(i);
        if (isPromptStart(line)) {
            ++i;
            QString reference;
            if (i < header.size() && header.at(i).startsWith(QStringLiteral("\\ Reference:"))) {
                reference = parseReferenceLine(header.at(i));
                ++i;
            }
            QStringList textLines;
            while (i < header.size()) {
                const QString current = header.at(i);
                if (isPromptStart(current) || isAgentNote(current))
                    break;
                if (hasPromptBody(current))
                    textLines << promptBodyLine(current);
                ++i;
            }
            Entry entry;
            entry.text = textLines.join(QLatin1Char('\n'));
            entry.reference = reference;
            entries.append(entry);
        } else if (isAgentNote(line)) {
            Entry entry;
            entry.note = true;
            entry.text = storedNoteLine(line);
            entries.append(entry);
            ++i;
        } else {
            ++i;
        }
    }
    return entries;
}

QString neutralizeMarker(const QString &line) {
    if (isExact(line, kLive) || isExact(line, kDraft))
        return QStringLiteral("\\ ") + line;
    return line;
}

bool firstTokenForbidden(const QString &line) {
    int i = 0;
    while (i < line.size() && (line.at(i) == QLatin1Char(' ') || line.at(i) == QLatin1Char('\t')))
        ++i;
    if (i >= line.size())
        return false;
    int end = i;
    while (end < line.size() && !line.at(end).isSpace())
        ++end;
    const QString token = line.mid(i, end - i);
    return token == QLatin1String("\\\\") || token == QLatin1String("\\\\S") || token == QLatin1String("\\S");
}

QString neutralizeCodeLine(const QString &line) {
    if (line.isEmpty())
        return line;
    if (isExact(line, kLive) || isExact(line, kDraft) || firstTokenForbidden(line))
        return QStringLiteral("\\ ") + line;
    return line;
}

QString commentProse(const QString &prose) {
    QString text = prose;
    if (text.startsWith(QLatin1Char('\n')))
        text.remove(0, 1);
    if (text.endsWith(QLatin1Char('\n')))
        text.chop(1);
    if (text.isEmpty())
        return QString();
    QStringList out;
    const QStringList lines = splitLines(text);
    for (const QString &line : lines) {
        if (line.isEmpty())
            out << QStringLiteral("\\");
        else if (line == QLatin1String("\\") || line.startsWith(QStringLiteral("\\ ")))
            out << neutralizeMarker(line);
        else
            out << neutralizeMarker(QStringLiteral("\\ ") + line);
    }
    return out.join(QLatin1Char('\n'));
}

QString sanitizeCode(const QString &code) {
    if (code.isEmpty())
        return QString();
    QStringList out;
    const QStringList lines = splitLines(code);
    for (const QString &line : lines)
        out << neutralizeCodeLine(line);
    return out.join(QLatin1Char('\n'));
}

struct Piece {
    bool code = false;
    QString text;
};

QVector<Piece> fencedPieces(const QString &text) {
    const QString fence = QStringLiteral("```");
    QVector<Piece> pieces;
    if (!text.contains(fence)) {
        Piece one;
        one.code = true;
        one.text = text;
        pieces.append(one);
        return pieces;
    }
    const QStringList parts = text.split(fence, Qt::KeepEmptyParts);
    for (int i = 0; i < parts.size(); ++i) {
        Piece piece;
        piece.code = (i % 2) == 1;
        piece.text = parts.at(i);
        if (piece.code) {
            const int newline = piece.text.indexOf(QLatin1Char('\n'));
            piece.text = newline < 0 ? QString() : piece.text.mid(newline + 1);
        }
        pieces.append(piece);
    }
    return pieces;
}

bool parenCommentIsOpen(const QString &text) {
    int state = 0;
    int index = 0;
    while (index < text.size()) {
        const QChar ch = text.at(index);
        if (state == 1) {
            if (ch == QLatin1Char('\n'))
                state = 0;
            ++index;
            continue;
        }
        if (state == 2) {
            if (ch == QLatin1Char(')'))
                state = 0;
            ++index;
            continue;
        }
        if (state == 3) {
            if (ch == QLatin1Char('"'))
                state = 0;
            else if (ch == QLatin1Char('\\') && index + 1 < text.size()) {
                index += 2;
                continue;
            }
            ++index;
            continue;
        }
        if (ch == QLatin1Char(' ') || ch == QLatin1Char('\t') || ch == QLatin1Char('\n') ||
            ch == QLatin1Char('\r')) {
            ++index;
            continue;
        }
        const int start = index;
        while (index < text.size()) {
            const QChar c = text.at(index);
            if (c == QLatin1Char(' ') || c == QLatin1Char('\t') || c == QLatin1Char('\n') ||
                c == QLatin1Char('\r'))
                break;
            ++index;
        }
        const QString token = text.mid(start, index - start);
        if (token == QLatin1String("\\"))
            state = 1;
        else if (token == QLatin1String("(") || token == QLatin1String(".("))
            state = 2;
        else if (token == QLatin1String(".\"") || token == QLatin1String("S\"") ||
                 token == QLatin1String("C\"") || token == QLatin1String("ABORT\"") ||
                 token == QLatin1String("S\\\""))
            state = 3;
    }
    return state == 2;
}

QString closeUnclosedParenComments(const QString &text) {
    if (!parenCommentIsOpen(text))
        return text;
    if (text.isEmpty())
        return QStringLiteral(")");
    if (text.back().isSpace())
        return text + QLatin1Char(')');
    return text + QStringLiteral(" )");
}

} // namespace

Document parse(const QString &text) {
    const QStringList lines = splitLines(normalize(text));
    QStringList header;
    QStringList body;
    bool sawCloser = false;
    for (const QString &line : lines) {
        if (!sawCloser && line.trimmed() == QLatin1String("{")) {
            sawCloser = true;
            continue;
        }
        if (sawCloser)
            body << line;
        else
            header << line;
    }
    Document doc;
    if (!sawCloser) {
        doc.live = trimNewlines(normalize(text));
        return doc;
    }
    doc.entries = parseEntries(header);
    int liveAt = -1;
    for (int i = body.size() - 1; i >= 0; --i) {
        if (isExact(body.at(i), kLive)) {
            liveAt = i;
            break;
        }
    }
    if (liveAt >= 0) {
        doc.archive = trimNewlines(body.mid(0, liveAt).join(QLatin1Char('\n')));
        doc.live = trimNewlines(body.mid(liveAt + 1).join(QLatin1Char('\n')));
    } else {
        doc.live = trimNewlines(body.join(QLatin1Char('\n')));
    }
    return doc;
}

QString renderHeader(const QString &model, const QString &temperature, const QStringList &settingLines,
                     const QString &sessionReference, const QVector<Entry> &entries) {
    const QString modelText = model.trimmed().isEmpty() ? QStringLiteral("(none)") : model.trimmed();
    QStringList lines;
    lines << QStringLiteral("\\\\ Ask Forth");
    lines << QStringLiteral("\\ Model: %1").arg(sanitizeHeader(modelText));
    lines << QStringLiteral("\\ Temperature: %1").arg(sanitizeHeader(temperature));
    for (const QString &raw : settingLines) {
        const QString safe = sanitizeHeader(raw).replace(QLatin1Char('\n'), QLatin1Char(' '));
        if (!safe.isEmpty())
            lines << QStringLiteral("\\ ") + safe;
    }
    lines << QStringLiteral("\\ Reference: %1").arg(sanitizeHeader(referenceLabel(sessionReference)));
    lines << QStringLiteral("\\ Earlier drafts are line comments. INCLUDE loads only the newest section.");
    lines << QStringLiteral("\\");
    int promptIndex = 0;
    for (const Entry &entry : entries) {
        if (!entry.note) {
            ++promptIndex;
            lines << QStringLiteral("\\ Prompt %1:").arg(promptIndex);
            lines << QStringLiteral("\\ Reference: %1").arg(sanitizeHeader(referenceLabel(entry.reference)));
            const QStringList parts = splitLines(normalize(entry.text));
            if (parts.isEmpty())
                lines << QStringLiteral("\\");
            else {
                for (const QString &part : parts)
                    lines << storedPromptLine(part);
            }
        } else {
            lines << storedNoteLine(entry.text);
        }
    }
    lines << QStringLiteral("{");
    return lines.join(QLatin1Char('\n')) + QLatin1Char('\n');
}

QString renderPrefix(const QString &header, const QString &archive) {
    QString out = header;
    if (!out.endsWith(QLatin1Char('\n')))
        out += QLatin1Char('\n');
    const QString arch = trimNewlines(archive);
    if (!arch.isEmpty()) {
        out += QLatin1Char('\n');
        out += arch;
        out += QLatin1Char('\n');
    }
    out += QLatin1Char('\n');
    out += kLive;
    out += QLatin1Char('\n');
    return out;
}

QString archiveLive(const QString &live) {
    const QString core = trimNewlines(live);
    if (core.trimmed().isEmpty())
        return QString();
    QStringList out;
    out << kDraft;
    const QStringList lines = splitLines(core);
    for (const QString &line : lines)
        out << (line.isEmpty() ? QStringLiteral("\\") : QStringLiteral("\\ ") + line);
    return out.join(QLatin1Char('\n'));
}

QString combineArchive(const QString &existing, const QString &added) {
    const QString a = trimNewlines(existing);
    const QString b = trimNewlines(added);
    if (a.isEmpty())
        return b;
    if (b.isEmpty())
        return a;
    return a + QStringLiteral("\n\n") + b;
}

QString sanitizeLive(const QString &text, bool closeParens) {
    const QString normalized = normalize(text);
    QString out;
    const QVector<Piece> pieces = fencedPieces(normalized);
    for (const Piece &piece : pieces) {
        const QString rendered = piece.code ? sanitizeCode(piece.text) : commentProse(piece.text);
        if (rendered.isEmpty())
            continue;
        if (!out.isEmpty() && !out.endsWith(QLatin1Char('\n')))
            out += QLatin1Char('\n');
        out += rendered;
    }
    if (closeParens)
        out = closeUnclosedParenComments(out);
    return out;
}

QString agentEnhanceNote(const QString &transcript) {
    QString status;
    QString depth;
    int from = 0;
    while (true) {
        const int at = transcript.indexOf(QStringLiteral("status="), from);
        if (at < 0)
            break;
        int i = at + 7;
        const int numStart = i;
        if (i < transcript.size() && transcript.at(i) == QLatin1Char('-'))
            ++i;
        while (i < transcript.size() && transcript.at(i).isDigit())
            ++i;
        if (i > numStart) {
            status = transcript.mid(numStart, i - numStart);
            const int depthAt = transcript.indexOf(QStringLiteral("depth="), i);
            if (depthAt >= 0) {
                int d = depthAt + 6;
                const int depthStart = d;
                if (d < transcript.size() && transcript.at(d) == QLatin1Char('-'))
                    ++d;
                while (d < transcript.size() && transcript.at(d).isDigit())
                    ++d;
                if (d > depthStart)
                    depth = transcript.mid(depthStart, d - depthStart);
            }
        }
        from = i;
    }
    if (!status.isEmpty() && !depth.isEmpty())
        return QStringLiteral("\\ Agent enhance: status=%1 depth=%2").arg(status, depth);
    if (transcript.contains(QStringLiteral("DONE (failed)")))
        return QStringLiteral("\\ Agent enhance: status=failed");
    if (transcript.contains(QStringLiteral("DONE (ok)")))
        return QStringLiteral("\\ Agent enhance: status=0");
    return QStringLiteral("\\ Agent enhance: status=unknown");
}

QString modelPreface(const QVector<Entry> &entries, const QString &previousLive) {
    QStringList parts;
    parts << QStringLiteral(
        "This continues an Ask Forth session. Reply with only the new live Forth for the new request. "
        "Do not repeat the header, earlier prompts, or earlier drafts. The host comments out the previous "
        "live section; your reply is the only Forth INCLUDE loads.");
    QString promptBlock;
    int count = 0;
    for (const Entry &entry : entries) {
        if (entry.note)
            continue;
        ++count;
        if (!promptBlock.isEmpty())
            promptBlock += QLatin1Char('\n');
        promptBlock += QString::number(count) + QStringLiteral(". ");
        if (!entry.reference.isEmpty())
            promptBlock += QStringLiteral("[reference: %1] ").arg(entry.reference);
        promptBlock += entry.text;
    }
    if (count > 0)
        parts << QStringLiteral("Earlier prompts:\n") + promptBlock;
    QString live = trimNewlines(previousLive);
    if (!live.trimmed().isEmpty()) {
        if (live.size() > kContextCap)
            live = live.left(kContextCap) + QStringLiteral("\n[truncated — previous live Forth continues]");
        parts << QStringLiteral("Previous live Forth:\n") + live;
    }
    return parts.join(QStringLiteral("\n\n"));
}

QString referenceContextBlock(const QString &path, const QString &contents, bool readable) {
    if (!readable)
        return QStringLiteral("Read-only reference file could not be read: %1\nContinue without its contents.")
            .arg(path);
    QString body = contents;
    QString note;
    if (body.size() > kContextCap) {
        body = body.left(kContextCap);
        note = QStringLiteral("\n[truncated — reference file continues beyond %1 characters]").arg(kContextCap);
    }
    return QStringLiteral(
               "Read-only reference file (never write this file; put suggestions only in the Ask Forth reply):\n"
               "Path: %1\n%2%3")
        .arg(path, body, note);
}

QString lastReference(const QVector<Entry> &entries) {
    for (int i = entries.size() - 1; i >= 0; --i) {
        if (!entries.at(i).note && !entries.at(i).reference.isEmpty())
            return entries.at(i).reference;
    }
    return QString();
}

} // namespace AskForthSession
