#include "ForthStackEffect.h"

#include <QHash>
#include <QPair>
#include <QRegularExpression>
#include <QSet>
#include <QVector>

#include <limits>

namespace ForthStackEffect {
namespace {

struct Sym {
    QString name;
    bool wide = false;
    bool operator==(const Sym &o) const { return name == o.name && wide == o.wide; }
};

struct Pattern {
    QVector<Sym> inputs;
    QVector<Sym> outputs;
    bool operator==(const Pattern &o) const { return inputs == o.inputs && outputs == o.outputs; }
};

struct Cell {
    int id = 0;
    QString role;
    bool hasLiteral = false;
    qint64 literal = 0;
    bool hasPair = false;
    int pair = 0;
};

enum class TokenKind { Word, StackComment };

struct Token {
    QString text;
    int line = 1;
    TokenKind kind = TokenKind::Word;
};

struct UserWord {
    bool hasPattern = false;
    Pattern pattern;
    bool immediate = false;
};

enum class Verdict { Copy, Mismatch, NotInferred, Ambiguous };

struct DefResult {
    QString name;
    QString traced;
    QString declared;
    bool hasDeclared = false;
    Verdict verdict = Verdict::NotInferred;
    QString detail;
    QString lineText() const;
};

enum class FrameKind { IfThen, ElseBranch, Begin, WhileBody, DoLoop, CaseHead, OfBody };

struct Frame {
    FrameKind kind = FrameKind::Begin;
    QVector<Cell> dataA;
    QVector<Cell> dataB;
    QVector<Cell> retA;
    QVector<Cell> retB;
    int retCount = 0;
    QVector<QVector<Cell>> exits;
    bool live = true;
    int line = 1;
    void insertDataBottom(const Cell &cell);
};

struct ParsedNumber {
    bool ok = false;
    bool isDouble = false;
    bool hasLiteral = false;
    qint64 literal = 0;
};

QString DefResult::lineText() const {
    switch (verdict) {
    case Verdict::Copy:
        return detail.isEmpty() ? QStringLiteral(": %1 %2 — copy").arg(name, traced)
                                : QStringLiteral(": %1 %2 — copy; %3").arg(name, traced, detail);
    case Verdict::Mismatch:
        return QStringLiteral(": %1 %2 — copy; declared %3 does not match")
            .arg(name, traced, hasDeclared ? declared : QStringLiteral("( ? )"));
    case Verdict::Ambiguous:
        return QStringLiteral(": %1 %2 — not a single effect: %3").arg(name, traced, detail);
    case Verdict::NotInferred:
        if (traced.isEmpty())
            return QStringLiteral(": %1 — not inferred: %2").arg(name, detail);
        return QStringLiteral(": %1 traced %2 — not inferred: %3").arg(name, traced, detail);
    }
    return QString();
}

void Frame::insertDataBottom(const Cell &cell) {
    switch (kind) {
    case FrameKind::IfThen:
    case FrameKind::ElseBranch:
    case FrameKind::Begin:
        dataA.prepend(cell);
        break;
    case FrameKind::WhileBody:
        dataA.prepend(cell);
        dataB.prepend(cell);
        break;
    case FrameKind::DoLoop:
    case FrameKind::CaseHead:
    case FrameKind::OfBody:
        dataA.prepend(cell);
        for (QVector<Cell> &stack : exits)
            stack.prepend(cell);
        break;
    }
}

bool isWideName(QString raw) {
    raw = raw.toLower();
    if (raw.startsWith(QLatin1Char('+')))
        raw = raw.mid(1);
    auto allDigits = [](const QString &s) {
        for (const QChar c : s) {
            if (!c.isDigit())
                return false;
        }
        return true;
    };
    if (raw.startsWith(QLatin1String("ud")))
        return allDigits(raw.mid(2));
    if (raw.startsWith(QLatin1Char('d')))
        return allDigits(raw.mid(1));
    return false;
}

QVector<Sym> symsIn(const QString &text) {
    QVector<Sym> out;
    const QStringList parts = text.split(QRegularExpression(QStringLiteral("[ \\t\\n\\r]+")), Qt::SkipEmptyParts);
    for (const QString &part : parts) {
        if (part == QLatin1String("|") || part == QLatin1String("\\"))
            continue;
        out.append(Sym{part, isWideName(part)});
    }
    return out;
}

Pattern parsePattern(QString comment, bool *ok) {
    comment = comment.trimmed();
    if (comment.startsWith(QLatin1Char('(')))
        comment = comment.mid(1);
    if (comment.endsWith(QLatin1Char(')')))
        comment.chop(1);
    const QStringList parts = comment.split(QStringLiteral("--"));
    if (parts.size() < 2) {
        if (ok != nullptr)
            *ok = false;
        return {};
    }
    QString outs;
    for (int i = 1; i < parts.size(); ++i) {
        if (i > 1)
            outs += QStringLiteral("--");
        outs += parts.at(i);
    }
    if (ok != nullptr)
        *ok = true;
    return Pattern{symsIn(parts.at(0)), symsIn(outs)};
}

const QString kPatternLines = QStringLiteral(
    "DUP ( x -- x x )\n"
    "DROP ( x -- )\n"
    "SWAP ( x1 x2 -- x2 x1 )\n"
    "OVER ( x1 x2 -- x1 x2 x1 )\n"
    "ROT ( x1 x2 x3 -- x2 x3 x1 )\n"
    "-ROT ( x1 x2 x3 -- x3 x1 x2 )\n"
    "NIP ( x1 x2 -- x2 )\n"
    "TUCK ( x1 x2 -- x2 x1 x2 )\n"
    "2DUP ( x1 x2 -- x1 x2 x1 x2 )\n"
    "2DROP ( x1 x2 -- )\n"
    "2SWAP ( x1 x2 x3 x4 -- x3 x4 x1 x2 )\n"
    "2OVER ( x1 x2 x3 x4 -- x1 x2 x3 x4 x1 x2 )\n"
    "2ROT ( x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2 )\n"
    "+ ( n1 n2 -- n3 )\n"
    "- ( n1 n2 -- n3 )\n"
    "* ( n1 n2 -- n3 )\n"
    "/ ( n1 n2 -- n3 )\n"
    "MOD ( n1 n2 -- n3 )\n"
    "/MOD ( n1 n2 -- n3 n4 )\n"
    "*/ ( n1 n2 n3 -- n4 )\n"
    "*/MOD ( n1 n2 n3 -- n4 n5 )\n"
    "NEGATE ( n1 -- n2 )\n"
    "ABS ( n1 -- n2 )\n"
    "MIN ( n1 n2 -- n3 )\n"
    "MAX ( n1 n2 -- n3 )\n"
    "1+ ( n1 -- n2 )\n"
    "1- ( n1 -- n2 )\n"
    "2* ( n1 -- n2 )\n"
    "2/ ( n1 -- n2 )\n"
    "AND ( x1 x2 -- x3 )\n"
    "OR ( x1 x2 -- x3 )\n"
    "XOR ( x1 x2 -- x3 )\n"
    "INVERT ( x1 -- x2 )\n"
    "LSHIFT ( x1 u -- x2 )\n"
    "RSHIFT ( x1 u -- x2 )\n"
    "= ( n1 n2 -- flag )\n"
    "<> ( n1 n2 -- flag )\n"
    "< ( n1 n2 -- flag )\n"
    "> ( n1 n2 -- flag )\n"
    "U< ( u1 u2 -- flag )\n"
    "U> ( u1 u2 -- flag )\n"
    ">= ( n1 n2 -- flag )\n"
    "<= ( n1 n2 -- flag )\n"
    "0= ( x -- flag )\n"
    "0<> ( x -- flag )\n"
    "0< ( n -- flag )\n"
    "0> ( n -- flag )\n"
    "WITHIN ( n1 n2 n3 -- flag )\n"
    "@ ( a-addr -- x )\n"
    "! ( x a-addr -- )\n"
    "C@ ( c-addr -- char )\n"
    "C! ( char c-addr -- )\n"
    "+! ( n a-addr -- )\n"
    "2@ ( a-addr -- x1 x2 )\n"
    "2! ( x1 x2 a-addr -- )\n"
    "CELL+ ( a-addr1 -- a-addr2 )\n"
    "CELLS ( n1 -- n2 )\n"
    "CELL ( -- n )\n"
    "CHAR+ ( c-addr1 -- c-addr2 )\n"
    "CHARS ( n1 -- n2 )\n"
    "ALIGNED ( addr -- a-addr )\n"
    "ALIGN ( -- )\n"
    "FILL ( c-addr u char -- )\n"
    "ERASE ( addr u -- )\n"
    "BLANK ( c-addr u -- )\n"
    "MOVE ( addr1 addr2 u -- )\n"
    "CMOVE ( c-addr1 c-addr2 u -- )\n"
    "CMOVE> ( c-addr1 c-addr2 u -- )\n"
    "/STRING ( c-addr1 u1 n -- c-addr2 u2 )\n"
    "-TRAILING ( c-addr u1 -- c-addr u2 )\n"
    "COMPARE ( c-addr1 u1 c-addr2 u2 -- n )\n"
    "TYPE ( c-addr u -- )\n"
    "COUNT ( c-addr1 -- c-addr2 u )\n"
    "ACCEPT ( c-addr u1 -- u2 )\n"
    "HERE ( -- addr )\n"
    "ALLOT ( n -- )\n"
    ", ( x -- )\n"
    "C, ( char -- )\n"
    "ALLOCATE ( u -- a-addr ior )\n"
    "FREE ( a-addr -- ior )\n"
    "RESIZE ( a-addr1 u -- a-addr2 ior )\n"
    "S>D ( n -- d )\n"
    "D>S ( d -- n )\n"
    "D+ ( d1 d2 -- d3 )\n"
    "D- ( d1 d2 -- d3 )\n"
    "DNEGATE ( d1 -- d2 )\n"
    "DABS ( d1 -- d2 )\n"
    "D= ( d1 d2 -- flag )\n"
    "D< ( d1 d2 -- flag )\n"
    "D0= ( d -- flag )\n"
    "D0< ( d -- flag )\n"
    "D2* ( d1 -- d2 )\n"
    "D2/ ( d1 -- d2 )\n"
    "DMAX ( d1 d2 -- d3 )\n"
    "DMIN ( d1 d2 -- d3 )\n"
    "M* ( n1 n2 -- d )\n"
    "UM* ( u1 u2 -- ud )\n"
    "SM/REM ( d n -- n2 n3 )\n"
    "FM/MOD ( d n -- n2 n3 )\n"
    "UM/MOD ( ud u1 -- u2 u3 )\n"
    "M+ ( d1 n -- d2 )\n"
    "DEPTH ( -- n )\n"
    "BL ( -- char )\n"
    "TRUE ( -- flag )\n"
    "FALSE ( -- flag )\n"
    "STATE ( -- a-addr )\n"
    "BASE ( -- a-addr )\n"
    ">IN ( -- a-addr )\n"
    "SOURCE ( -- c-addr u )\n"
    "SOURCE-ID ( -- n )\n"
    "PAD ( -- c-addr )\n"
    "KEY ( -- char )\n"
    "KEY? ( -- flag )\n"
    "EMIT ( char -- )\n"
    "CR ( -- )\n"
    "SPACE ( -- )\n"
    "SPACES ( n -- )\n"
    ". ( n -- )\n"
    "U. ( u -- )\n"
    ".R ( n u -- )\n"
    "U.R ( u1 u2 -- )\n"
    ".S ( -- )\n"
    "THROW ( n -- )\n"
    "OPEN-FILE ( c-addr u fam -- fileid ior )\n"
    "CREATE-FILE ( c-addr u fam -- fileid ior )\n"
    "CLOSE-FILE ( fileid -- ior )\n"
    "READ-FILE ( c-addr u1 fileid -- u2 ior )\n"
    "WRITE-FILE ( c-addr u fileid -- ior )\n"
    "READ-LINE ( c-addr u1 fileid -- u2 flag ior )\n"
    "WRITE-LINE ( c-addr u fileid -- ior )\n"
    "FILE-SIZE ( fileid -- ud ior )\n"
    "FILE-POSITION ( fileid -- ud ior )\n"
    "REPOSITION-FILE ( ud fileid -- ior )\n"
    "DELETE-FILE ( c-addr u -- ior )\n"
    "RENAME-FILE ( c-addr1 u1 c-addr2 u2 -- ior )\n"
    "FILE-STATUS ( c-addr u -- x ior )\n"
    "FLUSH-FILE ( fileid -- ior )\n"
    "RESIZE-FILE ( ud fileid -- ior )\n"
    "R/O ( -- fam )\n"
    "W/O ( -- fam )\n"
    "R/W ( -- fam )\n"
    "BIN ( fam1 -- fam2 )\n"
    "TIME&DATE ( -- n1 n2 n3 n4 n5 n6 )\n"
    "MS ( u -- )\n"
    "WORD ( char -- c-addr )\n");

const QHash<QString, Pattern> &builtinPatterns() {
    static const QHash<QString, Pattern> map = [] {
        QHash<QString, Pattern> built;
        const QStringList lines = kPatternLines.split(QLatin1Char('\n'));
        for (QString line : lines) {
            line = line.trimmed();
            if (line.isEmpty() || line.startsWith(QLatin1Char('#')))
                continue;
            const int space = line.indexOf(QLatin1Char(' '));
            if (space < 0)
                continue;
            bool ok = false;
            const Pattern pattern = parsePattern(line.mid(space).trimmed(), &ok);
            if (ok)
                built.insert(line.left(space).toUpper(), pattern);
        }
        return built;
    }();
    return map;
}

const QSet<QString> &floatWords() {
    static const QSet<QString> words = {
        QStringLiteral("F+"), QStringLiteral("F-"), QStringLiteral("F*"), QStringLiteral("F/"),
        QStringLiteral("FNEGATE"), QStringLiteral("FABS"), QStringLiteral("FMAX"), QStringLiteral("FMIN"),
        QStringLiteral("FSQRT"), QStringLiteral("FSIN"), QStringLiteral("FCOS"), QStringLiteral("FTAN"),
        QStringLiteral("FASIN"), QStringLiteral("FACOS"), QStringLiteral("FATAN"), QStringLiteral("FATAN2"),
        QStringLiteral("FEXP"), QStringLiteral("FLN"), QStringLiteral("FLOG"), QStringLiteral("F**"),
        QStringLiteral("FLOOR"), QStringLiteral("FROUND"), QStringLiteral("FTRUNC"), QStringLiteral("FDUP"),
        QStringLiteral("FDROP"), QStringLiteral("FSWAP"), QStringLiteral("FOVER"), QStringLiteral("FROT"),
        QStringLiteral("FNIP"), QStringLiteral("FTUCK"), QStringLiteral("F0="), QStringLiteral("F0<"),
        QStringLiteral("F<"), QStringLiteral("F>"), QStringLiteral("F="), QStringLiteral("F~"),
        QStringLiteral("F."), QStringLiteral("FS."), QStringLiteral("FE."), QStringLiteral("FLITERAL"),
        QStringLiteral("FLOATS"), QStringLiteral("FLOAT+"), QStringLiteral("DFLOATS"), QStringLiteral("DFLOAT+"),
        QStringLiteral("FALIGN"), QStringLiteral("FALIGNED"), QStringLiteral("PRECISION"),
        QStringLiteral("SET-PRECISION"), QStringLiteral("REPRESENT"), QStringLiteral("FVARIABLE"),
        QStringLiteral("FCONSTANT"), QStringLiteral("F@"), QStringLiteral("F!"), QStringLiteral("F>S"),
        QStringLiteral("S>F"), QStringLiteral("D>F"), QStringLiteral("F>D")};
    return words;
}

int digitValue(QChar ch) {
    const ushort v = ch.unicode();
    if (v >= 48 && v <= 57)
        return v - 48;
    if (v >= 65 && v <= 90)
        return v - 65 + 10;
    if (v >= 97 && v <= 122)
        return v - 97 + 10;
    return -1;
}

QString normalizeDeclared(QString text) {
    text = text.trimmed();
    if (!text.startsWith(QLatin1Char('(')))
        text.prepend(QLatin1Char('('));
    if (!text.endsWith(QLatin1Char(')')))
        text.append(QLatin1Char(')'));
    const QString inner = text.mid(1, text.size() - 2);
    const QStringList parts = inner.split(QStringLiteral("--"));
    if (parts.size() < 2)
        return text;
    const QString before = parts.at(0).split(QRegularExpression(QStringLiteral("\\s+")), Qt::SkipEmptyParts).join(QLatin1Char(' '));
    QString afterRaw;
    for (int i = 1; i < parts.size(); ++i) {
        if (i > 1)
            afterRaw += QStringLiteral("--");
        afterRaw += parts.at(i);
    }
    const QString after = afterRaw.split(QRegularExpression(QStringLiteral("\\s+")), Qt::SkipEmptyParts).join(QLatin1Char(' '));
    if (before.isEmpty() && after.isEmpty())
        return QStringLiteral("( -- )");
    if (before.isEmpty())
        return QStringLiteral("( -- %1 )").arg(after);
    if (after.isEmpty())
        return QStringLiteral("( %1 -- )").arg(before);
    return QStringLiteral("( %1 -- %2 )").arg(before, after);
}

QString formatComment(const QString &beforeRaw, const QString &afterRaw) {
    const QString before = beforeRaw.trimmed();
    const QString after = afterRaw.trimmed();
    if (before.isEmpty() && after.isEmpty())
        return QStringLiteral("( -- )");
    if (before.isEmpty())
        return QStringLiteral("( -- %1 )").arg(after);
    if (after.isEmpty())
        return QStringLiteral("( %1 -- )").arg(before);
    return QStringLiteral("( %1 -- %2 )").arg(before, after);
}

class Tracer {
public:
    Tracer(const QVector<Token> &body, int base, const QHash<QString, UserWord> &users)
        : m_body(body), m_base(base), m_users(users) {}

    struct Outcome {
        DefResult result;
        bool registered = false;
        Pattern pattern;
    };

    Outcome run(const QString &name, int line);

private:
    bool skipEffects() const { return m_unreachable || m_gaveUp; }
    void note(const QString &text);
    void step();
    bool startedCode(int commentIndex) const;
    void applyBracket(const QString &word);
    void applyWord(const QString &upper, const QString &display, int line);
    void giveUpWord(const QString &display);
    void giveUp(const QString &reason);
    void applyRecurse();
    QString takeBodyName();
    void opIF(int line);
    void opELSE(int line);
    void opTHEN();
    void join(const QVector<Cell> &thenData, const QVector<Cell> &thenRet, bool thenLive,
              const QVector<Cell> &elseData, const QVector<Cell> &elseRet, bool elseLive);
    void opUNTIL();
    void opAGAIN();
    void opWHILE(int line);
    void opREPEAT();
    void opDO(int line);
    void opLOOP(bool plus);
    void opIndex(int depth);
    void opLEAVE();
    void opEXIT();
    void opQdup();
    void clearQdup();
    void opPick();
    void opRoll();
    void opCASE(int line);
    void opOF(int line);
    void opENDOF();
    void opENDCASE();
    void opLocalsBar();
    void opBrace();
    void opTO(bool plus);
    void apply(const Pattern &pattern);
    QVector<Cell> popSym(const Sym &sym);
    void pushWide(const QString &role);
    Cell pop(const QString &role);
    Cell createInput(const QString &role, bool paired, int pair);
    Cell fresh(const QString &role, bool hasLiteral, qint64 literal, bool paired, int pair);
    void push(const Cell &cell);
    void deepen(int depth);
    void pushNumber(const ParsedNumber &number, const QString &spelling);
    QVector<Cell> unify(const QVector<Cell> &left, const QVector<Cell> &right);
    QString renderComment(const QVector<Cell> &inputs, const QVector<Cell> *outputs);
    QString render(const QVector<Cell> &cells, QHash<int, QString> &names, QSet<QString> &used);
    QString display(const Cell &cell, QHash<int, QString> &names, QSet<QString> &used);
    Pattern patternOf(const QVector<Cell> &inputs, const QVector<Cell> &outputs);
    QVector<Sym> namedSyms(const QVector<Cell> &cells, QHash<int, QString> &names, QSet<QString> &used);
    QString compareDeclared(const QString &declared, const QVector<Cell> &inputs, const QVector<Cell> &outputs);
    ParsedNumber parseNumber(const QString &token) const;
    bool characterLiteral(const QString &token, int *value) const;
    bool isFloatLiteral(const QString &token) const;
    QVector<Cell> *finishExits();
    QString detailText() const;
    Outcome finish(const QString &name, int line);

    QVector<Token> m_body;
    int m_index = 0;
    int m_base = 10;
    QHash<QString, UserWord> m_users;
    QVector<Cell> m_data;
    QVector<Cell> m_ret;
    QVector<Cell> m_inputs;
    QVector<Frame> m_frames;
    QVector<QVector<Cell>> m_exits;
    QHash<QString, Cell> m_locals;
    int m_nextId = 1;
    int m_nextPair = 1;
    bool m_unreachable = false;
    bool m_gaveUp = false;
    bool m_broken = false;
    bool m_ambiguous = false;
    bool m_sawFloat = false;
    bool m_hasQdup = false;
    QVector<Cell> m_qdupBefore;
    QStringList m_notes;
    QStringList m_unknowns;
    QString m_declared;
    bool m_hasDeclared = false;
    int m_bracket = 0;
    QVector<Cell> m_exitAcc;
    bool m_hasExitAcc = false;
};

QVector<Token> tokenize(const QString &source) {
    QVector<Token> tokens;
    int index = 0;
    int line = 1;
    const int n = source.size();
    auto bump = [&] {
        if (index >= n)
            return;
        if (source.at(index) == QLatin1Char('\n'))
            ++line;
        ++index;
    };
    auto readParenBody = [&] {
        int depth = 1;
        QString body;
        while (index < n) {
            const QChar ch = source.at(index);
            if (ch == QLatin1Char('('))
                ++depth;
            if (ch == QLatin1Char(')')) {
                --depth;
                if (depth == 0) {
                    bump();
                    break;
                }
            }
            body.append(ch);
            bump();
        }
        return body;
    };
    auto skipQuoted = [&](bool escaped) {
        while (index < n) {
            const QChar ch = source.at(index);
            if (escaped && ch == QLatin1Char('\\')) {
                bump();
                if (index < n)
                    bump();
                continue;
            }
            if (ch == QLatin1Char('"')) {
                bump();
                break;
            }
            bump();
        }
    };
    while (index < n) {
        const QChar ch = source.at(index);
        if (ch == QLatin1Char(' ') || ch == QLatin1Char('\t') || ch == QLatin1Char('\r') || ch == QLatin1Char('\n')) {
            bump();
            continue;
        }
        const int startLine = line;
        const int start = index;
        while (index < n) {
            const QChar c = source.at(index);
            if (c == QLatin1Char(' ') || c == QLatin1Char('\t') || c == QLatin1Char('\n') || c == QLatin1Char('\r'))
                break;
            bump();
        }
        const QString text = source.mid(start, index - start);
        if (text == QLatin1String("\\")) {
            while (index < n && source.at(index) != QLatin1Char('\n'))
                bump();
            continue;
        }
        if (text == QLatin1String("(")) {
            const QString body = readParenBody();
            if (body.contains(QStringLiteral("--")))
                tokens.append(Token{body, startLine, TokenKind::StackComment});
            continue;
        }
        if (text == QLatin1String(".(")) {
            readParenBody();
            tokens.append(Token{QStringLiteral(".("), startLine, TokenKind::Word});
            continue;
        }
        if (text == QLatin1String(".\"") || text == QLatin1String("S\"") || text == QLatin1String("C\"") ||
            text == QLatin1String("ABORT\"") || text == QLatin1String("S\\\"")) {
            skipQuoted(text == QLatin1String("S\\\""));
            tokens.append(Token{text, startLine, TokenKind::Word});
            continue;
        }
        tokens.append(Token{text, startLine, TokenKind::Word});
    }
    return tokens;
}

class Analyzer {
public:
    explicit Analyzer(const QString &source) : m_tokens(tokenize(source)) {}
    QVector<DefResult> definitions(int limit);

private:
    bool definingEffect(const QString &word, Pattern *pattern) const;
    QString takeName();
    void skipCode();
    void parseColon();

    QVector<Token> m_tokens;
    int m_index = 0;
    int m_base = 10;
    QHash<QString, UserWord> m_users;
    QString m_lastDefined;
    bool m_hasLast = false;
    QVector<DefResult> m_results;
};

QVector<DefResult> Analyzer::definitions(int limit) {
    while (m_index < m_tokens.size() && m_results.size() < limit) {
        const Token token = m_tokens.at(m_index);
        if (token.kind == TokenKind::StackComment) {
            ++m_index;
            continue;
        }
        const QString word = token.text.toUpper();
        if (word == QLatin1String(":")) {
            parseColon();
            continue;
        }
        if (word == QLatin1String("CODE")) {
            skipCode();
            continue;
        }
        if (word == QLatin1String("HEX")) {
            m_base = 16;
            ++m_index;
            continue;
        }
        if (word == QLatin1String("DECIMAL")) {
            m_base = 10;
            ++m_index;
            continue;
        }
        if (word == QLatin1String("IMMEDIATE")) {
            if (m_hasLast && m_users.contains(m_lastDefined.toUpper())) {
                UserWord user = m_users.value(m_lastDefined.toUpper());
                user.immediate = true;
                m_users.insert(m_lastDefined.toUpper(), user);
            }
            ++m_index;
            continue;
        }
        Pattern defined;
        if (definingEffect(word, &defined)) {
            const QString name = takeName();
            if (name.isEmpty())
                continue;
            UserWord user;
            user.hasPattern = true;
            user.pattern = defined;
            m_users.insert(name.toUpper(), user);
            m_lastDefined = name;
            m_hasLast = true;
            continue;
        }
        ++m_index;
    }
    return m_results;
}

bool Analyzer::definingEffect(const QString &word, Pattern *pattern) const {
    bool ok = false;
    if (word == QLatin1String("VARIABLE") || word == QLatin1String("2VARIABLE") || word == QLatin1String("CREATE") ||
        word == QLatin1String("BUFFER:")) {
        *pattern = parsePattern(QStringLiteral("( -- a-addr )"), &ok);
        return ok;
    }
    if (word == QLatin1String("CONSTANT") || word == QLatin1String("VALUE")) {
        *pattern = parsePattern(QStringLiteral("( -- n )"), &ok);
        return ok;
    }
    if (word == QLatin1String("2CONSTANT")) {
        *pattern = parsePattern(QStringLiteral("( -- d )"), &ok);
        return ok;
    }
    return false;
}

QString Analyzer::takeName() {
    ++m_index;
    if (m_index >= m_tokens.size() || m_tokens.at(m_index).kind != TokenKind::Word)
        return QString();
    const QString name = m_tokens.at(m_index).text;
    ++m_index;
    if (name == QLatin1String(";"))
        return QString();
    return name;
}

void Analyzer::skipCode() {
    ++m_index;
    QString name;
    if (m_index < m_tokens.size() && m_tokens.at(m_index).kind == TokenKind::Word) {
        name = m_tokens.at(m_index).text;
        ++m_index;
    }
    while (m_index < m_tokens.size()) {
        const QString word = m_tokens.at(m_index).text.toUpper();
        ++m_index;
        if (word == QLatin1String("END-CODE"))
            break;
    }
    if (!name.isEmpty()) {
        DefResult result;
        result.name = name;
        result.verdict = Verdict::NotInferred;
        result.detail = QStringLiteral("CODE word; machine code is not traced");
        m_results.append(result);
        m_users.insert(name.toUpper(), UserWord{});
        m_lastDefined = name;
        m_hasLast = true;
    }
}

void Analyzer::parseColon() {
    const int colonLine = m_tokens.at(m_index).line;
    ++m_index;
    if (m_index >= m_tokens.size() || m_tokens.at(m_index).kind != TokenKind::Word)
        return;
    const QString rawName = m_tokens.at(m_index).text;
    ++m_index;
    const bool noname = rawName.toUpper() == QLatin1String("NONAME");
    const QString name = noname ? QStringLiteral(":NONAME") : rawName;
    QVector<Token> body;
    bool closed = false;
    while (m_index < m_tokens.size()) {
        const Token token = m_tokens.at(m_index);
        ++m_index;
        if (token.kind == TokenKind::Word && token.text == QLatin1String(";")) {
            closed = true;
            break;
        }
        body.append(token);
    }
    if (!closed)
        return;
    Tracer tracer(body, m_base, m_users);
    const Tracer::Outcome outcome = tracer.run(name, colonLine);
    m_results.append(outcome.result);
    UserWord user;
    user.hasPattern = outcome.registered;
    user.pattern = outcome.pattern;
    m_users.insert(name.toUpper(), user);
    m_lastDefined = name;
    m_hasLast = true;
}

void Tracer::note(const QString &text) {
    if (!m_notes.contains(text))
        m_notes.append(text);
}

Tracer::Outcome Tracer::run(const QString &name, int line) {
    while (m_index < m_body.size())
        step();
    clearQdup();
    return finish(name, line);
}

QVector<Cell> *Tracer::finishExits() {
    if (!m_unreachable && !m_gaveUp)
        m_exits.append(m_data);
    if (m_exits.isEmpty())
        return nullptr;
    const int depth = m_exits.at(0).size();
    for (const QVector<Cell> &stack : m_exits) {
        if (stack.size() != depth) {
            note(QStringLiteral("exit paths leave different stack depths"));
            m_broken = true;
            m_exitAcc = m_exits.at(0);
            m_hasExitAcc = true;
            return &m_exitAcc;
        }
    }
    QVector<Cell> acc = m_exits.at(0);
    for (int i = 1; i < m_exits.size(); ++i)
        acc = unify(acc, m_exits.at(i));
    m_exitAcc = acc;
    m_hasExitAcc = true;
    return &m_exitAcc;
}

QString Tracer::detailText() const {
    QStringList parts;
    if (!m_unknowns.isEmpty())
        parts << QStringLiteral("unknown word%1 %2").arg(m_unknowns.size() == 1 ? QString() : QStringLiteral("s"),
                                                         m_unknowns.join(QStringLiteral(", ")));
    parts << m_notes;
    if (parts.isEmpty() && m_exits.isEmpty())
        parts << QStringLiteral("does not return");
    return parts.join(QStringLiteral("; "));
}

Tracer::Outcome Tracer::finish(const QString &name, int line) {
    Q_UNUSED(line);
    if (!m_frames.isEmpty()) {
        note(QStringLiteral("unbalanced control flow at ;"));
        m_broken = true;
    }
    if (!m_ret.isEmpty() && !m_gaveUp) {
        note(QStringLiteral("return stack still has %1 item(s) at ;").arg(m_ret.size()));
        m_broken = true;
    }
    if (m_sawFloat)
        note(QStringLiteral("float stack is separate and was not checked"));
    QVector<Cell> *outputs = finishExits();
    const QString traced = renderComment(m_inputs, outputs);
    const QString detail = detailText();
    Verdict verdict = Verdict::Copy;
    QString shown = traced;
    if (m_gaveUp || m_broken || outputs == nullptr) {
        verdict = Verdict::NotInferred;
    } else if (m_ambiguous) {
        verdict = Verdict::Ambiguous;
    } else if (m_hasDeclared) {
        const QString check = compareDeclared(m_declared, m_inputs, *outputs);
        if (check == QLatin1String("matches")) {
            verdict = Verdict::Copy;
            shown = normalizeDeclared(m_declared);
        } else {
            verdict = Verdict::Mismatch;
        }
    }
    Outcome outcome;
    if (verdict == Verdict::Copy || verdict == Verdict::Mismatch) {
        outcome.registered = true;
        outcome.pattern = patternOf(m_inputs, outputs == nullptr ? QVector<Cell>() : *outputs);
    }
    outcome.result.name = name;
    outcome.result.traced = shown;
    outcome.result.hasDeclared = m_hasDeclared;
    outcome.result.declared = m_hasDeclared ? normalizeDeclared(m_declared) : QString();
    outcome.result.verdict = verdict;
    outcome.result.detail = detail;
    return outcome;
}

void Tracer::step() {
    const Token token = m_body.at(m_index);
    ++m_index;
    if (token.kind == TokenKind::StackComment) {
        if (!m_hasDeclared && !startedCode(m_index - 1)) {
            m_declared = token.text;
            m_hasDeclared = true;
        }
        return;
    }
    const QString word = token.text;
    const QString upper = word.toUpper();
    if (m_bracket > 0) {
        applyBracket(upper);
        return;
    }
    if (upper == QLatin1String("[")) {
        ++m_bracket;
        return;
    }
    const ParsedNumber number = parseNumber(word);
    if (number.ok) {
        pushNumber(number, word);
        return;
    }
    int code = 0;
    if (characterLiteral(word, &code)) {
        push(fresh(word, true, code, false, 0));
        return;
    }
    if (isFloatLiteral(word)) {
        m_sawFloat = true;
        return;
    }
    applyWord(upper, word, token.line);
}

bool Tracer::startedCode(int commentIndex) const {
    for (int i = 0; i < commentIndex && i < m_body.size(); ++i) {
        if (m_body.at(i).kind == TokenKind::Word)
            return true;
    }
    return false;
}

void Tracer::applyBracket(const QString &word) {
    if (word == QLatin1String("]"))
        m_bracket = qMax(0, m_bracket - 1);
    else if (word == QLatin1String("HEX"))
        m_base = 16;
    else if (word == QLatin1String("DECIMAL"))
        m_base = 10;
    else if (word == QLatin1String("LITERAL")) {
        if (!skipEffects())
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
    } else if (word == QLatin1String("2LITERAL")) {
        if (!skipEffects()) {
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
        }
    }
}

void Tracer::applyWord(const QString &upper, const QString &display, int line) {
    if (m_locals.contains(upper)) {
        if (skipEffects())
            return;
        clearQdup();
        push(m_locals.value(upper));
        return;
    }
    if (upper == QLatin1String("RECURSE")) {
        clearQdup();
        applyRecurse();
        return;
    }
    if (upper == QLatin1String("IF")) {
        opIF(line);
        return;
    }
    if (upper == QLatin1String("ELSE")) {
        opELSE(line);
        return;
    }
    if (upper == QLatin1String("THEN")) {
        opTHEN();
        return;
    }
    if (upper == QLatin1String("BEGIN")) {
        clearQdup();
        Frame frame;
        frame.kind = FrameKind::Begin;
        frame.dataA = m_data;
        frame.retA = m_ret;
        frame.live = !skipEffects();
        frame.line = line;
        m_frames.append(frame);
        return;
    }
    if (upper == QLatin1String("UNTIL")) {
        opUNTIL();
        return;
    }
    if (upper == QLatin1String("AGAIN")) {
        opAGAIN();
        return;
    }
    if (upper == QLatin1String("WHILE")) {
        opWHILE(line);
        return;
    }
    if (upper == QLatin1String("REPEAT")) {
        opREPEAT();
        return;
    }
    if (upper == QLatin1String("DO") || upper == QLatin1String("?DO")) {
        opDO(line);
        return;
    }
    if (upper == QLatin1String("LOOP")) {
        opLOOP(false);
        return;
    }
    if (upper == QLatin1String("+LOOP")) {
        opLOOP(true);
        return;
    }
    if (upper == QLatin1String("I")) {
        opIndex(1);
        return;
    }
    if (upper == QLatin1String("J")) {
        opIndex(2);
        return;
    }
    if (upper == QLatin1String("LEAVE")) {
        opLEAVE();
        return;
    }
    if (upper == QLatin1String("UNLOOP")) {
        clearQdup();
        if (skipEffects())
            return;
        if (m_ret.size() >= 2) {
            m_ret.removeLast();
            m_ret.removeLast();
        } else {
            note(QStringLiteral("UNLOOP without a DO frame"));
            m_broken = true;
        }
        return;
    }
    if (upper == QLatin1String("EXIT")) {
        opEXIT();
        return;
    }
    if (upper == QLatin1String("?DUP")) {
        opQdup();
        return;
    }
    if (upper == QLatin1String("PICK")) {
        opPick();
        return;
    }
    if (upper == QLatin1String("ROLL")) {
        opRoll();
        return;
    }
    if (upper == QLatin1String(">R")) {
        clearQdup();
        if (!skipEffects())
            m_ret.append(pop(QStringLiteral("x")));
        return;
    }
    if (upper == QLatin1String("R>")) {
        clearQdup();
        if (skipEffects())
            return;
        if (!m_ret.isEmpty()) {
            push(m_ret.takeLast());
        } else {
            note(QStringLiteral("R> return-stack underflow"));
            m_broken = true;
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
        }
        return;
    }
    if (upper == QLatin1String("R@")) {
        clearQdup();
        if (skipEffects())
            return;
        if (!m_ret.isEmpty())
            push(m_ret.last());
        else {
            note(QStringLiteral("R@ outside a return value"));
            m_broken = true;
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
        }
        return;
    }
    if (upper == QLatin1String("2>R")) {
        clearQdup();
        if (skipEffects())
            return;
        const Cell hi = pop(QStringLiteral("x"));
        const Cell lo = pop(QStringLiteral("x"));
        m_ret.append(lo);
        m_ret.append(hi);
        return;
    }
    if (upper == QLatin1String("2R>")) {
        clearQdup();
        if (skipEffects())
            return;
        if (m_ret.size() < 2) {
            note(QStringLiteral("2R> return-stack underflow"));
            m_broken = true;
            return;
        }
        const Cell hi = m_ret.takeLast();
        const Cell lo = m_ret.takeLast();
        push(lo);
        push(hi);
        return;
    }
    if (upper == QLatin1String("2R@")) {
        clearQdup();
        if (skipEffects())
            return;
        if (m_ret.size() < 2) {
            note(QStringLiteral("2R@ outside a return pair"));
            m_broken = true;
            return;
        }
        push(m_ret.at(m_ret.size() - 2));
        push(m_ret.at(m_ret.size() - 1));
        return;
    }
    if (upper == QLatin1String("ABORT") || upper == QLatin1String("QUIT")) {
        clearQdup();
        m_data.clear();
        m_ret.clear();
        m_unreachable = true;
        return;
    }
    if (upper == QLatin1String("S\"") || upper == QLatin1String("S\\\"")) {
        clearQdup();
        if (skipEffects())
            return;
        push(fresh(QStringLiteral("c-addr"), false, 0, false, 0));
        push(fresh(QStringLiteral("u"), false, 0, false, 0));
        return;
    }
    if (upper == QLatin1String("C\"")) {
        clearQdup();
        if (!skipEffects())
            push(fresh(QStringLiteral("c-addr"), false, 0, false, 0));
        return;
    }
    if (upper == QLatin1String(".\"")) {
        clearQdup();
        return;
    }
    if (upper == QLatin1String(".("))
        return;
    if (upper == QLatin1String("ABORT\"")) {
        clearQdup();
        if (!skipEffects())
            pop(QStringLiteral("flag"));
        return;
    }
    if (upper == QLatin1String("[']") || upper == QLatin1String("'")) {
        clearQdup();
        takeBodyName();
        if (!skipEffects())
            push(fresh(QStringLiteral("xt"), false, 0, false, 0));
        return;
    }
    if (upper == QLatin1String("CHAR") || upper == QLatin1String("[CHAR]")) {
        clearQdup();
        takeBodyName();
        if (!skipEffects())
            push(fresh(QStringLiteral("char"), false, 0, false, 0));
        return;
    }
    if (upper == QLatin1String("POSTPONE")) {
        clearQdup();
        const QString postponed = takeBodyName();
        if (postponed.isEmpty()) {
            note(QStringLiteral("POSTPONE without a word"));
            m_broken = true;
            return;
        }
        applyWord(postponed.toUpper(), postponed, line);
        return;
    }
    if (upper == QLatin1String("LITERAL")) {
        clearQdup();
        if (!skipEffects())
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
        return;
    }
    if (upper == QLatin1String("2LITERAL")) {
        clearQdup();
        if (!skipEffects()) {
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
            push(fresh(QStringLiteral("x"), false, 0, false, 0));
        }
        return;
    }
    if (upper == QLatin1String("TO") || upper == QLatin1String("+TO")) {
        opTO(upper == QLatin1String("+TO"));
        return;
    }
    if (upper == QLatin1String("LOCALS|")) {
        opLocalsBar();
        return;
    }
    if (upper == QLatin1String("{:")) {
        opBrace();
        return;
    }
    if (upper == QLatin1String("EXECUTE")) {
        giveUp(QStringLiteral("EXECUTE stack effect depends on the execution token"));
        return;
    }
    if (upper == QLatin1String("EVALUATE") || upper == QLatin1String("INCLUDED") || upper == QLatin1String("INCLUDE") ||
        upper == QLatin1String("INCLUDE-FILE") || upper == QLatin1String("FLOAD") || upper == QLatin1String("LOAD")) {
        giveUp(QStringLiteral("%1 can change the stack").arg(upper));
        return;
    }
    if (upper == QLatin1String("CATCH")) {
        giveUp(QStringLiteral("CATCH stack effect depends on the execution token"));
        return;
    }
    if (upper == QLatin1String("AHEAD") || upper == QLatin1String("CS-ROLL") || upper == QLatin1String("CS-PICK") ||
        upper == QLatin1String("DOES>")) {
        giveUp(QStringLiteral("%1 is not traced").arg(upper));
        return;
    }
    if (upper == QLatin1String("CASE")) {
        opCASE(line);
        return;
    }
    if (upper == QLatin1String("OF")) {
        opOF(line);
        return;
    }
    if (upper == QLatin1String("ENDOF")) {
        opENDOF();
        return;
    }
    if (upper == QLatin1String("ENDCASE")) {
        opENDCASE();
        return;
    }
    if (m_users.contains(upper)) {
        clearQdup();
        const UserWord user = m_users.value(upper);
        if (user.immediate)
            giveUp(QStringLiteral("%1 is immediate; its compile-time effect is not traced").arg(display));
        else if (user.hasPattern)
            apply(user.pattern);
        else
            giveUp(QStringLiteral("%1 has no known stack effect").arg(display));
        return;
    }
    if (builtinPatterns().contains(upper)) {
        clearQdup();
        apply(builtinPatterns().value(upper));
        return;
    }
    if (floatWords().contains(upper)) {
        clearQdup();
        m_sawFloat = true;
        return;
    }
    if (upper == QLatin1String("]"))
        return;
    clearQdup();
    giveUpWord(display);
}

void Tracer::giveUpWord(const QString &display) {
    if (!m_unknowns.contains(display))
        m_unknowns.append(display);
    m_gaveUp = true;
}

void Tracer::giveUp(const QString &reason) {
    note(reason);
    m_gaveUp = true;
}

void Tracer::applyRecurse() {
    if (skipEffects())
        return;
    bool ok = false;
    if (!m_hasDeclared) {
        giveUp(QStringLiteral("RECURSE needs a stack comment; the effect is not known yet"));
        return;
    }
    const Pattern pattern = parsePattern(normalizeDeclared(m_declared), &ok);
    if (!ok) {
        giveUp(QStringLiteral("RECURSE needs a stack comment; the effect is not known yet"));
        return;
    }
    apply(pattern);
}

QString Tracer::takeBodyName() {
    if (m_index >= m_body.size() || m_body.at(m_index).kind != TokenKind::Word)
        return QString();
    const QString name = m_body.at(m_index).text;
    ++m_index;
    return name;
}

void Tracer::opIF(int line) {
    if (m_hasQdup) {
        QVector<Cell> zero = m_qdupBefore;
        m_hasQdup = false;
        if (!zero.isEmpty())
            zero.removeLast();
        if (!m_data.isEmpty())
            m_data.removeLast();
        Frame frame;
        frame.kind = FrameKind::IfThen;
        frame.dataA = zero;
        frame.retA = m_ret;
        frame.live = !skipEffects();
        frame.line = line;
        m_frames.append(frame);
        return;
    }
    if (!skipEffects())
        pop(QStringLiteral("flag"));
    Frame frame;
    frame.kind = FrameKind::IfThen;
    frame.dataA = m_data;
    frame.retA = m_ret;
    frame.live = !skipEffects();
    frame.line = line;
    m_frames.append(frame);
}

void Tracer::opELSE(int line) {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::IfThen) {
        note(QStringLiteral("ELSE without IF"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    const QVector<Cell> thenData = m_data;
    const QVector<Cell> thenRet = m_ret;
    const bool thenLive = !skipEffects();
    m_data = frame.dataA;
    m_ret = frame.retA;
    m_unreachable = !frame.live;
    Frame next;
    next.kind = FrameKind::ElseBranch;
    next.dataA = thenData;
    next.retA = thenRet;
    next.live = thenLive;
    next.line = line;
    m_frames.append(next);
}

void Tracer::opTHEN() {
    if (m_frames.isEmpty()) {
        note(QStringLiteral("THEN without IF"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    if (frame.kind == FrameKind::IfThen) {
        join(m_data, m_ret, !skipEffects(), frame.dataA, frame.retA, frame.live);
    } else if (frame.kind == FrameKind::ElseBranch) {
        join(frame.dataA, frame.retA, frame.live, m_data, m_ret, !skipEffects());
    } else {
        note(QStringLiteral("THEN does not match IF"));
        m_broken = true;
    }
}

void Tracer::join(const QVector<Cell> &thenData, const QVector<Cell> &thenRet, bool thenLive,
                  const QVector<Cell> &elseData, const QVector<Cell> &elseRet, bool elseLive) {
    if (m_gaveUp) {
        m_unreachable = false;
        return;
    }
    if (thenLive && elseLive) {
        if (thenData.size() != elseData.size()) {
            note(QStringLiteral("IF/ELSE/THEN stack depths differ (%1 and %2)").arg(thenData.size()).arg(elseData.size()));
            m_broken = true;
            m_data = thenData;
        } else {
            m_data = unify(thenData, elseData);
        }
        if (thenRet.size() != elseRet.size()) {
            note(QStringLiteral("IF/ELSE/THEN return-stack depths differ"));
            m_broken = true;
        }
        m_ret = thenRet;
        m_unreachable = false;
    } else if (thenLive && !elseLive) {
        m_data = thenData;
        m_ret = thenRet;
        m_unreachable = false;
    } else if (!thenLive && elseLive) {
        m_data = elseData;
        m_ret = elseRet;
        m_unreachable = false;
    } else {
        m_unreachable = true;
    }
}

void Tracer::opUNTIL() {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::Begin) {
        note(QStringLiteral("UNTIL without BEGIN"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    clearQdup();
    if (!skipEffects())
        pop(QStringLiteral("flag"));
    if (!m_gaveUp && frame.live && !m_unreachable && m_data.size() != frame.dataA.size()) {
        note(QStringLiteral("UNTIL stack does not match BEGIN (%1 vs %2)").arg(m_data.size()).arg(frame.dataA.size()));
        m_broken = true;
    }
    m_unreachable = !frame.live && m_unreachable;
    if (frame.live)
        m_unreachable = false;
}

void Tracer::opAGAIN() {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::Begin) {
        note(QStringLiteral("AGAIN without BEGIN"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    clearQdup();
    if (!m_gaveUp && !m_unreachable && m_data.size() != frame.dataA.size()) {
        note(QStringLiteral("AGAIN stack does not match BEGIN"));
        m_broken = true;
    }
    m_unreachable = true;
}

void Tracer::opWHILE(int line) {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::Begin) {
        note(QStringLiteral("WHILE without BEGIN"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    clearQdup();
    if (!skipEffects())
        pop(QStringLiteral("flag"));
    Frame next;
    next.kind = FrameKind::WhileBody;
    next.dataA = frame.dataA;
    next.dataB = m_data;
    next.retA = frame.retA;
    next.retB = m_ret;
    next.live = frame.live;
    next.line = line;
    m_frames.append(next);
}

void Tracer::opREPEAT() {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::WhileBody) {
        note(QStringLiteral("REPEAT without WHILE"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    const bool bodyLive = !m_unreachable && !m_gaveUp;
    if (bodyLive && m_data.size() != frame.dataA.size()) {
        note(QStringLiteral("REPEAT stack does not match BEGIN (%1 vs %2)").arg(m_data.size()).arg(frame.dataA.size()));
        m_broken = true;
    }
    if (frame.live) {
        if (bodyLive && m_data.size() == frame.dataB.size())
            m_data = unify(m_data, frame.dataB);
        else
            m_data = frame.dataB;
        m_ret = frame.retB;
        m_unreachable = false;
    } else {
        m_unreachable = true;
    }
}

void Tracer::opDO(int line) {
    clearQdup();
    if (!skipEffects()) {
        const Cell indexCell = pop(QStringLiteral("index"));
        const Cell limit = pop(QStringLiteral("limit"));
        m_ret.append(limit);
        m_ret.append(indexCell);
    }
    Frame frame;
    frame.kind = FrameKind::DoLoop;
    frame.dataA = m_data;
    frame.retCount = m_ret.size();
    frame.live = !skipEffects();
    frame.line = line;
    m_frames.append(frame);
}

void Tracer::opLOOP(bool plus) {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::DoLoop) {
        note(QStringLiteral("LOOP without DO"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    if (plus && !skipEffects())
        pop(QStringLiteral("n"));
    QVector<QVector<Cell>> paths;
    if (!m_unreachable && !m_gaveUp) {
        if (m_data.size() != frame.dataA.size()) {
            note(QStringLiteral("LOOP body depth %1 does not match %2 after DO").arg(m_data.size()).arg(frame.dataA.size()));
            m_broken = true;
        }
        paths.append(m_data);
    }
    for (const QVector<Cell> &leave : frame.exits) {
        if (leave.size() != frame.dataA.size()) {
            note(QStringLiteral("LEAVE depth %1 does not match %2 after DO").arg(leave.size()).arg(frame.dataA.size()));
            m_broken = true;
        }
    }
    paths << frame.exits;
    if (paths.isEmpty()) {
        m_unreachable = true;
    } else {
        QVector<Cell> acc = paths.at(0);
        for (int i = 1; i < paths.size(); ++i) {
            if (paths.at(i).size() == acc.size())
                acc = unify(acc, paths.at(i));
        }
        m_data = acc;
        m_unreachable = false;
    }
    if (m_ret.size() >= 2) {
        m_ret.removeLast();
        m_ret.removeLast();
    }
}

void Tracer::opIndex(int depth) {
    clearQdup();
    if (skipEffects())
        return;
    const int fromTop = depth == 1 ? 1 : 3;
    if (m_ret.size() < fromTop) {
        note(depth == 1 ? QStringLiteral("I outside DO") : QStringLiteral("J outside a nested DO"));
        m_broken = true;
        push(fresh(QStringLiteral("n"), false, 0, false, 0));
        return;
    }
    push(m_ret.at(m_ret.size() - fromTop));
}

void Tracer::opLEAVE() {
    int slot = -1;
    for (int i = m_frames.size() - 1; i >= 0; --i) {
        if (m_frames.at(i).kind == FrameKind::DoLoop) {
            slot = i;
            break;
        }
    }
    if (slot < 0) {
        note(QStringLiteral("LEAVE outside DO"));
        m_broken = true;
        return;
    }
    if (!skipEffects())
        m_frames[slot].exits.append(m_data);
    m_unreachable = true;
}

void Tracer::opEXIT() {
    clearQdup();
    if (!skipEffects()) {
        if (!m_ret.isEmpty()) {
            note(QStringLiteral("EXIT with %1 item(s) on the return stack").arg(m_ret.size()));
            m_broken = true;
        }
        m_exits.append(m_data);
    }
    m_unreachable = true;
}

void Tracer::opQdup() {
    if (skipEffects())
        return;
    if (m_data.isEmpty())
        push(createInput(QStringLiteral("x"), false, 0));
    m_qdupBefore = m_data;
    m_hasQdup = true;
    push(m_data.last());
}

void Tracer::clearQdup() {
    if (!m_hasQdup)
        return;
    m_hasQdup = false;
    m_ambiguous = true;
    note(QStringLiteral("?DUP was not followed by IF. Nonzero path keeps the extra item; zero path does not"));
}

void Tracer::opPick() {
    clearQdup();
    if (skipEffects())
        return;
    if (m_data.isEmpty() || !m_data.last().hasLiteral || m_data.last().literal < 0) {
        giveUp(QStringLiteral("PICK count is not a literal"));
        return;
    }
    const int count = static_cast<int>(m_data.last().literal);
    pop(QStringLiteral("u"));
    deepen(count + 1);
    push(m_data.at(m_data.size() - 1 - count));
}

void Tracer::opRoll() {
    clearQdup();
    if (skipEffects())
        return;
    if (m_data.isEmpty() || !m_data.last().hasLiteral || m_data.last().literal < 0) {
        giveUp(QStringLiteral("ROLL count is not a literal"));
        return;
    }
    const int count = static_cast<int>(m_data.last().literal);
    pop(QStringLiteral("u"));
    if (count == 0)
        return;
    deepen(count + 1);
    const int slot = m_data.size() - 1 - count;
    const Cell cell = m_data.takeAt(slot);
    m_data.append(cell);
}

void Tracer::opCASE(int line) {
    clearQdup();
    if (!skipEffects() && m_data.isEmpty())
        push(createInput(QStringLiteral("x"), false, 0));
    Frame frame;
    frame.kind = FrameKind::CaseHead;
    frame.dataA = m_data;
    frame.live = !skipEffects();
    frame.line = line;
    m_frames.append(frame);
}

void Tracer::opOF(int line) {
    clearQdup();
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::CaseHead) {
        note(QStringLiteral("OF without CASE"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    if (skipEffects()) {
        Frame next;
        next.kind = FrameKind::OfBody;
        next.dataA = m_data;
        next.exits = frame.exits;
        next.live = false;
        next.line = line;
        m_frames.append(next);
        return;
    }
    pop(QStringLiteral("x"));
    const Cell selector = pop(QStringLiteral("x"));
    const QVector<Cell> trueStart = m_data;
    QVector<Cell> falseStack = m_data;
    falseStack.append(selector);
    Frame next;
    next.kind = FrameKind::OfBody;
    next.dataA = falseStack;
    next.exits = frame.exits;
    next.live = true;
    next.line = line;
    m_frames.append(next);
    m_data = trueStart;
}

void Tracer::opENDOF() {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::OfBody) {
        note(QStringLiteral("ENDOF without OF"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    QVector<QVector<Cell>> exits = frame.exits;
    if (!skipEffects())
        exits.append(m_data);
    m_data = frame.dataA;
    m_unreachable = false;
    Frame next;
    next.kind = FrameKind::CaseHead;
    next.dataA = m_data;
    next.exits = exits;
    next.live = true;
    next.line = frame.line;
    m_frames.append(next);
}

void Tracer::opENDCASE() {
    if (m_frames.isEmpty() || m_frames.last().kind != FrameKind::CaseHead) {
        note(QStringLiteral("ENDCASE without CASE"));
        m_broken = true;
        return;
    }
    const Frame frame = m_frames.takeLast();
    if (!skipEffects())
        pop(QStringLiteral("x"));
    QVector<QVector<Cell>> exits = frame.exits;
    if (!skipEffects())
        exits.append(m_data);
    if (exits.isEmpty()) {
        m_unreachable = true;
        return;
    }
    const int depth = exits.at(0).size();
    bool differ = false;
    for (const QVector<Cell> &stack : exits) {
        if (stack.size() != depth)
            differ = true;
    }
    if (differ) {
        note(QStringLiteral("CASE branches leave different stack depths"));
        m_broken = true;
        m_data = exits.at(0);
    } else {
        QVector<Cell> acc = exits.at(0);
        for (int i = 1; i < exits.size(); ++i)
            acc = unify(acc, exits.at(i));
        m_data = acc;
    }
    m_unreachable = false;
}

void Tracer::opLocalsBar() {
    clearQdup();
    QStringList names;
    while (m_index < m_body.size()) {
        const Token token = m_body.at(m_index);
        ++m_index;
        if (token.kind == TokenKind::Word && token.text == QLatin1String("|"))
            break;
        if (token.kind == TokenKind::Word)
            names.append(token.text);
    }
    for (const QString &name : names) {
        const Cell cell = skipEffects() ? fresh(name, false, 0, false, 0) : pop(name);
        m_locals.insert(name.toUpper(), cell);
    }
}

void Tracer::opBrace() {
    clearQdup();
    int phase = 0;
    QStringList args;
    QStringList vals;
    QStringList outs;
    while (m_index < m_body.size()) {
        const Token token = m_body.at(m_index);
        ++m_index;
        if (token.kind != TokenKind::Word)
            continue;
        if (token.text == QLatin1String(":}"))
            break;
        if (token.text == QLatin1String("|")) {
            phase = 1;
            continue;
        }
        if (token.text == QLatin1String("--")) {
            phase = 2;
            continue;
        }
        if (phase == 0)
            args.append(token.text);
        else if (phase == 1)
            vals.append(token.text);
        else
            outs.append(token.text);
    }
    if (!m_hasDeclared) {
        m_declared = QStringLiteral("( %1 -- %2 )").arg(args.join(QLatin1Char(' ')), outs.join(QLatin1Char(' ')));
        m_hasDeclared = true;
    }
    for (int i = args.size() - 1; i >= 0; --i) {
        const QString name = args.at(i);
        const Cell cell = skipEffects() ? fresh(name, false, 0, false, 0) : pop(name);
        m_locals.insert(name.toUpper(), cell);
    }
    for (const QString &name : vals)
        m_locals.insert(name.toUpper(), fresh(name, false, 0, false, 0));
}

void Tracer::opTO(bool plus) {
    clearQdup();
    const QString name = takeBodyName();
    if (name.isEmpty()) {
        note(QStringLiteral("TO without a name"));
        m_broken = true;
        return;
    }
    if (skipEffects())
        return;
    const Cell value = pop(plus ? QStringLiteral("n") : QStringLiteral("x"));
    const QString key = name.toUpper();
    if (m_locals.contains(key))
        m_locals.insert(key, plus ? fresh(QStringLiteral("n"), false, 0, false, 0) : value);
}

void Tracer::apply(const Pattern &pattern) {
    if (skipEffects())
        return;
    QHash<QString, QVector<Cell>> bound;
    for (int i = pattern.inputs.size() - 1; i >= 0; --i) {
        const Sym sym = pattern.inputs.at(i);
        const QVector<Cell> cells = popSym(sym);
        if (!bound.contains(sym.name))
            bound.insert(sym.name, cells);
    }
    for (const Sym &sym : pattern.outputs) {
        if (bound.contains(sym.name)) {
            for (const Cell &cell : bound.value(sym.name))
                push(cell);
        } else if (sym.wide) {
            pushWide(sym.name);
        } else {
            push(fresh(sym.name, false, 0, false, 0));
        }
    }
}

QVector<Cell> Tracer::popSym(const Sym &sym) {
    if (!sym.wide)
        return {pop(sym.name)};
    if (m_data.size() >= 2) {
        const Cell hi = m_data.takeLast();
        const Cell lo = m_data.takeLast();
        return {lo, hi};
    }
    const int pair = m_nextPair++;
    if (m_data.size() == 1) {
        Cell hi = m_data.takeLast();
        hi.hasPair = true;
        hi.pair = pair;
        return {createInput(sym.name, true, pair), hi};
    }
    return {createInput(sym.name, true, pair), createInput(sym.name, true, pair)};
}

void Tracer::pushWide(const QString &role) {
    const int pair = m_nextPair++;
    push(fresh(role, false, 0, true, pair));
    push(fresh(role, false, 0, true, pair));
}

Cell Tracer::pop(const QString &role) {
    if (!m_data.isEmpty())
        return m_data.takeLast();
    return createInput(role, false, 0);
}

Cell Tracer::createInput(const QString &role, bool paired, int pair) {
    Cell cell;
    cell.id = m_nextId++;
    cell.role = role;
    cell.hasPair = paired;
    cell.pair = pair;
    m_inputs.append(cell);
    for (Frame &frame : m_frames)
        frame.insertDataBottom(cell);
    if (!m_exits.isEmpty()) {
        for (QVector<Cell> &stack : m_exits)
            stack.prepend(cell);
    }
    return cell;
}

Cell Tracer::fresh(const QString &role, bool hasLiteral, qint64 literal, bool paired, int pair) {
    Cell cell;
    cell.id = m_nextId++;
    cell.role = role;
    cell.hasLiteral = hasLiteral;
    cell.literal = literal;
    cell.hasPair = paired;
    cell.pair = pair;
    return cell;
}

void Tracer::push(const Cell &cell) { m_data.append(cell); }

void Tracer::deepen(int depth) {
    while (m_data.size() < depth) {
        const Cell cell = createInput(QStringLiteral("x"), false, 0);
        m_data.prepend(cell);
    }
}

void Tracer::pushNumber(const ParsedNumber &number, const QString &spelling) {
    if (skipEffects())
        return;
    clearQdup();
    if (!number.isDouble) {
        push(fresh(spelling, number.hasLiteral, number.literal, false, 0));
        return;
    }
    const int pair = m_nextPair++;
    push(fresh(spelling, number.hasLiteral, number.literal, true, pair));
    push(fresh(spelling, false, 0, true, pair));
}

QVector<Cell> Tracer::unify(const QVector<Cell> &left, const QVector<Cell> &right) {
    QVector<Cell> out;
    const int n = qMin(left.size(), right.size());
    for (int i = 0; i < n; ++i) {
        const Cell &a = left.at(i);
        const Cell &b = right.at(i);
        if (a.id == b.id)
            out.append(a);
        else
            out.append(fresh(a.role == b.role ? a.role : QStringLiteral("x"), false, 0, false, 0));
    }
    return out;
}

QString Tracer::display(const Cell &cell, QHash<int, QString> &names, QSet<QString> &used) {
    if (names.contains(cell.id))
        return names.value(cell.id);
    QString name = cell.role.isEmpty() ? QStringLiteral("x") : cell.role;
    if (used.contains(name)) {
        int n = 2;
        while (used.contains(name + QString::number(n)))
            ++n;
        name += QString::number(n);
    }
    used.insert(name);
    names.insert(cell.id, name);
    return name;
}

QString Tracer::render(const QVector<Cell> &cells, QHash<int, QString> &names, QSet<QString> &used) {
    QStringList parts;
    int index = 0;
    while (index < cells.size()) {
        const Cell cell = cells.at(index);
        if (cell.hasPair && index + 1 < cells.size() && cells.at(index + 1).hasPair && cells.at(index + 1).pair == cell.pair) {
            const QString name = display(cell, names, used);
            names.insert(cells.at(index + 1).id, name);
            parts << name;
            index += 2;
            continue;
        }
        parts << display(cell, names, used);
        ++index;
    }
    return parts.join(QLatin1Char(' '));
}

QString Tracer::renderComment(const QVector<Cell> &inputs, const QVector<Cell> *outputs) {
    if (outputs == nullptr)
        return QString();
    QHash<int, QString> names;
    QSet<QString> used;
    QVector<Cell> reversed;
    for (int i = inputs.size() - 1; i >= 0; --i)
        reversed.append(inputs.at(i));
    const QString before = render(reversed, names, used);
    const QString after = render(*outputs, names, used);
    return formatComment(before, after);
}

Pattern Tracer::patternOf(const QVector<Cell> &inputs, const QVector<Cell> &outputs) {
    QHash<int, QString> names;
    QSet<QString> used;
    QVector<Cell> reversed;
    for (int i = inputs.size() - 1; i >= 0; --i)
        reversed.append(inputs.at(i));
    return Pattern{namedSyms(reversed, names, used), namedSyms(outputs, names, used)};
}

QVector<Sym> Tracer::namedSyms(const QVector<Cell> &cells, QHash<int, QString> &names, QSet<QString> &used) {
    QVector<Sym> syms;
    int index = 0;
    while (index < cells.size()) {
        const Cell cell = cells.at(index);
        if (cell.hasPair && index + 1 < cells.size() && cells.at(index + 1).hasPair && cells.at(index + 1).pair == cell.pair) {
            const QString name = display(cell, names, used);
            names.insert(cells.at(index + 1).id, name);
            syms.append(Sym{name, true});
            index += 2;
            continue;
        }
        syms.append(Sym{display(cell, names, used), false});
        ++index;
    }
    return syms;
}

QString Tracer::compareDeclared(const QString &declared, const QVector<Cell> &inputs, const QVector<Cell> &outputs) {
    bool ok = false;
    const Pattern pattern = parsePattern(declared, &ok);
    if (!ok)
        return QStringLiteral("declared comment is not ( before -- after )");
    QVector<Cell> ins;
    for (int i = inputs.size() - 1; i >= 0; --i)
        ins.append(inputs.at(i));
    auto count = [](const QVector<Sym> &syms) {
        int n = 0;
        for (const Sym &sym : syms)
            n += sym.wide ? 2 : 1;
        return n;
    };
    const int inN = count(pattern.inputs);
    const int outN = count(pattern.outputs);
    if (inN != ins.size() || outN != outputs.size())
        return QStringLiteral("depth %1 -- %2 vs declared %3 -- %4").arg(ins.size()).arg(outputs.size()).arg(inN).arg(outN);
    QHash<QString, QVector<QVector<Cell>>> groups;
    int cursor = 0;
    for (const Sym &sym : pattern.inputs) {
        const int n = sym.wide ? 2 : 1;
        groups[sym.name].append(ins.mid(cursor, n));
        cursor += n;
    }
    QVector<QPair<QString, QVector<Cell>>> produced;
    cursor = 0;
    for (const Sym &sym : pattern.outputs) {
        const int n = sym.wide ? 2 : 1;
        produced.append({sym.name, outputs.mid(cursor, n)});
        cursor += n;
    }
    QSet<int> inputIds;
    for (const Cell &cell : ins)
        inputIds.insert(cell.id);
    QHash<QString, int> usedGroup;
    QHash<QString, QVector<int>> seen;
    for (const auto &item : produced) {
        QVector<int> ids;
        for (const Cell &cell : item.second)
            ids.append(cell.id);
        if (seen.contains(item.first) && seen.value(item.first) != ids)
            return QStringLiteral("%1 is repeated but the items differ").arg(item.first);
        seen.insert(item.first, ids);
        if (groups.contains(item.first)) {
            const int k = usedGroup.value(item.first, 0);
            const QVector<QVector<Cell>> occurrences = groups.value(item.first);
            if (k < occurrences.size()) {
                usedGroup.insert(item.first, k + 1);
                QVector<int> expected;
                for (const Cell &cell : occurrences.at(k))
                    expected.append(cell.id);
                if (ids != expected) {
                    bool wrong = false;
                    for (int id : ids) {
                        if (inputIds.contains(id) && !expected.contains(id))
                            wrong = true;
                    }
                    if (wrong)
                        return QStringLiteral("%1 is not the item the trace keeps").arg(item.first);
                }
            }
        } else {
            for (int id : ids) {
                if (inputIds.contains(id))
                    return QStringLiteral("%1 is an existing stack item, not a new value").arg(item.first);
            }
        }
    }
    return QStringLiteral("matches");
}

ParsedNumber Tracer::parseNumber(const QString &token) const {
    ParsedNumber parsed;
    QString chars = token;
    if (chars.isEmpty())
        return parsed;
    bool isDouble = false;
    if (chars.endsWith(QLatin1Char('.'))) {
        isDouble = true;
        chars.chop(1);
        if (chars.isEmpty())
            return parsed;
    }
    bool negative = false;
    if (chars.startsWith(QLatin1Char('-'))) {
        negative = true;
        chars = chars.mid(1);
        if (chars.isEmpty())
            return parsed;
    }
    int radix = m_base;
    if (!chars.isEmpty() && (chars.at(0) == QLatin1Char('#') || chars.at(0) == QLatin1Char('$') || chars.at(0) == QLatin1Char('%'))) {
        radix = chars.at(0) == QLatin1Char('#') ? 10 : (chars.at(0) == QLatin1Char('$') ? 16 : 2);
        chars = chars.mid(1);
        if (chars.isEmpty())
            return parsed;
        if (!negative && chars.startsWith(QLatin1Char('-'))) {
            negative = true;
            chars = chars.mid(1);
        }
    }
    if (chars.isEmpty() || radix < 2 || radix > 36)
        return parsed;
    qint64 value = 0;
    bool overflow = false;
    int digits = 0;
    for (const QChar ch : chars) {
        const int digit = digitValue(ch);
        if (digit < 0 || digit >= radix)
            return parsed;
        ++digits;
        if (value > (std::numeric_limits<qint64>::max() / radix))
            overflow = true;
        else
            value *= radix;
        if (value > std::numeric_limits<qint64>::max() - digit)
            overflow = true;
        else
            value += digit;
    }
    if (digits == 0)
        return parsed;
    if (negative)
        value = -value;
    parsed.ok = true;
    parsed.isDouble = isDouble;
    parsed.hasLiteral = !overflow;
    parsed.literal = overflow ? 0 : value;
    return parsed;
}

bool Tracer::characterLiteral(const QString &token, int *value) const {
    if (token.size() != 3 || !token.startsWith(QLatin1Char('\'')) || !token.endsWith(QLatin1Char('\'')))
        return false;
    *value = token.at(1).unicode();
    return true;
}

bool Tracer::isFloatLiteral(const QString &token) const {
    static const QRegularExpression re(
        QStringLiteral("^-?([0-9]+\\.[0-9]*|\\.[0-9]+)([eE][+-]?[0-9]+)?$|^-?[0-9]+[eE][+-]?[0-9]+$"));
    return re.match(token).hasMatch();
}

QStringList fencedForth(const QString &source) {
    QStringList blocks;
    int rest = 0;
    while (true) {
        const int open = source.indexOf(QStringLiteral("```"), rest);
        if (open < 0)
            break;
        int after = open + 3;
        const int lineEnd = source.indexOf(QLatin1Char('\n'), after);
        const QString lang = (lineEnd < 0 ? source.mid(after) : source.mid(after, lineEnd - after)).trimmed().toLower();
        const int bodyStart = lineEnd < 0 ? source.size() : lineEnd + 1;
        const int close = source.indexOf(QStringLiteral("```"), bodyStart);
        if (close < 0)
            break;
        const QString code = source.mid(bodyStart, close - bodyStart);
        const bool forthTag = lang == QLatin1String("forth") || lang == QLatin1String("fth") || lang == QLatin1String("fs") ||
                              lang == QLatin1String("f");
        if (forthTag || (lang.isEmpty() && code.contains(QLatin1Char(':')) && code.contains(QLatin1Char(';'))))
            blocks << code;
        rest = close + 3;
    }
    return blocks;
}

QString forthText(const QString &source) {
    const QStringList fences = fencedForth(source);
    if (!fences.isEmpty())
        return fences.join(QLatin1Char('\n'));
    return source;
}

QString formatReport(const QVector<DefResult> &defs) {
    QStringList lines;
    lines << QStringLiteral(
        "Stack model — traced from an empty data stack. An underflow is an input. Copy a comment marked copy. "
        "Do not invent a different ( before -- after ). A line marked not inferred has no trustworthy comment.");
    int used = lines.at(0).size();
    bool truncated = false;
    for (const DefResult &def : defs) {
        const QString line = def.lineText();
        if (used + line.size() + 1 > 7000) {
            truncated = true;
            break;
        }
        lines << line;
        used += line.size() + 1;
    }
    if (truncated || defs.size() >= 50)
        lines << QStringLiteral("[further definitions were not traced]");
    return lines.join(QLatin1Char('\n'));
}

} // namespace

QString promptRule() {
    return QStringLiteral(
        "A deterministic stack model traces colon definitions from an empty data stack. An underflow is an input; "
        "the first missing item is TOS. When the user message contains a Stack model block, copy a comment marked "
        "copy. Do not invent a different ( before -- after ) for that definition. If the block says not inferred, "
        "say so instead of guessing a stack comment.");
}

QString report(const QString &source) {
    const QVector<DefResult> defs = Analyzer(forthText(source)).definitions(50);
    if (defs.isEmpty())
        return QString();
    return formatReport(defs);
}

QString toolResult(const QString &source) {
    const QString trimmed = source.trimmed();
    if (trimmed.isEmpty())
        return QStringLiteral("Pass a colon definition, or a fragment such as DUP + .");
    const QString direct = report(trimmed);
    if (!direct.isEmpty())
        return direct;
    return report(QStringLiteral(": FRAGMENT\n%1\n;").arg(trimmed));
}

QStringList selfCheckFailures() {
    QStringList fails;
    const auto check = [&](const QString &title, const QString &source, const QStringList &contains,
                           const QStringList &absent) {
        const QString text = report(source);
        if (text.isEmpty()) {
            fails << QStringLiteral("%1: no report").arg(title);
            return;
        }
        for (const QString &needle : contains) {
            if (!text.contains(needle))
                fails << QStringLiteral("%1: missing [%2]\n%3").arg(title, needle, text);
        }
        for (const QString &needle : absent) {
            if (text.contains(needle))
                fails << QStringLiteral("%1: unexpected [%2]\n%3").arg(title, needle, text);
        }
    };
    if (promptRule().contains(QStringLiteral("stack_effect")))
        fails << QStringLiteral("promptRule must not name the tool; tools may be off");
    if (!report(QStringLiteral("what does DUP do?")).isEmpty())
        fails << QStringLiteral("prose should not produce a report");
    if (!report(QStringLiteral("the word : starts a definition")).isEmpty())
        fails << QStringLiteral("unclosed colon should not produce a report");
    check(QStringLiteral("DUP"), QStringLiteral(": T DUP ;"), {QStringLiteral(": T ( x -- x x ) — copy")}, {});
    check(QStringLiteral("SWAP"), QStringLiteral(": T SWAP ;"), {QStringLiteral(": T ( x1 x2 -- x2 x1 ) — copy")}, {});
    check(QStringLiteral("OVER"), QStringLiteral(": T OVER ;"), {QStringLiteral(": T ( x1 x2 -- x1 x2 x1 ) — copy")}, {});
    check(QStringLiteral("ROT"), QStringLiteral(": T ROT ;"), {QStringLiteral(": T ( x1 x2 x3 -- x2 x3 x1 ) — copy")}, {});
    check(QStringLiteral("DROP"), QStringLiteral(": T DROP ;"), {QStringLiteral(": T ( x -- ) — copy")}, {});
    check(QStringLiteral("PLUS"), QStringLiteral(": T + ;"), {QStringLiteral(": T ( n1 n2 -- n3 ) — copy")}, {});
    check(QStringLiteral("DUP+"), QStringLiteral(": T DUP + ;"), {QStringLiteral(": T ( x -- n3 ) — copy")}, {});
    check(QStringLiteral("literals"), QStringLiteral(": T 10 0 ;"), {QStringLiteral(": T ( -- 10 0 ) — copy")}, {});
    check(QStringLiteral("do-literals"), QStringLiteral(": T 10 0 DO I . LOOP ;"), {QStringLiteral(": T ( -- ) — copy")}, {});
    check(QStringLiteral("do-inputs"), QStringLiteral(": T DO I . LOOP ;"), {QStringLiteral(": T ( limit index -- ) — copy")}, {});
    check(QStringLiteral("countdown"), QStringLiteral(": T BEGIN DUP WHILE 1- REPEAT DROP ;"),
          {QStringLiteral(": T ( x -- ) — copy")}, {});
    check(QStringLiteral("while-carry"), QStringLiteral(": STEP ( n -- n' ) BEGIN DUP 0= WHILE 1+ REPEAT ;"),
          {QStringLiteral(": STEP ( n -- n' ) — copy")}, {});
    check(QStringLiteral("s-quote"), QStringLiteral(": T S\" hi\" ;"), {QStringLiteral(": T ( -- c-addr u ) — copy")}, {});
    check(QStringLiteral("file-size"), QStringLiteral(": T FILE-SIZE ;"), {QStringLiteral(": T ( fileid -- ud ior ) — copy")}, {});
    check(QStringLiteral("match"), QStringLiteral(": T ( x1 x2 -- x2 x1 ) SWAP ;"),
          {QStringLiteral(": T ( x1 x2 -- x2 x1 ) — copy")}, {});
    check(QStringLiteral("mismatch"), QStringLiteral(": T ( x1 x2 -- x1 x2 ) SWAP ;"),
          {QStringLiteral("( x1 x2 -- x2 x1 ) — copy"), QStringLiteral("does not match")}, {});
    check(QStringLiteral("one-plus"), QStringLiteral(": T ( n -- n ) 1+ ;"), {QStringLiteral(": T ( n -- n ) — copy")}, {});
    check(QStringLiteral("unknown"), QStringLiteral(": T ZORCH ;"), {QStringLiteral("not inferred"), QStringLiteral("ZORCH")},
          {QStringLiteral("— copy")});
    check(QStringLiteral("unbalanced-if"), QStringLiteral(": T IF DROP THEN ;"), {QStringLiteral("not inferred")},
          {QStringLiteral("— copy")});
    check(QStringLiteral("if-else"), QStringLiteral(": T IF 1 ELSE 2 THEN ;"), {QStringLiteral("( flag -- ")}, {});
    check(QStringLiteral("qdup-if"), QStringLiteral(": T ?DUP IF DROP THEN ;"), {QStringLiteral(": T ( x -- ) — copy")}, {});
    check(QStringLiteral("qdup-open"), QStringLiteral(": T ?DUP ;"), {QStringLiteral("not a single effect")},
          {QStringLiteral("— copy")});
    check(QStringLiteral("exit-flag"), QStringLiteral(": T IF EXIT THEN ;"), {QStringLiteral(": T ( flag -- ) — copy")}, {});
    check(QStringLiteral("exit-drop"), QStringLiteral(": T IF EXIT THEN DROP ;"), {QStringLiteral("not inferred")},
          {QStringLiteral("— copy")});
    check(QStringLiteral("no-2plus"), QStringLiteral(": T 2+ ;"), {QStringLiteral("not inferred"), QStringLiteral("2+")},
          {QStringLiteral("— copy")});
    check(QStringLiteral("rstack"), QStringLiteral(": T >R ;"), {QStringLiteral("not inferred"), QStringLiteral("return stack")},
          {QStringLiteral("— copy")});
    check(QStringLiteral("r-roundtrip"), QStringLiteral(": T >R R> ;"), {QStringLiteral(": T ( x -- x ) — copy")}, {});
    check(QStringLiteral("xunit"), QStringLiteral(": XUNIT [ 1 XBITS LSHIFT ] LITERAL ;"),
          {QStringLiteral(": XUNIT ( -- x ) — copy")}, {});
    check(QStringLiteral("locals-bar"), QStringLiteral(": LO-A LOCALS| x | x ;"), {QStringLiteral(": LO-A ( x -- x ) — copy")},
          {});
    check(QStringLiteral("locals-mul"), QStringLiteral(": LO-H LOCALS| x y | x y * ;"),
          {QStringLiteral(": LO-H ( y x -- n3 ) — copy")}, {});
    check(QStringLiteral("brace-add"), QStringLiteral(": LO-C {: a b -- n :} a b + ;"),
          {QStringLiteral(": LO-C ( a b -- n ) — copy")}, {});
    check(QStringLiteral("brace-tos"), QStringLiteral(": LO-D {: a b -- n :} b ;"),
          {QStringLiteral("( a b -- b ) — copy"), QStringLiteral("does not match")}, {});
    check(QStringLiteral("call"), QStringLiteral(": DOUBLE DUP + ;\n: QUAD DOUBLE DOUBLE ;"),
          {QStringLiteral(": DOUBLE ( x -- n3 ) — copy"), QStringLiteral(": QUAD ( x -- n3 ) — copy")}, {});
    check(QStringLiteral("case"), QStringLiteral(": T CASE 1 OF 10 ENDOF 2 OF 20 ENDOF DUP ENDCASE ;"),
          {QStringLiteral("( x -- ")}, {});
    const QString swap = toolResult(QStringLiteral("SWAP"));
    if (!swap.contains(QStringLiteral("( x1 x2 -- x2 x1 )")))
        fails << QStringLiteral("tool SWAP:\n%1").arg(swap);
    return fails;
}

} // namespace ForthStackEffect
