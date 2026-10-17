#pragma once

#include <QString>
#include <QVector>
#include <QWidget>

class QListWidget;

struct SearchHit {
    QString path;
    int line = 1;
    int column = 1;
    QString snippet;
};

struct SearchRequest {
    QStringList roots;
    QStringList extensions;
    QString query;
    bool caseSensitive = false;
    bool wholeWord = false;
    bool recursive = true;
};

struct SearchOutcome {
    QVector<SearchHit> hits;
    bool truncated = false;
    int filesScanned = 0;
};

SearchOutcome searchFolders(const SearchRequest &request);

// Edit → Search in Folders… Remembers the last query, folders, and extensions.
bool runFolderSearchDialog(QWidget *parent, const QString &startDir, SearchRequest *request);

class SearchResults : public QWidget {
    Q_OBJECT
public:
    SearchResults(const QString &summary, const QVector<SearchHit> &hits, QWidget *parent = nullptr);

signals:
    void openHit(const QString &path, int line, int column);
};
