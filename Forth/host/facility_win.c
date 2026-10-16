/* Public domain. ANS facility character grid and the clipboard. */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

void host_out(const void *p, size_t n);
void host_cls(void);

#define FAC_CAP_C 256
#define FAC_CAP_R 128

static int fac_cols = 88;
static int fac_rows = 27;
static uint32_t fac_cells[FAC_CAP_C * FAC_CAP_R];
static uint8_t fac_attr[FAC_CAP_C * FAC_CAP_R];
static int fac_ready;
static int fac_active;
static int fac_col;
static int fac_row;
static int fac_rev;
static unsigned char fac_utf[4];
static int fac_utf_n;

static void fac_fill(void)
{
    int n = fac_cols * fac_rows;
    int i;

    for (i = 0; i < n; i++) {
        fac_cells[i] = 32;
        fac_attr[i] = 0;
    }
}

static void fac_init(void)
{
    if (fac_ready)
        return;
    fac_fill();
    fac_ready = 1;
}

static int utf8_need(unsigned char lead)
{
    if (lead < 0x80)
        return 1;
    if ((lead & 0xE0) == 0xC0)
        return 2;
    if ((lead & 0xF0) == 0xE0)
        return 3;
    if ((lead & 0xF8) == 0xF0)
        return 4;
    return 0;
}

static int utf8_scalar(const unsigned char *b, int n, uint32_t *out)
{
    uint32_t s;

    if (n == 1) {
        *out = b[0];
        return 1;
    }
    if (n == 2) {
        s = ((uint32_t)(b[0] & 0x1F) << 6) | (uint32_t)(b[1] & 0x3F);
        if (s < 0x80)
            return 0;
    } else if (n == 3) {
        s = ((uint32_t)(b[0] & 0x0F) << 12) | ((uint32_t)(b[1] & 0x3F) << 6) |
            (uint32_t)(b[2] & 0x3F);
        if (s < 0x800 || (s >= 0xD800 && s <= 0xDFFF))
            return 0;
    } else if (n == 4) {
        s = ((uint32_t)(b[0] & 0x07) << 18) | ((uint32_t)(b[1] & 0x3F) << 12) |
            ((uint32_t)(b[2] & 0x3F) << 6) | (uint32_t)(b[3] & 0x3F);
        if (s < 0x10000 || s > 0x10FFFF)
            return 0;
    } else {
        return 0;
    }
    *out = s;
    return 1;
}

static void fac_advance(void)
{
    fac_col++;
    if (fac_col >= fac_cols) {
        fac_col = 0;
        fac_row++;
        if (fac_row >= fac_rows) {
            fac_row = fac_rows - 1;
            fac_col = fac_cols - 1;
        }
    }
}

static void fac_put(uint32_t s)
{
    int idx;

    if (s == 9)
        s = 32;
    if (s < 32)
        return;
    if (s > 0x10FFFF || (s >= 0xD800 && s <= 0xDFFF))
        s = 0x2E;
    idx = fac_row * fac_cols + fac_col;
    if (idx >= 0 && idx < fac_cols * fac_rows) {
        fac_cells[idx] = s;
        fac_attr[idx] = fac_rev ? 1 : 0;
    }
    fac_advance();
}

static void fac_newline(void)
{
    fac_utf_n = 0;
    fac_col = 0;
    fac_row++;
    if (fac_row >= fac_rows)
        fac_row = fac_rows - 1;
}

static void fac_emit_byte(unsigned char byte);

static void fac_emit_unlocked(unsigned char byte)
{
    int need;
    uint32_t scalar;

    if (fac_utf_n > 0) {
        if ((byte & 0xC0) == 0x80) {
            fac_utf[fac_utf_n++] = byte;
            need = utf8_need(fac_utf[0]);
            if (fac_utf_n < need)
                return;
            if (utf8_scalar(fac_utf, fac_utf_n, &scalar))
                fac_put(scalar);
            else
                fac_put(0x2E);
            fac_utf_n = 0;
            return;
        }
        fac_utf_n = 0;
        fac_put(0x2E);
        fac_emit_byte(byte);
        return;
    }
    if (byte == 10) {
        fac_newline();
        return;
    }
    if (byte == 13)
        return;
    if (byte < 32 && byte != 9)
        return;
    if (byte < 0x80) {
        fac_put(byte == 9 ? 32 : byte);
        return;
    }
    if ((byte & 0xC0) == 0x80) {
        fac_put(0x2E);
        return;
    }
    need = utf8_need(byte);
    if (need <= 1) {
        fac_put(0x2E);
        return;
    }
    fac_utf[0] = byte;
    fac_utf_n = 1;
}

static void fac_emit_byte(unsigned char byte)
{
    fac_emit_unlocked(byte);
}

/* 1 when the byte was painted into the facility grid. */
int host_facility_emit(unsigned char byte)
{
    if (!fac_active)
        return 0;
    fac_emit_byte(byte);
    return 1;
}

static void fac_render(void)
{
    char line[FAC_CAP_C * 4 + 2];
    int r, c, n;
    uint32_t s;

    for (r = 0; r < fac_rows; r++) {
        n = 0;
        for (c = 0; c < fac_cols; c++) {
            s = fac_cells[r * fac_cols + c];
            if (s < 32 || s > 0x10FFFF)
                s = 32;
            if (s < 0x80) {
                line[n++] = (char)s;
            } else if (s < 0x800) {
                line[n++] = (char)(0xC0 | (s >> 6));
                line[n++] = (char)(0x80 | (s & 0x3F));
            } else if (s < 0x10000) {
                line[n++] = (char)(0xE0 | (s >> 12));
                line[n++] = (char)(0x80 | ((s >> 6) & 0x3F));
                line[n++] = (char)(0x80 | (s & 0x3F));
            } else {
                line[n++] = (char)(0xF0 | (s >> 18));
                line[n++] = (char)(0x80 | ((s >> 12) & 0x3F));
                line[n++] = (char)(0x80 | ((s >> 6) & 0x3F));
                line[n++] = (char)(0x80 | (s & 0x3F));
            }
        }
        line[n++] = '\n';
        host_out(line, (size_t)n);
    }
}

void host_facility_op(int64_t op, int64_t a, int64_t b)
{
    int c;
    int r;

    fac_init();
    switch (op) {
    case 1:
        fac_active = 1;
        fac_fill();
        fac_col = 0;
        fac_row = 0;
        fac_rev = 0;
        fac_utf_n = 0;
        break;
    case 2:
        fac_active = 1;
        fac_utf_n = 0;
        c = (int)a;
        r = (int)b;
        if (c < 0)
            c = 0;
        if (r < 0)
            r = 0;
        if (c >= fac_cols)
            c = fac_cols - 1;
        if (r >= fac_rows)
            r = fac_rows - 1;
        fac_col = c;
        fac_row = r;
        break;
    case 3:
        if (fac_active)
            fac_render();
        break;
    case 4:
        fac_active = 0;
        fac_col = 0;
        fac_row = 0;
        fac_rev = 0;
        fac_utf_n = 0;
        break;
    case 5:
        c = (int)a;
        r = (int)b;
        if (c < 16)
            c = 16;
        if (r < 8)
            r = 8;
        if (c > FAC_CAP_C)
            c = FAC_CAP_C;
        if (r > FAC_CAP_R)
            r = FAC_CAP_R;
        fac_cols = c;
        fac_rows = r;
        fac_fill();
        fac_col = 0;
        fac_row = 0;
        fac_rev = 0;
        fac_utf_n = 0;
        break;
    case 6:
        fac_rev = (a != 0);
        break;
    case 9:
        host_cls();
        break;
    default:
        break;
    }
}

void host_facility_xy(int64_t *col, int64_t *row)
{
    fac_init();
    if (col != 0)
        *col = fac_col;
    if (row != 0)
        *row = fac_row;
}

void host_clip_set(const char *p, int64_t n)
{
    int wn;
    int tries;
    HGLOBAL mem;
    wchar_t *w;

    if (p == 0 || n < 0)
        return;
    if (n > 1048576)
        n = 1048576;
    wn = MultiByteToWideChar(CP_UTF8, 0, p, (int)n, NULL, 0);
    if (wn < 0)
        return;
    mem = GlobalAlloc(GMEM_MOVEABLE, ((size_t)wn + 1) * sizeof(wchar_t));
    if (mem == NULL)
        return;
    w = GlobalLock(mem);
    if (w == NULL) {
        GlobalFree(mem);
        return;
    }
    MultiByteToWideChar(CP_UTF8, 0, p, (int)n, w, wn);
    w[wn] = 0;
    GlobalUnlock(mem);
    for (tries = 0; tries < 5; tries++) {
        if (OpenClipboard(NULL))
            break;
        Sleep(10);
    }
    if (tries == 5) {
        GlobalFree(mem);
        return;
    }
    EmptyClipboard();
    if (SetClipboardData(CF_UNICODETEXT, mem) == NULL)
        GlobalFree(mem);
    CloseClipboard();
}

int64_t host_clip_get(char *dst, int64_t max)
{
    int tries;
    HANDLE mem;
    const wchar_t *w;
    int bytes;
    int copy;

    if (dst == 0 || max <= 0)
        return 0;
    for (tries = 0; tries < 5; tries++) {
        if (OpenClipboard(NULL))
            break;
        Sleep(10);
    }
    if (tries == 5)
        return 0;
    mem = GetClipboardData(CF_UNICODETEXT);
    if (mem == NULL) {
        CloseClipboard();
        return 0;
    }
    w = GlobalLock(mem);
    if (w == NULL) {
        CloseClipboard();
        return 0;
    }
    bytes = WideCharToMultiByte(CP_UTF8, 0, w, -1, NULL, 0, NULL, NULL);
    if (bytes <= 1) {
        GlobalUnlock(mem);
        CloseClipboard();
        return 0;
    }
    {
        char *tmp = (char *)malloc((size_t)bytes);
        if (tmp == NULL) {
            GlobalUnlock(mem);
            CloseClipboard();
            return 0;
        }
        WideCharToMultiByte(CP_UTF8, 0, w, -1, tmp, bytes, NULL, NULL);
        copy = bytes - 1;
        if (copy > (int)max)
            copy = (int)max;
        memcpy(dst, tmp, (size_t)copy);
        free(tmp);
    }
    GlobalUnlock(mem);
    CloseClipboard();
    return copy;
}
