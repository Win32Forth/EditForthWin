#pragma once

#include <QString>
#include <QStringList>
#include <QVector>

// Host-owned Ask Forth session file. The model never rewrites the header.
// Earlier drafts are line comments, so INCLUDE loads only the newest section.
// An F-PC \\ block comment ends at the next {, so old drafts are not wrapped that way.
namespace AskForthSession {

struct Entry {
    bool note = false;
    QString text;
    QString reference;
};

struct Document {
    QVector<Entry> entries;
    QString archive;
    QString live;
};

Document parse(const QString &text);
QString renderHeader(const QString &model, const QString &temperature, const QStringList &settingLines,
                     const QString &sessionReference, const QVector<Entry> &entries);
QString renderPrefix(const QString &header, const QString &archive);
QString archiveLive(const QString &live);
QString combineArchive(const QString &existing, const QString &added);
QString sanitizeLive(const QString &text, bool closeParens);
QString agentEnhanceNote(const QString &transcript);
QString modelPreface(const QVector<Entry> &entries, const QString &previousLive);
QString referenceContextBlock(const QString &path, const QString &contents, bool readable);
QString lastReference(const QVector<Entry> &entries);

} // namespace AskForthSession
