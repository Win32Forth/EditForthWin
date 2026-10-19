/* emit-win.c — Windows runner for a 64EMIT02 image. Public domain.
 * Separate from the Mac emit-run. Loads the image, binds HOST-APP slots,
 * and draws text and pixels into one window.
 *
 *   emit-win.exe [image.img]
 *   (no args: app.img beside the exe)
 *   EMIT_WIN_DUMP=1 writes last-grid.txt beside the exe.
 */
#define WIN32_LEAN_AND_MEAN
#define COBJMACROS
#include <initguid.h>
#include <windows.h>
#include <commdlg.h>
#include <wincodec.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EW_MAGIC 0xC0DE000000000000ull
/* Same cell as SA-DSP0-MAGIC in Emitter/target.fth. The runner stores
 * the empty data-stack pointer here so DEPTH/SP0/CLEARSTACK can find it. */
#define EW_DSP0_MAGIC 0xC0DE0000000000D0ull
#define EW_SLOTS 33
#define EW_PAGE  0x10000u
#define EW_COLS_MAX 256
#define EW_ROWS_MAX 128
#define EW_KEYS 64
#define EW_IMG_MAX (16 * 1024 * 1024)

#ifdef _M_X64
extern void run_itc(void *dsp, void *rp, void *cfa, void *xt, void *regfile);
#else
extern void run_itc(void *dsp, void *rp, void *cfa, void *body);
#endif

static int g_dump;
static int g_cols = 80;
static int g_rows = 25;
static int g_cell_w = 8;
static int g_cell_h = 16;
static int g_pend_cols = 80;
static int g_pend_rows = 25;
static int g_size_dirty;
static int g_in_size_move;
static int g_size_ready;
static unsigned char *g_cells;
static int g_cell_n;
static uint32_t *g_pix;
static int g_pix_w;
static int g_pix_h;
static int g_pix_n;
static struct { int x, y, w, h; COLORREF c; } g_sq[16];
static int g_sq_n;
static unsigned char *g_idx;
static int g_idx_n;
static int g_depth;
static HWND g_hwnd;
static HFONT g_font;
static int g_keys[EW_KEYS];
static int g_key_n;
static wchar_t g_title[256] = L"Emit Win";
static wchar_t g_exe_dir[MAX_PATH];
static long long g_mouse_x;
static long long g_mouse_y;
static long long g_mouse_b;

static void ensure_pix(void);

static void die(const char *msg) {
    fprintf(stderr, "emit-win: %s\n", msg);
    MessageBoxA(NULL, msg, "emit-win", MB_OK | MB_ICONERROR);
    exit(1);
}

static uint64_t rd_u64(const uint8_t *p) {
    uint64_t v;
    memcpy(&v, p, 8);
    return v;
}

static uint32_t rd_u32(const uint8_t *p) {
    uint32_t v;
    memcpy(&v, p, 4);
    return v;
}

static void pump(void) {
    MSG msg;
    while (PeekMessageW(&msg, NULL, 0, 0, PM_REMOVE)) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
}

static void push_key(int c) {
    if (c < 0 || g_key_n >= EW_KEYS)
        return;
    g_keys[g_key_n++] = c;
}

static int take_key(void) {
    int c;
    int i;
    if (g_key_n <= 0)
        return -1;
    c = g_keys[0];
    for (i = 1; i < g_key_n; i++)
        g_keys[i - 1] = g_keys[i];
    g_key_n--;
    return c;
}

/* COLOR8 indices 0..15 are the EGA set, then the 6x6x6 cube and gray ramp.
 * Same packing as gfx_win.c: little-endian B,G,R,A for a 32-bit DIB. */
static uint32_t pal8(unsigned char c)
{
    static uint32_t pal[256];
    static int ready;
    int i;
    int idx;
    int r;
    int g;
    int b;
    static const unsigned char rgb16[16][3] = {
        {0, 0, 0}, {0, 0, 170}, {0, 170, 0}, {0, 170, 170},
        {170, 0, 0}, {170, 0, 170}, {170, 85, 0}, {170, 170, 170},
        {85, 85, 85}, {85, 85, 255}, {85, 255, 85}, {85, 255, 255},
        {255, 85, 85}, {255, 85, 255}, {255, 255, 85}, {255, 255, 255}
    };

    if (!ready) {
        for (i = 0; i < 16; i++) {
            pal[i] = (uint32_t)rgb16[i][2]
                | ((uint32_t)rgb16[i][1] << 8)
                | ((uint32_t)rgb16[i][0] << 16)
                | 0xFF000000u;
        }
        idx = 16;
        for (r = 0; r < 6; r++) {
            for (g = 0; g < 6; g++) {
                for (b = 0; b < 6; b++) {
                    pal[idx++] = (uint32_t)(b * 51)
                        | ((uint32_t)(g * 51) << 8)
                        | ((uint32_t)(r * 51) << 16)
                        | 0xFF000000u;
                }
            }
        }
        for (i = 0; i < 24; i++) {
            unsigned v = (unsigned)(8 + i * 10);
            if (v > 255)
                v = 255;
            pal[232 + i] = v | (v << 8) | (v << 16) | 0xFF000000u;
        }
        ready = 1;
    }
    return pal[c];
}

/* Dark EGA indices (0..7) need white text. Light indices use black text.
 * That is the Mac COLOR8 rule, so the clock menu shows on a black face.
 * TRUECOLOR has no index: a dark pixel (IMAGEVIEW's erased canvas) also
 * needs white text. No pixel buffer yet means the black window brush. */
static int cell_on_dark(int x, int y)
{
    int cw;
    int ch;
    int ix;
    int iy;
    uint32_t p;
    int r;
    int g;
    int b;

    if (g_pix_w < 1 || g_pix_h < 1 || g_cols < 1 || g_rows < 1)
        return 1;
    cw = g_pix_w / g_cols;
    ch = g_pix_h / g_rows;
    if (cw < 1)
        cw = 1;
    if (ch < 1)
        ch = 1;
    ix = x * cw + cw / 2;
    iy = y * ch + ch / 2;
    if (ix >= g_pix_w)
        ix = g_pix_w - 1;
    if (iy >= g_pix_h)
        iy = g_pix_h - 1;
    if (g_depth == 8 && g_idx != NULL)
        return g_idx[iy * g_pix_w + ix] < 8;
    if (g_pix == NULL)
        return 1;
    p = g_pix[iy * g_pix_w + ix];
    b = (int)(p & 255u);
    g = (int)((p >> 8) & 255u);
    r = (int)((p >> 16) & 255u);
    return (r + g + b) < (128 * 3);
}

/* Map a pixel in the Forth grid onto the stretched client area. */
static int stretch_x(int x, int dest_w) {
    if (g_pix_w < 1 || dest_w < 1)
        return x;
    return x * dest_w / g_pix_w;
}

static int stretch_y(int y, int dest_h) {
    if (g_pix_h < 1 || dest_h < 1)
        return y;
    return y * dest_h / g_pix_h;
}

static void paint(HDC dc) {
    int x;
    int y;
    int dw;
    int dh;
    RECT rc;
    HBRUSH bg;
    char ch[2];

    GetClientRect(g_hwnd, &rc);
    dw = rc.right;
    dh = rc.bottom;
    if (dw < 1)
        dw = 1;
    if (dh < 1)
        dh = 1;
    /* Clock paper is black. A white COLOR_WINDOW fill is the empty margin. */
    bg = (HBRUSH)GetStockObject(BLACK_BRUSH);
    FillRect(dc, &rc, bg);
    if (g_pix && g_pix_w > 0 && g_pix_h > 0) {
        BITMAPINFO bmi;
        memset(&bmi, 0, sizeof bmi);
        bmi.bmiHeader.biSize = sizeof bmi.bmiHeader;
        bmi.bmiHeader.biWidth = g_pix_w;
        bmi.bmiHeader.biHeight = -g_pix_h;
        bmi.bmiHeader.biPlanes = 1;
        bmi.bmiHeader.biBitCount = 32;
        bmi.bmiHeader.biCompression = BI_RGB;
        SetStretchBltMode(dc, COLORONCOLOR);
        StretchDIBits(dc, 0, 0, dw, dh, 0, 0, g_pix_w, g_pix_h,
                      g_pix, &bmi, DIB_RGB_COLORS, SRCCOPY);
    }
    {
        int s;
        for (s = 0; s < g_sq_n; s++) {
            RECT sr;
            HBRUSH br = CreateSolidBrush(g_sq[s].c);
            sr.left = stretch_x(g_sq[s].x, dw);
            sr.top = stretch_y(g_sq[s].y, dh);
            sr.right = stretch_x(g_sq[s].x + g_sq[s].w, dw);
            sr.bottom = stretch_y(g_sq[s].y + g_sq[s].h, dh);
            FillRect(dc, &sr, br);
            DeleteObject(br);
        }
    }
    if (!g_font)
        g_font = (HFONT)GetStockObject(ANSI_FIXED_FONT);
    if (!g_cells || !g_font)
        return;
    SelectObject(dc, g_font);
    SetBkMode(dc, TRANSPARENT);
    ch[1] = 0;
    for (y = 0; y < g_rows; y++) {
        for (x = 0; x < g_cols; x++) {
            int i = y * g_cols + x;
            unsigned char c;
            if (i >= g_cell_n)
                break;
            c = g_cells[i];
            if (c <= 32 || c > 126)
                continue;
            ch[0] = (char)c;
            if (cell_on_dark(x, y))
                SetTextColor(dc, RGB(255, 255, 255));
            else
                SetTextColor(dc, RGB(0, 0, 0));
            TextOutA(dc, stretch_x(x * g_cell_w, dw), stretch_y(y * g_cell_h, dh), ch, 1);
        }
    }
}

static void note_client_size(HWND hwnd) {
    RECT rc;
    int c;
    int r;
    GetClientRect(hwnd, &rc);
    c = g_cell_w > 0 ? rc.right / g_cell_w : g_cols;
    r = g_cell_h > 0 ? rc.bottom / g_cell_h : g_rows;
    if (c < 40)
        c = 40;
    if (r < 12)
        r = 12;
    if (c > EW_COLS_MAX)
        c = EW_COLS_MAX;
    if (r > EW_ROWS_MAX)
        r = EW_ROWS_MAX;
    if (c != g_cols || r != g_rows) {
        g_pend_cols = c;
        g_pend_rows = r;
        g_size_dirty = 1;
    }
}

/* Plot y grows up, matching the graphics host. The window is stretched
 * over the client, so map the click back into the pixel grid. */
static void note_mouse(HWND hwnd, int x, int y, WPARAM wp) {
    RECT rc;
    int pw;
    int ph;
    long long px;
    long long py;
    long long buttons = 0;

    GetClientRect(hwnd, &rc);
    pw = g_pix_w > 0 ? g_pix_w : g_cols * g_cell_w;
    ph = g_pix_h > 0 ? g_pix_h : g_rows * g_cell_h;
    if (pw < 1)
        pw = 1;
    if (ph < 1)
        ph = 1;
    if (rc.right < 1)
        rc.right = 1;
    if (rc.bottom < 1)
        rc.bottom = 1;
    if (x < 0)
        x = 0;
    if (y < 0)
        y = 0;
    px = (long long)x * pw / rc.right;
    py = (long long)ph - 1 - ((long long)y * ph / rc.bottom);
    if (px < 0)
        px = 0;
    if (py < 0)
        py = 0;
    if (px >= pw)
        px = pw - 1;
    if (py >= ph)
        py = ph - 1;
    if (wp & MK_LBUTTON)
        buttons |= 1;
    if (wp & MK_RBUTTON)
        buttons |= 2;
    if (wp & MK_MBUTTON)
        buttons |= 4;
    g_mouse_x = px;
    g_mouse_y = py;
    g_mouse_b = buttons;
}

static LRESULT CALLBACK wnd_proc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
    switch (msg) {
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC dc = BeginPaint(hwnd, &ps);
        paint(dc);
        EndPaint(hwnd, &ps);
        return 0;
    }
    case WM_ERASEBKGND:
        return 1;
    case WM_ENTERSIZEMOVE:
        g_in_size_move = 1;
        return 0;
    case WM_SIZE:
        InvalidateRect(hwnd, NULL, FALSE);
        if (g_size_ready && !g_in_size_move)
            note_client_size(hwnd);
        return 0;
    case WM_EXITSIZEMOVE:
        g_in_size_move = 0;
        note_client_size(hwnd);
        InvalidateRect(hwnd, NULL, FALSE);
        return 0;
    case WM_MOUSEMOVE:
    case WM_LBUTTONDOWN:
    case WM_LBUTTONUP:
    case WM_RBUTTONDOWN:
    case WM_RBUTTONUP:
    case WM_MBUTTONDOWN:
    case WM_MBUTTONUP:
        note_mouse(hwnd, (short)LOWORD(lp), (short)HIWORD(lp), wp);
        if (msg == WM_LBUTTONDOWN || msg == WM_RBUTTONDOWN || msg == WM_MBUTTONDOWN)
            SetCapture(hwnd);
        if (msg == WM_LBUTTONUP || msg == WM_RBUTTONUP || msg == WM_MBUTTONUP)
            ReleaseCapture();
        return 0;
    case WM_CHAR:
        push_key((int)wp);
        return 0;
    case WM_KEYDOWN:
        if (wp == VK_RETURN) push_key(13);
        else if (wp == VK_ESCAPE) push_key(27);
        else if (wp == VK_BACK) push_key(8);
        return 0;
    case WM_DESTROY:
        g_hwnd = NULL;
        return 0;
    default:
        return DefWindowProcW(hwnd, msg, wp, lp);
    }
}

static void ensure_class(void) {
    static int ready;
    WNDCLASSW wc;
    if (ready)
        return;
    memset(&wc, 0, sizeof wc);
    wc.lpfnWndProc = wnd_proc;
    wc.hInstance = GetModuleHandleW(NULL);
    wc.lpszClassName = L"EmitWin";
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
    if (!RegisterClassW(&wc))
        die("register class");
    ready = 1;
}

static void resize_window(void) {
    RECT rc;
    if (!g_hwnd)
        return;
    rc.left = 0;
    rc.top = 0;
    rc.right = g_cols * g_cell_w;
    rc.bottom = g_rows * g_cell_h;
    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW, FALSE);
    SetWindowPos(g_hwnd, NULL, 0, 0, rc.right - rc.left, rc.bottom - rc.top,
                 SWP_NOMOVE | SWP_NOZORDER);
}

static long long ew_open(long long cols, long long rows) {
    int n;
    if (cols < 1) cols = 80;
    if (rows < 1) rows = 25;
    if (cols > EW_COLS_MAX) cols = EW_COLS_MAX;
    if (rows > EW_ROWS_MAX) rows = EW_ROWS_MAX;
    g_cols = (int)cols;
    g_rows = (int)rows;
    n = g_cols * g_rows;
    free(g_cells);
    g_cells = (unsigned char *)malloc((size_t)n);
    if (!g_cells)
        return -1;
    memset(g_cells, ' ', (size_t)n);
    g_cell_n = n;
    g_sq_n = 0;
    g_pix_w = g_cols * g_cell_w;
    g_pix_h = g_rows * g_cell_h;
    g_pend_cols = g_cols;
    g_pend_rows = g_rows;
    g_size_dirty = 0;
    ensure_pix();
    ensure_class();
    if (!g_font)
        g_font = CreateFontW(16, 8, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
                              ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                              DEFAULT_QUALITY, FIXED_PITCH | FF_MODERN, L"Courier New");
    if (!g_hwnd) {
        g_hwnd = CreateWindowExW(0, L"EmitWin", g_title, WS_OVERLAPPEDWINDOW,
                                  CW_USEDEFAULT, CW_USEDEFAULT, 640, 480,
                                  NULL, NULL, GetModuleHandleW(NULL), NULL);
        if (!g_hwnd)
            return -1;
    }
    SetWindowTextW(g_hwnd, g_title);
    resize_window();
    g_size_ready = 1;
    ShowWindow(g_hwnd, SW_SHOW);
    UpdateWindow(g_hwnd);
    pump();
    return 0;
}

static long long ew_close(void) {
    if (g_hwnd) {
        DestroyWindow(g_hwnd);
        g_hwnd = NULL;
    }
    pump();
    return 0;
}

static long long ew_blit(long long addr, long long nbytes) {
    int n;
    if (!g_cells || addr == 0 || nbytes <= 0)
        return 0;
    n = g_cell_n;
    if (nbytes < n)
        n = (int)nbytes;
    memcpy(g_cells, (const void *)(uintptr_t)addr, (size_t)n);
    if (g_hwnd) {
        InvalidateRect(g_hwnd, NULL, FALSE);
        UpdateWindow(g_hwnd);
    }
    pump();
    return 0;
}

static void ensure_pix(void) {
    int n = g_pix_w * g_pix_h;
    if (n < 1)
        return;
    if (g_pix_n == n && g_pix)
        return;
    free(g_pix);
    g_pix = (uint32_t *)calloc((size_t)n, 4);
    g_pix_n = g_pix ? n : 0;
}

static long long ew_cblit(long long addr, long long nbytes, long long depth) {
    const unsigned char *src;
    int x;
    int y;
    int stride;
    int i;
    if (addr == 0 || nbytes <= 0)
        return 0;
    if (g_pix_w < 1)
        g_pix_w = g_cols * 8;
    if (g_pix_h < 1)
        g_pix_h = g_rows * 16;
    ensure_pix();
    if (!g_pix)
        return -1;
    src = (const unsigned char *)(uintptr_t)addr;
    /* Depth 4 is a Windows square list: color,x,y,w,h cells. Not a Mac depth. */
    if (depth == 4 && (nbytes % 40) == 0) {
        int nrec = (int)(nbytes / 40);
        int r;
        int k;
        for (k = 0; k < g_pix_w * g_pix_h; k++)
            g_pix[k] = 0xFFFFFFFFu;
        g_sq_n = nrec > 16 ? 16 : nrec;
        for (r = 0; r < nrec; r++) {
            const int64_t *rec = (const int64_t *)(src + r * 40);
            int x0 = (int)rec[1];
            int y0 = (int)rec[2];
            int rw = (int)rec[3];
            int rh = (int)rec[4];
            int x;
            int y;
            uint32_t color = (uint32_t)rec[0];
            if (r < 16) {
                g_sq[r].x = x0;
                g_sq[r].y = y0;
                g_sq[r].w = rw;
                g_sq[r].h = rh;
                g_sq[r].c = RGB((color >> 16) & 255, (color >> 8) & 255, color & 255);
            }
            for (y = y0; y < y0 + rh; y++) {
                if (y < 0 || y >= g_pix_h)
                    continue;
                for (x = x0; x < x0 + rw; x++) {
                    if (x < 0 || x >= g_pix_w)
                        continue;
                    g_pix[y * g_pix_w + x] = color;
                }
            }
        }
        if (g_hwnd) {
            InvalidateRect(g_hwnd, NULL, TRUE);
            UpdateWindow(g_hwnd);
        }
        g_depth = 4;
        pump();
        return 0;
    }
    if (depth != 8 && depth != 32)
        depth = 1;
    g_depth = (int)depth;
    if (depth == 32) {
        int n = g_pix_w * g_pix_h * 4;
        int k;
        if (nbytes < n)
            n = (int)nbytes;
        for (k = 0; k < g_pix_w * g_pix_h; k++)
            g_pix[k] = 0xFFFFFFFFu;
        memcpy(g_pix, src, (size_t)n);
    } else if (depth == 8) {
        int n = g_pix_w * g_pix_h;
        if (g_idx_n != n || g_idx == NULL) {
            free(g_idx);
            g_idx = (unsigned char *)malloc((size_t)n);
            g_idx_n = g_idx ? n : 0;
        }
        if (g_idx == NULL)
            return -1;
        for (i = 0; i < n; i++) {
            unsigned char c = (i < nbytes) ? src[i] : 0;
            g_idx[i] = c;
            g_pix[i] = pal8(c);
        }
    } else {
        stride = (g_pix_w + 7) / 8;
        for (y = 0; y < g_pix_h; y++) {
            for (x = 0; x < g_pix_w; x++) {
                int bit = y * stride + (x >> 3);
                int on = 0;
                if (bit < nbytes)
                    on = (src[bit] & (0x80 >> (x & 7))) != 0;
                /* Ink on white paper. Off bits used to be opaque black,
                   which hid the black text drawn on top. */
                g_pix[y * g_pix_w + x] = on ? 0xFF000000u : 0xFFFFFFFFu;
            }
        }
    }
    if (g_hwnd) {
        InvalidateRect(g_hwnd, NULL, FALSE);
        UpdateWindow(g_hwnd);
    }
    pump();
    return 0;
}

static long long ew_pblit(long long addr, long long nbytes) {
    return ew_cblit(addr, nbytes, 1);
}

static long long ew_keyq(void) {
    pump();
    return g_key_n > 0 ? -1 : 0;
}

static long long ew_key(void) {
    int c;
    if (g_dump)
        return 13;
    for (;;) {
        pump();
        c = take_key();
        if (c >= 0)
            return c;
        if (!g_hwnd)
            return 27;
        Sleep(10);
    }
}

static long long ew_name(long long addr, long long nbytes) {
    char tmp[240];
    int n;
    if (addr == 0 || nbytes <= 0)
        return 0;
    n = (int)nbytes;
    if (n > 239)
        n = 239;
    memcpy(tmp, (const void *)(uintptr_t)addr, (size_t)n);
    tmp[n] = 0;
    MultiByteToWideChar(CP_UTF8, 0, tmp, -1, g_title, 256);
    if (g_hwnd)
        SetWindowTextW(g_hwnd, g_title);
    return 0;
}

static long long ew_tone(long long freq, long long dur) {
    (void)freq;
    (void)dur;
    return 0;
}

static long long ew_pump(void) {
    pump();
    return 0;
}

static long long ew_ms(void) {
    return (long long)GetTickCount64();
}

static long long ew_alloc(long long n) {
    if (n < 0)
        return 0;
    return (long long)(uintptr_t)malloc(n == 0 ? 1 : (size_t)n);
}

static long long ew_free(long long p) {
    free((void *)(uintptr_t)p);
    return 0;
}

static long long ew_stub0(void) { return 0; }
static long long ew_stub_m1(void) { return -1; }

static long long ew_mouse(long long xp, long long yp, long long bp) {
    if (xp) *(long long *)(uintptr_t)xp = g_mouse_x;
    if (yp) *(long long *)(uintptr_t)yp = g_mouse_y;
    if (bp) *(long long *)(uintptr_t)bp = g_mouse_b;
    return 0;
}

/* (APP-SIZE?) — x0=&cols x1=&rows. Return -1 once after a finished resize. */
static long long ew_size(long long cp, long long rp) {
    long long flag = 0;
    if (cp)
        *(long long *)(uintptr_t)cp = g_pend_cols;
    if (rp)
        *(long long *)(uintptr_t)rp = g_pend_rows;
    if (g_size_dirty) {
        g_size_dirty = 0;
        flag = -1;
    }
    return flag;
}

/* Slot 27: TIME&DATE. x0 points at int64 out[6]: sec min hour day month year. */
static long long ew_time_date(long long out_ptr) {
    SYSTEMTIME st;
    long long *out = (long long *)(uintptr_t)out_ptr;
    if (!out)
        return 0;
    GetLocalTime(&st);
    out[0] = st.wSecond;
    out[1] = st.wMinute;
    out[2] = st.wHour;
    out[3] = st.wDay;
    out[4] = st.wMonth;
    out[5] = st.wYear;
    return 0;
}

static long long ew_sleep(long long ms) {
    if (ms > 0)
        Sleep((DWORD)ms);
    return 0;
}

/* SA-PRINT rebind: x0 is the character. Also lands in the window grid. */
static void ew_putchar(unsigned long long c) {
    unsigned char b = (unsigned char)c;
    static int col;
    static int row;
    int i;
    fputc(b, stdout);
    if (!g_cells)
        return;
    if (b == 10 || b == 13) {
        col = 0;
        if (row + 1 < g_rows)
            row++;
        return;
    }
    i = row * g_cols + col;
    if (i >= 0 && i < g_cell_n)
        g_cells[i] = b;
    col++;
    if (col >= g_cols) {
        col = 0;
        if (row + 1 < g_rows)
            row++;
    }
}

static long long ew_file_op(long long op, long long a, long long b,
                             long long c, long long d, long long ptr) {
    (void)op; (void)a; (void)b; (void)c; (void)d; (void)ptr;
    return -1;
}

/* Loaded picture, 32-bit BGRA. Same limits as the editor graphics host. */
static unsigned char *g_img;
static int g_img_w;
static int g_img_h;

static int ew_wic_load(const wchar_t *path) {
    IWICImagingFactory *fac = NULL;
    IWICBitmapDecoder *dec = NULL;
    IWICBitmapFrameDecode *frame = NULL;
    IWICFormatConverter *conv = NULL;
    UINT w = 0;
    UINT h = 0;
    UINT stride;
    UINT bytes;
    HRESULT hr;
    HRESULT co;
    int own = 0;
    unsigned char *buf;

    co = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
    if (co == S_OK)
        own = 1;
    hr = CoCreateInstance(&CLSID_WICImagingFactory, NULL, CLSCTX_INPROC_SERVER,
                           &IID_IWICImagingFactory, (void **)&fac);
    if (FAILED(hr))
        goto fail;
    hr = IWICImagingFactory_CreateDecoderFromFilename(fac, path, NULL, GENERIC_READ,
                                                       WICDecodeMetadataCacheOnLoad, &dec);
    if (FAILED(hr))
        goto fail;
    hr = IWICBitmapDecoder_GetFrame(dec, 0, &frame);
    if (FAILED(hr))
        goto fail;
    hr = IWICImagingFactory_CreateFormatConverter(fac, &conv);
    if (FAILED(hr))
        goto fail;
    hr = IWICFormatConverter_Initialize(conv, (IWICBitmapSource *)frame,
                                         &GUID_WICPixelFormat32bppBGRA,
                                         WICBitmapDitherTypeNone, NULL, 0.0,
                                         WICBitmapPaletteTypeCustom);
    if (FAILED(hr))
        goto fail;
    hr = IWICBitmapSource_GetSize((IWICBitmapSource *)conv, &w, &h);
    if (FAILED(hr) || w == 0 || h == 0 || w > 4096 || h > 4096)
        goto fail;
    stride = w * 4;
    bytes = stride * h;
    if (bytes > EW_IMG_MAX)
        goto fail;
    buf = (unsigned char *)malloc(bytes);
    if (buf == NULL)
        goto fail;
    hr = IWICBitmapSource_CopyPixels((IWICBitmapSource *)conv, NULL, stride, bytes, buf);
    if (FAILED(hr)) {
        free(buf);
        goto fail;
    }
    free(g_img);
    g_img = buf;
    g_img_w = (int)w;
    g_img_h = (int)h;
    if (conv != NULL)
        IWICFormatConverter_Release(conv);
    if (frame != NULL)
        IWICBitmapFrameDecode_Release(frame);
    if (dec != NULL)
        IWICBitmapDecoder_Release(dec);
    if (fac != NULL)
        IWICImagingFactory_Release(fac);
    if (own)
        CoUninitialize();
    return 0;
fail:
    if (conv != NULL)
        IWICFormatConverter_Release(conv);
    if (frame != NULL)
        IWICBitmapFrameDecode_Release(frame);
    if (dec != NULL)
        IWICBitmapDecoder_Release(dec);
    if (fac != NULL)
        IWICImagingFactory_Release(fac);
    free(g_img);
    g_img = NULL;
    g_img_w = 0;
    g_img_h = 0;
    if (own)
        CoUninitialize();
    return -2;
}

static int ew_wide_path(const void *addr, long long nbytes, wchar_t *dst, int cap) {
    char tmp[1024];
    int n;
    if (addr == NULL || nbytes <= 0 || cap < 2)
        return 0;
    if (nbytes > 1023)
        nbytes = 1023;
    memcpy(tmp, addr, (size_t)nbytes);
    tmp[nbytes] = 0;
    n = MultiByteToWideChar(CP_UTF8, 0, tmp, -1, dst, cap);
    return n > 0;
}

/* (APP-IMG-CHOOSE) ( -- ior ). 0 loaded, -1 cancelled, -2 failed. */
static long long ew_img_choose(void) {
    wchar_t file[1024];
    OPENFILENAMEW ofn;
    BOOL ok;

    file[0] = 0;
    memset(&ofn, 0, sizeof ofn);
    ofn.lStructSize = sizeof ofn;
    ofn.hwndOwner = g_hwnd;
    ofn.lpstrFile = file;
    ofn.nMaxFile = 1024;
    ofn.lpstrFilter = L"Images\0*.bmp;*.png;*.jpg;*.jpeg;*.gif;*.tif;*.tiff\0All files\0*.*\0";
    ofn.lpstrTitle = L"Open Image";
    ofn.nFilterIndex = 1;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_NOCHANGEDIR;
    ok = GetOpenFileNameW(&ofn);
    if (!ok)
        return CommDlgExtendedError() ? -2 : -1;
    return ew_wic_load(file);
}

/* (APP-IMG-LOAD) ( c-addr u -- ior ). */
static long long ew_img_load(long long addr, long long nbytes) {
    wchar_t wide[1024];
    if (!ew_wide_path((const void *)(uintptr_t)addr, nbytes, wide, 1024))
        return -2;
    return ew_wic_load(wide);
}

/* (APP-IMG-SIZE) ( -- w h ). Writes the two result cells the prim allocated. */
static long long ew_img_size(long long wp, long long hp) {
    if (wp)
        *(long long *)(uintptr_t)wp = g_img_w;
    if (hp)
        *(long long *)(uintptr_t)hp = g_img_h;
    return 0;
}

/* (APP-IMG-RENDER) ( dest w h cx cy zoom100 -- ior ). BGRA, y down. */
static long long ew_img_render(long long dest, long long dest_w, long long dest_h,
                               long long cx, long long cy, long long zoom100) {
    unsigned char *out;
    unsigned char *img;
    int iw;
    int ih;
    int dw;
    int dh;
    int z;
    int sy;
    int sx;
    int half_w;
    int half_h;

    if (dest == 0 || dest_w <= 0 || dest_h <= 0)
        return -1;
    if (dest_w > 4096 || dest_h > 4096)
        return -1;
    if (g_img == NULL || g_img_w <= 0 || g_img_h <= 0)
        return -1;
    iw = g_img_w;
    ih = g_img_h;
    img = (unsigned char *)malloc((size_t)iw * (size_t)ih * 4u);
    if (img == NULL)
        return -1;
    memcpy(img, g_img, (size_t)iw * (size_t)ih * 4u);
    dw = (int)dest_w;
    dh = (int)dest_h;
    z = (int)zoom100;
    if (z < 1)
        z = 1;
    half_w = dw / 2;
    half_h = dh / 2;
    out = (unsigned char *)(uintptr_t)dest;
    for (sy = 0; sy < dh; sy++) {
        for (sx = 0; sx < dw; sx++) {
            int ix = (int)cx + (sx - half_w) * 100 / z;
            int iy = (int)cy + (sy - half_h) * 100 / z;
            int o = (sy * dw + sx) * 4;
            if (ix < 0 || iy < 0 || ix >= iw || iy >= ih) {
                out[o] = 0;
                out[o + 1] = 0;
                out[o + 2] = 0;
                out[o + 3] = 255;
            } else {
                int s = (iy * iw + ix) * 4;
                out[o] = img[s];
                out[o + 1] = img[s + 1];
                out[o + 2] = img[s + 2];
                out[o + 3] = 255;
            }
        }
    }
    free(img);
    return 0;
}

/* Staged path for (APP-FILE-*). UTF-8. Slots 21–25 were the -1 stub,
 * so Open and Save returned immediately and the page just redrew. */
static char g_staged[1024];

static void ew_stage_wide(const wchar_t *path) {
    int n = WideCharToMultiByte(CP_UTF8, 0, path, -1, g_staged,
                                (int)sizeof g_staged, NULL, NULL);
    if (n <= 0)
        g_staged[0] = 0;
}

/* 0 = path staged, -1 = cancelled, -2 = failed. */
static long long ew_file_dialog(int save) {
    wchar_t file[1024];
    OPENFILENAMEW ofn;
    BOOL ok;

    file[0] = 0;
    if (save && g_staged[0] != 0)
        MultiByteToWideChar(CP_UTF8, 0, g_staged, -1, file, 1024);
    memset(&ofn, 0, sizeof ofn);
    ofn.lStructSize = sizeof ofn;
    ofn.hwndOwner = g_hwnd;
    ofn.lpstrFile = file;
    ofn.nMaxFile = 1024;
    ofn.lpstrFilter = L"All files\0*.*\0Forth files\0*.fth;*.fs;*.4th;*.f;*.txt\0";
    ofn.lpstrTitle = save ? L"Save File" : L"Open File";
    ofn.nFilterIndex = 1;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR;
    if (save) {
        ofn.Flags |= OFN_OVERWRITEPROMPT;
        ok = GetSaveFileNameW(&ofn);
    } else {
        ofn.Flags |= OFN_FILEMUSTEXIST;
        ok = GetOpenFileNameW(&ofn);
    }
    if (!ok)
        return CommDlgExtendedError() ? -2 : -1;
    ew_stage_wide(file);
    return 0;
}

static long long ew_file_choose(void) {
    return ew_file_dialog(0);
}

static long long ew_file_save_as(void) {
    return ew_file_dialog(1);
}

static long long ew_file_path(void *dest, long long max) {
    size_t n;
    if (dest == NULL || max <= 0)
        return 0;
    n = strlen(g_staged);
    if (n > (size_t)max)
        n = (size_t)max;
    if (n > 0)
        memcpy(dest, g_staged, n);
    return (long long)n;
}

static long long ew_file_slurp(void *dest, long long max, long long *out_u) {
    FILE *fp;
    long long n;
    wchar_t wide[1024];

    if (out_u != NULL)
        *out_u = 0;
    if (dest == NULL || max <= 0)
        return -2;
    if (g_staged[0] == 0)
        return -1;
    if (MultiByteToWideChar(CP_UTF8, 0, g_staged, -1, wide, 1024) <= 0)
        return -2;
    if (_wfopen_s(&fp, wide, L"rb") != 0 || fp == NULL)
        return -2;
    n = (long long)fread(dest, 1, (size_t)max, fp);
    fclose(fp);
    if (out_u != NULL)
        *out_u = n;
    return 0;
}

static long long ew_file_spew(const void *src, long long nbytes) {
    FILE *fp;
    wchar_t wide[1024];

    if (src == NULL || nbytes < 0)
        return -2;
    if (g_staged[0] == 0)
        return -1;
    if (MultiByteToWideChar(CP_UTF8, 0, g_staged, -1, wide, 1024) <= 0)
        return -2;
    if (_wfopen_s(&fp, wide, L"wb") != 0 || fp == NULL)
        return -2;
    if (nbytes > 0 && fwrite(src, 1, (size_t)nbytes, fp) != (size_t)nbytes) {
        fclose(fp);
        return -2;
    }
    fclose(fp);
    return 0;
}

static void *g_slot[EW_SLOTS];

static void slots_init(void) {
    int i;
    for (i = 0; i < EW_SLOTS; i++)
        g_slot[i] = (void *)ew_stub_m1;
    g_slot[0] = (void *)ew_open;
    g_slot[1] = (void *)ew_close;
    g_slot[2] = (void *)ew_blit;
    g_slot[3] = (void *)ew_pblit;
    g_slot[4] = (void *)ew_keyq;
    g_slot[5] = (void *)ew_key;
    g_slot[6] = (void *)ew_name;
    g_slot[7] = (void *)ew_tone;
    g_slot[8] = (void *)ew_pump;
    g_slot[9] = (void *)ew_ms;
    g_slot[10] = (void *)ew_alloc;
    g_slot[11] = (void *)ew_free;
    g_slot[12] = (void *)ew_stub_m1;
    g_slot[13] = (void *)ew_stub_m1;
    g_slot[14] = (void *)ew_stub_m1;
    g_slot[15] = (void *)ew_mouse;
    g_slot[16] = (void *)ew_cblit;
    g_slot[17] = (void *)ew_img_choose;
    g_slot[18] = (void *)ew_img_load;
    g_slot[19] = (void *)ew_img_size;
    g_slot[20] = (void *)ew_img_render;
    g_slot[21] = (void *)ew_file_choose;
    g_slot[22] = (void *)ew_file_save_as;
    g_slot[23] = (void *)ew_file_path;
    g_slot[24] = (void *)ew_file_slurp;
    g_slot[25] = (void *)ew_file_spew;
    g_slot[26] = (void *)ew_size;
    g_slot[27] = (void *)ew_time_date;
    g_slot[32] = (void *)ew_sleep;
    (void)ew_stub0;
}

static void rebase_cell(uint8_t *cell, uint64_t code_base, uint64_t code_len,
                         uint64_t data_base, uint64_t data_len,
                         uint8_t *code, uint8_t *data) {
    uint64_t v = rd_u64(cell);
    if (v >= code_base && v < code_base + code_len) {
        uint64_t nv = v - code_base + (uint64_t)(uintptr_t)code;
        memcpy(cell, &nv, 8);
    } else if (data_len && v >= data_base && v < data_base + data_len) {
        uint64_t nv = v - data_base + (uint64_t)(uintptr_t)data;
        memcpy(cell, &nv, 8);
    }
}

static void bind_dsp0(uint8_t *data, uint64_t data_len, void *dsp) {
    uint64_t off;
    uint64_t v;
    if (data == NULL || dsp == NULL)
        return;
    v = (uint64_t)(uintptr_t)dsp;
    for (off = 0; off + 8 <= data_len; off += 8) {
        if (rd_u64(data + off) == EW_DSP0_MAGIC)
            memcpy(data + off, &v, 8);
    }
}

static uint8_t *alloc_rw(size_t n) {
    uint8_t *p = (uint8_t *)VirtualAlloc(NULL, n, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    if (!p)
        die("VirtualAlloc");
    return p;
}

static void exe_dir(void) {
    wchar_t path[MAX_PATH];
    DWORD n = GetModuleFileNameW(NULL, path, MAX_PATH);
    wchar_t *slash;
    if (n == 0 || n >= MAX_PATH)
        die("exe path");
    slash = wcsrchr(path, L'\\');
    if (!slash)
        die("exe dir");
    *(slash + 1) = 0;
    wcscpy_s(g_exe_dir, MAX_PATH, path);
}

static void default_img(wchar_t *out, size_t out_n) {
    if (wcscpy_s(out, out_n, g_exe_dir) != 0)
        die("path");
    if (wcscat_s(out, out_n, L"app.img") != 0)
        die("path");
}

static void apply_host_fix(uint8_t *code, uint64_t code_len) {
    wchar_t path[MAX_PATH];
    FILE *f;
    char line[128];
    if (wcscpy_s(path, MAX_PATH, g_exe_dir) != 0)
        return;
    if (wcscat_s(path, MAX_PATH, L"host.fix") != 0)
        return;
    f = _wfopen(path, L"r");
    if (!f)
        return;
    while (fgets(line, sizeof line, f)) {
        unsigned long off = 0;
        void *fn = NULL;
        if (sscanf(line, "putchar %lu", &off) == 1)
            fn = (void *)ew_putchar;
        else if (sscanf(line, "file %lu", &off) == 1)
            fn = (void *)ew_file_op;
        else
            continue;
        if (off + 8 > code_len) {
            fclose(f);
            die("host.fix offset");
        }
        memcpy(code + off, &fn, 8);
    }
    fclose(f);
}

static void write_dump(void) {
    wchar_t path[MAX_PATH];
    FILE *f;
    int y;
    int white = 0;
    int i;
    if (!g_dump)
        return;
    if (wcscpy_s(path, MAX_PATH, g_exe_dir) != 0)
        return;
    if (wcscat_s(path, MAX_PATH, L"last-grid.txt") != 0)
        return;
    f = _wfopen(path, L"w");
    if (!f)
        return;
    if (g_cells) {
        for (y = 0; y < g_rows; y++) {
            fwrite(g_cells + y * g_cols, 1, (size_t)g_cols, f);
            fputc('\n', f);
        }
    }
    if (g_pix) {
        for (i = 0; i < g_pix_n; i++) {
            if ((g_pix[i] & 0x00FFFFFFu) != 0)
                white++;
        }
    }
    fprintf(f, "pix %d\n", white);
    fclose(f);
    printf("emit-win: grid\n");
    if (g_cells) {
        for (y = 0; y < g_rows && y < 4; y++) {
            fwrite(g_cells + y * g_cols, 1, (size_t)g_cols, stdout);
            fputc('\n', stdout);
        }
    }
    printf("pix %d\n", white);
}

int main(int argc, char **argv) {
    const char *path = NULL;
    FILE *f;
    long flen;
    uint8_t *file;
    uint64_t code_len;
    uint64_t data_len;
    uint64_t entry_off;
    uint64_t reloc_n;
    uint64_t code_base;
    uint64_t data_base;
    uint64_t ptr_n;
    uint64_t host_bytes;
    const uint8_t *rel;
    const uint8_t *ptrs;
    uint8_t *code;
    uint8_t *data;
    uint8_t *gadget;
    uint8_t *stack;
    size_t code_bytes;
    uint64_t i;
    void *dsp;
    void *rp;
    void *cfa;
    wchar_t img_w[MAX_PATH];
    char img_a[MAX_PATH];

    slots_init();
    exe_dir();
    if (getenv("EMIT_WIN_DUMP") && getenv("EMIT_WIN_DUMP")[0] == '1')
        g_dump = 1;
    for (i = 1; (int)i < argc; i++) {
        if (strcmp(argv[i], "--dump") == 0)
            g_dump = 1;
        else if (argv[i][0] != '-' && !path)
            path = argv[i];
    }
    if (!path) {
        default_img(img_w, MAX_PATH);
        WideCharToMultiByte(CP_UTF8, 0, img_w, -1, img_a, MAX_PATH, NULL, NULL);
        path = img_a;
    }
    f = fopen(path, "rb");
    if (!f)
        die("open image");
    if (fseek(f, 0, SEEK_END) != 0)
        die("seek");
    flen = ftell(f);
    if (flen < 64)
        die("image too small");
    rewind(f);
    file = (uint8_t *)malloc((size_t)flen);
    if (!file || fread(file, 1, (size_t)flen, f) != (size_t)flen)
        die("read");
    fclose(f);
    if (memcmp(file, "64EMIT02", 8) != 0)
        die("bad magic");
    code_len = rd_u64(file + 16);
    data_len = rd_u64(file + 24);
    entry_off = rd_u64(file + 32);
    reloc_n = rd_u64(file + 40);
    code_base = rd_u64(file + 48);
    data_base = rd_u64(file + 56);
    rel = file + 64 + code_len + data_len;
    host_bytes = reloc_n * 8;
    if ((uint64_t)flen < 64 + code_len + data_len + host_bytes + 8)
        die("truncated image");
    ptr_n = rd_u64(rel + host_bytes);
    if ((uint64_t)flen < 64 + code_len + data_len + host_bytes + 8 + ptr_n * 8)
        die("truncated image (ptr)");

#ifdef _M_X64
    /* Code is padded to 4096. Data, including the register file, follows it. */
    if (data_len < 256)
        die("x64 image has no register file");
    code_bytes = (size_t)code_len;
    code = alloc_rw(code_bytes + (size_t)((data_len + 4095) & ~(uint64_t)4095));
    data = code + code_len;
#else
    code_bytes = (size_t)((code_len + EW_PAGE - 1) & ~(uint64_t)(EW_PAGE - 1));
    if (code_bytes < EW_PAGE)
        code_bytes = EW_PAGE;
    code = alloc_rw(code_bytes);
    data = alloc_rw(data_len ? (size_t)((data_len + 4095) & ~(uint64_t)4095) : 4096);
#endif
    memcpy(code, file + 64, (size_t)code_len);
    if (data_len)
        memcpy(data, file + 64 + code_len, (size_t)data_len);

    ptrs = rel + host_bytes + 8;
    for (i = 0; i < ptr_n; i++) {
        uint32_t off = rd_u32(ptrs + i * 8);
        uint32_t spc = rd_u32(ptrs + i * 8 + 4);
        uint8_t *cell = spc ? data + off : code + off;
        if (spc) {
            if ((uint64_t)off + 8 > data_len)
                die("ptr data off");
        } else if ((uint64_t)off + 8 > code_len) {
            die("ptr code off");
        }
        rebase_cell(cell, code_base, code_len, data_base, data_len, code, data);
    }
    for (i = 0; i < reloc_n; i++) {
        uint32_t off = rd_u32(rel + i * 8);
        uint32_t slot = rd_u32(rel + i * 8 + 4);
        uint64_t fn;
        if ((uint64_t)off + 8 > code_len)
            die("reloc off");
        if (slot >= EW_SLOTS || !g_slot[slot])
            die("reloc slot");
        fn = (uint64_t)(uintptr_t)g_slot[slot];
        memcpy(code + off, &fn, 8);
    }
    apply_host_fix(code, code_len);

    gadget = alloc_rw(EW_PAGE);
#ifdef _M_X64
    {
        uint8_t *regfile = data + data_len - 256;
        uint64_t x23 = (uint64_t)(uintptr_t)(regfile + 23 * 8);
        uint64_t *q;
        /* pop the Forth return stack (arm_x23) and jump to that address */
        gadget[0] = 0x48; gadget[1] = 0xB8;
        memcpy(gadget + 2, &x23, 8);
        gadget[10] = 0x48; gadget[11] = 0x8B; gadget[12] = 0x08;
        gadget[13] = 0x48; gadget[14] = 0x8B; gadget[15] = 0x11;
        gadget[16] = 0x48; gadget[17] = 0x83; gadget[18] = 0xC1; gadget[19] = 0x08;
        gadget[20] = 0x48; gadget[21] = 0x89; gadget[22] = 0x08;
        gadget[23] = 0xFF; gadget[24] = 0xE2;
        q = (uint64_t *)(gadget + 32);
        q[0] = (uint64_t)(uintptr_t)gadget;
        q[1] = (uint64_t)(uintptr_t)(gadget + 32);
    }
#else
    {
        uint32_t *ins = (uint32_t *)gadget;
        uint64_t *q = (uint64_t *)(gadget + 16);
        ins[0] = 0xF84086FE;
        ins[1] = 0xD65F03C0;
        q[0] = (uint64_t)(uintptr_t)gadget;
        q[1] = (uint64_t)(uintptr_t)(gadget + 16);
    }
#endif
    {
        DWORD oldp = 0;
        if (!VirtualProtect(code, code_bytes, PAGE_EXECUTE_READ, &oldp))
            die("protect code");
        if (!VirtualProtect(gadget, EW_PAGE, PAGE_EXECUTE_READ, &oldp))
            die("protect gadget");
    }
    FlushInstructionCache(GetCurrentProcess(), code, code_bytes);
    FlushInstructionCache(GetCurrentProcess(), gadget, 64);

    stack = alloc_rw(0x110000);
    dsp = stack + 0x100000 - 64;
    rp = (uint8_t *)dsp - 0x8000;
    bind_dsp0(data, data_len, dsp);
    cfa = code + entry_off;
#ifdef _M_X64
    run_itc(dsp, rp, cfa, gadget + 40, data + data_len - 256);
#else
    run_itc(dsp, rp, cfa, gadget + 24);
#endif
    write_dump();
    if (g_hwnd) {
        pump();
        if (!g_dump) {
            MSG msg;
            while (g_hwnd && GetMessageW(&msg, NULL, 0, 0) > 0) {
                TranslateMessage(&msg);
                DispatchMessageW(&msg);
            }
        } else {
            ew_close();
        }
    }
    return 0;
}
