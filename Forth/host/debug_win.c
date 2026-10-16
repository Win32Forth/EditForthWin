/* Public domain. Editor debug span for DBG-HOST-SPAN / DBG-HOST-PAINT. */

#include <stdint.h>

static int64_t span_off;
static int64_t span_len;

void host_debug_set_span(int64_t off, int64_t len)
{
    span_off = off;
    span_len = len;
}

void host_debug_get_span(int64_t *off, int64_t *len)
{
    if (off != 0)
        *off = span_off;
    if (len != 0)
        *len = span_len;
}

void host_debug_paint(void)
{
}
