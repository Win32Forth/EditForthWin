/* Public domain.
   Executable pages for ALLOCATE-EXEC, FREE-EXEC, MPROTECT, and ICACHE-INVAL.
   Prot bits match the Mac kernel: 1=read, 2=write, 4=execute.
   ALLOCATE-EXEC memory starts read/write. MPROTECT 5 makes it read/execute.
   JIT-WPROTECT does not switch pages. Windows has no per-thread MAP_JIT mode. */

#include <stdint.h>
#include <string.h>
#include <windows.h>

static unsigned long long host_page(void)
{
    SYSTEM_INFO info;
    unsigned long long page;

    GetSystemInfo(&info);
    page = info.dwPageSize;
    if (page == 0)
        page = 4096;
    return page;
}

static DWORD host_win_prot(long long prot)
{
    int read = (prot & 1) != 0;
    int write = (prot & 2) != 0;
    int exec = (prot & 4) != 0;

    if (exec && write)
        return PAGE_EXECUTE_READWRITE;
    if (exec && read)
        return PAGE_EXECUTE_READ;
    if (exec)
        return PAGE_EXECUTE;
    if (write)
        return PAGE_READWRITE;
    if (read)
        return PAGE_READONLY;
    return PAGE_NOACCESS;
}

long long host_alloc_exec(unsigned long long n, void **out)
{
    unsigned long long page;
    unsigned long long mask;
    void *ptr;

    if (out != NULL)
        *out = NULL;
    page = host_page();
    if (n == 0)
        n = page;
    mask = page - 1;
    n = (n + mask) & ~mask;
    ptr = VirtualAlloc(NULL, (SIZE_T)n, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
    if (ptr == NULL)
        return -1;
    if (out != NULL)
        *out = ptr;
    return 0;
}

long long host_free_exec(void *addr, unsigned long long n)
{
    (void)n;
    if (addr == NULL)
        return 0;
    if (!VirtualFree(addr, 0, MEM_RELEASE))
        return -1;
    return 0;
}

long long host_mprotect(void *addr, unsigned long long n, long long prot)
{
    unsigned long long page;
    unsigned long long mask;
    unsigned long long base;
    unsigned long long end;
    DWORD old = 0;

    if (addr == NULL)
        return -1;
    page = host_page();
    mask = page - 1;
    base = (unsigned long long)addr & ~mask;
    end = (unsigned long long)addr + n;
    end = (end + mask) & ~mask;
    if (end <= base)
        end = base + page;
    if (!VirtualProtect((void *)base, (SIZE_T)(end - base), host_win_prot(prot), &old))
        return -(long long)GetLastError();
    return 0;
}

void host_icache_inval(void *addr, unsigned long long n)
{
    if (addr == NULL || n == 0)
        return;
    FlushInstructionCache(GetCurrentProcess(), addr, (SIZE_T)n);
}

/* Leaf that returns 7. ARM64 is movz x0,#7; ret. x64 is mov eax,7; ret. */
long long host_native_ret7(void *addr)
{
    if (addr == NULL)
        return -1;
#if defined(_M_ARM64)
    {
        unsigned int code[2];
        code[0] = 0xD28000E0u;
        code[1] = 0xD65F03C0u;
        memcpy(addr, code, sizeof code);
        return (long long)sizeof code;
    }
#elif defined(_M_X64)
    {
        static const unsigned char code[] = { 0xB8, 0x07, 0x00, 0x00, 0x00, 0xC3 };
        memcpy(addr, code, sizeof code);
        return (long long)sizeof code;
    }
#else
    return -1;
#endif
}
