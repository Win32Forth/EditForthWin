/* Public domain. Host multiprecision for BI-MUL, BI-DIVMOD, and BI-ISQRT.
   Layout matches Library/BigInteger/big-int.fth: base 10^9 limbs.
   cell 0 capacity, cell 1 length, cell 2 sign, cell 3+ little-endian limbs. */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

void host_outs(const char *s);

#define BI_BASE 1000000000LL

typedef struct {
    int64_t *v;
    int n;
    int cap;
} BiLimbs;

static int bi_overflows;

static int bi_reserve(BiLimbs *a, int n)
{
    int c;
    int64_t *p;

    if (n <= a->cap)
        return 1;
    c = a->cap < 8 ? 8 : a->cap;
    while (c < n) {
        if (c > 1000000)
            return 0;
        c *= 2;
    }
    p = (int64_t *)realloc(a->v, (size_t)c * sizeof(int64_t));
    if (p == NULL)
        return 0;
    a->v = p;
    a->cap = c;
    return 1;
}

static void bi_clear(BiLimbs *a)
{
    a->n = 0;
}

static void bi_free(BiLimbs *a)
{
    free(a->v);
    a->v = NULL;
    a->n = 0;
    a->cap = 0;
}

static void bi_trim(BiLimbs *a)
{
    while (a->n > 0 && a->v[a->n - 1] == 0)
        a->n--;
}

static int bi_push(BiLimbs *a, int64_t x)
{
    if (!bi_reserve(a, a->n + 1))
        return 0;
    a->v[a->n++] = x;
    return 1;
}

static int bi_copy(BiLimbs *dst, const BiLimbs *src)
{
    if (!bi_reserve(dst, src->n))
        return 0;
    if (src->n > 0)
        memcpy(dst->v, src->v, (size_t)src->n * sizeof(int64_t));
    dst->n = src->n;
    return 1;
}

static int bi_eq(const BiLimbs *a, const BiLimbs *b)
{
    if (a->n != b->n)
        return 0;
    for (int i = 0; i < a->n; i++) {
        if (a->v[i] != b->v[i])
            return 0;
    }
    return 1;
}

static int bi_cmp(const BiLimbs *a, const BiLimbs *b)
{
    if (a->n != b->n)
        return a->n < b->n ? -1 : 1;
    for (int i = a->n - 1; i >= 0; i--) {
        if (a->v[i] != b->v[i])
            return a->v[i] < b->v[i] ? -1 : 1;
    }
    return 0;
}

static int bi_read(const int64_t *bi, BiLimbs *out, int *sign)
{
    int cap;
    int n;

    bi_clear(out);
    *sign = 1;
    if (bi == NULL)
        return 1;
    cap = (int)bi[0];
    if (cap < 0)
        cap = 0;
    n = (int)bi[1];
    if (n < 0)
        n = 0;
    if (n > cap)
        n = cap;
    for (int i = 0; i < n; i++) {
        if (!bi_push(out, bi[3 + i]))
            return 0;
    }
    bi_trim(out);
    *sign = out->n == 0 ? 1 : (bi[2] < 0 ? -1 : 1);
    return 1;
}

static void bi_fail_cap(int need, int cap)
{
    char msg[96];

    bi_overflows++;
    snprintf(msg, sizeof msg,
             "BigIntHost: BI capacity exceeded (need %d limbs, cap %d)\n",
             need, cap);
    host_outs(msg);
}

static void bi_write(int64_t *bi, int sign, const BiLimbs *limbs)
{
    BiLimbs tmp;

    if (bi == NULL)
        return;
    memset(&tmp, 0, sizeof tmp);
    if (!bi_copy(&tmp, limbs)) {
        bi_free(&tmp);
        bi_fail_cap(limbs->n, (int)bi[0]);
        return;
    }
    bi_trim(&tmp);
    if (tmp.n == 0) {
        bi[1] = 0;
        bi[2] = 1;
        bi_free(&tmp);
        return;
    }
    if (tmp.n > (int)bi[0]) {
        bi_fail_cap(tmp.n, (int)bi[0]);
        bi_free(&tmp);
        return;
    }
    for (int i = 0; i < tmp.n; i++)
        bi[3 + i] = tmp.v[i];
    bi[1] = tmp.n;
    bi[2] = sign < 0 ? -1 : 1;
    bi_free(&tmp);
}

static int bi_mul(const BiLimbs *a, const BiLimbs *b, BiLimbs *c)
{
    bi_clear(c);
    if (a->n == 0 || b->n == 0)
        return 1;
    if (!bi_reserve(c, a->n + b->n))
        return 0;
    c->n = a->n + b->n;
    for (int i = 0; i < c->n; i++)
        c->v[i] = 0;
    for (int i = 0; i < a->n; i++) {
        int64_t carry = 0;
        for (int j = 0; j < b->n; j++) {
            int64_t p = a->v[i] * b->v[j] + c->v[i + j] + carry;
            c->v[i + j] = p % BI_BASE;
            carry = p / BI_BASE;
        }
        int k = i + b->n;
        while (carry != 0) {
            int64_t p;
            if (k >= c->n) {
                if (!bi_push(c, 0))
                    return 0;
            }
            p = c->v[k] + carry;
            c->v[k] = p % BI_BASE;
            carry = p / BI_BASE;
            k++;
        }
    }
    bi_trim(c);
    return 1;
}

static int bi_add(const BiLimbs *a, const BiLimbs *b, BiLimbs *c)
{
    int n = a->n > b->n ? a->n : b->n;
    int64_t carry = 0;

    bi_clear(c);
    if (!bi_reserve(c, n + 1))
        return 0;
    c->n = n + 1;
    for (int i = 0; i < n; i++) {
        int64_t av = i < a->n ? a->v[i] : 0;
        int64_t bv = i < b->n ? b->v[i] : 0;
        int64_t s = av + bv + carry;
        c->v[i] = s % BI_BASE;
        carry = s / BI_BASE;
    }
    c->v[n] = carry;
    bi_trim(c);
    return 1;
}

static int bi_sub(const BiLimbs *a, const BiLimbs *b, BiLimbs *c)
{
    int64_t borrow = 0;

    bi_clear(c);
    if (!bi_reserve(c, a->n))
        return 0;
    c->n = a->n;
    for (int i = 0; i < a->n; i++) {
        int64_t bv = i < b->n ? b->v[i] : 0;
        int64_t d = a->v[i] - bv - borrow;
        if (d < 0) {
            d += BI_BASE;
            borrow = 1;
        } else {
            borrow = 0;
        }
        c->v[i] = d;
    }
    bi_trim(c);
    return 1;
}

static int bi_mul_small(const BiLimbs *x, int64_t k, BiLimbs *out)
{
    int64_t carry = 0;

    bi_clear(out);
    if (k == 0 || x->n == 0)
        return 1;
    if (!bi_reserve(out, x->n + 1))
        return 0;
    out->n = x->n + 1;
    for (int i = 0; i < x->n; i++) {
        int64_t p = x->v[i] * k + carry;
        out->v[i] = p % BI_BASE;
        carry = p / BI_BASE;
    }
    out->v[x->n] = carry;
    bi_trim(out);
    return 1;
}

static int bi_window(const int64_t *uu, int start, int n, BiLimbs *w)
{
    bi_clear(w);
    for (int i = 0; i < n + 1; i++) {
        if (!bi_push(w, uu[start + i]))
            return 0;
    }
    bi_trim(w);
    return 1;
}

static void bi_sub_window(int64_t *uu, int start, int n, const BiLimbs *prod)
{
    int64_t borrow = 0;

    for (int i = 0; i < n + 1; i++) {
        int64_t pv = i < prod->n ? prod->v[i] : 0;
        int64_t d = uu[start + i] - pv - borrow;
        if (d < 0) {
            d += BI_BASE;
            borrow = 1;
        } else {
            borrow = 0;
        }
        uu[start + i] = d;
    }
}

static int bi_divmod(const BiLimbs *uIn, const BiLimbs *vIn, BiLimbs *q, BiLimbs *r)
{
    BiLimbs u;
    BiLimbs v;
    BiLimbs prod;
    BiLimbs win;
    int64_t *uu = NULL;
    int ok = 0;
    int n;
    int m;

    memset(&u, 0, sizeof u);
    memset(&v, 0, sizeof v);
    memset(&prod, 0, sizeof prod);
    memset(&win, 0, sizeof win);
    bi_clear(q);
    bi_clear(r);
    if (!bi_copy(&u, uIn) || !bi_copy(&v, vIn))
        goto done;
    bi_trim(&u);
    bi_trim(&v);
    if (v.n == 0 || u.n == 0 || bi_cmp(&u, &v) < 0) {
        if (v.n != 0 && u.n != 0 && bi_cmp(&u, &v) < 0) {
            if (!bi_copy(r, &u))
                goto done;
        }
        ok = 1;
        goto done;
    }
    if (v.n == 1) {
        int64_t d = v.v[0];
        int64_t rem = 0;
        if (!bi_reserve(q, u.n))
            goto done;
        q->n = u.n;
        for (int i = u.n - 1; i >= 0; i--) {
            int64_t cur = rem * BI_BASE + u.v[i];
            q->v[i] = cur / d;
            rem = cur % d;
        }
        bi_trim(q);
        if (rem != 0 && !bi_push(r, rem))
            goto done;
        ok = 1;
        goto done;
    }

    n = v.n;
    m = u.n - n;
    uu = (int64_t *)calloc((size_t)m + (size_t)n + 1, sizeof(int64_t));
    if (uu == NULL || !bi_reserve(q, m + 1))
        goto done;
    for (int i = 0; i < u.n; i++)
        uu[i] = u.v[i];
    q->n = m + 1;
    for (int i = 0; i < q->n; i++)
        q->v[i] = 0;

    for (int j = m; j >= 0; j--) {
        int64_t lo = 0;
        int64_t hi = BI_BASE - 1;
        int64_t num_hi = uu[j + n] * BI_BASE + uu[j + n - 1];
        int64_t lead = v.v[n - 1];
        if (lead > 0) {
            int64_t guess = num_hi / lead;
            if (guess < hi)
                hi = guess;
        }
        while (lo < hi) {
            int64_t mid = (lo + hi + 1) / 2;
            if (!bi_mul_small(&v, mid, &prod) || !bi_window(uu, j, n, &win))
                goto done;
            if (bi_cmp(&prod, &win) <= 0)
                lo = mid;
            else
                hi = mid - 1;
        }
        if (lo > 0) {
            if (!bi_mul_small(&v, lo, &prod))
                goto done;
            bi_sub_window(uu, j, n, &prod);
        }
        q->v[j] = lo;
    }
    bi_trim(q);
    for (int i = 0; i < n + 1; i++) {
        if (!bi_push(r, uu[i]))
            goto done;
    }
    bi_trim(r);
    ok = 1;
done:
    free(uu);
    bi_free(&u);
    bi_free(&v);
    bi_free(&prod);
    bi_free(&win);
    return ok;
}

static int bi_half(const BiLimbs *s, BiLimbs *half)
{
    int64_t carry = 0;

    bi_clear(half);
    if (s->n == 0)
        return 1;
    if (!bi_reserve(half, s->n))
        return 0;
    half->n = s->n;
    for (int i = 0; i < s->n; i++)
        half->v[i] = 0;
    for (int i = s->n - 1; i >= 0; i--) {
        int64_t cur = carry * BI_BASE + s->v[i];
        half->v[i] = cur / 2;
        carry = cur % 2;
    }
    bi_trim(half);
    return 1;
}

static int bi_isqrt(const BiLimbs *aIn, BiLimbs *out)
{
    BiLimbs a;
    BiLimbs x;
    BiLimbs prev;
    BiLimbs q;
    BiLimbs r;
    BiLimbs s;
    BiLimbs half;
    BiLimbs one;
    BiLimbs sq;
    BiLimbs xp;
    int ok = 0;
    int guard = 0;

    memset(&a, 0, sizeof a);
    memset(&x, 0, sizeof x);
    memset(&prev, 0, sizeof prev);
    memset(&q, 0, sizeof q);
    memset(&r, 0, sizeof r);
    memset(&s, 0, sizeof s);
    memset(&half, 0, sizeof half);
    memset(&one, 0, sizeof one);
    memset(&sq, 0, sizeof sq);
    memset(&xp, 0, sizeof xp);
    bi_clear(out);
    if (!bi_copy(&a, aIn) || !bi_push(&one, 1))
        goto done;
    bi_trim(&a);
    if (a.n == 0) {
        ok = 1;
        goto done;
    }
    if (a.n == 1) {
        int64_t x0 = (int64_t)sqrt((double)a.v[0]);
        while ((x0 + 1) * (x0 + 1) <= a.v[0])
            x0++;
        while (x0 * x0 > a.v[0])
            x0--;
        if (x0 != 0 && !bi_push(out, x0))
            goto done;
        ok = 1;
        goto done;
    }

    {
        int init_len = (a.n + 1) / 2;
        int64_t top;
        if (!bi_reserve(&x, init_len))
            goto done;
        x.n = init_len;
        for (int i = 0; i < init_len; i++)
            x.v[i] = 0;
        top = (int64_t)sqrt((double)a.v[a.n - 1]) + 1;
        if (top < 1)
            top = 1;
        if (top >= BI_BASE)
            top = BI_BASE - 1;
        x.v[init_len - 1] = top;
    }

    while (!bi_eq(&x, &prev) && guard < 10000) {
        guard++;
        if (!bi_copy(&prev, &x))
            goto done;
        if (!bi_divmod(&a, &x, &q, &r) || !bi_add(&x, &q, &s) || !bi_half(&s, &half))
            goto done;
        if (half.n == 0) {
            if (!bi_copy(&x, &one))
                goto done;
        } else if (!bi_copy(&x, &half)) {
            goto done;
        }
    }

    for (;;) {
        if (!bi_mul(&x, &x, &sq))
            goto done;
        if (bi_cmp(&sq, &a) <= 0) {
            if (!bi_add(&x, &one, &xp) || !bi_mul(&xp, &xp, &sq))
                goto done;
            if (bi_cmp(&sq, &a) <= 0) {
                if (!bi_copy(&x, &xp))
                    goto done;
                continue;
            }
            break;
        }
        if (!bi_sub(&x, &one, &xp) || !bi_copy(&x, &xp))
            goto done;
    }
    if (!bi_copy(out, &x))
        goto done;
    ok = 1;
done:
    bi_free(&a);
    bi_free(&x);
    bi_free(&prev);
    bi_free(&q);
    bi_free(&r);
    bi_free(&s);
    bi_free(&half);
    bi_free(&one);
    bi_free(&sq);
    bi_free(&xp);
    return ok;
}

static int64_t *bi_ptr(long long cell)
{
    return (int64_t *)(uintptr_t)cell;
}

void host_bi_mul(long long a, long long b, long long r)
{
    BiLimbs la;
    BiLimbs lb;
    BiLimbs lp;
    int sa;
    int sb;

    memset(&la, 0, sizeof la);
    memset(&lb, 0, sizeof lb);
    memset(&lp, 0, sizeof lp);
    if (!bi_read(bi_ptr(a), &la, &sa) || !bi_read(bi_ptr(b), &lb, &sb) ||
        !bi_mul(&la, &lb, &lp)) {
        bi_free(&la);
        bi_free(&lb);
        bi_free(&lp);
        return;
    }
    bi_write(bi_ptr(r), sa * sb, &lp);
    bi_free(&la);
    bi_free(&lb);
    bi_free(&lp);
}

void host_bi_divmod(long long num, long long den, long long quot, long long rem)
{
    BiLimbs ln;
    BiLimbs ld;
    BiLimbs lq;
    BiLimbs lr;
    int sn;
    int sd;
    int qs;
    int rs;

    memset(&ln, 0, sizeof ln);
    memset(&ld, 0, sizeof ld);
    memset(&lq, 0, sizeof lq);
    memset(&lr, 0, sizeof lr);
    if (!bi_read(bi_ptr(num), &ln, &sn) || !bi_read(bi_ptr(den), &ld, &sd))
        goto done;
    if (ld.n == 0 || ln.n == 0) {
        bi_write(bi_ptr(quot), 1, &lq);
        bi_write(bi_ptr(rem), 1, &lr);
        goto done;
    }
    if (!bi_divmod(&ln, &ld, &lq, &lr))
        goto done;
    qs = lq.n == 0 ? 1 : sn * sd;
    rs = lr.n == 0 ? 1 : sn;
    bi_write(bi_ptr(quot), qs, &lq);
    bi_write(bi_ptr(rem), rs, &lr);
done:
    bi_free(&ln);
    bi_free(&ld);
    bi_free(&lq);
    bi_free(&lr);
}

void host_bi_isqrt(long long a, long long r)
{
    BiLimbs la;
    BiLimbs lr;
    int sign;

    memset(&la, 0, sizeof la);
    memset(&lr, 0, sizeof lr);
    if (!bi_read(bi_ptr(a), &la, &sign) || !bi_isqrt(&la, &lr)) {
        bi_free(&la);
        bi_free(&lr);
        return;
    }
    bi_write(bi_ptr(r), 1, &lr);
    bi_free(&la);
    bi_free(&lr);
}

static int64_t *bi_alloc(int cap)
{
    int64_t *p = (int64_t *)calloc((size_t)cap + 3, sizeof(int64_t));
    if (p == NULL)
        return NULL;
    p[0] = cap;
    p[1] = 0;
    p[2] = 1;
    return p;
}

static void bi_set_u(int64_t *p, int64_t u)
{
    int i = 0;
    if (u == 0) {
        p[1] = 0;
        p[2] = 1;
        return;
    }
    while (u != 0) {
        p[3 + i] = u % BI_BASE;
        u /= BI_BASE;
        i++;
    }
    p[1] = i;
    p[2] = 1;
}

static int bi_get_u(const int64_t *p, int64_t *out)
{
    int n = (int)p[1];
    int64_t v = 0;
    int64_t place = 1;
    if (n <= 0) {
        *out = 0;
        return 1;
    }
    if (n > 3)
        return 0;
    for (int i = 0; i < n; i++) {
        int64_t limb = p[3 + i];
        if (limb < 0 || limb >= BI_BASE)
            return 0;
        v += limb * place;
        place *= BI_BASE;
    }
    *out = v;
    return 1;
}

static long long bi_cell(int64_t *p)
{
    return (long long)(uintptr_t)p;
}

int host_bi_selftest(void)
{
    int cap = 16;
    int64_t *a = bi_alloc(cap);
    int64_t *b = bi_alloc(cap);
    int64_t *r = bi_alloc(cap);
    int64_t *q = bi_alloc(cap);
    int64_t *rem = bi_alloc(cap);
    int64_t got = 0;
    int rc = 1;
    int saved;

    if (a == NULL || b == NULL || r == NULL || q == NULL || rem == NULL)
        goto done;
    saved = bi_overflows;
    bi_overflows = 0;

    bi_set_u(a, 123);
    bi_set_u(b, 456);
    host_bi_mul(bi_cell(a), bi_cell(b), bi_cell(r));
    if (!bi_get_u(r, &got) || got != 56088) {
        host_outs("BigIntHost self-test FAILED: mul 123*456\n");
        goto done;
    }

    bi_set_u(a, BI_BASE);
    bi_set_u(b, BI_BASE);
    host_bi_mul(bi_cell(a), bi_cell(b), bi_cell(r));
    if (r[1] != 3 || r[3] != 0 || r[4] != 0 || r[5] != 1) {
        host_outs("BigIntHost self-test FAILED: mul 1e9*1e9\n");
        goto done;
    }

    host_bi_isqrt(bi_cell(r), bi_cell(q));
    if (!bi_get_u(q, &got) || got != BI_BASE) {
        host_outs("BigIntHost self-test FAILED: isqrt 1e18\n");
        goto done;
    }

    bi_set_u(a, 100);
    bi_set_u(b, 7);
    host_bi_divmod(bi_cell(a), bi_cell(b), bi_cell(q), bi_cell(rem));
    if (!bi_get_u(q, &got) || got != 14 || !bi_get_u(rem, &got) || got != 2) {
        host_outs("BigIntHost self-test FAILED: divmod 100/7\n");
        goto done;
    }

    /* (10^18 + 10^9) / (10^9 + 1) = 10^9, two-limb divisor. */
    a[1] = 3;
    a[3] = 0;
    a[4] = 1;
    a[5] = 1;
    b[1] = 2;
    b[3] = 1;
    b[4] = 1;
    host_bi_divmod(bi_cell(a), bi_cell(b), bi_cell(q), bi_cell(rem));
    if (q[1] != 2 || q[3] != 0 || q[4] != 1 || rem[1] != 0) {
        host_outs("BigIntHost self-test FAILED: divmod two-limb\n");
        goto done;
    }

    if (bi_overflows != 0) {
        host_outs("BigIntHost self-test FAILED: capacity overflow\n");
        goto done;
    }
    bi_overflows = saved;
    rc = 0;
done:
    free(a);
    free(b);
    free(r);
    free(q);
    free(rem);
    return rc;
}
