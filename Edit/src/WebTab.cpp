#include "WebTab.h"

#include <QDesktopServices>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QListWidget>
#include <QPushButton>
#include <QSettings>
#include <QUrl>
#include <QVBoxLayout>

WebTab::WebTab(QWidget *parent) : QWidget(parent) {
    auto *address = new QLineEdit(QStringLiteral("https://forth-standard.org"), this);
    auto *go = new QPushButton(QStringLiteral("Open"), this);
    auto *send = new QPushButton(QStringLiteral("Send to Ask Forth"), this);
    send->setToolTip(QStringLiteral("Append this address to the Ask Forth prompt."));
    auto *note = new QLabel(
        QStringLiteral("Opens in the system browser. This Qt kit has no embedded web view."), this);
    note->setWordWrap(true);
    auto *recent = new QListWidget(this);
    QSettings settings;
    const QStringList history = settings.value(QStringLiteral("webHistory")).toStringList();
    for (const QString &url : history)
        recent->addItem(url);

    auto openUrl = [address, recent] {
        QString text = address->text().trimmed();
        if (text.isEmpty())
            return;
        if (!text.contains(QLatin1String("://")))
            text = QStringLiteral("https://") + text;
        address->setText(text);
        const QUrl url(text);
        if (!url.isValid())
            return;
        QDesktopServices::openUrl(url);
        QSettings store;
        QStringList history = store.value(QStringLiteral("webHistory")).toStringList();
        history.removeAll(text);
        history.prepend(text);
        while (history.size() > 20)
            history.removeLast();
        store.setValue(QStringLiteral("webHistory"), history);
        recent->clear();
        for (const QString &item : history)
            recent->addItem(item);
    };

    auto *bar = new QHBoxLayout;
    bar->addWidget(address, 1);
    bar->addWidget(go);
    bar->addWidget(send);
    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(8, 8, 8, 8);
    box->addLayout(bar);
    box->addWidget(note);
    box->addWidget(new QLabel(QStringLiteral("Recent"), this));
    box->addWidget(recent, 1);
    connect(go, &QPushButton::clicked, this, openUrl);
    connect(address, &QLineEdit::returnPressed, this, openUrl);
    connect(send, &QPushButton::clicked, this, [this, address] {
        QString text = address->text().trimmed();
        if (text.isEmpty())
            return;
        if (!text.contains(QLatin1String("://")))
            text = QStringLiteral("https://") + text;
        address->setText(text);
        if (!QUrl(text).isValid())
            return;
        emit sendToAskForth(text);
    });
    connect(recent, &QListWidget::itemActivated, this, [address, openUrl](QListWidgetItem *item) {
        address->setText(item->text());
        openUrl();
    });
}
