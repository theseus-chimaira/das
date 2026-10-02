/*
 * s6text - host-side DAIMOS S6REC text converter.
 *
 * This is deliberately C89.  PDP-10 words are represented as a 32-bit
 * low part plus the remaining four high bits, avoiding long long.
 *
 * Plain input for --encode must already be DAIMOS SIXBIT-safe:
 * characters 040 through 0137 octal, plus CR/LF line separators.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define S6REC_TEXT     (1UL << 30)
#define S6REC_LEN_MASK 077777777UL
#define S6_LINE_MAX    S6REC_LEN_MASK

struct word36 {
    unsigned long lo;
    unsigned int hi;
};

static int
write_word(FILE *out, struct word36 w)
{
    unsigned int i;
    unsigned long v;

    v = w.lo;
    for (i = 0; i < 4; i++) {
        if (fputc((int)(v & 0377UL), out) == EOF)
            return -1;
        v >>= 8;
    }
    if (fputc((int)(w.hi & 017U), out) == EOF)
        return -1;
    for (i = 0; i < 3; i++) {
        if (fputc(0, out) == EOF)
            return -1;
    }
    return 0;
}

static int
read_word(FILE *in, struct word36 *wp)
{
    unsigned int i;
    int ch;
    unsigned long lo;

    lo = 0UL;
    for (i = 0; i < 4; i++) {
        ch = fgetc(in);
        if (ch == EOF) {
            if (i == 0 && !ferror(in))
                return 0;
            return -1;
        }
        lo |= ((unsigned long)(unsigned int)ch) << (8U * i);
    }
    ch = fgetc(in);
    if (ch == EOF || (ch & 0360) != 0)
        return -1;
    wp->hi = (unsigned int)ch;
    for (i = 0; i < 3; i++) {
        ch = fgetc(in);
        if (ch == EOF || ch != 0)
            return -1;
    }
    wp->lo = lo;
    return 1;
}

static int
safe_char(int ch)
{
    return ch >= 040 && ch <= 0137;
}

static void
put_sixbit(struct word36 *wp, unsigned int slot, unsigned int value)
{
    if (slot == 0U) {
        wp->lo |= ((unsigned long)(value & 03U)) << 30;
        wp->hi |= value >> 2;
    } else {
        wp->lo |= ((unsigned long)value) << (30U - 6U * slot);
    }
}

static unsigned int
get_sixbit(struct word36 w, unsigned int slot)
{
    if (slot == 0U)
        return ((w.hi & 017U) << 2) | (unsigned int)((w.lo >> 30) & 03UL);
    return (unsigned int)((w.lo >> (30U - 6U * slot)) & 077UL);
}

static int
flush_record(FILE *out, const unsigned char *line, unsigned long len)
{
    struct word36 w;
    unsigned long i;
    unsigned int slot;

    if (len > S6_LINE_MAX)
        return -1;

    w.lo = S6REC_TEXT | len;
    w.hi = 0U;
    if (write_word(out, w) != 0)
        return -1;

    w.lo = 0UL;
    w.hi = 0U;
    slot = 0U;
    for (i = 0UL; i < len; i++) {
        put_sixbit(&w, slot, (unsigned int)(line[i] - 040U));
        slot++;
        if (slot == 6U) {
            if (write_word(out, w) != 0)
                return -1;
            w.lo = 0UL;
            w.hi = 0U;
            slot = 0U;
        }
    }
    if (slot != 0U && write_word(out, w) != 0)
        return -1;
    return 0;
}

static int
encode_stream(FILE *in, FILE *out)
{
    unsigned char *line;
    unsigned long cap;
    unsigned long len;
    unsigned long lineno;
    int ch;

    cap = 256UL;
    line = (unsigned char *)malloc((size_t)cap);
    if (line == NULL)
        return -1;
    len = 0UL;
    lineno = 1UL;

    for (;;) {
        ch = fgetc(in);
        if (ch == EOF) {
            if (ferror(in)) {
                free(line);
                return -1;
            }
            if (len != 0UL && flush_record(out, line, len) != 0) {
                free(line);
                return -1;
            }
            break;
        }
        if (ch == '\r')
            continue;
        if (ch == '\n') {
            if (flush_record(out, line, len) != 0) {
                free(line);
                return -1;
            }
            len = 0UL;
            lineno++;
            continue;
        }
        if (!safe_char(ch)) {
            fprintf(stderr,
                "s6text: line %lu: byte 0x%02x is not SIXBIT-safe\n",
                lineno, (unsigned int)ch & 0377U);
            free(line);
            return -1;
        }
        if (len == S6_LINE_MAX) {
            fprintf(stderr, "s6text: line %lu is too long\n", lineno);
            free(line);
            return -1;
        }
        if (len == cap) {
            unsigned long ncap;
            unsigned char *nline;

            ncap = cap * 2UL;
            if (ncap < cap || ncap > S6_LINE_MAX)
                ncap = S6_LINE_MAX;
            nline = (unsigned char *)realloc(line, (size_t)ncap);
            if (nline == NULL) {
                free(line);
                return -1;
            }
            line = nline;
            cap = ncap;
        }
        line[len++] = (unsigned char)ch;
    }
    free(line);
    return 0;
}

static int
record_header(struct word36 w, unsigned long *lenp)
{
    unsigned long allowed;

    allowed = S6REC_TEXT | S6REC_LEN_MASK;
    if (w.hi != 0U)
        return -1;
    if ((w.lo & S6REC_TEXT) == 0UL)
        return -1;
    if ((w.lo & ~allowed) != 0UL)
        return -1;
    *lenp = w.lo & S6REC_LEN_MASK;
    return 0;
}

static int
read_record(FILE *in, FILE *out, int emit)
{
    struct word36 h;
    struct word36 w;
    unsigned long len;
    unsigned long i;
    unsigned int slot;
    unsigned int value;
    int rc;

    rc = read_word(in, &h);
    if (rc <= 0)
        return rc;
    if (record_header(h, &len) != 0)
        return -1;

    w.lo = 0UL;
    w.hi = 0U;
    slot = 6U;
    for (i = 0UL; i < len; i++) {
        if (slot == 6U) {
            rc = read_word(in, &w);
            if (rc != 1)
                return -1;
            slot = 0U;
        }
        value = get_sixbit(w, slot++);
        if (emit && fputc((int)(value + 040U), out) == EOF)
            return -1;
    }
    if (emit && fputc('\n', out) == EOF)
        return -1;
    return 1;
}

static int
decode_stream(FILE *in, FILE *out, int emit)
{
    int rc;

    for (;;) {
        rc = read_record(in, out, emit);
        if (rc == 0)
            break;
        if (rc < 0)
            return -1;
    }
    return 0;
}

static void
usage(const char *prog)
{
    fprintf(stderr,
        "usage: %s --encode INPUT OUTPUT\n"
        "       %s --decode INPUT OUTPUT\n"
        "       %s --check INPUT\n",
        prog, prog, prog);
}

int
main(int argc, char **argv)
{
    FILE *in;
    FILE *out;
    int rc;

    if (argc == 3 && strcmp(argv[1], "--check") == 0) {
        in = fopen(argv[2], "rb");
        if (in == NULL) {
            perror(argv[2]);
            return 1;
        }
        rc = decode_stream(in, (FILE *)0, 0);
        if (fclose(in) != 0)
            rc = -1;
        if (rc != 0) {
            fprintf(stderr, "s6text: invalid S6REC input: %s\n", argv[2]);
            return 1;
        }
        return 0;
    }

    if (argc != 4 ||
        (strcmp(argv[1], "--encode") != 0 &&
         strcmp(argv[1], "--decode") != 0)) {
        usage(argv[0]);
        return 1;
    }

    in = fopen(argv[2], strcmp(argv[1], "--encode") == 0 ? "rb" : "rb");
    if (in == NULL) {
        perror(argv[2]);
        return 1;
    }
    out = fopen(argv[3], strcmp(argv[1], "--encode") == 0 ? "wb" : "wb");
    if (out == NULL) {
        perror(argv[3]);
        fclose(in);
        return 1;
    }

    if (strcmp(argv[1], "--encode") == 0)
        rc = encode_stream(in, out);
    else
        rc = decode_stream(in, out, 1);

    if (fclose(in) != 0)
        rc = -1;
    if (fclose(out) != 0)
        rc = -1;
    if (rc != 0) {
        fprintf(stderr, "s6text: conversion failed\n");
        return 1;
    }
    return 0;
}
