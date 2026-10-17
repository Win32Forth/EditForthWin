#pragma once

#include <QString>
#include <QWidget>

class QListWidget;

// Buffer against the file on disk. One tab lists the changed lines.
class DiskDiffView : public QWidget {
    Q_OBJECT
public:
    DiskDiffView(const QString &path, const QString &buffer, QWidget *parent = nullptr);

signals:
    void openLine(const QString &path, int line);
};
