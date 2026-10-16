/* Public domain.
   IEEE-754 binary64 stack behind (F-OP) and FLIT.
   Opcode numbers are the ones kernel2.fth passes to (F-OP).
   A true flag is all bits set. The stack holds 16 values. */

#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void host_outs(const char *s);

#define FSTACK_N 16

static double fstack[FSTACK_N];
static int fdepth;
static int fprec = 6;

static void fpush(double v)
{
    if (fdepth >= FSTACK_N)
        return;
    fstack[fdepth++] = v;
}

static double fpop(void)
{
    if (fdepth <= 0)
        return 0.0;
    return fstack[--fdepth];
}

static double bits_to_d(long long bits)
{
    double d;
    uint64_t u = (uint64_t)bits;

    memcpy(&d, &u, sizeof d);
    return d;
}

static long long d_to_bits(double d)
{
    uint64_t u;

    memcpy(&u, &d, sizeof u);
    return (long long)u;
}

static long long flag(int cond)
{
    return cond ? -1 : 0;
}

static double load8(const void *p)
{
    double d = 0.0;

    if (p != NULL)
        memcpy(&d, p, 8);
    return d;
}

static void store8(void *p, double d)
{
    if (p != NULL)
        memcpy(p, &d, 8);
}

static double load4(const void *p)
{
    float f = 0.0f;

    if (p != NULL)
        memcpy(&f, p, 4);
    return (double)f;
}

static void store4(void *p, double d)
{
    float f;

    if (p == NULL)
        return;
    f = (float)d;
    memcpy(p, &f, 4);
}

/* Toward zero, saturated to a signed cell. */
static long long i64_from_f(double v)
{
    if (!isfinite(v))
        return v < 0.0 ? INT64_MIN : INT64_MAX;
    if (v >= 9223372036854775808.0)
        return INT64_MAX;
    if (v <= (double)INT64_MIN)
        return INT64_MIN;
    return (long long)v;
}

static long long align_up(long long addr, long long n)
{
    unsigned long long u = (unsigned long long)addr;
    unsigned long long m = (unsigned long long)n - 1ull;

    return (long long)((u + m) & ~m);
}

static int is_ws(unsigned char c)
{
    return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\v' || c == '\f';
}

static void app_ch(char *d, int *n, int cap, char c)
{
    if (*n < cap - 1)
        d[(*n)++] = c;
}

static void app_repeat(char *d, int *n, int cap, char c, int count)
{
    while (count-- > 0)
        app_ch(d, n, cap, c);
}

static void app_cstr(char *d, int *n, int cap, const char *s)
{
    while (*s != '\0')
        app_ch(d, n, cap, *s++);
}

/* ANS >FLOAT. Empty or all-whitespace is 0. Any other whitespace fails.
   A bare + or - with digits is an exponent (1+1, 1-1). Finish with strtod
   so 1-1 matches the literal 0.1E. */
static int parse_greater(const char *s, long long n, double *out)
{
    char buf[256];
    char *end;
    long long i;
    int o = 0;
    int has_digit = 0;
    int any_exp = 0;
    int exp_sign = 1;
    double v;

    if (out == NULL)
        return 0;
    if (n < 0)
        return 0;
    if (n == 0) {
        *out = 0.0;
        return 1;
    }
    if (s == NULL || n >= (long long)sizeof buf - 8)
        return 0;
    for (i = 0; i < n; i++) {
        if (!is_ws((unsigned char)s[i]))
            break;
    }
    if (i == n) {
        *out = 0.0;
        return 1;
    }
    for (i = 0; i < n; i++) {
        if (is_ws((unsigned char)s[i]))
            return 0;
    }
    i = 0;
    if (s[0] == '+' || s[0] == '-') {
        if (s[0] == '-')
            buf[o++] = '-';
        i++;
    }
    if (i >= n)
        return 0;
    while (i < n && s[i] >= '0' && s[i] <= '9') {
        has_digit = 1;
        buf[o++] = s[i++];
    }
    if (i < n && s[i] == '.') {
        buf[o++] = '.';
        i++;
        while (i < n && s[i] >= '0' && s[i] <= '9') {
            has_digit = 1;
            buf[o++] = s[i++];
        }
    }
    if (!has_digit)
        return 0;
    if (i < n) {
        char marker = s[i];

        if (marker == 'e' || marker == 'E' || marker == 'd' || marker == 'D') {
            i++;
            if (i < n && (s[i] == '+' || s[i] == '-')) {
                if (s[i] == '-')
                    exp_sign = -1;
                i++;
            }
        } else if (marker == '+' || marker == '-') {
            if (marker == '-')
                exp_sign = -1;
            i++;
            if (i >= n || s[i] < '0' || s[i] > '9')
                return 0;
        } else {
            return 0;
        }
        buf[o++] = 'e';
        if (exp_sign < 0)
            buf[o++] = '-';
        while (i < n && s[i] >= '0' && s[i] <= '9') {
            any_exp = 1;
            buf[o++] = s[i++];
        }
        if (!any_exp)
            buf[o++] = '0';
    }
    if (i != n)
        return 0;
    buf[o] = '\0';
    v = strtod(buf, &end);
    if (end == buf || *end != '\0')
        return 0;
    *out = v;
    return 1;
}

typedef struct {
    int k;
    int sign;
    int valid;
    int n;
    char digits[40];
} FRep;

static void fm_mod(int d, int divisor, int *rem, int *quot)
{
    int q;
    int r;

    if (divisor == 0) {
        *rem = 0;
        *quot = 0;
        return;
    }
    q = d / divisor;
    r = d % divisor;
    if (((d ^ divisor) < 0) && r != 0) {
        q -= 1;
        r += divisor;
    }
    *rem = r;
    *quot = q;
}

static int round_lead(const char *digits, int nd, int keep, char *out)
{
    int i;

    if (keep <= 0 || nd <= 0)
        return 0;
    if (keep > nd)
        keep = nd;
    for (i = 0; i < keep; i++)
        out[i] = digits[i];
    if (nd > keep && digits[keep] >= '5') {
        for (i = keep - 1; i >= 0; i--) {
            if (out[i] != '9') {
                out[i] = (char)(out[i] + 1);
                return keep;
            }
            out[i] = '0';
        }
        out[0] = '1';
        for (i = 1; i <= keep; i++)
            out[i] = '0';
        return keep + 1;
    }
    return keep;
}

/* u significant digits, implied point at the left. k is the exponent. */
static void rep_fill(double value, int u, char *dst, FRep *rep)
{
    int width;
    int i;
    double absv;
    double scale;
    double sig;
    double upper;
    char tmp[64];

    if (u < 1)
        u = 1;
    if (u > 32)
        u = 32;
    width = u;
    rep->k = 0;
    rep->sign = 0;
    rep->valid = 0;
    rep->n = width;
    for (i = 0; i < width; i++)
        rep->digits[i] = '0';
    rep->digits[width] = '\0';
    if (dst != NULL) {
        for (i = 0; i < width; i++)
            dst[i] = '0';
    }
    if (!isfinite(value))
        return;
    rep->valid = -1;
    if (value < 0.0)
        rep->sign = -1;
    if (value == 0.0)
        return;
    absv = fabs(value);
    rep->k = (int)floor(log10(absv)) + 1;
    scale = pow(10.0, (double)(width - rep->k));
    sig = round(absv * scale);
    upper = pow(10.0, (double)width);
    if (!isfinite(sig)) {
        rep->k = 0;
        return;
    }
    if (sig >= upper) {
        sig /= 10.0;
        rep->k += 1;
    } else if (sig > 0.0 && sig < upper / 10.0) {
        sig *= 10.0;
        rep->k -= 1;
    }
    snprintf(tmp, sizeof tmp, "%0*.0f", width, sig);
    for (i = 0; i < width; i++) {
        char c = (tmp[i] >= '0' && tmp[i] <= '9') ? tmp[i] : '0';

        rep->digits[i] = c;
        if (dst != NULL)
            dst[i] = c;
    }
    rep->digits[width] = '\0';
}

static void fmt_special(double v, char *out)
{
    if (isnan(v)) {
        memcpy(out, "NaN ", 5);
        return;
    }
    if (signbit(v))
        memcpy(out, "-Infinity ", 11);
    else
        memcpy(out, "Infinity ", 10);
}

static void fmt_output(double v, char *out)
{
    FRep rep;
    char lead[40];
    int n = 0;
    int prec;
    int ln;
    int i;
    const int cap = 128;

    if (!isfinite(v)) {
        fmt_special(v, out);
        return;
    }
    prec = fprec < 1 ? 1 : fprec;
    rep_fill(v, prec, NULL, &rep);
    if (rep.sign)
        app_ch(out, &n, cap, '-');
    if (rep.k <= 0) {
        app_cstr(out, &n, cap, "0.");
        if (rep.k < 0)
            app_repeat(out, &n, cap, '0', -rep.k);
        ln = round_lead(rep.digits, rep.n, prec + rep.k, lead);
        for (i = 0; i < ln; i++)
            app_ch(out, &n, cap, lead[i]);
    } else {
        int leadn = rep.k < prec ? rep.k : prec;

        for (i = 0; i < leadn && i < rep.n; i++)
            app_ch(out, &n, cap, rep.digits[i]);
        app_ch(out, &n, cap, '.');
        if (rep.k < prec) {
            int end = rep.n;

            while (end > rep.k && rep.digits[end - 1] == '0')
                end--;
            for (i = rep.k; i < end; i++)
                app_ch(out, &n, cap, rep.digits[i]);
        }
    }
    app_ch(out, &n, cap, ' ');
    out[n] = '\0';
}

static void fmt_scientific(double v, char *out)
{
    FRep rep;
    char expb[16];
    int n = 0;
    int prec;
    int i;
    const int cap = 128;

    if (!isfinite(v)) {
        fmt_special(v, out);
        return;
    }
    prec = fprec < 1 ? 1 : fprec;
    rep_fill(v, prec, NULL, &rep);
    if (rep.sign)
        app_ch(out, &n, cap, '-');
    if (rep.n > 0)
        app_ch(out, &n, cap, rep.digits[0]);
    app_ch(out, &n, cap, '.');
    for (i = 1; i < rep.n; i++)
        app_ch(out, &n, cap, rep.digits[i]);
    snprintf(expb, sizeof expb, "E%d", rep.k - 1);
    app_cstr(out, &n, cap, expb);
    app_ch(out, &n, cap, ' ');
    out[n] = '\0';
}

static void fmt_engineering(double v, char *out)
{
    FRep rep;
    char expb[16];
    int n = 0;
    int prec;
    int expn;
    int rem;
    int quot;
    int lead;
    int typec;
    int i;
    const int cap = 128;

    if (!isfinite(v)) {
        fmt_special(v, out);
        return;
    }
    prec = fprec < 1 ? 1 : fprec;
    rep_fill(v, prec, NULL, &rep);
    expn = rep.k - 1;
    fm_mod(expn, 3, &rem, &quot);
    lead = rem + 1;
    if (rep.sign)
        app_ch(out, &n, cap, '-');
    typec = lead < prec ? lead : prec;
    if (lead > 0) {
        for (i = 0; i < typec && i < rep.n; i++)
            app_ch(out, &n, cap, rep.digits[i]);
    } else {
        app_ch(out, &n, cap, '0');
    }
    if (lead > typec)
        app_repeat(out, &n, cap, '0', lead - typec);
    app_ch(out, &n, cap, '.');
    if (lead < prec) {
        for (i = lead > 0 ? lead : 0; i < rep.n; i++)
            app_ch(out, &n, cap, rep.digits[i]);
    }
    snprintf(expb, sizeof expb, "E%d", quot * 3);
    app_cstr(out, &n, cap, expb);
    app_ch(out, &n, cap, ' ');
    out[n] = '\0';
}

static void represent(double r, char *dst, long long u, long long *nexp,
                      long long *sign, long long *exact)
{
    FRep rep;
    int width;

    width = (int)u;
    if (width < 1)
        width = 1;
    rep_fill(r, width, dst, &rep);
    if (nexp != NULL)
        *nexp = rep.k;
    if (sign != NULL)
        *sign = rep.sign;
    if (exact != NULL)
        *exact = rep.valid;
}

static int looks_like_float(const char *s)
{
    size_t n;
    size_t i;
    int dots = 0;
    int has_e = 0;
    const char *q;

    if (s == NULL || s[0] == '\0')
        return 0;
    n = strlen(s);
    for (i = 0; i < n; i++) {
        char c = s[i];
        if (c == 'e' || c == 'E')
            has_e = 1;
        if (c == '.')
            dots++;
    }
    if (has_e)
        return 1;
    if (dots != 0) {
        if (s[n - 1] == '.' && dots == 1) {
            q = s;
            if (*q == '+' || *q == '-')
                q++;
            if (q >= s + n - 1)
                return 0;
            for (; q < s + n - 1; q++) {
                if (*q < '0' || *q > '9')
                    return 1;
            }
            return 0;
        }
        return 1;
    }
    if (s[n - 1] == 'd' || s[n - 1] == 'D') {
        q = s;
        if (*q == '+' || *q == '-')
            q++;
        if (q >= s + n - 1)
            return 0;
        for (; q < s + n - 1; q++) {
            if ((*q < '0' || *q > '9') && *q != '+' && *q != '-' && *q != '.')
                return 0;
        }
        return 1;
    }
    return 0;
}

/* Interpreter literal. looks_like_float keeps HEX 1E and trailing-dot
   doubles on the integer path. strtod rounds the long digit strings. */
static int parse_text_float(const char *s, double *out)
{
    char buf[512];
    char *end;
    size_t n;
    size_t i;
    double v;

    if (s == NULL || out == NULL || !looks_like_float(s))
        return 0;
    while (*s == ' ' || *s == '\t')
        s++;
    n = strlen(s);
    while (n > 0 && (s[n - 1] == ' ' || s[n - 1] == '\t'))
        n--;
    if (n == 0 || n >= sizeof buf - 2)
        return 0;
    if (s[0] == '+') {
        s++;
        n--;
    }
    if (n == 0 || n >= sizeof buf - 2)
        return 0;
    memcpy(buf, s, n);
    buf[n] = '\0';
    if (buf[n - 1] == 'D' || buf[n - 1] == 'd') {
        buf[n - 1] = 'e';
        buf[n] = '0';
        buf[n + 1] = '\0';
        n++;
    } else if (buf[n - 1] == 'E' || buf[n - 1] == 'e') {
        buf[n] = '0';
        buf[n + 1] = '\0';
        n++;
    }
    for (i = 0; i < n; i++) {
        if (buf[i] == 'D' || buf[i] == 'd')
            buf[i] = 'e';
    }
    v = strtod(buf, &end);
    if (end == buf || *end != '\0')
        return 0;
    *out = v;
    return 1;
}

long long host_float_op(long long op, long long a, long long b, long long c, long long d,
                        void *ptr, long long *out)
{
    double r1;
    double r2;
    double r3;
    long long o1 = 0;
    long long o2 = 0;
    long long o3 = 0;
    char text[512];

    (void)c;
    (void)d;
    switch (op) {
    case 1:
        o1 = fdepth;
        break;
    case 2:
        (void)fpop();
        break;
    case 3:
        r1 = fpop();
        fpush(r1);
        fpush(r1);
        break;
    case 4:
        r2 = fpop();
        r1 = fpop();
        fpush(r2);
        fpush(r1);
        break;
    case 5:
        r2 = fpop();
        r1 = fpop();
        fpush(r1);
        fpush(r2);
        fpush(r1);
        break;
    case 6:
        r3 = fpop();
        r2 = fpop();
        r1 = fpop();
        fpush(r2);
        fpush(r3);
        fpush(r1);
        break;
    case 7:
        r2 = fpop();
        r1 = fpop();
        fpush(r1 + r2);
        break;
    case 8:
        r2 = fpop();
        r1 = fpop();
        fpush(r1 - r2);
        break;
    case 9:
        r2 = fpop();
        r1 = fpop();
        fpush(r1 * r2);
        break;
    case 10:
        r2 = fpop();
        r1 = fpop();
        fpush(r1 / r2);
        break;
    case 11:
        fpush(-fpop());
        break;
    case 12:
        fpush(fabs(fpop()));
        break;
    case 13:
        r2 = fpop();
        r1 = fpop();
        fpush(fmax(r1, r2));
        break;
    case 14:
        r2 = fpop();
        r1 = fpop();
        fpush(fmin(r1, r2));
        break;
    case 15:
        o1 = flag(fpop() == 0.0);
        break;
    case 16:
        o1 = flag(fpop() < 0.0);
        break;
    case 17:
        r2 = fpop();
        r1 = fpop();
        o1 = flag(r1 < r2);
        break;
    case 18:
        r2 = fpop();
        r1 = fpop();
        o1 = flag(r1 > r2);
        break;
    case 19:
        r2 = fpop();
        r1 = fpop();
        o1 = flag(r1 == r2);
        break;
    case 20:
        r2 = fpop();
        r1 = fpop();
        o1 = flag(r1 != r2);
        break;
    case 21:
        r3 = fpop();
        r2 = fpop();
        r1 = fpop();
        if (r3 > 0.0)
            o1 = flag(fabs(r1 - r2) < r3);
        else if (r3 == 0.0)
            o1 = flag(d_to_bits(r1) == d_to_bits(r2));
        else
            o1 = flag(fabs(r1 - r2) < fabs(r3) * (fabs(r1) + fabs(r2)));
        break;
    case 22:
    case 26:
        fpush(load8((void *)(uintptr_t)a));
        break;
    case 23:
    case 27:
        store8((void *)(uintptr_t)a, fpop());
        break;
    case 24:
        fpush(load4((void *)(uintptr_t)a));
        break;
    case 25:
        store4((void *)(uintptr_t)a, fpop());
        break;
    case 28:
        fpush((double)a);
        break;
    case 29:
        o1 = i64_from_f(fpop());
        break;
    case 30:
        if (b == 0 || b == -1)
            fpush((double)a);
        else
            fpush(ldexp((double)b, 64) + (double)(uint64_t)a);
        break;
    case 31:
        r1 = fpop();
        o1 = i64_from_f(r1);
        o2 = (r1 < 0.0) ? -1 : 0;
        break;
    case 32:
        if (parse_greater((const char *)ptr, b, &r1)) {
            fpush(r1);
            o1 = -1;
        }
        break;
    case 33:
        fmt_output(fpop(), text);
        host_outs(text);
        break;
    case 34:
        fmt_scientific(fpop(), text);
        host_outs(text);
        break;
    case 35:
        fmt_engineering(fpop(), text);
        host_outs(text);
        break;
    case 36:
        o1 = fprec;
        break;
    case 37:
        if (a < 1)
            a = 1;
        if (a > 32)
            a = 32;
        fprec = (int)a;
        break;
    case 38:
        represent(fpop(), (char *)ptr, b, &o1, &o2, &o3);
        break;
    case 39:
    case 43:
        o1 = a * 8;
        break;
    case 40:
    case 44:
        o1 = a + 8;
        break;
    case 41:
        o1 = a * 4;
        break;
    case 42:
        o1 = a + 4;
        break;
    case 45:
        fpush(sqrt(fpop()));
        break;
    case 46:
        r2 = fpop();
        r1 = fpop();
        fpush(pow(r1, r2));
        break;
    case 47:
        fpush(exp(fpop()));
        break;
    case 48:
        fpush(expm1(fpop()));
        break;
    case 49:
        fpush(log(fpop()));
        break;
    case 50:
        fpush(log1p(fpop()));
        break;
    case 51:
        fpush(log10(fpop()));
        break;
    case 52:
        fpush(pow(10.0, fpop()));
        break;
    case 53:
        fpush(sin(fpop()));
        break;
    case 54:
        fpush(cos(fpop()));
        break;
    case 55:
        fpush(tan(fpop()));
        break;
    case 56:
        fpush(asin(fpop()));
        break;
    case 57:
        fpush(acos(fpop()));
        break;
    case 58:
        fpush(atan(fpop()));
        break;
    case 59:
        r2 = fpop();
        r1 = fpop();
        fpush(atan2(r1, r2));
        break;
    case 60:
        r1 = fpop();
        fpush(sin(r1));
        fpush(cos(r1));
        break;
    case 61:
        fpush(sinh(fpop()));
        break;
    case 62:
        fpush(cosh(fpop()));
        break;
    case 63:
        fpush(tanh(fpop()));
        break;
    case 64:
        fpush(asinh(fpop()));
        break;
    case 65:
        fpush(acosh(fpop()));
        break;
    case 66:
        fpush(atanh(fpop()));
        break;
    case 67:
        fpush(floor(fpop()));
        break;
    case 68:
        fpush(round(fpop()));
        break;
    case 69:
        r2 = fpop();
        r1 = fpop();
        if (r2 == 0.0)
            fpush(0.0);
        else
            fpush(r1 - r2 * floor(r1 / r2));
        break;
    case 70:
    case 72:
    case 73:
    case 75:
        o1 = align_up(a, 8);
        break;
    case 71:
    case 74:
        o1 = align_up(a, 4);
        break;
    case 100: {
        size_t u = (size_t)b;
        double v;

        if (ptr == NULL || b <= 0 || u >= sizeof text) {
            o1 = 0;
            break;
        }
        memcpy(text, ptr, u);
        text[u] = '\0';
        if (!parse_text_float(text, &v)) {
            o1 = 0;
            break;
        }
        o1 = 1;
        o2 = d_to_bits(v);
        break;
    }
    case 101:
        fpush(bits_to_d(a));
        break;
    case 102:
        o1 = d_to_bits(fpop());
        break;
    default:
        break;
    }
    if (out != NULL) {
        out[0] = o1;
        out[1] = o2;
        out[2] = o3;
    }
    return 0;
}
