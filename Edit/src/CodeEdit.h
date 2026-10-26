#pragma once

#include <QPlainTextEdit>
#include <QWidget>

class QLabel;
class QPaintEvent;
class QResizeEvent;
class QShowEvent;

// Forth source editor: monospace text plus a line-number gutter.
class CodeEdit : public QPlainTextEdit {
    Q_OBJECT
public:
    explicit CodeEdit(QWidget *parent = nullptr);

    void setLineNumbersVisible(bool visible);
    bool lineNumbersVisible() const { return m_numbers; }

    void setPointSize(int points);
    void setBrowse(bool browse);
    bool browse() const { return m_browse; }
    // While set, a debug session keeps the keyboard in the console.
    // A double-click still selects the Forth word under the pointer.
    void setDebugFocusLock(bool lock);
    void setWrap(const QString &mode, int column);
    void gotoLine(int line, int column = 1);
    void toggleLineComment();
    QString wordAtCursor() const;
    int utf8OffsetOfWord() const;
    void relayoutChrome();

    // line is 1-based, or 0 when the header has no stamp.
    // utf8Off and utf8Len are byte offsets in the file text.
    void showDebugHit(int line, int utf8Off, int utf8Len, const QString &name, bool useSpan);
    void clearDebugHit();

    void lineNumberPaint(QPaintEvent *event);
    int lineNumberWidth() const;

signals:
    void browseChanged(bool browse);
    void viewWordRequested(const QString &word);
    void breakWordRequested(const QString &word);
    void runToRequested(int utf8Offset);

protected:
    void resizeEvent(QResizeEvent *event) override;
    void showEvent(QShowEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseDoubleClickEvent(QMouseEvent *event) override;
    void contextMenuEvent(QContextMenuEvent *event) override;

private:
    void updateGutterWidth();
    void updateGutter(const QRect &rect, int dy);
    void applyWrap();
    void revealPosition(int position);
    void scrollToPosition(int position);
    void applyDebugWash();
    QString tokenAt(int position, int *startOut) const;

    class Gutter;
    Gutter *m_gutter = nullptr;
    bool m_numbers = true;
    bool m_browse = false;
    bool m_debugFocusLock = false;
    QString m_wrapMode = QStringLiteral("off");
    int m_wrapColumn = 80;
    int m_revealGen = 0;
    int m_revealPos = -1;
    int m_hitStart = -1;
    int m_hitChars = 0;
};

// One file pane: the view-mode banner, then that file's editor.
// The banner stays inside this pane so each tab and the split each have their own.
class EditorPane : public QWidget {
    Q_OBJECT
public:
    explicit EditorPane(CodeEdit *edit, QWidget *parent = nullptr);

    CodeEdit *edit() const { return m_edit; }
    void setDebugState(bool armed, bool paused);

private:
    void syncBanner();

    CodeEdit *m_edit = nullptr;
    QWidget *m_banner = nullptr;
    QLabel *m_hint = nullptr;
    bool m_armed = false;
    bool m_paused = false;
};
