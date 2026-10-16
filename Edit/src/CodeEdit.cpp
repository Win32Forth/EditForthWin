#include "CodeEdit.h"

#include <QColor>
#include <QFont>
#include <QFontMetrics>
#include <QPaintEvent>
#include <QPainter>
#include <QResizeEvent>
#include <QTextBlock>
#include <QTextCursor>

class CodeEdit::Gutter : public QWidget {
public:
    explicit Gutter(CodeEdit *edit) : QWidget(edit), m_edit(edit) {}
    QSize sizeHint() const override { return QSize(m_edit->lineNumberWidth(), 0); }

protected:
    void paintEvent(QPaintEvent *event) override { m_edit->lineNumberPaint(event); }

private:
    CodeEdit *m_edit;
};

CodeEdit::CodeEdit(QWidget *parent) : QPlainTextEdit(parent), m_gutter(new Gutter(this)) {
    QFont font("Consolas", 13);
    font.setStyleHint(QFont::Monospace);
    font.setFixedPitch(true);
    setFont(font);
    setLineWrapMode(QPlainTextEdit::NoWrap);
    setTabStopDistance(QFontMetrics(font).horizontalAdvance(QLatin1Char(' ')) * 4);
    setFrameStyle(QFrame::NoFrame);

    connect(this, &CodeEdit::blockCountChanged, this, [this](int) { updateGutterWidth(); });
    connect(this, &CodeEdit::updateRequest, this, &CodeEdit::updateGutter);
    updateGutterWidth();
}

void CodeEdit::setLineNumbersVisible(bool visible) {
    m_numbers = visible;
    updateGutterWidth();
}

int CodeEdit::lineNumberWidth() const {
    if (!m_numbers)
        return 0;
    int digits = 1;
    int max = qMax(1, blockCount());
    while (max >= 10) {
        max /= 10;
        ++digits;
    }
    return 8 + fontMetrics().horizontalAdvance(QLatin1Char('9')) * digits;
}

void CodeEdit::updateGutterWidth() {
    setViewportMargins(lineNumberWidth(), 0, 0, 0);
}

void CodeEdit::updateGutter(const QRect &rect, int dy) {
    if (dy)
        m_gutter->scroll(0, dy);
    else
        m_gutter->update(0, rect.y(), m_gutter->width(), rect.height());
    if (rect.contains(viewport()->rect()))
        updateGutterWidth();
}

void CodeEdit::resizeEvent(QResizeEvent *event) {
    QPlainTextEdit::resizeEvent(event);
    const QRect cr = contentsRect();
    m_gutter->setGeometry(QRect(cr.left(), cr.top(), lineNumberWidth(), cr.height()));
}

namespace {

bool selectToken(QTextDocument *document, int line, const QString &name, QTextCursor *hit) {
    if (name.isEmpty() || document == nullptr)
        return false;
    QTextBlock block = line > 0 ? document->findBlockByNumber(line - 1) : document->firstBlock();
    if (line > 0 && !block.isValid())
        return false;
    while (block.isValid()) {
        const QString text = block.text();
        int at = 0;
        while (at < text.size()) {
            while (at < text.size() && text.at(at).isSpace())
                ++at;
            int end = at;
            while (end < text.size() && !text.at(end).isSpace())
                ++end;
            if (end > at && text.mid(at, end - at).compare(name, Qt::CaseInsensitive) == 0) {
                hit->setPosition(block.position() + at);
                hit->setPosition(block.position() + end, QTextCursor::KeepAnchor);
                return true;
            }
            at = end;
        }
        if (line > 0)
            break;
        block = block.next();
    }
    return false;
}

} // namespace

void CodeEdit::showDebugHit(int line, int utf8Off, int utf8Len, const QString &name, bool useSpan) {
    QTextCursor hit(document());
    bool found = false;
    if (useSpan && utf8Off >= 0 && utf8Len > 0) {
        const QByteArray utf8 = toPlainText().toUtf8();
        if (utf8Off <= utf8.size() && utf8Len <= utf8.size() - utf8Off) {
            const int start = QString::fromUtf8(utf8.left(utf8Off)).size();
            const int chars = QString::fromUtf8(utf8.mid(utf8Off, utf8Len)).size();
            if (start >= 0 && start + chars <= toPlainText().size()) {
                hit.setPosition(start);
                if (line <= 0 || hit.blockNumber() + 1 == line) {
                    hit.setPosition(start + chars, QTextCursor::KeepAnchor);
                    found = true;
                }
            }
        }
    }
    if (!found)
        found = selectToken(document(), line, name, &hit);
    if (!found) {
        clearDebugHit();
        return;
    }
    QTextEdit::ExtraSelection selection;
    selection.cursor = hit;
    selection.format.setBackground(QColor(255, 214, 102));
    setExtraSelections({selection});
    QTextCursor place = hit;
    place.setPosition(hit.selectionStart());
    setTextCursor(place);
    ensureCursorVisible();
}

void CodeEdit::clearDebugHit() { setExtraSelections({}); }

void CodeEdit::lineNumberPaint(QPaintEvent *event) {
    QPainter painter(m_gutter);
    painter.fillRect(event->rect(), palette().color(QPalette::Window));
    if (!m_numbers)
        return;

    QTextBlock block = firstVisibleBlock();
    int number = block.blockNumber();
    int top = qRound(blockBoundingGeometry(block).translated(contentOffset()).top());
    int bottom = top + qRound(blockBoundingRect(block).height());

    painter.setPen(palette().color(QPalette::PlaceholderText));
    while (block.isValid() && top <= event->rect().bottom()) {
        if (block.isVisible() && bottom >= event->rect().top()) {
            painter.drawText(0, top, m_gutter->width() - 6, fontMetrics().height(),
                             Qt::AlignRight, QString::number(number + 1));
        }
        block = block.next();
        top = bottom;
        bottom = top + qRound(blockBoundingRect(block).height());
        ++number;
    }
}
