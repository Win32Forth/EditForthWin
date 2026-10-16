#include "DebugBar.h"

#include <QDialog>
#include <QStringList>
#include <QHBoxLayout>
#include <QLabel>
#include <QListWidget>
#include <QPushButton>
#include <QVBoxLayout>

namespace {

const char kOn[] = "color: #1b7a32; font-weight: 600;";
const char kOff[] = "color: #666666;";
const char kMark[] = "color: #c46200; font-weight: 600;";
const char kError[] = "color: #b00020;";
const char kNote[] = "color: #6a4b00;";

class BreaksDialog : public QDialog {
public:
    QListWidget *list = nullptr;
    QLabel *empty = nullptr;
    bool filling = false;

    explicit BreaksDialog(QWidget *parent) : QDialog(parent) {
        setWindowTitle(QStringLiteral("Breakpoints"));
        setModal(false);
        resize(320, 280);
        list = new QListWidget(this);
        empty = new QLabel(QStringLiteral("None yet"), this);
        empty->setAlignment(Qt::AlignCenter);
        toggleButton = new QPushButton(QStringLiteral("Toggle caret"), this);
        armButton = new QPushButton(QStringLiteral("Arm"), this);

        auto *buttons = new QHBoxLayout;
        buttons->addWidget(toggleButton);
        buttons->addWidget(armButton);
        buttons->addStretch(1);

        auto *box = new QVBoxLayout(this);
        box->addWidget(list, 1);
        box->addWidget(empty);
        box->addLayout(buttons);
    }

    QPushButton *toggleButton = nullptr;
    QPushButton *armButton = nullptr;
};

} // namespace

DebugBar::DebugBar(QWidget *parent) : QWidget(parent) {
    m_engine = new QLabel(QStringLiteral("Engine down"), this);
    m_mark = new QLabel(QStringLiteral("debugging"), this);
    m_mark->setStyleSheet(QString::fromLatin1(kMark));
    m_word = new QLabel(this);
    m_hint = new QLabel(QStringLiteral("F6 over  |  F7 into  |  F8 out  |  F5 continue  |  Esc stop"), this);
    m_error = new QLabel(this);
    m_error->setWordWrap(true);
    m_error->setStyleSheet(QString::fromLatin1(kError));
    m_note = new QLabel(this);
    m_note->setWordWrap(true);
    m_note->setStyleSheet(QString::fromLatin1(kNote));

    m_pause = new QPushButton(QStringLiteral("Pause"), this);
    auto *breaks = new QPushButton(QStringLiteral("Breakpoints"), this);
    m_dock = new QPushButton(QStringLiteral("Undock"), this);
    connect(m_pause, &QPushButton::clicked, this, &DebugBar::pauseRequested);
    connect(breaks, &QPushButton::clicked, this, &DebugBar::showBreaks);
    connect(m_dock, &QPushButton::clicked, this, &DebugBar::dockToggleRequested);

    auto *strip = new QHBoxLayout;
    strip->setContentsMargins(8, 4, 8, 2);
    strip->addWidget(m_engine);
    strip->addWidget(m_mark);
    strip->addWidget(m_word);
    strip->addStretch(1);
    strip->addWidget(m_hint);
    strip->addWidget(m_pause);
    strip->addWidget(breaks);
    strip->addWidget(m_dock);

    m_arm = new QPushButton(QStringLiteral("Arm"), this);
    m_over = new QPushButton(QStringLiteral("Step Over"), this);
    m_into = new QPushButton(QStringLiteral("Step Into"), this);
    m_out = new QPushButton(QStringLiteral("Step Out"), this);
    m_go = new QPushButton(QStringLiteral("Continue"), this);
    m_stop = new QPushButton(QStringLiteral("Stop"), this);
    auto *toolBreaks = new QPushButton(QStringLiteral("Breakpoints"), this);
    auto *toolPause = new QPushButton(QStringLiteral("Pause"), this);
    connect(m_arm, &QPushButton::clicked, this, &DebugBar::armRequested);
    connect(m_over, &QPushButton::clicked, this, &DebugBar::stepOverRequested);
    connect(m_into, &QPushButton::clicked, this, &DebugBar::stepIntoRequested);
    connect(m_out, &QPushButton::clicked, this, &DebugBar::stepOutRequested);
    connect(m_go, &QPushButton::clicked, this, &DebugBar::continueRequested);
    connect(m_stop, &QPushButton::clicked, this, &DebugBar::stopRequested);
    connect(toolBreaks, &QPushButton::clicked, this, &DebugBar::showBreaks);
    connect(toolPause, &QPushButton::clicked, this, &DebugBar::pauseRequested);

    auto *help = new QLabel(
        QStringLiteral("Breakpoints  |  Arm  |  F6 over  |  F7 into  |  F8 out  |  F5 continue  |  Esc stop"),
        this);
    auto *tools = new QHBoxLayout;
    tools->setContentsMargins(8, 2, 8, 4);
    tools->addWidget(toolBreaks);
    tools->addWidget(m_arm);
    tools->addWidget(toolPause);
    tools->addWidget(m_over);
    tools->addWidget(m_into);
    tools->addWidget(m_out);
    tools->addWidget(m_go);
    tools->addWidget(m_stop);
    tools->addWidget(help, 1);

    m_tools = new QWidget(this);
    m_tools->setLayout(tools);
    m_tools->setStyleSheet(QStringLiteral("background: #d7ecd4;"));

    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(0, 0, 0, 0);
    box->setSpacing(0);
    box->addLayout(strip);
    box->addWidget(m_error);
    box->addWidget(m_note);
    box->addWidget(m_tools);
    setError(QString());
    setNote(QString());
    apply();
}

void DebugBar::setConnected(bool connected) {
    m_connected = connected;
    if (!connected) {
        m_armed = false;
        m_paused = false;
    }
    apply();
}

void DebugBar::setDebug(bool armed, bool paused, const QString &name) {
    m_armed = armed;
    m_paused = paused && armed;
    m_word->setText(m_paused ? name : QString());
    apply();
}

void DebugBar::setError(const QString &text) {
    m_error->setText(text);
    m_error->setVisible(!text.isEmpty());
}

void DebugBar::setNote(const QString &text) {
    m_note->setText(text);
    m_note->setVisible(!text.isEmpty());
}

void DebugBar::setConsolePlace(ConsolePlace place) {
    if (place == ConsolePlace::Floating)
        m_dock->setText(QStringLiteral("Dock"));
    else if (place == ConsolePlace::Hidden)
        m_dock->setText(QStringLiteral("Unhide Forth"));
    else
        m_dock->setText(QStringLiteral("Undock"));
}

void DebugBar::setBreaks(const QString &text) {
    m_breakText = text;
    auto *dialog = static_cast<BreaksDialog *>(m_breaks);
    if (dialog == nullptr)
        return;
    dialog->filling = true;
    dialog->list->clear();
    const QStringList rows = text.split(QLatin1Char('\n'), Qt::SkipEmptyParts);
    for (const QString &row : rows) {
        const QStringList cols = row.split(QLatin1Char('\t'));
        if (cols.size() < 3)
            continue;
        bool ok = false;
        const int index = cols.at(0).toInt(&ok);
        if (!ok)
            continue;
        auto *item = new QListWidgetItem(cols.at(1), dialog->list);
        item->setFlags(item->flags() | Qt::ItemIsUserCheckable);
        item->setCheckState(cols.at(2).trimmed() == QLatin1String("0") ? Qt::Unchecked : Qt::Checked);
        item->setData(Qt::UserRole, index);
    }
    const bool any = dialog->list->count() > 0;
    dialog->list->setVisible(any);
    dialog->empty->setVisible(!any);
    dialog->filling = false;
}

void DebugBar::showBreaks() {
    if (m_breaks == nullptr) {
        auto *dialog = new BreaksDialog(this);
        m_breaks = dialog;
        connect(dialog->toggleButton, &QPushButton::clicked, this, &DebugBar::toggleCaretRequested);
        connect(dialog->armButton, &QPushButton::clicked, this, &DebugBar::armRequested);
        connect(dialog->list, &QListWidget::itemChanged, this, [this](QListWidgetItem *item) {
            auto *dialog = static_cast<BreaksDialog *>(m_breaks);
            if (dialog == nullptr || dialog->filling || item == nullptr)
                return;
            emit breakEnableRequested(item->data(Qt::UserRole).toInt(),
                                      item->checkState() == Qt::Checked);
        });
    }
    setBreaks(m_breakText);
    m_breaks->show();
    m_breaks->raise();
    m_breaks->activateWindow();
    emit breakpointsRequested();
}

void DebugBar::apply() {
    m_engine->setText(m_connected ? QStringLiteral("Engine connected") : QStringLiteral("Engine down"));
    m_engine->setStyleSheet(QString::fromLatin1(m_connected ? kOn : kOff));
    m_mark->setVisible(m_armed);
    m_hint->setVisible(m_armed);
    m_tools->setVisible(m_armed);
    if (m_armed)
        m_tools->setStyleSheet(m_connected ? QStringLiteral("background: #d7ecd4;")
                                           : QStringLiteral("background: #ffe8cc;"));
    m_pause->setEnabled(m_connected);
    m_arm->setEnabled(m_connected && (!m_armed || m_paused));
    const bool step = m_connected && m_paused;
    m_over->setEnabled(step);
    m_into->setEnabled(step);
    m_out->setEnabled(step);
    m_go->setEnabled(step);
    m_stop->setEnabled(step);
    if (!m_connected)
        m_word->clear();
}
