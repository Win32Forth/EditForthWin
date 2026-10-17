#include "FolderSearch.h"

#include <QCheckBox>
#include <QDir>
#include <QDirIterator>
#include <QDialog>
#include <QDialogButtonBox>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QListWidget>
#include <QPlainTextEdit>
#include <QPushButton>
#include <QSettings>
#include <QVBoxLayout>

namespace {

const int kMaxHits = 5000;

const char *kSkipDirs[] = {".git", ".svn", "DerivedData", "node_modules", ".build", "xcuserdata"};

bool skipDir(const QString &name) {
    for (const char *skip : kSkipDirs) {
        if (name.compare(QLatin1String(skip), Qt::CaseInsensitive) == 0)
            return true;
    }
    return name.endsWith(QLatin1String(".app"), Qt::CaseInsensitive) ||
           name.endsWith(QLatin1String(".framework"), Qt::CaseInsensitive) ||
           name.endsWith(QLatin1String(".xcarchive"), Qt::CaseInsensitive);
}

bool extensionOk(const QString &path, const QStringList &extensions) {
    const QString ext = QFileInfo(path).suffix().toLower();
    return extensions.contains(ext);
}

bool wordBounded(const QString &line, int at, int n) {
    auto word = [](QChar c) { return c.isLetterOrNumber() || c == QLatin1Char('_'); };
    if (at > 0 && word(line.at(at - 1)))
        return false;
    const int after = at + n;
    return after >= line.size() || !word(line.at(after));
}

void scanFile(const QString &path, const SearchRequest &request, SearchOutcome *out) {
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
        return;
    const QString text = QString::fromUtf8(file.readAll());
    const QString needle = request.query;
    const Qt::CaseSensitivity sense =
        request.caseSensitive ? Qt::CaseSensitive : Qt::CaseInsensitive;
    int lineNo = 1;
    int start = 0;
    while (start <= text.size()) {
        int end = text.indexOf(QLatin1Char('\n'), start);
        if (end < 0)
            end = text.size();
        QString line = text.mid(start, end - start);
        if (line.endsWith(QLatin1Char('\r')))
            line.chop(1);
        int at = 0;
        while (at >= 0) {
            at = line.indexOf(needle, at, sense);
            if (at < 0)
                break;
            if (!request.wholeWord || wordBounded(line, at, needle.size())) {
                SearchHit hit;
                hit.path = path;
                hit.line = lineNo;
                hit.column = at + 1;
                hit.snippet = line.trimmed();
                if (hit.snippet.size() > 240)
                    hit.snippet = hit.snippet.left(240);
                out->hits.append(hit);
                if (out->hits.size() >= kMaxHits) {
                    out->truncated = true;
                    return;
                }
            }
            at += qMax(1, needle.size());
        }
        if (end >= text.size())
            break;
        start = end + 1;
        ++lineNo;
    }
}

} // namespace

SearchOutcome searchFolders(const SearchRequest &request) {
    SearchOutcome out;
    if (request.query.isEmpty())
        return out;
    QStringList extensions;
    for (QString ext : request.extensions) {
        ext = ext.trimmed().toLower();
        if (ext.startsWith(QLatin1Char('.')))
            ext.remove(0, 1);
        if (!ext.isEmpty())
            extensions.append(ext);
    }
    SearchRequest local = request;
    local.extensions = extensions;
    for (const QString &root : request.roots) {
        QFileInfo info(root);
        if (!info.exists())
            continue;
        if (info.isFile()) {
            if (extensionOk(info.absoluteFilePath(), extensions)) {
                ++out.filesScanned;
                scanFile(info.absoluteFilePath(), local, &out);
            }
            if (out.truncated)
                return out;
            continue;
        }
        if (!request.recursive) {
            const QFileInfoList files =
                QDir(info.absoluteFilePath()).entryInfoList(QDir::Files | QDir::NoDotAndDotDot);
            for (const QFileInfo &file : files) {
                if (!extensionOk(file.absoluteFilePath(), extensions))
                    continue;
                ++out.filesScanned;
                scanFile(file.absoluteFilePath(), local, &out);
                if (out.truncated)
                    return out;
            }
            continue;
        }
        QDirIterator it(info.absoluteFilePath(), QDirIterator::Subdirectories);
        while (it.hasNext()) {
            const QString path = it.next();
            const QFileInfo file(path);
            if (!file.isFile() || !extensionOk(path, extensions))
                continue;
            const QStringList parts = QDir::toNativeSeparators(path).split(QLatin1Char('\\'));
            bool skipped = false;
            for (const QString &part : parts) {
                if (skipDir(part)) {
                    skipped = true;
                    break;
                }
            }
            if (skipped)
                continue;
            ++out.filesScanned;
            scanFile(path, local, &out);
            if (out.truncated)
                return out;
        }
    }
    return out;
}

bool runFolderSearchDialog(QWidget *parent, const QString &startDir, SearchRequest *request) {
    QSettings settings;
    QDialog dialog(parent);
    dialog.setWindowTitle(QStringLiteral("Search in Folders"));
    dialog.resize(560, 360);
    auto *query = new QLineEdit(settings.value(QStringLiteral("searchQuery")).toString(), &dialog);
    auto *folders = new QPlainTextEdit(&dialog);
    folders->setPlainText(settings.value(QStringLiteral("searchFolders"), startDir).toString());
    folders->setPlaceholderText(QStringLiteral("One folder path per line"));
    auto *extensions = new QLineEdit(
        settings.value(QStringLiteral("searchExtensions"), QStringLiteral("fth, fs, 4th, f, txt"))
            .toString(),
        &dialog);
    auto *nested = new QCheckBox(QStringLiteral("Include subfolders"), &dialog);
    nested->setChecked(settings.value(QStringLiteral("searchNested"), true).toBool());
    auto *matchCase = new QCheckBox(QStringLiteral("Case sensitive"), &dialog);
    matchCase->setChecked(settings.value(QStringLiteral("searchCase"), false).toBool());
    auto *whole = new QCheckBox(QStringLiteral("Whole word"), &dialog);
    whole->setChecked(settings.value(QStringLiteral("searchWord"), false).toBool());
    auto *add = new QPushButton(QStringLiteral("Add Folder..."), &dialog);
    QObject::connect(add, &QPushButton::clicked, &dialog, [&] {
        const QString dir = QFileDialog::getExistingDirectory(&dialog, QStringLiteral("Search Folder"),
                                                              startDir);
        if (dir.isEmpty())
            return;
        QString text = folders->toPlainText();
        if (!text.isEmpty() && !text.endsWith(QLatin1Char('\n')))
            text += QLatin1Char('\n');
        folders->setPlainText(text + dir);
    });
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel, &dialog);
    QObject::connect(buttons, &QDialogButtonBox::accepted, &dialog, &QDialog::accept);
    QObject::connect(buttons, &QDialogButtonBox::rejected, &dialog, &QDialog::reject);

    auto *box = new QVBoxLayout(&dialog);
    box->addWidget(new QLabel(QStringLiteral("Find"), &dialog));
    box->addWidget(query);
    box->addWidget(new QLabel(QStringLiteral("Folders"), &dialog));
    box->addWidget(folders, 1);
    box->addWidget(add);
    box->addWidget(new QLabel(QStringLiteral("Extensions"), &dialog));
    box->addWidget(extensions);
    auto *checks = new QHBoxLayout;
    checks->addWidget(nested);
    checks->addWidget(matchCase);
    checks->addWidget(whole);
    checks->addStretch(1);
    box->addLayout(checks);
    box->addWidget(buttons);
    if (dialog.exec() != QDialog::Accepted)
        return false;
    request->query = query->text();
    request->roots.clear();
    const QStringList lines = folders->toPlainText().split(QLatin1Char('\n'));
    for (QString line : lines) {
        line = line.trimmed();
        if (!line.isEmpty())
            request->roots.append(line);
    }
    request->extensions = extensions->text().split(QLatin1Char(','));
    request->recursive = nested->isChecked();
    request->caseSensitive = matchCase->isChecked();
    request->wholeWord = whole->isChecked();
    settings.setValue(QStringLiteral("searchQuery"), request->query);
    settings.setValue(QStringLiteral("searchFolders"), folders->toPlainText());
    settings.setValue(QStringLiteral("searchExtensions"), extensions->text());
    settings.setValue(QStringLiteral("searchNested"), request->recursive);
    settings.setValue(QStringLiteral("searchCase"), request->caseSensitive);
    settings.setValue(QStringLiteral("searchWord"), request->wholeWord);
    return !request->query.trimmed().isEmpty() && !request->roots.isEmpty();
}

SearchResults::SearchResults(const QString &summary, const QVector<SearchHit> &hits, QWidget *parent)
    : QWidget(parent) {
    auto *title = new QLabel(summary, this);
    title->setWordWrap(true);
    auto *list = new QListWidget(this);
    for (const SearchHit &hit : hits) {
        auto *item = new QListWidgetItem(
            QStringLiteral("%1:%2: %3").arg(hit.path).arg(hit.line).arg(hit.snippet), list);
        item->setData(Qt::UserRole, hit.path);
        item->setData(Qt::UserRole + 1, hit.line);
        item->setData(Qt::UserRole + 2, hit.column);
    }
    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(8, 8, 8, 8);
    box->addWidget(title);
    box->addWidget(list, 1);
    connect(list, &QListWidget::itemActivated, this, [this](QListWidgetItem *item) {
        emit openHit(item->data(Qt::UserRole).toString(), item->data(Qt::UserRole + 1).toInt(),
                     item->data(Qt::UserRole + 2).toInt());
    });
}
