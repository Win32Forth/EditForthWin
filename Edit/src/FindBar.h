#pragma once

#include <QWidget>

class QCheckBox;
class QLineEdit;
class QPlainTextEdit;

// Find and replace bar for the focused source editor.
class FindBar : public QWidget {
    Q_OBJECT
public:
    explicit FindBar(QWidget *parent = nullptr);

    void attach(QPlainTextEdit *edit);
    void showFind();
    void showReplace();
    void findNext();
    void findPrevious();
    void useSelection();
    void replaceOne();
    void replaceSelection();
    void replaceAll();

private:
    bool find(bool backward);
    void rememberEditor();

    QPlainTextEdit *m_edit = nullptr;
    QLineEdit *m_find = nullptr;
    QLineEdit *m_replace = nullptr;
    QCheckBox *m_case = nullptr;
    QCheckBox *m_word = nullptr;
    QWidget *m_replaceRow = nullptr;
};
