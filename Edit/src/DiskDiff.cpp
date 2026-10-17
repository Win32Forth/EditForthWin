#include "DiskDiff.h"

#include <QFile>
#include <QFileInfo>
#include <QHBoxLayout>
#include <QLabel>
#include <QListWidget>
#include <QPushButton>
#include <QVBoxLayout>

#include <algorithm>
#include <vector>

namespace {

const int kMaxLines = 1500;

struct Row {
    int bufLine = 0;
    int diskLine = 0;
    QChar kind;
    QString text;
};

std::vector<Row> diffLines(const QStringList &buf, const QStringList &disk) {
    const int n = buf.size();
    const int m = disk.size();
    std::vector<int> dp((size_t)(n + 1) * (m + 1), 0);
    auto at = [m](int i, int j) -> size_t { return (size_t)i * (m + 1) + (size_t)j; };
    for (int i = n - 1; i >= 0; --i) {
        for (int j = m - 1; j >= 0; --j) {
            if (buf.at(i) == disk.at(j))
                dp[at(i, j)] = dp[at(i + 1, j + 1)] + 1;
            else
                dp[at(i, j)] = std::max(dp[at(i + 1, j)], dp[at(i, j + 1)]);
        }
    }
    std::vector<Row> rows;
    int i = 0;
    int j = 0;
    while (i < n && j < m) {
        if (buf.at(i) == disk.at(j)) {
            ++i;
            ++j;
        } else if (dp[at(i + 1, j)] >= dp[at(i, j + 1)]) {
            Row row;
            row.kind = QLatin1Char('-');
            row.bufLine = i + 1;
            row.text = buf.at(i);
            rows.push_back(row);
            ++i;
        } else {
            Row row;
            row.kind = QLatin1Char('+');
            row.diskLine = j + 1;
            row.bufLine = i + 1;
            row.text = disk.at(j);
            rows.push_back(row);
            ++j;
        }
    }
    while (i < n) {
        Row row;
        row.kind = QLatin1Char('-');
        row.bufLine = i + 1;
        row.text = buf.at(i);
        rows.push_back(row);
        ++i;
    }
    while (j < m) {
        Row row;
        row.kind = QLatin1Char('+');
        row.diskLine = j + 1;
        row.bufLine = n + 1;
        row.text = disk.at(j);
        rows.push_back(row);
        ++j;
    }
    return rows;
}

} // namespace

DiskDiffView::DiskDiffView(const QString &path, const QString &buffer, QWidget *parent) : QWidget(parent) {
    auto *title = new QLabel(this);
    title->setWordWrap(true);
    auto *list = new QListWidget(this);
    auto *open = new QPushButton(QStringLiteral("Show in Editor"), this);
    open->setEnabled(false);

    QFile file(path);
    QString diskText;
    bool readable = file.open(QIODevice::ReadOnly);
    if (readable)
        diskText = QString::fromUtf8(file.readAll());
    QString bufferNorm = buffer;
    bufferNorm.replace(QStringLiteral("\r\n"), QStringLiteral("\n"));
    diskText.replace(QStringLiteral("\r\n"), QStringLiteral("\n"));
    if (bufferNorm.endsWith(QLatin1Char('\n')))
        bufferNorm.chop(1);
    if (diskText.endsWith(QLatin1Char('\n')))
        diskText.chop(1);
    const QStringList bufLines = bufferNorm.split(QLatin1Char('\n'));
    const QStringList diskLines = readable ? diskText.split(QLatin1Char('\n')) : QStringList();

    if (!readable) {
        title->setText(QStringLiteral("Can't read %1").arg(path));
    } else if (bufLines.size() > kMaxLines || diskLines.size() > kMaxLines) {
        title->setText(QStringLiteral("%1 has %2 lines in the editor and %3 on disk. "
                                      "Compare handles files up to %4 lines.")
                           .arg(QFileInfo(path).fileName())
                           .arg(bufLines.size())
                           .arg(diskLines.size())
                           .arg(kMaxLines));
    } else if (bufferNorm == diskText) {
        title->setText(QStringLiteral("%1 matches the file on disk.").arg(QFileInfo(path).fileName()));
    } else {
        const std::vector<Row> rows = diffLines(bufLines, diskLines);
        title->setText(QStringLiteral("%1 — %2 changed line%3. Minus is the editor, plus is the disk.")
                           .arg(QFileInfo(path).fileName())
                           .arg(rows.size())
                           .arg(rows.size() == 1 ? QString() : QStringLiteral("s")));
        for (const Row &row : rows) {
            QString text = row.text;
            if (text.size() > 240)
                text = text.left(240);
            auto *item = new QListWidgetItem(
                QStringLiteral("%1 %2  %3").arg(row.kind).arg(row.bufLine, 5).arg(text), list);
            item->setData(Qt::UserRole, row.bufLine);
        }
    }

    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(8, 8, 8, 8);
    box->addWidget(title);
    box->addWidget(list, 1);
    auto *row = new QHBoxLayout;
    row->addWidget(open);
    row->addStretch(1);
    box->addLayout(row);
    connect(list, &QListWidget::currentItemChanged, this, [open](QListWidgetItem *item, QListWidgetItem *) {
        open->setEnabled(item != nullptr);
    });
    connect(list, &QListWidget::itemActivated, this, [this, path](QListWidgetItem *item) {
        emit openLine(path, item->data(Qt::UserRole).toInt());
    });
    connect(open, &QPushButton::clicked, this, [this, list, path] {
        QListWidgetItem *item = list->currentItem();
        if (item != nullptr)
            emit openLine(path, item->data(Qt::UserRole).toInt());
    });
}
