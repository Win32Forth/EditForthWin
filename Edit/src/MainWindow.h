#pragma once

#include <QMainWindow>

class CodeEdit;
class QTabWidget;

// One workspace window: a tab per Forth source, line numbers, open and save.
class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = nullptr);

    void newFile();
    void openFile(const QString &path);
    int tabCount() const;

protected:
    void closeEvent(QCloseEvent *event) override;

private:
    CodeEdit *currentEdit() const;
    CodeEdit *editAt(int index) const;
    void addEditor(CodeEdit *edit, const QString &title);
    void wire(CodeEdit *edit);
    bool saveEdit(CodeEdit *edit);
    bool saveEditAs(CodeEdit *edit);
    bool maybeSave(CodeEdit *edit);
    void refreshTitle(CodeEdit *edit);
    void refreshStatus();
    void applyLineNumbers();
    void closeTab(int index);

    QTabWidget *m_tabs = nullptr;
    QAction *m_lineNumbersAction = nullptr;
    int m_untitled = 0;
};
