#ifndef DAS_NATIVE_RUNTIME_H
#define DAS_NATIVE_RUNTIME_H

#include "dsys.h"
#include "exec.h"

#define DSYS_STDIN 0
#define DSYS_STDOUT 1
#define DSYS_STDERR 2

#define DAS_NATIVE_PATH_WORDS 18U
#define DAS_NATIVE_PATH_MAX_CHARS SYS_RUN_PATH_MAX_CHARS
#define KPATH_MAX_CHARS DAS_NATIVE_PATH_MAX_CHARS

static int das_native_diag(unsigned int code)
{
    unsigned int shift;
    int rc;

    code &= 077777U;
    if (dsys_writechar(DSYS_STDERR, 'D') < 0)
        return -1;
    shift = 12U;
    for (;;) {
        rc = dsys_writechar(DSYS_STDERR,
            (int)('0' + ((code >> shift) & 07U)));
        if (rc < 0 || shift == 0U)
            break;
        shift -= 3U;
    }
    if (rc >= 0)
        rc = dsys_writechar(DSYS_STDERR, '\n');
    return rc;
}

#ifndef NULL
#define NULL 0
#endif

#ifndef EOF
#define EOF (-1)
#endif

#define SEEK_SET SYS_SEEK_SET
#define SEEK_CUR SYS_SEEK_CUR
#define SEEK_END SYS_SEEK_END

typedef unsigned int size_t;

typedef struct das_native_file {
    int fd;
    int error;
    int used;
} FILE;

#define DAS_NATIVE_FILE_SLOTS 12U
static FILE das_native_files[DAS_NATIVE_FILE_SLOTS];
static FILE das_native_stderr = { DSYS_STDERR, 0, 1 };
#define stderr (&das_native_stderr)

static int das_native_is_space(int c)
{
    return c == ' ' || c == '\t' || c == '\n' || c == '\r' ||
        c == '\f' || c == '\v';
}

static int das_native_is_alpha(int c)
{
    return c >= 'A' && c <= 'Z';
}

static int das_native_is_digit(int c)
{
    return c >= '0' && c <= '9';
}

static int das_native_is_alnum(int c)
{
    return das_native_is_alpha(c) || das_native_is_digit(c);
}

#define isspace(c) das_native_is_space((int)(c))
#define isalpha(c) das_native_is_alpha((int)(c))
#define isalnum(c) das_native_is_alnum((int)(c))
#define isdigit(c) das_native_is_digit((int)(c))

static size_t strlen(const char *s)
{
    size_t n;

    n = 0U;
    while (s[n] != 0)
        n++;
    return n;
}

static int strcmp(const char *a, const char *b)
{
    while (*a != 0 && *a == *b) {
        a++;
        b++;
    }
    return (unsigned char)*a - (unsigned char)*b;
}

static void das_native_memset(unsigned char *dst, int ch, size_t n)
{
    while (n != 0U) {
        *dst++ = (unsigned char)ch;
        n--;
    }
}
#define memset(d,c,n) das_native_memset((unsigned char *)(d), (c), (n))

static void das_native_memcpy(unsigned char *dst, const unsigned char *src,
                              size_t n)
{
    while (n != 0U) {
        *dst++ = *src++;
        n--;
    }
}
#define memcpy(d,s,n) \
    das_native_memcpy((unsigned char *)(d), (const unsigned char *)(s), (n))

static void das_native_memmove(unsigned char *dst, const unsigned char *src,
                               size_t n)
{
    if (dst < src) {
        while (n != 0U) {
            *dst++ = *src++;
            n--;
        }
    } else if (dst > src) {
        dst += n;
        src += n;
        while (n != 0U) {
            *--dst = *--src;
            n--;
        }
    }
}
#define memmove(d,s,n) \
    das_native_memmove((unsigned char *)(d), (const unsigned char *)(s), (n))

static char *strchr(const char *s, int ch)
{
    while (*s != 0) {
        if ((unsigned char)*s == (unsigned char)ch)
            return (char *)s;
        s++;
    }
    return ch == 0 ? (char *)s : NULL;
}

static char *strrchr(const char *s, int ch)
{
    const char *last;

    last = NULL;
    do {
        if ((unsigned char)*s == (unsigned char)ch)
            last = s;
    } while (*s++ != 0);
    return (char *)last;
}

static char *strstr(const char *hay, const char *needle)
{
    const char *h;
    const char *n;

    if (*needle == 0)
        return (char *)hay;
    while (*hay != 0) {
        h = hay;
        n = needle;
        while (*h != 0 && *n != 0 && *h == *n) {
            h++;
            n++;
        }
        if (*n == 0)
            return (char *)hay;
        hay++;
    }
    return NULL;
}

static unsigned long das_native_strtoul(const char *s, char **endp, int base)
{
    unsigned long v;
    int d;

    v = 0UL;
    for (;;) {
        if (*s >= '0' && *s <= '9')
            d = *s - '0';
        else if (*s >= 'A' && *s <= 'F')
            d = *s - 'A' + 10;
        else if (*s >= 'a' && *s <= 'f')
            d = *s - 'a' + 10;
        else
            break;
        if (d >= base)
            break;
        v = v * (unsigned long)base + (unsigned long)d;
        s++;
    }
    if (endp != NULL)
        *endp = (char *)s;
    return v;
}

#define strtoul(s,e,b) das_native_strtoul((s),(e),(b))

static int das_native_pack_path(const char *src, kword_t *dst)
{
    unsigned int count;
    unsigned int slot;
    unsigned int pos;
    unsigned int ch;
    unsigned int i;

    for (i = 0U; i < DAS_NATIVE_PATH_WORDS; i++)
        dst[i] = 0UL;
    count = 0U;
    while (*src != 0) {
        ch = (unsigned int)(unsigned char)*src++;
        if (ch >= 'a' && ch <= 'z')
            ch = ch - 'a' + 'A';
        if (ch < 040U || ch > 0137U || count >= DAS_NATIVE_PATH_MAX_CHARS)
            return 1;
        slot = 1U + count / 6U;
        pos = count % 6U;
        ch = (ch - 040U) & 077U;
        dst[slot] |= (kword_t)ch << (30U - pos * 6U);
        count++;
    }
    if (count == 0U)
        return 1;
    dst[0] = (kword_t)count;
    return 0;
}

static FILE *das_native_alloc_file(int fd)
{
    unsigned int i;

    for (i = 0U; i < DAS_NATIVE_FILE_SLOTS; i++) {
        if (!das_native_files[i].used) {
            das_native_files[i].fd = fd;
            das_native_files[i].error = 0;
            das_native_files[i].used = 1;
            return &das_native_files[i];
        }
    }
    return NULL;
}

static FILE *fopen(const char *path, const char *mode)
{
    kword_t packed[DAS_NATIVE_PATH_WORDS];
    int flags;
    int fd;
    FILE *f;

    if (das_native_pack_path(path, packed) != 0)
        return NULL;
    flags = SYS_O_RDONLY;
    if (mode[0] == 'w')
        flags = SYS_O_WRONLY | SYS_O_CREAT | SYS_O_TRUNC;
    else if (mode[0] == 'r' && strchr(mode, '+') != NULL)
        flags = SYS_O_RDWR;
    if (mode[0] == 'w' && strchr(mode, '+') != NULL)
        flags = SYS_O_RDWR | SYS_O_CREAT | SYS_O_TRUNC;
    fd = dsys_open(packed, flags);
    if (fd < 0)
        return NULL;
    f = das_native_alloc_file(fd);
    if (f == NULL) {
        (void)dsys_close(fd);
        return NULL;
    }
    return f;
}

static int fclose(FILE *f)
{
    int rc;

    if (f == NULL || !f->used)
        return EOF;
    rc = dsys_close(f->fd);
    f->used = 0;
    if (rc < 0) {
        f->error = 1;
        return EOF;
    }
    return 0;
}

static int fseek(FILE *f, long off, int whence)
{
    kword_t rc;

    rc = dsys_seek(f->fd, (kword_t)off, whence);
    if (rc == (kword_t)-1) {
        f->error = 1;
        return -1;
    }
    return 0;
}

#define fflush(f) (0)

static int remove(const char *path)
{
    kword_t packed[DAS_NATIVE_PATH_WORDS];

    if (das_native_pack_path(path, packed) != 0)
        return -1;
    return dsys_unlink(packed) < 0 ? -1 : 0;
}

#define fprintf(file_, code_, ...) \
    das_native_diag((unsigned int)(code_))

#define perror(s) \
    ((void)das_native_diag((unsigned int)(__LINE__ & 077777U)))

#define exit(status_) ((void)dsys_exit((status_)))

#endif /* DAS_NATIVE_RUNTIME_H */
