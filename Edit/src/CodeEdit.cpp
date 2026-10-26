#include "CodeEdit.h"

#include <QColor>
#include <QContextMenuEvent>
#include <QFont>
#include <QFontMetrics>
#include <QHBoxLayout>
#include <QLabel>
#include <QList>
#include <QMenu>
#include <QMouseEvent>
#include <QPaintEvent>
#include <QPainter>
#include <QPushButton>
#include <QResizeEvent>
#include <QScrollBar>
#include <QShowEvent>
#include <QSizePolicy>
#include <QStringList>
#include <QTimer>
#include <QTextBlock>
#include <QTextCursor>
#include <QVBoxLayout>

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
    applyWrap();
}

void CodeEdit::setPointSize(int points) {
    QFont next = font();
    next.setPointSize(qBound(9, points, 32));
    setFont(next);
    setTabStopDistance(fontMetrics().horizontalAdvance(QLatin1Char(' ')) * 4);
    applyWrap();
}

void CodeEdit::setBrowse(bool browse) {
    m_browse = browse;
    setReadOnly(browse);
    emit browseChanged(browse);
}

void CodeEdit::setDebugFocusLock(bool lock) {
    m_debugFocusLock = lock;
    setFocusPolicy(lock ? Qt::NoFocus : Qt::StrongFocus);
    if (!lock)
        return;
    QPalette pal = palette();
    pal.setColor(QPalette::Inactive, QPalette::Highlight, pal.color(QPalette::Active, QPalette::Highlight));
    pal.setColor(QPalette::Inactive, QPalette::HighlightedText,
                 pal.color(QPalette::Active, QPalette::HighlightedText));
    setPalette(pal);
}

void CodeEdit::revealPosition(int position) {
    if (toPlainText().isEmpty())
        return;
    const int at = qBound(0, position, qMax(0, toPlainText().size() - 1));
    m_revealPos = at;
    const int gen = ++m_revealGen;
    scrollToPosition(at);
    const auto again = [this, gen, at] {
        if (gen != m_revealGen || m_revealPos != at)
            return;
        scrollToPosition(at);
    };
    // A new tab has no layout yet. VIEW's gotoLine survives that; these
    // retries cover the same window Mac uses after the text view appears.
    QTimer::singleShot(0, this, again);
    QTimer::singleShot(50, this, again);
    QTimer::singleShot(200, this, again);
}

void CodeEdit::scrollToPosition(int position) {
    if (document() == nullptr || document()->isEmpty())
        return;
    const int at = qBound(0, position, qMax(0, document()->characterCount() - 1));
    const QTextCursor saved = textCursor();
    // Same scroll as VIEW / gotoLine: set the caret and center it. That lays
    // out a line the block geometry does not know yet. Then put the caret
    // back and keep the scroll, so a debug step does not leave it in the file.
    QTextCursor mark(document());
    mark.setPosition(at);
    setTextCursor(mark);
    centerCursor();
    const int y = verticalScrollBar()->value();
    const int x = horizontalScrollBar()->value();
    setTextCursor(saved);
    verticalScrollBar()->setValue(y);
    horizontalScrollBar()->setValue(x);
    applyDebugWash();
}

void CodeEdit::applyDebugWash() {
    if (m_hitStart < 0 || m_hitChars <= 0) {
        setExtraSelections({});
        return;
    }
    const int chars = qMin(m_hitChars, document()->characterCount() - m_hitStart);
    if (chars <= 0) {
        setExtraSelections({});
        return;
    }
    QTextCursor mark(document());
    mark.setPosition(m_hitStart);
    mark.setPosition(m_hitStart + chars, QTextCursor::KeepAnchor);
    QTextEdit::ExtraSelection selection;
    selection.cursor = mark;
    selection.format.setBackground(QColor(176, 230, 176));
    setExtraSelections({selection});
}

void CodeEdit::showEvent(QShowEvent *event) {
    QPlainTextEdit::showEvent(event);
    if (m_revealPos >= 0)
        scrollToPosition(m_revealPos);
}

void CodeEdit::setWrap(const QString &mode, int column) {
    m_wrapMode = mode;
    m_wrapColumn = column;
    applyWrap();
}

void CodeEdit::applyWrap() {
    if (m_wrapMode == QLatin1String("off")) {
        setLineWrapMode(QPlainTextEdit::NoWrap);
        setMaximumWidth(QWIDGETSIZE_MAX);
        return;
    }
    setLineWrapMode(QPlainTextEdit::WidgetWidth);
    if (m_wrapMode == QLatin1String("column")) {
        const int cols = qBound(40, m_wrapColumn, 300);
        const int width = fontMetrics().horizontalAdvance(QLatin1Char('M')) * cols + lineNumberWidth() + 24;
        setMaximumWidth(width);
    } else {
        setMaximumWidth(QWIDGETSIZE_MAX);
    }
}

void CodeEdit::relayoutChrome() {
    updateGutterWidth();
    applyWrap();
}

QString CodeEdit::tokenAt(int position, int *startOut) const {
    const QString text = toPlainText();
    if (position < 0 || position > text.size())
        return {};
    if (position == text.size()) {
        if (position == 0 || text.at(position - 1).isSpace())
            return {};
        --position;
    } else if (text.at(position).isSpace()) {
        return {};
    }
    int start = position;
    int end = position + 1;
    while (start > 0 && !text.at(start - 1).isSpace())
        --start;
    while (end < text.size() && !text.at(end).isSpace())
        ++end;
    if (startOut != nullptr)
        *startOut = start;
    return text.mid(start, end - start);
}

QString CodeEdit::wordAtCursor() const {
    return tokenAt(textCursor().position(), nullptr);
}

int CodeEdit::utf8OffsetOfWord() const {
    int start = 0;
    if (tokenAt(textCursor().position(), &start).isEmpty())
        start = textCursor().position();
    return toPlainText().left(start).toUtf8().size();
}

void CodeEdit::gotoLine(int line, int column) {
    if (line < 1)
        line = 1;
    QTextBlock block = document()->findBlockByNumber(line - 1);
    if (!block.isValid())
        block = document()->lastBlock();
    QTextCursor cursor(block);
    const int col = qBound(0, column - 1, block.length());
    cursor.movePosition(QTextCursor::Right, QTextCursor::MoveAnchor, col);
    setTextCursor(cursor);
    centerCursor();
    setFocus();
}

namespace {

// Paragraph that contains `index`, including its line break. A caret on the
// break stays with the line that break ends.
struct LineSpan {
    int loc = 0;
    int len = 0;
};

int breakLengthAt(const QString &text, int index) {
    if (index < 0 || index >= text.size())
        return 0;
    const QChar ch = text.at(index);
    if (ch == QLatin1Char('\r'))
        return (index + 1 < text.size() && text.at(index + 1) == QLatin1Char('\n')) ? 2 : 1;
    if (ch == QLatin1Char('\n'))
        return 1;
    return 0;
}

int lineStartAt(const QString &text, int index) {
    int i = qBound(0, index, qMax(0, text.size() - 1));
    while (i > 0) {
        const QChar prev = text.at(i - 1);
        if (prev == QLatin1Char('\n'))
            return i;
        if (prev == QLatin1Char('\r')) {
            // The caret is on the LF of a CRLF. That break still belongs to this line.
            if (text.at(i) == QLatin1Char('\n')) {
                --i;
                continue;
            }
            return i;
        }
        --i;
    }
    return 0;
}

LineSpan paragraphAt(const QString &text, int index) {
    const int n = text.size();
    if (n == 0)
        return {};
    const int i = qBound(0, index, n - 1);
    const int start = lineStartAt(text, i);
    int end = start;
    while (end < n) {
        const int br = breakLengthAt(text, end);
        if (br != 0) {
            end += br;
            break;
        }
        ++end;
    }
    return {start, end - start};
}

} // namespace

void CodeEdit::toggleLineComment() {
    if (isReadOnly())
        return;
    const QString prefix = QStringLiteral("\\ ");
    const QString text = toPlainText();
    const int n = text.size();
    const QTextCursor current = textCursor();
    int loc = qBound(0, current.selectionStart(), n);
    int len = qBound(0, current.selectionEnd() - loc, n - loc);

    int blockLoc = 0;
    int blockLen = 0;
    if (n == 0) {
        blockLoc = 0;
        blockLen = 0;
    } else if (len == 0) {
        if (loc == n && loc > 0 && breakLengthAt(text, loc - 1) != 0) {
            blockLoc = loc;
            blockLen = 0;
        } else {
            const LineSpan span = paragraphAt(text, loc == n ? n - 1 : loc);
            blockLoc = span.loc;
            blockLen = span.len;
        }
    } else {
        const LineSpan start = paragraphAt(text, qMin(loc, n - 1));
        const LineSpan end = paragraphAt(text, loc + len - 1);
        blockLoc = start.loc;
        blockLen = end.loc + end.len - start.loc;
    }

    const QString chunk = text.mid(blockLoc, blockLen);
    QString newline = QStringLiteral("\n");
    if (chunk.contains(QStringLiteral("\r\n")))
        newline = QStringLiteral("\r\n");
    else if (chunk.contains(QLatin1Char('\r')))
        newline = QStringLiteral("\r");
    QStringList lines = chunk.isEmpty() ? QStringList{QString()} : chunk.split(newline);
    bool trailing = false;
    if (!chunk.isEmpty() && !lines.isEmpty() && lines.last().isEmpty()) {
        lines.removeLast();
        trailing = true;
    }
    if (lines.isEmpty())
        lines << QString();

    bool uncomment = false;
    int nonempty = 0;
    for (const QString &line : lines) {
        if (line.isEmpty())
            continue;
        ++nonempty;
        if (!line.startsWith(prefix)) {
            uncomment = false;
            nonempty = -1;
            break;
        }
    }
    if (nonempty > 0)
        uncomment = true;

    for (QString &line : lines) {
        if (uncomment) {
            if (line.startsWith(prefix))
                line.remove(0, prefix.size());
        } else {
            line.prepend(prefix);
        }
    }
    QString replacement = lines.join(newline);
    if (trailing)
        replacement += newline;

    QTextCursor edit(document());
    edit.beginEditBlock();
    edit.setPosition(blockLoc);
    edit.setPosition(blockLoc + blockLen, QTextCursor::KeepAnchor);
    edit.insertText(replacement);
    edit.endEditBlock();
    edit.setPosition(blockLoc);
    edit.setPosition(blockLoc + replacement.size(), QTextCursor::KeepAnchor);
    setTextCursor(edit);
}

void CodeEdit::mousePressEvent(QMouseEvent *event) {
    if (event->button() == Qt::LeftButton && (event->modifiers() & Qt::ControlModifier)) {
        const QTextCursor cursor = cursorForPosition(event->position().toPoint());
        setTextCursor(cursor);
        const QString word = wordAtCursor();
        if (!word.isEmpty())
            emit viewWordRequested(word);
        event->accept();
        return;
    }
    // Debug browse keeps the caret out of this pane. A key must not land here.
    if (m_debugFocusLock && event->button() == Qt::LeftButton) {
        event->accept();
        return;
    }
    QPlainTextEdit::mousePressEvent(event);
}

void CodeEdit::mouseDoubleClickEvent(QMouseEvent *event) {
    if (m_debugFocusLock && event->button() == Qt::LeftButton &&
        !(event->modifiers() & Qt::ControlModifier)) {
        const QTextCursor at = cursorForPosition(event->position().toPoint());
        int start = 0;
        const QString word = tokenAt(at.position(), &start);
        if (!word.isEmpty()) {
            QTextCursor mark(document());
            mark.setPosition(start);
            mark.setPosition(start + word.size(), QTextCursor::KeepAnchor);
            setTextCursor(mark);
            revealPosition(start);
        }
        event->accept();
        return;
    }
    QPlainTextEdit::mouseDoubleClickEvent(event);
}

void CodeEdit::contextMenuEvent(QContextMenuEvent *event) {
    const QPoint viewportPos = viewport()->mapFrom(this, event->pos());
    setTextCursor(cursorForPosition(viewportPos));
    QMenu menu(this);
    QAction *view = menu.addAction(QStringLiteral("View Word"));
    QAction *breaks = menu.addAction(QStringLiteral("Toggle Breakpoint"));
    QAction *runto = menu.addAction(QStringLiteral("Run to Here"));
    menu.addSeparator();
    QAction *standard = menu.addAction(QStringLiteral("Standard Edit Menu"));
    QAction *chosen = menu.exec(event->globalPos());
    if (chosen == view || chosen == breaks) {
        const QString word = wordAtCursor();
        if (word.isEmpty())
            return;
        if (chosen == view)
            emit viewWordRequested(word);
        else
            emit breakWordRequested(word);
    } else if (chosen == runto) {
        emit runToRequested(utf8OffsetOfWord());
    } else if (chosen == standard) {
        QPlainTextEdit::contextMenuEvent(event);
    }
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

struct Needle {
    QString text;
    bool literal;
};

bool forthSpace(QChar ch) { return ch.isSpace(); }

bool boundaryBefore(const QString &text, int index) {
    return index <= 0 || forthSpace(text.at(index - 1));
}

bool boundaryAfter(const QString &text, int end) {
    return end >= text.size() || forthSpace(text.at(end));
}

void addNeedle(QList<Needle> *out, const char *text, bool literal) {
    out->append(Needle{QString::fromLatin1(text), literal});
}

// Same remap as Mac PendingGoto.highlightNeedles. First hit in the definition wins.
QList<Needle> highlightNeedles(const QString &name) {
    QList<Needle> out;
    const QString upper = name.toUpper();
    if (upper == QLatin1String("EXIT")) {
        addNeedle(&out, ";", true);
        addNeedle(&out, "EXIT", false);
    } else if (upper == QLatin1String("(S\")")) {
        addNeedle(&out, "S\"", true);
        addNeedle(&out, ".\"", true);
    } else if (upper == QLatin1String("(C\")")) {
        addNeedle(&out, "C\"", true);
    } else if (upper == QLatin1String("0BRANCH")) {
        addNeedle(&out, "IF", false);
        addNeedle(&out, "WHILE", false);
        addNeedle(&out, "UNTIL", false);
    } else if (upper == QLatin1String("BRANCH")) {
        addNeedle(&out, "ELSE", false);
        addNeedle(&out, "AGAIN", false);
        addNeedle(&out, "REPEAT", false);
    } else if (upper == QLatin1String("(DO)")) {
        addNeedle(&out, "DO", false);
    } else if (upper == QLatin1String("(?DO)")) {
        addNeedle(&out, "?DO", true);
    } else if (upper == QLatin1String("(LOOP)")) {
        addNeedle(&out, "LOOP", false);
    } else if (upper == QLatin1String("(+LOOP)")) {
        addNeedle(&out, "+LOOP", true);
    } else if (upper == QLatin1String("LIT")) {
        addNeedle(&out, "[']", true);
        addNeedle(&out, "[CHAR]", false);
        addNeedle(&out, "LIT", false);
    } else {
        out.append(Needle{name, false});
    }
    return out;
}

int firstWholeWord(const QString &text, const QString &needle, bool literal, int from, int to) {
    if (needle.isEmpty() || from >= to)
        return -1;
    const auto sense = literal ? Qt::CaseSensitive : Qt::CaseInsensitive;
    int search = from;
    while (search < to) {
        const int found = text.indexOf(needle, search, sense);
        if (found < 0 || found >= to)
            return -1;
        const int end = found + needle.size();
        if (end <= to && boundaryBefore(text, found) && boundaryAfter(text, end))
            return found;
        search = found + qMax(1, needle.size());
    }
    return -1;
}

int lineStartIndex(const QString &text, int line) {
    if (line < 1)
        line = 1;
    int current = 1;
    int idx = 0;
    while (current < line && idx < text.size()) {
        const int nl = text.indexOf(QLatin1Char('\n'), idx);
        if (nl < 0)
            return text.size();
        idx = nl + 1;
        ++current;
    }
    return idx;
}

// Next line whose first non-blank character is ':' followed by whitespace.
int nextDefinitionStart(const QString &text, int from) {
    int idx = from;
    while (idx < text.size()) {
        const QChar ch = text.at(idx);
        ++idx;
        if (ch == QLatin1Char('\n') || ch == QLatin1Char('\r'))
            break;
    }
    while (idx < text.size()) {
        const int lineStart = idx;
        int j = idx;
        while (j < text.size() && (text.at(j) == QLatin1Char(' ') || text.at(j) == QLatin1Char('\t')))
            ++j;
        if (j < text.size() && text.at(j) == QLatin1Char(':')) {
            const int after = j + 1;
            if (after >= text.size() || forthSpace(text.at(after)))
                return lineStart;
        }
        while (idx < text.size()) {
            const QChar ch = text.at(idx);
            ++idx;
            if (ch == QLatin1Char('\n') || ch == QLatin1Char('\r'))
                break;
        }
    }
    return -1;
}

bool definitionWindow(const QString &text, int nearLine, int *fromOut, int *toOut) {
    const int from = lineStartIndex(text, qMax(nearLine, 1));
    if (from >= text.size())
        return false;
    int to = text.size();
    const int semi = firstWholeWord(text, QStringLiteral(";"), true, from, text.size());
    if (semi >= 0) {
        to = semi + 1;
    } else {
        const int nextDef = nextDefinitionStart(text, from);
        if (nextDef >= 0)
            to = nextDef;
    }
    if (to <= from)
        return false;
    *fromOut = from;
    *toOut = to;
    return true;
}

bool findInDefinition(const QString &text, const QString &name, int nearLine, int *startOut, int *lenOut) {
    const QString needle = name.trimmed();
    if (needle.isEmpty())
        return false;
    int from = 0;
    int to = 0;
    if (!definitionWindow(text, nearLine, &from, &to))
        return false;
    const QList<Needle> needles = highlightNeedles(needle);
    for (const Needle &cand : needles) {
        const int at = firstWholeWord(text, cand.text, cand.literal, from, to);
        if (at >= 0) {
            *startOut = at;
            *lenOut = cand.text.size();
            return true;
        }
    }
    return false;
}

bool spanMatches(const QString &slice, const QString &name) {
    const QString trimmed = slice.trimmed();
    if (trimmed.isEmpty() || name.trimmed().isEmpty())
        return false;
    const QList<Needle> needles = highlightNeedles(name.trimmed());
    for (const Needle &cand : needles) {
        if (cand.literal) {
            if (trimmed == cand.text)
                return true;
        } else if (trimmed.compare(cand.text, Qt::CaseInsensitive) == 0) {
            return true;
        }
    }
    return false;
}

} // namespace

void CodeEdit::showDebugHit(int line, int utf8Off, int utf8Len, const QString &name, bool useSpan) {
    const QString text = toPlainText();
    int spanAt = -1;
    int spanChars = 0;
    if (useSpan && utf8Off >= 0 && utf8Len > 0) {
        const QByteArray utf8 = text.toUtf8();
        if (utf8Off <= utf8.size() && utf8Len <= utf8.size() - utf8Off) {
            const int at = QString::fromUtf8(utf8.left(utf8Off)).size();
            const int chars = QString::fromUtf8(utf8.mid(utf8Off, utf8Len)).size();
            if (at >= 0 && chars > 0 && at + chars <= text.size() &&
                !text.mid(at, chars).trimmed().isEmpty()) {
                spanAt = at;
                spanChars = chars;
            }
        }
    }
    const bool spanOk = spanAt >= 0 && spanMatches(text.mid(spanAt, spanChars), name);
    int wordAt = 0;
    int wordChars = 0;
    const bool wordOk = findInDefinition(text, name, line, &wordAt, &wordChars);

    int start = -1;
    int chars = 0;
    if (spanOk) {
        start = spanAt;
        chars = spanChars;
    } else if (wordOk) {
        start = wordAt;
        chars = wordChars;
    } else if (spanAt >= 0) {
        start = spanAt;
        chars = spanChars;
    }
    if (start < 0) {
        m_hitStart = -1;
        m_hitChars = 0;
        setExtraSelections({});
        revealPosition(lineStartIndex(text, qMax(line, 1)));
        return;
    }

    // Scroll the word into view without leaving the caret here. The keyboard
    // stays in the Forth console; a click must not leave the insertion point here.
    m_hitStart = start;
    m_hitChars = chars;
    revealPosition(start);
    viewport()->update();
}

void CodeEdit::clearDebugHit() {
    m_hitStart = -1;
    m_hitChars = 0;
    m_revealPos = -1;
    ++m_revealGen;
    setExtraSelections({});
}

EditorPane::EditorPane(CodeEdit *edit, QWidget *parent) : QWidget(parent), m_edit(edit) {
    auto *layout = new QVBoxLayout(this);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->setSpacing(0);

    m_banner = new QWidget(this);
    m_banner->setAutoFillBackground(true);
    QPalette bannerPal = m_banner->palette();
    bannerPal.setColor(QPalette::Window, QColor(255, 244, 176));
    m_banner->setPalette(bannerPal);
    m_banner->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Fixed);

    auto *title = new QLabel(QStringLiteral("View mode"), m_banner);
    QFont titleFont = title->font();
    titleFont.setPointSize(11);
    titleFont.setBold(true);
    title->setFont(titleFont);

    m_hint = new QLabel(m_banner);
    QFont hintFont = m_hint->font();
    hintFont.setPointSize(11);
    hintFont.setBold(false);
    m_hint->setFont(hintFont);
    QPalette hintPal = m_hint->palette();
    hintPal.setColor(QPalette::WindowText, QColor(90, 90, 90));
    m_hint->setPalette(hintPal);

    auto *editButton = new QPushButton(QStringLiteral("Edit"), m_banner);
    QFont buttonFont = editButton->font();
    buttonFont.setPointSize(11);
    editButton->setFont(buttonFont);
    connect(editButton, &QPushButton::clicked, m_edit, [this] { m_edit->setBrowse(false); });

    auto *row = new QHBoxLayout(m_banner);
    row->setContentsMargins(10, 5, 10, 5);
    row->setSpacing(8);
    row->addWidget(title);
    row->addWidget(m_hint, 1);
    row->addWidget(editButton);

    layout->addWidget(m_banner);
    layout->addWidget(m_edit, 1);
    connect(m_edit, &CodeEdit::browseChanged, this, [this](bool) { syncBanner(); });
    syncBanner();
}

void EditorPane::setDebugState(bool armed, bool paused) {
    if (m_armed == armed && m_paused == paused)
        return;
    m_armed = armed;
    m_paused = paused;
    syncBanner();
}

void EditorPane::syncBanner() {
    const bool on = m_edit != nullptr && m_edit->browse();
    m_banner->setVisible(on);
    if (!on)
        return;
    if (m_armed && m_paused) {
        m_hint->setText(QStringLiteral(
            "Read-only \u2014 F5\u2013F8 / i o Space g q drive the stepper"));
    } else if (m_armed) {
        m_hint->setText(QStringLiteral("Running \u2014 Space and Return go to the program"));
    } else {
        m_hint->setText(QStringLiteral("Read-only \u2014 typing asks to switch to Edit"));
    }
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
