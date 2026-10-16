/* Public domain.
   Character and pixel graphics window, image and file panels, and the
   small OOP window host. The kernel only calls these functions. */

#define COBJMACROS
#include <initguid.h>
#include <windows.h>
#include <commdlg.h>
#include <wincodec.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define GFX_JOB (WM_APP + 20)
#define GFX_COLS_MAX 256
#define GFX_ROWS_MAX 128
#define GFX_CELL_MAX (GFX_COLS_MAX * GFX_ROWS_MAX)
#define GFX_PIX_MAX (16 * 1024 * 1024)
#define KEY_MAX 64
#define OOP_MAX 32
#define PATH_MAX_UTF 4096

struct gfx_job {
    void (*fn)(void *);
    void *arg;
    HANDLE done;
};

struct oop_win {
    int used;
    HWND hwnd;
};

static CRITICAL_SECTION gfx_cs;
static CRITICAL_SECTION key_cs;
static HANDLE gfx_ready;
static DWORD gfx_tid;
static HWND g_hwnd;
static int g_opened;
static int g_headless;
static int g_cols;
static int g_rows;
static int g_cell_w;
static int g_cell_h;
static unsigned char g_cells[GFX_CELL_MAX];
static unsigned char *g_pix;
static int g_pix_bytes;
static int g_pix_w;
static int g_pix_h;
static int g_has_pix;
static HFONT g_font;
static long long g_keys[KEY_MAX];
static int g_key_n;
static long long g_mouse_x;
static long long g_mouse_y;
static long long g_mouse_b;
static long long g_pend_cols;
static long long g_pend_rows;
static int g_size_dirty;
static unsigned char *g_img;
static int g_img_w;
static int g_img_h;
static char g_staged[PATH_MAX_UTF];
static struct oop_win g_oop[OOP_MAX];
static long long g_events[KEY_MAX];
static int g_event_n;
static uint32_t g_pal[256];
static int g_pal_ready;

static void palette_init(void)
{
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

    if (g_pal_ready)
        return;
    for (i = 0; i < 16; i++) {
        g_pal[i] = (uint32_t)rgb16[i][2]
            | ((uint32_t)rgb16[i][1] << 8)
            | ((uint32_t)rgb16[i][0] << 16)
            | 0xFF000000u;
    }
    idx = 16;
    for (r = 0; r < 6; r++) {
        for (g = 0; g < 6; g++) {
            for (b = 0; b < 6; b++) {
                g_pal[idx++] = (uint32_t)(b * 51)
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
        g_pal[232 + i] = v | (v << 8) | (v << 16) | 0xFF000000u;
    }
    g_pal_ready = 1;
}

static void push_key(long long c)
{
    EnterCriticalSection(&key_cs);
    if (g_key_n < KEY_MAX)
        g_keys[g_key_n++] = c;
    LeaveCriticalSection(&key_cs);
}

static long long take_key(void)
{
    long long c = -1;
    int i;

    EnterCriticalSection(&key_cs);
    if (g_key_n > 0) {
        c = g_keys[0];
        for (i = 1; i < g_key_n; i++)
            g_keys[i - 1] = g_keys[i];
        g_key_n--;
    }
    LeaveCriticalSection(&key_cs);
    return c;
}

static void push_event(long long tag)
{
    EnterCriticalSection(&gfx_cs);
    if (g_event_n < KEY_MAX)
        g_events[g_event_n++] = tag;
    LeaveCriticalSection(&gfx_cs);
}

static long long take_event(void)
{
    long long tag = 0;
    int i;

    EnterCriticalSection(&gfx_cs);
    if (g_event_n > 0) {
        tag = g_events[0];
        for (i = 1; i < g_event_n; i++)
            g_events[i - 1] = g_events[i];
        g_event_n--;
    }
    LeaveCriticalSection(&gfx_cs);
    return tag;
}

static void expand_pixels(const unsigned char *src, int n, int depth, int w, int h)
{
    int need;
    int stride;
    int x;
    int y;
    int i;
    unsigned char *dst;
    const unsigned char *row;

    if (depth == 8) {
        stride = w;
        need = w * h;
    } else if (depth == 32) {
        stride = w * 4;
        need = w * h * 4;
    } else {
        depth = 1;
        stride = (w + 7) / 8;
        need = stride * h;
    }
    if (need <= 0 || need > GFX_PIX_MAX)
        return;
    dst = (unsigned char *)malloc((size_t)w * (size_t)h * 4u);
    if (dst == NULL)
        return;
    if (n > need)
        n = need;
    if (depth == 32) {
        memset(dst, 0, (size_t)w * (size_t)h * 4u);
        if (n > 0)
            memcpy(dst, src, (size_t)n);
        for (i = 3; i < w * h * 4; i += 4) {
            if (dst[i] == 0)
                dst[i] = 255;
        }
    } else if (depth == 8) {
        palette_init();
        for (i = 0; i < w * h; i++) {
            uint32_t c = 0xFF000000u;
            if (i < n)
                c = g_pal[src[i]];
            dst[i * 4] = (unsigned char)(c & 255);
            dst[i * 4 + 1] = (unsigned char)((c >> 8) & 255);
            dst[i * 4 + 2] = (unsigned char)((c >> 16) & 255);
            dst[i * 4 + 3] = 255;
        }
    } else {
        for (y = 0; y < h; y++) {
            row = src + y * stride;
            for (x = 0; x < w; x++) {
                int on = 0;
                int o = (y * w + x) * 4;
                if (y * stride + (x >> 3) < n)
                    on = (row[x >> 3] & (1 << (x & 7))) != 0;
                if (on) {
                    dst[o] = 178;
                    dst[o + 1] = 255;
                    dst[o + 2] = 178;
                    dst[o + 3] = 255;
                } else {
                    dst[o] = 0;
                    dst[o + 1] = 0;
                    dst[o + 2] = 0;
                    dst[o + 3] = 255;
                }
            }
        }
    }
    EnterCriticalSection(&gfx_cs);
    free(g_pix);
    g_pix = dst;
    g_pix_bytes = w * h * 4;
    g_pix_w = w;
    g_pix_h = h;
    g_has_pix = 1;
    LeaveCriticalSection(&gfx_cs);
}

static void paint_gfx(HWND hwnd)
{
    PAINTSTRUCT ps;
    HDC dc;
    RECT rc;
    int cols;
    int rows;
    int cw;
    int ch;
    int has;
    int pw;
    int ph;
    unsigned char *pix = NULL;
    unsigned char *cells = NULL;
    int i;
    HBRUSH brush;

    EnterCriticalSection(&gfx_cs);
    cols = g_cols;
    rows = g_rows;
    cw = g_cell_w;
    ch = g_cell_h;
    has = g_has_pix;
    pw = g_pix_w;
    ph = g_pix_h;
    if (cols > 0 && rows > 0) {
        cells = (unsigned char *)malloc((size_t)cols * (size_t)rows);
        if (cells != NULL)
            memcpy(cells, g_cells, (size_t)cols * (size_t)rows);
    }
    if (has && g_pix != NULL && pw > 0 && ph > 0) {
        pix = (unsigned char *)malloc((size_t)g_pix_bytes);
        if (pix != NULL)
            memcpy(pix, g_pix, (size_t)g_pix_bytes);
    }
    LeaveCriticalSection(&gfx_cs);

    dc = BeginPaint(hwnd, &ps);
    GetClientRect(hwnd, &rc);
    brush = CreateSolidBrush(RGB(0, 0, 0));
    FillRect(dc, &rc, brush);
    DeleteObject(brush);
    if (pix != NULL && rc.right > 0 && rc.bottom > 0) {
        BITMAPINFO bi;
        memset(&bi, 0, sizeof bi);
        bi.bmiHeader.biSize = sizeof bi.bmiHeader;
        bi.bmiHeader.biWidth = pw;
        bi.bmiHeader.biHeight = -ph;
        bi.bmiHeader.biPlanes = 1;
        bi.bmiHeader.biBitCount = 32;
        bi.bmiHeader.biCompression = BI_RGB;
        SetStretchBltMode(dc, COLORONCOLOR);
        StretchDIBits(dc, 0, 0, rc.right, rc.bottom, 0, 0, pw, ph,
                      pix, &bi, DIB_RGB_COLORS, SRCCOPY);
    }
    if (cells != NULL && g_font != NULL && cw > 0 && ch > 0) {
        SetBkMode(dc, TRANSPARENT);
        SetTextColor(dc, RGB(178, 255, 178));
        SelectObject(dc, g_font);
        for (i = 0; i < cols * rows; i++) {
            char chb[2];
            int col = i % cols;
            int row = i / cols;
            if (cells[i] == 0 || cells[i] == ' ')
                continue;
            chb[0] = (char)cells[i];
            chb[1] = 0;
            TextOutA(dc, col * cw, row * ch, chb, 1);
        }
    }
    EndPaint(hwnd, &ps);
    free(cells);
    free(pix);
}

static void note_mouse(HWND hwnd, int x, int y, WPARAM wp)
{
    RECT rc;
    int pw;
    int ph;
    long long px;
    long long py;
    long long buttons = 0;

    GetClientRect(hwnd, &rc);
    EnterCriticalSection(&gfx_cs);
    pw = g_has_pix ? g_pix_w : g_cols * 8;
    ph = g_has_pix ? g_pix_h : g_rows * 16;
    LeaveCriticalSection(&gfx_cs);
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
    if (wp & MK_LBUTTON)
        buttons |= 1;
    if (wp & MK_RBUTTON)
        buttons |= 2;
    if (wp & MK_MBUTTON)
        buttons |= 4;
    EnterCriticalSection(&gfx_cs);
    g_mouse_x = px;
    g_mouse_y = py;
    g_mouse_b = buttons;
    LeaveCriticalSection(&gfx_cs);
}

static LRESULT CALLBACK gfx_wnd(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg) {
    case WM_PAINT:
        paint_gfx(hwnd);
        return 0;
    case WM_ERASEBKGND:
        return 1;
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
    case WM_KEYDOWN:
        if (wp == VK_LEFT) {
            push_key(203);
            return 0;
        }
        if (wp == VK_RIGHT) {
            push_key(205);
            return 0;
        }
        if (wp == VK_UP) {
            push_key(200);
            return 0;
        }
        if (wp == VK_DOWN) {
            push_key(208);
            return 0;
        }
        if (wp == VK_ESCAPE) {
            push_key(27);
            return 0;
        }
        break;
    case WM_CHAR:
        if (wp > 0 && wp < 128 && wp != 27) {
            push_key((long long)wp);
            return 0;
        }
        break;
    case WM_EXITSIZEMOVE: {
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
        if (c > GFX_COLS_MAX)
            c = GFX_COLS_MAX;
        if (r > GFX_ROWS_MAX)
            r = GFX_ROWS_MAX;
        EnterCriticalSection(&gfx_cs);
        if (c != g_cols || r != g_rows) {
            g_pend_cols = c;
            g_pend_rows = r;
            g_size_dirty = 1;
        }
        LeaveCriticalSection(&gfx_cs);
        InvalidateRect(hwnd, NULL, FALSE);
        return 0;
    }
    case WM_CLOSE:
        push_key(27);
        DestroyWindow(hwnd);
        return 0;
    case WM_DESTROY:
        EnterCriticalSection(&gfx_cs);
        if (g_hwnd == hwnd) {
            g_hwnd = NULL;
            g_opened = 0;
        }
        LeaveCriticalSection(&gfx_cs);
        return 0;
    default:
        break;
    }
    return DefWindowProcW(hwnd, msg, wp, lp);
}

static int oop_from_hwnd(HWND hwnd)
{
    int i;
    for (i = 0; i < OOP_MAX; i++) {
        if (g_oop[i].used && g_oop[i].hwnd == hwnd)
            return i;
    }
    return -1;
}

static LRESULT CALLBACK oop_wnd(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    if (msg == WM_COMMAND) {
        push_event((long long)LOWORD(wp));
        return 0;
    }
    if (msg == WM_CLOSE) {
        DestroyWindow(hwnd);
        return 0;
    }
    if (msg == WM_DESTROY) {
        int i = oop_from_hwnd(hwnd);
        if (i >= 0) {
            g_oop[i].used = 0;
            g_oop[i].hwnd = NULL;
        }
        return 0;
    }
    return DefWindowProcW(hwnd, msg, wp, lp);
}

static DWORD WINAPI gfx_thread(LPVOID unused)
{
    MSG msg;
    WNDCLASSW wc;

    (void)unused;
    PeekMessageW(&msg, NULL, WM_USER, WM_USER, PM_NOREMOVE);
    CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
    memset(&wc, 0, sizeof wc);
    wc.lpfnWndProc = gfx_wnd;
    wc.hInstance = GetModuleHandleW(NULL);
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
    wc.lpszClassName = L"EditForthWinGraphics";
    wc.style = CS_HREDRAW | CS_VREDRAW;
    RegisterClassW(&wc);
    wc.lpfnWndProc = oop_wnd;
    wc.lpszClassName = L"EditForthWinOOP";
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    RegisterClassW(&wc);
    SetEvent(gfx_ready);
    while (GetMessageW(&msg, NULL, 0, 0) > 0) {
        if (msg.hwnd == NULL && msg.message == GFX_JOB) {
            struct gfx_job *job = (struct gfx_job *)msg.lParam;
            job->fn(job->arg);
            SetEvent(job->done);
            continue;
        }
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
    return 0;
}

static void gfx_ensure(void)
{
    if (gfx_ready != NULL)
        return;
    InitializeCriticalSection(&gfx_cs);
    InitializeCriticalSection(&key_cs);
    gfx_ready = CreateEventW(NULL, TRUE, FALSE, NULL);
    CreateThread(NULL, 0, gfx_thread, NULL, 0, &gfx_tid);
    WaitForSingleObject(gfx_ready, 5000);
}

static void gfx_call(void (*fn)(void *), void *arg)
{
    struct gfx_job job;

    gfx_ensure();
    job.fn = fn;
    job.arg = arg;
    job.done = CreateEventW(NULL, FALSE, FALSE, NULL);
    if (job.done == NULL)
        return;
    PostThreadMessageW(gfx_tid, GFX_JOB, 0, (LPARAM)&job);
    WaitForSingleObject(job.done, 60000);
    CloseHandle(job.done);
}

struct open_arg {
    int cols;
    int rows;
    long long ior;
};

static void open_on_ui(void *p)
{
    struct open_arg *a = p;
    int dpi;
    RECT rc;
    HWND hwnd;

    a->ior = -1;
    if (a->cols < 1)
        a->cols = 80;
    if (a->rows < 1)
        a->rows = 25;
    if (a->cols > GFX_COLS_MAX)
        a->cols = GFX_COLS_MAX;
    if (a->rows > GFX_ROWS_MAX)
        a->rows = GFX_ROWS_MAX;
    dpi = GetDpiForSystem();
    g_cell_w = MulDiv(8, dpi, 96);
    g_cell_h = MulDiv(16, dpi, 96);
    if (g_cell_w < 1)
        g_cell_w = 8;
    if (g_cell_h < 1)
        g_cell_h = 16;
    if (g_font != NULL)
        DeleteObject(g_font);
    g_font = CreateFontW(-g_cell_h, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
                          DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                          CLEARTYPE_QUALITY, FIXED_PITCH | FF_MODERN, L"Consolas");
    EnterCriticalSection(&gfx_cs);
    g_cols = a->cols;
    g_rows = a->rows;
    memset(g_cells, ' ', (size_t)g_cols * (size_t)g_rows);
    g_has_pix = 0;
    g_mouse_x = 0;
    g_mouse_y = 0;
    g_mouse_b = 0;
    g_size_dirty = 0;
    hwnd = g_hwnd;
    LeaveCriticalSection(&gfx_cs);
    EnterCriticalSection(&key_cs);
    g_key_n = 0;
    LeaveCriticalSection(&key_cs);
    rc.left = 0;
    rc.top = 0;
    rc.right = a->cols * g_cell_w;
    rc.bottom = a->rows * g_cell_h;
    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW, FALSE);
    if (hwnd == NULL) {
        hwnd = CreateWindowExW(0, L"EditForthWinGraphics", L"EditForthWin Graphics",
                                WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT,
                                rc.right - rc.left, rc.bottom - rc.top,
                                NULL, NULL, GetModuleHandleW(NULL), NULL);
        if (hwnd == NULL)
            return;
        EnterCriticalSection(&gfx_cs);
        g_hwnd = hwnd;
        g_opened = 1;
        LeaveCriticalSection(&gfx_cs);
        ShowWindow(hwnd, SW_SHOW);
    } else {
        SetWindowPos(hwnd, NULL, 0, 0, rc.right - rc.left, rc.bottom - rc.top,
                     SWP_NOMOVE | SWP_NOZORDER);
        EnterCriticalSection(&gfx_cs);
        g_opened = 1;
        LeaveCriticalSection(&gfx_cs);
        ShowWindow(hwnd, SW_SHOW);
    }
    UpdateWindow(hwnd);
    a->ior = 0;
}

void host_set_headless(int on)
{
    g_headless = on ? 1 : 0;
}

long long host_app_open(long long cols, long long rows)
{
    struct open_arg a;

    a.cols = (int)cols;
    a.rows = (int)rows;
    a.ior = -1;
    gfx_call(open_on_ui, &a);
    return a.ior;
}

static void close_on_ui(void *unused)
{
    HWND hwnd;

    (void)unused;
    EnterCriticalSection(&gfx_cs);
    hwnd = g_hwnd;
    g_opened = 0;
    g_hwnd = NULL;
    g_has_pix = 0;
    free(g_pix);
    g_pix = NULL;
    LeaveCriticalSection(&gfx_cs);
    if (hwnd != NULL)
        DestroyWindow(hwnd);
    push_key(27);
}

void host_app_close(void)
{
    gfx_call(close_on_ui, NULL);
}

void host_app_blit(const void *addr, long long nbytes)
{
    int need;
    HWND hwnd;

    if (addr == NULL || nbytes < 0)
        return;
    gfx_ensure();
    EnterCriticalSection(&gfx_cs);
    if (!g_opened || g_cols < 1 || g_rows < 1) {
        LeaveCriticalSection(&gfx_cs);
        return;
    }
    need = g_cols * g_rows;
    if (nbytes < need)
        need = (int)nbytes;
    if (need > 0)
        memcpy(g_cells, addr, (size_t)need);
    hwnd = g_hwnd;
    LeaveCriticalSection(&gfx_cs);
    if (hwnd != NULL)
        InvalidateRect(hwnd, NULL, FALSE);
}

void host_app_cblit(const void *addr, long long nbytes, long long depth)
{
    int w;
    int h;
    int d;
    HWND hwnd;

    if (addr == NULL || nbytes <= 0)
        return;
    gfx_ensure();
    EnterCriticalSection(&gfx_cs);
    if (!g_opened) {
        LeaveCriticalSection(&gfx_cs);
        return;
    }
    w = g_cols * 8;
    h = g_rows * 16;
    hwnd = g_hwnd;
    LeaveCriticalSection(&gfx_cs);
    if (w < 1 || h < 1)
        return;
    d = (int)depth;
    if (d != 8 && d != 32)
        d = 1;
    expand_pixels((const unsigned char *)addr, (int)nbytes, d, w, h);
    if (hwnd != NULL)
        InvalidateRect(hwnd, NULL, FALSE);
}

void host_app_pblit(const void *addr, long long nbytes)
{
    host_app_cblit(addr, nbytes, 1);
}

long long host_app_keyq(void)
{
    int n;

    gfx_ensure();
    EnterCriticalSection(&key_cs);
    n = g_key_n;
    LeaveCriticalSection(&key_cs);
    if (n == 0)
        Sleep(1);
    return n > 0 ? -1 : 0;
}

long long host_app_key(void)
{
    int i;
    long long c;

    gfx_ensure();
    c = take_key();
    if (c >= 0)
        return c;
    for (i = 0; i < 10; i++) {
        EnterCriticalSection(&gfx_cs);
        if (!g_opened) {
            LeaveCriticalSection(&gfx_cs);
            return 27;
        }
        LeaveCriticalSection(&gfx_cs);
        Sleep(50);
        c = take_key();
        if (c >= 0)
            return c;
    }
    return -1;
}

struct name_arg {
    wchar_t title[256];
};

static void name_on_ui(void *p)
{
    struct name_arg *a = p;
    HWND hwnd;

    EnterCriticalSection(&gfx_cs);
    hwnd = g_hwnd;
    LeaveCriticalSection(&gfx_cs);
    if (hwnd != NULL)
        SetWindowTextW(hwnd, a->title);
}

void host_app_name(const void *addr, long long nbytes)
{
    struct name_arg a;
    char tmp[256];
    int n = 0;

    if (addr != NULL && nbytes > 0) {
        if (nbytes > 255)
            nbytes = 255;
        memcpy(tmp, addr, (size_t)nbytes);
        n = (int)nbytes;
    }
    tmp[n] = 0;
    if (n == 0 || MultiByteToWideChar(CP_UTF8, 0, tmp, -1, a.title, 256) <= 0)
        wcscpy_s(a.title, 256, L"EditForthWin Graphics");
    gfx_call(name_on_ui, &a);
}

void host_app_tone(long long freq, long long dur)
{
    long long tenths;
    DWORD hz;

    tenths = dur;
    if (tenths < 0)
        tenths = 0;
    if (tenths > 50)
        tenths = 50;
    if (tenths == 0)
        return;
    hz = (DWORD)freq;
    if (hz < 37)
        hz = 37;
    if (hz > 32767)
        hz = 32767;
    Beep(hz, (DWORD)(tenths * 100));
}

void host_app_pump(void)
{
    Sleep(10);
}

void host_app_mouse(long long *x, long long *y, long long *buttons)
{
    gfx_ensure();
    EnterCriticalSection(&gfx_cs);
    if (!g_opened) {
        if (x != NULL)
            *x = 0;
        if (y != NULL)
            *y = 0;
        if (buttons != NULL)
            *buttons = 0;
        LeaveCriticalSection(&gfx_cs);
        return;
    }
    if (x != NULL)
        *x = g_mouse_x;
    if (y != NULL)
        *y = g_mouse_y;
    if (buttons != NULL)
        *buttons = g_mouse_b;
    LeaveCriticalSection(&gfx_cs);
}

long long host_app_size(long long *cols, long long *rows)
{
    long long flag = 0;

    gfx_ensure();
    EnterCriticalSection(&gfx_cs);
    if (cols != NULL)
        *cols = g_pend_cols;
    if (rows != NULL)
        *rows = g_pend_rows;
    if (g_size_dirty) {
        g_size_dirty = 0;
        flag = -1;
    }
    LeaveCriticalSection(&gfx_cs);
    return flag;
}

static int wic_load(const wchar_t *path)
{
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

    co = CoInitializeEx(NULL, COINIT_MULTITHREADED);
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
    if (bytes > GFX_PIX_MAX)
        goto fail;
    buf = (unsigned char *)malloc(bytes);
    if (buf == NULL)
        goto fail;
    hr = IWICBitmapSource_CopyPixels((IWICBitmapSource *)conv, NULL, stride, bytes, buf);
    if (FAILED(hr)) {
        free(buf);
        goto fail;
    }
    EnterCriticalSection(&gfx_cs);
    free(g_img);
    g_img = buf;
    g_img_w = (int)w;
    g_img_h = (int)h;
    LeaveCriticalSection(&gfx_cs);
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
    EnterCriticalSection(&gfx_cs);
    free(g_img);
    g_img = NULL;
    g_img_w = 0;
    g_img_h = 0;
    LeaveCriticalSection(&gfx_cs);
    if (own)
        CoUninitialize();
    return -2;
}

static int wide_from_forth(const void *addr, long long nbytes, wchar_t *dst, int cap)
{
    char tmp[PATH_MAX_UTF];
    int n;

    if (addr == NULL || nbytes <= 0 || cap < 2)
        return 0;
    if (nbytes >= PATH_MAX_UTF)
        nbytes = PATH_MAX_UTF - 1;
    memcpy(tmp, addr, (size_t)nbytes);
    tmp[nbytes] = 0;
    n = MultiByteToWideChar(CP_UTF8, 0, tmp, -1, dst, cap);
    return n > 0;
}

static void stage_wide(const wchar_t *path)
{
    int n = WideCharToMultiByte(CP_UTF8, 0, path, -1, g_staged, PATH_MAX_UTF, NULL, NULL);
    if (n <= 0)
        g_staged[0] = 0;
}

struct choose_arg {
    int save;
    int image;
    long long ior;
};

static void choose_on_ui(void *p)
{
    struct choose_arg *a = p;
    wchar_t file[1024];
    OPENFILENAMEW ofn;
    HWND owner;
    BOOL ok;

    a->ior = -2;
    file[0] = 0;
    memset(&ofn, 0, sizeof ofn);
    ofn.lStructSize = sizeof ofn;
    EnterCriticalSection(&gfx_cs);
    owner = g_hwnd;
    LeaveCriticalSection(&gfx_cs);
    ofn.hwndOwner = owner;
    ofn.lpstrFile = file;
    ofn.nMaxFile = 1024;
    if (a->image) {
        ofn.lpstrFilter = L"Images\0*.bmp;*.png;*.jpg;*.jpeg;*.gif;*.tif;*.tiff\0All files\0*.*\0";
        ofn.lpstrTitle = L"Open Image";
    } else if (a->save) {
        ofn.lpstrFilter = L"All files\0*.*\0Forth files\0*.fth;*.fs;*.4th;*.f;*.txt\0";
        ofn.lpstrTitle = L"Save File";
    } else {
        ofn.lpstrFilter = L"All files\0*.*\0Forth files\0*.fth;*.fs;*.4th;*.f;*.txt\0";
        ofn.lpstrTitle = L"Open File";
    }
    ofn.nFilterIndex = 1;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR;
    if (a->save) {
        ofn.Flags |= OFN_OVERWRITEPROMPT;
        ok = GetSaveFileNameW(&ofn);
    } else {
        ofn.Flags |= OFN_FILEMUSTEXIST;
        ok = GetOpenFileNameW(&ofn);
    }
    if (!ok) {
        a->ior = CommDlgExtendedError() ? -2 : -1;
        return;
    }
    stage_wide(file);
    if (a->image)
        a->ior = wic_load(file);
    else
        a->ior = 0;
}

long long host_app_img_choose(void)
{
    struct choose_arg a;

    if (g_headless)
        return -1;
    a.save = 0;
    a.image = 1;
    a.ior = -2;
    gfx_call(choose_on_ui, &a);
    return a.ior;
}

long long host_app_img_load(const void *path, long long nbytes)
{
    wchar_t wide[1024];

    if (!wide_from_forth(path, nbytes, wide, 1024))
        return -2;
    gfx_ensure();
    return wic_load(wide);
}

void host_app_img_size(long long *w, long long *h)
{
    gfx_ensure();
    EnterCriticalSection(&gfx_cs);
    if (w != NULL)
        *w = g_img_w;
    if (h != NULL)
        *h = g_img_h;
    LeaveCriticalSection(&gfx_cs);
}

long long host_app_img_render(void *dest, long long dest_w, long long dest_h,
                              long long cx, long long cy, long long zoom100)
{
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

    if (dest == NULL || dest_w <= 0 || dest_h <= 0)
        return -1;
    if (dest_w > 4096 || dest_h > 4096)
        return -1;
    gfx_ensure();
    EnterCriticalSection(&gfx_cs);
    if (g_img == NULL || g_img_w <= 0 || g_img_h <= 0) {
        LeaveCriticalSection(&gfx_cs);
        return -1;
    }
    iw = g_img_w;
    ih = g_img_h;
    img = (unsigned char *)malloc((size_t)iw * (size_t)ih * 4u);
    if (img == NULL) {
        LeaveCriticalSection(&gfx_cs);
        return -1;
    }
    memcpy(img, g_img, (size_t)iw * (size_t)ih * 4u);
    LeaveCriticalSection(&gfx_cs);
    dw = (int)dest_w;
    dh = (int)dest_h;
    z = (int)zoom100;
    if (z < 1)
        z = 1;
    half_w = dw / 2;
    half_h = dh / 2;
    out = (unsigned char *)dest;
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

long long host_app_file_choose(void)
{
    struct choose_arg a;

    if (g_headless)
        return -1;
    a.save = 0;
    a.image = 0;
    a.ior = -2;
    gfx_call(choose_on_ui, &a);
    return a.ior;
}

long long host_app_file_save_as(void)
{
    struct choose_arg a;

    if (g_headless)
        return -1;
    a.save = 1;
    a.image = 0;
    a.ior = -2;
    gfx_call(choose_on_ui, &a);
    return a.ior;
}

long long host_app_file_path(void *dest, long long max)
{
    size_t n;

    if (dest == NULL || max <= 0)
        return 0;
    gfx_ensure();
    n = strlen(g_staged);
    if (n > (size_t)max)
        n = (size_t)max;
    if (n > 0)
        memcpy(dest, g_staged, n);
    return (long long)n;
}

long long host_app_file_slurp(void *dest, long long max, long long *out_u)
{
    FILE *fp;
    long long n = 0;
    wchar_t wide[1024];

    if (out_u != NULL)
        *out_u = 0;
    if (dest == NULL || max <= 0)
        return -2;
    gfx_ensure();
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

long long host_app_file_spew(const void *src, long long nbytes)
{
    FILE *fp;
    wchar_t wide[1024];

    if (src == NULL || nbytes < 0)
        return -2;
    gfx_ensure();
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

struct oop_arg {
    long long a;
    long long b;
    long long c;
    long long d;
    long long op;
    long long result;
};

static wchar_t *wide_dup(long long addr, long long n)
{
    wchar_t *w;
    int len;

    if (addr == 0 || n <= 0)
        n = 0;
    if (n > 1024)
        n = 1024;
    w = (wchar_t *)malloc(2048);
    if (w == NULL)
        return NULL;
    if (n == 0) {
        w[0] = 0;
        return w;
    }
    len = MultiByteToWideChar(CP_UTF8, 0, (const char *)(uintptr_t)addr, (int)n, w, 1023);
    if (len < 0)
        len = 0;
    w[len] = 0;
    return w;
}

static void oop_on_ui(void *p)
{
    struct oop_arg *a = p;
    int i;
    int id;
    HWND hwnd;
    wchar_t *text;

    a->result = 0;
    if (a->op == 1 || a->op == 7) {
        for (i = 0; i < OOP_MAX; i++) {
            if (!g_oop[i].used)
                break;
        }
        if (i == OOP_MAX)
            return;
        if (a->op == 1) {
            hwnd = CreateWindowExW(0, L"EditForthWinOOP", L"EditForthWin",
                                    WS_OVERLAPPEDWINDOW, (int)a->a, (int)a->b,
                                    (int)a->c, (int)a->d, NULL, NULL,
                                    GetModuleHandleW(NULL), NULL);
        } else {
            HWND parent = NULL;
            id = (int)a->d - 1;
            if (id >= 0 && id < OOP_MAX && g_oop[id].used)
                parent = g_oop[id].hwnd;
            hwnd = CreateWindowExW(0, L"EditForthWinOOP", L"",
                                    WS_CHILD | WS_VISIBLE, (int)a->a, (int)a->b,
                                    (int)(a->c & 0xffff), (int)((a->c >> 16) & 0xffff),
                                    parent, NULL, GetModuleHandleW(NULL), NULL);
        }
        if (hwnd == NULL)
            return;
        g_oop[i].used = 1;
        g_oop[i].hwnd = hwnd;
        ShowWindow(hwnd, SW_SHOW);
        a->result = i + 1;
        return;
    }
    id = (int)a->a - 1;
    if (a->op == 2) {
        if (id >= 0 && id < OOP_MAX && g_oop[id].used)
            DestroyWindow(g_oop[id].hwnd);
        return;
    }
    id = (int)a->c - 1;
    if (id < 0 || id >= OOP_MAX || !g_oop[id].used)
        return;
    hwnd = g_oop[id].hwnd;
    if (a->op == 3) {
        text = wide_dup(a->a, a->b);
        if (text != NULL) {
            SetWindowTextW(hwnd, text);
            free(text);
        }
        return;
    }
    if (a->op == 4) {
        HMENU menu = GetMenu(hwnd);
        text = wide_dup(a->a, a->b);
        if (menu == NULL) {
            menu = CreateMenu();
            SetMenu(hwnd, menu);
        }
        if (text != NULL) {
            AppendMenuW(menu, MF_STRING, (UINT_PTR)(a->d & 0xffff), text);
            DrawMenuBar(hwnd);
            free(text);
        }
        return;
    }
    if (a->op == 5) {
        int tag = (int)(a->d & 0xffff);
        int x = (int)((a->d >> 16) & 0xffff);
        int y = (int)((a->d >> 32) & 0xffff);
        text = wide_dup(a->a, a->b);
        if (text != NULL) {
            CreateWindowExW(0, L"BUTTON", text, WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
                             x, y, 160, 28, hwnd, (HMENU)(INT_PTR)tag,
                             GetModuleHandleW(NULL), NULL);
            free(text);
        }
    }
}

long long host_oop_call(long long a, long long b, long long c, long long d, long long op)
{
    struct oop_arg arg;

    if (op == 6) {
        Sleep(50);
        return take_event();
    }
    arg.a = a;
    arg.b = b;
    arg.c = c;
    arg.d = d;
    arg.op = op;
    arg.result = 0;
    gfx_call(oop_on_ui, &arg);
    return arg.result;
}
