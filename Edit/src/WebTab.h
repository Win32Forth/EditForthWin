#pragma once

#include <QWidget>

// Address tab. This Qt kit has no embedded web engine, so Go opens the system browser.
class WebTab : public QWidget {
    Q_OBJECT
public:
    explicit WebTab(QWidget *parent = nullptr);

signals:
    void sendToAskForth(const QString &url);
};
