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

static void print_eng(double v)
{
    char buf[128];
    int exp10;
    int eng;
    int digits;
    double mant;

    if (!isfinite(v) || v == 0.0) {
        snprintf(buf, sizeof buf, "%.*g ", fprec, v);
        host_outs(buf);
        return;
    }
    exp10 = (int)floor(log10(fabs(v)));
    eng = (exp10 / 3) * 3;
    if (exp10 < 0 && exp10 % 3 != 0)
        eng -= 3;
    mant = v / pow(10.0, (double)eng);
    digits = fprec > 1 ? fprec - 1 : 0;
    if (digits > 16)
        digits = 16;
    snprintf(buf, sizeof buf, "%.*fE%d ", digits, mant, eng);
    host_outs(buf);
}

static int parse_float(const char *s, long long n, double *out)
{
    char buf[256];
    char *end;
    long long i;
    double v;

    if (s == NULL || n <= 0 || out == NULL)
        return 0;
    while (n > 0 && (*s == ' ' || *s == '\t')) {
        s++;
        n--;
    }
    while (n > 0 && (s[n - 1] == ' ' || s[n - 1] == '\t'))
        n--;
    if (n <= 0 || n >= (long long)sizeof buf)
        return 0;
    memcpy(buf, s, (size_t)n);
    buf[n] = '\0';
    for (i = 0; i < n; i++) {
        if (buf[i] == 'd' || buf[i] == 'D')
            buf[i] = 'e';
    }
    v = strtod(buf, &end);
    if (end == buf || *end != '\0')
        return 0;
    *out = v;
    return 1;
}

/* ANS REPRESENT: u digits of the significand, n such that
   |r| is about 0.digits * 10^n. */
static void represent(double r, char *dst, long long u, long long *nexp,
                      long long *sign, long long *exact)
{
    char tmp[64];
    char digits[40];
    int nd = 0;
    int expv = 0;
    int i;
    double a;

    if (sign != NULL)
        *sign = signbit(r) ? -1 : 0;
    if (exact != NULL)
        *exact = isfinite(r) ? -1 : 0;
    if (nexp != NULL)
        *nexp = 0;
    if (dst == NULL || u <= 0)
        return;
    if (!isfinite(r) || r == 0.0) {
        for (i = 0; i < u; i++)
            dst[i] = '0';
        return;
    }
    a = fabs(r);
    snprintf(tmp, sizeof tmp, "%.16e", a);
    for (i = 0; tmp[i] != '\0' && nd < (int)sizeof digits; i++) {
        if (tmp[i] == 'e' || tmp[i] == 'E') {
            expv = atoi(tmp + i + 1);
            break;
        }
        if (tmp[i] >= '0' && tmp[i] <= '9')
            digits[nd++] = tmp[i];
    }
    if (nd == 0)
        digits[nd++] = '0';
    if (nexp != NULL)
        *nexp = (long long)expv + 1;
    for (i = 0; i < u; i++)
        dst[i] = (i < nd) ? digits[i] : '0';
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
    char text[128];

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
        if (parse_float((const char *)ptr, b, &r1)) {
            fpush(r1);
            o1 = -1;
        }
        break;
    case 33:
        snprintf(text, sizeof text, "%.*g ", fprec, fpop());
        host_outs(text);
        break;
    case 34:
        snprintf(text, sizeof text, "%.*e ", fprec > 0 ? fprec - 1 : 0, fpop());
        host_outs(text);
        break;
    case 35:
        print_eng(fpop());
        break;
    case 36:
        o1 = fprec;
        break;
    case 37:
        if (a < 1)
            a = 1;
        if (a > 17)
            a = 17;
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
