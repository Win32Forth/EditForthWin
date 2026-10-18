/* emit-win.c — Windows runner for a 64EMIT02 image. Public domain.
 * Separate from the Mac emit-run. Loads the image, binds HOST-APP slots,
 * and draws text and pixels into one window.
 *
 *   emit-win.exe [image.img]
 *   (no args: app.img beside the exe)
 *   EMIT_WIN_DUMP=1 writes last-grid.txt beside the exe.
 */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EW_MAGIC 0xC0DE000000000000ull
#define EW_SLOTS 33
#define EW_PAGE  0x10000u
#define EW_COLS_MAX 256
#define EW_ROWS_MAX 128
#define EW_KEYS 64

extern void run_itc(void *dsp, void *rp, void *cfa, void *body);

static int g_dump;
static int g_cols = 80;
static int g_rows = 25;
static unsigned char *g_cells;
static int g_cell_n;
static uint32_t *g_pix;
static int g_pix_w;
static int g_pix_h;
static int g_pix_n;
static struct { int x, y, w, h; COLORREF c; } g_sq[16];
static int g_sq_n;
static HWND g_hwnd;
static HFONT g_font;
static int g_keys[EW_KEYS];
static int g_key_n;
static wchar_t g_title[256] = L"Emit Win";
static wchar_t g_exe_dir[MAX_PATH];

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

static void paint(HDC dc) {
    int x;
    int y;
    RECT rc;
    char ch[2];

    GetClientRect(g_hwnd, &rc);
    FillRect(dc, &rc, (HBRUSH)(COLOR_WINDOW + 1));
    if (g_pix && g_pix_w > 0 && g_pix_h > 0 && g_sq_n == 0) {
        BITMAPINFO bmi;
        memset(&bmi, 0, sizeof bmi);
        bmi.bmiHeader.biSize = sizeof bmi.bmiHeader;
        bmi.bmiHeader.biWidth = g_pix_w;
        bmi.bmiHeader.biHeight = -g_pix_h;
        bmi.bmiHeader.biPlanes = 1;
        bmi.bmiHeader.biBitCount = 32;
        bmi.bmiHeader.biCompression = BI_RGB;
        SetDIBitsToDevice(dc, 0, 0, g_pix_w, g_pix_h, 0, 0, 0, g_pix_h,
                          g_pix, &bmi, DIB_RGB_COLORS);
    }
    {
        int s;
        for (s = 0; s < g_sq_n; s++) {
            RECT sr;
            HBRUSH br = CreateSolidBrush(g_sq[s].c);
            sr.left = g_sq[s].x;
            sr.top = g_sq[s].y;
            sr.right = g_sq[s].x + g_sq[s].w;
            sr.bottom = g_sq[s].y + g_sq[s].h;
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
    SetTextColor(dc, RGB(0, 0, 0));
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
            TextOutA(dc, x * 8, y * 16, ch, 1);
        }
    }
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
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
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
    rc.right = g_cols * 8;
    rc.bottom = g_rows * 16;
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
    g_pix_w = g_cols * 8;
    g_pix_h = g_rows * 16;
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
        pump();
        return 0;
    }
    if (depth != 8 && depth != 32)
        depth = 1;
    if (depth == 32) {
        int n = g_pix_w * g_pix_h * 4;
        int k;
        if (nbytes < n)
            n = (int)nbytes;
        for (k = 0; k < g_pix_w * g_pix_h; k++)
            g_pix[k] = 0xFFFFFFFFu;
        memcpy(g_pix, src, (size_t)n);
    } else if (depth == 8) {
        for (i = 0; i < g_pix_w * g_pix_h; i++) {
            unsigned char c = (i < nbytes) ? src[i] : 0;
            g_pix[i] = 0xFF000000u | ((uint32_t)c << 16) | ((uint32_t)c << 8) | c;
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
    if (xp) *(long long *)(uintptr_t)xp = 0;
    if (yp) *(long long *)(uintptr_t)yp = 0;
    if (bp) *(long long *)(uintptr_t)bp = 0;
    return 0;
}

static long long ew_size(long long cp, long long rp) {
    (void)cp;
    (void)rp;
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
    g_slot[26] = (void *)ew_size;
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

    code_bytes = (size_t)((code_len + EW_PAGE - 1) & ~(uint64_t)(EW_PAGE - 1));
    if (code_bytes < EW_PAGE)
        code_bytes = EW_PAGE;
    code = alloc_rw(code_bytes);
    data = alloc_rw(data_len ? (size_t)((data_len + 4095) & ~(uint64_t)4095) : 4096);
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
    {
        uint32_t *ins = (uint32_t *)gadget;
        uint64_t *q = (uint64_t *)(gadget + 16);
        ins[0] = 0xF84086FE;
        ins[1] = 0xD65F03C0;
        q[0] = (uint64_t)(uintptr_t)gadget;
        q[1] = (uint64_t)(uintptr_t)(gadget + 16);
    }
    {
        DWORD oldp = 0;
        if (!VirtualProtect(code, code_bytes, PAGE_EXECUTE_READ, &oldp))
            die("protect code");
        if (!VirtualProtect(gadget, EW_PAGE, PAGE_EXECUTE_READ, &oldp))
            die("protect gadget");
    }
    FlushInstructionCache(GetCurrentProcess(), code, code_bytes);
    FlushInstructionCache(GetCurrentProcess(), gadget, 32);

    stack = alloc_rw(0x110000);
    dsp = stack + 0x100000 - 64;
    rp = (uint8_t *)dsp - 0x8000;
    cfa = code + entry_off;
    run_itc(dsp, rp, cfa, gadget + 24);
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
