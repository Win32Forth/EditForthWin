#include "FindBar.h"

#include <QCheckBox>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QPlainTextEdit>
#include <QPushButton>
#include <QTextCursor>
#include <QTextDocument>
#include <QVBoxLayout>

FindBar::FindBar(QWidget *parent) : QWidget(parent) {
    m_find = new QLineEdit(this);
    m_find->setPlaceholderText(QStringLiteral("Find"));
    m_replace = new QLineEdit(this);
    m_replace->setPlaceholderText(QStringLiteral("Replace"));
    m_case = new QCheckBox(QStringLiteral("Case"), this);
    m_word = new QCheckBox(QStringLiteral("Word"), this);

    auto *findRow = new QHBoxLayout;
    findRow->setContentsMargins(6, 4, 6, 2);
    findRow->addWidget(new QLabel(QStringLiteral("Find"), this));
    findRow->addWidget(m_find, 1);
    auto *next = new QPushButton(QStringLiteral("Next"), this);
    auto *prev = new QPushButton(QStringLiteral("Previous"), this);
    findRow->addWidget(prev);
    findRow->addWidget(next);
    findRow->addWidget(m_case);
    findRow->addWidget(m_word);
    auto *close = new QPushButton(QStringLiteral("Close"), this);
    findRow->addWidget(close);

    m_replaceRow = new QWidget(this);
    auto *replaceRow = new QHBoxLayout(m_replaceRow);
    replaceRow->setContentsMargins(6, 2, 6, 4);
    replaceRow->addWidget(new QLabel(QStringLiteral("Replace"), m_replaceRow));
    replaceRow->addWidget(m_replace, 1);
    auto *one = new QPushButton(QStringLiteral("Replace"), m_replaceRow);
    auto *all = new QPushButton(QStringLiteral("Replace All"), m_replaceRow);
    replaceRow->addWidget(one);
    replaceRow->addWidget(all);

    auto *box = new QVBoxLayout(this);
    box->setContentsMargins(0, 0, 0, 0);
    box->setSpacing(0);
    box->addLayout(findRow);
    box->addWidget(m_replaceRow);
    setStyleSheet(QStringLiteral("background: #f4f1e8;"));

    connect(m_find, &QLineEdit::returnPressed, this, &FindBar::findNext);
    connect(next, &QPushButton::clicked, this, &FindBar::findNext);
    connect(prev, &QPushButton::clicked, this, &FindBar::findPrevious);
    connect(one, &QPushButton::clicked, this, &FindBar::replaceOne);
    connect(all, &QPushButton::clicked, this, &FindBar::replaceAll);
    connect(close, &QPushButton::clicked, this, &QWidget::hide);
}

void FindBar::attach(QPlainTextEdit *edit) { m_edit = edit; }

void FindBar::rememberEditor() {
    if (m_edit != nullptr)
        m_edit->setFocus();
}

void FindBar::showFind() {
    m_replaceRow->hide();
    show();
    m_find->setFocus();
    m_find->selectAll();
}

void FindBar::showReplace() {
    m_replaceRow->show();
    show();
    m_find->setFocus();
    m_find->selectAll();
}

void FindBar::useSelection() {
    if (m_edit == nullptr)
        return;
    const QString selected = m_edit->textCursor().selectedText();
    if (selected.isEmpty() || selected.contains(QChar(0x2029)))
        return;
    m_find->setText(selected);
    showFind();
}

bool FindBar::find(bool backward) {
    if (m_edit == nullptr)
        return false;
    const QString needle = m_find->text();
    if (needle.isEmpty())
        return false;
    QTextDocument::FindFlags flags;
    if (backward)
        flags |= QTextDocument::FindBackward;
    if (m_case->isChecked())
        flags |= QTextDocument::FindCaseSensitively;
    if (m_word->isChecked())
        flags |= QTextDocument::FindWholeWords;
    if (m_edit->find(needle, flags))
        return true;
    QTextCursor cursor = m_edit->textCursor();
    cursor.movePosition(backward ? QTextCursor::End : QTextCursor::Start);
    m_edit->setTextCursor(cursor);
    return m_edit->find(needle, flags);
}

void FindBar::findNext() { find(false); }

void FindBar::findPrevious() { find(true); }

void FindBar::replaceSelection() {
    if (m_edit == nullptr || m_edit->isReadOnly())
        return;
    QTextCursor cursor = m_edit->textCursor();
    if (!cursor.hasSelection())
        return;
    const QString selected = cursor.selectedText();
    const QString needle = m_find->text();
    const bool same = m_case->isChecked() ? selected == needle
                                           : selected.compare(needle, Qt::CaseInsensitive) == 0;
    if (same)
        cursor.insertText(m_replace->text());
}

void FindBar::replaceOne() {
    replaceSelection();
    findNext();
}

void FindBar::replaceAll() {
    if (m_edit == nullptr || m_edit->isReadOnly())
        return;
    const QString needle = m_find->text();
    if (needle.isEmpty())
        return;
    QTextDocument::FindFlags flags;
    if (m_case->isChecked())
        flags |= QTextDocument::FindCaseSensitively;
    if (m_word->isChecked())
        flags |= QTextDocument::FindWholeWords;
    QTextCursor cursor(m_edit->document());
    cursor.beginEditBlock();
    cursor.movePosition(QTextCursor::Start);
    m_edit->setTextCursor(cursor);
    int count = 0;
    while (m_edit->find(needle, flags)) {
        m_edit->textCursor().insertText(m_replace->text());
        ++count;
        if (count > 100000)
            break;
    }
    cursor.endEditBlock();
}
