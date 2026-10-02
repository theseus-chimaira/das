/* s6filter - canonicalize host/compiler assembly to DAIMOS S6REC. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define S6_TEXT_TYPE (1UL << 30)
#define S6_LINE_MAX 255U

static void put_host_word(FILE *out, unsigned long low, unsigned int high)
{
    unsigned int i;

    for (i = 0U; i < 4U; i++) {
        if (fputc((int)(low & 0377UL), out) == EOF) {
            perror("s6filter");
            exit(1);
        }
        low >>= 8;
    }
    if (fputc((int)(high & 017U), out) == EOF) {
        perror("s6filter");
        exit(1);
    }
    for (i = 5U; i < 8U; i++) {
        if (fputc(0, out) == EOF) {
            perror("s6filter");
            exit(1);
        }
    }
}

static int write_record(FILE *out, const char *line, unsigned int len)
{
    unsigned int i, slot, ch, shift, high;
    unsigned long low;

    put_host_word(out, S6_TEXT_TYPE | (unsigned long)len, 0U);
    slot = 0U;
    low = 0UL;
    high = 0U;
    for (i = 0U; i < len; i++) {
        ch = (unsigned int)(unsigned char)line[i];
        if (ch < 040U || ch > 0137U)
            return 1;
        ch -= 040U;
        shift = 30U - 6U * slot;
        if (shift == 30U) {
            low |= (unsigned long)(ch & 03U) << 30;
            high |= ch >> 2;
        } else {
            low |= (unsigned long)ch << shift;
        }
        slot++;
        if (slot == 6U) {
            put_host_word(out, low, high);
            slot = 0U;
            low = 0UL;
            high = 0U;
        }
    }
    if (slot != 0U)
        put_host_word(out, low, high);
    return ferror(out) ? 1 : 0;
}

static int semantic_lowercase(const char *line, unsigned int len, unsigned int i)
{
    unsigned int p;
    int quote, delim, in_comment, data_dir, seen_key;
    char key[8];
    unsigned int k;

    quote = 0; delim = 0; in_comment = 0; data_dir = 0; seen_key = 0;
    key[0] = 0; k = 0U;
    p = 0U;
    while (p < i) {
        if (line[p] == ';')
            return 0;
        p++;
    }
    p = 0U;
    while (p < len) {
        unsigned int ch = (unsigned int)(unsigned char)line[p];
        if (!quote && delim == 0 && ch == ';') in_comment = 1;
        if (in_comment) {
            if (p == i) return 1;
            p++; continue;
        }
        if (!seen_key) {
            if (ch == ':') { k = 0U; key[0] = 0; p++; continue; }
            if (ch == ' ' || ch == '\t' || ch == '.') { p++; continue; }
            while (p < len && line[p] != ' ' && line[p] != '\t' && line[p] != ':') {
                ch = (unsigned int)(unsigned char)line[p];
                if (k + 1U < sizeof(key)) {
                    if (ch >= 'a' && ch <= 'z') ch -= 'a' - 'A';
                    key[k++] = (char)ch; key[k] = 0;
                }
                p++;
            }
            if (p < len && line[p] == ':') { k = 0U; key[0] = 0; p++; continue; }
            seen_key = 1;
            data_dir = strcmp(key,"ASCII")==0 || strcmp(key,"ASCIZ")==0 || strcmp(key,"SIXBIT")==0;
            continue;
        }
        if (data_dir && delim == 0 && !quote && ch != ' ' && ch != '\t') {
            if (ch == '"' || ch == '\'') quote = 1;
            else delim = (int)ch;
            if (p == i) return 0;
            p++; continue;
        }
        if (delim != 0) {
            if ((int)ch == delim) delim = 0;
            else if (p == i) return 1;
            p++; continue;
        }
        if (quote) {
            if (ch == '"' || ch == '\'') quote = 0;
            else if (p == i) return 1;
            p++; continue;
        }
        if (ch == '"' || ch == '\'') { quote = 1; p++; continue; }
        if (p == i) return 0;
        p++;
    }
    return 0;
}

static int canonicalize_line(char *line, unsigned int len, unsigned int lineno)
{
    unsigned int i, ch;
    for (i = 0U; i < len; i++) {
        ch = (unsigned int)(unsigned char)line[i];
        if (ch == '\t') {
            line[i] = ' ';
            continue;
        }
        if (ch < 040U || ch > 0176U) {
            fprintf(stderr, "s6filter:%u: non-ASCII input byte 0x%02X\n", lineno, ch);
            return 1;
        }
        if (ch >= 'a' && ch <= 'z') {
            if (semantic_lowercase(line, len, i)) {
                fprintf(stderr, "s6filter:%u: lowercase in semantic text\n", lineno);
                return 1;
            }
            line[i] = (char)(ch - ('a' - 'A'));
            ch = (unsigned int)(unsigned char)line[i];
        }
        if (ch > 0137U) {
            fprintf(stderr, "s6filter:%u: character outside SIXBIT range\n", lineno);
            return 1;
        }
    }
    return 0;
}

static int filter_stream(FILE *in, FILE *out)
{
    char line[S6_LINE_MAX + 1U];
    unsigned int len, lineno;
    int ch, saw_cr;
    len = 0U; lineno = 1U; saw_cr = 0;
    for (;;) {
        ch = fgetc(in);
        if (ch == EOF) {
            if (ferror(in)) { perror("s6filter"); return 1; }
            if (saw_cr) { fprintf(stderr, "s6filter:%u: bare CR\n", lineno); return 1; }
            if (len != 0U) {
                line[len] = 0;
                if (canonicalize_line(line,len,lineno) || write_record(out,line,len)) return 1;
            }
            break;
        }
        if (saw_cr) {
            if (ch != '\n') { fprintf(stderr, "s6filter:%u: bare CR\n", lineno); return 1; }
            saw_cr = 0; ch = '\n';
        } else if (ch == '\r') { saw_cr = 1; continue; }
        if (ch == '\n') {
            line[len] = 0;
            if (canonicalize_line(line,len,lineno) || write_record(out,line,len)) return 1;
            len = 0U; lineno++; continue;
        }
        if (len >= S6_LINE_MAX) { fprintf(stderr, "s6filter:%u: input line too long\n", lineno); return 1; }
        line[len++] = (char)ch;
    }
    if (fflush(out) != 0) { perror("s6filter"); return 1; }
    return 0;
}

int main(int argc, char **argv)
{
    FILE *in = stdin;
    FILE *out = stdout;
    int rc;
    if (argc > 3) { fprintf(stderr, "usage: s6filter [input|- [output|-]]\n"); return 1; }
    if (argc >= 2 && strcmp(argv[1], "-") != 0) { in = fopen(argv[1], "rb"); if (!in) { perror(argv[1]); return 1; } }
    if (argc >= 3 && strcmp(argv[2], "-") != 0) { out = fopen(argv[2], "wb"); if (!out) { perror(argv[2]); if (in != stdin) fclose(in); return 1; } }
    rc = filter_stream(in,out);
    if (out != stdout && fclose(out) != 0) rc = 1;
    if (in != stdin) fclose(in);
    return rc;
}
