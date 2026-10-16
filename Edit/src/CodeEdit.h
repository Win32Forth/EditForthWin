#pragma once

#include <QPlainTextEdit>

class QPaintEvent;
class QResizeEvent;

// Forth source editor: monospace text plus a line-number gutter.
class CodeEdit : public QPlainTextEdit {
    Q_OBJECT
public:
    explicit CodeEdit(QWidget *parent = nullptr);

    void setLineNumbersVisible(bool visible);
    bool lineNumbersVisible() const { return m_numbers; }

    // line is 1-based, or 0 when the header has no stamp.
    // utf8Off and utf8Len are byte offsets in the file text.
    void showDebugHit(int line, int utf8Off, int utf8Len, const QString &name, bool useSpan);
    void clearDebugHit();

    void lineNumberPaint(QPaintEvent *event);
    int lineNumberWidth() const;

protected:
    void resizeEvent(QResizeEvent *event) override;

private:
    void updateGutterWidth();
    void updateGutter(const QRect &rect, int dy);

    class Gutter;
    Gutter *m_gutter = nullptr;
    bool m_numbers = true;
};
