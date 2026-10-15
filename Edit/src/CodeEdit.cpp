#include "CodeEdit.h"

#include <QFont>
#include <QFontMetrics>
#include <QPaintEvent>
#include <QPainter>
#include <QResizeEvent>
#include <QTextBlock>

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
