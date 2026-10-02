#if defined(DAS_HOST) && defined(DAS_NATIVE)
#error DAS_HOST and DAS_NATIVE are mutually exclusive
#endif
#if !defined(DAS_HOST) && !defined(DAS_NATIVE)
#error define exactly one of DAS_HOST or DAS_NATIVE
#endif

#ifdef DAS_HOST
#define _POSIX_C_SOURCE 200809L
#define DAS_ENABLE_OPTIMIZER 1
#else
#define DAS_ENABLE_OPTIMIZER 0
#endif
/* das - DAIMOS DXR V1 assembler, first cut. */
#ifdef DAS_NATIVE
#ifndef DAS_NATIVE_CORE_ONLY
#include "das_native_runtime.h"
#endif
#elif defined(DAS_HOST)
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#endif

#define DAS_CAT_I(a,b) a##b
#define DAS_CAT(a,b) DAS_CAT_I(a,b)
#ifdef DAS_NATIVE
typedef unsigned long das_word_t;
#define DAS_W(x) DAS_CAT(x,UL)
#else
typedef unsigned long long das_word_t;
#define DAS_W(x) DAS_CAT(x,ULL)
#endif

#define DAS_WORD_MASK DAS_W(0777777777777)
#define DAS_HALF_MASK 0777777U
#define DAS_MAX_LINE 256
#define DAS_MAX_NAME 39
#define DAS_CHAR_INPUT_BUFFER 128U
#define DAS_WORD_INPUT_BUFFER 32U
#define DAS_OUTPUT_BUFFER_WORDS 64U
#define DAS_SEC_ABS 0
#define DAS_SEC_TEXT 1
#define DAS_SEC_DATA 2
#define DAS_SEC_BSS 3
#define DAS_SEC_REL 4
#define DAS_SYM_SEC_MASK 07
#define DAS_SYM_KIND_EQU 010
#define DAS_SYM_KIND_SET 020
#define DAS_SYM_KIND_VIS 030
#define DAS_SYM_KIND_MASK 030

#define DAS_OPT_GUARD_NEXT 01U
#define DAS_OPT_GUARD_XCT_TABLE 02U
#define DAS_RELOC_NONE 0
#define DAS_RELOC_ADDR18 1
#define DAS_OBJ_RELOC_LOCAL_RH18 1
#define DAS_OBJ_RELOC_SYMBOL_RH18 2
#define DAS_OBJ_RELOC_LOCAL_LH18  3
#define DAS_OBJ_RELOC_SYMBOL_LH18 4
#define DAS_MAGIC_DXR ((((das_word_t)044) << 12) | (((das_word_t)070) << 6) | DAS_W(062))
#define DAS_WORD(lh,rh) ((((das_word_t)((lh) & DAS_HALF_MASK)) << 18) | ((das_word_t)((rh) & DAS_HALF_MASK)))
#define DAS_MASK18(x) ((unsigned int)(x) & DAS_HALF_MASK)
#define DAS_CH(c) ((das_word_t)(((c) >= 'a' && (c) <= 'z') ? ((c) - 'a' + 1) : ((c) - 'A' + 1)))
#define DAS_OP2(a,b) ((((DAS_CH(a)) & 077UL) << 6) | ((DAS_CH(b)) & 077UL))
#define DAS_OP3(a,b,c) ((((DAS_CH(a)) & 077UL) << 12) | (((DAS_CH(b)) & 077UL) << 6) | ((DAS_CH(c)) & 077UL))
#define DAS_OP4(a,b,c,d) ((DAS_OP3((a),(b),(c)) << 6) | ((DAS_CH(d)) & 077UL))
#define DAS_OP5(a,b,c,d,e) ((DAS_OP4((a),(b),(c),(d)) << 6) | ((DAS_CH(e)) & 077UL))
#define DAS_OP6(a,b,c,d,e,f) ((DAS_OP5((a),(b),(c),(d),(e)) << 6) | ((DAS_CH(f)) & 077UL))

#ifdef DAS_NATIVE
#define DAS_DIAG(short_msg, long_msg) ((unsigned int)(__LINE__ & 077777U))
#else
#define DAS_DIAG(short_msg, long_msg) long_msg
#endif

#define DAS_INPUT_OK 1
#define DAS_INPUT_EOF 0
#define DAS_INPUT_ERROR -1
#define DAS_INPUT_TOOLONG -2
#define DAS_INPUT_ASCII 0
#define DAS_INPUT_S6REC 1
#define DAS_S6REC_COUNT_MASK DAS_W(077777777)
#define DAS_S6REC_TYPE_SHIFT 30U
#define DAS_S6REC_TYPE_MASK 077U
#define DAS_S6REC_TEXT 1U

struct das_char_reader {
    int (*get)(void *arg, unsigned int *ch);
    void *arg;
    unsigned int cstate;
};

#define DAS_CSTATE_COMMENT 01U
#define DAS_QUOTE_ESCAPE 0200U

#if !defined(DAS_NATIVE_PHASE2_ONLY)
/* Strip GAS C-style comments in-place.  Only the multi-line comment bit is
 * retained between lines; quote/escape state is line-local by definition.
 */
static void das_strip_c_comments(char *line, unsigned int *state)
{
    char *src;
    char *dst;
    unsigned int quote;

    src = line;
    dst = line;
    quote = 0U;
    while (*src != 0) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)*src++;
        if ((*state & DAS_CSTATE_COMMENT) != 0U) {
            if (ch == '*' && *src == '/') {
                *state &= ~DAS_CSTATE_COMMENT;
                src++;
            }
            continue;
        }
        if (quote != 0U) {
            *dst++ = (char)ch;
            if ((quote & DAS_QUOTE_ESCAPE) != 0U)
                quote &= 0177U;
            else if (ch == '\\')
                quote |= DAS_QUOTE_ESCAPE;
            else if (ch == (quote & 0177U))
                quote = 0U;
            continue;
        }
        if (ch == '\'' || ch == '"') {
            quote = ch;
            *dst++ = (char)ch;
            continue;
        }
        if (ch == '/' && *src == '*') {
            *dst++ = ' ';
            *state |= DAS_CSTATE_COMMENT;
            src++;
            continue;
        }
        *dst++ = (char)ch;
    }
    *dst = 0;
}

struct das_word_reader {
    int (*get)(void *arg, das_word_t *word);
    void *arg;
};

struct das_s6reader {
    struct das_word_reader words;
    das_word_t packed;
    unsigned int left;
    unsigned int slot;
    int newline;
};

/* All textual input is normalized to 7-bit ASCII before lexical analysis.
 * On a 9-bit DAIMOS C implementation this clears both high bits of char.
 */
static int das_read_line(struct das_char_reader *r, char *line,
                         unsigned int cap)
{
    unsigned int n;
    unsigned int ch;
    int rc;
    int long_line;

    if (r == 0 || r->get == 0 || line == 0 || cap == 0U)
        return DAS_INPUT_ERROR;
    n = 0U;
    long_line = 0;
    for (;;) {
        rc = r->get(r->arg, &ch);
        if (rc == DAS_INPUT_ERROR)
            return DAS_INPUT_ERROR;
        if (rc == DAS_INPUT_EOF) {
            if (n == 0U && !long_line)
                return DAS_INPUT_EOF;
            line[n] = 0;
            if (!long_line)
                das_strip_c_comments(line, &r->cstate);
            return long_line ? DAS_INPUT_TOOLONG : DAS_INPUT_OK;
        }
        ch &= 0177U;
        if (ch == '\n') {
            line[n] = 0;
            if (!long_line)
                das_strip_c_comments(line, &r->cstate);
            return long_line ? DAS_INPUT_TOOLONG : DAS_INPUT_OK;
        }
        if (!long_line) {
            if (n + 1U < cap)
                line[n++] = (char)ch;
            else
                long_line = 1;
        }
    }
}

static int das_s6_get(void *arg, unsigned int *ch)
{
    struct das_s6reader *r;
    das_word_t header;
    unsigned int shift;
    int rc;

    r = (struct das_s6reader *)arg;
    if (r == 0 || ch == 0)
        return DAS_INPUT_ERROR;
    if (r->newline) {
        r->newline = 0;
        *ch = '\n';
        return DAS_INPUT_OK;
    }
    while (r->left == 0U) {
        rc = r->words.get(r->words.arg, &header);
        if (rc != DAS_INPUT_OK)
            return rc;
        if ((unsigned int)((header >> DAS_S6REC_TYPE_SHIFT) &
                           DAS_S6REC_TYPE_MASK) != DAS_S6REC_TEXT)
            return DAS_INPUT_ERROR;
        r->left = (unsigned int)(header & DAS_S6REC_COUNT_MASK);
        r->slot = 6U;
        if (r->left == 0U) {
            *ch = '\n';
            return DAS_INPUT_OK;
        }
    }
    if (r->slot >= 6U) {
        rc = r->words.get(r->words.arg, &r->packed);
        if (rc != DAS_INPUT_OK)
            return DAS_INPUT_ERROR;
        r->slot = 0U;
    }
    shift = 30U - 6U * r->slot;
    *ch = (unsigned int)(((r->packed >> shift) & DAS_W(077)) + DAS_W(040));
    r->slot++;
    r->left--;
    if (r->left == 0U)
        r->newline = 1;
    return DAS_INPUT_OK;
}

static void das_s6_init(struct das_s6reader *r,
                        int (*getword)(void *, das_word_t *),
                        void *arg)
{
    r->words.get = getword;
    r->words.arg = arg;
    r->packed = DAS_W(0);
    r->left = 0U;
    r->slot = 6U;
    r->newline = 0;
}
#endif

#define DAS_OP_COUNT 390U
#define DAS_OP_INFO_PER_WORD 3U
static const das_word_t das_op_mn[DAS_OP_COUNT] = {
    DAS_OP3('A','D','D'),
    DAS_OP3('A','N','D'),
    DAS_OP3('A','O','J'),
    DAS_OP3('A','O','S'),
    DAS_OP3('A','S','H'),
    DAS_OP3('B','L','T'),
    DAS_OP3('C','A','I'),
    DAS_OP3('C','A','M'),
    DAS_OP3('D','F','N'),
    DAS_OP3('D','I','V'),
    DAS_OP3('D','P','B'),
    DAS_OP3('E','Q','V'),
    DAS_OP3('F','A','D'),
    DAS_OP3('F','D','V'),
    DAS_OP3('F','I','X'),
    DAS_OP3('F','M','P'),
    DAS_OP3('F','S','B'),
    DAS_OP3('F','S','C'),
    DAS_OP3('H','L','L'),
    DAS_OP3('H','L','R'),
    DAS_OP3('H','R','L'),
    DAS_OP3('H','R','R'),
    DAS_OP3('I','B','P'),
    DAS_OP3('I','O','R'),
    DAS_OP3('J','R','A'),
    DAS_OP3('J','S','A'),
    DAS_OP3('J','S','P'),
    DAS_OP3('J','S','R'),
    DAS_OP3('L','D','B'),
    DAS_OP3('L','S','H'),
    DAS_OP3('M','A','P'),
    DAS_OP3('M','U','L'),
    DAS_OP3('O','R','B'),
    DAS_OP3('O','R','I'),
    DAS_OP3('O','R','M'),
    DAS_OP3('P','O','P'),
    DAS_OP3('R','O','T'),
    DAS_OP3('S','O','J'),
    DAS_OP3('S','O','S'),
    DAS_OP3('S','U','B'),
    DAS_OP3('T','D','C'),
    DAS_OP3('T','D','N'),
    DAS_OP3('T','D','O'),
    DAS_OP3('T','D','Z'),
    DAS_OP3('T','L','C'),
    DAS_OP3('T','L','N'),
    DAS_OP3('T','L','O'),
    DAS_OP3('T','L','Z'),
    DAS_OP3('T','R','C'),
    DAS_OP3('T','R','N'),
    DAS_OP3('T','R','O'),
    DAS_OP3('T','R','Z'),
    DAS_OP3('T','S','C'),
    DAS_OP3('T','S','N'),
    DAS_OP3('T','S','O'),
    DAS_OP3('T','S','Z'),
    DAS_OP3('U','F','A'),
    DAS_OP3('X','C','T'),
    DAS_OP3('X','O','R'),
    DAS_OP4('A','D','D','B'),
    DAS_OP4('A','D','D','I'),
    DAS_OP4('A','D','D','M'),
    DAS_OP4('A','N','D','B'),
    DAS_OP4('A','N','D','I'),
    DAS_OP4('A','N','D','M'),
    DAS_OP4('A','O','J','A'),
    DAS_OP4('A','O','J','E'),
    DAS_OP4('A','O','J','G'),
    DAS_OP4('A','O','J','L'),
    DAS_OP4('A','O','J','N'),
    DAS_OP4('A','O','S','A'),
    DAS_OP4('A','O','S','E'),
    DAS_OP4('A','O','S','G'),
    DAS_OP4('A','O','S','L'),
    DAS_OP4('A','O','S','N'),
    DAS_OP4('A','S','H','C'),
    DAS_OP4('C','A','I','A'),
    DAS_OP4('C','A','I','E'),
    DAS_OP4('C','A','I','G'),
    DAS_OP4('C','A','I','L'),
    DAS_OP4('C','A','I','N'),
    DAS_OP4('C','A','M','A'),
    DAS_OP4('C','A','M','E'),
    DAS_OP4('C','A','M','G'),
    DAS_OP4('C','A','M','L'),
    DAS_OP4('C','A','M','N'),
    DAS_OP4('D','A','D','D'),
    DAS_OP4('D','D','I','V'),
    DAS_OP4('D','F','A','D'),
    DAS_OP4('D','F','D','V'),
    DAS_OP4('D','F','M','P'),
    DAS_OP4('D','F','S','B'),
    DAS_OP4('D','I','V','B'),
    DAS_OP4('D','I','V','I'),
    DAS_OP4('D','I','V','M'),
    DAS_OP4('D','M','U','L'),
    DAS_OP4('D','S','U','B'),
    DAS_OP4('E','Q','V','B'),
    DAS_OP4('E','Q','V','I'),
    DAS_OP4('E','Q','V','M'),
    DAS_OP4('E','X','C','H'),
    DAS_OP4('F','A','D','B'),
    DAS_OP4('F','A','D','L'),
    DAS_OP4('F','A','D','M'),
    DAS_OP4('F','A','D','R'),
    DAS_OP4('F','D','V','B'),
    DAS_OP4('F','D','V','L'),
    DAS_OP4('F','D','V','M'),
    DAS_OP4('F','D','V','R'),
    DAS_OP4('F','I','X','R'),
    DAS_OP4('F','L','T','R'),
    DAS_OP4('F','M','P','B'),
    DAS_OP4('F','M','P','L'),
    DAS_OP4('F','M','P','M'),
    DAS_OP4('F','M','P','R'),
    DAS_OP4('F','S','B','B'),
    DAS_OP4('F','S','B','L'),
    DAS_OP4('F','S','B','M'),
    DAS_OP4('F','S','B','R'),
    DAS_OP4('H','A','L','T'),
    DAS_OP4('H','L','L','E'),
    DAS_OP4('H','L','L','I'),
    DAS_OP4('H','L','L','M'),
    DAS_OP4('H','L','L','O'),
    DAS_OP4('H','L','L','S'),
    DAS_OP4('H','L','L','Z'),
    DAS_OP4('H','L','R','E'),
    DAS_OP4('H','L','R','I'),
    DAS_OP4('H','L','R','M'),
    DAS_OP4('H','L','R','O'),
    DAS_OP4('H','L','R','S'),
    DAS_OP4('H','L','R','Z'),
    DAS_OP4('H','R','L','E'),
    DAS_OP4('H','R','L','I'),
    DAS_OP4('H','R','L','M'),
    DAS_OP4('H','R','L','O'),
    DAS_OP4('H','R','L','S'),
    DAS_OP4('H','R','L','Z'),
    DAS_OP4('H','R','R','E'),
    DAS_OP4('H','R','R','I'),
    DAS_OP4('H','R','R','M'),
    DAS_OP4('H','R','R','O'),
    DAS_OP4('H','R','R','S'),
    DAS_OP4('H','R','R','Z'),
    DAS_OP4('I','D','I','V'),
    DAS_OP4('I','D','P','B'),
    DAS_OP4('I','L','D','B'),
    DAS_OP4('I','M','U','L'),
    DAS_OP4('I','O','R','B'),
    DAS_OP4('I','O','R','I'),
    DAS_OP4('I','O','R','M'),
    DAS_OP4('J','F','C','L'),
    DAS_OP4('J','F','F','O'),
    DAS_OP4('J','R','S','T'),
    DAS_OP4('J','U','M','P'),
    DAS_OP4('L','S','H','C'),
    DAS_OP4('M','O','V','E'),
    DAS_OP4('M','O','V','M'),
    DAS_OP4('M','O','V','N'),
    DAS_OP4('M','O','V','S'),
    DAS_OP4('M','U','L','B'),
    DAS_OP4('M','U','L','I'),
    DAS_OP4('M','U','L','M'),
    DAS_OP4('O','R','C','A'),
    DAS_OP4('O','R','C','B'),
    DAS_OP4('O','R','C','M'),
    DAS_OP4('P','O','P','J'),
    DAS_OP4('P','U','S','H'),
    DAS_OP4('R','O','T','C'),
    DAS_OP4('S','E','T','A'),
    DAS_OP4('S','E','T','M'),
    DAS_OP4('S','E','T','O'),
    DAS_OP4('S','E','T','Z'),
    DAS_OP4('S','K','I','P'),
    DAS_OP4('S','O','J','A'),
    DAS_OP4('S','O','J','E'),
    DAS_OP4('S','O','J','G'),
    DAS_OP4('S','O','J','L'),
    DAS_OP4('S','O','J','N'),
    DAS_OP4('S','O','S','A'),
    DAS_OP4('S','O','S','E'),
    DAS_OP4('S','O','S','G'),
    DAS_OP4('S','O','S','L'),
    DAS_OP4('S','O','S','N'),
    DAS_OP4('S','U','B','B'),
    DAS_OP4('S','U','B','I'),
    DAS_OP4('S','U','B','M'),
    DAS_OP4('T','D','C','A'),
    DAS_OP4('T','D','C','E'),
    DAS_OP4('T','D','C','N'),
    DAS_OP4('T','D','N','A'),
    DAS_OP4('T','D','N','E'),
    DAS_OP4('T','D','N','N'),
    DAS_OP4('T','D','O','A'),
    DAS_OP4('T','D','O','E'),
    DAS_OP4('T','D','O','N'),
    DAS_OP4('T','D','Z','A'),
    DAS_OP4('T','D','Z','E'),
    DAS_OP4('T','D','Z','N'),
    DAS_OP4('T','L','C','A'),
    DAS_OP4('T','L','C','E'),
    DAS_OP4('T','L','C','N'),
    DAS_OP4('T','L','N','A'),
    DAS_OP4('T','L','N','E'),
    DAS_OP4('T','L','N','N'),
    DAS_OP4('T','L','O','A'),
    DAS_OP4('T','L','O','E'),
    DAS_OP4('T','L','O','N'),
    DAS_OP4('T','L','Z','A'),
    DAS_OP4('T','L','Z','E'),
    DAS_OP4('T','L','Z','N'),
    DAS_OP4('T','R','C','A'),
    DAS_OP4('T','R','C','E'),
    DAS_OP4('T','R','C','N'),
    DAS_OP4('T','R','N','A'),
    DAS_OP4('T','R','N','E'),
    DAS_OP4('T','R','N','N'),
    DAS_OP4('T','R','O','A'),
    DAS_OP4('T','R','O','E'),
    DAS_OP4('T','R','O','N'),
    DAS_OP4('T','R','Z','A'),
    DAS_OP4('T','R','Z','E'),
    DAS_OP4('T','R','Z','N'),
    DAS_OP4('T','S','C','A'),
    DAS_OP4('T','S','C','E'),
    DAS_OP4('T','S','C','N'),
    DAS_OP4('T','S','N','A'),
    DAS_OP4('T','S','N','E'),
    DAS_OP4('T','S','N','N'),
    DAS_OP4('T','S','O','A'),
    DAS_OP4('T','S','O','E'),
    DAS_OP4('T','S','O','N'),
    DAS_OP4('T','S','Z','A'),
    DAS_OP4('T','S','Z','E'),
    DAS_OP4('T','S','Z','N'),
    DAS_OP4('X','O','R','B'),
    DAS_OP4('X','O','R','I'),
    DAS_OP4('X','O','R','M'),
    DAS_OP5('A','D','J','B','P'),
    DAS_OP5('A','D','J','S','P'),
    DAS_OP5('A','N','D','C','A'),
    DAS_OP5('A','N','D','C','B'),
    DAS_OP5('A','N','D','C','M'),
    DAS_OP5('A','O','B','J','N'),
    DAS_OP5('A','O','B','J','P'),
    DAS_OP5('A','O','J','G','E'),
    DAS_OP5('A','O','J','L','E'),
    DAS_OP5('A','O','S','G','E'),
    DAS_OP5('A','O','S','L','E'),
    DAS_OP5('C','A','I','G','E'),
    DAS_OP5('C','A','I','L','E'),
    DAS_OP5('C','A','M','G','E'),
    DAS_OP5('C','A','M','L','E'),
    DAS_OP5('C','L','E','A','R'),
    DAS_OP5('D','M','O','V','E'),
    DAS_OP5('D','M','O','V','N'),
    DAS_OP5('F','A','D','R','B'),
    DAS_OP5('F','A','D','R','I'),
    DAS_OP5('F','A','D','R','L'),
    DAS_OP5('F','A','D','R','M'),
    DAS_OP5('F','D','V','R','B'),
    DAS_OP5('F','D','V','R','I'),
    DAS_OP5('F','D','V','R','L'),
    DAS_OP5('F','D','V','R','M'),
    DAS_OP5('F','M','P','R','B'),
    DAS_OP5('F','M','P','R','I'),
    DAS_OP5('F','M','P','R','L'),
    DAS_OP5('F','M','P','R','M'),
    DAS_OP5('F','S','B','R','B'),
    DAS_OP5('F','S','B','R','I'),
    DAS_OP5('F','S','B','R','L'),
    DAS_OP5('F','S','B','R','M'),
    DAS_OP5('H','L','L','E','I'),
    DAS_OP5('H','L','L','E','M'),
    DAS_OP5('H','L','L','E','S'),
    DAS_OP5('H','L','L','O','I'),
    DAS_OP5('H','L','L','O','M'),
    DAS_OP5('H','L','L','O','S'),
    DAS_OP5('H','L','L','Z','I'),
    DAS_OP5('H','L','L','Z','M'),
    DAS_OP5('H','L','L','Z','S'),
    DAS_OP5('H','L','R','E','I'),
    DAS_OP5('H','L','R','E','M'),
    DAS_OP5('H','L','R','E','S'),
    DAS_OP5('H','L','R','O','I'),
    DAS_OP5('H','L','R','O','M'),
    DAS_OP5('H','L','R','O','S'),
    DAS_OP5('H','L','R','Z','I'),
    DAS_OP5('H','L','R','Z','M'),
    DAS_OP5('H','L','R','Z','S'),
    DAS_OP5('H','R','L','E','I'),
    DAS_OP5('H','R','L','E','M'),
    DAS_OP5('H','R','L','E','S'),
    DAS_OP5('H','R','L','O','I'),
    DAS_OP5('H','R','L','O','M'),
    DAS_OP5('H','R','L','O','S'),
    DAS_OP5('H','R','L','Z','I'),
    DAS_OP5('H','R','L','Z','M'),
    DAS_OP5('H','R','L','Z','S'),
    DAS_OP5('H','R','R','E','I'),
    DAS_OP5('H','R','R','E','M'),
    DAS_OP5('H','R','R','E','S'),
    DAS_OP5('H','R','R','O','I'),
    DAS_OP5('H','R','R','O','M'),
    DAS_OP5('H','R','R','O','S'),
    DAS_OP5('H','R','R','Z','I'),
    DAS_OP5('H','R','R','Z','M'),
    DAS_OP5('H','R','R','Z','S'),
    DAS_OP5('I','D','I','V','B'),
    DAS_OP5('I','D','I','V','I'),
    DAS_OP5('I','D','I','V','M'),
    DAS_OP5('I','M','U','L','B'),
    DAS_OP5('I','M','U','L','I'),
    DAS_OP5('I','M','U','L','M'),
    DAS_OP5('J','U','M','P','A'),
    DAS_OP5('J','U','M','P','E'),
    DAS_OP5('J','U','M','P','G'),
    DAS_OP5('J','U','M','P','L'),
    DAS_OP5('J','U','M','P','N'),
    DAS_OP5('M','O','V','E','I'),
    DAS_OP5('M','O','V','E','M'),
    DAS_OP5('M','O','V','E','S'),
    DAS_OP5('M','O','V','M','I'),
    DAS_OP5('M','O','V','M','M'),
    DAS_OP5('M','O','V','M','S'),
    DAS_OP5('M','O','V','N','I'),
    DAS_OP5('M','O','V','N','M'),
    DAS_OP5('M','O','V','N','S'),
    DAS_OP5('M','O','V','S','I'),
    DAS_OP5('M','O','V','S','M'),
    DAS_OP5('M','O','V','S','S'),
    DAS_OP5('O','R','C','A','B'),
    DAS_OP5('O','R','C','A','I'),
    DAS_OP5('O','R','C','A','M'),
    DAS_OP5('O','R','C','B','B'),
    DAS_OP5('O','R','C','B','I'),
    DAS_OP5('O','R','C','B','M'),
    DAS_OP5('O','R','C','M','B'),
    DAS_OP5('O','R','C','M','I'),
    DAS_OP5('O','R','C','M','M'),
    DAS_OP5('P','U','S','H','J'),
    DAS_OP5('S','E','T','A','B'),
    DAS_OP5('S','E','T','A','I'),
    DAS_OP5('S','E','T','A','M'),
    DAS_OP5('S','E','T','C','A'),
    DAS_OP5('S','E','T','C','M'),
    DAS_OP5('S','E','T','M','B'),
    DAS_OP5('S','E','T','M','I'),
    DAS_OP5('S','E','T','M','M'),
    DAS_OP5('S','E','T','O','B'),
    DAS_OP5('S','E','T','O','I'),
    DAS_OP5('S','E','T','O','M'),
    DAS_OP5('S','E','T','Z','B'),
    DAS_OP5('S','E','T','Z','I'),
    DAS_OP5('S','E','T','Z','M'),
    DAS_OP5('S','K','I','P','A'),
    DAS_OP5('S','K','I','P','E'),
    DAS_OP5('S','K','I','P','G'),
    DAS_OP5('S','K','I','P','L'),
    DAS_OP5('S','K','I','P','N'),
    DAS_OP5('S','O','J','G','E'),
    DAS_OP5('S','O','J','L','E'),
    DAS_OP5('S','O','S','G','E'),
    DAS_OP5('S','O','S','L','E'),
    DAS_OP6('A','N','D','C','A','B'),
    DAS_OP6('A','N','D','C','A','I'),
    DAS_OP6('A','N','D','C','A','M'),
    DAS_OP6('A','N','D','C','B','B'),
    DAS_OP6('A','N','D','C','B','I'),
    DAS_OP6('A','N','D','C','B','M'),
    DAS_OP6('A','N','D','C','M','B'),
    DAS_OP6('A','N','D','C','M','I'),
    DAS_OP6('A','N','D','C','M','M'),
    DAS_OP6('C','L','E','A','R','B'),
    DAS_OP6('C','L','E','A','R','I'),
    DAS_OP6('C','L','E','A','R','M'),
    DAS_OP6('D','M','O','V','E','M'),
    DAS_OP6('D','M','O','V','N','M'),
    DAS_OP6('E','X','T','E','N','D'),
    DAS_OP6('J','U','M','P','G','E'),
    DAS_OP6('J','U','M','P','L','E'),
    DAS_OP6('S','E','T','C','A','B'),
    DAS_OP6('S','E','T','C','A','I'),
    DAS_OP6('S','E','T','C','A','M'),
    DAS_OP6('S','E','T','C','M','B'),
    DAS_OP6('S','E','T','C','M','I'),
    DAS_OP6('S','E','T','C','M','M'),
    DAS_OP6('S','K','I','P','G','E'),
    DAS_OP6('S','K','I','P','L','E'),
    DAS_OP6('X','M','O','V','E','I')
};
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static const das_word_t das_op_info[] = {
    DAS_W(001341010340),
    DAS_W(001640500251),
    DAS_W(001400621131),
    DAS_W(001160276444),
    DAS_W(004602361122),
    DAS_W(004702321132),
    DAS_W(002401310504),
    DAS_W(002600266434),
    DAS_W(001334554265),
    DAS_W(001320272242),
    DAS_W(005274450437),
    DAS_W(002165074262),
    DAS_W(001204740370),
    DAS_W(001361520610),
    DAS_W(003341460641),
    DAS_W(003005542621),
    DAS_W(003201400660),
    DAS_W(003101522611),
    DAS_W(003345463130),
    DAS_W(001271060273),
    DAS_W(001344564407),
    DAS_W(002025014344),
    DAS_W(001610716341),
    DAS_W(001630730352),
    DAS_W(001674722356),
    DAS_W(001220610302),
    DAS_W(001434602306),
    DAS_W(001460624317),
    DAS_W(001444635114),
    DAS_W(004476221113),
    DAS_W(004452222237),
    DAS_W(001164475116),
    DAS_W(004465116445),
    DAS_W(002230521143),
    DAS_W(004606305144),
    DAS_W(004756363172),
    DAS_W(004762255127),
    DAS_W(004716343162),
    DAS_W(004722327151),
    DAS_W(004652330254),
    DAS_W(002541202502),
    DAS_W(002501206510),
    DAS_W(002761312546),
    DAS_W(002721316554),
    DAS_W(002561212506),
    DAS_W(002521216514),
    DAS_W(002741302542),
    DAS_W(002701306550),
    DAS_W(001140274134),
    DAS_W(001101076435),
    DAS_W(002170532243),
    DAS_W(001260640246),
    DAS_W(001000430210),
    DAS_W(001020456225),
    DAS_W(001131130470),
    DAS_W(002320546261),
    DAS_W(001225050414),
    DAS_W(002361000330),
    DAS_W(001720744367),
    DAS_W(001704754374),
    DAS_W(001750776371),
    DAS_W(001770576275),
    DAS_W(001371530652),
    DAS_W(003271430612),
    DAS_W(003071570672),
    DAS_W(003371470632),
    DAS_W(003171512643),
    DAS_W(003235412603),
    DAS_W(003035552663),
    DAS_W(003335452623),
    DAS_W(003135510642),
    DAS_W(003231410602),
    DAS_W(003031550662),
    DAS_W(003331450622),
    DAS_W(003131532653),
    DAS_W(003275432613),
    DAS_W(003075572673),
    DAS_W(003375472633),
    DAS_W(003175066431),
    DAS_W(002150266105),
    DAS_W(002041100420),
    DAS_W(001254524345),
    DAS_W(001614732353),
    DAS_W(001424606315),
    DAS_W(001455001120),
    DAS_W(004506317145),
    DAS_W(004626315177),
    DAS_W(004766373176),
    DAS_W(004736353165),
    DAS_W(004732337155),
    DAS_W(004666334531),
    DAS_W(002551266521),
    DAS_W(002511246511),
    DAS_W(002451226575),
    DAS_W(002771376565),
    DAS_W(002731356555),
    DAS_W(002671336535),
    DAS_W(002571276525),
    DAS_W(002531256515),
    DAS_W(002471236571),
    DAS_W(002751366561),
    DAS_W(002711346551),
    DAS_W(002651326233),
    DAS_W(001144464223),
    DAS_W(001104444324),
    DAS_W(001510656321),
    DAS_W(001530402202),
    DAS_W(001014432216),
    DAS_W(001074422212),
    DAS_W(001054412206),
    DAS_W(001035136455),
    DAS_W(002271166471),
    DAS_W(002351156465),
    DAS_W(002330540427),
    DAS_W(002125054450),
    DAS_W(002301036415),
    DAS_W(002071176475),
    DAS_W(002371006401),
    DAS_W(002010670332),
    DAS_W(001574662336),
    DAS_W(001724746375),
    DAS_W(001755026411),
    DAS_W(002051106441),
    DAS_W(002211046421),
    DAS_W(002111006401),
    DAS_W(002012251125),
    DAS_W(004514652323),
    DAS_W(002255122452),
    DAS_W(002315142462),
    DAS_W(001564667201)
};
#elif DAS_ENABLE_OPTIMIZER
/* Pass 1 needs exact skip classification, but not the complete opcode
 * encoding table.  One bit per sorted mnemonic preserves optimizer semantics
 * while avoiding phase-2-only encoding metadata in the resident image. */
static const das_word_t das_op_skip_bits[] = {
    DAS_W(000000000000),
    DAS_W(001703640003),
    DAS_W(737760000000),
    DAS_W(000000000000),
    DAS_W(000000000001),
    DAS_W(743777777777),
    DAS_W(777777400037),
    DAS_W(400000000000),
    DAS_W(000000000000),
    DAS_W(000000000037),
    DAS_W(140000000600)
};
#endif
static das_word_t das_mask36(das_word_t x) { return x & DAS_WORD_MASK; }
#if defined(DAS_NATIVE_PHASE1_ONLY)
static int lookup_op_mn(das_word_t m, int *nonbase)
{
    unsigned int lo;
    unsigned int hi;
    unsigned int mid;

    lo = 0U;
    hi = DAS_OP_COUNT;
    if (nonbase != 0)
        *nonbase = 0;
    while (lo < hi) {
        mid = lo + (hi - lo) / 2U;
        if (m < das_op_mn[mid])
            hi = mid;
        else if (m > das_op_mn[mid])
            lo = mid + 1U;
        else
            return 0;
    }
    return -1;
}
#else
static int lookup_op_mn(das_word_t m, int *nonbase)
{
    unsigned int lo;
    unsigned int hi;
    unsigned int mid;
    unsigned int shift;
    das_word_t info;

    lo = 0U;
    hi = DAS_OP_COUNT;
    while (lo < hi) {
        mid = lo + (hi - lo) / 2U;
        if (m < das_op_mn[mid])
            hi = mid;
        else if (m > das_op_mn[mid])
            lo = mid + 1U;
        else {
            shift = (2U - (mid % DAS_OP_INFO_PER_WORD)) * 10U;
            info = (das_op_info[mid / DAS_OP_INFO_PER_WORD] >> shift) &
                DAS_W(01777);
            if (nonbase != 0)
                *nonbase = (info & DAS_W(01000)) != DAS_W(0);
            return (int)(info & DAS_W(0777));
        }
    }
    if (nonbase != 0)
        *nonbase = 0;
    return -1;
}
#endif
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static das_word_t das_enc_mem(unsigned int op, unsigned int ac, int ind, int xr, unsigned int y) { return das_mask36(((das_word_t)op << 27) | ((das_word_t)(ac & 017) << 23) | ((das_word_t)(ind & 1) << 22) | ((das_word_t)(xr & 017) << 18) | (y & DAS_HALF_MASK)); }
static void das_bitmap_set(das_word_t *map, unsigned int off) { map[off / 36U] |= (DAS_W(1) << (35U - (off % 36U))); }
#if DAS_ENABLE_OPTIMIZER
static void das_bitmap_clear(das_word_t *map, unsigned int off) { map[off / 36U] &= ~(DAS_W(1) << (35U - (off % 36U))); }
static int das_bitmap_get(das_word_t *map, unsigned int off) { return (map[off / 36U] & (DAS_W(1) << (35U - (off % 36U)))) != 0; }
#endif
#endif

#if defined(DAS_NATIVE_SELFTEST)
#define DAS_NREC_END 0U
#define DAS_NREC_LABEL 1U
#define DAS_NREC_OP_SYM 2U
#define DAS_NREC_OP_ABS 3U
#define DAS_NREC_WORD 4U
#define DAS_NREC_BSS 5U
#define DAS_NMAX_SYM 16U
#define DAS_NMAX_IMAGE 128U

struct das_nrec {
    unsigned int kind;
    unsigned int sym;
    unsigned int op;
    unsigned int ac;
    unsigned int arg;
    das_word_t word;
};

int das_native_assemble_mem(const struct das_nrec *src,
                                   das_word_t *out,
                                   unsigned int outmax,
                                   unsigned int *outwords)
{
    unsigned int symv[DAS_NMAX_SYM];
    unsigned int loc, bss, i, image_words, reloc_words, outp, relbase;

    for (i = 0; i < DAS_NMAX_SYM; i++) symv[i] = DAS_HALF_MASK;

    loc = 0;
    bss = 0;
    for (i = 0; src[i].kind != DAS_NREC_END; i++) {
        if (src[i].kind == DAS_NREC_LABEL) {
            if (src[i].sym >= DAS_NMAX_SYM) return 10;
            symv[src[i].sym] = loc;
        } else if (src[i].kind == DAS_NREC_BSS) {
            bss += src[i].arg;
        } else {
            if (loc >= DAS_NMAX_IMAGE) return 11;
            loc++;
        }
    }
    image_words = loc;
    if (image_words == 0) return 12;
    reloc_words = (image_words + 35U) / 36U;
    if (outmax < 2U + image_words + reloc_words) return 30;

    out[0] = DAS_WORD(DAS_MAGIC_DXR, 0);
    out[1] = DAS_WORD(image_words, bss);
    for (i = 0; i < image_words + reloc_words; i++) out[2U + i] = 0;
    relbase = 2U + image_words;

    loc = 0;
    for (i = 0; src[i].kind != DAS_NREC_END; i++) {
        if (src[i].kind == DAS_NREC_LABEL || src[i].kind == DAS_NREC_BSS) continue;
        outp = 2U + loc;
        if (src[i].kind == DAS_NREC_OP_SYM) {
            if (src[i].arg >= DAS_NMAX_SYM || symv[src[i].arg] == DAS_HALF_MASK) return 20;
            out[outp] = das_enc_mem(src[i].op, src[i].ac, 0, 0,
                                    symv[src[i].arg]);
            das_bitmap_set(out + relbase, loc);
        } else if (src[i].kind == DAS_NREC_OP_ABS) {
            out[outp] = das_enc_mem(src[i].op, src[i].ac, 0, 0,
                                    src[i].arg);
        } else if (src[i].kind == DAS_NREC_WORD) {
            out[outp] = src[i].word & DAS_WORD_MASK;
        } else {
            return 23;
        }
        loc++;
    }

    *outwords = 2U + image_words + reloc_words;
    return 0;
}

#ifdef DAS_NATIVE_SELFTEST
int das_native_selftest(void)
{
    static const struct das_nrec src[] = {
        {DAS_NREC_LABEL, 1, 0, 0, 0, 0},
        {DAS_NREC_OP_SYM, 0, 0201, 1, 2, 0},
        {DAS_NREC_OP_SYM, 0, 0254, 0, 3, 0},
        {DAS_NREC_LABEL, 2, 0, 0, 0, 0},
        {DAS_NREC_WORD, 0, 0, 0, 0, DAS_W(0123456)},
        {DAS_NREC_LABEL, 3, 0, 0, 0, 0},
        {DAS_NREC_OP_ABS, 0, 0254, 0, 0, 0},
        {DAS_NREC_BSS, 0, 0, 0, 5, 0},
        {DAS_NREC_END, 0, 0, 0, 0, 0}
    };
    static const das_word_t expect[] = {
        DAS_WORD(DAS_W(0447062), 0),
        DAS_WORD(4, 5),
        DAS_W(0201040000002),
        DAS_W(0254000000003),
        DAS_W(0000000123456),
        DAS_W(0254000000000),
        DAS_W(0600000000000)
    };
    das_word_t out[16];
    unsigned int n, i;
    int rc;

    if (DAS_MAGIC_DXR != DAS_W(0447062)) return 1;
    if (das_enc_mem(0201, 1, 0, 0, 2) != DAS_W(0201040000002)) return 2;
    rc = das_native_assemble_mem(src, out, 16U, &n);
    if (rc != 0) return 100 + rc;
    if (n != (sizeof(expect) / sizeof(expect[0]))) return 4;
    for (i = 0; i < n; i++) {
        if ((out[i] & DAS_WORD_MASK) != expect[i]) return 20 + (int)i;
    }
    return 0;
}
#endif /* DAS_NATIVE_SELFTEST */
#endif /* DAS_NATIVE_SELFTEST */

#ifndef DAS_NATIVE_CORE_ONLY
#define DAS_MAX_WORK_WORDS 65536U
#define DAS_TARGET_CHARS_PER_WORD 4U
#ifdef DAS_NATIVE
#define DAS_SYM_BUCKETS 256U
/* Native symbol capacity is spill-backed, so the bucket array is only a
 * lookup accelerator.  Keep both phases at 256 buckets: this removes 0400
 * resident words from phase 1 without changing symbol capacity or semantics. */
#define DAS_SYM_CACHE_ENTRIES 13U
#define DAS_PARSER_WORK_WORDS 1536U
#else
#define DAS_SYM_BUCKETS 2048U
#define DAS_SYM_CACHE_ENTRIES 55U
#define DAS_PARSER_WORK_WORDS 4096U
#endif
#define DAS_SYM_NAME_WORDS \
    ((DAS_MAX_NAME + DAS_TARGET_CHARS_PER_WORD) / DAS_TARGET_CHARS_PER_WORD)
#define DAS_SYM_RECORD_WORDS (3U + DAS_SYM_NAME_WORDS)
#define DAS_LIT_TEXT_WORDS \
    ((DAS_MAX_LINE - 1U + DAS_TARGET_CHARS_PER_WORD - 1U) / \
        DAS_TARGET_CHARS_PER_WORD)
#define DAS_LIT_RECORD_WORDS (1U + DAS_LIT_TEXT_WORDS)
#define DAS_SYM_CACHE_SLOT_WORDS (DAS_SYM_NAME_WORDS + 5U)
#define DAS_FIXED_WORK_WORDS \
    (DAS_PARSER_WORK_WORDS + DAS_SYM_BUCKETS + \
        DAS_SYM_CACHE_ENTRIES * DAS_SYM_CACHE_SLOT_WORDS + \
        DAS_WORD_INPUT_BUFFER)

struct sym { char name[DAS_MAX_NAME + 1]; int sec; das_word_t off; };
struct das_wordfile {
    FILE *file;
    unsigned int words;
#ifdef DAS_NATIVE
    char path[KPATH_MAX_CHARS + 1U];
#endif
};
struct das_sym_cache {
    das_word_t hash;
    unsigned int record;
    int valid;
    struct sym sym;
};
struct das_sym_store {
    unsigned int heads[DAS_SYM_BUCKETS];
    struct das_sym_cache cache[DAS_SYM_CACHE_ENTRIES];
    struct das_wordfile spill;
    unsigned int records;
    unsigned int lookups;
    unsigned int probes;
};
struct das_lit_store {
    struct das_wordfile spill;
    unsigned int records;
    unsigned int words;
    unsigned int image_words;
    unsigned int read_next;
    unsigned int read_pos;
    unsigned int read_count;
    unsigned int read_records;
    das_word_t read_buffer[DAS_WORD_INPUT_BUFFER];
};
enum das_token {
    DAS_TOK_OTHER = 0,
    DAS_TOK_TEXT,
    DAS_TOK_DATA,
    DAS_TOK_BSS,
    DAS_TOK_PSECT,
    DAS_TOK_NO_WORDS,
    DAS_TOK_ENTRY,
    DAS_TOK_ERROR,
    DAS_TOK_WARNING,
    DAS_TOK_RADIX,
    DAS_TOK_BLOCK,
    DAS_TOK_SPACE,
    DAS_TOK_COMM,
    DAS_TOK_LCOMM,
    DAS_TOK_BYTE,
    DAS_TOK_ASCII,
    DAS_TOK_ASCIZ,
    DAS_TOK_SIXBIT,
    DAS_TOK_WORD,
    DAS_TOK_EXP,
    DAS_TOK_LONG,
    DAS_TOK_POINT,
    DAS_TOK_GIW,
    DAS_TOK_OWGBP,
    DAS_TOK_ORG,
    DAS_TOK_EQU,
    DAS_TOK_SET,
    DAS_TOK_ALIGN,
    DAS_TOK_GLOBAL,
    DAS_TOK_EXTERN
};
struct das_parsed_line {
    char *label;
    size_t label_len;
    char *stmt;
    char *rest;
    char key[DAS_MAX_NAME + 1];
    enum das_token token;
    das_word_t mnemonic;
    unsigned int operand_ac;
    unsigned int operand_reg;
    das_word_t operand_integer;
    char *operand;
    int has_operand_ac;
    int operand_is_reg;
    int operand_is_integer;
    int operand_integer_negative;
    int was_pseudo;
};
#define DAS_MAX_COND_DEPTH 18U
struct das_cond_state {
    unsigned int depth;
    das_word_t active_bits;
    das_word_t else_bits;
};
struct das_macro_frame {
    unsigned int def_pos;
    const struct das_macro_frame *parent;
};
struct das_iter_frame {
    unsigned int name_pos;
    unsigned int value_pos;
    const struct das_iter_frame *parent;
};
#ifndef DAS_NATIVE
struct das_obj_global {
    char name[DAS_MAX_NAME + 1];
};
struct das_obj_reloc {
    int loc_sec;
    int type;
    int target_sec;
    unsigned int offset;
    unsigned int symbol;
    das_word_t addend;
};
struct das_set_reloc {
    int valid;
    int reloc_kind;
    int target_sec;
    unsigned int symbol;
    das_word_t addend;
};
#endif
struct asmctx {
    struct das_sym_store sym_store;
    struct das_lit_store lit_store;
    struct das_wordfile rept_spill;
    struct das_wordfile ir_spill;
    unsigned int loc[4];
    unsigned int entry;
    unsigned int relmap_words;
    unsigned int peak_work_words;
    unsigned int parser_classifications;
    unsigned int parser_token_probes;
#if DAS_ENABLE_OPTIMIZER
    unsigned int opt_window_len;
    unsigned int opt_value[16];
    unsigned int opt_prev_move;
    unsigned int opt_prev_move_ac;
    unsigned int opt_prev_zero;
    unsigned int opt_prev_zero_ac;
    unsigned int opt_prev_immediate;
    unsigned int opt_prev_immediate_ac;
    unsigned int opt_prev_immediate_value;
    unsigned int opt_prev_movei_any;
    unsigned int opt_prev_movei_any_ac;
    unsigned int opt_prev_deadwrite;
    unsigned int opt_prev_deadwrite_ac;
    unsigned int opt_prev_forward_move;
    unsigned int opt_prev_forward_move_ac;
    unsigned int opt_pending_push;
    unsigned int opt_pending_push_temp;
    unsigned int opt_pending_push_ac;
    unsigned int opt_pending_push_kind;
    unsigned int opt_prev_store;
    unsigned int opt_prev_store_ac;
    das_word_t opt_prev_store_ea;
    int opt_prev_store_reloc;
    unsigned int opt_prev_mem;
    unsigned int opt_prev_mem_ac;
    char opt_prev_mem_ea[DAS_MAX_LINE];
    unsigned int opt_prev_lshr;
    unsigned int opt_prev_lshr_ac;
    unsigned int opt_prev_lshr_count;
    unsigned int opt_skip_next;
    unsigned int opt_current_may_be_skipped;
#endif
    char entry_name[DAS_MAX_NAME + 1];
#ifndef DAS_NATIVE
    int object_mode;
    struct das_obj_global *obj_globals;
    unsigned int obj_global_count;
    unsigned int obj_global_cap;
    struct das_obj_reloc *obj_relocs;
    unsigned int obj_reloc_count;
    unsigned int obj_reloc_cap;
    int eval_reloc_kind;
    int eval_target_sec;
    unsigned int eval_symbol;
    das_word_t eval_addend;
    int eval_lh_reloc_kind;
    int eval_lh_target_sec;
    unsigned int eval_lh_symbol;
    das_word_t eval_lh_addend;
    struct das_set_reloc *set_relocs;
    unsigned int set_reloc_cap;
#endif
    int eval_silent;
    unsigned int set_serial;
    unsigned int source_serial;
};

struct das_output {
    FILE *file;
#ifndef DAS_NATIVE
    struct asmctx *ctx;
    int object_mode;
    unsigned int header_words;
#endif
    das_word_t *relmap;
    unsigned int relmap_words;
    unsigned int image_words;
    unsigned int word_pos;
#ifdef DAS_NATIVE
    das_word_t *buffer;
    unsigned int buffer_first;
    unsigned int buffer_count;
#endif
};

#ifndef DAS_NATIVE
struct host_char_input {
    FILE *file;
    char *buffer;
    unsigned int pos;
    unsigned int count;
};
#endif

struct host_word_input {
    FILE *file;
    das_word_t *buffer;
    unsigned int pos;
    unsigned int count;
};

static unsigned int sec_base(struct asmctx *c, int sec);
#if DAS_ENABLE_OPTIMIZER
static int das_optimize;
#endif
#if !defined(DAS_NATIVE) && !defined(DAS_PHASE2_PROGRAM)
static int das_object_mode;
#endif

#define DAS_MAX_INCLUDE_DEPTH 8U
#define DAS_MAX_REPT_DEPTH 8U
#define DAS_MAX_REPT_COUNT 65535U
#define DAS_MAX_MACRO_DEPTH 8U
#define DAS_MAX_MACRO_ARGS 9U
#define DAS_REPT_NONE 0
#define DAS_REPT_BLOCK 1
#define DAS_REPT_END 2
#define DAS_REPT_IRP 3
#define DAS_REPT_IRPC 4
#define DAS_IR_MAGIC DAS_W(0444163516221) /* SIXBIT /DASIR1/ */
#define DAS_PHASE_MAGIC DAS_W(0444163516222) /* SIXBIT /DASIR2/ */
#define DAS_IR_TYPE_SHIFT 30U
#define DAS_IR_TYPE_MASK 077U
#define DAS_IR_COUNT_MASK DAS_W(07777777777)
#define DAS_IR_LINE 1U
#define DAS_IR_RESET 2U
#define DAS_IR_GUARD 3U
#define DAS_PHASE_STATE 4U
#define DAS_PHASE_SYMBOLS 5U
#define DAS_PHASE_LITERALS 6U
#define DAS_PHASE_LINES 7U
#define DAS_PHASE_END 8U
#define DAS_PHASE_STATE_WORDS 14U
#define DAS_PHASE_F_OPTIMIZE 000001U
#define DAS_PHASE_F_STRICT_BASE 000002U
#define DAS_PHASE_F_KERNEL 000004U
#define DAS_REPT_PACK_WORDS \
    ((DAS_MAX_LINE - 1U + DAS_TARGET_CHARS_PER_WORD - 1U) / \
        DAS_TARGET_CHARS_PER_WORD)
#ifdef DAS_NATIVE
#define DAS_NATIVE_RELMAP_WORDS \
    ((EXEC_DXR_MAX_IMAGE_WORDS + 35U) / 36U)
#if !defined(DAS_NATIVE_PHASE2_ONLY)
static char das_native_file_paths[DAS_MAX_INCLUDE_DEPTH + 1U]
    [KPATH_MAX_CHARS + 1U];
static char das_native_inc[DAS_MAX_LINE];
static char das_native_dir[KPATH_MAX_CHARS + 1U];
static das_word_t das_native_rept_record[1U + DAS_REPT_PACK_WORDS];
#endif
static char das_native_line[DAS_MAX_LINE];
static char das_native_tmp[DAS_MAX_LINE];
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static das_word_t das_native_relmap[DAS_NATIVE_RELMAP_WORDS];
static das_word_t das_native_output_buffer[DAS_OUTPUT_BUFFER_WORDS];
static das_word_t das_native_phase_input[DAS_WORD_INPUT_BUFFER];
/* DASIR2 line payloads must not share the output queue.  pass2_line() may
 * leave optimized machine words buffered across source lines, so decoding
 * the next source record into that same storage corrupts pending output. */
static das_word_t das_native_phase_line[DAS_REPT_PACK_WORDS];
#endif
static struct asmctx das_native_ctx;
#endif

#ifndef DAS_NATIVE
static int host_char_get(void *arg, unsigned int *ch)
{
    struct host_char_input *in;

    in = (struct host_char_input *)arg;
    if (in->pos >= in->count) {
#ifdef DAS_NATIVE
        int rc;

        rc = dsys_read(in->file->fd, in->buffer,
            DAS_CHAR_INPUT_BUFFER);
        if (rc == 0)
            return DAS_INPUT_EOF;
        if (rc < 0) {
            in->file->error = 1;
            return DAS_INPUT_ERROR;
        }
        in->count = (unsigned int)rc;
#else
        size_t n;

        n = fread(in->buffer, 1U, DAS_CHAR_INPUT_BUFFER,
            in->file);
        if (n == 0U)
            return ferror(in->file) ? DAS_INPUT_ERROR : DAS_INPUT_EOF;
        in->count = (unsigned int)n;
#endif
        in->pos = 0U;
    }
    *ch = (unsigned int)(unsigned char)in->buffer[in->pos++];
    return DAS_INPUT_OK;
}

#endif
static int host_word_get(void *arg, das_word_t *word)
{
    struct host_word_input *in;

    in = (struct host_word_input *)arg;
    if (in->pos >= in->count) {
#ifdef DAS_NATIVE
        int rc;

        rc = dsys_read_words(in->file->fd, (kword_t *)in->buffer,
            DAS_WORD_INPUT_BUFFER);
        if (rc == 0)
            return DAS_INPUT_EOF;
        if (rc < 0) {
            in->file->error = 1;
            return DAS_INPUT_ERROR;
        }
        in->count = (unsigned int)rc;
#else
        unsigned int n;

        in->count = 0U;
        for (n = 0U; n < DAS_WORD_INPUT_BUFFER; n++) {
            das_word_t value;
            unsigned int i;
            int c;

            value = DAS_W(0);
            for (i = 0U; i < 8U; i++) {
                c = fgetc(in->file);
                if (c == EOF) {
                    if (i != 0U || ferror(in->file))
                        return DAS_INPUT_ERROR;
                    break;
                }
                value |= ((das_word_t)(unsigned int)c) << (i * 8U);
            }
            if (i == 0U)
                break;
            if ((value & ~DAS_WORD_MASK) != DAS_W(0))
                return DAS_INPUT_ERROR;
            in->buffer[in->count++] = value;
        }
        if (in->count == 0U)
            return DAS_INPUT_EOF;
#endif
        in->pos = 0U;
    }
    *word = in->buffer[in->pos++];
    return DAS_INPUT_OK;
}

#ifdef DAS_NATIVE
static void das_native_die(unsigned int code)
{
    (void)fprintf(stderr, code);
    exit(1);
}
#define die(msg) das_native_die((unsigned int)(__LINE__ & 077777U))
#else
static void die(const char *msg) { fprintf(stderr, "das: %s\n", msg); exit(1); }
#endif
static unsigned int das_work_words(unsigned int relmap_words)
{
    das_word_t words;

    words = (das_word_t)DAS_FIXED_WORK_WORDS;
    words += (das_word_t)relmap_words;
    if (words > (das_word_t)DAS_MAX_WORK_WORDS)
        die(DAS_DIAG("work memory exceeded", "64 kword work-memory budget exceeded"));
    return (unsigned int)words;
}
static void das_note_work(struct asmctx *c, unsigned int relmap_words)
{
    unsigned int words;

    words = das_work_words(relmap_words);
    if (words > c->peak_work_words)
        c->peak_work_words = words;
}
static void strcopy(char *d, const char *s, size_t n) { if (!n) return; while (n > 1 && *s) { *d++ = *s++; n--; } *d = 0; }
static size_t char_distance(const char *first, const char *last)
{
    size_t n;

    n = 0U;
    while (first != last) {
        first++;
        n++;
    }
    return n;
}
static char *skipws(char *p) { while (*p && isspace((unsigned char)*p)) p++; return p; }
static void rtrim(char *p) { size_t n = strlen(p); while (n && isspace((unsigned char)p[n - 1])) p[--n] = 0; }
#ifdef DAS_NATIVE
static int streqi(const char *a, const char *b) { return strcmp(a, b) == 0; }
static int pref_i(const char *a, const char *b, size_t n) { size_t i; for (i = 0; i < n; i++) if (a[i] != b[i]) return 0; return 1; }
#else
static int streqi(const char *a, const char *b) { while (*a && *b) { if (tolower((unsigned char)*a) != tolower((unsigned char)*b)) return 0; a++; b++; } return *a == 0 && *b == 0; }
static int pref_i(const char *a, const char *b, size_t n) { size_t i; for (i = 0; i < n; i++) if (tolower((unsigned char)a[i]) != tolower((unsigned char)b[i])) return 0; return 1; }
#endif
#define DAS_KEY3(a,b,c) (DAS_OP3((a),(b),(c)) << 18)
#define DAS_KEY4(a,b,c,d) (DAS_OP4((a),(b),(c),(d)) << 12)
#define DAS_KEY5(a,b,c,d,e) (DAS_OP5((a),(b),(c),(d),(e)) << 6)
#define DAS_KEY6(a,b,c,d,e,f) DAS_OP6((a),(b),(c),(d),(e),(f))

struct das_token_entry {
    das_word_t key;
    enum das_token token;
};

static das_word_t token_key(const char *s)
{
    das_word_t w;
    unsigned int n;

    w = DAS_W(0);
    n = 0U;
    while (*s != 0 && n < 6U) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)*s++;
        if (ch >= 'a' && ch <= 'z')
            ch = ch - 'a' + 'A';
        w = (w << 6) | (das_word_t)(ch - 'A' + 1U);
        n++;
    }
    while (n++ < 6U)
        w <<= 6;
    return w;
}

static enum das_token classify_token(struct asmctx *c, const char *key)
{
    static const struct das_token_entry table[] = {
        {DAS_KEY5('A','L','I','G','N'), DAS_TOK_ALIGN},
        {DAS_KEY5('A','S','C','I','I'), DAS_TOK_ASCII},
        {DAS_KEY5('A','S','C','I','Z'), DAS_TOK_ASCIZ},
        {DAS_KEY5('B','L','O','C','K'), DAS_TOK_BLOCK},
        {DAS_KEY3('B','S','S'), DAS_TOK_BSS},
        {DAS_KEY4('B','Y','T','E'), DAS_TOK_BYTE},
        {DAS_KEY4('C','O','D','E'), DAS_TOK_TEXT},
        {DAS_KEY4('C','O','M','M'), DAS_TOK_COMM},
        {DAS_KEY6('C','O','M','M','O','N'), DAS_TOK_COMM},
        {DAS_KEY5('C','O','N','S','T'), DAS_TOK_DATA},
        {DAS_KEY4('D','A','T','A'), DAS_TOK_DATA},
        {DAS_KEY3('E','N','D'), DAS_TOK_NO_WORDS},
        {DAS_KEY5('E','N','D','P','S'), DAS_TOK_NO_WORDS},
        {DAS_KEY5('E','N','T','R','Y'), DAS_TOK_ENTRY},
        {DAS_KEY3('E','Q','U'), DAS_TOK_EQU},
        {DAS_KEY5('E','R','R','O','R'), DAS_TOK_ERROR},
        {DAS_KEY3('E','X','P'), DAS_TOK_EXP},
        {DAS_KEY6('E','X','T','E','R','N'), DAS_TOK_EXTERN},
        {DAS_KEY4('F','I','L','E'), DAS_TOK_NO_WORDS},
        {DAS_KEY3('G','I','W'), DAS_TOK_GIW},
        {DAS_KEY6('G','L','O','B','A','L'), DAS_TOK_GLOBAL},
        {DAS_KEY5('G','L','O','B','L'), DAS_TOK_GLOBAL},
        {DAS_KEY5('I','D','E','N','T'), DAS_TOK_NO_WORDS},
        {DAS_KEY5('L','C','O','M','M'), DAS_TOK_LCOMM},
        {DAS_KEY3('L','O','C'), DAS_TOK_NO_WORDS},
        {DAS_KEY4('L','O','N','G'), DAS_TOK_LONG},
        {DAS_KEY3('O','R','G'), DAS_TOK_ORG},
        {DAS_KEY5('O','W','G','B','P'), DAS_TOK_OWGBP},
        {DAS_KEY5('P','O','I','N','T'), DAS_TOK_POINT},
        {DAS_KEY5('P','S','E','C','T'), DAS_TOK_PSECT},
        {DAS_KEY5('R','A','D','I','X'), DAS_TOK_RADIX},
        {DAS_KEY6('R','O','D','A','T','A'), DAS_TOK_DATA},
        {DAS_KEY4('S','E','C','T'), DAS_TOK_PSECT},
        {DAS_KEY6('S','E','C','T','I','O'), DAS_TOK_PSECT},
        {DAS_KEY3('S','E','T'), DAS_TOK_SET},
        {DAS_KEY6('S','I','X','B','I','T'), DAS_TOK_SIXBIT},
        {DAS_KEY5('S','P','A','C','E'), DAS_TOK_SPACE},
        {DAS_KEY4('T','E','X','T'), DAS_TOK_TEXT},
        {DAS_KEY5('T','I','T','L','E'), DAS_TOK_NO_WORDS},
        {DAS_KEY6('W','A','R','N','I','N'), DAS_TOK_WARNING},
        {DAS_KEY4('W','O','R','D'), DAS_TOK_WORD},
        {DAS_KEY4('Z','E','R','O'), DAS_TOK_SPACE}
    };
    das_word_t k;
    unsigned int lo;
    unsigned int hi;
    unsigned int mid;
    unsigned int first;

    if (pref_i(key, "P2ALIGN", 7) && key[7] == 0)
        return DAS_TOK_ALIGN;
#ifdef DAS_NATIVE
    first = (unsigned int)((unsigned char)key[0] - 'A');
#else
    first = (unsigned int)(tolower((unsigned char)key[0]) - 'a');
#endif
    if (first >= 26U || ((DAS_W(0223544577) >> first) & DAS_W(1)) == 0)
        return DAS_TOK_OTHER;
    k = token_key(key);
    lo = 0U;
    hi = (unsigned int)(sizeof(table) / sizeof(table[0]));
    while (lo < hi) {
        mid = lo + (hi - lo) / 2U;
        c->parser_token_probes++;
        if (k < table[mid].key)
            hi = mid;
        else if (k > table[mid].key)
            lo = mid + 1U;
        else
            return table[mid].token;
    }
    return DAS_TOK_OTHER;
}
static int isname0(int c) { return isalpha((unsigned char)c) || c == '_' || c == '.' || c == '%' || c == '$'; }
static int isname(int c) { return isalnum((unsigned char)c) || c == '_' || c == '.' || c == '%' || c == '$'; }
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static das_word_t parse_octal_w(const char *s) { das_word_t v = 0; while (*s >= '0' && *s <= '7') { v = (v << 3) + (das_word_t)(*s - '0'); s++; } return v & DAS_WORD_MASK; }
static unsigned int parse_octal_u(const char *s) { return (unsigned int)(parse_octal_w(s) & DAS_HALF_MASK); }
#endif
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int is_octal_end(int c) { return c == 0 || isspace((unsigned char)c) || c == ',' || c == ')' || c == ']' || c == '+' || c == '-'; }
static int looks_octal_token(const char *s) { if (*s == '+' || *s == '-') s++; if (!(*s >= '0' && *s <= '7')) return 0; while (*s >= '0' && *s <= '7') s++; return is_octal_end((unsigned char)*s); }
static int looks_symbolic_data_expr(const struct das_parsed_line *parsed)
{
    const char *p;

    if (parsed->token != DAS_TOK_OTHER || parsed->was_pseudo ||
        *skipws(parsed->rest) != 0)
        return 0;
    p = parsed->stmt;
    if (!isname0((unsigned char)*p))
        return 0;
    while (isname((unsigned char)*p))
        p++;
    return *p != 0;
}
#endif
static das_word_t sixbit_mn(const char *s) { das_word_t w = 0; int n = 0; while (*s && n < 6) { unsigned char ch = (unsigned char)*s++; if (ch >= 'a' && ch <= 'z') ch = (unsigned char)(ch - 'a' + 'A'); if (ch >= 'A' && ch <= 'Z') { w = (w << 6) | (das_word_t)(ch - 'A' + 1); n++; } } return w; }
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static das_word_t sixbit_ascii(const char *s) { das_word_t w = 0; int i; for (i = 0; i < 6; i++) { unsigned int c = 0; if (s[i]) { unsigned char ch = (unsigned char)s[i]; if (ch >= 'a' && ch <= 'z') ch = (unsigned char)(ch - 'a' + 'A'); if (ch >= ' ' && ch <= '_') c = ch - ' '; } w = (w << 6) | (c & 077); } return w & DAS_WORD_MASK; }
#endif
static int das_strict_base = 0;
static int das_kernel_mode = 0;
#ifndef DAS_NATIVE
static int das_memory_report = 0;
static const char *das_labels_out = 0;
#endif
static int lookup_extra_op_mn(das_word_t m)
{
    struct op_entry {
        das_word_t name;
        unsigned int op;
    };
    static const struct op_entry table[] = {
        {DAS_OP5('P','M','O','V','E'),     0052U},
        {DAS_OP6('P','M','O','V','E','M'), 0053U},
        {DAS_OP4('U','J','E','N'),         0100U},
        {DAS_OP4('G','F','A','D'),         0102U},
        {DAS_OP4('G','F','S','B'),         0103U},
        {DAS_OP4('J','S','Y','S'),         0104U},
        {DAS_OP4('G','F','M','P'),         0106U},
        {DAS_OP4('G','F','D','V'),         0107U},
        {DAS_OP4('C','I','R','C'),         0247U},
        {DAS_OP5('A','P','R','I','D'),     0700U},
        {DAS_OP5('U','M','O','V','E'),     0704U},
        {DAS_OP6('U','M','O','V','E','M'), 0705U},
        {DAS_OP4('T','I','O','E'),         0710U},
        {DAS_OP4('T','I','O','N'),         0711U},
        {DAS_OP4('R','D','I','O'),         0712U},
        {DAS_OP4('W','R','I','O'),         0713U},
        {DAS_OP4('B','S','I','O'),         0714U},
        {DAS_OP4('B','C','I','O'),         0715U},
        {DAS_OP5('T','I','O','E','B'),     0720U},
        {DAS_OP5('T','I','O','N','B'),     0721U},
        {DAS_OP5('R','D','I','O','B'),     0722U},
        {DAS_OP5('W','R','I','O','B'),     0723U},
        {DAS_OP5('B','S','I','O','B'),     0724U},
        {DAS_OP5('B','C','I','O','B'),     0725U}
    };
    unsigned int i;

    for (i = 0U; i < (unsigned int)(sizeof(table) / sizeof(table[0])); i++)
        if (table[i].name == m)
            return (int)table[i].op;
    return -1;
}
static int lookup_op(const char *s, int *nonbase)
{
    das_word_t m;
    int op;

    m = sixbit_mn(s);
    op = lookup_op_mn(m, nonbase);
    if (op >= 0)
        return op;
    op = lookup_extra_op_mn(m);
    if (op >= 0 && nonbase != 0)
        *nonbase = 1;
    return op;
}
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int lookup_fixed_ac_alias(const char *s, unsigned int *op, unsigned int *ac)
{
    struct alias_entry {
        das_word_t name;
        unsigned int code;
    };
    static const struct alias_entry table[] = {
        {DAS_OP6('P','O','R','T','A','L'), (0254U << 4) | 01U},
        {DAS_OP5('J','R','S','T','F'),     (0254U << 4) | 02U},
        {DAS_OP6('X','J','R','S','T','F'), (0254U << 4) | 05U},
        {DAS_OP4('X','J','E','N'),         (0254U << 4) | 06U},
        {DAS_OP4('X','P','C','W'),         (0254U << 4) | 07U},
        {DAS_OP3('J','E','N'),             (0254U << 4) | 012U},
        {DAS_OP3('S','F','M'),             (0254U << 4) | 014U},
        {DAS_OP5('X','J','R','S','T'),     (0254U << 4) | 015U},
        {DAS_OP4('J','F','O','V'),         (0255U << 4) | 01U},
        {DAS_OP3('J','O','V'),             (0255U << 4) | 010U},
        {DAS_OP6('C','L','R','S','C','H'), (0701U << 4) | 00U},
        {DAS_OP5('R','D','U','B','R'),     (0701U << 4) | 01U},
        {DAS_OP5('C','L','R','P','T'),     (0701U << 4) | 02U},
        {DAS_OP5('W','R','U','B','R'),     (0701U << 4) | 03U},
        {DAS_OP5('W','R','E','B','R'),     (0701U << 4) | 04U},
        {DAS_OP5('R','D','E','B','R'),     (0701U << 4) | 05U},
        {DAS_OP5('R','D','S','P','B'),     (0702U << 4) | 00U},
        {DAS_OP5('R','D','C','S','B'),     (0702U << 4) | 01U},
        {DAS_OP5('R','D','P','U','R'),     (0702U << 4) | 02U},
        {DAS_OP6('R','D','C','S','T','M'), (0702U << 4) | 03U},
        {DAS_OP6('R','D','T','I','M','E'), (0702U << 4) | 04U},
        {DAS_OP5('R','D','I','N','T'),     (0702U << 4) | 05U},
        {DAS_OP5('R','D','H','S','B'),     (0702U << 4) | 06U},
        {DAS_OP3('S','P','M'),             (0702U << 4) | 07U},
        {DAS_OP5('W','R','S','P','B'),     (0702U << 4) | 010U},
        {DAS_OP5('W','R','C','S','B'),     (0702U << 4) | 011U},
        {DAS_OP5('W','R','P','U','R'),     (0702U << 4) | 012U},
        {DAS_OP6('W','R','C','S','T','M'), (0702U << 4) | 013U},
        {DAS_OP6('W','R','T','I','M','E'), (0702U << 4) | 014U},
        {DAS_OP5('W','R','I','N','T'),     (0702U << 4) | 015U},
        {DAS_OP5('W','R','H','S','B'),     (0702U << 4) | 016U},
        {DAS_OP4('L','P','M','R'),         (0702U << 4) | 017U}
    };
    das_word_t m;
    unsigned int i;
    unsigned int code;

    m = sixbit_mn(s);
    if (m == DAS_OP4('J','C','R','Y')) {
        const char *q;

        q = s;
        while (*q && !isdigit((unsigned char)*q))
            q++;
        *op = 0255U;
        if (*q == '1' && q[1] == 0)
            *ac = 02U;
        else if (*q == '0' && q[1] == 0)
            *ac = 04U;
        else if (*q == 0)
            *ac = 06U;
        else
            return 0;
        return 1;
    }
    for (i = 0U; i < (unsigned int)(sizeof(table) / sizeof(table[0])); i++) {
        if (table[i].name != m)
            continue;
        code = table[i].code;
        *op = code >> 4;
        *ac = code & 017U;
        return 1;
    }
    return 0;
}
#endif
static int lookup_io(const char *s)
{
    static const das_word_t table[] = {
        DAS_OP4('B','L','K','I'),
        DAS_OP5('D','A','T','A','I'),
        DAS_OP4('B','L','K','O'),
        DAS_OP5('D','A','T','A','O'),
        DAS_OP4('C','O','N','O'),
        DAS_OP4('C','O','N','I'),
        DAS_OP5('C','O','N','S','Z'),
        DAS_OP5('C','O','N','S','O')
    };
    das_word_t m;
    unsigned int i;

    m = sixbit_mn(s);
    for (i = 0U; i < (unsigned int)(sizeof(table) / sizeof(table[0])); i++)
        if (table[i] == m)
            return (int)i;
    return -1;
}
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static das_word_t das_enc_io(unsigned int dev, unsigned int fn, int ind, int xr, unsigned int y) { return das_mask36((DAS_W(7) << 33) | ((das_word_t)((dev >> 2) & 0177U) << 26) | ((das_word_t)(fn & 7U) << 23) | ((das_word_t)(ind & 1) << 22) | ((das_word_t)(xr & 017) << 18) | (y & DAS_HALF_MASK)); }
#endif
static int wordfile_seek(struct das_wordfile *wf, unsigned int word)
{
    long off;

#ifdef DAS_NATIVE
    off = (long)word;
#else
    off = (long)word * 8L;
#endif
    return fseek(wf->file, off, SEEK_SET) == 0 ? 0 : -1;
}
static int wordfile_write(struct das_wordfile *wf,
                          const das_word_t *words, unsigned int count)
{
#ifdef DAS_NATIVE
    while (count != 0U) {
        int rc;

        rc = dsys_write_words(wf->file->fd, (kword_t *)words, count);
        if (rc <= 0)
            return -1;
        words += (unsigned int)rc;
        count -= (unsigned int)rc;
    }
    return 0;
#else
    unsigned int i;
    unsigned char raw[DAS_WORD_INPUT_BUFFER * 8U];

    while (count != 0U) {
        unsigned int chunk;
        unsigned int n;

        chunk = count > DAS_WORD_INPUT_BUFFER ?
            DAS_WORD_INPUT_BUFFER : count;
        for (n = 0U; n < chunk; n++) {
            das_word_t value;

            value = words[n] & DAS_WORD_MASK;
            for (i = 0U; i < 8U; i++) {
                raw[n * 8U + i] =
                    (unsigned char)(value & DAS_W(0377));
                value >>= 8U;
            }
        }
        if (fwrite(raw, 8U, chunk, wf->file) != chunk)
            return -1;
        words += chunk;
        count -= chunk;
    }
    return 0;
#endif
}

static int wordfile_read_words(struct das_wordfile *wf,
                               das_word_t *words, unsigned int count)
{
#ifdef DAS_NATIVE
    while (count != 0U) {
        int rc;

        rc = dsys_read_words(wf->file->fd, (kword_t *)words, count);
        if (rc <= 0)
            return -1;
        words += (unsigned int)rc;
        count -= (unsigned int)rc;
    }
    return 0;
#else
    unsigned char raw[DAS_WORD_INPUT_BUFFER * 8U];

    while (count != 0U) {
        unsigned int chunk;
        unsigned int n;
        unsigned int i;

        chunk = count > DAS_WORD_INPUT_BUFFER ?
            DAS_WORD_INPUT_BUFFER : count;
        if (fread(raw, 8U, chunk, wf->file) != chunk)
            return -1;
        for (n = 0U; n < chunk; n++) {
            das_word_t value;

            value = DAS_W(0);
            for (i = 0U; i < 8U; i++)
                value |= ((das_word_t)raw[n * 8U + i]) << (i * 8U);
            if ((value & ~DAS_WORD_MASK) != DAS_W(0))
                return -1;
            words[n] = value;
        }
        words += chunk;
        count -= chunk;
    }
    return 0;
#endif
}

static int wordfile_append(struct das_wordfile *wf,
                           const das_word_t *words,
                           unsigned int count)
{
    if (wordfile_seek(wf, wf->words) != 0)
        return -1;
    if (wordfile_write(wf, words, count) != 0)
        return -1;
    wf->words += count;
    return 0;
}

static int wordfile_read(struct das_wordfile *wf, unsigned int first,
                         das_word_t *words, unsigned int count)
{
    if (first > wf->words || count > wf->words - first)
        return -1;
    if (wordfile_seek(wf, first) != 0)
        return -1;
    return wordfile_read_words(wf, words, count);
}

static void pack_text_words(das_word_t *words, unsigned int nwords,
                            const char *text, unsigned int nchars)
{
    unsigned int i;
    unsigned int slot;
    unsigned int shift;

    for (i = 0U; i < nwords; i++)
        words[i] = DAS_W(0);
    for (i = 0U; i < nchars; i++) {
        slot = i & 3U;
        shift = 27U - slot * 9U;
        words[i >> 2] |=
            ((das_word_t)((unsigned char)text[i] & 0177U)) << shift;
    }
}
static void unpack_text_words(char *text, unsigned int cap,
                              const das_word_t *words,
                              unsigned int nchars)
{
    unsigned int i;
    unsigned int slot;
    unsigned int shift;

    if (cap == 0U)
        return;
    if (nchars >= cap)
        nchars = cap - 1U;
    for (i = 0U; i < nchars; i++) {
        slot = i & 3U;
        shift = 27U - slot * 9U;
        text[i] = (char)((words[i >> 2] >> shift) & DAS_W(0177));
    }
    text[nchars] = 0;
}
static das_word_t sym_hash(const char *name)
{
    das_word_t hash;

    hash = DAS_W(0);
    while (*name) {
        hash = das_mask36((hash << 5U) + hash +
            (das_word_t)((unsigned char)*name & 0177U));
        name++;
    }
    return hash;
}
static unsigned int sym_cache_index(das_word_t hash)
{
    return (unsigned int)((hash ^ (hash >> 18U)) %
        DAS_SYM_CACHE_ENTRIES);
}
static void sym_record_pack(das_word_t record[DAS_SYM_RECORD_WORDS],
                            unsigned int next, das_word_t hash,
                            const char *name, int sec, das_word_t value)
{
    unsigned int len;

    len = (unsigned int)strlen(name);
    if (len > DAS_MAX_NAME)
        len = DAS_MAX_NAME;
    record[0] = ((value >> 18U) & DAS_HALF_MASK) << 18U |
        (das_word_t)(next & DAS_HALF_MASK);
    record[1] = hash;
    record[2] = ((das_word_t)(len & 077U) << 23U) |
        ((das_word_t)((unsigned int)sec & 037U) << 18U) |
        (value & DAS_HALF_MASK);
    pack_text_words(record + 3U, DAS_SYM_NAME_WORDS, name, len);
}
static void sym_record_unpack(
    const das_word_t record[DAS_SYM_RECORD_WORDS], struct sym *sym)
{
    unsigned int len;

    len = (unsigned int)((record[2] >> 23U) & DAS_W(077));
    unpack_text_words(sym->name, sizeof(sym->name), record + 3U, len);
    sym->sec = (int)((record[2] >> 18U) & DAS_W(037));
    sym->off = (((record[0] >> 18U) & DAS_HALF_MASK) << 18U) |
        (record[2] & DAS_HALF_MASK);
}
#ifdef DAS_NATIVE
static int scratch_open(struct das_wordfile *wf, const char *base,
                        const char *suffix)
{
    size_t bn;
    size_t sn;

    bn = strlen(base);
    sn = strlen(suffix);
    if (bn + sn > KPATH_MAX_CHARS)
        return -1;
    strcopy(wf->path, base, sizeof(wf->path));
    strcopy(wf->path + bn, suffix, sizeof(wf->path) - bn);
    (void)remove(wf->path);
    wf->file = fopen(wf->path, "w+b");
    return wf->file == 0 ? -1 : 0;
}
#endif
#if !defined(DAS_PHASE2_PROGRAM) && !defined(DAS_NATIVE_PHASE2_ONLY)
static int store_init(struct asmctx *c, const char *scratch_base)
{
    memset(&c->sym_store, 0, sizeof(c->sym_store));
    memset(&c->lit_store, 0, sizeof(c->lit_store));
    memset(&c->rept_spill, 0, sizeof(c->rept_spill));
    memset(&c->ir_spill, 0, sizeof(c->ir_spill));
#ifdef DAS_NATIVE
    if (scratch_open(&c->sym_store.spill, scratch_base, ".DSY") != 0)
        return -1;
    if (scratch_open(&c->lit_store.spill, scratch_base, ".DLT") != 0) {
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        (void)remove(c->sym_store.spill.path);
        return -1;
    }
    if (scratch_open(&c->rept_spill, scratch_base, ".DRP") != 0) {
        fclose(c->lit_store.spill.file);
        c->lit_store.spill.file = 0;
        (void)remove(c->lit_store.spill.path);
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        (void)remove(c->sym_store.spill.path);
        return -1;
    }
    if (scratch_open(&c->ir_spill, scratch_base, ".D1R") != 0) {
        fclose(c->rept_spill.file);
        c->rept_spill.file = 0;
        (void)remove(c->rept_spill.path);
        fclose(c->lit_store.spill.file);
        c->lit_store.spill.file = 0;
        (void)remove(c->lit_store.spill.path);
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        (void)remove(c->sym_store.spill.path);
        return -1;
    }
#else
    (void)scratch_base;
    c->sym_store.spill.file = tmpfile();
    if (c->sym_store.spill.file == 0)
        return -1;
    c->lit_store.spill.file = tmpfile();
    if (c->lit_store.spill.file == 0) {
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        return -1;
    }
    c->rept_spill.file = tmpfile();
    if (c->rept_spill.file == 0) {
        fclose(c->lit_store.spill.file);
        c->lit_store.spill.file = 0;
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        return -1;
    }
    c->ir_spill.file = tmpfile();
    if (c->ir_spill.file == 0) {
        fclose(c->rept_spill.file);
        c->rept_spill.file = 0;
        fclose(c->lit_store.spill.file);
        c->lit_store.spill.file = 0;
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        return -1;
    }
#endif
    return 0;
}

#endif

#if !defined(DAS_NATIVE_PHASE1_ONLY) && \
    (defined(DAS_NATIVE) || defined(DAS_PHASE2_PROGRAM))
static int store_init_phase2(struct asmctx *c, const char *scratch_base)
{
    memset(&c->sym_store, 0, sizeof(c->sym_store));
    memset(&c->lit_store, 0, sizeof(c->lit_store));
    memset(&c->rept_spill, 0, sizeof(c->rept_spill));
    memset(&c->ir_spill, 0, sizeof(c->ir_spill));
#ifdef DAS_NATIVE
    if (scratch_open(&c->sym_store.spill, scratch_base, ".DSY") != 0)
        return -1;
    if (scratch_open(&c->lit_store.spill, scratch_base, ".DLT") != 0) {
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        (void)remove(c->sym_store.spill.path);
        return -1;
    }
#else
    (void)scratch_base;
    c->sym_store.spill.file = tmpfile();
    if (c->sym_store.spill.file == 0)
        return -1;
    c->lit_store.spill.file = tmpfile();
    if (c->lit_store.spill.file == 0) {
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
        return -1;
    }
#endif
    return 0;
}
#endif

static void store_close(struct asmctx *c)
{
    if (c->sym_store.spill.file != 0) {
        fclose(c->sym_store.spill.file);
        c->sym_store.spill.file = 0;
#ifdef DAS_NATIVE
        (void)remove(c->sym_store.spill.path);
#endif
    }
    if (c->lit_store.spill.file != 0) {
        fclose(c->lit_store.spill.file);
        c->lit_store.spill.file = 0;
#ifdef DAS_NATIVE
        (void)remove(c->lit_store.spill.path);
#endif
    }
    if (c->rept_spill.file != 0) {
        fclose(c->rept_spill.file);
        c->rept_spill.file = 0;
#ifdef DAS_NATIVE
        (void)remove(c->rept_spill.path);
#endif
    }
    if (c->ir_spill.file != 0) {
        fclose(c->ir_spill.file);
        c->ir_spill.file = 0;
#ifdef DAS_NATIVE
        (void)remove(c->ir_spill.path);
#endif
    }
}
static void sym_copy(struct sym *dst, const struct sym *src)
{
    strcopy(dst->name, src->name, sizeof(dst->name));
    dst->sec = src->sec;
    dst->off = src->off;
}
static int find_sym(struct asmctx *c, const char *name, struct sym *out)
{
    struct das_sym_store *store;
    struct das_sym_cache *cache;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    das_word_t hash;
    unsigned int bucket;
    unsigned int ref;
    unsigned int ci;
    struct sym found;

    store = &c->sym_store;
    hash = sym_hash(name);
    ci = sym_cache_index(hash);
    cache = &store->cache[ci];
    store->lookups++;
    if (cache->valid && cache->hash == hash &&
        strcmp(cache->sym.name, name) == 0) {
        sym_copy(out, &cache->sym);
        return 1;
    }
    bucket = (unsigned int)(hash & (DAS_SYM_BUCKETS - 1U));
    ref = store->heads[bucket];
    while (ref != 0U) {
        if (wordfile_read(&store->spill,
                (ref - 1U) * DAS_SYM_RECORD_WORDS,
                record, DAS_SYM_RECORD_WORDS) != 0)
            die("symbol scratch read failed");
        store->probes++;
        if (record[1] == hash) {
            sym_record_unpack(record, &found);
            if (strcmp(found.name, name) == 0) {
                cache->hash = hash;
                cache->record = ref;
                cache->valid = 1;
                sym_copy(&cache->sym, &found);
                sym_copy(out, &found);
                return 1;
            }
        }
        ref = (unsigned int)(record[0] & DAS_HALF_MASK);
    }
    return 0;
}
static void add_sym(struct asmctx *c, const char *name, int sec,
                    das_word_t value)
{
    struct das_sym_store *store;
    struct das_sym_cache *cache;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    das_word_t hash;
    unsigned int bucket;
    unsigned int ref;
    unsigned int ci;

    store = &c->sym_store;
    hash = sym_hash(name);
    bucket = (unsigned int)(hash & (DAS_SYM_BUCKETS - 1U));
    ref = store->records + 1U;
    sym_record_pack(record, store->heads[bucket], hash, name, sec, value);
    if (wordfile_append(&store->spill, record,
            DAS_SYM_RECORD_WORDS) != 0)
        die("symbol scratch write failed");
    store->heads[bucket] = ref;
    store->records = ref;
    ci = sym_cache_index(hash);
    cache = &store->cache[ci];
    cache->hash = hash;
    cache->record = ref;
    cache->valid = 1;
    strcopy(cache->sym.name, name, sizeof(cache->sym.name));
    cache->sym.sec = sec;
    cache->sym.off = value & DAS_WORD_MASK;
}

/* Indexed XCT can enter any word in its target table.  Keep a distinct
 * spill-backed marker namespace so this information costs no fixed RAM. */
#if DAS_ENABLE_OPTIMIZER
static das_word_t indexed_xct_hash(const char *name)
{
    return das_mask36(sym_hash(name) ^ DAS_W(0252525252525));
}

static int find_indexed_xct_marker(struct asmctx *c, const char *name)
{
    struct das_sym_store *store;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    das_word_t hash;
    unsigned int bucket;
    unsigned int ref;
    struct sym found;

    store = &c->sym_store;
    hash = indexed_xct_hash(name);
    bucket = (unsigned int)(hash & (DAS_SYM_BUCKETS - 1U));
    ref = store->heads[bucket];
    while (ref != 0U) {
        if (wordfile_read(&store->spill,
                (ref - 1U) * DAS_SYM_RECORD_WORDS,
                record, DAS_SYM_RECORD_WORDS) != 0)
            die("symbol scratch read failed");
        if (record[1] == hash) {
            sym_record_unpack(record, &found);
            if (strcmp(found.name, name) == 0 &&
                (found.sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_VIS)
                return 1;
        }
        ref = (unsigned int)(record[0] & DAS_HALF_MASK);
    }
    return 0;
}

#if !defined(DAS_NATIVE_PHASE2_ONLY)
static void mark_indexed_xct_target(struct asmctx *c, const char *name)
{
    struct das_sym_store *store;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    das_word_t hash;
    unsigned int bucket;
    unsigned int ref;

    if (find_indexed_xct_marker(c, name))
        return;
    store = &c->sym_store;
    hash = indexed_xct_hash(name);
    bucket = (unsigned int)(hash & (DAS_SYM_BUCKETS - 1U));
    ref = store->records + 1U;
    sym_record_pack(record, store->heads[bucket], hash, name,
        DAS_SEC_ABS | DAS_SYM_KIND_VIS, DAS_W(0));
    if (wordfile_append(&store->spill, record,
            DAS_SYM_RECORD_WORDS) != 0)
        die("symbol scratch write failed");
    store->heads[bucket] = ref;
    store->records = ref;
}
#endif
#endif

#if !defined(DAS_NATIVE_PHASE2_ONLY)
static das_word_t visibility_hash(const char *name)
{
    return das_mask36(sym_hash(name) ^ DAS_W(0525252525252));
}

static int find_visible_marker(struct asmctx *c, const char *name,
                               struct sym *out)
{
    struct das_sym_store *store;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    das_word_t hash;
    unsigned int bucket;
    unsigned int ref;
    struct sym found;

    store = &c->sym_store;
    hash = visibility_hash(name);
    bucket = (unsigned int)(hash & (DAS_SYM_BUCKETS - 1U));
    ref = store->heads[bucket];
    while (ref != 0U) {
        if (wordfile_read(&store->spill,
                (ref - 1U) * DAS_SYM_RECORD_WORDS,
                record, DAS_SYM_RECORD_WORDS) != 0)
            die("symbol scratch read failed");
        if (record[1] == hash) {
            sym_record_unpack(record, &found);
            if (strcmp(found.name, name) == 0 &&
                (found.sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_VIS) {
                sym_copy(out, &found);
                return 1;
            }
        }
        ref = (unsigned int)(record[0] & DAS_HALF_MASK);
    }
    return 0;
}

static void mark_symbol_visible(struct asmctx *c, const char *name)
{
    struct das_sym_store *store;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    das_word_t hash;
    unsigned int bucket;
    unsigned int ref;
    struct sym old;

    if (find_visible_marker(c, name, &old))
        return;
    store = &c->sym_store;
    hash = visibility_hash(name);
    bucket = (unsigned int)(hash & (DAS_SYM_BUCKETS - 1U));
    ref = store->records + 1U;
    sym_record_pack(record, store->heads[bucket], hash, name,
        DAS_SEC_ABS | DAS_SYM_KIND_VIS, (das_word_t)c->source_serial);
    if (wordfile_append(&store->spill, record,
            DAS_SYM_RECORD_WORDS) != 0)
        die("symbol scratch write failed");
    store->heads[bucket] = ref;
    store->records = ref;
}

static int symbol_visible_here(struct asmctx *c, const char *name)
{
    struct sym marker;

    if (!find_visible_marker(c, name, &marker))
        return 0;
    return (unsigned int)(marker.off & DAS_HALF_MASK) <= c->source_serial;
}
#endif

#ifndef DAS_NATIVE
static void sym_record_counts(struct asmctx *c, unsigned int *user_records,
                              unsigned int *visibility_records)
{
    das_word_t record[DAS_SYM_RECORD_WORDS];
    struct sym sym;
    unsigned int i;
    unsigned int users;
    unsigned int visibility;

    users = 0U;
    visibility = 0U;
    for (i = 0U; i < c->sym_store.records; i++) {
        if (wordfile_read(&c->sym_store.spill,
                i * DAS_SYM_RECORD_WORDS, record,
                DAS_SYM_RECORD_WORDS) != 0)
            die("symbol scratch read failed");
        sym_record_unpack(record, &sym);
        if ((sym.sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_VIS)
            visibility++;
        else
            users++;
    }
    *user_records = users;
    *visibility_records = visibility;
}

static unsigned int obj_global_find(struct asmctx *c, const char *name)
{
    unsigned int i;

    for (i = 0U; i < c->obj_global_count; i++) {
        if (strcmp(c->obj_globals[i].name, name) == 0)
            return i + 1U;
    }
    return 0U;
}

static unsigned int obj_global_add(struct asmctx *c, const char *name)
{
    struct das_obj_global *nv;
    unsigned int cap;
    unsigned int found;

    found = obj_global_find(c, name);
    if (found != 0U)
        return found;
    if (strlen(name) > DAS_MAX_NAME)
        die("object symbol name too long");
    if (c->obj_global_count == c->obj_global_cap) {
        cap = c->obj_global_cap == 0U ? 32U : c->obj_global_cap * 2U;
        nv = (struct das_obj_global *)realloc(c->obj_globals,
            (size_t)cap * sizeof(*nv));
        if (nv == 0)
            die("out of memory");
        c->obj_globals = nv;
        c->obj_global_cap = cap;
    }
    strcopy(c->obj_globals[c->obj_global_count].name, name,
        sizeof(c->obj_globals[c->obj_global_count].name));
    c->obj_global_count++;
    return c->obj_global_count;
}

static int obj_parse_global_list(struct asmctx *c, const char *rest)
{
    const char *p;
    char name[DAS_MAX_NAME + 1];
    unsigned int n;

    p = rest;
    for (;;) {
        while (*p != 0 && (isspace((unsigned char)*p) || *p == ','))
            p++;
        if (*p == 0)
            return 0;
        if (!isname0((unsigned char)*p))
            return -1;
        n = 0U;
        while (isname((unsigned char)*p)) {
            if (n >= DAS_MAX_NAME)
                return -1;
            name[n++] = *p++;
        }
        name[n] = 0;
        (void)obj_global_add(c, name);
        while (*p != 0 && isspace((unsigned char)*p))
            p++;
        if (*p != 0 && *p != ',')
            return -1;
    }
}

/*
 * DOBJ1 RH18 relocations carry only the address-field arithmetic addend.
 * The containing section word retains its left half, which may contain
 * opcode bits or GCC pointer metadata.  Preserve a sign-extended negative
 * RH18 addend; otherwise serialize only the unsigned RH18 contribution.
 */
static das_word_t obj_18_addend(das_word_t addend)
{
    unsigned int lh;
    unsigned int rh;

    lh = (unsigned int)((addend >> 18) & DAS_HALF_MASK);
    rh = DAS_MASK18(addend);
    if (lh == DAS_HALF_MASK && (rh & 0400000U) != 0U)
        return DAS_WORD(DAS_HALF_MASK, rh);
    return DAS_WORD(0U, rh);
}

static int obj_reloc_add(struct asmctx *c, int loc_sec, unsigned int offset,
                         int type, int target_sec, unsigned int symbol,
                         das_word_t addend)
{
    struct das_obj_reloc *nv;
    unsigned int cap;
    struct das_obj_reloc *r;

    if (c->obj_reloc_count == c->obj_reloc_cap) {
        cap = c->obj_reloc_cap == 0U ? 64U : c->obj_reloc_cap * 2U;
        nv = (struct das_obj_reloc *)realloc(c->obj_relocs,
            (size_t)cap * sizeof(*nv));
        if (nv == 0)
            return -1;
        c->obj_relocs = nv;
        c->obj_reloc_cap = cap;
    }
    r = &c->obj_relocs[c->obj_reloc_count++];
    r->loc_sec = loc_sec;
    r->offset = offset;
    r->type = type;
    r->target_sec = target_sec;
    r->symbol = symbol;
    r->addend = obj_18_addend(addend);
    return 0;
}
#endif

#ifndef DAS_NATIVE
static int write_labels_file(struct asmctx *c, const char *path)
{
    FILE *f;
    das_word_t record[DAS_SYM_RECORD_WORDS];
    struct sym sym;
    unsigned int i;
    unsigned int addr;

    if (!path)
        return 0;
    f = fopen(path, "w");
    if (!f) {
        perror(path);
        return 1;
    }
    for (i = 1U; i <= c->sym_store.records; i++) {
        if (wordfile_read(&c->sym_store.spill,
                (i - 1U) * DAS_SYM_RECORD_WORDS,
                record, DAS_SYM_RECORD_WORDS) != 0) {
            fclose(f);
            fprintf(stderr, DAS_DIAG("das: sym read\n", "das: symbol scratch read failed\n"));
            return 1;
        }
        sym_record_unpack(record, &sym);
        if ((sym.sec & DAS_SYM_KIND_MASK) != 0)
            continue;
        addr = sec_base(c, sym.sec & DAS_SYM_SEC_MASK) +
            (unsigned int)(sym.off & DAS_HALF_MASK);
        fprintf(f, "%-32s %06o\n", sym.name, addr & DAS_HALF_MASK);
    }
    if (fclose(f) != 0) {
        perror(path);
        return 1;
    }
    return 0;
}
#endif
static unsigned int lit_record_words(unsigned int len)
{
    return 1U + (len + DAS_TARGET_CHARS_PER_WORD - 1U) /
        DAS_TARGET_CHARS_PER_WORD;
}
static unsigned int literal_image_words(const char *expr, unsigned int len)
{
    char tmp[DAS_MAX_LINE];
    char mnem[32];
    char *p;
    char *comma;
    unsigned int n;

    if (len >= DAS_MAX_LINE)
        len = DAS_MAX_LINE - 1U;
    memcpy(tmp, expr, len);
    tmp[len] = 0;
    p = skipws(tmp);
    if ((pref_i(p, "POINT", 5) && isspace((unsigned char)p[5])) ||
        (pref_i(p, "GIW", 3) && isspace((unsigned char)p[3])) ||
        (pref_i(p, "OWGBP", 5) && isspace((unsigned char)p[5])) ||
        (pref_i(p, "%EXIND", 6) && p[6] == '('))
        return 1U;
    if (strstr(p, ",,") != 0)
        return 1U;
    n = 0U;
    while (p[n] != 0 && !isspace((unsigned char)p[n]) &&
           p[n] != ',' && n + 1U < sizeof(mnem)) {
        mnem[n] = p[n];
        n++;
    }
    mnem[n] = 0;
    if (n != 0U) {
        if (mnem[0] == '.')
            memmove(mnem, mnem + 1, strlen(mnem));
        if (lookup_op(mnem, (int *)0) >= 0 || lookup_io(mnem) >= 0)
            return 1U;
    }
    comma = strchr(p, ',');
    if (comma != 0 && strchr(comma + 1, ',') == 0)
        return 2U;
    return 1U;
}
static char *das_format_u10_digits(char *out, unsigned int value)
{
    if (value >= 10U)
        out = das_format_u10_digits(out, value / 10U);
    *out++ = (char)('0' + value % 10U);
    return out;
}

static unsigned int das_format_u10(char *out, unsigned int value)
{
    char *end;

    end = das_format_u10_digits(out, value);
    *end = 0;
    return (unsigned int)strlen(out);
}

static void das_format_octal(char *out, das_word_t value)
{
    char *p;
    int shift;
    int started;

    p = out;
    started = 0;
    for (shift = 33; shift >= 0; shift -= 3) {
        unsigned int digit;

        digit = (unsigned int)((value >> shift) & DAS_W(07));
        if (digit != 0U || started || shift == 0) {
            *p++ = (char)('0' + digit);
            started = 1;
        }
    }
    *p = 0;
}

static void set_snapshot_name(unsigned int generation, char *name,
                              unsigned int cap)
{
    char num[16];
    unsigned int used;
    unsigned int n;

    if (cap == 0U)
        return;
    strcopy(name, "%$DAS$S", cap);
    used = (unsigned int)strlen(name);
    n = das_format_u10(num, generation);
    if (used + n >= cap)
        n = cap - 1U - used;
    if (n != 0U)
        memcpy(name + used, num, n);
    name[used + n] = 0;
}

static int set_snapshot_lookup(struct asmctx *c, const struct sym *set_sym,
                               struct sym *snapshot)
{
    char name[DAS_MAX_NAME + 1];
    unsigned int generation;

    if ((set_sym->sec & DAS_SYM_KIND_MASK) != DAS_SYM_KIND_SET)
        return 0;
    generation = (unsigned int)(set_sym->off & DAS_HALF_MASK);
    if (generation == 0U || generation > c->set_serial)
        return 0;
    set_snapshot_name(generation, name, sizeof(name));
    if (!find_sym(c, name, snapshot))
        return 0;
    return (snapshot->sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_EQU;
}

static void set_snapshot_define(struct asmctx *c, unsigned int generation,
                                int sec, das_word_t value)
{
    char name[DAS_MAX_NAME + 1];

    set_snapshot_name(generation, name, sizeof(name));
    add_sym(c, name, sec | DAS_SYM_KIND_EQU, value);
}

#ifndef DAS_NATIVE
static int set_reloc_store(struct asmctx *c, unsigned int generation)
{
    struct das_set_reloc *nv;
    unsigned int cap;
    struct das_set_reloc *m;

    if (!c->object_mode || generation == 0U)
        return 0;
    if (generation > c->set_reloc_cap) {
        cap = c->set_reloc_cap == 0U ? 16U : c->set_reloc_cap;
        while (cap < generation)
            cap *= 2U;
        nv = (struct das_set_reloc *)realloc(c->set_relocs,
            cap * sizeof(*nv));
        if (nv == 0)
            return -1;
        memset(nv + c->set_reloc_cap, 0,
            (cap - c->set_reloc_cap) * sizeof(*nv));
        c->set_relocs = nv;
        c->set_reloc_cap = cap;
    }
    m = &c->set_relocs[generation - 1U];
    m->valid = c->eval_reloc_kind != 0;
    m->reloc_kind = c->eval_reloc_kind;
    m->target_sec = c->eval_target_sec;
    m->symbol = c->eval_symbol;
    m->addend = c->eval_addend;
    return 0;
}

#endif

static int literal_first_token_is_operator(const char *expr, const char *end)
{
    char name[DAS_MAX_NAME + 1];
    unsigned int n;
    int dummy;

    n = (unsigned int)(end - expr);
    if (n == 0U || n > DAS_MAX_NAME)
        return 0;
    memcpy(name, expr, n);
    name[n] = 0;
    if (name[0] == '.')
        memmove(name, name + 1, strlen(name));
    if (lookup_op(name, &dummy) >= 0 || lookup_io(name) >= 0)
        return 1;
    if (pref_i(name, "POINT", 5) || pref_i(name, "GIW", 3) ||
        pref_i(name, "OWGBP", 5) || pref_i(name, "%EXIND", 6))
        return 1;
    return 0;
}

/*
 * Freeze mutable .set references at the literal's source position.  Absolute
 * values are written as canonical octal constants.  Relocatable values use an
 * immutable internal symbol keyed by section/value, preserving relocation.
 * This keeps ordinary text deduplication while making .set-sensitive literals
 * compare by semantics rather than by their mutable source spelling.
 */
static int literal_canonicalize(struct asmctx *c, const char *expr,
                                unsigned int len, char *out,
                                unsigned int cap)
{
    const char *p;
    const char *end;
    unsigned int used;
    int quote;
    int first_token;

    if (cap == 0U)
        return -1;
    p = expr;
    end = expr + len;
    used = 0U;
    quote = 0;
    first_token = 1;
    while (p < end) {
        if (quote != 0) {
            if (used + 1U >= cap)
                return -1;
            out[used++] = *p;
            if (*p == quote)
                quote = 0;
            p++;
            continue;
        }
        if (*p == '\'' || *p == '"') {
            quote = (unsigned char)*p;
            if (used + 1U >= cap)
                return -1;
            out[used++] = *p++;
            continue;
        }
        if (isname0((unsigned char)*p)) {
            const char *q;
            char name[DAS_MAX_NAME + 1];
            unsigned int n;
            struct sym sym;
            int replace;

            q = p + 1;
            while (q < end && isname((unsigned char)*q))
                q++;
            n = (unsigned int)(q - p);
            replace = 0;
            if (n <= DAS_MAX_NAME) {
                memcpy(name, p, n);
                name[n] = 0;
                if (!(first_token && literal_first_token_is_operator(p, q)) &&
                    find_sym(c, name, &sym) &&
                    (sym.sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_SET)
                    replace = 1;
            }
            if (replace) {
                char rep[DAS_MAX_NAME + 24];
                struct sym snapshot;
                unsigned int generation;

                generation = (unsigned int)(sym.off & DAS_HALF_MASK);
                if (set_snapshot_lookup(c, &sym, &snapshot) &&
                    (snapshot.sec & DAS_SYM_SEC_MASK) == DAS_SEC_ABS) {
                    rep[0] = '0';
                    das_format_octal(rep + 1, snapshot.off & DAS_WORD_MASK);
                } else {
                    set_snapshot_name(generation, rep, sizeof(rep));
                }
                n = (unsigned int)strlen(rep);
                if (used + n >= cap)
                    return -1;
                memcpy(out + used, rep, n);
                used += n;
            } else {
                if (used + n >= cap)
                    return -1;
                memcpy(out + used, p, n);
                used += n;
            }
            p = q;
            first_token = 0;
            continue;
        }
        if (!isspace((unsigned char)*p))
            first_token = 0;
        if (used + 1U >= cap)
            return -1;
        out[used++] = *p++;
    }
    out[used] = 0;
    return (int)used;
}

static int lit_find_text(struct asmctx *c, const char *expr,
                         unsigned int len, unsigned int *image_off)
{
#ifndef DAS_NATIVE
    das_word_t record[DAS_LIT_RECORD_WORDS];
    char tmp[DAS_MAX_LINE];
#else
    das_word_t *record;
    char *tmp;
    das_word_t header;
#endif
    unsigned int pos;
    unsigned int off;
    unsigned int i;

#ifdef DAS_NATIVE
#if defined(DAS_NATIVE_PHASE1_ONLY)
    record = das_native_rept_record;
#else
    record = das_native_output_buffer;
#endif
    tmp = das_native_tmp;
#endif
    pos = 0U;
    off = 0U;
    for (i = 0U; i < c->lit_store.records; i++) {
        unsigned int oldlen;
        unsigned int words;

#ifndef DAS_NATIVE
        if (wordfile_read(&c->lit_store.spill, pos, record, 1U) != 0)
            die("literal scratch read failed");
        oldlen = (unsigned int)record[0];
#else
        if (wordfile_read(&c->lit_store.spill, pos, &header, 1U) != 0)
            die("literal scratch read failed");
        oldlen = (unsigned int)header;
#endif
        if (oldlen >= DAS_MAX_LINE)
            die("corrupt literal scratch record");
        words = lit_record_words(oldlen);
#ifndef DAS_NATIVE
        if (wordfile_read(&c->lit_store.spill, pos, record, words) != 0)
            die("literal scratch read failed");
        unpack_text_words(tmp, sizeof(tmp), record + 1U, oldlen);
#else
        if (words > 1U &&
            wordfile_read(&c->lit_store.spill, pos + 1U, record,
                words - 1U) != 0)
            die("literal scratch read failed");
        unpack_text_words(tmp, DAS_MAX_LINE, record, oldlen);
#endif
        if (oldlen == len) {
            unsigned int j;
            int same;

            same = 1;
            for (j = 0U; j < len; j++) {
                if (tmp[j] != expr[j]) {
                    same = 0;
                    break;
                }
            }
            if (same) {
                if (image_off != 0)
                    *image_off = off;
                return 1;
            }
        }
        off += literal_image_words(tmp, oldlen);
        pos += words;
    }
    return 0;
}
#if !defined(DAS_NATIVE_PHASE2_ONLY)
static void add_lit_text(struct asmctx *c, const char *expr, size_t n)
{
    das_word_t record[DAS_LIT_RECORD_WORDS];
    char canonical[DAS_MAX_LINE];
    unsigned int len;
    unsigned int words;
    int clen;

    len = (unsigned int)n;
    if (len >= DAS_MAX_LINE)
        len = DAS_MAX_LINE - 1U;
    clen = literal_canonicalize(c, expr, len, canonical, sizeof(canonical));
    if (clen >= 0) {
        expr = canonical;
        len = (unsigned int)clen;
    }
    if (lit_find_text(c, expr, len, (unsigned int *)0))
        return;
    words = lit_record_words(len);
    record[0] = (das_word_t)len;
    pack_text_words(record + 1U, words - 1U, expr, len);
    if (wordfile_append(&c->lit_store.spill, record, words) != 0)
        die("literal scratch write failed");
    c->lit_store.records++;
    c->lit_store.words += words;
    c->lit_store.image_words += literal_image_words(expr, len);
}
#endif
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static void lit_stream_reset(struct asmctx *c)
{
    c->lit_store.read_next = 0U;
    c->lit_store.read_pos = 0U;
    c->lit_store.read_count = 0U;
    c->lit_store.read_records = 0U;
}
static int lit_stream_word(struct asmctx *c, das_word_t *word)
{
    struct das_lit_store *store;
    unsigned int count;

    store = &c->lit_store;
    if (store->read_pos >= store->read_count) {
        if (store->read_next >= store->words)
            return -1;
        count = store->words - store->read_next;
        if (count > DAS_WORD_INPUT_BUFFER)
            count = DAS_WORD_INPUT_BUFFER;
        if (wordfile_read(&store->spill, store->read_next,
                store->read_buffer, count) != 0)
            return -1;
        store->read_next += count;
        store->read_pos = 0U;
        store->read_count = count;
    }
    *word = store->read_buffer[store->read_pos++];
    return 0;
}
static int lit_read_next(struct asmctx *c, char *expr, unsigned int cap)
{
    das_word_t header;
    das_word_t packed;
    unsigned int len;
    unsigned int i;
    unsigned int slot;
    unsigned int shift;

    if (c->lit_store.read_records >= c->lit_store.records)
        return -1;
    if (lit_stream_word(c, &header) != 0)
        return -1;
    len = (unsigned int)header;
    if (len >= DAS_MAX_LINE || cap == 0U || len >= cap)
        return -1;
    packed = DAS_W(0);
    for (i = 0U; i < len; i++) {
        slot = i & 3U;
        if (slot == 0U && lit_stream_word(c, &packed) != 0)
            return -1;
        shift = 27U - slot * 9U;
        expr[i] = (char)((packed >> shift) & DAS_W(0177));
    }
    expr[len] = 0;
    c->lit_store.read_records++;
    return 0;
}
#endif

static unsigned int text_total(struct asmctx *c)
{
    return c->loc[DAS_SEC_TEXT] + c->lit_store.image_words;
}
static unsigned int sec_base(struct asmctx *c, int sec) { if (sec == DAS_SEC_ABS || sec == DAS_SEC_REL || sec == DAS_SEC_TEXT) return 0; if (sec == DAS_SEC_DATA) return text_total(c); return text_total(c) + c->loc[DAS_SEC_DATA]; }
static void strip_brackets(char *s) { char *p = skipws(s); size_t n; if (p != s) memmove(s, p, strlen(p) + 1); n = strlen(s); while (n && isspace((unsigned char)s[n - 1])) s[--n] = 0; if (n >= 2 && s[0] == '[' && s[n - 1] == ']') { memmove(s, s + 1, n - 2); s[n - 2] = 0; } }
static __inline__ int
parse_expr_integer_base(char **pp, das_word_t *value, int default_base)
{
    char *p;
    char *end;
    int base;
    int ch;

    p = *pp;
    base = default_base;
    if (*p == '0') {
        ch = p[1] | 040;
        if (ch == 'd') {
            base = 10;
            p += 2;
        } else if (ch == 'o') {
            base = 8;
            p += 2;
        } else if (ch == 'x') {
            base = 16;
            p += 2;
        } else if (ch == 'b') {
            base = 2;
            p += 2;
        } else if (p[1] >= '0' && p[1] <= '7') {
            base = 8;
        }
    }
#ifdef DAS_NATIVE
    *value = das_mask36((das_word_t)strtoul(p, &end, base));
#else
    *value = das_mask36((das_word_t)strtoull(p, &end, base));
#endif
    if (end == p)
        return -1;
    *pp = end;
    return 0;
}

static __inline__ int parse_expr_integer(char **pp, das_word_t *value)
{
    return parse_expr_integer_base(pp, value, 8);
}

static int opt_octal_ac(const char **pp, unsigned int *ac);

#if DAS_ENABLE_OPTIMIZER
static int opt_move_literal_immediate(struct das_parsed_line *parsed,
                                      unsigned int *ac, unsigned int *value)
{
    char *p;
    das_word_t v;

    if (!das_optimize || parsed->token != DAS_TOK_OTHER ||
        parsed->mnemonic != DAS_OP4('M','O','V','E'))
        return 0;
    if (!parsed->has_operand_ac)
        return 0;
    *ac = parsed->operand_ac;
    p = parsed->operand;
    if (*p++ != '[')
        return 0;
    p = skipws(p);
    if (*p == '-' || parse_expr_integer(&p, &v) != 0 ||
        v > DAS_W(0777777))
        return 0;
    p = skipws(p);
    if (*p++ != ']')
        return 0;
    if (*skipws(p) != 0)
        return 0;
    *value = (unsigned int)v;
    return 1;
}
#endif

struct expr_state {
    struct asmctx *c;
    const char *input;
    char *p;
    unsigned int dot;
    int default_base;
    int failed;
};

struct expr_value {
    das_word_t value;
    int rel;
#ifndef DAS_NATIVE
    int reloc_kind;
    int target_sec;
    unsigned int symbol;
#endif
};

#ifndef DAS_NATIVE
static int set_reloc_apply(struct asmctx *c, unsigned int generation,
                           struct expr_value *out)
{
    struct das_set_reloc *m;

    if (!c->object_mode || generation == 0U ||
        generation > c->set_reloc_cap)
        return 0;
    m = &c->set_relocs[generation - 1U];
    if (!m->valid)
        return 0;
    out->reloc_kind = m->reloc_kind;
    out->target_sec = m->target_sec;
    out->symbol = m->symbol;
    out->value = m->addend;
    return 1;
}
#endif

static void expr_error(struct expr_state *st, const char *msg)
{
    if (!st->failed && !st->c->eval_silent)
        fprintf(stderr, DAS_DIAG("das: bad expr\n", "das: %s %s\n"),
                msg, st->input);
    st->failed = 1;
}

static struct expr_value expr_abs(das_word_t value)
{
    struct expr_value v;
    v.value = das_mask36(value);
    v.rel = 0;
#ifndef DAS_NATIVE
    v.reloc_kind = 0;
    v.target_sec = DAS_SEC_ABS;
    v.symbol = 0U;
#endif
    return v;
}

static int expr_require_abs(struct expr_state *st, struct expr_value a,
                            struct expr_value b)
{
    if (a.rel != 0 || b.rel != 0) {
        if (!st->failed)
            fprintf(stderr, DAS_DIAG("das: bad relocation\n",
                    "das: unsupported relocation expression %s\n"),
                    st->input);
        st->failed = 1;
        return -1;
    }
    return 0;
}

static das_word_t expr_shift_right(das_word_t value, unsigned int count)
{
    das_word_t sign;
    das_word_t fill;

    if (count == 0U)
        return das_mask36(value);
    if (count >= 36U)
        return (value & DAS_W(0400000000000)) ? DAS_WORD_MASK : DAS_W(0);
    sign = value & DAS_W(0400000000000);
    value >>= count;
    if (sign) {
        fill = DAS_WORD_MASK ^ (DAS_WORD_MASK >> count);
        value |= fill;
    }
    return das_mask36(value);
}

static das_word_t expr_signed_div(das_word_t a, das_word_t b, int remainder)
{
    int aneg, bneg;
    das_word_t amag, bmag, q;

    aneg = (a & DAS_W(0400000000000)) != 0;
    bneg = (b & DAS_W(0400000000000)) != 0;
    amag = aneg ? das_mask36(DAS_W(0) - a) : a;
    bmag = bneg ? das_mask36(DAS_W(0) - b) : b;
    if (remainder) {
        q = amag % bmag;
        if (aneg)
            q = das_mask36(DAS_W(0) - q);
    } else {
        q = amag / bmag;
        if (aneg != bneg)
            q = das_mask36(DAS_W(0) - q);
    }
    return q;
}

static struct expr_value parse_expr_or(struct expr_state *st);

#ifndef DAS_NATIVE
static void expr_set_local(struct expr_value *v, int sec)
{
    v->reloc_kind = DAS_OBJ_RELOC_LOCAL_RH18;
    v->target_sec = sec;
    v->symbol = 0U;
}

static void expr_set_symbol(struct expr_value *v, unsigned int symbol)
{
    v->reloc_kind = DAS_OBJ_RELOC_SYMBOL_RH18;
    v->target_sec = DAS_SEC_ABS;
    v->symbol = symbol;
}
#endif

static unsigned int set_snapshot_generation(const char *name)
{
    const char *p;
    unsigned long value;
    char *end;

    if (!pref_i(name, "%$DAS$S", 7))
        return 0U;
    p = name + 7;
    if (*p < '0' || *p > '9')
        return 0U;
    value = strtoul(p, &end, 10);
    if (*end != 0 || value == 0UL || value > (unsigned long)DAS_HALF_MASK)
        return 0U;
    return (unsigned int)value;
}

static int resolve_set_symbol(struct asmctx *c, struct sym *sym)
{
    struct sym snapshot;

    if ((sym->sec & DAS_SYM_KIND_MASK) != DAS_SYM_KIND_SET)
        return 1;
    if (!set_snapshot_lookup(c, sym, &snapshot))
        return 0;
    *sym = snapshot;
    return 1;
}

static struct expr_value parse_expr_primary(struct expr_state *st)
{
    struct expr_value out;
    struct sym sym;
    char tok[DAS_MAX_NAME + 1];
    char *q;
    das_word_t v;
    unsigned int set_generation;
    int n;

    out = expr_abs(DAS_W(0));
    st->p = skipws(st->p);
    if (*st->p == '(') {
        st->p++;
        out = parse_expr_or(st);
        st->p = skipws(st->p);
        if (*st->p != ')') {
            expr_error(st, "malformed expression");
            return out;
        }
        st->p++;
        return out;
    }
    if (*st->p == '.' && isdigit((unsigned char)st->p[1])) {
        q = st->p + 1;
        n = 2;
        tok[0] = '%';
        tok[1] = 'L';
        while (isdigit((unsigned char)*q) && n < DAS_MAX_NAME)
            tok[n++] = *q++;
        tok[n] = 0;
        if (!find_sym(st->c, tok, &sym)) {
#ifndef DAS_NATIVE
            unsigned int gi;
            gi = st->c->object_mode ? obj_global_find(st->c, tok) : 0U;
            if (gi != 0U) {
                out.value = DAS_W(0);
                out.rel = 1;
                expr_set_symbol(&out, gi);
                st->p = q;
                return out;
            }
#endif
            if (!st->c->eval_silent)
                fprintf(stderr, DAS_DIAG("das: undef\n", "das: undefined symbol %s\n"), tok);
            st->failed = 1;
            return out;
        }
        set_generation = (sym.sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_SET ?
            (unsigned int)(sym.off & DAS_HALF_MASK) :
            set_snapshot_generation(tok);
        if (!resolve_set_symbol(st->c, &sym)) {
            if (!st->c->eval_silent)
                fprintf(stderr, DAS_DIAG("das: undef\n",
                    "das: undefined symbol %s\n"), tok);
            st->failed = 1;
            return out;
        }
        if ((sym.sec & DAS_SYM_SEC_MASK) == DAS_SEC_REL)
            out.value = sym.off;
        else
            out.value = sec_base(st->c, sym.sec & DAS_SYM_SEC_MASK) + sym.off;
        out.value = das_mask36(out.value);
        out.rel = (sym.sec & DAS_SYM_SEC_MASK) != DAS_SEC_ABS;
#ifndef DAS_NATIVE
        if (out.rel) {
            expr_set_local(&out, sym.sec & DAS_SYM_SEC_MASK);
            if (set_generation != 0U)
                (void)set_reloc_apply(st->c, set_generation, &out);
        }
#endif
        st->p = q;
        return out;
    }
    if (*st->p == '.') {
        out.value = st->dot;
        out.rel = 1;
#ifndef DAS_NATIVE
        expr_set_local(&out, -1);
#endif
        st->p++;
        return out;
    }
    if (isdigit((unsigned char)*st->p)) {
        q = st->p;
        if (parse_expr_integer_base(&q, &v, st->default_base) != 0) {
            expr_error(st, "malformed expression");
            return out;
        }
        out.value = v;
        st->p = q;
        return out;
    }
    if (isname0((unsigned char)*st->p)) {
        n = 0;
        while (isname((unsigned char)*st->p) && n < DAS_MAX_NAME)
            tok[n++] = *st->p++;
        tok[n] = 0;
        if (!find_sym(st->c, tok, &sym)) {
#ifndef DAS_NATIVE
            unsigned int gi;
            gi = st->c->object_mode ? obj_global_add(st->c, tok) : 0U;
            if (gi != 0U) {
                out.value = DAS_W(0);
                out.rel = 1;
                expr_set_symbol(&out, gi);
                return out;
            }
#endif
            if (!st->c->eval_silent)
                fprintf(stderr, DAS_DIAG("das: undef\n", "das: undefined symbol %s\n"), tok);
            st->failed = 1;
            return out;
        }
        set_generation = (sym.sec & DAS_SYM_KIND_MASK) == DAS_SYM_KIND_SET ?
            (unsigned int)(sym.off & DAS_HALF_MASK) :
            set_snapshot_generation(tok);
        if (!resolve_set_symbol(st->c, &sym)) {
            if (!st->c->eval_silent)
                fprintf(stderr, DAS_DIAG("das: undef\n",
                    "das: undefined symbol %s\n"), tok);
            st->failed = 1;
            return out;
        }
        if ((sym.sec & DAS_SYM_SEC_MASK) == DAS_SEC_REL)
            out.value = sym.off;
        else
            out.value = sec_base(st->c, sym.sec & DAS_SYM_SEC_MASK) + sym.off;
        out.value = das_mask36(out.value);
        out.rel = (sym.sec & DAS_SYM_SEC_MASK) != DAS_SEC_ABS;
#ifndef DAS_NATIVE
        if (out.rel) {
            expr_set_local(&out, sym.sec & DAS_SYM_SEC_MASK);
            if (set_generation != 0U)
                (void)set_reloc_apply(st->c, set_generation, &out);
        }
#endif
        return out;
    }
    expr_error(st, "malformed expression");
    return out;
}

static struct expr_value parse_expr_unary(struct expr_state *st)
{
    struct expr_value v;
    int op;

    st->p = skipws(st->p);
    op = (unsigned char)*st->p;
    if (op == '+' || op == '-' || op == '~') {
        st->p++;
        v = parse_expr_unary(st);
        if (op == '-') {
            v.value = das_mask36(DAS_W(0) - v.value);
            v.rel = -v.rel;
        } else if (op == '~') {
            if (v.rel != 0) {
                if (!st->failed)
                    fprintf(stderr, DAS_DIAG("das: bad relocation\n",
                            "das: unsupported relocation expression %s\n"),
                            st->input);
                st->failed = 1;
            }
            v.value = das_mask36(~v.value);
            v.rel = 0;
        }
        return v;
    }
    return parse_expr_primary(st);
}

#ifdef DAS_NATIVE
#define EXPR_OP_OR     1
#define EXPR_OP_XOR    2
#define EXPR_OP_AND    3
#define EXPR_OP_SHL    4
#define EXPR_OP_SHR    5
#define EXPR_OP_ADD    6
#define EXPR_OP_SUB    7
#define EXPR_OP_MUL    8
#define EXPR_OP_DIV    9
#define EXPR_OP_REM   10

static int expr_binary_op(char *p, int *op, int *prec, int *width)
{
    if (*p == '|') { *op = EXPR_OP_OR;  *prec = 1; *width = 1; return 1; }
    if (*p == '^') { *op = EXPR_OP_XOR; *prec = 2; *width = 1; return 1; }
    if (*p == '&') { *op = EXPR_OP_AND; *prec = 3; *width = 1; return 1; }
    if (p[0] == '<' && p[1] == '<') {
        *op = EXPR_OP_SHL; *prec = 4; *width = 2; return 1;
    }
    if (p[0] == '>' && p[1] == '>') {
        *op = EXPR_OP_SHR; *prec = 4; *width = 2; return 1;
    }
    if (*p == '+') { *op = EXPR_OP_ADD; *prec = 5; *width = 1; return 1; }
    if (*p == '-') { *op = EXPR_OP_SUB; *prec = 5; *width = 1; return 1; }
    if (*p == '*') { *op = EXPR_OP_MUL; *prec = 6; *width = 1; return 1; }
    if (*p == '/') { *op = EXPR_OP_DIV; *prec = 6; *width = 1; return 1; }
    if (*p == '%') { *op = EXPR_OP_REM; *prec = 6; *width = 1; return 1; }
    return 0;
}

static struct expr_value parse_expr_binary(struct expr_state *st, int minprec)
{
    struct expr_value a;
    struct expr_value b;
    char *p;
    unsigned int count;
    int op;
    int prec;
    int width;

    a = parse_expr_unary(st);
    for (;;) {
        p = skipws(st->p);
        if (!expr_binary_op(p, &op, &prec, &width) || prec < minprec)
            return a;
        st->p = p + width;
        b = parse_expr_binary(st, prec + 1);
        if (op == EXPR_OP_ADD) {
            a.value = das_mask36(a.value + b.value);
            a.rel += b.rel;
        } else if (op == EXPR_OP_SUB) {
            a.value = das_mask36(a.value - b.value);
            a.rel -= b.rel;
        } else {
            if (expr_require_abs(st, a, b) != 0)
                return a;
            if ((op == EXPR_OP_DIV || op == EXPR_OP_REM) &&
                b.value == DAS_W(0)) {
                expr_error(st, "division by zero in expression");
                return a;
            }
            if (op == EXPR_OP_MUL)
                a.value = das_mask36(a.value * b.value);
            else if (op == EXPR_OP_DIV || op == EXPR_OP_REM)
                a.value = expr_signed_div(a.value, b.value,
                    op == EXPR_OP_REM);
            else if (op == EXPR_OP_SHL || op == EXPR_OP_SHR) {
                count = b.value >= DAS_W(36) ? 36U : (unsigned int)b.value;
                if (op == EXPR_OP_SHL)
                    a.value = count >= 36U ? DAS_W(0) :
                        das_mask36(a.value << count);
                else
                    a.value = expr_shift_right(a.value, count);
            } else if (op == EXPR_OP_AND)
                a.value &= b.value;
            else if (op == EXPR_OP_XOR)
                a.value ^= b.value;
            else
                a.value |= b.value;
            a.rel = 0;
        }
    }
}

static struct expr_value parse_expr_or(struct expr_state *st)
{
    return parse_expr_binary(st, 1);
}
#else
static struct expr_value parse_expr_mul(struct expr_state *st)
{
    struct expr_value a, b;
    int op;

    a = parse_expr_unary(st);
    for (;;) {
        st->p = skipws(st->p);
        op = (unsigned char)*st->p;
        if (op != '*' && op != '/' && op != '%')
            return a;
        st->p++;
        b = parse_expr_unary(st);
        if (expr_require_abs(st, a, b) != 0)
            return a;
        if ((op == '/' || op == '%') && b.value == DAS_W(0)) {
            expr_error(st, "division by zero in expression");
            return a;
        }
        if (op == '*')
            a.value = das_mask36(a.value * b.value);
        else
            a.value = expr_signed_div(a.value, b.value, op == '%');
        a.rel = 0;
    }
}

static struct expr_value parse_expr_add(struct expr_state *st)
{
    struct expr_value a, b;
    int op;

    a = parse_expr_mul(st);
    for (;;) {
        st->p = skipws(st->p);
        op = (unsigned char)*st->p;
        if (op != '+' && op != '-')
            return a;
        st->p++;
        b = parse_expr_mul(st);
        if (op == '+') {
#ifndef DAS_NATIVE
            if (a.rel == 0 && b.rel != 0) {
                a.reloc_kind = b.reloc_kind;
                a.target_sec = b.target_sec;
                a.symbol = b.symbol;
            } else if (a.rel != 0 && b.rel != 0) {
                a.reloc_kind = 0;
                a.target_sec = DAS_SEC_ABS;
                a.symbol = 0U;
            }
#endif
            a.value = das_mask36(a.value + b.value);
            a.rel += b.rel;
        } else {
#ifndef DAS_NATIVE
            if (a.rel == 0 || b.rel != 0) {
                if (a.rel == 0 && b.rel == 0) {
                    a.reloc_kind = 0;
                    a.target_sec = DAS_SEC_ABS;
                    a.symbol = 0U;
                } else if (b.rel != 0) {
                    a.reloc_kind = 0;
                    a.target_sec = DAS_SEC_ABS;
                    a.symbol = 0U;
                }
            }
#endif
            a.value = das_mask36(a.value - b.value);
            a.rel -= b.rel;
        }
    }
}

static struct expr_value parse_expr_shift(struct expr_state *st)
{
    struct expr_value a, b;
    unsigned int count;
    int left;

    a = parse_expr_add(st);
    for (;;) {
        st->p = skipws(st->p);
        if (st->p[0] == '<' && st->p[1] == '<')
            left = 1;
        else if (st->p[0] == '>' && st->p[1] == '>')
            left = 0;
        else
            return a;
        st->p += 2;
        b = parse_expr_add(st);
        if (expr_require_abs(st, a, b) != 0)
            return a;
        count = b.value >= DAS_W(36) ? 36U : (unsigned int)b.value;
        if (left)
            a.value = count >= 36U ? DAS_W(0) : das_mask36(a.value << count);
        else
            a.value = expr_shift_right(a.value, count);
        a.rel = 0;
    }
}

static struct expr_value parse_expr_and(struct expr_state *st)
{
    struct expr_value a, b;

    a = parse_expr_shift(st);
    for (;;) {
        st->p = skipws(st->p);
        if (*st->p != '&')
            return a;
        st->p++;
        b = parse_expr_shift(st);
        if (expr_require_abs(st, a, b) != 0)
            return a;
        a.value &= b.value;
    }
}

static struct expr_value parse_expr_xor(struct expr_state *st)
{
    struct expr_value a, b;

    a = parse_expr_and(st);
    for (;;) {
        st->p = skipws(st->p);
        if (*st->p != '^')
            return a;
        st->p++;
        b = parse_expr_and(st);
        if (expr_require_abs(st, a, b) != 0)
            return a;
        a.value ^= b.value;
    }
}

static struct expr_value parse_expr_or(struct expr_state *st)
{
    struct expr_value a, b;

    a = parse_expr_xor(st);
    for (;;) {
        st->p = skipws(st->p);
        if (*st->p != '|')
            return a;
        st->p++;
        b = parse_expr_xor(st);
        if (expr_require_abs(st, a, b) != 0)
            return a;
        a.value |= b.value;
    }
}

#endif

static int eval_expr_radix(struct asmctx *c, const char *in, unsigned int dot,
                           int default_base, das_word_t *val, int *reloc)
{
    char buf[DAS_MAX_LINE];
    struct expr_state st;
    struct expr_value out;

    strcopy(buf, in, sizeof(buf));
    strip_brackets(buf);
    st.c = c;
    st.input = in;
    st.p = skipws(buf);
    st.dot = dot;
    st.default_base = default_base;
    st.failed = 0;
    if (!*st.p) {
        *val = DAS_W(0);
        *reloc = DAS_RELOC_NONE;
        return 0;
    }
    out = parse_expr_or(&st);
    st.p = skipws(st.p);
    if (!st.failed && *st.p != 0)
        expr_error(&st, "malformed expression");
    if (!st.failed && out.rel != 0 && out.rel != 1) {
        if (!c->eval_silent)
            fprintf(stderr, DAS_DIAG("das: bad relocation\n",
                    "das: unsupported relocation expression %s\n"), in);
        st.failed = 1;
    }
    if (st.failed)
        return -1;
    *val = das_mask36(out.value);
    *reloc = out.rel == 1 ? DAS_RELOC_ADDR18 : DAS_RELOC_NONE;
#ifndef DAS_NATIVE
    if (c->object_mode && out.rel == 1) {
        c->eval_reloc_kind = out.reloc_kind;
        c->eval_target_sec = out.target_sec;
        c->eval_symbol = out.symbol;
        c->eval_addend = out.value & DAS_WORD_MASK;
    } else {
        c->eval_reloc_kind = 0;
        c->eval_target_sec = DAS_SEC_ABS;
        c->eval_symbol = 0U;
        c->eval_addend = DAS_W(0);
    }
#endif
    return 0;
}

static int eval_expr(struct asmctx *c, const char *in, unsigned int dot,
                     das_word_t *val, int *reloc)
{
    return eval_expr_radix(c, in, dot, 10, val, reloc);
}

static int eval_expr_octal(struct asmctx *c, const char *in, unsigned int dot,
                           das_word_t *val, int *reloc)
{
    return eval_expr_radix(c, in, dot, 8, val, reloc);
}

#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int split2(char *s, char **a, char **b)
{
    char *c;
    int paren;
    int bracket;
    int quote;

    paren = 0;
    bracket = 0;
    quote = 0;
    for (c = s; *c != 0; c++) {
        if (quote != 0) {
            if (*c == quote)
                quote = 0;
            continue;
        }
        if (*c == '\'' || *c == '"') {
            quote = (unsigned char)*c;
            continue;
        }
        if (*c == '[') {
            bracket++;
            continue;
        }
        if (*c == ']') {
            if (bracket > 0)
                bracket--;
            continue;
        }
        if (*c == '(') {
            paren++;
            continue;
        }
        if (*c == ')') {
            if (paren > 0)
                paren--;
            continue;
        }
        if (*c == ',' && paren == 0 && bracket == 0)
            break;
    }
    if (*c == 0)
        return 0;
    *c++ = 0;
    *a = skipws(s);
    *b = skipws(c);
    rtrim(*a);
    rtrim(*b);
    return 1;
}
#endif
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int parse_index_suffix(char *s, int *xr)
{
    char *lp, *rp, *p;
    unsigned int value;

    rtrim(s);
    rp = strrchr(s, ')');
    if (!rp || rp[1] != 0)
        return 0;
    lp = strrchr(s, '(');
    if (!lp || lp > rp)
        return 0;
    p = skipws(lp + 1);
    if (p == rp || *p < '0' || *p > '7')
        return 0;
    value = 0U;
    while (p < rp && *p >= '0' && *p <= '7') {
        value = (value << 3) | (unsigned int)(*p - '0');
        p++;
    }
    p = skipws(p);
    if (p != rp || value > 017U)
        return 0;
    *lp = 0;
    rtrim(s);
    *xr = (int)value;
    return 1;
}

#endif

static char *matching_rbracket(char *s)
{
    char *p;
    unsigned int depth;

    if (s == 0 || *s != '[')
        return 0;
    depth = 1U;
    for (p = s + 1; *p != 0; p++) {
        if (*p == '[')
            depth++;
        else if (*p == ']') {
            depth--;
            if (depth == 0U)
                return p;
        }
    }
    return 0;
}

#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int parse_ea(struct asmctx *c, char *s, unsigned int dot, unsigned int *y, int *ind, int *xr, int *reloc) { das_word_t v; *ind = 0; *xr = 0; *reloc = 0; s = skipws(s); if (!*s) { *y = 0; return 0; } while (*s == '@') { *ind = 1; s++; } if (*s == '[') { char *rb = matching_rbracket(s); unsigned int litoff; unsigned int len; if (!rb) return -1; len = (unsigned int)char_distance(s + 1, rb); if (len >= DAS_MAX_LINE) len = DAS_MAX_LINE - 1U; { char canon[DAS_MAX_LINE]; int clen; clen = literal_canonicalize(c, s + 1, len, canon, sizeof(canon)); if (clen >= 0) { if (!lit_find_text(c, canon, (unsigned int)clen, &litoff) && !lit_find_text(c, s + 1, len, &litoff)) return -1; } else if (!lit_find_text(c, s + 1, len, &litoff)) return -1; } *y = text_total(c) - c->lit_store.image_words + litoff; *reloc = DAS_RELOC_ADDR18;
#ifndef DAS_NATIVE
    if (c->object_mode) {
        c->eval_reloc_kind = DAS_OBJ_RELOC_LOCAL_RH18;
        c->eval_target_sec = DAS_SEC_TEXT;
        c->eval_symbol = 0U;
        c->eval_addend = (das_word_t)*y;
    }
#endif
    return 0; } if (pref_i(s, "POINT", 5) && isspace((unsigned char)s[5])) { char *c1, *c2; s = skipws(s + 5); c1 = strchr(s, ','); if (!c1) return -1; c2 = strchr(c1 + 1, ','); if (c2) *c2 = 0; return parse_ea(c, skipws(c1 + 1), dot, y, ind, xr, reloc); } (void)parse_index_suffix(s, xr); rtrim(s); if (!*s) { *y = 0; *reloc = 0; return 0; } if (eval_expr_octal(c, s, dot, &v, reloc) != 0) return -1; *y = DAS_MASK18(v); return 0; }
#endif

static char *byte_field_end(char *p)
{
    char *q;
    int prev;

    q = p;
    prev = 0;
    while (*q) {
        if (*q == ',')
            break;
        if (*q == '(')
            break;
        if (isspace((unsigned char)*q)) {
            char *n;

            n = skipws(q);
            if (*n == '+' || *n == '-' || prev == '+' || prev == '-') {
                q = n;
                continue;
            }
            break;
        }
        prev = (unsigned char)*q;
        q++;
    }
    return q;
}
static char *long_values(char *p)
{
    p = skipws(p);
    if (*p == '.')
        p++;
    if (pref_i(p, "LONG", 4))
        p = skipws(p + 4);
    return p;
}

static char *long_field_end(char *p)
{
    unsigned int paren;
    unsigned int bracket;

    paren = 0U;
    bracket = 0U;
    while (*p) {
        if (*p == '(')
            paren++;
        else if (*p == ')') {
            if (paren == 0U)
                return 0;
            paren--;
        } else if (*p == '[')
            bracket++;
        else if (*p == ']') {
            if (bracket == 0U)
                return 0;
            bracket--;
        } else if (*p == ',' && paren == 0U && bracket == 0U)
            return p;
        p++;
    }
    if (paren != 0U || bracket != 0U)
        return 0;
    return p;
}

static int long_word_count(char *arg)
{
    char *p;
    char *end;
    int words;

    p = long_values(arg);
    if (*p == 0)
        return -1;
    words = 0;
    for (;;) {
        end = long_field_end(p);
        if (end == 0)
            return -1;
        words++;
        if (*end == 0)
            return words;
        p = end + 1;
    }
}

static int eval_abs_u(struct asmctx *c, char *arg, unsigned int dot,
                      das_word_t limit, unsigned int *value);

static int byte_begin(struct asmctx *c, char *p, unsigned int dot,
                      char **next, int *size)
{
    char *end;
    char save;
    unsigned int value;

    p = skipws(p);
    if (*p == '.')
        p++;
    if (pref_i(p, "BYTE", 4))
        p = skipws(p + 4);
    end = p;
    while (*end != 0 && *end != ',' && !isspace((unsigned char)*end))
        end++;
    if (end == p)
        return -1;
    save = *end;
    *end = 0;
    if (eval_abs_u(c, p, dot, DAS_W(36), &value) != 0 || value == 0U) {
        *end = save;
        return -1;
    }
    *end = save;
    *size = (int)value;
    p = skipws(end);
    if (*p == ',')
        p++;
    *next = p;
    return 0;
}

static int byte_size_prefix(struct asmctx *c, char **next, unsigned int dot,
                            int *size)
{
    char *p;
    char *end;
    char save;
    unsigned int value;

    p = skipws(*next);
    if (*p != '(') {
        *next = p;
        return 0;
    }
    p++;
    end = strchr(p, ')');
    if (end == 0)
        return -1;
    save = *end;
    *end = 0;
    if (eval_abs_u(c, p, dot, DAS_W(36), &value) != 0 || value == 0U) {
        *end = save;
        return -1;
    }
    *end = save;
    *size = (int)value;
    *next = skipws(end + 1);
    return 0;
}

static int byte_word_count(struct asmctx *c, char *arg, unsigned int dot) {
    char *p, *e;
    int size, used = 0, words = 0;
    if (byte_begin(c, arg, dot, &p, &size) != 0) return -1;
    while (*skipws(p)) {
        p = skipws(p);
        if (*p == ',') { p++; continue; }
        if (byte_size_prefix(c, &p, dot + (unsigned int)words, &size) != 0) return -1;
        e = byte_field_end(p);
        if (e == p) break;
        if (used + size > 36) { words++; used = 0; }
        used += size;
        if (used == 36) { words++; used = 0; }
        p = e;
    }
    if (used || words == 0) words++;
    return words;
}
static int delimited_text_len(char *p, int *len) {
    char *a, *b;
    p = skipws(p);
    if (!*p) return -1;
    a = p + 1;
    b = strrchr(a, *p);
    if (!b) return -1;
    *len = (int)char_distance(a, b);
    return 0;
}
static int ascii_word_count(char *p, int zterm) {
    char *q = skipws(p);
    int len;
    if (*q == '.') q++;
    if (pref_i(q, "ASCIZ", 5)) q = skipws(q + 5);
    else if (pref_i(q, "ASCII", 5)) q = skipws(q + 5);
    if (delimited_text_len(q, &len) != 0) return -1;
    if (zterm) len++;
    if (len <= 0) return 1;
    return (len + 4) / 5;
}
static int sixbit_word_count(char *p) {
    char *q = skipws(p);
    int len;
    if (*q == '.') q++;
    if (pref_i(q, "SIXBIT", 6)) q = skipws(q + 6);
    if (delimited_text_len(q, &len) != 0) return -1;
    if (len <= 0) return 1;
    return (len + 5) / 6;
}
static int eval_abs_u(struct asmctx *c, char *arg, unsigned int dot,
                      das_word_t limit, unsigned int *value)
{
    das_word_t v;
    int reloc;

    if (eval_expr(c, skipws(arg), dot, &v, &reloc) != 0 || reloc || v > limit)
        return -1;
    *value = (unsigned int)v;
    return 0;
}

static int align_word_padding(struct asmctx *c, char *arg, unsigned int dot,
                              unsigned int loc, unsigned int *padding)
{
    unsigned int power;
    unsigned int align_words;

    if (eval_abs_u(c, arg, dot, DAS_W(19), &power) != 0)
        return -1;
    if (power <= 2UL) {
        *padding = 0U;
        return 0;
    }
    align_words = 1U << ((unsigned int)power - 2U);
    *padding = (0U - loc) & (align_words - 1U);
    return 0;
}
static int org_word_target(struct asmctx *c, char *arg, unsigned int dot,
                           unsigned int loc, unsigned int *target)
{
    das_word_t value;
    int reloc;

    if (eval_expr(c, skipws(arg), dot, &value, &reloc) != 0)
        return -1;
    if (reloc || value > (das_word_t)DAS_HALF_MASK)
        return -1;
    *target = (unsigned int)value;
    if (*target < loc)
        return -1;
    return 0;
}

static int parsed_word_count(struct asmctx *c, struct das_parsed_line *line,
                             unsigned int dot)
{
    switch (line->token) {
    case DAS_TOK_TEXT:
    case DAS_TOK_DATA:
    case DAS_TOK_BSS:
    case DAS_TOK_PSECT:
    case DAS_TOK_NO_WORDS:
    case DAS_TOK_ENTRY:
    case DAS_TOK_GLOBAL:
    case DAS_TOK_EXTERN:
    case DAS_TOK_ERROR:
    case DAS_TOK_WARNING:
    case DAS_TOK_RADIX:
    case DAS_TOK_EQU:
    case DAS_TOK_SET:
    case DAS_TOK_ALIGN:
    case DAS_TOK_ORG:
        return 0;
    case DAS_TOK_BLOCK:
        {
            das_word_t value;
            int reloc;

            if (eval_expr_octal(c, line->rest, dot, &value, &reloc) != 0 ||
                reloc != 0 || value > DAS_HALF_MASK)
                return -1;
            return (int)value;
        }
    case DAS_TOK_SPACE:
        {
            unsigned int units;

            if (eval_abs_u(c, line->rest, dot,
                    (das_word_t)DAS_HALF_MASK * DAS_W(4), &units) != 0)
                return -1;
            return (int)((units + 3U) >> 2);
        }
    case DAS_TOK_COMM:
    case DAS_TOK_LCOMM:
        return 0;
    case DAS_TOK_BYTE:
        return byte_word_count(c, line->stmt, dot);
    case DAS_TOK_ASCII:
        return ascii_word_count(line->stmt, 0);
    case DAS_TOK_ASCIZ:
        return ascii_word_count(line->stmt, 1);
    case DAS_TOK_SIXBIT:
        return sixbit_word_count(line->stmt);
    case DAS_TOK_LONG:
        return long_word_count(line->stmt);
    case DAS_TOK_WORD:
    case DAS_TOK_EXP:
    case DAS_TOK_POINT:
    case DAS_TOK_GIW:
    case DAS_TOK_OWGBP:
    case DAS_TOK_OTHER:
        return 1;
    }
    return 1;
}
#if !defined(DAS_NATIVE_PHASE2_ONLY)
static void scan_literals(struct asmctx *c, const char *p)
{
    const char *q;

    q = p;
    while ((q = strchr(q, '[')) != 0) {
        char *r;

        r = matching_rbracket((char *)q);
        if (r == 0)
            return;
        add_lit_text(c, q + 1, char_distance(q + 1, r));
        /* Advance one character so nested literals are recorded too. */
        q++;
    }
}
#endif
static int psect_to_sec(char *q, int cursec) {
    q = skipws(q);
    if (*q == '"') q++;
    if (*q == '.') q++;
    if (pref_i(q,"TEXT",4) || pref_i(q,"CODE",4)) return DAS_SEC_TEXT;
    if (pref_i(q,"DATA",4) || pref_i(q,"RODATA",6) || pref_i(q,"CONST",5)) return DAS_SEC_DATA;
    if (pref_i(q,"BSS",3)) return DAS_SEC_BSS;
    return cursec;
}
static int parse_line_head(struct asmctx *c, char *line,
                           struct das_parsed_line *parsed)
{
    char *p;
    char *colon;
    char *q;
    size_t n;
    unsigned int i;

    parsed->label = 0;
    parsed->label_len = 0U;
    parsed->stmt = 0;
    parsed->rest = 0;
    parsed->key[0] = 0;
    parsed->token = DAS_TOK_OTHER;
    parsed->mnemonic = 0;
    parsed->operand_ac = 0U;
    parsed->operand_reg = 0U;
    parsed->operand_integer = 0;
    parsed->operand = 0;
    parsed->has_operand_ac = 0;
    parsed->operand_is_reg = 0;
    parsed->operand_is_integer = 0;
    parsed->operand_integer_negative = 0;
    parsed->was_pseudo = 0;
    p = strchr(line, ';');
    if (p != 0)
        *p = 0;
    rtrim(line);
    p = skipws(line);
    if (*p == 0)
        return 0;
    colon = strchr(p, ':');
    if (colon != 0) {
        n = char_distance(p, colon);
        while (n != 0U && isspace((unsigned char)p[n - 1U]))
            n--;
        parsed->label = p;
        parsed->label_len = n;
        p = skipws(colon + 1);
        if (*p == 0)
            return 1;
    }
    parsed->stmt = p;
    q = p;
    if (*q == '.') {
        parsed->was_pseudo = 1;
        q++;
    }
    i = 0U;
    while (q[i] != 0 && !isspace((unsigned char)q[i]) &&
           i < DAS_MAX_NAME) {
        parsed->key[i] = q[i];
        i++;
    }
    parsed->key[i] = 0;
    parsed->rest = skipws(q + i);
    parsed->token = classify_token(c, parsed->key);
    if (parsed->token == DAS_TOK_OTHER) {
        const char *op;

        parsed->mnemonic = sixbit_mn(parsed->key);
        op = parsed->rest;
        if (opt_octal_ac(&op, &parsed->operand_ac) && *op == ',') {
            const char *rhs;

            parsed->has_operand_ac = 1;
            parsed->operand = skipws((char *)op + 1);
            rhs = parsed->operand;
            if (opt_octal_ac(&rhs, &parsed->operand_reg) && *rhs == 0)
                parsed->operand_is_reg = 1;
            {
                char *ip;
                das_word_t iv;

                ip = parsed->operand;
                parsed->operand_integer_negative = *ip == '-';
                if (*ip == '-' || *ip == '+')
                    ip++;
                if (parse_expr_integer(&ip, &iv) == 0 && *skipws(ip) == 0) {
                    parsed->operand_is_integer = 1;
                    parsed->operand_integer = iv;
                }
            }
        }
    }
    c->parser_classifications++;
    return 1;
}
#if !defined(DAS_NATIVE_PHASE2_ONLY)
static int cond_active(const struct das_cond_state *cond)
{
    das_word_t bit;

    if (cond->depth == 0U)
        return 1;
    bit = DAS_W(1) << (cond->depth - 1U);
    return (cond->active_bits & bit) != 0;
}

static int conditional_prefix(const char *line)
{
    const char *p;

    p = line;
    while (*p != 0 && isspace((unsigned char)*p))
        p++;
    if (*p == '.')
        p++;
    if (pref_i(p, "IFDEF", 5) &&
        (p[5] == 0 || isspace((unsigned char)p[5])))
        return 1;
    if (pref_i(p, "IFNDEF", 6) &&
        (p[6] == 0 || isspace((unsigned char)p[6])))
        return 1;
    if (pref_i(p, "IF", 2) &&
        (p[2] == 0 || isspace((unsigned char)p[2])))
        return 1;
    if (pref_i(p, "ELSE", 4) &&
        (p[4] == 0 || isspace((unsigned char)p[4])))
        return 1;
    if (pref_i(p, "ENDIF", 5) &&
        (p[5] == 0 || isspace((unsigned char)p[5])))
        return 1;
    return 0;
}

static int conditional_symbol_arg(char *rest, char *name, size_t namesz)
{
    char *p;
    size_t n;

    p = skipws(rest);
    if (!isname0((unsigned char)*p))
        return -1;
    n = 0U;
    while (isname((unsigned char)*p)) {
        if (n + 1U >= namesz)
            return -1;
        name[n++] = *p++;
    }
    name[n] = 0;
    return *skipws(p) == 0 ? 0 : -1;
}

static int conditional_line(struct asmctx *c, char *line,
                            struct das_cond_state *cond,
                            unsigned int dot, int *handled)
{
    struct das_parsed_line parsed;
    das_word_t bit;
    das_word_t value;
    char name[DAS_MAX_NAME + 1];
    int parent_active;
    int reloc;

    *handled = 0;
    if (!conditional_prefix(line))
        return 0;
    if (parse_line_head(c, line, &parsed) == 0 || parsed.stmt == 0)
        return 0;
    if (!streqi(parsed.key, "IF") && !streqi(parsed.key, "IFDEF") &&
        !streqi(parsed.key, "IFNDEF") && !streqi(parsed.key, "ELSE") &&
        !streqi(parsed.key, "ENDIF"))
        return 0;
    *handled = 1;
    if (parsed.label != 0) {
        fprintf(stderr, DAS_DIAG("das: bad conditional\n",
            "das: conditional directive cannot define a label: %s\n"),
            parsed.stmt);
        return 1;
    }
    if (streqi(parsed.key, "IF") || streqi(parsed.key, "IFDEF") ||
        streqi(parsed.key, "IFNDEF")) {
        if (cond->depth >= DAS_MAX_COND_DEPTH || *skipws(parsed.rest) == 0) {
            fprintf(stderr, DAS_DIAG("das: bad if\n",
                "das: malformed or too-deep .if directive: %s\n"),
                parsed.stmt);
            return 1;
        }
        parent_active = cond_active(cond);
        bit = DAS_W(1) << cond->depth;
        cond->active_bits &= ~bit;
        cond->else_bits &= ~bit;
        if (streqi(parsed.key, "IF")) {
            if (parent_active) {
                if (eval_expr(c, parsed.rest, dot, &value, &reloc) != 0 || reloc) {
                    fprintf(stderr, DAS_DIAG("das: bad if expr\n",
                        "das: .if requires an absolute expression: %s\n"),
                        parsed.stmt);
                    return 1;
                }
                if (value != DAS_W(0))
                    cond->active_bits |= bit;
            }
        } else {
            if (conditional_symbol_arg(parsed.rest, name, sizeof(name)) != 0) {
                fprintf(stderr, DAS_DIAG("das: bad ifdef\n",
                    "das: malformed .%s directive: %s\n"),
                    streqi(parsed.key, "IFDEF") ? "ifdef" : "ifndef",
                    parsed.stmt);
                return 1;
            }
            if (parent_active) {
                int visible;

                visible = symbol_visible_here(c, name);
                if (streqi(parsed.key, "IFNDEF"))
                    visible = !visible;
                if (visible)
                    cond->active_bits |= bit;
            }
        }
        cond->depth++;
        return 0;
    }
    if (*skipws(parsed.rest) != 0 || cond->depth == 0U) {
        fprintf(stderr, DAS_DIAG("das: bad conditional\n",
            "das: unmatched or malformed .%s directive\n"), parsed.key);
        return 1;
    }
    bit = DAS_W(1) << (cond->depth - 1U);
    if (streqi(parsed.key, "ELSE")) {
        if ((cond->else_bits & bit) != 0) {
            fprintf(stderr, DAS_DIAG("das: duplicate else\n",
                "das: duplicate .else directive\n"));
            return 1;
        }
        cond->else_bits |= bit;
        if (cond->depth == 1U)
            parent_active = 1;
        else
            parent_active = (cond->active_bits &
                (DAS_W(1) << (cond->depth - 2U))) != 0;
        if (parent_active)
            cond->active_bits ^= bit;
        else
            cond->active_bits &= ~bit;
        return 0;
    }
    cond->depth--;
    cond->active_bits &= ~bit;
    cond->else_bits &= ~bit;
    return 0;
}
#endif

#if DAS_ENABLE_OPTIMIZER
static void opt_reset(struct asmctx *c)
{
    unsigned int i;

    c->opt_window_len = 0U;
    c->opt_prev_move = 0U;
    c->opt_prev_zero = 0U;
    c->opt_prev_immediate = 0U;
    c->opt_prev_movei_any = 0U;
    c->opt_prev_deadwrite = 0U;
    c->opt_prev_forward_move = 0U;
    c->opt_pending_push = 0U;
    c->opt_pending_push_kind = 0U;
    c->opt_prev_mem = 0U;
    c->opt_prev_store = 0U;
    for (i = 0U; i < 16U; i++)
        c->opt_value[i] = i;
}
#endif

static int opt_octal_ac(const char **pp, unsigned int *ac)
{
    const char *p;
    unsigned int v;
    int any;

    p = *pp;
    while (*p != 0 && isspace((unsigned char)*p))
        p++;
    v = 0U;
    any = 0;
    while (*p >= '0' && *p <= '7') {
        any = 1;
        v = (v << 3) + (unsigned int)(*p - '0');
        if (v > 017U)
            return 0;
        p++;
    }
    if (!any)
        return 0;
    while (*p != 0 && isspace((unsigned char)*p))
        p++;
    *pp = p;
    *ac = v;
    return 1;
}

#if DAS_ENABLE_OPTIMIZER
static int opt_reg_pair(struct das_parsed_line *parsed, das_word_t *mn,
                        unsigned int *dst, unsigned int *src)
{
    if (parsed->token != DAS_TOK_OTHER || !parsed->has_operand_ac ||
        !parsed->operand_is_reg)
        return 0;
    *dst = parsed->operand_ac;
    *src = parsed->operand_reg;
    *mn = parsed->mnemonic;
    return 1;
}

static int opt_ac_integer(struct das_parsed_line *parsed, das_word_t *mn,
                          unsigned int *ac, das_word_t *value)
{
    if (parsed->token != DAS_TOK_OTHER || !parsed->has_operand_ac ||
        !parsed->operand_is_integer)
        return 0;
    *ac = parsed->operand_ac;
    *value = parsed->operand_integer;
    *mn = parsed->mnemonic;
    return 1;
}

static int opt_ac_signed_integer(struct das_parsed_line *parsed,
                                 das_word_t *mn, unsigned int *ac,
                                 int *negative, das_word_t *value)
{
    if (parsed->token != DAS_TOK_OTHER || !parsed->has_operand_ac ||
        !parsed->operand_is_integer)
        return 0;
    *ac = parsed->operand_ac;
    *negative = parsed->operand_integer_negative;
    *value = parsed->operand_integer;
    *mn = parsed->mnemonic;
    return 1;
}

static int opt_direct_move(struct das_parsed_line *parsed,
                           unsigned int *dst, unsigned int *src)
{
    das_word_t mn;

    return opt_reg_pair(parsed, &mn, dst, src) &&
        mn == DAS_OP4('M','O','V','E');
}

static int opt_any_movei(struct das_parsed_line *parsed,
                         unsigned int *dst)
{

    if (parsed->token != DAS_TOK_OTHER || parsed->mnemonic != DAS_OP5('M','O','V','E','I'))
        return 0;
    if (!parsed->has_operand_ac)
        return 0;
    *dst = parsed->operand_ac;
    return *parsed->operand != 0;
}

static int opt_direct_movei(struct das_parsed_line *parsed,
                            unsigned int *dst, unsigned int *value)
{
    das_word_t mn;
    das_word_t v;

    if (!opt_ac_integer(parsed, &mn, dst, &v) ||
        mn != DAS_OP5('M','O','V','E','I') || v > DAS_HALF_MASK)
        return 0;
    *value = (unsigned int)v;
    return 1;
}

static int opt_direct_setz(struct das_parsed_line *parsed,
                           unsigned int *dst)
{
    if (parsed->token != DAS_TOK_OTHER ||
        parsed->mnemonic != DAS_OP4('S','E','T','Z') ||
        !parsed->has_operand_ac || parsed->operand == 0 ||
        *parsed->operand != 0)
        return 0;
    *dst = parsed->operand_ac;
    return 1;
}

#define DAS_OPT_FOLD_NONE 0
#define DAS_OPT_FOLD_HLRZ 1
#define DAS_OPT_FOLD_HRLZ 2
#define DAS_OPT_FOLD_HRRZ 3

static int opt_halfword_fold(struct asmctx *c,
                             struct das_parsed_line *parsed)
{
    das_word_t v;
    das_word_t m;
    unsigned int ac;
    int negative;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_move ||
        !opt_ac_signed_integer(parsed, &m, &ac, &negative, &v) ||
        ac != c->opt_prev_move_ac)
        return DAS_OPT_FOLD_NONE;
    if (m == DAS_OP4('A','N','D','I')) {
        if (negative || v != DAS_W(0777777))
            return DAS_OPT_FOLD_NONE;
        return DAS_OPT_FOLD_HRRZ;
    }
    if (m != DAS_OP3('L','S','H') || v != DAS_W(022))
        return DAS_OPT_FOLD_NONE;
    return negative ? DAS_OPT_FOLD_HLRZ : DAS_OPT_FOLD_HRLZ;
}

static int opt_operand_uses_dot(const char *s)
{
    const char *p;

    for (p = s; *p != 0; p++) {
        int prev_name;
        int next_name;

        if (*p != '.')
            continue;
        prev_name = p != s &&
            (isalnum((unsigned char)p[-1]) || p[-1] == '_' || p[-1] == '$' ||
             p[-1] == '.');
        next_name = isalnum((unsigned char)p[1]) || p[1] == '_' ||
            p[1] == '$' || p[1] == '.';
        if (!prev_name && !next_name)
            return 1;
    }
    return 0;
}

/*
 * Removing a repeated memory operation is safe only when reevaluating the
 * operand cannot change the effective address.  In particular, indirect
 * addressing may auto-index and indexed addressing may depend on an AC that
 * the first instruction changes.  Literal operands also have assembler-side
 * allocation semantics.  Keep this peephole deliberately to plain direct
 * addresses and expressions.
 */
static int opt_mem_ea_is_direct(const char *s)
{
    const char *p;

    if (opt_operand_uses_dot(s))
        return 0;
    for (p = s; *p != 0; p++) {
        if (*p == '@' || *p == '(' || *p == ')' ||
            *p == '[' || *p == ']')
            return 0;
    }
    return 1;
}

static int opt_copy_mem_ea(struct das_parsed_line *parsed,
                           unsigned int *kind, unsigned int *ac,
                           char *buf, size_t cap)
{
    const char *q;
    const char *end;
    size_t n;

    if (parsed->token != DAS_TOK_OTHER)
        return 0;
    {
        das_word_t m;

        m = parsed->mnemonic;
        if (m == DAS_OP4('M','O','V','E'))
            *kind = 1U;
        else if (m == DAS_OP5('M','O','V','E','M'))
            *kind = 2U;
        else
            return 0;
    }
    if (!parsed->has_operand_ac)
        return 0;
    *ac = parsed->operand_ac;
    q = parsed->operand;
    if (*q == 0 || !opt_mem_ea_is_direct(q))
        return 0;
    end = q + strlen(q);
    while (end != q && isspace((unsigned char)end[-1]))
        end--;
    n = (size_t)(end - q);
    if (n == 0U || n >= cap)
        return 0;
    memcpy(buf, q, n);
    buf[n] = 0;
    return 1;
}

static int opt_redundant_mem_pair(struct asmctx *c,
                                  struct das_parsed_line *parsed)
{
    const char *q;
    const char *end;

    if (!das_optimize || parsed->label != 0 ||
        (c->opt_prev_mem != 1U && c->opt_prev_mem != 2U) ||
        parsed->token != DAS_TOK_OTHER)
        return 0;
    /*
     * Identical accesses are redundant.  There is one deliberately
     * asymmetric cross-kind case: existing store forwarding turns
     *
     *     MOVEM A,EA
     *     MOVE  A,EA
     *
     * into MOVEM A,EA / MOVE A,A.  The second word is then a non-faulting
     * architectural no-op, so remove it in both passes.  Different-AC
     * store/reloads are not removable because they must still copy A.
     */
    if (c->opt_prev_mem == 1U) {
        if (parsed->mnemonic != DAS_OP4('M','O','V','E'))
            return 0;
    } else if (parsed->mnemonic != DAS_OP5('M','O','V','E','M') &&
               parsed->mnemonic != DAS_OP4('M','O','V','E')) {
        return 0;
    }
    if (!parsed->has_operand_ac || parsed->operand_ac != c->opt_prev_mem_ac)
        return 0;
    q = parsed->operand;
    if (*q == 0 || !opt_mem_ea_is_direct(q))
        return 0;
    end = q + strlen(q);
    while (end != q && isspace((unsigned char)end[-1]))
        end--;
    *(char *)end = 0;
    return strcmp(q, c->opt_prev_mem_ea) == 0;
}

#define DAS_OPT_MEM_JRST_TARGET 3U
#define DAS_OPT_MEM_JUMP_TARGET 4U
#define DAS_OPT_MEM_JUMP_JRST 5U
#define DAS_OPT_BRANCH_TARGET2 (DAS_MAX_NAME + 1U)

static int opt_direct_jump_symbol(struct das_parsed_line *parsed,
                                  char *buf, size_t cap,
                                  unsigned int *opcode, unsigned int *ac)
{
    const char *q;
    const char *p;
    size_t n;
    int op;

    if (parsed->label != 0 || parsed->token != DAS_TOK_OTHER ||
        !parsed->has_operand_ac || parsed->operand == 0)
        return 0;
    op = lookup_op_mn(parsed->mnemonic, 0);
    if (op < 0321 || op > 0327 || op == 0324)
        return 0;
    q = skipws(parsed->operand);
    if (!isname0((unsigned char)*q))
        return 0;
    p = q + 1;
    while (isname((unsigned char)*p))
        p++;
    if (*skipws((char *)p) != 0)
        return 0;
    n = (size_t)(p - q);
    if (n == 0U || n >= cap)
        return 0;
    memcpy(buf, q, n);
    buf[n] = 0;
    *opcode = (unsigned int)op;
    *ac = parsed->operand_ac;
    return 1;
}

static int opt_direct_jrst_symbol(struct das_parsed_line *parsed,
                                  char *buf, size_t cap)
{
    const char *q;
    const char *p;
    size_t n;

    if (parsed->label != 0 || parsed->token != DAS_TOK_OTHER ||
        parsed->mnemonic != DAS_OP4('J','R','S','T'))
        return 0;
    q = skipws(parsed->rest);
    if (!isname0((unsigned char)*q))
        return 0;
    p = q + 1;
    while (isname((unsigned char)*p))
        p++;
    if (*skipws((char *)p) != 0)
        return 0;
    n = (size_t)(p - q);
    if (n == 0U || n >= cap)
        return 0;
    memcpy(buf, q, n);
    buf[n] = 0;
    return 1;
}

static int opt_label_is(struct das_parsed_line *parsed, const char *target)
{
    char name[DAS_MAX_NAME + 1];
    size_t n;

    if (parsed->label == 0)
        return 0;
    n = parsed->label_len;
    if (n == 0U || n > DAS_MAX_NAME)
        return 0;
    memcpy(name, parsed->label, n);
    name[n] = 0;
    return streqi(name, target);
}

static int opt_jrst_next_label(struct asmctx *c,
                               struct das_parsed_line *parsed)
{
    return das_optimize && c->opt_prev_mem == DAS_OPT_MEM_JRST_TARGET &&
        opt_label_is(parsed, c->opt_prev_mem_ea);
}

static int opt_jump_jrst_next_label(struct asmctx *c,
                                    struct das_parsed_line *parsed)
{
    return das_optimize && c->opt_prev_mem == DAS_OPT_MEM_JUMP_JRST &&
        opt_label_is(parsed, c->opt_prev_mem_ea);
}

static int opt_jump_jrst_transition(struct asmctx *c,
                                    struct das_parsed_line *parsed)
{
    char *target2;
    size_t cap;

    if (!das_optimize || c->opt_prev_mem != DAS_OPT_MEM_JUMP_TARGET)
        return 0;
    target2 = c->opt_prev_mem_ea + DAS_OPT_BRANCH_TARGET2;
    cap = sizeof(c->opt_prev_mem_ea) - DAS_OPT_BRANCH_TARGET2;
    if (!opt_direct_jrst_symbol(parsed, target2, cap))
        return 0;
    opt_reset(c);
    c->opt_prev_mem = DAS_OPT_MEM_JUMP_JRST;
    return 1;
}

static int opt_instruction_overwrites_ac(struct das_parsed_line *parsed,
                                         unsigned int target)
{
    unsigned int dst;
    unsigned int src;
    unsigned int value;

    if (parsed->label != 0 || parsed->token != DAS_TOK_OTHER)
        return 0;
    if (opt_direct_movei(parsed, &dst, &value))
        return dst == target;
    if (opt_direct_move(parsed, &dst, &src))
        return dst == target && src != dst;
    return 0;
}

#if !defined(DAS_NATIVE_PHASE2_ONLY)
static int opt_indexed_xct_symbol(struct das_parsed_line *parsed,
                                  char *name, size_t namesz)
{
    const char *q;
    const char *p;
    const char *scan;
    size_t n;

    if (parsed->token != DAS_TOK_OTHER ||
        parsed->mnemonic != DAS_OP3('X','C','T'))
        return 0;
    q = skipws(parsed->rest);
    if (*q == '@')
        q = skipws((char *)q + 1);
    if (!isname0((unsigned char)*q))
        return 0;
    p = q + 1;
    while (isname((unsigned char)*p))
        p++;
    /* An index register makes individual words reachable.  Be conservative
     * about the expression between the leading symbol and the index. */
    scan = p;
    while (*scan != 0 && *scan != '(')
        scan++;
    if (*scan != '(')
        return 0;
    n = (size_t)(p - q);
    if (n == 0U || n >= namesz)
        return 0;
    memcpy(name, q, n);
    name[n] = 0;
    return 1;
}
#endif

static int opt_label_is_indexed_xct_target(struct asmctx *c,
                                           struct das_parsed_line *parsed)
{
    char name[DAS_MAX_NAME + 1];
    size_t n;

    if (parsed->label == 0)
        return 0;
    n = parsed->label_len;
    if (n > DAS_MAX_NAME)
        n = DAS_MAX_NAME;
    memcpy(name, parsed->label, n);
    name[n] = 0;
    return find_indexed_xct_marker(c, name);
}

static int opt_instruction_may_skip(struct das_parsed_line *parsed)
{
#if defined(DAS_NATIVE_PHASE1_ONLY)
    int index;
#else
    int op;
#endif

    if (!das_optimize || parsed->token != DAS_TOK_OTHER)
        return 0;
    if (parsed->mnemonic == DAS_OP3('X','C','T'))
        return 1;
#if defined(DAS_NATIVE_PHASE1_ONLY)
    index = lookup_op_index(parsed->mnemonic);
    return op_index_may_skip(index);
#else
    op = lookup_op_mn(parsed->mnemonic, 0);
    if (op < 0)
        return 0;
    if ((op >= 0301 && op <= 0307) ||
        (op >= 0311 && op <= 0317) ||
        (op >= 0331 && op <= 0337) ||
        (op >= 0351 && op <= 0357) ||
        (op >= 0371 && op <= 0377))
        return 1;
    if (op >= 0600 && op <= 0677 && (op & 07) != 0)
        return 1;
    return 0;
#endif
}

static void opt_begin_line(struct asmctx *c,
                           struct das_parsed_line *parsed)
{
    unsigned int guarded;

    guarded = c->opt_skip_next;
    if (parsed->label != 0) {
        /* A new label terminates the preceding indexed-XCT table.  A label
         * recorded as an indexed target starts a new table region. */
        guarded &= ~DAS_OPT_GUARD_XCT_TABLE;
        if (opt_label_is_indexed_xct_target(c, parsed))
            guarded |= DAS_OPT_GUARD_XCT_TABLE;
    }

    /*
     * PDP-10 skip instructions skip the next emitted instruction word, not
     * the next source line.  Labels and assembler directives must therefore
     * not consume a pending skip barrier.  An indexed-XCT table is also an
     * address-stable region: every instruction word through the next label
     * can be entered directly and may not participate in cross-word folds.
     */
    if (parsed->stmt == 0 || parsed->token != DAS_TOK_OTHER) {
        c->opt_current_may_be_skipped = 0U;
        c->opt_skip_next = guarded;
        if (parsed->stmt == 0 && parsed->label != 0)
            c->opt_skip_next |= DAS_OPT_GUARD_NEXT;
        return;
    }
    if (guarded)
        opt_reset(c);
    c->opt_current_may_be_skipped = guarded;
    c->opt_skip_next = guarded & DAS_OPT_GUARD_XCT_TABLE;
    if (opt_instruction_may_skip(parsed))
        c->opt_skip_next |= DAS_OPT_GUARD_NEXT;
}

static void opt_record_prev(struct asmctx *c,
                            struct das_parsed_line *parsed)
{
    unsigned int ac;
    unsigned int value;
    unsigned int make_pending;
    unsigned int pending_temp;
    unsigned int pending_kind;
    das_word_t reg_mn;
    unsigned int reg_dst;
    unsigned int reg_src;

    if (c->opt_current_may_be_skipped)
        return;
    /*
     * A label is an execution-entry barrier, including for XCT.  A later
     * peephole must not rewrite the instruction at that label by absorbing
     * following instructions, because XCT executes only the labeled word.
     * Do not seed cross-instruction optimizer state from labeled words.
     */
    if (parsed->label != 0) {
        opt_reset(c);
        return;
    }

    make_pending = 0U;
    pending_temp = 0U;
    pending_kind = 0U;
    if (das_optimize && c->opt_prev_forward_move &&
        opt_direct_move(parsed, &reg_dst, &reg_src) &&
        reg_src == c->opt_prev_forward_move_ac && reg_dst != reg_src) {
        make_pending = 1U;
        pending_temp = reg_src;
        c->opt_pending_push_ac = reg_dst;
        pending_kind = c->opt_prev_forward_move == 2U ? 4U : 2U;
    } else if (das_optimize && c->opt_prev_movei_any &&
        opt_direct_move(parsed, &reg_dst, &reg_src) &&
        reg_src == c->opt_prev_movei_any_ac && reg_dst != reg_src) {
        make_pending = 1U;
        pending_temp = reg_src;
        c->opt_pending_push_ac = reg_dst;
        pending_kind = 3U;
    }
    c->opt_prev_move = 0U;
    c->opt_prev_zero = 0U;
    c->opt_prev_immediate = 0U;
    c->opt_prev_movei_any = 0U;
    c->opt_prev_deadwrite = 0U;
    c->opt_prev_forward_move = 0U;
    c->opt_pending_push = make_pending;
    if (make_pending) {
        c->opt_pending_push_temp = pending_temp;
        c->opt_pending_push_kind = pending_kind;
    }
    c->opt_prev_mem = 0U;
    c->opt_prev_lshr = 0U;
    if (!das_optimize || parsed->token != DAS_TOK_OTHER)
        return;
    if (parsed->label == 0) {
        unsigned int src;

        if (opt_direct_movei(parsed, &ac, &value)) {
            c->opt_prev_deadwrite = 1U;
            c->opt_prev_deadwrite_ac = ac;
        } else if (opt_direct_move(parsed, &ac, &src)) {
            c->opt_prev_deadwrite = 1U;
            c->opt_prev_deadwrite_ac = ac;
        }
    }
    {
        unsigned int kind;

        if (opt_copy_mem_ea(parsed, &kind, &ac, c->opt_prev_mem_ea,
                            sizeof(c->opt_prev_mem_ea))) {
            if (!(kind == 1U && opt_move_literal_immediate(parsed, &ac, &value))) {
                c->opt_prev_mem = kind;
                c->opt_prev_mem_ac = ac;
            }
        }
    }
    {
        unsigned int branch_op;
        unsigned int branch_ac;

        if (opt_direct_jump_symbol(parsed, c->opt_prev_mem_ea,
                DAS_OPT_BRANCH_TARGET2, &branch_op, &branch_ac)) {
            c->opt_prev_mem = DAS_OPT_MEM_JUMP_TARGET;
            c->opt_prev_mem_ac = (branch_op << 4) | (branch_ac & 017U);
        }
    }
    if (c->opt_prev_mem == 0U &&
        opt_direct_jrst_symbol(parsed, c->opt_prev_mem_ea,
            sizeof(c->opt_prev_mem_ea)))
        c->opt_prev_mem = DAS_OPT_MEM_JRST_TARGET;
    if (parsed->label == 0 && parsed->mnemonic == DAS_OP4('M','O','V','E') &&
        parsed->has_operand_ac && parsed->operand != 0 &&
        *parsed->operand != 0 && !parsed->operand_is_reg) {
        c->opt_prev_forward_move = 1U;
        c->opt_prev_forward_move_ac = parsed->operand_ac;
    } else if (parsed->label == 0 &&
        opt_reg_pair(parsed, &reg_mn, &reg_dst, &reg_src) &&
        reg_mn == DAS_OP4('S','E','T','M') && reg_dst != reg_src) {
        /*
         * SETM AC,SRC is a register copy when SRC is a direct accumulator.
         * Mark it separately so MOVE DST,AC can retarget this instruction if
         * AC is immediately proven dead.  Reusing the existing forwarding
         * state costs no additional native optimizer words.
         */
        c->opt_prev_forward_move = 2U;
        c->opt_prev_forward_move_ac = reg_dst;
    }
    if (parsed->mnemonic == DAS_OP4('M','O','V','E') &&
        !opt_move_literal_immediate(parsed, &ac, &value)) {
        if (!parsed->has_operand_ac)
            return;
        ac = parsed->operand_ac;
        c->opt_prev_move = 1U;
        c->opt_prev_move_ac = ac;
        return;
    }
    if (parsed->mnemonic == DAS_OP5('M','O','V','E','M'))
        return;
    if (opt_direct_setz(parsed, &ac)) {
        c->opt_prev_zero = 1U;
        c->opt_prev_zero_ac = ac;
        return;
    }
    if (opt_any_movei(parsed, &ac)) {
        c->opt_prev_movei_any = 1U;
        c->opt_prev_movei_any_ac = ac;
    }
    if (opt_direct_movei(parsed, &ac, &value)) {
        c->opt_prev_immediate = 1U;
        c->opt_prev_immediate_ac = ac;
        c->opt_prev_immediate_value = value;
        if (value == 0U) {
            c->opt_prev_zero = 1U;
            c->opt_prev_zero_ac = ac;
        }
    }
    {
        das_word_t mn;
        das_word_t shift;
        int negative;

        if (parsed->label == 0 &&
            opt_ac_signed_integer(parsed, &mn, &ac, &negative, &shift) &&
            mn == DAS_OP3('L','S','H') && negative && shift <= DAS_W(077)) {
            c->opt_prev_lshr = 1U;
            c->opt_prev_lshr_ac = ac;
            c->opt_prev_lshr_count = (unsigned int)shift;
        }
    }
}

static int opt_lshr_andi_redundant(struct asmctx *c,
                                    struct das_parsed_line *parsed)
{
    das_word_t mn;
    das_word_t mask;
    das_word_t needed;
    unsigned int ac;
    unsigned int bits;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_lshr ||
        !opt_ac_integer(parsed, &mn, &ac, &mask) ||
        mn != DAS_OP4('A','N','D','I') || ac != c->opt_prev_lshr_ac ||
        mask > DAS_HALF_MASK || c->opt_prev_lshr_count < 18U)
        return 0;
    if (c->opt_prev_lshr_count >= 36U)
        needed = DAS_W(0);
    else {
        bits = 36U - c->opt_prev_lshr_count;
        needed = (DAS_W(1) << bits) - DAS_W(1);
    }
    return (mask & needed) == needed;
}

static int opt_immediate_fold(struct asmctx *c,
                              struct das_parsed_line *parsed,
                              unsigned int *ac, unsigned int *value)
{
    das_word_t v;
    das_word_t m;
    unsigned int rhs;
    unsigned int lhs;

    if (!das_optimize || parsed->label != 0 ||
        !c->opt_prev_immediate || parsed->token != DAS_TOK_OTHER)
        return 0;
    if (!opt_ac_integer(parsed, &m, ac, &v) ||
        *ac != c->opt_prev_immediate_ac || v > DAS_HALF_MASK)
        return 0;
    /* SUBI sets carry flags even when the positive result is known. */
    if (m != DAS_OP4('A','D','D','I') && m != DAS_OP4('A','N','D','I') &&
        m != DAS_OP4('I','O','R','I') && m != DAS_OP5('I','M','U','L','I'))
        return 0;
    lhs = c->opt_prev_immediate_value;
    rhs = (unsigned int)v;
    if (m == DAS_OP4('A','D','D','I')) {
        if (lhs > DAS_HALF_MASK - rhs)
            return 0;
        *value = lhs + rhs;
    } else if (m == DAS_OP4('A','N','D','I')) {
        *value = lhs & rhs;
    } else if (m == DAS_OP4('I','O','R','I')) {
        *value = lhs | rhs;
    } else {
        if (rhs != 0U && lhs > DAS_HALF_MASK / rhs)
            return 0;
        *value = lhs * rhs;
    }
    return 1;
}

static int opt_movei_right_shift_fold(struct asmctx *c,
                                      struct das_parsed_line *parsed,
                                      unsigned int *ac,
                                      unsigned int *value)
{
    das_word_t shift;
    das_word_t m;
    int negative;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_immediate ||
        !opt_ac_signed_integer(parsed, &m, ac, &negative, &shift) ||
        *ac != c->opt_prev_immediate_ac || !negative ||
        (m != DAS_OP3('A','S','H') && m != DAS_OP3('L','S','H')) ||
        shift > DAS_W(077))
        return 0;
    if (shift >= DAS_W(18))
        *value = 0U;
    else
        *value = c->opt_prev_immediate_value >> (unsigned int)shift;
    return 1;
}


static int opt_movei_test_nonskip(struct asmctx *c,
                                  struct das_parsed_line *parsed)
{
    das_word_t mask;
    das_word_t m;
    unsigned int ac;
    unsigned int test;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_immediate ||
        parsed->token != DAS_TOK_OTHER)
        return 0;
    if (!opt_ac_integer(parsed, &m, &ac, &mask) ||
        ac != c->opt_prev_immediate_ac || mask > DAS_HALF_MASK)
        return 0;
    if (m != DAS_OP4('T','R','N','E') && m != DAS_OP4('T','R','N','N') &&
        m != DAS_OP4('T','L','N','E') && m != DAS_OP4('T','L','N','N'))
        return 0;
    if (m == DAS_OP4('T','R','N','E') || m == DAS_OP4('T','R','N','N'))
        test = c->opt_prev_immediate_value & (unsigned int)mask;
    else
        test = 0U;
    if (m == DAS_OP4('T','R','N','E') || m == DAS_OP4('T','L','N','E'))
        return test != 0U;
    return test == 0U;
}

static int opt_movei_movn_fold(struct asmctx *c,
                                struct das_parsed_line *parsed,
                                unsigned int *ac)
{
    das_word_t mn;
    unsigned int src;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_immediate ||
        !opt_reg_pair(parsed, &mn, ac, &src) || mn != DAS_OP4('M','O','V','N'))
        return 0;
    return *ac == c->opt_prev_immediate_ac && src == *ac;
}


struct opt_mn_code {
    das_word_t name;
    unsigned int code;
};

static int opt_lookup_code(const char *key, const struct opt_mn_code *table,
                           unsigned int count, unsigned int *code)
{
    das_word_t name;
    unsigned int i;

    name = sixbit_mn(key);
    for (i = 0U; i < count; i++) {
        if (table[i].name != name)
            continue;
        *code = table[i].code;
        return 1;
    }
    return 0;
}

static int opt_movei_unary_immediate_fold(struct asmctx *c,
                                           struct das_parsed_line *parsed,
                                           unsigned int *ac,
                                           unsigned int *opcode)
{
    static const struct opt_mn_code table[] = {
        {DAS_OP4('M','O','V','S'),  0205U},
        {DAS_OP5('S','E','T','C','M'), 0461U},
        {DAS_OP4('H','R','L','Z'),  0515U},
        {DAS_OP4('H','R','R','E'),  0571U}
    };
    das_word_t mn;
    unsigned int src;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_immediate ||
        !opt_reg_pair(parsed, &mn, ac, &src) ||
        !opt_lookup_code(parsed->key, table,
            (unsigned int)(sizeof(table) / sizeof(table[0])), opcode))
        return 0;
    return *ac == c->opt_prev_immediate_ac && src == *ac;
}

static void opt_set_prev_immediate(struct asmctx *c, unsigned int ac,
                                   unsigned int value)
{
    opt_reset(c);
    c->opt_window_len = 1U;
    c->opt_value[ac] = (unsigned int)DAS_HALF_MASK + 1U + value;
    c->opt_prev_immediate = 1U;
    c->opt_prev_immediate_ac = ac;
    c->opt_prev_immediate_value = value;
    c->opt_prev_movei_any = 1U;
    c->opt_prev_movei_any_ac = ac;
    if (value == 0U) {
        c->opt_prev_zero = 1U;
        c->opt_prev_zero_ac = ac;
    }
}

static int opt_zero_move_pair(struct asmctx *c,
                              struct das_parsed_line *parsed,
                              unsigned int *dst_ac)
{
    unsigned int src_ac;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_zero ||
        !opt_direct_move(parsed, dst_ac, &src_ac))
        return 0;
    return src_ac == c->opt_prev_zero_ac && *dst_ac != src_ac;
}

static int opt_zero_pair(struct asmctx *c,
                         struct das_parsed_line *parsed,
                         unsigned int *second_ac)
{
    unsigned int value;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_zero)
        return 0;
    if (!opt_direct_setz(parsed, second_ac)) {
        if (!opt_direct_movei(parsed, second_ac, &value) || value != 0U)
            return 0;
    }
    return *second_ac != c->opt_prev_zero_ac;
}

static int opt_move_unary_fold(struct asmctx *c,
                               struct das_parsed_line *parsed,
                               unsigned int *opcode)
{
    static const struct opt_mn_code table[] = {
        {DAS_OP4('M','O','V','S'),  0204U},
        {DAS_OP5('S','E','T','C','M'), 0460U},
        {DAS_OP4('H','L','L','Z'),  0510U},
        {DAS_OP4('H','R','R','Z'),  0550U},
        {DAS_OP4('H','L','R','Z'),  0554U},
        {DAS_OP4('H','R','R','E'),  0570U}
    };
    das_word_t mn;
    unsigned int ac;
    unsigned int src;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_move ||
        !opt_reg_pair(parsed, &mn, &ac, &src) ||
        !opt_lookup_code(parsed->key, table,
            (unsigned int)(sizeof(table) / sizeof(table[0])), opcode))
        return 0;
    return ac == c->opt_prev_move_ac && src == ac;
}

static int opt_move_skip_fold(struct asmctx *c,
                              struct das_parsed_line *parsed,
                              unsigned int *opcode)
{
    static const struct opt_mn_code table[] = {
        {DAS_OP4('S','K','I','P'),  0330U},
        {DAS_OP5('S','K','I','P','L'), 0331U},
        {DAS_OP5('S','K','I','P','E'), 0332U},
        {DAS_OP6('S','K','I','P','L','E'), 0333U},
        {DAS_OP5('S','K','I','P','A'), 0334U},
        {DAS_OP6('S','K','I','P','G','E'), 0335U},
        {DAS_OP5('S','K','I','P','N'), 0336U},
        {DAS_OP5('S','K','I','P','G'), 0337U}
    };
    das_word_t mn;
    unsigned int ac;
    unsigned int src;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_move ||
        !opt_reg_pair(parsed, &mn, &ac, &src) ||
        !opt_lookup_code(parsed->key, table,
            (unsigned int)(sizeof(table) / sizeof(table[0])), opcode))
        return 0;
    /* SKIP with AC 0 suppresses the accumulator write; MOVE 0,EA does not. */
    return ac != 0U && ac == c->opt_prev_move_ac && src == ac;
}

static int opt_zero_store(struct asmctx *c,
                          struct das_parsed_line *parsed)
{
    const char *q;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_zero ||
        parsed->token != DAS_TOK_OTHER || parsed->mnemonic != DAS_OP5('M','O','V','E','M'))
        return 0;
    if (!parsed->has_operand_ac || parsed->operand_ac != c->opt_prev_zero_ac)
        return 0;
    q = parsed->operand;
    /*
     * SETZB performs its store before updating AC.  MOVEI/MOVEM updates AC
     * before the store, so a faulting memory destination observes different
     * register state.  Restrict the fold to accumulator destinations, whose
     * register-file write cannot fault.
     */
    return *q != 0 && parsed->operand_is_reg;
}

static int opt_movei_hrrz_redundant(struct asmctx *c,
                                    struct das_parsed_line *parsed)
{
    das_word_t mn;
    unsigned int ac;
    unsigned int src;

    if (!das_optimize || parsed->label != 0 || !c->opt_prev_movei_any ||
        !opt_reg_pair(parsed, &mn, &ac, &src) || mn != DAS_OP4('H','R','R','Z'))
        return 0;
    return ac == c->opt_prev_movei_any_ac && src == ac;
}

/*
 * A side-effect-free register initialization may be discarded when the next
 * unlabeled instruction completely overwrites the same accumulator without
 * reading its incoming value and without a possible synchronous fault.  A
 * faulting overwrite must retain the earlier assignment because trap-visible
 * accumulator state is architectural state.
 */
static int opt_overwrite_prev(struct asmctx *c,
                              struct das_parsed_line *parsed,
                              unsigned int *dst)
{
    if (!das_optimize || !c->opt_prev_deadwrite ||
        !opt_instruction_overwrites_ac(parsed, c->opt_prev_deadwrite_ac))
        return 0;
    *dst = c->opt_prev_deadwrite_ac;
    return 1;
}

static int opt_finish_pending_push(struct asmctx *c,
                                   struct das_parsed_line *parsed)
{
    return das_optimize && c->opt_pending_push &&
        opt_instruction_overwrites_ac(parsed, c->opt_pending_push_temp);
}

/*
 * Track symbolic register-value identities across at most six adjacent direct
 * accumulator copies.  If both registers already carry the same incoming
 * value, another MOVE cannot change machine state and may be dropped.
 */
static int opt_drop_line(struct asmctx *c, struct das_parsed_line *parsed)
{
    unsigned int dst;
    unsigned int src;
    unsigned int value;

    if (!das_optimize)
        return 0;
    if (parsed->label != 0) {
        opt_reset(c);
        return 0;
    }
    if (parsed->stmt == 0)
        return 0;
    /*
     * opt_begin_line() resets incoming optimizer state when this instruction
     * may be skipped, but the instruction itself must not seed the bounded
     * value-identity window: on the path where the preceding skip fires, its
     * assignment never happens.  Keep opt_skip_next intact so a guarded skip
     * instruction still protects its own successor.
     */
    if (c->opt_current_may_be_skipped)
        return 0;
    if (c->opt_window_len >= 6U)
        opt_reset(c);
    if (opt_direct_move(parsed, &dst, &src)) {
        value = c->opt_value[src];
    } else if (opt_direct_movei(parsed, &dst, &src)) {
        value = (unsigned int)DAS_HALF_MASK + 1U + src;
    } else {
        unsigned int keep_store;
        unsigned int keep_store_ac;
        das_word_t keep_store_ea;
        int keep_store_reloc;

        keep_store = c->opt_prev_store && parsed->token == DAS_TOK_OTHER &&
            parsed->mnemonic == DAS_OP4('M','O','V','E');
        keep_store_ac = c->opt_prev_store_ac;
        keep_store_ea = c->opt_prev_store_ea;
        keep_store_reloc = c->opt_prev_store_reloc;
        opt_reset(c);
        if (keep_store) {
            c->opt_prev_store = 1U;
            c->opt_prev_store_ac = keep_store_ac;
            c->opt_prev_store_ea = keep_store_ea;
            c->opt_prev_store_reloc = keep_store_reloc;
        }
        return 0;
    }
    if (c->opt_value[dst] == value)
        return 1;
    c->opt_value[dst] = value;
    c->opt_window_len++;
    return 0;
}
#else
#define opt_reset(c) ((void)(c))
#endif

static int assignment_args(char *rest, char *name, size_t namesz,
                           char **expr)
{
    char *comma;
    char *p;
    size_t n;

    comma = strchr(rest, ',');
    if (comma == 0)
        return -1;
    n = char_distance(rest, comma);
    while (n != 0U && isspace((unsigned char)rest[n - 1U]))
        n--;
    while (n != 0U && isspace((unsigned char)*rest)) {
        rest++;
        n--;
    }
    if (n == 0U || n >= namesz || !isname0((unsigned char)rest[0]))
        return -1;
    memcpy(name, rest, n);
    name[n] = 0;
    for (p = name + 1; *p != 0; p++) {
        if (!isname((unsigned char)*p))
            return -1;
    }
    *expr = skipws(comma + 1);
    if (**expr == 0)
        return -1;
    return 0;
}

#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int define_assignment(struct asmctx *c,
                             struct das_parsed_line *parsed,
                             unsigned int dot)
{
    char name[DAS_MAX_NAME + 1];
    char *expr;
    struct sym oldsym;
    das_word_t value;
    int reloc;
    int kind;
    int sec;
    unsigned int generation;

    if (assignment_args(parsed->rest, name, sizeof(name), &expr) != 0) {
        fprintf(stderr, DAS_DIAG("das: bad assignment\n",
            "das: malformed .%s directive: %s\n"),
            parsed->token == DAS_TOK_EQU ? "equ" : "set", parsed->stmt);
        return 1;
    }
    kind = parsed->token == DAS_TOK_EQU ? DAS_SYM_KIND_EQU :
        DAS_SYM_KIND_SET;
    generation = 0U;
    if (kind == DAS_SYM_KIND_SET)
        generation = ++c->set_serial;
    if (eval_expr(c, expr, dot, &value, &reloc) != 0)
        return 1;
    sec = reloc ? DAS_SEC_REL : DAS_SEC_ABS;
    if (find_sym(c, name, &oldsym)) {
        int oldkind;

        oldkind = oldsym.sec & DAS_SYM_KIND_MASK;
        if (kind == DAS_SYM_KIND_EQU) {
            if (oldkind == DAS_SYM_KIND_EQU && oldsym.sec == (sec | kind) &&
                oldsym.off == value)
                return 0;
            fprintf(stderr, DAS_DIAG("das: dup assignment\n",
                "das: symbol cannot be redefined by .equ: %s\n"), name);
            return 1;
        }
        if (oldkind != DAS_SYM_KIND_SET) {
            fprintf(stderr, DAS_DIAG("das: dup assignment\n",
                "das: symbol cannot be redefined by .set: %s\n"), name);
            return 1;
        }
    }
    if (kind == DAS_SYM_KIND_SET) {
        set_snapshot_define(c, generation, sec, value);
#ifndef DAS_NATIVE
        if (set_reloc_store(c, generation) != 0)
            die("cannot retain .set relocation metadata");
#endif
        add_sym(c, name, DAS_SEC_ABS | DAS_SYM_KIND_SET,
            (das_word_t)generation);
    } else {
        add_sym(c, name, sec | kind, value);
    }
    return 0;
}
#endif

static int common_args(char *rest, char *name, size_t namesz,
                       unsigned int *words)
{
    char *comma;
    char *size;
    char *end;
    unsigned long units;
    size_t n;

    comma = strchr(rest, ',');
    if (comma == 0)
        return -1;
    n = char_distance(rest, comma);
    while (n != 0U && isspace((unsigned char)rest[n - 1U]))
        n--;
    while (n != 0U && isspace((unsigned char)*rest)) {
        rest++;
        n--;
    }
    if (n == 0U || n >= namesz)
        return -1;
    memcpy(name, rest, n);
    name[n] = 0;
    size = skipws(comma + 1);
    if (*size == 0 || *size == '-')
        return -1;
    units = strtoul(size, &end, 10);
    if (end == size)
        return -1;
    end = skipws(end);
    if (*end != 0 && *end != ',')
        return -1;
    if (units > ((unsigned long)DAS_HALF_MASK * 4UL))
        return -1;
    *words = (unsigned int)((units + 3UL) / 4UL);
    return 0;
}

#if !defined(DAS_NATIVE_PHASE2_ONLY)
static int pass1_assignment(struct asmctx *c,
                            struct das_parsed_line *parsed,
                            unsigned int dot)
{
    char name[DAS_MAX_NAME + 1];
    char *expr;
    struct sym oldsym;
    das_word_t value;
    int reloc;
    int kind;
    int sec;
    unsigned int generation;

    if (assignment_args(parsed->rest, name, sizeof(name), &expr) != 0) {
#if defined(DAS_NATIVE_PHASE1_ONLY)
        fprintf(stderr, DAS_DIAG("das: bad assignment\n",
            "das: malformed assignment directive\n"));
        return 1;
#else
        return define_assignment(c, parsed, dot);
#endif
    }
    kind = parsed->token == DAS_TOK_EQU ? DAS_SYM_KIND_EQU : DAS_SYM_KIND_SET;
    generation = 0U;
    if (kind == DAS_SYM_KIND_SET)
        generation = ++c->set_serial;
    if (find_sym(c, name, &oldsym)) {
        int oldkind;
        oldkind = oldsym.sec & DAS_SYM_KIND_MASK;
        if (kind == DAS_SYM_KIND_EQU || oldkind != DAS_SYM_KIND_SET) {
            fprintf(stderr, DAS_DIAG("das: dup assignment\n",
                "das: symbol cannot be redefined by .%s: %s\n"),
                kind == DAS_SYM_KIND_EQU ? "equ" : "set", name);
            return 1;
        }
    }
    mark_symbol_visible(c, name);
    c->eval_silent = 1;
    if (eval_expr(c, expr, dot, &value, &reloc) != 0) {
        c->eval_silent = 0;
        if (kind == DAS_SYM_KIND_SET)
            add_sym(c, name, DAS_SEC_ABS | DAS_SYM_KIND_SET,
                (das_word_t)generation);
        return 0;
    }
    c->eval_silent = 0;
    sec = reloc ? DAS_SEC_REL : DAS_SEC_ABS;
    if (kind == DAS_SYM_KIND_SET) {
        set_snapshot_define(c, generation, sec, value);
#ifndef DAS_NATIVE
        if (set_reloc_store(c, generation) != 0)
            die("cannot retain .set relocation metadata");
#endif
        add_sym(c, name, DAS_SEC_ABS | DAS_SYM_KIND_SET,
            (das_word_t)generation);
    } else {
        add_sym(c, name, sec | kind, value);
    }
    return 0;
}

static int pass1_line(struct asmctx *c, char *line, int *sec)
{
    struct das_parsed_line parsed;
    char name[DAS_MAX_NAME + 1];
    size_t n;
    int nwords;

    if (parse_line_head(c, line, &parsed) == 0)
        return 0;
#if DAS_ENABLE_OPTIMIZER
    if (opt_indexed_xct_symbol(&parsed, name, sizeof(name)))
        mark_indexed_xct_target(c, "");
    if (opt_jump_jrst_next_label(c, &parsed)) {
        if (c->loc[*sec] == 0U)
            return 1;
        c->loc[*sec]--;
        opt_reset(c);
    } else if (das_optimize &&
               c->opt_prev_mem == DAS_OPT_MEM_JUMP_JRST) {
        opt_reset(c);
    }
    if (opt_jrst_next_label(c, &parsed)) {
        if (c->loc[*sec] == 0U)
            return 1;
        c->loc[*sec]--;
        opt_reset(c);
    } else if (das_optimize &&
               c->opt_prev_mem == DAS_OPT_MEM_JRST_TARGET) {
        /* Keep JRST-to-next-label folding strictly adjacent to a parsed line.
         * Pass 2 can then defer the JRST for one line without a source queue. */
        opt_reset(c);
    }
    opt_begin_line(c, &parsed);
    if (!c->opt_current_may_be_skipped &&
        opt_jump_jrst_transition(c, &parsed)) {
        c->loc[*sec]++;
        return 0;
    }
#endif
    if (parsed.label != 0) {
        n = parsed.label_len;
        if (n > DAS_MAX_NAME)
            n = DAS_MAX_NAME;
        memcpy(name, parsed.label, n);
        name[n] = 0;
        {
            struct sym oldsym;

            if (find_sym(c, name, &oldsym)) {
                fprintf(stderr, DAS_DIAG("das: dup symbol\n", "das: duplicate symbol definition: %s\n"), name);
                return 1;
            }
        }
        mark_symbol_visible(c, name);
        add_sym(c, name, *sec, c->loc[*sec]);
    }
#if DAS_ENABLE_OPTIMIZER
    if (opt_finish_pending_push(c, &parsed)) {
        opt_reset(c);
        opt_record_prev(c, &parsed);
        return 0;
    }
    {
        unsigned int overwrite_ac;

        if (opt_overwrite_prev(c, &parsed, &overwrite_ac)) {
            c->opt_prev_store = 0U;
            opt_record_prev(c, &parsed);
            return 0;
        }
    }
    if (opt_redundant_mem_pair(c, &parsed))
        return 0;
    {
        unsigned int opcode;

        if (opt_move_unary_fold(c, &parsed, &opcode)) {
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int opcode;

        if (opt_move_skip_fold(c, &parsed, &opcode)) {
            opt_reset(c);
            return 0;
        }
    }
    if (opt_lshr_andi_redundant(c, &parsed)) {
        opt_reset(c);
        return 0;
    }
    if (opt_movei_hrrz_redundant(c, &parsed)) {
        opt_reset(c);
        return 0;
    }
    if (opt_zero_store(c, &parsed)) {
        opt_reset(c);
        return 0;
    }
    {
        unsigned int zero_ac;

        if (opt_zero_move_pair(c, &parsed, &zero_ac)) {
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int zero_ac;

        if (opt_zero_pair(c, &parsed, &zero_ac)) {
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int opt_ac;
        unsigned int opt_value;

        if (opt_immediate_fold(c, &parsed, &opt_ac, &opt_value)) {
            opt_set_prev_immediate(c, opt_ac, opt_value);
            return 0;
        }
    }
    {
        unsigned int opt_ac;
        unsigned int opt_value;

        if (opt_movei_right_shift_fold(c, &parsed, &opt_ac, &opt_value)) {
            opt_set_prev_immediate(c, opt_ac, opt_value);
            return 0;
        }
    }
    if (opt_movei_test_nonskip(c, &parsed)) {
        c->opt_skip_next &= ~DAS_OPT_GUARD_NEXT;
        return 0;
    }
    {
        unsigned int opt_ac;

        if (opt_movei_movn_fold(c, &parsed, &opt_ac)) {
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int opt_ac;
        unsigned int opcode;

        if (opt_movei_unary_immediate_fold(c, &parsed, &opt_ac, &opcode)) {
            opt_reset(c);
            return 0;
        }
    }
    {
        int fold;

        fold = opt_halfword_fold(c, &parsed);
        if (fold != DAS_OPT_FOLD_NONE) {
            opt_reset(c);
            return 0;
        }
    }
    if (opt_drop_line(c, &parsed))
        return 0;
#endif
    if (parsed.stmt == 0)
        return 0;
    switch (parsed.token) {
    case DAS_TOK_TEXT:
        *sec = DAS_SEC_TEXT;
        return 0;
    case DAS_TOK_DATA:
        *sec = DAS_SEC_DATA;
        return 0;
    case DAS_TOK_BSS:
        *sec = DAS_SEC_BSS;
        return 0;
    case DAS_TOK_PSECT:
        *sec = psect_to_sec(parsed.rest, *sec);
        return 0;
    case DAS_TOK_ENTRY:
        strcopy(c->entry_name, parsed.rest, sizeof(c->entry_name));
#ifndef DAS_NATIVE
        if (c->object_mode && c->entry_name[0] != 0)
            (void)obj_global_add(c, c->entry_name);
#endif
        return 0;
    case DAS_TOK_GLOBAL:
    case DAS_TOK_EXTERN:
#ifndef DAS_NATIVE
        if (c->object_mode && obj_parse_global_list(c, parsed.rest) != 0) {
            fprintf(stderr, "das: malformed global symbol list: %s\n",
                    parsed.rest);
            return 1;
        }
#endif
        return 0;
    case DAS_TOK_WARNING:
        fprintf(stderr, DAS_DIAG("das: warning\n",
            "das: warning: %s\n"), parsed.rest);
        return 0;
    case DAS_TOK_ERROR:
        fprintf(stderr, DAS_DIAG("das: error\n",
            "das: error: %s\n"), parsed.rest);
        return 1;
    case DAS_TOK_ALIGN: {
        unsigned int padding;

        if (align_word_padding(c, parsed.rest,
                sec_base(c, *sec) + c->loc[*sec], c->loc[*sec], &padding) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad align\n", "das: malformed .align directive: %s\n"), parsed.stmt);
            return 1;
        }
        c->loc[*sec] += padding;
        return 0;
    }
    case DAS_TOK_ORG: {
        unsigned int target;
        unsigned int dot;

        dot = sec_base(c, *sec) + c->loc[*sec];
        if (org_word_target(c, parsed.rest, dot, c->loc[*sec], &target) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad org\n", "das: malformed or backward .org directive: %s\n"), parsed.stmt);
            return 1;
        }
        c->loc[*sec] = target;
        return 0;
    }
    case DAS_TOK_EQU:
    case DAS_TOK_SET:
        return pass1_assignment(c, &parsed,
            sec_base(c, *sec) + c->loc[*sec]);
    case DAS_TOK_NO_WORDS:
    case DAS_TOK_RADIX:
        return 0;
    case DAS_TOK_COMM:
    case DAS_TOK_LCOMM: {
        unsigned int words;
        struct sym oldsym;

        if (common_args(parsed.rest, name, sizeof(name), &words) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad common\n", "das: malformed common directive: %s\n"), parsed.stmt);
            return 1;
        }
        if (find_sym(c, name, &oldsym)) {
            fprintf(stderr, DAS_DIAG("das: dup common\n", "das: duplicate common symbol: %s\n"), name);
            return 1;
        }
        mark_symbol_visible(c, name);
        add_sym(c, name, DAS_SEC_BSS, c->loc[DAS_SEC_BSS]);
#ifndef DAS_NATIVE
        if (c->object_mode && parsed.token == DAS_TOK_COMM)
            (void)obj_global_add(c, name);
#endif
        c->loc[DAS_SEC_BSS] += words;
        return 0;
    }
    default:
        break;
    }
    {
#if DAS_ENABLE_OPTIMIZER
        unsigned int opt_ac;
        unsigned int opt_value;

        if (!opt_move_literal_immediate(&parsed, &opt_ac, &opt_value))
            scan_literals(c, parsed.stmt);
#else
        scan_literals(c, parsed.stmt);
#endif
    }
    nwords = parsed_word_count(c, &parsed,
        sec_base(c, *sec) + c->loc[*sec]);
    if (nwords < 0) {
        fprintf(stderr, DAS_DIAG("das: bad directive\n", "das: malformed directive: %s\n"), parsed.stmt);
        return 1;
    }
    c->loc[*sec] += (unsigned int)nwords;
#if DAS_ENABLE_OPTIMIZER
    opt_record_prev(c, &parsed);
#endif
    return 0;
}
#endif
#if !defined(DAS_NATIVE_PHASE1_ONLY)
static int parse_point_position(struct asmctx *c, char *expr,
                                unsigned int dot, int *pos)
{
    das_word_t value;
    int reloc;

    if (eval_expr(c, expr, dot, &value, &reloc) != 0 || reloc != 0)
        return -1;
    if (value == DAS_WORD_MASK) {
        *pos = -1;
        return 0;
    }
    if (value > DAS_W(35))
        return -1;
    *pos = (int)value;
    return 0;
}

static int parse_point_word(struct asmctx *c, char *q, unsigned int dot,
                            das_word_t *w, int *reloc)
{
    char *a, *b, *d, *c1, *c2;
    unsigned int size;
    int pos;
    unsigned int yy;
    int r, ind, xr;

    c1 = strchr(q, ',');
    if (!c1) return -1;
    *c1++ = 0;
    a = skipws(q);
    b = skipws(c1);
    rtrim(a);
    c2 = strchr(b, ',');
    if (c2) {
        *c2++ = 0;
        d = skipws(c2);
        rtrim(b);
        rtrim(d);
        if (!*d || parse_point_position(c, d, dot, &pos) != 0)
            return -1;
    } else {
        rtrim(b);
        pos = -1;
    }
    if (!*a || !*b || eval_abs_u(c, a, dot, DAS_W(077), &size) != 0)
        return -1;
    if (parse_ea(c, b, dot, &yy, &ind, &xr, &r)) return -1;
    *w = das_mask36(((das_word_t)(35 - pos) << 30) |
        ((das_word_t)size << 24) | ((das_word_t)(ind & 1) << 22) |
        ((das_word_t)(xr & 017) << 18) | (das_word_t)(yy & DAS_HALF_MASK));
    *reloc = r;
    return 0;
}
static int parse_giw_word(struct asmctx *c, char *q, unsigned int dot, das_word_t *w, int *reloc) { if (eval_expr_octal(c, q, dot, w, reloc)) return -1; return 0; }
static int parse_exind_word(struct asmctx *c, char *q, unsigned int dot,
                            das_word_t *w, int *reloc)
{
    char *p;
    char *a;
    char *b;
    char *end;
    das_word_t ind;
    das_word_t xr;
    das_word_t y;
    int r1;
    int r2;
    int r3;

    q = skipws(q);
    if (*q != '(')
        return -1;
    q++;
    end = strrchr(q, ')');
    if (end == 0)
        return -1;
    *end++ = 0;
    if (*skipws(end) != 0)
        return -1;
    p = q;
    a = strchr(p, ',');
    if (a == 0)
        return -1;
    *a++ = 0;
    b = strchr(a, ',');
    if (b == 0)
        return -1;
    *b++ = 0;
    if (strchr(b, ',') != 0)
        return -1;
    rtrim(p);
    rtrim(a);
    rtrim(b);
    if (eval_expr(c, p, dot, &ind, &r1) != 0 ||
        eval_expr(c, a, dot, &xr, &r2) != 0 ||
        eval_expr(c, b, dot, &y, &r3) != 0)
        return -1;
    if (r1 || r2 || r3) {
        fprintf(stderr, DAS_DIAG("das: reloc EXIND\n",
            "das: relocation in %%EXIND is unsupported\n"));
        return -1;
    }
    if (ind > DAS_W(1) || xr > DAS_W(017) || y > DAS_W(07777777777)) {
        fprintf(stderr, DAS_DIAG("das: bad EXIND\n",
            "das: %%EXIND field out of range\n"));
        return -1;
    }
    *w = ((ind & DAS_W(1)) << 34) |
         ((xr & DAS_W(017)) << 30) |
         (y & DAS_W(07777777777));
    *reloc = 0;
    return 0;
}
static int owgbp_lookup(int sel, int *size, int *low) {
    static const int tbl[][3] = {
        {046,6,0},{047,6,6},{050,6,12},{051,6,18},{052,6,24},{053,6,30},
        {062,7,0},{063,7,7},{064,7,14},{065,7,21},{066,7,28},
        {055,8,0},{056,8,8},{057,8,16},{060,8,24},
        {070,9,0},{071,9,9},{072,9,18},{073,9,27},
        {075,18,0},{076,18,18},{0,0,0}
    };
    int i;
    for (i = 0; tbl[i][0]; i++) {
        if (tbl[i][0] == sel) { *size = tbl[i][1]; *low = tbl[i][2]; return 1; }
    }
    return 0;
}
static int parse_owgbp_word(struct asmctx *c, char *q, unsigned int dot, das_word_t *w, int *reloc) {
    char *a, *b;
    int sel, size, low, high;
    das_word_t y;
    q = skipws(q);
    if (!split2(q, &a, &b)) return -1;
    sel = (int)parse_octal_u(a);
    if (!owgbp_lookup(sel, &size, &low)) { fprintf(stderr, DAS_DIAG("das: bad owgbp\n", "das: unknown OWGBP selector %o\n"), sel); return -1; }
    b = skipws(b);
    if (pref_i(b, "GIW", 3)) b = skipws(b + 3);
    if (eval_expr_octal(c, b, dot, &y, reloc)) return -1;
    high = low + size - 1;
    *w = das_mask36(((das_word_t)(35 - high) << 30) | ((das_word_t)size << 24) | (y & DAS_HALF_MASK));
    return 0;
}
static int write_words_host(FILE *f, const das_word_t *words,
                            unsigned int count)
{
#ifdef DAS_NATIVE
    while (count != 0U) {
        int rc;

        rc = dsys_write_words(f->fd, (kword_t *)words, count);
        if (rc <= 0)
            return -1;
        words += (unsigned int)rc;
        count -= (unsigned int)rc;
    }
    return 0;
#else
    unsigned char raw[DAS_OUTPUT_BUFFER_WORDS * 8U];

    while (count != 0U) {
        unsigned int chunk;
        unsigned int n;
        unsigned int i;

        chunk = count > DAS_OUTPUT_BUFFER_WORDS ?
            DAS_OUTPUT_BUFFER_WORDS : count;
        for (n = 0U; n < chunk; n++) {
            das_word_t value;

            value = words[n] & DAS_WORD_MASK;
            for (i = 0U; i < 8U; i++) {
                raw[n * 8U + i] =
                    (unsigned char)(value & DAS_W(0377));
                value >>= 8U;
            }
        }
        if (fwrite(raw, 8U, chunk, f) != chunk)
            return -1;
        words += chunk;
        count -= chunk;
    }
    return 0;
#endif
}

static int output_seek_raw(struct das_output *out, unsigned int pos)
{
    long off;

    if (out->word_pos == pos)
        return 0;
#ifdef DAS_NATIVE
    off = (long)pos;
#else
    off = (long)pos * 8L;
#endif
    if (fseek(out->file, off, SEEK_SET) != 0)
        return -1;
    out->word_pos = pos;
    return 0;
}

#ifdef DAS_NATIVE
static int output_flush(struct das_output *out)
{
    if (out->buffer_count == 0U)
        return 0;
    if (output_seek_raw(out, out->buffer_first) != 0)
        return -1;
    if (write_words_host(out->file, out->buffer,
            out->buffer_count) != 0)
        return -1;
    out->word_pos = out->buffer_first + out->buffer_count;
    out->buffer_count = 0U;
    return 0;
}

static int output_queue(struct das_output *out, unsigned int pos,
                        das_word_t word)
{
    if (out->buffer_count != 0U &&
        (pos != out->buffer_first + out->buffer_count ||
         out->buffer_count >= DAS_OUTPUT_BUFFER_WORDS)) {
        if (output_flush(out) != 0)
            return -1;
    }
    if (out->buffer_count == 0U)
        out->buffer_first = pos;
    out->buffer[out->buffer_count++] = word & DAS_WORD_MASK;
    return 0;
}
#endif

#ifndef DAS_NATIVE
static void output_object_location(struct das_output *out, unsigned int off,
                                   int *loc_sec, unsigned int *loc_off)
{
    struct asmctx *c;

    c = out->ctx;
    if (off < text_total(c)) {
        *loc_sec = DAS_SEC_TEXT;
        *loc_off = off;
    } else {
        *loc_sec = DAS_SEC_DATA;
        *loc_off = off - text_total(c);
    }
}

static int obj_reloc_at_output(struct das_output *out,
                               const struct das_obj_reloc *r,
                               unsigned int off)
{
    int loc_sec;
    unsigned int loc_off;

    output_object_location(out, off, &loc_sec, &loc_off);
    return r->loc_sec == loc_sec && r->offset == loc_off;
}

static void obj_reloc_remove_output(struct das_output *out, unsigned int off)
{
    struct asmctx *c;
    unsigned int i;
    unsigned int dst;

    c = out->ctx;
    dst = 0U;
    for (i = 0U; i < c->obj_reloc_count; i++) {
        if (obj_reloc_at_output(out, &c->obj_relocs[i], off))
            continue;
        if (dst != i)
            c->obj_relocs[dst] = c->obj_relocs[i];
        dst++;
    }
    c->obj_reloc_count = dst;
}

static int obj_reloc_present_output(struct das_output *out, unsigned int off)
{
    struct asmctx *c;
    unsigned int i;

    c = out->ctx;
    for (i = 0U; i < c->obj_reloc_count; i++) {
        if (obj_reloc_at_output(out, &c->obj_relocs[i], off))
            return 1;
    }
    return 0;
}

static int obj_reloc_same_output(struct das_output *out,
                                 unsigned int aoff, unsigned int boff)
{
    struct asmctx *c;
    const struct das_obj_reloc *a[2];
    const struct das_obj_reloc *b[2];
    unsigned int na;
    unsigned int nb;
    unsigned int i;

    c = out->ctx;
    na = 0U;
    nb = 0U;
    for (i = 0U; i < c->obj_reloc_count; i++) {
        if (obj_reloc_at_output(out, &c->obj_relocs[i], aoff)) {
            if (na >= 2U)
                return 0;
            a[na++] = &c->obj_relocs[i];
        }
        if (obj_reloc_at_output(out, &c->obj_relocs[i], boff)) {
            if (nb >= 2U)
                return 0;
            b[nb++] = &c->obj_relocs[i];
        }
    }
    if (na != nb)
        return 0;
    for (i = 0U; i < na; i++) {
        if (a[i]->type != b[i]->type ||
            a[i]->target_sec != b[i]->target_sec ||
            a[i]->symbol != b[i]->symbol ||
            a[i]->addend != b[i]->addend)
            return 0;
    }
    return 1;
}

static int output_object_relocate_word(struct das_output *out,
                                       unsigned int off,
                                       das_word_t *word, int reloc)
{
    struct asmctx *c;
    int loc_sec;
    unsigned int loc_off;
    int target_sec;
    das_word_t addend;
    unsigned int addr;
    int had_lh_reloc;
    int had_rh_reloc;

    if (!reloc)
        return 0;
    c = out->ctx;
    output_object_location(out, off, &loc_sec, &loc_off);
    target_sec = c->eval_target_sec;
    addend = c->eval_addend;
    had_lh_reloc = c->eval_lh_reloc_kind != 0;
    had_rh_reloc = 0;
    if (had_lh_reloc) {
        int ltype;
        int ltarget;
        das_word_t laddend;
        unsigned int lsymbol;

        ltype = c->eval_lh_reloc_kind == DAS_OBJ_RELOC_LOCAL_RH18 ?
            DAS_OBJ_RELOC_LOCAL_LH18 : DAS_OBJ_RELOC_SYMBOL_LH18;
        ltarget = c->eval_lh_target_sec;
        laddend = c->eval_lh_addend;
        lsymbol = c->eval_lh_symbol;
        if (c->eval_lh_reloc_kind == DAS_OBJ_RELOC_LOCAL_RH18) {
            unsigned int laddr;

            laddr = DAS_MASK18(laddend);
            if (ltarget < DAS_SEC_TEXT || ltarget > DAS_SEC_BSS) {
                if (laddr < text_total(c))
                    ltarget = DAS_SEC_TEXT;
                else if (laddr < text_total(c) + c->loc[DAS_SEC_DATA])
                    ltarget = DAS_SEC_DATA;
                else
                    ltarget = DAS_SEC_BSS;
            }
            laddend = das_mask36(laddend -
                (das_word_t)sec_base(c, ltarget));
        }
        if (obj_reloc_add(c, loc_sec, loc_off, ltype, ltarget,
                lsymbol, laddend) != 0)
            return -1;
        *word &= (das_word_t)DAS_HALF_MASK;
        c->eval_lh_reloc_kind = 0;
    }
    if (c->eval_reloc_kind == DAS_OBJ_RELOC_LOCAL_RH18) {
        addr = DAS_MASK18(addend);
        if (target_sec < DAS_SEC_TEXT || target_sec > DAS_SEC_BSS) {
            if (addr < text_total(c))
                target_sec = DAS_SEC_TEXT;
            else if (addr < text_total(c) + c->loc[DAS_SEC_DATA])
                target_sec = DAS_SEC_DATA;
            else
                target_sec = DAS_SEC_BSS;
        }
        addend = das_mask36(addend - (das_word_t)sec_base(c, target_sec));
        if (obj_reloc_add(c, loc_sec, loc_off,
                DAS_OBJ_RELOC_LOCAL_RH18, target_sec, 0U, addend) != 0)
            return -1;
        had_rh_reloc = 1;
    } else if (c->eval_reloc_kind == DAS_OBJ_RELOC_SYMBOL_RH18) {
        if (obj_reloc_add(c, loc_sec, loc_off,
                DAS_OBJ_RELOC_SYMBOL_RH18, DAS_SEC_ABS,
                c->eval_symbol, addend) != 0)
            return -1;
        had_rh_reloc = 1;
    } else if (!had_lh_reloc) {
        fprintf(stderr, DAS_DIAG("das: obj reloc\n",
            "das: object relocation metadata lost\n"));
        return -1;
    }
    if (had_rh_reloc)
        *word &= ~((das_word_t)DAS_HALF_MASK);
    return 0;
}
#endif

#if DAS_ENABLE_OPTIMIZER
#ifdef DAS_NATIVE
/* Keep the native optimizer on the existing bitmap operations with no new
 * resident helper code or state.  DOBJ exists only in the host build. */
#define output_reloc_present(out, off) \
    das_bitmap_get((out)->relmap, (off))
#define output_reloc_same(out, aoff, boff) \
    (das_bitmap_get((out)->relmap, (aoff)) == \
     das_bitmap_get((out)->relmap, (boff)))
#else
static int output_reloc_present(struct das_output *out, unsigned int off)
{
    if (out->object_mode)
        return obj_reloc_present_output(out, off);
    return das_bitmap_get(out->relmap, off);
}

static int output_reloc_same(struct das_output *out,
                             unsigned int aoff, unsigned int boff)
{
    if (out->object_mode)
        return obj_reloc_same_output(out, aoff, boff);
    return das_bitmap_get(out->relmap, aoff) ==
        das_bitmap_get(out->relmap, boff);
}
#endif
#endif

static int output_emit(struct das_output *out, unsigned int off,
                       das_word_t word, int reloc)
{
    if (off >= out->image_words)
        return -1;
#ifdef DAS_NATIVE
    if (output_queue(out, off + 2U, word) != 0)
        return -1;
#else
    if (out->object_mode && reloc) {
        if (output_object_relocate_word(out, off, &word, reloc) != 0)
            return -1;
    }
    if (output_seek_raw(out, off + out->header_words) != 0)
        return -1;
    if (write_words_host(out->file, &word, 1U) != 0)
        return -1;
    out->word_pos++;
#endif
    if (reloc) {
#ifndef DAS_NATIVE
        if (!out->object_mode)
#endif
            das_bitmap_set(out->relmap, off);
    }
    return 0;
}

#if DAS_ENABLE_OPTIMIZER
static int output_read_word(struct das_output *out, unsigned int off,
                            das_word_t *word)
{
#ifdef DAS_NATIVE
    unsigned int pos;
    unsigned int index;

    pos = off + 2U;
    if (out->buffer_count == 0U || pos < out->buffer_first ||
        pos >= out->buffer_first + out->buffer_count)
        return -1;
    index = pos - out->buffer_first;
    *word = out->buffer[index] & DAS_WORD_MASK;
#else
    unsigned char raw[8];
    unsigned int i;

    if (output_seek_raw(out, off + out->header_words) != 0)
        return -1;
    /*
     * The host output is an update stream (w+b).  Optimizer peepholes read
     * previously emitted words and can then resume a sequential write at the
     * cached current offset.  ISO C requires a positioning operation when
     * changing direction on an update stream.  Do it around these uncommon
     * optimizer reads rather than forcing a seek for every emitted word.
     */
    if (fseek(out->file, 0L, SEEK_CUR) != 0)
        return -1;
    if (fread(raw, 8U, 1U, out->file) != 1U)
        return -1;
    out->word_pos = off + out->header_words + 1U;
    if (fseek(out->file, 0L, SEEK_CUR) != 0)
        return -1;
    *word = DAS_W(0);
    for (i = 0U; i < 8U; i++)
        *word |= ((das_word_t)raw[i]) << (i * 8U);
    *word &= DAS_WORD_MASK;
#endif
    return 0;
}

static int output_replace_word(struct das_output *out, unsigned int off,
                               das_word_t word)
{
#ifdef DAS_NATIVE
    unsigned int pos;
    unsigned int index;

    pos = off + 2U;
    if (out->buffer_count == 0U || pos < out->buffer_first ||
        pos >= out->buffer_first + out->buffer_count)
        return -1;
    index = pos - out->buffer_first;
    out->buffer[index] = word & DAS_WORD_MASK;
#else
    if (output_seek_raw(out, off + out->header_words) != 0)
        return -1;
    if (write_words_host(out->file, &word, 1U) != 0)
        return -1;
    out->word_pos = off + out->header_words + 1U;
#endif
    return 0;
}

static int output_replace_word_reloc(struct das_output *out, unsigned int off,
                                     das_word_t word, int reloc)
{
#ifndef DAS_NATIVE
    if (out->object_mode) {
        obj_reloc_remove_output(out, off);
        if (reloc && output_object_relocate_word(out, off, &word, reloc) != 0)
            return -1;
        return output_replace_word(out, off, word);
    }
#endif
    if (output_replace_word(out, off, word) != 0)
        return -1;
    if (reloc)
        das_bitmap_set(out->relmap, off);
    else
        das_bitmap_clear(out->relmap, off);
    return 0;
}

static int output_reopcode(struct das_output *out, unsigned int off,
                           unsigned int opcode)
{
    das_word_t word;
#ifdef DAS_NATIVE
    unsigned int pos;
    unsigned int index;

    pos = off + 2U;
    if (out->buffer_count == 0U || pos < out->buffer_first ||
        pos >= out->buffer_first + out->buffer_count)
        return -1;
    index = pos - out->buffer_first;
    word = out->buffer[index];
    out->buffer[index] = (word & DAS_W(0777777777)) |
        ((das_word_t)(opcode & 0777U) << 27);
#else
    unsigned char raw[8];
    unsigned int i;

    if (output_seek_raw(out, off + out->header_words) != 0)
        return -1;
    if (fread(raw, 8U, 1U, out->file) != 1U)
        return -1;
    out->word_pos = off + out->header_words + 1U;
    word = DAS_W(0);
    for (i = 0U; i < 8U; i++)
        word |= ((das_word_t)raw[i]) << (i * 8U);
    word = (word & DAS_W(0777777777)) |
        ((das_word_t)(opcode & 0777U) << 27);
    if (output_seek_raw(out, off + out->header_words) != 0)
        return -1;
    if (write_words_host(out->file, &word, 1U) != 0)
        return -1;
    out->word_pos = off + out->header_words + 1U;
#endif
    return 0;
}
#endif

static int output_emit_zeros(struct das_output *out, unsigned int off,
                             unsigned int count)
{
    while (count != 0U) {
        if (output_emit(out, off, DAS_W(0), 0) != 0)
            return -1;
        off++;
        count--;
    }
    return 0;
}


#if !defined(DAS_NATIVE) && !defined(DAS_PHASE2_PROGRAM)
static das_word_t dobj_magic_word(const char *text)
{
    das_word_t w;
    unsigned int i;
    unsigned int ch;

    w = DAS_W(0);
    for (i = 0U; i < 6U; i++) {
        ch = (unsigned int)(unsigned char)text[i];
        if (ch < 040U || ch > 0137U)
            ch = 040U;
        w = (w << 6U) | (das_word_t)((ch - 040U) & 077U);
    }
    return w & DAS_WORD_MASK;
}

static int dobj_write_name(FILE *f, const char *name)
{
    unsigned int len;
    unsigned int pos;

    len = (unsigned int)strlen(name);
    pos = 0U;
    while (pos < len) {
        das_word_t w;
        unsigned int slot;
        unsigned int ch;

        w = DAS_W(0);
        for (slot = 0U; slot < 4U && pos < len; slot++, pos++) {
            ch = (unsigned int)(unsigned char)name[pos] & 0177U;
            if (slot == 0U)
                w |= (das_word_t)ch << 27U;
            else if (slot == 1U)
                w |= (das_word_t)ch << 18U;
            else if (slot == 2U)
                w |= (das_word_t)ch << 9U;
            else
                w |= (das_word_t)ch;
        }
        if (write_words_host(f, &w, 1U) != 0)
            return -1;
    }
    return 0;
}

static int output_begin_object(struct das_output *out, FILE *file,
                               struct asmctx *c, unsigned int image_words)
{
    das_word_t zero[5];

    memset(out, 0, sizeof(*out));
    memset(zero, 0, sizeof(zero));
    out->file = file;
    out->ctx = c;
    out->object_mode = 1;
    out->header_words = 5U;
    out->image_words = image_words;
    if (write_words_host(file, zero, 5U) != 0)
        return -1;
    out->word_pos = 5U;
    return 0;
}

static int output_finish_object(struct das_output *out)
{
    struct asmctx *c;
    das_word_t h[5];
    unsigned int i;
    unsigned int entry_symbol;

    c = out->ctx;
    if (output_seek_raw(out, out->header_words + out->image_words) != 0)
        return -1;
    for (i = 0U; i < c->obj_global_count; i++) {
        struct sym sym;
        das_word_t s0;
        das_word_t value;
        int kind;
        int sec;
        unsigned int len;

        if (find_sym(c, c->obj_globals[i].name, &sym)) {
            kind = 1;
            sec = sym.sec & DAS_SYM_SEC_MASK;
            if (sec == DAS_SEC_REL)
                sec = DAS_SEC_ABS;
            if (sec == DAS_SEC_ABS)
                value = sym.off;
            else
                value = sym.off;
        } else {
            kind = 2;
            sec = DAS_SEC_ABS;
            value = DAS_W(0);
        }
        len = (unsigned int)strlen(c->obj_globals[i].name);
        s0 = DAS_WORD(((unsigned int)kind << 15U) |
                      ((unsigned int)sec << 12U) | (len & 077U), 0U);
        if (write_words_host(out->file, &s0, 1U) != 0 ||
            write_words_host(out->file, &value, 1U) != 0 ||
            dobj_write_name(out->file, c->obj_globals[i].name) != 0)
            return -1;
    }
    for (i = 0U; i < c->obj_reloc_count; i++) {
        struct das_obj_reloc *r;
        das_word_t r0;
        das_word_t r1;

        r = &c->obj_relocs[i];
        r0 = DAS_WORD(((unsigned int)r->loc_sec << 15U) |
                      ((unsigned int)r->type << 12U) |
                      ((unsigned int)r->target_sec << 9U), r->offset);
        r1 = DAS_WORD(0U, r->symbol);
        if (write_words_host(out->file, &r0, 1U) != 0 ||
            write_words_host(out->file, &r1, 1U) != 0 ||
            write_words_host(out->file, &r->addend, 1U) != 0)
            return -1;
    }
    entry_symbol = c->entry_name[0] != 0 ?
        obj_global_find(c, c->entry_name) : 0U;
    h[0] = dobj_magic_word("DOBJ1 ");
    h[1] = DAS_WORD(text_total(c), c->loc[DAS_SEC_DATA]);
    h[2] = DAS_WORD(c->loc[DAS_SEC_BSS], c->obj_global_count);
    h[3] = DAS_WORD(c->obj_reloc_count, 0U);
    h[4] = DAS_WORD(0U, entry_symbol);
    if (output_seek_raw(out, 0U) != 0)
        return -1;
    if (write_words_host(out->file, h, 5U) != 0)
        return -1;
    return fflush(out->file) == 0 ? 0 : -1;
}
#endif

static int output_begin(struct das_output *out, FILE *file,
                        unsigned int entry, unsigned int image_words,
                        unsigned int bss_words,
                        das_word_t *relmap,
                        unsigned int relmap_words)
{
    das_word_t header[2];

    memset(out, 0, sizeof(*out));
    out->file = file;
#ifndef DAS_NATIVE
    out->header_words = 2U;
#endif
    out->relmap = relmap;
    out->relmap_words = relmap_words;
    out->image_words = image_words;
#ifdef DAS_NATIVE
    out->buffer = das_native_output_buffer;
#endif
    header[0] = DAS_WORD(DAS_MAGIC_DXR, entry);
    header[1] = DAS_WORD(image_words, bss_words);
    if (write_words_host(file, header, 2U) != 0)
        return -1;
    out->word_pos = 2U;
    return 0;
}

static int output_finish(struct das_output *out)
{
#ifdef DAS_NATIVE
    if (output_flush(out) != 0)
        return -1;
#endif
    if (output_seek_raw(out, 2U + out->image_words) != 0)
        return -1;
    if (write_words_host(out->file, out->relmap,
            out->relmap_words) != 0)
        return -1;
    out->word_pos += out->relmap_words;
    return fflush(out->file) == 0 ? 0 : -1;
}
static int emit_byte_directive(struct asmctx *c, char *p, unsigned int dot,
                               struct das_output *out,
                               unsigned int maxwords)
{
    char *q, *e;
    int size, used;
    unsigned int wi;
    das_word_t word, v, mask;
    int r;

    used = 0;
    wi = 0U;
    word = DAS_W(0);
    if (byte_begin(c, p, dot, &q, &size) != 0) return -1;
    while (*skipws(q)) {
        q = skipws(q);
        if (*q == ',') { q++; continue; }
        if (byte_size_prefix(c, &q, dot + wi, &size) != 0) return -1;
        e = byte_field_end(q);
        if (e == q) break;
        if (*e) *e++ = 0;
        rtrim(q);
        if (eval_expr(c, q, dot + wi, &v, &r) != 0) return -1;
        if (r) {
            fprintf(stderr, DAS_DIAG("das: .byte relocation\n", "das: relocation inside .byte is unsupported in DXR V1\n"));
            return -1;
        }
        if (used + size > 36) {
            if (wi >= maxwords || output_emit(out, dot + wi, word, 0) != 0)
                return -1;
            wi++;
            word = DAS_W(0);
            used = 0;
        }
        mask = (size == 36) ? DAS_WORD_MASK : ((DAS_W(1) << size) - DAS_W(1));
        word |= (v & mask) << (36 - used - size);
        used += size;
        if (used == 36) {
            if (wi >= maxwords || output_emit(out, dot + wi, word, 0) != 0)
                return -1;
            wi++;
            word = DAS_W(0);
            used = 0;
        }
        q = e;
    }
    if (used || wi == 0U) {
        if (wi >= maxwords || output_emit(out, dot + wi, word, 0) != 0)
            return -1;
    }
    return 0;
}
static int emit_sixbit_directive(char *p, unsigned int dot,
                                 struct das_output *out,
                                 unsigned int maxwords)
{
    char *q, *a, *b;
    int len, ci;
    unsigned int wi;

    q = skipws(p);
    if (*q == '.') q++;
    if (pref_i(q, "SIXBIT", 6)) q = skipws(q + 6);
    if (delimited_text_len(q, &len) != 0) return -1;
    a = q + 1;
    b = strrchr(a, *q);
    (void)b;
    if (len <= 0) len = 1;
    for (wi = 0U; wi < maxwords; wi++) {
        das_word_t w;

        w = DAS_W(0);
        for (ci = 0; ci < 6; ci++) {
            int pos;
            unsigned int c;
            unsigned char ch;

            pos = (int)(wi * 6U) + ci;
            c = 0U;
            if (pos < len) {
                ch = (unsigned char)a[pos];
                if (ch >= 'a' && ch <= 'z') ch = (unsigned char)(ch - 'a' + 'A');
                if (ch >= ' ' && ch <= '_') c = (unsigned int)(ch - ' ');
            }
            w = (w << 6) | (das_word_t)(c & 077U);
        }
        if (output_emit(out, dot + wi, w, 0) != 0)
            return -1;
    }
    return 0;
}
static int emit_ascii_directive(char *p, unsigned int dot,
                                struct das_output *out,
                                unsigned int maxwords, int zterm)
{
    char *q, *a, *b;
    int len, i, outlen, used;
    unsigned int wi;
    das_word_t word;

    used = 0;
    wi = 0U;
    word = DAS_W(0);
    q = skipws(p);
    if (*q == '.') q++;
    if (pref_i(q, "ASCIZ", 5)) q = skipws(q + 5);
    else if (pref_i(q, "ASCII", 5)) q = skipws(q + 5);
    if (delimited_text_len(q, &len) != 0) return -1;
    a = q + 1;
    b = strrchr(a, *q);
    (void)b;
    outlen = len + (zterm ? 1 : 0);
    if (outlen <= 0) outlen = 1;
    for (i = 0; i < outlen; i++) {
        unsigned int ch;

        ch = 0U;
        if (i < len) ch = (unsigned char)a[i];
        if (used + 7 > 36) {
            if (wi >= maxwords || output_emit(out, dot + wi, word, 0) != 0)
                return -1;
            wi++;
            word = DAS_W(0);
            used = 0;
        }
        word |= ((das_word_t)(ch & 0177U)) << (36 - used - 7);
        used += 7;
    }
    if (wi >= maxwords || output_emit(out, dot + wi, word, 0) != 0)
        return -1;
    return 0;
}
static int parse_instruction_word(struct asmctx *c, char *p, unsigned int dot, das_word_t *w, int *reloc) {
    char mnem[32], *q, *rest, *a, *b;
    int i = 0, op, ind, xr, rel;
    unsigned int ac = 0, y;
    q = skipws(p);
    if (!isname0((unsigned char)*q)) return 0;
    while (*q && !isspace((unsigned char)*q)) { if (i < 31) mnem[i++] = *q; q++; }
    mnem[i] = 0;
    rest = skipws(q);
    if (!*rest) return 0;
    if (mnem[0] == '.') memmove(mnem, mnem + 1, strlen(mnem));
    op = lookup_op(mnem, 0);
    if (op < 0) {
        unsigned int alias_op;
        if (lookup_fixed_ac_alias(mnem, &alias_op, &ac)) {
            op = (int)alias_op;
            b = rest;
        } else {
            int iofn = lookup_io(mnem);
            if (iofn < 0) return 0;
            if (!split2(rest, &a, &b)) { a = (char *)"0"; b = rest; }
            if (parse_ea(c, b, dot, &y, &ind, &xr, &rel)) return -1;
            *w = das_enc_io(parse_octal_u(a), (unsigned int)iofn, ind, xr, y);
            *reloc = rel;
            return 1;
        }
    } else {
        if (sixbit_mn(mnem) == DAS_OP4('H','A','L','T')) {
            ac = 04U;
            b = rest;
        } else {
            if (!split2(rest, &a, &b)) { a = (char *)"0"; b = rest; }
            ac = parse_octal_u(a);
        }
    }
    if (parse_ea(c, b, dot, &y, &ind, &xr, &rel)) return -1;
    *w = das_enc_mem((unsigned int)op, ac, ind, xr, y);
    *reloc = rel;
    return 1;
}
static int parse_data_word_radix(struct asmctx *, char *, unsigned int,
                                 das_word_t *, int *, int);
static int
parse_data_word_radix(struct asmctx *c, char *p, unsigned int dot,
                      das_word_t *w, int *reloc, int default_base)
{
    char *q;
    int ir;

    q = skipws(p);
    if (*q == '.')
        q++;
    if (pref_i(q, "SIXBIT", 6)) {
        char *a;
        char *b;

        a = strchr(q, '/');
        if (!a)
            return -1;
        b = strrchr(a + 1, '/');
        if (b)
            *b = 0;
        *w = sixbit_ascii(a + 1);
        *reloc = 0;
        return 0;
    }
    if (pref_i(q, "WORD", 4))
        q = skipws(q + 4);
    else if (pref_i(q, "EXP", 3))
        q = skipws(q + 3);
    else if (pref_i(q, "LONG", 4))
        q = skipws(q + 4);
    if (pref_i(q, "POINT", 5))
        return parse_point_word(c, skipws(q + 5), dot, w, reloc);
    if (pref_i(q, "GIW", 3))
        return parse_giw_word(c, skipws(q + 3), dot, w, reloc);
    if (pref_i(q, "OWGBP", 5))
        return parse_owgbp_word(c, skipws(q + 5), dot, w, reloc);
    if (pref_i(q, "%EXIND", 6))
        return parse_exind_word(c, skipws(q + 6), dot, w, reloc);
    ir = parse_instruction_word(c, q, dot, w, reloc);
    if (ir)
        return ir < 0 ? -1 : 0;
    if (strstr(q, ",,")) {
        char *d;
        das_word_t lh;
        das_word_t rh;
        int r1;
        int r2;
#ifndef DAS_NATIVE
        int lk;
        int ls;
        unsigned int lsy;
        das_word_t la;
#endif

        d = strstr(q, ",,");
#ifndef DAS_NATIVE
        lk = 0;
        ls = DAS_SEC_ABS;
        lsy = 0U;
        la = 0;
#endif
        *d = 0;
        d += 2;
        if (eval_expr_radix(c, q, dot, default_base, &lh, &r1))
            return -1;
#ifndef DAS_NATIVE
        if (r1) {
            lk = c->eval_reloc_kind;
            ls = c->eval_target_sec;
            lsy = c->eval_symbol;
            la = c->eval_addend;
        }
#endif
        if (eval_expr_radix(c, d, dot, default_base, &rh, &r2))
            return -1;
#ifndef DAS_NATIVE
        if (r1 && !c->object_mode) {
            fprintf(stderr,
                    "das: left-half relocation is unsupported in DXR V1: %s\n",
                    q);
            return -1;
        }
#else
        if (r1) {
            fprintf(stderr, "das: left-half relocation is unsupported\n");
            return -1;
        }
#endif
#ifndef DAS_NATIVE
        c->eval_lh_reloc_kind = lk;
        c->eval_lh_target_sec = ls;
        c->eval_lh_symbol = lsy;
        c->eval_lh_addend = la;
#endif
        *w = DAS_WORD(lh, rh);
        *reloc = (r1 || r2) ? DAS_RELOC_ADDR18 : DAS_RELOC_NONE;
        return 0;
    }
    if (eval_expr_radix(c, q, dot, default_base, w, reloc))
        return -1;
    if (*reloc) {
        /* DOBJ1 full expressions are RH18 relocations.  Strip only a
         * sign-extension introduced by a negative RH18 addend.  A genuine
         * left-half constant (for example GCC byte-pointer metadata) belongs
         * to the containing word and must survive object assembly. */
#ifndef DAS_NATIVE
        if (c->object_mode &&
            (((*w >> 18) & DAS_HALF_MASK) == DAS_HALF_MASK) &&
            ((*w & DAS_W(0400000)) != 0))
            *w &= (das_word_t)DAS_HALF_MASK;
#endif
        if (q[0] == '.' && q[1] == 0) {
            fprintf(stderr, DAS_DIAG("das: full relocation: %s\n",
                    "das: full-word relocation is unsupported in DXR V1: %s\n"), q);
            return -1;
        }
        *reloc = DAS_RELOC_ADDR18;
    }
    return 0;
}

static int
parse_data_word(struct asmctx *c, char *p, unsigned int dot,
                das_word_t *w, int *reloc)
{
    return parse_data_word_radix(c, p, dot, w, reloc, 10);
}

static int emit_long_directive(struct asmctx *c, char *stmt,
                               unsigned int dot, struct das_output *out,
                               unsigned int nwords)
{
    char *start;
    char *end;
    unsigned int emitted;

    start = long_values(stmt);
    emitted = 0U;
    for (;;) {
        int at_end;
        das_word_t w;
        int r;

        end = long_field_end(start);
        if (end == 0)
            return -1;
        at_end = *end == 0;
        if (!at_end)
            *end = 0;
        rtrim(start);
        start = skipws(start);
        if (*start == 0 || emitted >= nwords)
            return -1;
        if (parse_data_word(c, start, dot + emitted, &w, &r) != 0 ||
            output_emit(out, dot + emitted, w, r) != 0)
            return -1;
        emitted++;
        if (at_end)
            break;
        start = end + 1;
    }
    return emitted == nwords ? 0 : -1;
}

static int pass2_stmt(struct asmctx *c, int sec, unsigned int off,
                      struct das_parsed_line *parsed,
                      unsigned int nwords, struct das_output *out)
{
    char *a;
    char *b;
    int op;
    unsigned int dot;

    dot = sec_base(c, sec) + off;
    if (sec == DAS_SEC_BSS)
        return 0;
#if DAS_ENABLE_OPTIMIZER
    {
        unsigned int opt_ac;
        unsigned int opt_value;

        if (opt_move_literal_immediate(parsed, &opt_ac, &opt_value))
            return output_emit(out, dot,
                das_enc_mem(0201U, opt_ac, 0, 0, opt_value), 0);
    }
#endif
    switch (parsed->token) {
    case DAS_TOK_RADIX:
        fprintf(stderr, DAS_DIAG("das: RADIX unsupported\n", "das: RADIX is not supported; DXR assembly uses octal constants by default\n"));
        return -1;
    case DAS_TOK_BLOCK:
    case DAS_TOK_SPACE:
        return output_emit_zeros(out, dot, nwords);
    case DAS_TOK_BYTE:
        return emit_byte_directive(c, parsed->stmt, dot, out, nwords);
    case DAS_TOK_ASCII:
        return emit_ascii_directive(parsed->stmt, dot, out, nwords, 0);
    case DAS_TOK_ASCIZ:
        return emit_ascii_directive(parsed->stmt, dot, out, nwords, 1);
    case DAS_TOK_SIXBIT:
        return emit_sixbit_directive(parsed->stmt, dot, out, nwords);
    case DAS_TOK_LONG:
        return emit_long_directive(c, parsed->stmt, dot, out, nwords);
    case DAS_TOK_WORD:
    case DAS_TOK_EXP:
    case DAS_TOK_POINT:
    case DAS_TOK_GIW:
    case DAS_TOK_OWGBP:
        {
            das_word_t w;
            int r;

            if (parse_data_word(c, parsed->stmt, dot, &w, &r))
                return -1;
            return output_emit(out, dot, w, r);
        }
    default:
        break;
    }
    if (looks_octal_token(parsed->key) || looks_symbolic_data_expr(parsed)) {
        das_word_t w;
        int r;

        if (parse_data_word(c, parsed->stmt, dot, &w, &r))
            return -1;
        return output_emit(out, dot, w, r);
    }
    /* Generic PDP-6/PDP-10 UUO syntax: UUO opcode,ea.
     * The opcode occupies the normal nine-bit instruction field; AC is zero
     * and the effective-address operand retains normal relocation syntax. */
    if (streqi(parsed->key, "UUO")) {
        unsigned int opcode;
        unsigned int y;
        int ind;
        int xr;
        int rel;
        das_word_t w;

        if (!split2(parsed->rest, &a, &b))
            return -1;
        if (eval_abs_u(c, a, dot, DAS_W(077), &opcode) != 0)
            return -1;
        if (parse_ea(c, b, dot, &y, &ind, &xr, &rel) != 0)
            return -1;
        w = das_enc_mem(opcode, 0U, ind, xr, y);
        return output_emit(out, dot, w, rel);
    }
    {
        int nonbase;

        op = lookup_op(parsed->key, &nonbase);
        if (op >= 0 && das_strict_base && nonbase) {
            fprintf(stderr, DAS_DIAG("das: non-base opcode: %s\n", "das: non-base opcode rejected in strict DAIMOS V1 mode: %s\n"), parsed->key);
            return -1;
        }
    }
    if (op < 0) {
        unsigned int alias_op;
        unsigned int alias_ac;

        if (lookup_fixed_ac_alias(parsed->key, &alias_op, &alias_ac)) {
            unsigned int y;
            int ind;
            int xr;
            int rel;
            das_word_t w;

            if (parse_ea(c, parsed->rest, dot, &y, &ind, &xr, &rel))
                return -1;
            w = das_enc_mem(alias_op, alias_ac, ind, xr, y);
            return output_emit(out, dot, w, rel);
        } else {
            int iofn;

            iofn = lookup_io(parsed->key);
            if (iofn < 0) {
                if (parsed->was_pseudo)
                    fprintf(stderr, DAS_DIAG("das: bad pseudo\n", "das: unsupported pseudo-op .%s\n"), parsed->key);
                else
                    fprintf(stderr, DAS_DIAG("das: bad op\n", "das: unknown op %s\n"), parsed->key);
                return -1;
            }
            if (das_strict_base && !das_kernel_mode) {
                fprintf(stderr, DAS_DIAG("das: I/O needs kernel mode: %s\n", "das: I/O opcode requires -k in strict DAIMOS V1 mode: %s\n"), parsed->key);
                return -1;
            }
            if (!split2(parsed->rest, &a, &b)) {
                a = (char *)"0";
                b = parsed->rest;
            }
            {
                unsigned int dev;
                unsigned int y;
                int ind;
                int xr;
                int rel;
                das_word_t w;

                dev = parse_octal_u(a);
                if (parse_ea(c, b, dot, &y, &ind, &xr, &rel))
                    return -1;
                w = das_enc_io(dev, (unsigned int)iofn, ind, xr, y);
                return output_emit(out, dot, w, rel);
            }
        }
    }
    if (sixbit_mn(parsed->key) == DAS_OP4('H','A','L','T')) {
        a = (char *)"4";
        b = parsed->rest;
    } else if (!split2(parsed->rest, &a, &b)) {
        a = (char *)"0";
        b = parsed->rest;
    }
    {
        unsigned int ac;
        unsigned int y;
        int ind;
        int xr;
        int rel;
        das_word_t w;

        ac = parse_octal_u(a);
        if (parse_ea(c, b, dot, &y, &ind, &xr, &rel))
            return -1;
        w = das_enc_mem((unsigned int)op, ac, ind, xr, y);
        return output_emit(out, dot, w, rel);
    }
}
static int fill_literals(struct asmctx *c, struct das_output *out)
{
    unsigned int i;
    unsigned int base;
    unsigned int image_off;

    base = text_total(c) - c->lit_store.image_words;
    image_off = 0U;
    lit_stream_reset(c);
    for (i = 0U; i < c->lit_store.records; i++) {
        char tmp[DAS_MAX_LINE];
        das_word_t w;
        int r;
        unsigned int dot;
        unsigned int lw;

        if (lit_read_next(c, tmp, sizeof(tmp)) != 0) {
            fprintf(stderr, DAS_DIAG("das: lit read\n", "das: cannot read literal %u\n"), i);
            return -1;
        }
        lw = literal_image_words(tmp, (unsigned int)strlen(tmp));
        dot = base + image_off;
        if (lw == 2U) {
            char *comma;

            comma = strchr(tmp, ',');
            if (comma == 0) {
                fprintf(stderr, DAS_DIAG("das: bad lit\n", "das: malformed literal %u: %s\n"), i, tmp);
                return -1;
            }
            *comma = 0;
            if (parse_data_word_radix(c, tmp, dot, &w, &r, 8) ||
                output_emit(out, dot, w, r) != 0) {
                fprintf(stderr, DAS_DIAG("das: bad lit\n", "das: malformed literal %u: %s\n"), i, tmp);
                return -1;
            }
            if (parse_data_word_radix(c, skipws(comma + 1), dot + 1U, &w, &r, 8) ||
                output_emit(out, dot + 1U, w, r) != 0) {
                fprintf(stderr, DAS_DIAG("das: bad lit\n",
                    "das: malformed literal %u: %s\n"), i,
                    skipws(comma + 1));
                return -1;
            }
        } else {
            if (parse_data_word_radix(c, tmp, dot, &w, &r, 8)) {
                fprintf(stderr, DAS_DIAG("das: bad lit\n", "das: malformed literal %u: %s\n"), i, tmp);
                return -1;
            }
            if (output_emit(out, dot, w, r) != 0) {
                fprintf(stderr, DAS_DIAG("das: lit emit\n", "das: cannot emit literal %u\n"), i);
                return -1;
            }
        }
        image_off += lw;
    }
    return 0;
}

#endif

#if !defined(DAS_NATIVE_PHASE2_ONLY)
static int parse_include_line(char *line, char *name, size_t namesz) { char *p, *q, *e; p = strchr(line, ';'); if (p) *p = 0; rtrim(line); p = skipws(line); if (*p == '.') p++; if (!pref_i(p, "INCLUDE", 7)) return 0; p = skipws(p + 7); if (*p != '\"') return -1; q = p + 1; e = strchr(q, '\"'); if (!e) return -1; *e = 0; strcopy(name, q, namesz); return 1; }
static void dirname_of(const char *path, char *out, size_t outsz) { const char *s = strrchr(path, '/'); size_t n; if (!s) { strcopy(out, ".", outsz); return; } n = char_distance(path, s); if (n >= outsz) n = outsz - 1; memcpy(out, path, n); out[n] = 0; }
static void join_path(const char *dir, const char *name, char *out, size_t outsz)
{
    size_t dlen;
    size_t nlen;

    if (name[0] == '/') {
        strcopy(out, name, outsz);
        return;
    }
    dlen = strlen(dir);
    nlen = strlen(name);
    if (dlen + 1U + nlen >= outsz)
        die("include path too long");
    memcpy(out, dir, dlen);
    out[dlen] = '/';
    memcpy(out + dlen + 1U, name, nlen + 1U);
}
static int rept_prefix(const char *line)
{
    const char *p;

    p = line;
    while (*p != 0 && isspace((unsigned char)*p))
        p++;
    if (*p == '.')
        p++;
    if (pref_i(p, "REPT", 4) &&
        (p[4] == 0 || isspace((unsigned char)p[4])))
        return 1;
    if (pref_i(p, "IRP", 3) &&
        (p[3] == 0 || isspace((unsigned char)p[3])))
        return 1;
    if (pref_i(p, "IRPC", 4) &&
        (p[4] == 0 || isspace((unsigned char)p[4])))
        return 1;
    if (pref_i(p, "ENDR", 4) &&
        (p[4] == 0 || isspace((unsigned char)p[4])))
        return 1;
    return 0;
}

static int rept_structure_kind(struct asmctx *c, char *line)
{
    struct das_parsed_line parsed;

    if (!rept_prefix(line))
        return 0;
    if (parse_line_head(c, line, &parsed) == 0 || parsed.stmt == 0)
        return 0;
    if (streqi(parsed.key, "REPT") || streqi(parsed.key, "IRP") ||
        streqi(parsed.key, "IRPC"))
        return 1;
    if (streqi(parsed.key, "ENDR"))
        return 2;
    return 0;
}

static int rept_count_line(struct asmctx *c, char *line, unsigned int dot,
                           unsigned int *count, int *kind)
{
    struct das_parsed_line parsed;
    char *p;
    das_word_t value;
    int reloc;

    *kind = 0;
    if (!rept_prefix(line))
        return 0;
    if (parse_line_head(c, line, &parsed) == 0 || parsed.stmt == 0)
        return 0;
    if (!streqi(parsed.key, "REPT") && !streqi(parsed.key, "IRP") &&
        !streqi(parsed.key, "IRPC") && !streqi(parsed.key, "ENDR"))
        return 0;
    if (streqi(parsed.key, "REPT"))
        *kind = DAS_REPT_BLOCK;
    else if (streqi(parsed.key, "IRP"))
        *kind = DAS_REPT_IRP;
    else if (streqi(parsed.key, "IRPC"))
        *kind = DAS_REPT_IRPC;
    else
        *kind = DAS_REPT_END;
    if (parsed.label != 0) {
        fprintf(stderr, DAS_DIAG("das: bad rept\n",
            "das: repetition directive cannot define a label: %s\n"),
            parsed.stmt);
        return 1;
    }
    if (*kind == DAS_REPT_END) {
        if (*skipws(parsed.rest) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad endr\n",
                "das: malformed .endr directive: %s\n"), parsed.stmt);
            return 1;
        }
        return 0;
    }
    if (*kind == DAS_REPT_IRP || *kind == DAS_REPT_IRPC) {
        p = skipws(parsed.rest);
        if (!isname0((unsigned char)*p)) {
            fprintf(stderr, DAS_DIAG("das: bad iter\n",
                "das: .%s requires an iterator symbol: %s\n"),
                *kind == DAS_REPT_IRP ? "irp" : "irpc", parsed.stmt);
            return 1;
        }
        while (isname((unsigned char)*p))
            p++;
        p = skipws(p);
        if (*p != 0 && *p != ',' && *p != ';') {
            fprintf(stderr, DAS_DIAG("das: bad iter\n",
                "das: malformed .%s iterator list: %s\n"),
                *kind == DAS_REPT_IRP ? "irp" : "irpc", parsed.stmt);
            return 1;
        }
        return 0;
    }
    if (*skipws(parsed.rest) == 0 ||
        eval_expr(c, parsed.rest, dot, &value, &reloc) != 0 || reloc ||
        value > (das_word_t)DAS_MAX_REPT_COUNT) {
        fprintf(stderr, DAS_DIAG("das: bad rept\n",
            "das: .rept requires an absolute count from 0 through %u: %s\n"),
            DAS_MAX_REPT_COUNT, parsed.stmt);
        return 1;
    }
    *count = (unsigned int)value;
    return 0;
}

static int rept_store_append_line(struct asmctx *c, const char *line)
{
    unsigned int len;
    unsigned int words;
#ifdef DAS_NATIVE
    das_word_t *record;
#else
    das_word_t record[1U + DAS_REPT_PACK_WORDS];
#endif

    len = (unsigned int)strlen(line);
    if (len >= DAS_MAX_LINE)
        return -1;
    words = (len + DAS_TARGET_CHARS_PER_WORD - 1U) /
        DAS_TARGET_CHARS_PER_WORD;
#ifdef DAS_NATIVE
    record = das_native_rept_record;
#endif
    record[0] = (das_word_t)len;
    if (words != 0U)
        pack_text_words(record + 1U, words, line, len);
    return wordfile_append(&c->rept_spill, record, 1U + words);
}

static int rept_store_read_line(struct asmctx *c, unsigned int pos,
                                unsigned int limit, char *line,
                                unsigned int *next)
{
    das_word_t header;
    unsigned int len;
    unsigned int words;
#ifdef DAS_NATIVE
    das_word_t *record;
#else
    das_word_t record[DAS_REPT_PACK_WORDS];
#endif

    if (pos >= limit || wordfile_read(&c->rept_spill, pos, &header, 1U) != 0)
        return -1;
    len = (unsigned int)(header & DAS_HALF_MASK);
    if (len >= DAS_MAX_LINE)
        return -1;
    words = (len + DAS_TARGET_CHARS_PER_WORD - 1U) /
        DAS_TARGET_CHARS_PER_WORD;
    if (pos + 1U + words > limit)
        return -1;
#ifdef DAS_NATIVE
    record = das_native_rept_record;
#endif
    if (words != 0U &&
        wordfile_read(&c->rept_spill, pos + 1U, record, words) != 0)
        return -1;
    if (words != 0U)
        unpack_text_words(line, DAS_MAX_LINE, record, len);
    else
        line[0] = 0;
    *next = pos + 1U + words;
    return 0;
}

static int iter_store_spec(struct asmctx *c, char *line,
                           unsigned int *name_pos,
                           unsigned int *values_pos)
{
    struct das_parsed_line parsed;
    char *name;
    char *p;
    char *q;
    char *end;
    char saved;
    unsigned int quote;
    int escape;

    if (parse_line_head(c, line, &parsed) == 0 || parsed.stmt == 0 ||
        (!streqi(parsed.key, "IRP") && !streqi(parsed.key, "IRPC")))
        return -1;
    name = skipws(parsed.rest);
    q = name;
    while (isname((unsigned char)*q))
        q++;
    if (q == name)
        return -1;
    saved = *q;
    *q = 0;
    *name_pos = c->rept_spill.words;
    if (rept_store_append_line(c, name) != 0) {
        *q = saved;
        return -1;
    }
    *q = saved;

    p = skipws(q);
    if (*p == ',')
        p = skipws(p + 1);
    else
        p += strlen(p);

    quote = 0U;
    escape = 0;
    end = p;
    for (q = p; *q != 0; q++) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)*q;
        if (quote != 0U) {
            if (escape)
                escape = 0;
            else if (ch == '\\')
                escape = 1;
            else if (ch == quote)
                quote = 0U;
        } else if (ch == '"' || ch == '\'') {
            quote = ch;
        } else if (ch == ';') {
            break;
        }
        end = q + 1;
    }
    while (end > p && isspace((unsigned char)end[-1]))
        end--;
    saved = *end;
    *end = 0;
    *values_pos = c->rept_spill.words;
    if (rept_store_append_line(c, p) != 0) {
        *end = saved;
        return -1;
    }
    *end = saved;
    return 0;
}

static int iter_store_value_slice(struct asmctx *c, char *line,
                                  char *first, char *last,
                                  unsigned int *value_pos)
{
    char saved;

    while (first < last && isspace((unsigned char)*first))
        first++;
    while (last > first && isspace((unsigned char)last[-1]))
        last--;
    if (last - first >= 2 && first[0] == '"' && last[-1] == '"') {
        first++;
        last--;
    }
    (void)line;
    saved = *last;
    *last = 0;
    *value_pos = c->rept_spill.words;
    if (rept_store_append_line(c, first) != 0) {
        *last = saved;
        return -1;
    }
    *last = saved;
    return 0;
}

static int iter_irp_next(struct asmctx *c, unsigned int values_pos,
                         unsigned int *cursor, unsigned int *started,
                         unsigned int *value_pos)
{
#ifdef DAS_NATIVE
    char *line;
#else
    char line_store[DAS_MAX_LINE];
    char *line;
#endif
    unsigned int next;
    unsigned int len;
    unsigned int pos;
    unsigned int quote;
    unsigned int paren;
    unsigned int bracket;
    unsigned int brace;
    int escape;
    char *first;
    char *last;

#ifdef DAS_NATIVE
    line = das_native_tmp;
#else
    line = line_store;
#endif
    if (rept_store_read_line(c, values_pos, c->rept_spill.words,
            line, &next) != 0)
        return -1;
    len = (unsigned int)strlen(line);
    if (len == 0U) {
        if (*started)
            return 0;
        *started = 1U;
        *value_pos = c->rept_spill.words;
        return rept_store_append_line(c, "") == 0 ? 1 : -1;
    }
    if (*cursor >= len)
        return 0;

    pos = *cursor;
    first = line + pos;
    quote = paren = bracket = brace = 0U;
    escape = 0;
    for (;;) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)line[pos];
        if (quote != 0U) {
            if (ch == 0U)
                return -1;
            if (escape)
                escape = 0;
            else if (ch == '\\')
                escape = 1;
            else if (ch == quote)
                quote = 0U;
            pos++;
            continue;
        }
        if (ch == '"' || ch == '\'') {
            quote = ch;
            pos++;
            continue;
        }
        if (ch == '(')
            paren++;
        else if (ch == ')') {
            if (paren == 0U)
                return -1;
            paren--;
        } else if (ch == '[')
            bracket++;
        else if (ch == ']') {
            if (bracket == 0U)
                return -1;
            bracket--;
        } else if (ch == '{')
            brace++;
        else if (ch == '}') {
            if (brace == 0U)
                return -1;
            brace--;
        }
        if ((ch == ',' || ch == 0U) && paren == 0U && bracket == 0U &&
            brace == 0U)
            break;
        if (ch == 0U)
            return -1;
        pos++;
    }
    last = line + pos;
    *cursor = line[pos] == ',' ? pos + 1U : len;
    *started = 1U;
    if (iter_store_value_slice(c, line, first, last, value_pos) != 0)
        return -1;
    return 1;
}

static int iter_irpc_next(struct asmctx *c, unsigned int values_pos,
                          unsigned int *cursor, unsigned int *started,
                          unsigned int *quote, unsigned int *value_pos)
{
#ifdef DAS_NATIVE
    char *line;
#else
    char line_store[DAS_MAX_LINE];
    char *line;
#endif
    unsigned int next;
    unsigned int len;
    char value[2];

#ifdef DAS_NATIVE
    line = das_native_tmp;
#else
    line = line_store;
#endif
    if (rept_store_read_line(c, values_pos, c->rept_spill.words,
            line, &next) != 0)
        return -1;
    len = (unsigned int)strlen(line);
    if (len == 0U) {
        if (*started)
            return 0;
        *started = 1U;
        *value_pos = c->rept_spill.words;
        return rept_store_append_line(c, "") == 0 ? 1 : -1;
    }
    *started = 1U;
    while (*cursor < len) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)line[*cursor];
        (*cursor)++;
        if (ch == '"') {
            *quote = *quote == 0U ? ch : 0U;
            continue;
        }
        if (*quote == 0U && isspace((unsigned char)ch))
            continue;
        value[0] = (char)ch;
        value[1] = 0;
        *value_pos = c->rept_spill.words;
        return rept_store_append_line(c, value) == 0 ? 1 : -1;
    }
    return *quote == 0U ? 0 : -1;
}

#if !defined(DAS_PHASE2_PROGRAM)
#if !defined(DAS_NATIVE_PHASE2_ONLY)
static int source_advance(struct asmctx *c);
#endif
static int ir_store_begin(struct asmctx *c)
{
    das_word_t magic;

    magic = DAS_IR_MAGIC;
    return wordfile_append(&c->ir_spill, &magic, 1U);
}
#endif

#if DAS_ENABLE_OPTIMIZER
static int ir_store_control(struct asmctx *c, unsigned int type)
{
    das_word_t header;

    header = ((das_word_t)(type & DAS_IR_TYPE_MASK)) << DAS_IR_TYPE_SHIFT;
    return wordfile_append(&c->ir_spill, &header, 1U);
}
#endif

static int ir_store_append_line(struct asmctx *c, const char *line)
{
    das_word_t header;
    unsigned int len;
    unsigned int words;
#ifdef DAS_NATIVE
    das_word_t *record;
#else
    das_word_t record[DAS_REPT_PACK_WORDS];
#endif

    len = (unsigned int)strlen(line);
    if (len >= DAS_MAX_LINE)
        return -1;
    words = (len + DAS_TARGET_CHARS_PER_WORD - 1U) /
        DAS_TARGET_CHARS_PER_WORD;
    header = ((das_word_t)DAS_IR_LINE << DAS_IR_TYPE_SHIFT) |
        (das_word_t)len;
    if (wordfile_append(&c->ir_spill, &header, 1U) != 0)
        return -1;
#ifdef DAS_NATIVE
    record = das_native_rept_record;
#endif
    if (words != 0U) {
        pack_text_words(record, words, line, len);
        if (wordfile_append(&c->ir_spill, record, words) != 0)
            return -1;
    }
    return 0;
}

#if !defined(DAS_PHASE2_PROGRAM)
#if DAS_ENABLE_OPTIMIZER
static int ir_store_read_line(struct asmctx *c, unsigned int *pos,
                              char *line, unsigned int *type)
{
    das_word_t header;
    unsigned int len;
    unsigned int words;
#ifdef DAS_NATIVE
    das_word_t *record;
#else
    das_word_t record[DAS_REPT_PACK_WORDS];
#endif

    if (*pos >= c->ir_spill.words ||
        wordfile_read(&c->ir_spill, *pos, &header, 1U) != 0)
        return -1;
    (*pos)++;
    *type = (unsigned int)((header >> DAS_IR_TYPE_SHIFT) &
        DAS_IR_TYPE_MASK);
    if (*type != DAS_IR_LINE) {
        line[0] = 0;
        return 0;
    }
    len = (unsigned int)(header & DAS_HALF_MASK);
    if (len >= DAS_MAX_LINE)
        return -1;
    words = (len + DAS_TARGET_CHARS_PER_WORD - 1U) /
        DAS_TARGET_CHARS_PER_WORD;
    if (*pos + words > c->ir_spill.words)
        return -1;
#ifdef DAS_NATIVE
    record = das_native_rept_record;
#endif
    if (words != 0U) {
        if (wordfile_read(&c->ir_spill, *pos, record, words) != 0)
            return -1;
        unpack_text_words(line, DAS_MAX_LINE, record, len);
    } else {
        line[0] = 0;
    }
    *pos += words;
    return 0;
}
#endif
#endif


#if !defined(DAS_PHASE2_PROGRAM) && !defined(DAS_NATIVE_PHASE2_ONLY) && \
    DAS_ENABLE_OPTIMIZER
static int ir_indexed_xct_targets(struct asmctx *c, int mark)
{
#ifdef DAS_NATIVE
    char *line;
    char *name;
#else
    char line_store[DAS_MAX_LINE];
    char name_store[DAS_MAX_NAME + 1];
    char *line;
    char *name;
#endif
    struct das_parsed_line parsed;
    unsigned int pos;
    unsigned int type;
    int found;

#ifdef DAS_NATIVE
    line = das_native_line;
    name = das_native_inc;
#else
    line = line_store;
    name = name_store;
#endif
    pos = 1U;
    found = 0;
    while (pos < c->ir_spill.words) {
        if (ir_store_read_line(c, &pos, line, &type) != 0)
            return -1;
        if (type != DAS_IR_LINE)
            continue;
        if (parse_line_head(c, line, &parsed) == 0)
            continue;
        if (!opt_indexed_xct_symbol(&parsed, name, DAS_MAX_NAME + 1U))
            continue;
        found = 1;
        if (mark)
            mark_indexed_xct_target(c, name);
    }
    return found;
}

static void pass1_reset_semantics_for_ir_replay(struct asmctx *c)
{
    memset(c->sym_store.heads, 0, sizeof(c->sym_store.heads));
    memset(c->sym_store.cache, 0, sizeof(c->sym_store.cache));
    c->sym_store.spill.words = 0U;
    c->sym_store.records = 0U;
    c->sym_store.lookups = 0U;
    c->sym_store.probes = 0U;

    c->lit_store.spill.words = 0U;
    c->lit_store.records = 0U;
    c->lit_store.words = 0U;
    c->lit_store.image_words = 0U;
    c->lit_store.read_next = 0U;
    c->lit_store.read_pos = 0U;
    c->lit_store.read_count = 0U;
    c->lit_store.read_records = 0U;

    memset(c->loc, 0, sizeof(c->loc));
    c->entry = 0U;
    c->entry_name[0] = 0;
    c->source_serial = 0U;
    c->set_serial = 0U;
#if DAS_ENABLE_OPTIMIZER
    c->opt_skip_next = 0U;
    c->opt_current_may_be_skipped = 0U;
#endif
    opt_reset(c);
#ifndef DAS_NATIVE
    c->obj_global_count = 0U;
    c->obj_reloc_count = 0U;
#endif
}

static int pass1_replay_ir(struct asmctx *c)
{
#ifdef DAS_NATIVE
    char *line;
#else
    char line_store[DAS_MAX_LINE];
    char *line;
#endif
    unsigned int pos;
    unsigned int type;
    int sec;

#ifdef DAS_NATIVE
    line = das_native_line;
#else
    line = line_store;
#endif
    sec = DAS_SEC_TEXT;
    pos = 1U;
    while (pos < c->ir_spill.words) {
        if (ir_store_read_line(c, &pos, line, &type) != 0)
            return 1;
        if (type == DAS_IR_RESET) {
            opt_reset(c);
            continue;
        }
        if (type == DAS_IR_GUARD) {
#if DAS_ENABLE_OPTIMIZER
            c->opt_skip_next |= DAS_OPT_GUARD_NEXT;
#endif
            continue;
        }
        if (type != DAS_IR_LINE)
            return 1;
        if (source_advance(c) || pass1_line(c, line, &sec) != 0)
            return 1;
    }
    return 0;
}

/* The expanded IR is already available after pass 1.  If it contains an
 * indexed symbolic XCT, replay only the semantic/layout pass with every XCT
 * table target marked up front.  This handles both forward and backward table
 * references without a fixed-RAM target set and without penalizing sources
 * that do not use indexed XCT dispatch. */
static int pass1_replay_indexed_xct(struct asmctx *c)
{
    /* The empty marker is an internal sentinel set while the normal pass
     * parses an indexed XCT.  Sources without indexed XCT avoid even an IR
     * scan, preserving the normal fast path and parser-work accounting. */
    if (!find_indexed_xct_marker(c, ""))
        return 0;
    pass1_reset_semantics_for_ir_replay(c);
    if (ir_indexed_xct_targets(c, 1) <= 0)
        return 1;
    return pass1_replay_ir(c);
}
#endif

#endif

#if !defined(DAS_PHASE2_PROGRAM) && !defined(DAS_NATIVE_PHASE2_ONLY)
static das_word_t phase_header(unsigned int type, unsigned int count)
{
    return ((das_word_t)(type & DAS_IR_TYPE_MASK) << DAS_IR_TYPE_SHIFT) |
        ((das_word_t)count & DAS_IR_COUNT_MASK);
}

static int phase_write_words(FILE *file, const das_word_t *words,
                             unsigned int count)
{
    struct das_wordfile out;

    memset(&out, 0, sizeof(out));
    out.file = file;
    return wordfile_write(&out, words, count);
}

static int phase_copy_wordfile(FILE *dst, struct das_wordfile *src,
                               unsigned int first, unsigned int words)
{
#ifdef DAS_NATIVE
    das_word_t *buffer;
#else
    das_word_t buffer[DAS_WORD_INPUT_BUFFER];
#endif
    unsigned int chunk;

#ifdef DAS_NATIVE
    buffer = das_native_rept_record;
#endif
    while (words != 0U) {
        chunk = words > DAS_WORD_INPUT_BUFFER ?
            DAS_WORD_INPUT_BUFFER : words;
        if (wordfile_read(src, first, buffer, chunk) != 0 ||
            phase_write_words(dst, buffer, chunk) != 0)
            return -1;
        first += chunk;
        words -= chunk;
    }
    return 0;
}

static int phase_export_stream(struct asmctx *c, FILE *out)
{
    das_word_t state[DAS_PHASE_STATE_WORDS];
    das_word_t header;
    das_word_t magic;
    unsigned int flags;
    unsigned int line_words;
    int rc;

    flags = 0U;
#if DAS_ENABLE_OPTIMIZER
    if (das_optimize)
        flags |= DAS_PHASE_F_OPTIMIZE;
#endif
    if (das_strict_base)
        flags |= DAS_PHASE_F_STRICT_BASE;
    if (das_kernel_mode)
        flags |= DAS_PHASE_F_KERNEL;
    state[0] = (das_word_t)flags;
    state[1] = (das_word_t)c->entry;
    state[2] = (das_word_t)c->loc[DAS_SEC_ABS];
    state[3] = (das_word_t)c->loc[DAS_SEC_TEXT];
    state[4] = (das_word_t)c->loc[DAS_SEC_DATA];
    state[5] = (das_word_t)c->loc[DAS_SEC_BSS];
    state[6] = (das_word_t)c->sym_store.records;
    state[7] = (das_word_t)c->lit_store.records;
    state[8] = (das_word_t)c->lit_store.words;
    state[9] = (das_word_t)c->lit_store.image_words;
    state[10] = (das_word_t)c->peak_work_words;
    state[11] = (das_word_t)c->parser_classifications;
    state[12] = (das_word_t)c->parser_token_probes;
    state[13] = DAS_WORD(c->sym_store.lookups, c->sym_store.probes);
    magic = DAS_PHASE_MAGIC;
    header = phase_header(DAS_PHASE_STATE, DAS_PHASE_STATE_WORDS);
    rc = phase_write_words(out, &magic, 1U) != 0 ||
        phase_write_words(out, &header, 1U) != 0 ||
        phase_write_words(out, state, DAS_PHASE_STATE_WORDS) != 0;
    if (!rc) {
        header = phase_header(DAS_PHASE_SYMBOLS, c->sym_store.records);
        rc = phase_write_words(out, &header, 1U) != 0 ||
            phase_copy_wordfile(out, &c->sym_store.spill, 0U,
                c->sym_store.records * DAS_SYM_RECORD_WORDS) != 0;
    }
    if (!rc) {
        header = phase_header(DAS_PHASE_LITERALS, c->lit_store.words);
        rc = phase_write_words(out, &header, 1U) != 0 ||
            phase_copy_wordfile(out, &c->lit_store.spill, 0U,
                c->lit_store.words) != 0;
    }
    if (!rc) {
        line_words = c->ir_spill.words - 1U;
        header = phase_header(DAS_PHASE_LINES, line_words);
        rc = phase_write_words(out, &header, 1U) != 0 ||
            phase_copy_wordfile(out, &c->ir_spill, 1U, line_words) != 0;
    }
    if (!rc) {
        header = phase_header(DAS_PHASE_END, 0U);
        rc = phase_write_words(out, &header, 1U) != 0;
    }
    return rc ? -1 : 0;
}



#endif

#if !defined(DAS_NATIVE_PHASE1_ONLY) && \
    (defined(DAS_NATIVE) || defined(DAS_PHASE2_PROGRAM))
static int phase_get_word(struct host_word_input *in, das_word_t *word)
{
    return host_word_get(in, word) == DAS_INPUT_OK ? 0 : -1;
}

static int phase_get_header(struct host_word_input *in, unsigned int type,
                            unsigned int *count)
{
    das_word_t header;
    unsigned int got;

    if (phase_get_word(in, &header) != 0)
        return -1;
    got = (unsigned int)((header >> DAS_IR_TYPE_SHIFT) & DAS_IR_TYPE_MASK);
    if (got != type)
        return -1;
    *count = (unsigned int)(header & DAS_IR_COUNT_MASK);
    return 0;
}

static int phase_import_state(struct asmctx *c, struct host_word_input *in,
                              unsigned int *line_words)
{
    das_word_t state[DAS_PHASE_STATE_WORDS];
    das_word_t record[DAS_SYM_RECORD_WORDS];
#ifdef DAS_NATIVE
    das_word_t *buffer;
#else
    das_word_t buffer[DAS_WORD_INPUT_BUFFER];
#endif
    das_word_t magic;
    unsigned int count;
    unsigned int flags;
    unsigned int i;
    unsigned int j;
    unsigned int chunk;
    unsigned int bucket;
    unsigned int ref;

#ifdef DAS_NATIVE
    buffer = das_native_output_buffer;
#endif
    if (phase_get_word(in, &magic) != 0 || magic != DAS_PHASE_MAGIC ||
        phase_get_header(in, DAS_PHASE_STATE, &count) != 0 ||
        count != DAS_PHASE_STATE_WORDS)
        return -1;
    for (i = 0U; i < DAS_PHASE_STATE_WORDS; i++) {
        if (phase_get_word(in, &state[i]) != 0)
            return -1;
    }
    flags = (unsigned int)state[0];
#if DAS_ENABLE_OPTIMIZER
    das_optimize = (flags & DAS_PHASE_F_OPTIMIZE) != 0U;
#endif
    das_strict_base = (flags & DAS_PHASE_F_STRICT_BASE) != 0U;
    das_kernel_mode = (flags & DAS_PHASE_F_KERNEL) != 0U;
    c->entry = (unsigned int)state[1];
    c->loc[DAS_SEC_ABS] = (unsigned int)state[2];
    c->loc[DAS_SEC_TEXT] = (unsigned int)state[3];
    c->loc[DAS_SEC_DATA] = (unsigned int)state[4];
    c->loc[DAS_SEC_BSS] = (unsigned int)state[5];
    c->lit_store.records = (unsigned int)state[7];
    c->lit_store.words = (unsigned int)state[8];
    c->lit_store.image_words = (unsigned int)state[9];
    c->peak_work_words = (unsigned int)state[10];
    c->parser_classifications = (unsigned int)state[11];
    c->parser_token_probes = (unsigned int)state[12];
    c->sym_store.lookups = (unsigned int)((state[13] >> 18U) &
        DAS_HALF_MASK);
    c->sym_store.probes = (unsigned int)(state[13] & DAS_HALF_MASK);
    if (phase_get_header(in, DAS_PHASE_SYMBOLS, &count) != 0 ||
        count != (unsigned int)state[6])
        return -1;
    for (i = 0U; i < count; i++) {
        for (j = 0U; j < DAS_SYM_RECORD_WORDS; j++) {
            if (phase_get_word(in, &record[j]) != 0)
                return -1;
        }
        bucket = (unsigned int)(record[1] & (DAS_SYM_BUCKETS - 1U));
        ref = i + 1U;
        if ((unsigned int)(record[0] & DAS_HALF_MASK) !=
            c->sym_store.heads[bucket] ||
            wordfile_append(&c->sym_store.spill, record,
                DAS_SYM_RECORD_WORDS) != 0)
            return -1;
        c->sym_store.heads[bucket] = ref;
    }
    c->sym_store.records = count;
    if (phase_get_header(in, DAS_PHASE_LITERALS, &count) != 0 ||
        count != c->lit_store.words)
        return -1;
    while (count != 0U) {
        chunk = count > DAS_WORD_INPUT_BUFFER ?
            DAS_WORD_INPUT_BUFFER : count;
        for (i = 0U; i < chunk; i++) {
            if (phase_get_word(in, &buffer[i]) != 0)
                return -1;
        }
        if (wordfile_append(&c->lit_store.spill, buffer, chunk) != 0)
            return -1;
        count -= chunk;
    }
    if (phase_get_header(in, DAS_PHASE_LINES, line_words) != 0)
        return -1;
    return 0;
}

#endif

#if !defined(DAS_NATIVE_PHASE2_ONLY)
static int macro_name_eq(const char *a, size_t an,
                         const char *b, size_t bn)
{
    size_t i;

    if (an != bn)
        return 0;
    for (i = 0U; i < an; i++) {
        unsigned int ac;
        unsigned int bc;

        ac = (unsigned int)(unsigned char)a[i];
        bc = (unsigned int)(unsigned char)b[i];
        if (ac >= 'a' && ac <= 'z')
            ac = ac - 'a' + 'A';
        if (bc >= 'a' && bc <= 'z')
            bc = bc - 'a' + 'A';
        if (ac != bc)
            return 0;
    }
    return 1;
}

static int macro_internal_key(const char *name, char *key, size_t keysz)
{
    size_t n;
    size_t i;

    n = strlen(name);
    if (n == 0U || n + 2U > keysz)
        return -1;
    key[0] = '\001';
    for (i = 0U; i < n; i++) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)name[i];
        if (ch >= 'a' && ch <= 'z')
            ch = ch - 'a' + 'A';
        key[i + 1U] = (char)ch;
    }
    key[n + 1U] = 0;
    return 0;
}

static int macro_name_reserved(struct asmctx *c, const char *name)
{
    if (classify_token(c, name) != DAS_TOK_OTHER ||
        lookup_op_mn(sixbit_mn(name), 0) >= 0)
        return 1;
    return streqi(name, "MACRO") || streqi(name, "ENDM") ||
        streqi(name, "REPT") || streqi(name, "IRP") ||
        streqi(name, "IRPC") || streqi(name, "ENDR") ||
        streqi(name, "INCLUDE") || streqi(name, "IF") ||
        streqi(name, "IFDEF") || streqi(name, "IFNDEF") ||
        streqi(name, "ELSE") || streqi(name, "ENDIF");
}

static int macro_param_seen(const char *first, const char *cur,
                            const char *name, size_t namelen)
{
    const char *p;

    p = first;
    while (p < cur) {
        const char *a;
        size_t n;

        while (p < cur && (isspace((unsigned char)*p) || *p == ','))
            p++;
        if (p >= cur)
            break;
        a = p;
        while (p < cur && isname((unsigned char)*p))
            p++;
        n = char_distance(a, p);
        if (macro_name_eq(a, n, name, namelen))
            return 1;
        while (p < cur && *p != ',')
            p++;
    }
    return 0;
}

static int macro_parse_definition(struct asmctx *c, char *line,
                                  char *name, size_t namesz,
                                  unsigned int *argc)
{
    struct das_parsed_line parsed;
    char *p;
    const char *params;
    size_t n;
    unsigned int count;

    *argc = 0U;
    if (parse_line_head(c, line, &parsed) == 0 || parsed.stmt == 0 ||
        !streqi(parsed.key, "MACRO"))
        return 0;
    if (parsed.label != 0) {
        fprintf(stderr, DAS_DIAG("das: bad macro\n",
            "das: .macro directive cannot define a label: %s\n"),
            parsed.stmt);
        return -1;
    }
    p = skipws(parsed.rest);
    if (!isname0((unsigned char)*p)) {
        fprintf(stderr, DAS_DIAG("das: bad macro\n",
            "das: malformed .macro definition: %s\n"), parsed.stmt);
        return -1;
    }
    n = 0U;
    while (isname((unsigned char)*p)) {
        if (n + 1U >= namesz) {
            fprintf(stderr, DAS_DIAG("das: macro name long\n",
                "das: macro name is too long\n"));
            return -1;
        }
        name[n++] = *p++;
    }
    name[n] = 0;
    /* Internal macro symbols reserve one otherwise-impossible name byte. */
    if (n >= DAS_MAX_NAME) {
        fprintf(stderr, DAS_DIAG("das: macro name long\n",
            "das: macro name is too long\n"));
        return -1;
    }
    if (macro_name_reserved(c, name)) {
        fprintf(stderr, DAS_DIAG("das: macro name reserved\n",
            "das: macro name conflicts with an instruction or directive: %s\n"),
            name);
        return -1;
    }
    p = skipws(p);
    if (*p == 0)
        return 1;
    params = p;
    count = 0U;
    for (;;) {
        char *a;
        size_t pn;

        p = skipws(p);
        if (!isname0((unsigned char)*p)) {
            fprintf(stderr, DAS_DIAG("das: bad macro args\n",
                "das: malformed .macro parameter list\n"));
            return -1;
        }
        a = p;
        while (isname((unsigned char)*p))
            p++;
        pn = char_distance(a, p);
        if (macro_param_seen(params, a, a, pn)) {
            fprintf(stderr, DAS_DIAG("das: dup macro arg\n",
                "das: duplicate macro parameter: %.*s\n"),
                (int)pn, a);
            return -1;
        }
        count++;
        if (count > DAS_MAX_MACRO_ARGS) {
            fprintf(stderr, DAS_DIAG("das: macro args many\n",
                "das: macro has more than %u parameters\n"),
                DAS_MAX_MACRO_ARGS);
            return -1;
        }
        p = skipws(p);
        if (*p == 0)
            break;
        if (*p != ',') {
            fprintf(stderr, DAS_DIAG("das: bad macro args\n",
                "das: macro parameters must be comma-separated\n"));
            return -1;
        }
        p++;
        if (*skipws(p) == 0) {
            fprintf(stderr, DAS_DIAG("das: bad macro args\n",
                "das: trailing comma in .macro parameter list\n"));
            return -1;
        }
    }
    *argc = count;
    return 1;
}

static int macro_scan_head(char *line, struct das_parsed_line *parsed)
{
    char *p;
    char *colon;
    char *q;
    size_t n;
    unsigned int i;

    parsed->label = 0;
    parsed->label_len = 0U;
    parsed->stmt = 0;
    parsed->rest = 0;
    parsed->key[0] = 0;
    p = strchr(line, ';');
    if (p != 0)
        *p = 0;
    rtrim(line);
    p = skipws(line);
    if (*p == 0)
        return 0;
    colon = strchr(p, ':');
    if (colon != 0) {
        n = char_distance(p, colon);
        while (n != 0U && isspace((unsigned char)p[n - 1U]))
            n--;
        parsed->label = p;
        parsed->label_len = n;
        p = skipws(colon + 1);
        if (*p == 0)
            return 1;
    }
    parsed->stmt = p;
    q = p;
    if (*q == '.')
        q++;
    i = 0U;
    while (q[i] != 0 && !isspace((unsigned char)q[i]) &&
           i < DAS_MAX_NAME) {
        parsed->key[i] = q[i];
        i++;
    }
    parsed->key[i] = 0;
    parsed->rest = skipws(q + i);
    return 1;
}

static int macro_structure_kind(struct asmctx *c, char *line)
{
    struct das_parsed_line parsed;

    (void)c;
    if (macro_scan_head(line, &parsed) == 0 || parsed.stmt == 0)
        return 0;
    if (streqi(parsed.key, "MACRO"))
        return 1;
    if (streqi(parsed.key, "ENDM"))
        return 2;
    return 0;
}

static int macro_validate_endm(struct asmctx *c, char *line)
{
    struct das_parsed_line parsed;

    if (parse_line_head(c, line, &parsed) == 0 || parsed.stmt == 0 ||
        !streqi(parsed.key, "ENDM"))
        return 0;
    if (parsed.label != 0 || *skipws(parsed.rest) != 0) {
        fprintf(stderr, DAS_DIAG("das: bad endm\n",
            "das: malformed .endm directive\n"));
        return -1;
    }
    return 1;
}

static int macro_arg_scan(const char *s, unsigned int wanted,
                          const char **arg, size_t *arglen,
                          unsigned int *count)
{
    const char *p;
    const char *start;
    const char *end;
    unsigned int n;
    unsigned int paren;
    unsigned int bracket;
    unsigned int brace;
    unsigned int quote;
    int escape;

    p = s;
    while (*p != 0 && isspace((unsigned char)*p))
        p++;
    if (*p == 0 || *p == ';') {
        *count = 0U;
        return wanted == 0U ? 0 : -1;
    }
    start = p;
    n = 1U;
    paren = bracket = brace = quote = 0U;
    escape = 0;
    for (;;) {
        unsigned int ch;

        ch = (unsigned int)(unsigned char)*p;
        if (quote != 0U) {
            if (ch == 0U)
                return -1;
            if (escape)
                escape = 0;
            else if (ch == '\\')
                escape = 1;
            else if (ch == quote)
                quote = 0U;
            p++;
            continue;
        }
        if (ch == '\'' || ch == '"') {
            quote = ch;
            p++;
            continue;
        }
        if (ch == 0U && (paren != 0U || bracket != 0U || brace != 0U))
            return -1;
        if (ch == '(') paren++;
        else if (ch == ')') { if (paren == 0U) return -1; paren--; }
        else if (ch == '[') bracket++;
        else if (ch == ']') { if (bracket == 0U) return -1; bracket--; }
        else if (ch == '{') brace++;
        else if (ch == '}') { if (brace == 0U) return -1; brace--; }
        if ((ch == ',' || ch == 0U || ch == ';') &&
            paren == 0U && bracket == 0U && brace == 0U) {
            end = p;
            while (end > start && isspace((unsigned char)end[-1]))
                end--;
            while (start < end && isspace((unsigned char)*start))
                start++;
            if (start == end)
                return -1;
            if (n == wanted && arg != 0 && arglen != 0) {
                *arg = start;
                *arglen = char_distance(start, end);
            }
            if (ch == ',') {
                n++;
                p++;
                start = p;
                continue;
            }
            if (paren != 0U || bracket != 0U || brace != 0U)
                return -1;
            *count = n;
            return 0;
        }
        p++;
    }
}

static int macro_param_index(struct asmctx *c, unsigned int def_pos,
                             const char *name, size_t namelen,
                             char *scratch, unsigned int *index)
{
    struct das_parsed_line parsed;
    unsigned int next;
    char *p;
    unsigned int n;

    if (rept_store_read_line(c, def_pos, c->rept_spill.words,
            scratch, &next) != 0 ||
        parse_line_head(c, scratch, &parsed) == 0 || parsed.stmt == 0 ||
        !streqi(parsed.key, "MACRO"))
        return -1;
    p = skipws(parsed.rest);
    while (isname((unsigned char)*p))
        p++;
    p = skipws(p);
    n = 0U;
    while (*p != 0) {
        char *a;
        size_t len;

        if (*p == ',')
            p = skipws(p + 1);
        a = p;
        if (!isname0((unsigned char)*p))
            return -1;
        while (isname((unsigned char)*p))
            p++;
        len = char_distance(a, p);
        n++;
        if (macro_name_eq(a, len, name, namelen)) {
            *index = n;
            return 0;
        }
        p = skipws(p);
        if (*p != 0 && *p != ',')
            return -1;
    }
    return 1;
}

static int macro_append_text(char *out, size_t outsz, size_t *used,
                             const char *s, size_t n)
{
    if (*used + n >= outsz)
        return -1;
    if (n != 0U)
        memcpy(out + *used, s, n);
    *used += n;
    out[*used] = 0;
    return 0;
}

static int macro_append_arg(struct asmctx *c, unsigned int arg_pos,
                            unsigned int index, char *out, size_t outsz,
                            size_t *used, char *scratch)
{
    const char *a;
    size_t n;
    unsigned int count;
    unsigned int next;

    if (rept_store_read_line(c, arg_pos, c->rept_spill.words,
            scratch, &next) != 0 ||
        macro_arg_scan(scratch, index, &a, &n, &count) != 0 ||
        index == 0U || index > count)
        return -1;
    return macro_append_text(out, outsz, used, a, n);
}

static int iter_append_named(struct asmctx *c,
                             const struct das_iter_frame *frame,
                             const char *name, size_t namelen,
                             char *out, size_t outsz, size_t *used,
                             char *scratch)
{
    while (frame != 0) {
        unsigned int next;
        size_t n;

        if (rept_store_read_line(c, frame->name_pos, c->rept_spill.words,
                scratch, &next) != 0)
            return -1;
        n = strlen(scratch);
        if (macro_name_eq(scratch, n, name, namelen)) {
            if (rept_store_read_line(c, frame->value_pos,
                    c->rept_spill.words, scratch, &next) != 0)
                return -1;
            if (macro_append_text(out, outsz, used, scratch,
                    strlen(scratch)) != 0)
                return -1;
            return 1;
        }
        frame = frame->parent;
    }
    return 0;
}

static int iter_substitute_line(struct asmctx *c,
                                const struct das_iter_frame *frame,
                                const char *in, char *out, size_t outsz,
                                char *scratch)
{
    const char *p;
    size_t used;
    unsigned int quote;
    int escape;

    if (frame == 0) {
        strcopy(out, in, outsz);
        return strlen(in) < outsz ? 0 : -1;
    }
    p = in;
    used = 0U;
    out[0] = 0;
    quote = 0U;
    escape = 0;
    while (*p != 0) {
        if (quote == 0U && *p == ';')
            return macro_append_text(out, outsz, &used, p, strlen(p));
        if (*p == '\\' && isname0((unsigned char)p[1])) {
            const char *q;
            size_t n;
            int found;

            q = p + 1;
            while (isname((unsigned char)*q))
                q++;
            n = char_distance(p + 1, q);
            found = iter_append_named(c, frame, p + 1, n, out, outsz,
                &used, scratch);
            if (found < 0)
                return -1;
            if (found > 0) {
                p = q;
                continue;
            }
        }
        if (macro_append_text(out, outsz, &used, p, 1U) != 0)
            return -1;
        if (escape) {
            escape = 0;
        } else if (quote != 0U && (unsigned int)(unsigned char)*p == quote) {
            quote = 0U;
        } else if (quote != 0U && *p == '\\') {
            escape = 1;
        } else if (quote == 0U && (*p == '\'' || *p == '"')) {
            quote = (unsigned int)(unsigned char)*p;
        }
        p++;
    }
    return 0;
}

static int macro_substitute_line(struct asmctx *c, unsigned int def_pos,
                                 unsigned int arg_pos, unsigned int call_id,
                                 const char *in, char *out, size_t outsz,
                                 char *scratch,
                                 const struct das_iter_frame *iter_frame)
{
    const char *p;
    size_t used;
    unsigned int quote;
    int escape;

    p = in;
    used = 0U;
    out[0] = 0;
    quote = 0U;
    escape = 0;
    while (*p != 0) {
        if (quote == 0U && *p == ';')
            return macro_append_text(out, outsz, &used, p, strlen(p));
        if (*p == '\\') {
            const char *q;
            unsigned int index;

            q = p + 1;
            if (*q == 0) {
                fprintf(stderr, DAS_DIAG("das: bad macro escape\n",
                    "das: trailing backslash in macro body\n"));
                return -1;
            }
            if (*q == '\\') {
                if (macro_append_text(out, outsz, &used, "\\", 1U) != 0)
                    return -1;
                if (quote != 0U)
                    escape = 1;
                p += 2;
                continue;
            }
            if (*q == '(' && q[1] == ')') {
                p += 3;
                continue;
            }
            if (*q == '@') {
                char num[16];
                int nn;

                nn = (int)das_format_u10(num, call_id);
                if (macro_append_text(out, outsz, &used,
                        num, (size_t)nn) != 0)
                    return -1;
                p += 2;
                continue;
            }
            if (*q >= '1' && *q <= '9') {
                index = (unsigned int)(*q - '0');
                if (macro_append_arg(c, arg_pos, index, out, outsz,
                        &used, scratch) != 0) {
                    fprintf(stderr, DAS_DIAG("das: bad macro arg\n",
                        "das: invalid positional macro argument \\%u\n"),
                        index);
                    return -1;
                }
                p += 2;
                continue;
            }
            if (isname0((unsigned char)*q)) {
                const char *a;
                size_t n;
                int found;
                int iter_found;

                a = q;
                while (isname((unsigned char)*q))
                    q++;
                n = char_distance(a, q);
                found = macro_param_index(c, def_pos, a, n,
                    scratch, &index);
                if (found == 0) {
                    if (macro_append_arg(c, arg_pos, index, out, outsz,
                            &used, scratch) != 0)
                        return -1;
                    p = q;
                    continue;
                }
                iter_found = iter_append_named(c, iter_frame, a, n,
                    out, outsz, &used, scratch);
                if (iter_found > 0) {
                    p = q;
                    continue;
                }
                if (iter_found < 0) {
                    return -1;
                }
                {
                    fprintf(stderr, DAS_DIAG("das: unknown macro arg\n",
                        "das: unknown macro parameter in substitution: %.*s\n"),
                        (int)n, a);
                    return -1;
                }
            }
            fprintf(stderr, DAS_DIAG("das: bad macro escape\n",
                "das: malformed macro substitution escape\n"));
            return -1;
        }
        if (macro_append_text(out, outsz, &used, p, 1U) != 0)
            return -1;
        if (escape) {
            escape = 0;
        } else if (quote != 0U && (unsigned int)(unsigned char)*p == quote) {
            quote = 0U;
        } else if (quote == 0U && (*p == '\'' || *p == '"')) {
            quote = (unsigned int)(unsigned char)*p;
        }
        p++;
    }
    return 0;
}

static int macro_lookup(struct asmctx *c, const char *name,
                        unsigned int *def_pos)
{
    char key[DAS_MAX_NAME + 1];
    struct sym sym;

    if (macro_internal_key(name, key, sizeof(key)) != 0 ||
        !find_sym(c, key, &sym) || !symbol_visible_here(c, key))
        return 0;
    if ((sym.sec & DAS_SYM_KIND_MASK) != DAS_SYM_KIND_EQU)
        return 0;
    *def_pos = (unsigned int)(sym.off & DAS_WORD_MASK);
    return 1;
}

static int macro_frame_contains(const struct das_macro_frame *frame,
                                unsigned int def_pos)
{
    while (frame != 0) {
        if (frame->def_pos == def_pos)
            return 1;
        frame = frame->parent;
    }
    return 0;
}

static int rept_find_end(struct asmctx *c, unsigned int first,
                         unsigned int limit, unsigned int *end_line,
                         unsigned int *after_end)
{
    unsigned int pos;
    unsigned int depth;
#ifdef DAS_NATIVE
    char *tmp;
#else
    char tmp[DAS_MAX_LINE];
#endif

#ifdef DAS_NATIVE
    tmp = das_native_tmp;
#endif
    pos = first;
    depth = 0U;
    while (pos < limit) {
        unsigned int next;
        int kind;

        if (rept_store_read_line(c, pos, limit, tmp, &next) != 0)
            return -1;
        kind = rept_structure_kind(c, tmp);
        if (kind == 1)
            depth++;
        else if (kind == 2) {
            if (depth == 0U) {
                *end_line = pos;
                *after_end = next;
                return 0;
            }
            depth--;
        }
        pos = next;
    }
    return -1;
}

static int capture_rept_body(struct asmctx *c, struct das_char_reader *reader,
                             char *line, char *tmp, unsigned int active_depth,
                             unsigned int *first, unsigned int *after
                             )
{
    unsigned int nested;

    *first = c->rept_spill.words;
    nested = 0U;
    for (;;) {
        int lr;
        int kind;

        lr = das_read_line(reader, line, DAS_MAX_LINE);
        if (lr == DAS_INPUT_EOF) {
            fprintf(stderr, DAS_DIAG("das: unterminated rept\n",
                "das: unterminated .rept directive\n"));
            return -1;
        }
        if (lr == DAS_INPUT_TOOLONG) {
            fprintf(stderr, DAS_DIAG("das: long line\n",
                "das: source line too long in .rept body\n"));
            return -1;
        }
        if (lr == DAS_INPUT_ERROR) {
            fprintf(stderr, DAS_DIAG("das: bad input\n",
                "das: malformed input in .rept body\n"));
            return -1;
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        kind = rept_structure_kind(c, tmp);
        if (kind == 2) {
            if (nested == 0U)
                break;
            nested--;
        } else if (kind == 1) {
            if (active_depth + nested >= DAS_MAX_REPT_DEPTH) {
                fprintf(stderr, DAS_DIAG("das: rept deep\n",
                    "das: repetition nesting too deep\n"));
                return -1;
            }
            nested++;
        }
        if (rept_store_append_line(c, line) != 0) {
            fprintf(stderr, DAS_DIAG("das: rept scratch\n",
                "das: cannot retain bounded .rept body\n"));
            return -1;
        }
    }
    *after = c->rept_spill.words;
    return 0;
}

static int capture_macro_body(struct asmctx *c,
                              struct das_char_reader *reader,
                              const char *definition, char *line, char *tmp,
                              unsigned int *def_pos
                              )
{
    char name[DAS_MAX_NAME + 1];
    char key[DAS_MAX_NAME + 1];
    struct sym old;
    unsigned int argc;

    strcopy(tmp, definition, DAS_MAX_LINE);
    if (macro_parse_definition(c, tmp, name, sizeof(name), &argc) <= 0)
        return -1;
    if (macro_internal_key(name, key, sizeof(key)) != 0 || find_sym(c, key, &old)) {
        fprintf(stderr, DAS_DIAG("das: duplicate macro\n",
            "das: duplicate macro definition: %s\n"), name);
        return -1;
    }
    *def_pos = c->rept_spill.words;
    if (rept_store_append_line(c, definition) != 0) {
        fprintf(stderr, DAS_DIAG("das: macro scratch\n",
            "das: cannot retain bounded macro definition\n"));
        return -1;
    }
    for (;;) {
        int lr;
        int kind;

        lr = das_read_line(reader, line, DAS_MAX_LINE);
        if (lr == DAS_INPUT_EOF) {
            fprintf(stderr, DAS_DIAG("das: unterminated macro\n",
                "das: unterminated .macro directive\n"));
            return -1;
        }
        if (lr == DAS_INPUT_TOOLONG) {
            fprintf(stderr, DAS_DIAG("das: long line\n",
                "das: source line too long in .macro body\n"));
            return -1;
        }
        if (lr == DAS_INPUT_ERROR) {
            fprintf(stderr, DAS_DIAG("das: bad input\n",
                "das: malformed input in .macro body\n"));
            return -1;
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        kind = macro_structure_kind(c, tmp);
        if (kind == 1) {
            fprintf(stderr, DAS_DIAG("das: nested macro def\n",
                "das: nested .macro definitions are not supported\n"));
            return -1;
        }
        if (kind == 2) {
            strcopy(tmp, line, DAS_MAX_LINE);
            if (macro_validate_endm(c, tmp) <= 0)
                return -1;
        }
        if (rept_store_append_line(c, line) != 0) {
            fprintf(stderr, DAS_DIAG("das: macro scratch\n",
                "das: cannot retain bounded macro body\n"));
            return -1;
        }
        if (kind == 2)
            break;
    }
    add_sym(c, key, DAS_SEC_ABS | DAS_SYM_KIND_EQU, (das_word_t)*def_pos);
    mark_symbol_visible(c, key);
    return 0;
}

static int discard_macro_body(struct asmctx *c,
                              struct das_char_reader *reader,
                              char *line, char *tmp
                              )
{
    for (;;) {
        int lr;
        int kind;

        lr = das_read_line(reader, line, DAS_MAX_LINE);
        if (lr == DAS_INPUT_EOF) {
            fprintf(stderr, DAS_DIAG("das: unterminated macro\n",
                "das: unterminated .macro directive\n"));
            return -1;
        }
        if (lr == DAS_INPUT_TOOLONG || lr == DAS_INPUT_ERROR) {
            fprintf(stderr, DAS_DIAG("das: bad macro input\n",
                "das: malformed input in .macro body\n"));
            return -1;
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        kind = macro_structure_kind(c, tmp);
        if (kind == 1) {
            fprintf(stderr, DAS_DIAG("das: nested macro def\n",
                "das: nested .macro definitions are not supported\n"));
            return -1;
        }
        if (kind == 2)
            return macro_validate_endm(c, tmp) > 0 ? 0 : -1;
    }
}

static int macro_definition_end(struct asmctx *c, unsigned int def_pos,
                                unsigned int *first, unsigned int *after)
{
    unsigned int pos;
    unsigned int next;
#ifdef DAS_NATIVE
    char *tmp;
#else
    char tmp_store[DAS_MAX_LINE];
    char *tmp;
#endif

#ifdef DAS_NATIVE
    tmp = das_native_tmp;
#else
    tmp = tmp_store;
#endif
    if (rept_store_read_line(c, def_pos, c->rept_spill.words,
            tmp, &next) != 0)
        return -1;
    *first = next;
    pos = next;
    while (pos < c->rept_spill.words) {
        int kind;

        if (rept_store_read_line(c, pos, c->rept_spill.words,
                tmp, &next) != 0)
            return -1;
        kind = macro_structure_kind(c, tmp);
        if (kind == 1)
            return -1;
        if (kind == 2) {
            *after = pos;
            return 0;
        }
        pos = next;
    }
    return -1;
}

static int macro_prepare_invocation(struct asmctx *c, char *line,
                                    char *scratch, char *label,
                                    size_t labelsz, unsigned int *def_pos,
                                    unsigned int *arg_pos,
                                    unsigned int *call_id)
{
    struct das_parsed_line parsed;
    unsigned int expected;
    unsigned int count;
    unsigned int next;
    size_t n;
    int found;

    label[0] = 0;
    if (macro_scan_head(line, &parsed) == 0 || parsed.stmt == 0)
        return 0;
    /* Macro names cannot shadow dotted directives or real opcodes. */
    if (parsed.stmt[0] == '.' ||
        lookup_op_mn(sixbit_mn(parsed.key), 0) >= 0)
        return 0;
    found = macro_lookup(c, parsed.key, def_pos);
    if (!found)
        return 0;
    if (rept_store_read_line(c, *def_pos, c->rept_spill.words,
            scratch, &next) != 0 ||
        macro_parse_definition(c, scratch, label, labelsz,
            &expected) <= 0)
        return -1;
    if (macro_arg_scan(parsed.rest, 0U, 0, 0, &count) != 0) {
        fprintf(stderr, DAS_DIAG("das: bad macro invocation\n",
            "das: malformed macro invocation arguments: %s\n"), parsed.stmt);
        return -1;
    }
    if (count != expected) {
        fprintf(stderr, DAS_DIAG("das: macro arg count\n",
            "das: macro %s expects %u arguments, got %u\n"),
            label, expected, count);
        return -1;
    }
    /* The definition-name scratch is not an invocation label. */
    label[0] = 0;
    *arg_pos = c->rept_spill.words;
    if (rept_store_append_line(c, parsed.rest) != 0) {
        fprintf(stderr, DAS_DIAG("das: macro scratch\n",
            "das: cannot retain macro invocation arguments\n"));
        return -1;
    }
    *call_id = c->source_serial;
    if (parsed.label != 0) {
        n = parsed.label_len;
        if (n + 2U > labelsz)
            return -1;
        memcpy(label, parsed.label, n);
        label[n] = ':';
        label[n + 1U] = 0;
    }
    return 1;
}

static int macro_materialize(struct asmctx *c, unsigned int def_pos,
                             unsigned int arg_pos, unsigned int call_id,
                             unsigned int first, unsigned int after,
                             unsigned int *expanded_first,
                             unsigned int *expanded_after,
                             const struct das_iter_frame *iter_frame)
{
    unsigned int pos;
#ifdef DAS_NATIVE
    char *raw;
    char *line;
    char *scratch;
#else
    char raw_store[DAS_MAX_LINE];
    char line_store[DAS_MAX_LINE];
    char scratch_store[DAS_MAX_LINE];
    char *raw;
    char *line;
    char *scratch;
#endif

#ifdef DAS_NATIVE
    raw = das_native_line;
    line = das_native_tmp;
    scratch = das_native_inc;
#else
    raw = raw_store;
    line = line_store;
    scratch = scratch_store;
#endif
    *expanded_first = c->rept_spill.words;
    pos = first;
    while (pos < after) {
        unsigned int next;

        if (rept_store_read_line(c, pos, after, raw, &next) != 0)
            return -1;
        pos = next;
        if (macro_substitute_line(c, def_pos, arg_pos, call_id, raw, line,
                DAS_MAX_LINE, scratch, iter_frame) != 0) {
            fprintf(stderr, DAS_DIAG("das: macro expansion\n",
                "das: macro expansion line is malformed or too long\n"));
            return -1;
        }
        if (rept_store_append_line(c, line) != 0) {
            fprintf(stderr, DAS_DIAG("das: macro scratch\n",
                "das: cannot retain bounded macro expansion\n"));
            return -1;
        }
    }
    *expanded_after = c->rept_spill.words;
    return 0;
}

static int pass1_file(struct asmctx *c, const char *infile, int *sec,
                      int depth, int input_format,
                      struct das_cond_state *cond, unsigned int rept_depth,
                      const struct das_macro_frame *macro_frame,
                      unsigned int macro_depth,
                      const struct das_iter_frame *iter_frame);
static int pass1_rept_body(struct asmctx *c, const char *source_path,
                           unsigned int first, unsigned int after, int *sec,
                           int include_depth, int input_format,
                           struct das_cond_state *cond,
                           unsigned int rept_depth,
                           const struct das_macro_frame *macro_frame,
                           unsigned int macro_depth,
                           const struct das_iter_frame *iter_frame);

static int pass1_iter_body(struct asmctx *c, const char *source_path,
                           int kind, unsigned int name_pos,
                           unsigned int values_pos, unsigned int first,
                           unsigned int after, int *sec, int include_depth,
                           int input_format, struct das_cond_state *cond,
                           unsigned int rept_depth,
                           const struct das_macro_frame *macro_frame,
                           unsigned int macro_depth,
                           const struct das_iter_frame *parent_iter)
{
    struct das_iter_frame frame;
    unsigned int cursor;
    unsigned int started;
    unsigned int quote;

    cursor = 0U;
    started = 0U;
    quote = 0U;
    for (;;) {
        unsigned int value_pos;
        int rc;

        if (kind == DAS_REPT_IRP)
            rc = iter_irp_next(c, values_pos, &cursor, &started,
                &value_pos);
        else
            rc = iter_irpc_next(c, values_pos, &cursor, &started, &quote,
                &value_pos);
        if (rc < 0) {
            fprintf(stderr, DAS_DIAG("das: bad iter\n",
                "das: malformed .%s value list\n"),
                kind == DAS_REPT_IRP ? "irp" : "irpc");
            return 1;
        }
        if (rc == 0)
            break;
        frame.name_pos = name_pos;
        frame.value_pos = value_pos;
        frame.parent = parent_iter;
        if (pass1_rept_body(c, source_path, first, after, sec,
                include_depth, input_format, cond, rept_depth,
                macro_frame, macro_depth, &frame))
            return 1;
    }
    return 0;
}

static int source_advance(struct asmctx *c)
{
    if (c->source_serial >= DAS_HALF_MASK) {
        fprintf(stderr, DAS_DIAG("das: source too large\n",
            "das: too many expanded source lines\n"));
        return 1;
    }
    c->source_serial++;
    return 0;
}

static int pass1_ir_line(struct asmctx *c, char *line, int *sec)
{
    if (ir_store_append_line(c, line) != 0) {
        fprintf(stderr, DAS_DIAG("das: ir scratch\n",
            "das: cannot retain expanded phase stream\n"));
        return 1;
    }
    return pass1_line(c, line, sec);
}

static int pass1_ir_reset(struct asmctx *c)
{
#if DAS_ENABLE_OPTIMIZER
    opt_reset(c);
    if (ir_store_control(c, DAS_IR_RESET) != 0) {
        fprintf(stderr, DAS_DIAG("das: ir scratch\n",
            "das: cannot retain optimizer phase barrier\n"));
        return 1;
    }
#else
    (void)c;
#endif
    return 0;
}

static int pass1_ir_guard(struct asmctx *c)
{
#if DAS_ENABLE_OPTIMIZER
    c->opt_skip_next |= DAS_OPT_GUARD_NEXT;
    if (ir_store_control(c, DAS_IR_GUARD) != 0) {
        fprintf(stderr, DAS_DIAG("das: ir scratch\n",
            "das: cannot retain labeled-entry phase barrier\n"));
        return 1;
    }
#else
    (void)c;
#endif
    return 0;
}

static int pass1_macro_invoke(struct asmctx *c, const char *source_path,
                              const char *label, unsigned int def_pos,
                              unsigned int arg_pos, unsigned int call_id,
                              int *sec, int include_depth, int input_format,
                              struct das_cond_state *cond,
                              unsigned int rept_depth,
                              const struct das_macro_frame *macro_frame,
                              unsigned int macro_depth,
                              const struct das_iter_frame *iter_frame)
{
    struct das_macro_frame frame;
    unsigned int first;
    unsigned int after;
    unsigned int expanded_first;
    unsigned int expanded_after;

    if (macro_depth >= DAS_MAX_MACRO_DEPTH) {
        fprintf(stderr, DAS_DIAG("das: macro deep\n",
            "das: macro invocation nesting too deep\n"));
        return 1;
    }
    if (macro_frame_contains(macro_frame, def_pos)) {
        fprintf(stderr, DAS_DIAG("das: macro recursion\n",
            "das: recursive macro invocation is not allowed\n"));
        return 1;
    }
    if (macro_definition_end(c, def_pos, &first, &after) != 0 ||
        macro_materialize(c, def_pos, arg_pos, call_id, first, after,
            &expanded_first, &expanded_after, iter_frame) != 0) {
        fprintf(stderr, DAS_DIAG("das: macro scratch\n",
            "das: malformed retained macro definition\n"));
        return 1;
    }
    if (label[0] != 0) {
        char label_line[DAS_MAX_NAME + 2U];

        strcopy(label_line, label, sizeof(label_line));
        if (pass1_ir_line(c, label_line, sec))
            return 1;
        /*
         * The invocation label names the first emitted expansion word.  The
         * expanded source line itself carries no label, so keep a conservative
         * one-word optimizer barrier to preserve labeled/XCT entry semantics.
         */
        if (pass1_ir_guard(c))
            return 1;
    }
    frame.def_pos = def_pos;
    frame.parent = macro_frame;
    return pass1_rept_body(c, source_path, expanded_first, expanded_after,
        sec, include_depth, input_format, cond, rept_depth, &frame,
        macro_depth + 1U, iter_frame);
}

static int pass1_rept_body(struct asmctx *c, const char *source_path,
                           unsigned int first, unsigned int after, int *sec,
                           int include_depth, int input_format,
                           struct das_cond_state *cond,
                           unsigned int rept_depth,
                           const struct das_macro_frame *macro_frame,
                           unsigned int macro_depth,
                           const struct das_iter_frame *iter_frame)
{
    unsigned int pos;
    unsigned int cond_start_depth;
#ifdef DAS_NATIVE
    char *line;
    char *tmp;
    char *inc;
    char *dir;
    char *path;
    size_t dir_cap;
    size_t path_cap;
#else
    char line[DAS_MAX_LINE];
    char tmp[DAS_MAX_LINE];
    char inc[DAS_MAX_LINE];
    char dir[DAS_MAX_LINE];
    char path[DAS_MAX_LINE * 2U];
#endif

#ifdef DAS_NATIVE
    line = das_native_line;
    tmp = das_native_tmp;
    inc = das_native_inc;
    dir = das_native_dir;
    path = das_native_file_paths[(unsigned int)include_depth];
    dir_cap = sizeof(das_native_dir);
    path_cap = sizeof(das_native_file_paths[0]);
#endif
    pos = first;
    cond_start_depth = cond->depth;
    while (pos < after) {
        unsigned int next;
        int handled;
        unsigned int dot;
        unsigned int count;
        int kind;
        int ir;

        if (rept_store_read_line(c, pos, after, line, &next) != 0)
            return 1;
        pos = next;
        if (source_advance(c))
            return 1;
        if (iter_frame != 0) {
            if (iter_substitute_line(c, iter_frame, line, tmp,
                    DAS_MAX_LINE, inc) != 0) {
                fprintf(stderr, DAS_DIAG("das: iter expansion\n",
                    "das: iterator expansion line is malformed or too long\n"));
                return 1;
            }
            strcopy(line, tmp, DAS_MAX_LINE);
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        dot = sec_base(c, *sec) + c->loc[*sec];
        if (conditional_line(c, tmp, cond, dot, &handled))
            return 1;
        if (handled) {
            if (pass1_ir_reset(c))
                return 1;
            continue;
        }
        if (!cond_active(cond)) {
            strcopy(tmp, line, DAS_MAX_LINE);
            if (macro_structure_kind(c, tmp) != 0) {
                fprintf(stderr, DAS_DIAG("das: macro in rept\n",
                    "das: .macro/.endm directives are not allowed inside .rept bodies\n"));
                return 1;
            }
            if (pass1_ir_reset(c))
                return 1;
            continue;
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        kind = macro_structure_kind(c, tmp);
        if (kind != 0) {
            fprintf(stderr, DAS_DIAG("das: macro in rept\n",
                "das: .macro/.endm directives are not allowed inside .rept bodies\n"));
            return 1;
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        if (rept_count_line(c, tmp, dot, &count, &kind))
            return 1;
        if (kind == DAS_REPT_END) {
            fprintf(stderr, DAS_DIAG("das: unmatched endr\n",
                "das: unmatched .endr directive\n"));
            return 1;
        }
        if (kind == DAS_REPT_BLOCK || kind == DAS_REPT_IRP ||
            kind == DAS_REPT_IRPC) {
            unsigned int end_line;
            unsigned int after_end;
            unsigned int name_pos;
            unsigned int values_pos;

            if (rept_depth >= DAS_MAX_REPT_DEPTH) {
                fprintf(stderr, DAS_DIAG("das: rept deep\n",
                    "das: repetition nesting too deep\n"));
                return 1;
            }
            if (rept_find_end(c, pos, after, &end_line, &after_end) != 0) {
                fprintf(stderr, DAS_DIAG("das: unterminated rept\n",
                    "das: unterminated nested repetition directive\n"));
                return 1;
            }
            if (kind == DAS_REPT_BLOCK) {
                unsigned int i;

                for (i = 0U; i < count; i++) {
                    if (pass1_rept_body(c, source_path, pos, end_line, sec,
                            include_depth, input_format, cond,
                            rept_depth + 1U, macro_frame, macro_depth,
                            iter_frame))
                        return 1;
                }
            } else {
                strcopy(tmp, line, DAS_MAX_LINE);
                if (iter_store_spec(c, tmp, &name_pos, &values_pos) != 0 ||
                    pass1_iter_body(c, source_path, kind, name_pos,
                        values_pos, pos, end_line, sec, include_depth,
                        input_format, cond, rept_depth + 1U, macro_frame,
                        macro_depth, iter_frame))
                    return 1;
            }
            pos = after_end;
            if (pass1_ir_reset(c))
                return 1;
            continue;
        }
        {
            unsigned int nested_def;
            unsigned int nested_args;
            unsigned int nested_call;
            char label[DAS_MAX_NAME + 2U];
            int mr;

            strcopy(tmp, line, DAS_MAX_LINE);
            mr = macro_prepare_invocation(c, tmp, inc, label, sizeof(label),
                &nested_def, &nested_args, &nested_call);
            if (mr < 0)
                return 1;
            if (mr > 0) {
                if (pass1_macro_invoke(c, source_path, label, nested_def,
                        nested_args, nested_call, sec, include_depth,
                        input_format, cond, rept_depth, macro_frame,
                        macro_depth, iter_frame))
                    return 1;
                continue;
            }
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        ir = parse_include_line(tmp, inc, DAS_MAX_LINE);
        if (ir < 0) {
            fprintf(stderr, DAS_DIAG("das: bad include\n",
                "das: bad include directive in repeated body\n"));
            return 1;
        }
        if (ir > 0) {
            if (pass1_ir_reset(c))
                return 1;
#ifdef DAS_NATIVE
            dirname_of(source_path, dir, dir_cap);
            join_path(dir, inc, path, path_cap);
#else
            dirname_of(source_path, dir, sizeof(dir));
            join_path(dir, inc, path, sizeof(path));
#endif
            if (pass1_file(c, path, sec, include_depth + 1,
                    input_format, cond, rept_depth, macro_frame, macro_depth,
                    iter_frame))
                return 1;
        } else if (pass1_ir_line(c, line, sec)) {
            return 1;
        }
    }
    if (cond->depth != cond_start_depth) {
        fprintf(stderr, DAS_DIAG("das: rept conditional\n",
            "das: conditional cannot cross a .rept boundary\n"));
        return 1;
    }
    return 0;
}

static int pass1_file(struct asmctx *c, const char *infile, int *sec,
                      int depth, int input_format,
                      struct das_cond_state *cond, unsigned int rept_depth,
                      const struct das_macro_frame *macro_frame,
                      unsigned int macro_depth,
                      const struct das_iter_frame *iter_frame)
{
    FILE *f;
#ifndef DAS_NATIVE
    struct host_char_input chars;
#endif
    struct host_word_input words;
    struct das_s6reader s6;
    struct das_char_reader reader;
    char *line;
    char *inc;
    char *dir;
    char *path;
    char *tmp;
    size_t dir_cap;
    size_t path_cap;
#ifndef DAS_NATIVE
    char line_store[DAS_MAX_LINE];
    char inc_store[DAS_MAX_LINE];
    char dir_store[DAS_MAX_LINE];
    char path_store[DAS_MAX_LINE * 2U];
    char tmp_store[DAS_MAX_LINE];
    char char_store[DAS_CHAR_INPUT_BUFFER];
    das_word_t word_store[DAS_WORD_INPUT_BUFFER];
#else
    das_word_t word_store[DAS_WORD_INPUT_BUFFER];
#endif
    int lr;
    unsigned int cond_start_depth;
    cond_start_depth = cond->depth;
#if DAS_ENABLE_OPTIMIZER
    if (depth == 0) {
        c->opt_skip_next = 0U;
        c->opt_current_may_be_skipped = 0U;
    }
#endif
    if (depth > (int)DAS_MAX_INCLUDE_DEPTH) {
        fprintf(stderr, DAS_DIAG("das: include deep\n", "das: include nesting too deep\n"));
        return 1;
    }
#ifdef DAS_NATIVE
    line = das_native_line;
    inc = das_native_inc;
    dir = das_native_dir;
    path = das_native_file_paths[(unsigned int)depth];
    tmp = das_native_tmp;
    words.buffer = word_store;
    dir_cap = sizeof(das_native_dir);
    path_cap = sizeof(das_native_file_paths[0]);
#else
    line = line_store;
    inc = inc_store;
    dir = dir_store;
    path = path_store;
    tmp = tmp_store;
    chars.buffer = char_store;
    words.buffer = word_store;
    dir_cap = sizeof(dir_store);
    path_cap = sizeof(path_store);
#endif
    f = fopen(infile, "rb");
    if (!f) {
        perror(infile);
        return 1;
    }
#ifndef DAS_NATIVE
    chars.file = f;
    chars.pos = 0U;
    chars.count = 0U;
#endif
    words.file = f;
    words.pos = 0U;
    words.count = 0U;
#ifdef DAS_NATIVE
    (void)input_format;
    das_s6_init(&s6, host_word_get, &words);
    reader.get = das_s6_get;
    reader.arg = &s6;
#else
    if (input_format == DAS_INPUT_S6REC) {
        das_s6_init(&s6, host_word_get, &words);
        reader.get = das_s6_get;
        reader.arg = &s6;
    } else {
        reader.get = host_char_get;
        reader.arg = &chars;
    }
#endif
    reader.cstate = 0U;
    for (;;) {
        int ir;

        lr = das_read_line(&reader, line, DAS_MAX_LINE);
        if (lr == DAS_INPUT_EOF)
            break;
        if (lr == DAS_INPUT_TOOLONG) {
            fprintf(stderr, DAS_DIAG("das: long line: %s\n", "das: source line too long in %s\n"), infile);
            fclose(f);
            return 1;
        }
        if (lr == DAS_INPUT_ERROR) {
            fprintf(stderr, DAS_DIAG("das: bad input: %s\n", "das: malformed input in %s\n"), infile);
            fclose(f);
            return 1;
        }
        if (source_advance(c)) {
            fclose(f);
            return 1;
        }
        if (iter_frame != 0) {
            if (iter_substitute_line(c, iter_frame, line, tmp,
                    DAS_MAX_LINE, inc) != 0) {
                fprintf(stderr, DAS_DIAG("das: iter expansion\n",
                    "das: iterator expansion line is malformed or too long in %s\n"),
                    infile);
                fclose(f);
                return 1;
            }
            strcopy(line, tmp, DAS_MAX_LINE);
        }
        {
            int handled;
            unsigned int dot;

            strcopy(tmp, line, DAS_MAX_LINE);
            dot = sec_base(c, *sec) + c->loc[*sec];
            if (conditional_line(c, tmp, cond, dot, &handled)) {
                fclose(f);
                return 1;
            }
            if (handled) {
                if (pass1_ir_reset(c)) {
                    fclose(f);
                    return 1;
                }
                continue;
            }
            if (!cond_active(cond)) {
                int mkind;

                strcopy(tmp, line, DAS_MAX_LINE);
                mkind = macro_structure_kind(c, tmp);
                if (mkind == 1 && discard_macro_body(c, &reader, line, tmp
                        ) != 0) {
                    fclose(f);
                    return 1;
                }
                if (pass1_ir_reset(c)) {
                    fclose(f);
                    return 1;
                }
                continue;
            }
        }
        {
            int mkind;

            strcopy(tmp, line, DAS_MAX_LINE);
            mkind = macro_structure_kind(c, tmp);
            if (mkind == 2) {
                fprintf(stderr, DAS_DIAG("das: unmatched endm\n",
                    "das: unmatched .endm directive in %s\n"), infile);
                fclose(f);
                return 1;
            }
            if (mkind == 1) {
                unsigned int macro_pos;

                if (macro_depth != 0U) {
                    fprintf(stderr, DAS_DIAG("das: nested macro def\n",
                        "das: macro definitions during macro expansion are not supported\n"));
                    fclose(f);
                    return 1;
                }
                if (capture_macro_body(c, &reader, line, line, tmp, &macro_pos
                        ) != 0) {
                    fclose(f);
                    return 1;
                }
                if (pass1_ir_reset(c)) {
                    fclose(f);
                    return 1;
                }
                continue;
            }
        }
        {
            unsigned int count;
            unsigned int dot;
            int kind;

            dot = sec_base(c, *sec) + c->loc[*sec];
            strcopy(tmp, line, DAS_MAX_LINE);
            if (rept_count_line(c, tmp, dot, &count, &kind)) {
                fclose(f);
                return 1;
            }
            if (kind == DAS_REPT_END) {
                fprintf(stderr, DAS_DIAG("das: unmatched endr\n",
                    "das: unmatched .endr directive in %s\n"), infile);
                fclose(f);
                return 1;
            }
            if (kind == DAS_REPT_BLOCK || kind == DAS_REPT_IRP ||
                kind == DAS_REPT_IRPC) {
                unsigned int body_first;
                unsigned int body_after;
                unsigned int name_pos;
                unsigned int values_pos;

                if (rept_depth >= DAS_MAX_REPT_DEPTH) {
                    fprintf(stderr, DAS_DIAG("das: rept deep\n",
                        "das: repetition nesting too deep in %s\n"), infile);
                    fclose(f);
                    return 1;
                }
                name_pos = 0U;
                values_pos = 0U;
                if (kind != DAS_REPT_BLOCK) {
                    strcopy(tmp, line, DAS_MAX_LINE);
                    if (iter_store_spec(c, tmp, &name_pos, &values_pos) != 0) {
                        fprintf(stderr, DAS_DIAG("das: iter scratch\n",
                            "das: cannot retain iterator specification in %s\n"),
                            infile);
                        fclose(f);
                        return 1;
                    }
                }
                if (capture_rept_body(c, &reader, line, tmp,
                        rept_depth + 1U, &body_first, &body_after
                        ) != 0) {
                    fclose(f);
                    return 1;
                }
                if (pass1_ir_reset(c)) {
                    fclose(f);
                    return 1;
                }
                if (kind == DAS_REPT_BLOCK) {
                    unsigned int i;

                    for (i = 0U; i < count; i++) {
                        if (pass1_rept_body(c, infile, body_first, body_after,
                                sec, depth, input_format, cond,
                                rept_depth + 1U, macro_frame, macro_depth,
                                iter_frame)) {
                            fclose(f);
                            return 1;
                        }
                    }
                } else {
                    if (pass1_iter_body(c, infile, kind, name_pos, values_pos,
                            body_first, body_after, sec, depth, input_format,
                            cond, rept_depth + 1U, macro_frame, macro_depth,
                            iter_frame)) {
                        fclose(f);
                        return 1;
                    }
                }
                continue;
            }
        }
        {
            unsigned int nested_def;
            unsigned int nested_args;
            unsigned int nested_call;
            char label[DAS_MAX_NAME + 2U];
            int mr;

            strcopy(tmp, line, DAS_MAX_LINE);
            mr = macro_prepare_invocation(c, tmp, inc, label, sizeof(label),
                &nested_def, &nested_args, &nested_call);
            if (mr < 0) {
                fclose(f);
                return 1;
            }
            if (mr > 0) {
                if (pass1_macro_invoke(c, infile, label, nested_def,
                        nested_args, nested_call, sec, depth, input_format,
                        cond, rept_depth, macro_frame, macro_depth,
                        iter_frame)) {
                    fclose(f);
                    return 1;
                }
                continue;
            }
        }
        strcopy(tmp, line, DAS_MAX_LINE);
        ir = parse_include_line(tmp, inc, DAS_MAX_LINE);
        if (ir < 0) {
            fprintf(stderr, DAS_DIAG("das: bad include: %s\n", "das: bad include directive in %s\n"), infile);
            fclose(f);
            return 1;
        }
        if (ir > 0) {
            if (pass1_ir_reset(c)) {
                fclose(f);
                return 1;
            }
            dirname_of(infile, dir, dir_cap);
            join_path(dir, inc, path, path_cap);
            if (pass1_file(c, path, sec, depth + 1, input_format, cond,
                    rept_depth, macro_frame, macro_depth, iter_frame)) {
                fclose(f);
                return 1;
            }
        } else {
            if (pass1_ir_line(c, line, sec)) {
                fclose(f);
                return 1;
            }
        }
    }
    if ((reader.cstate & DAS_CSTATE_COMMENT) != 0U) {
        fprintf(stderr, DAS_DIAG("das: bad comment\n",
            "das: unterminated /* comment in %s\n"), infile);
        fclose(f);
        return 1;
    }
    if (cond->depth != cond_start_depth) {
        fprintf(stderr, DAS_DIAG("das: unterminated if\n",
            "das: unterminated conditional in %s\n"), infile);
        fclose(f);
        return 1;
    }
    fclose(f);
    return 0;
}
#endif

#if !defined(DAS_NATIVE_PHASE1_ONLY)
#if DAS_ENABLE_OPTIMIZER
static int opt_store_forward_emitted(struct asmctx *c,
                                     struct das_parsed_line *parsed,
                                     struct das_output *out,
                                     unsigned int off)
{
    das_word_t word;
    unsigned int dst;
    int reloc;

    if (!das_optimize || !c->opt_prev_store || c->opt_prev_mem != 1U ||
        parsed->label != 0 || parsed->token != DAS_TOK_OTHER ||
        parsed->mnemonic != DAS_OP4('M','O','V','E'))
        return 0;
    if (output_read_word(out, off, &word) != 0)
        return 0;
    reloc = output_reloc_present(out, off);
    if ((word & DAS_W(037777777)) != c->opt_prev_store_ea ||
        reloc != c->opt_prev_store_reloc || off == 0U ||
        !output_reloc_same(out, off - 1U, off))
        return 0;
    dst = (unsigned int)((word >> 23) & DAS_W(017));
    word = das_enc_mem(0200U, dst, 0, 0, c->opt_prev_store_ac);
    if (output_replace_word_reloc(out, off, word, 0) != 0)
        return -1;
    return 1;
}

static void opt_record_store_word(struct asmctx *c,
                                  struct das_parsed_line *parsed,
                                  struct das_output *out,
                                  unsigned int off)
{
    das_word_t word;

    c->opt_prev_store = 0U;
    if (!das_optimize || c->opt_prev_mem != 2U || parsed->label != 0 ||
        parsed->token != DAS_TOK_OTHER || parsed->mnemonic != DAS_OP5('M','O','V','E','M'))
        return;
    if (output_read_word(out, off, &word) != 0)
        return;
    c->opt_prev_store = 1U;
    c->opt_prev_store_ac = (unsigned int)((word >> 23) & DAS_W(017));
    c->opt_prev_store_ea = word & DAS_W(037777777);
    c->opt_prev_store_reloc = output_reloc_present(out, off);
}

static int pass2_emit_pending_jump_jrst(struct asmctx *c, int *sec,
                                        unsigned int loc[4],
                                        struct das_output *out)
{
    const char *target2;
    unsigned int y;
    unsigned int dot;
    int ind;
    int xr;
    int reloc;
    das_word_t word;

    if (!das_optimize || c->opt_prev_mem != DAS_OPT_MEM_JUMP_JRST)
        return 0;
    target2 = c->opt_prev_mem_ea + DAS_OPT_BRANCH_TARGET2;
    dot = sec_base(c, *sec) + loc[*sec];
    if (parse_ea(c, (char *)target2, dot, &y, &ind, &xr, &reloc) != 0)
        return -1;
    word = das_enc_mem(0254U, 0U, ind, xr, y);
    if (output_emit(out, dot, word, reloc) != 0)
        return -1;
    loc[*sec]++;
    opt_reset(c);
    return 0;
}

static int pass2_fold_jump_jrst(struct asmctx *c, int *sec,
                                unsigned int loc[4],
                                struct das_output *out)
{
    const char *target2;
    unsigned int packed;
    unsigned int opcode;
    unsigned int ac;
    unsigned int y;
    unsigned int dot;
    int ind;
    int xr;
    int reloc;
    das_word_t word;

    if (!das_optimize || c->opt_prev_mem != DAS_OPT_MEM_JUMP_JRST ||
        loc[*sec] == 0U)
        return -1;
    target2 = c->opt_prev_mem_ea + DAS_OPT_BRANCH_TARGET2;
    packed = c->opt_prev_mem_ac;
    opcode = (packed >> 4) & 0777U;
    ac = packed & 017U;
    if (opcode < 0321U || opcode > 0327U || opcode == 0324U)
        return -1;
    dot = sec_base(c, *sec) + loc[*sec] - 1U;
    if (parse_ea(c, (char *)target2, dot, &y, &ind, &xr, &reloc) != 0)
        return -1;
    if (ind != 0 || xr != 0)
        return -1;
    word = das_enc_mem(opcode ^ 04U, ac, 0, 0, y);
    if (output_replace_word_reloc(out, dot, word, reloc) != 0)
        return -1;
    opt_reset(c);
    return 0;
}

static int pass2_emit_pending_jrst(struct asmctx *c, int *sec,
                                   unsigned int loc[4],
                                   struct das_output *out)
{
    unsigned int y;
    unsigned int dot;
    int ind;
    int xr;
    int reloc;
    das_word_t word;

    if (!das_optimize || c->opt_prev_mem != DAS_OPT_MEM_JRST_TARGET)
        return 0;
    dot = sec_base(c, *sec) + loc[*sec];
    if (parse_ea(c, c->opt_prev_mem_ea, dot, &y, &ind, &xr, &reloc) != 0)
        return -1;
    word = das_enc_mem(0254U, 0U, ind, xr, y);
    if (output_emit(out, dot, word, reloc) != 0)
        return -1;
    loc[*sec]++;
    opt_reset(c);
    return 0;
}
#else
#define pass2_emit_pending_jump_jrst(c, sec, loc, out) (0)
#define pass2_emit_pending_jrst(c, sec, loc, out) (0)
#endif

static int pass2_line(struct asmctx *c, char *line, int *sec,
                      unsigned int loc[4], struct das_output *out)
{
    struct das_parsed_line parsed;
    int nwords;
    unsigned int off;

    if (parse_line_head(c, line, &parsed) == 0)
        return 0;
#if DAS_ENABLE_OPTIMIZER
    if (opt_jump_jrst_next_label(c, &parsed)) {
        if (pass2_fold_jump_jrst(c, sec, loc, out) != 0)
            return 1;
    } else if (das_optimize &&
               c->opt_prev_mem == DAS_OPT_MEM_JUMP_JRST) {
        if (pass2_emit_pending_jump_jrst(c, sec, loc, out) != 0)
            return 1;
    }
    if (opt_jrst_next_label(c, &parsed)) {
        opt_reset(c);
    } else if (das_optimize &&
               c->opt_prev_mem == DAS_OPT_MEM_JRST_TARGET) {
        if (pass2_emit_pending_jrst(c, sec, loc, out) != 0)
            return 1;
    }
    opt_begin_line(c, &parsed);
    if (!c->opt_current_may_be_skipped &&
        opt_jump_jrst_transition(c, &parsed))
        return 0;
    if (!c->opt_current_may_be_skipped && parsed.label == 0 &&
        das_optimize && opt_direct_jrst_symbol(&parsed, c->opt_prev_mem_ea,
            sizeof(c->opt_prev_mem_ea))) {
        opt_reset(c);
        c->opt_prev_mem = DAS_OPT_MEM_JRST_TARGET;
        return 0;
    }
    if (opt_finish_pending_push(c, &parsed)) {
        das_word_t move_word;
        das_word_t current_word;
        das_word_t push_word;
        unsigned int first_off;
        unsigned int second_off;
        int current_reloc;

        if (loc[*sec] < 2U)
            return 1;
        first_off = sec_base(c, *sec) + loc[*sec] - 2U;
        second_off = first_off + 1U;
        if (output_read_word(out, first_off, &move_word) != 0)
            return 1;
        {
            unsigned int expected_opcode;

            if (c->opt_pending_push_kind == 3U)
                expected_opcode = 0201U;
            else if (c->opt_pending_push_kind == 4U)
                expected_opcode = 0414U;
            else
                expected_opcode = 0200U;
            if (((move_word >> 27) & DAS_W(0777)) !=
                    (das_word_t)expected_opcode ||
                ((move_word >> 23) & DAS_W(017)) !=
                    c->opt_pending_push_temp)
                return 1;
        }
        push_word = (move_word & ~((das_word_t)DAS_W(017) << 23)) |
            ((das_word_t)c->opt_pending_push_ac << 23);
        if (output_replace_word(out, first_off, push_word) != 0)
            return 1;
        if (parse_instruction_word(c, parsed.stmt, second_off,
                &current_word, &current_reloc) <= 0)
            return 1;
        if (output_replace_word_reloc(out, second_off, current_word,
                current_reloc) != 0)
            return 1;
        opt_reset(c);
        opt_record_prev(c, &parsed);
        return 0;
    }
    {
        unsigned int overwrite_ac;

        if (opt_overwrite_prev(c, &parsed, &overwrite_ac)) {
            das_word_t word;
            int reloc;
            unsigned int dot;

            if (loc[*sec] == 0U)
                return 1;
            dot = sec_base(c, *sec) + loc[*sec] - 1U;
            if (parse_instruction_word(c, parsed.stmt, dot, &word, &reloc) <= 0)
                return 1;
            if (output_replace_word_reloc(out, dot, word, reloc) != 0)
                return 1;
            c->opt_prev_store = 0U;
            opt_record_prev(c, &parsed);
            return 0;
        }
    }
    if (opt_redundant_mem_pair(c, &parsed))
        return 0;
    {
        unsigned int opcode;

        if (opt_move_unary_fold(c, &parsed, &opcode)) {
            if (loc[*sec] == 0U)
                return 1;
            if (output_reopcode(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, opcode) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int opcode;

        if (opt_move_skip_fold(c, &parsed, &opcode)) {
            if (loc[*sec] == 0U)
                return 1;
            if (output_reopcode(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, opcode) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    if (opt_lshr_andi_redundant(c, &parsed)) {
        opt_reset(c);
        return 0;
    }
    if (opt_movei_hrrz_redundant(c, &parsed)) {
        opt_reset(c);
        return 0;
    }
    if (opt_zero_store(c, &parsed)) {
        das_word_t word;
        int reloc;
        unsigned int dot;

        if (loc[*sec] == 0U)
            return 1;
        dot = sec_base(c, *sec) + loc[*sec];
        if (parse_instruction_word(c, parsed.stmt, dot, &word, &reloc) <= 0)
            return 1;
        word = (word & DAS_W(0777777777)) | (DAS_W(0403) << 27);
        if (output_replace_word_reloc(out,
                sec_base(c, *sec) + loc[*sec] - 1U, word, reloc) != 0)
            return 1;
        opt_reset(c);
        return 0;
    }
    {
        unsigned int zero_ac;

        if (opt_zero_move_pair(c, &parsed, &zero_ac)) {
            das_word_t word;

            if (loc[*sec] == 0U)
                return 1;
            word = das_enc_mem(0403U, c->opt_prev_zero_ac,
                0, 0, zero_ac);
            if (output_replace_word(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, word) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int zero_ac;

        if (opt_zero_pair(c, &parsed, &zero_ac)) {
            das_word_t word;

            if (loc[*sec] == 0U)
                return 1;
            word = das_enc_mem(0403U, c->opt_prev_zero_ac,
                0, 0, zero_ac);
            if (output_replace_word(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, word) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int opt_ac;
        unsigned int opt_value;

        if (opt_immediate_fold(c, &parsed, &opt_ac, &opt_value)) {
            das_word_t word;

            if (loc[*sec] == 0U)
                return 1;
            word = das_enc_mem(0201U, opt_ac, 0, 0, opt_value);
            if (output_replace_word(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, word) != 0)
                return 1;
            opt_set_prev_immediate(c, opt_ac, opt_value);
            return 0;
        }
    }
    {
        unsigned int opt_ac;
        unsigned int opt_value;
        das_word_t word;

        if (opt_movei_right_shift_fold(c, &parsed, &opt_ac, &opt_value)) {
            if (loc[*sec] == 0U)
                return 1;
            word = das_enc_mem(0201U, opt_ac, 0, 0, opt_value);
            if (output_replace_word(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, word) != 0)
                return 1;
            opt_set_prev_immediate(c, opt_ac, opt_value);
            return 0;
        }
    }
    if (opt_movei_test_nonskip(c, &parsed)) {
        c->opt_skip_next &= ~DAS_OPT_GUARD_NEXT;
        return 0;
    }
    {
        unsigned int opt_ac;
        das_word_t word;

        if (opt_movei_movn_fold(c, &parsed, &opt_ac)) {
            if (loc[*sec] == 0U)
                return 1;
            word = das_enc_mem(0211U, opt_ac, 0, 0,
                c->opt_prev_immediate_value);
            if (output_replace_word(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, word) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    {
        unsigned int opt_ac;
        unsigned int opcode;
        das_word_t word;

        if (opt_movei_unary_immediate_fold(c, &parsed, &opt_ac, &opcode)) {
            if (loc[*sec] == 0U)
                return 1;
            word = das_enc_mem(opcode, opt_ac, 0, 0,
                c->opt_prev_immediate_value);
            if (output_replace_word(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, word) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    {
        int fold;

        fold = opt_halfword_fold(c, &parsed);
        if (fold != DAS_OPT_FOLD_NONE) {
            unsigned int opcode;

            if (loc[*sec] == 0U)
                return 1;
            if (fold == DAS_OPT_FOLD_HLRZ)
                opcode = 0554U;
            else if (fold == DAS_OPT_FOLD_HRLZ)
                opcode = 0514U;
            else
                opcode = 0550U;
            if (output_reopcode(out,
                    sec_base(c, *sec) + loc[*sec] - 1U, opcode) != 0)
                return 1;
            opt_reset(c);
            return 0;
        }
    }
    if (opt_drop_line(c, &parsed))
        return 0;
#endif
    if (parsed.stmt == 0)
        return 0;
    switch (parsed.token) {
    case DAS_TOK_TEXT:
        *sec = DAS_SEC_TEXT;
        return 0;
    case DAS_TOK_DATA:
        *sec = DAS_SEC_DATA;
        return 0;
    case DAS_TOK_BSS:
        *sec = DAS_SEC_BSS;
        return 0;
    case DAS_TOK_PSECT:
        *sec = psect_to_sec(parsed.rest, *sec);
        return 0;
    case DAS_TOK_EQU:
    case DAS_TOK_SET:
        return define_assignment(c, &parsed,
            sec_base(c, *sec) + loc[*sec]);
    case DAS_TOK_ALIGN: {
        unsigned int padding;
        unsigned int dot;

        if (align_word_padding(c, parsed.rest,
                sec_base(c, *sec) + loc[*sec], loc[*sec], &padding) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad align\n", "das: malformed .align directive: %s\n"), parsed.stmt);
            return 1;
        }
        dot = sec_base(c, *sec) + loc[*sec];
        if (*sec != DAS_SEC_BSS && padding != 0U &&
            output_emit_zeros(out, dot, padding) != 0)
            return 1;
        loc[*sec] += padding;
#if DAS_ENABLE_OPTIMIZER
        opt_reset(c);
#endif
        return 0;
    }
    case DAS_TOK_ORG: {
        unsigned int target;
        unsigned int dot;
        unsigned int padding;

        dot = sec_base(c, *sec) + loc[*sec];
        if (org_word_target(c, parsed.rest, dot, loc[*sec], &target) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad org\n", "das: malformed or backward .org directive: %s\n"), parsed.stmt);
            return 1;
        }
        padding = target - loc[*sec];
        if (*sec != DAS_SEC_BSS && padding != 0U &&
            output_emit_zeros(out, dot, padding) != 0)
            return 1;
        loc[*sec] = target;
#if DAS_ENABLE_OPTIMIZER
        opt_reset(c);
#endif
        return 0;
    }
    case DAS_TOK_NO_WORDS:
    case DAS_TOK_ENTRY:
    case DAS_TOK_GLOBAL:
    case DAS_TOK_EXTERN:
    case DAS_TOK_ERROR:
    case DAS_TOK_WARNING:
        return 0;
    case DAS_TOK_COMM:
    case DAS_TOK_LCOMM: {
        char common_name[DAS_MAX_NAME + 1];
        unsigned int words;

        if (common_args(parsed.rest, common_name, sizeof(common_name),
                &words) != 0)
            return 1;
        loc[DAS_SEC_BSS] += words;
        return 0;
    }
    default:
        break;
    }
    nwords = parsed_word_count(c, &parsed,
        sec_base(c, *sec) + loc[*sec]);
    if (nwords < 0) {
        fprintf(stderr, DAS_DIAG("das: bad directive\n", "das: malformed directive: %s\n"), parsed.stmt);
        return 1;
    }
    off = loc[*sec];
#if DAS_ENABLE_OPTIMIZER
    opt_record_prev(c, &parsed);
#endif
    if (pass2_stmt(c, *sec, off, &parsed,
            (unsigned int)nwords, out) != 0)
        return 1;
#if DAS_ENABLE_OPTIMIZER
    if (nwords == 1) {
        int forwarded;

        forwarded = opt_store_forward_emitted(c, &parsed, out,
            sec_base(c, *sec) + off);
        if (forwarded < 0)
            return 1;
    }
    opt_record_store_word(c, &parsed, out, sec_base(c, *sec) + off);
#endif
    loc[*sec] += (unsigned int)nwords;
    return 0;
}
#if !defined(DAS_NATIVE_PHASE2_ONLY) && !defined(DAS_PHASE2_PROGRAM)
static int pass2_ir(struct asmctx *c, int *sec, unsigned int loc[4],
                    struct das_output *out)
{
    das_word_t magic;
    unsigned int pos;
#ifdef DAS_NATIVE
    char *line;
#else
    char line_store[DAS_MAX_LINE];
    char *line;
#endif

#ifdef DAS_NATIVE
    line = das_native_line;
#else
    line = line_store;
#endif
    if (c->ir_spill.words == 0U ||
        wordfile_read(&c->ir_spill, 0U, &magic, 1U) != 0 ||
        magic != DAS_IR_MAGIC) {
        fprintf(stderr, DAS_DIAG("das: bad ir\n",
            "das: malformed private DASIR1 phase stream\n"));
        return 1;
    }
    pos = 1U;
    while (pos < c->ir_spill.words) {
        unsigned int type;

        if (ir_store_read_line(c, &pos, line, &type) != 0) {
            fprintf(stderr, DAS_DIAG("das: bad ir\n",
                "das: malformed private DASIR1 phase record\n"));
            return 1;
        }
        if (type == DAS_IR_RESET) {
            /* Pass 1 has already counted any deferred branch word.  A phase
             * barrier ends adjacency, so emit that word before clearing the
             * optimizer state. */
            if (pass2_emit_pending_jump_jrst(c, sec, loc, out) != 0 ||
                pass2_emit_pending_jrst(c, sec, loc, out) != 0)
                return 1;
            opt_reset(c);
            continue;
        }
        if (type == DAS_IR_GUARD) {
#if DAS_ENABLE_OPTIMIZER
            c->opt_skip_next |= DAS_OPT_GUARD_NEXT;
#endif
            continue;
        }
        if (type != DAS_IR_LINE) {
            fprintf(stderr, DAS_DIAG("das: bad ir\n",
                "das: invalid private DASIR1 phase record\n"));
            return 1;
        }
        if (pass2_line(c, line, sec, loc, out) != 0)
            return 1;
    }
    if (pass2_emit_pending_jump_jrst(c, sec, loc, out) != 0)
        return 1;
    if (pass2_emit_pending_jrst(c, sec, loc, out) != 0)
        return 1;
    return 0;
}
#endif

#if defined(DAS_NATIVE) || defined(DAS_PHASE2_PROGRAM)
static int phase_read_line_record(struct host_word_input *in,
                                  unsigned int *remaining,
                                  char *line, unsigned int *type)
{
    das_word_t header;
    unsigned int len;
    unsigned int words;
    unsigned int i;
#ifdef DAS_NATIVE
    das_word_t *record;
#else
    das_word_t record[DAS_REPT_PACK_WORDS];
#endif

    if (*remaining == 0U || phase_get_word(in, &header) != 0)
        return -1;
    (*remaining)--;
    *type = (unsigned int)((header >> DAS_IR_TYPE_SHIFT) &
        DAS_IR_TYPE_MASK);
    if (*type != DAS_IR_LINE) {
        line[0] = 0;
        return 0;
    }
    len = (unsigned int)(header & DAS_HALF_MASK);
    if (len >= DAS_MAX_LINE)
        return -1;
    words = (len + DAS_TARGET_CHARS_PER_WORD - 1U) /
        DAS_TARGET_CHARS_PER_WORD;
    if (words > *remaining)
        return -1;
#ifdef DAS_NATIVE
    record = das_native_phase_line;
#endif
    for (i = 0U; i < words; i++) {
        if (phase_get_word(in, &record[i]) != 0)
            return -1;
    }
    *remaining -= words;
    if (words != 0U)
        unpack_text_words(line, DAS_MAX_LINE, record, len);
    else
        line[0] = 0;
    return 0;
}

static int pass2_phase_stream(struct asmctx *c, struct host_word_input *in,
                              unsigned int line_words, int *sec,
                              unsigned int loc[4], struct das_output *out)
{
#ifdef DAS_NATIVE
    char *line;
#else
    char line_store[DAS_MAX_LINE];
    char *line;
#endif

#ifdef DAS_NATIVE
    line = das_native_line;
#else
    line = line_store;
#endif
    while (line_words != 0U) {
        unsigned int type;

        if (phase_read_line_record(in, &line_words, line, &type) != 0) {
            fprintf(stderr, DAS_DIAG("das2: bad ir\n",
                "das2: malformed private DASIR2 line stream\n"));
            return 1;
        }
        if (type == DAS_IR_RESET) {
            /* Pass 1 has already counted any deferred branch word.  A phase
             * barrier ends adjacency, so emit that word before clearing the
             * optimizer state. */
            if (pass2_emit_pending_jump_jrst(c, sec, loc, out) != 0 ||
                pass2_emit_pending_jrst(c, sec, loc, out) != 0)
                return 1;
            opt_reset(c);
            continue;
        }
        if (type == DAS_IR_GUARD) {
#if DAS_ENABLE_OPTIMIZER
            c->opt_skip_next |= DAS_OPT_GUARD_NEXT;
#endif
            continue;
        }
        if (type != DAS_IR_LINE) {
            fprintf(stderr, DAS_DIAG("das2: bad ir\n",
                "das2: invalid private DASIR2 line record\n"));
            return 1;
        }
        if (pass2_line(c, line, sec, loc, out) != 0)
            return 1;
    }
    if (pass2_emit_pending_jump_jrst(c, sec, loc, out) != 0)
        return 1;
    if (pass2_emit_pending_jrst(c, sec, loc, out) != 0)
        return 1;
    return 0;
}
#endif

#endif

#if !defined(DAS_NATIVE_PHASE2_ONLY)
#ifndef DAS_PHASE2_PROGRAM
static int assemble_phase1_stream(const char *infile, const char *outfile,
                                  FILE *phaseout, int input_format)
{
#ifndef DAS_NATIVE
    struct asmctx local_ctx;
#endif
    struct asmctx *c;
    struct sym entry_sym;
    struct das_cond_state cond;
    int sec;
    int rc;
    unsigned int image_words;
    unsigned int reloc_words;

#ifdef DAS_NATIVE
    c = &das_native_ctx;
#else
    c = &local_ctx;
#endif
    memset(c, 0, sizeof(*c));
    if (store_init(c, outfile) != 0)
        die("cannot create scratch files");
    if (ir_store_begin(c) != 0) {
        store_close(c);
        die("cannot initialize phase stream");
    }
    das_note_work(c, 0U);
    sec = DAS_SEC_TEXT;
    memset(&cond, 0, sizeof(cond));
    opt_reset(c);
    rc = pass1_file(c, infile, &sec, 0, input_format, &cond,
        0U, 0, 0U, 0);
#if DAS_ENABLE_OPTIMIZER
    if (rc == 0)
        rc = pass1_replay_indexed_xct(c);
#endif
    if (rc != 0) {
        store_close(c);
        return 1;
    }
    if (c->entry_name[0]) {
        if (!find_sym(c, c->entry_name, &entry_sym))
            die("undefined entry");
        c->entry = sec_base(c, entry_sym.sec & DAS_SYM_SEC_MASK) +
            (unsigned int)(entry_sym.off & DAS_HALF_MASK);
    } else if (find_sym(c, "main", &entry_sym)) {
        c->entry = sec_base(c, entry_sym.sec & DAS_SYM_SEC_MASK) +
            (unsigned int)(entry_sym.off & DAS_HALF_MASK);
    }
    image_words = text_total(c) + c->loc[DAS_SEC_DATA];
#ifndef DAS_NATIVE
    if (image_words == 0U && c->loc[DAS_SEC_BSS] == 0U && !c->object_mode)
        die("empty image");
#else
    if (image_words == 0U && c->loc[DAS_SEC_BSS] == 0U)
        die("empty image");
#endif
    if (image_words != 0U && c->entry >= image_words)
        die("entry outside image");
    reloc_words = (image_words + 35U) / 36U;
    c->relmap_words = reloc_words;
    das_note_work(c, reloc_words);
#ifdef DAS_NATIVE
    if (image_words > EXEC_DXR_MAX_IMAGE_WORDS ||
        c->loc[DAS_SEC_BSS] > EXEC_DXR_MAX_BSS_WORDS ||
        image_words + c->loc[DAS_SEC_BSS] +
            EXEC_DXR_STACK_WORDS > 040000U)
        die("output exceeds native DXR process limit");
#endif
    rc = phase_export_stream(c, phaseout) != 0;
    store_close(c);
    if (rc != 0) {
        fprintf(stderr, DAS_DIAG("das: phase write\n",
            "das: cannot write private DASIR2 phase stream\n"));
        return 1;
    }
    return 0;
}

static int assemble_phase1_file(const char *infile, const char *outfile,
                                const char *phasefile, int input_format)
{
    FILE *phaseout;
    int rc;

    phaseout = fopen(phasefile, "w+b");
    if (phaseout == 0) {
        perror(phasefile);
        return 1;
    }
    rc = assemble_phase1_stream(infile, outfile, phaseout, input_format);
    if (fclose(phaseout) != 0)
        rc = 1;
    if (rc != 0)
        (void)remove(phasefile);
    return rc;
}
#endif


#endif

#if !defined(DAS_NATIVE_PHASE1_ONLY)
#if defined(DAS_NATIVE) || defined(DAS_PHASE2_PROGRAM)
static int assemble_phase2_stream(FILE *f, const char *outfile)
{
    FILE *o;
#ifndef DAS_NATIVE
    struct asmctx local_ctx;
    das_word_t input_buffer[DAS_WORD_INPUT_BUFFER];
#endif
    struct asmctx *c;
    struct host_word_input input;
    struct das_output output;
    int pass2_sec;
    int rc;
    unsigned int image_words;
    unsigned int reloc_words;
    unsigned int emit_loc[4];
    unsigned int line_words;
    unsigned int end_count;
    das_word_t *relmap;

#ifdef DAS_NATIVE
    c = &das_native_ctx;
#else
    c = &local_ctx;
#endif
    memset(c, 0, sizeof(*c));
    if (store_init_phase2(c, outfile) != 0)
        die("cannot create phase-2 scratch files");
    memset(&input, 0, sizeof(input));
    input.file = f;
#ifdef DAS_NATIVE
    input.buffer = das_native_phase_input;
#else
    input.buffer = input_buffer;
#endif
    if (phase_import_state(c, &input, &line_words) != 0) {
        fprintf(stderr, DAS_DIAG("das2: bad ir\n",
            "das2: malformed private DASIR2 phase state\n"));
        store_close(c);
        return 1;
    }
    image_words = text_total(c) + c->loc[DAS_SEC_DATA];
    reloc_words = (image_words + 35U) / 36U;
    c->relmap_words = reloc_words;
    das_note_work(c, reloc_words);
#ifdef DAS_NATIVE
    if (reloc_words > DAS_NATIVE_RELMAP_WORDS)
        die("native relocation bitmap too large");
    relmap = das_native_relmap;
    memset(relmap, 0, reloc_words * sizeof(*relmap));
#else
    relmap = 0;
    if (reloc_words != 0U) {
        relmap = (das_word_t *)calloc(reloc_words, sizeof(*relmap));
        if (!relmap)
            die("out of memory");
    }
#endif
    o = fopen(outfile, "w+b");
    if (!o) {
        perror(outfile);
#ifndef DAS_NATIVE
        free(relmap);
#endif
        store_close(c);
        return 1;
    }
    rc = output_begin(&output, o, c->entry, image_words,
        c->loc[DAS_SEC_BSS], relmap, reloc_words);
    if (rc != 0) {
        perror(outfile);
        fclose(o);
        remove(outfile);
#ifndef DAS_NATIVE
        free(relmap);
#endif
        store_close(c);
        return 1;
    }
    memset(emit_loc, 0, sizeof(emit_loc));
    pass2_sec = DAS_SEC_TEXT;
    c->set_serial = 0U;
    c->source_serial = 0U;
    opt_reset(c);
    rc = pass2_phase_stream(c, &input, line_words, &pass2_sec,
        emit_loc, &output);
    if (rc == 0 &&
        (phase_get_header(&input, DAS_PHASE_END, &end_count) != 0 ||
         end_count != 0U)) {
        fprintf(stderr, DAS_DIAG("das2: bad ir\n",
            "das2: malformed private DASIR2 stream ending\n"));
        rc = 1;
    }
    if (rc == 0)
        rc = fill_literals(c, &output);
    if (rc == 0 &&
        (emit_loc[DAS_SEC_TEXT] != c->loc[DAS_SEC_TEXT] ||
         emit_loc[DAS_SEC_DATA] != c->loc[DAS_SEC_DATA] ||
         emit_loc[DAS_SEC_BSS] != c->loc[DAS_SEC_BSS])) {
        fprintf(stderr, DAS_DIAG("das2: source changed\n",
            "das2: source changed between assembler phases\n"));
        rc = 1;
    }
    if (rc == 0) {
        rc = output_finish(&output);
        if (rc != 0)
            perror(outfile);
    }
    if (fclose(o) != 0) {
        perror(outfile);
        rc = 1;
    }
    if (rc != 0)
        remove(outfile);
#ifndef DAS_NATIVE
    if (rc == 0 && write_labels_file(c, das_labels_out) != 0)
        rc = 1;
    if (rc == 0 && das_memory_report) {
        unsigned int user_records;
        unsigned int visibility_records;

        sym_record_counts(c, &user_records, &visibility_records);
        fprintf(stderr, "das-memory: retained-statement-words=0\n");
        fprintf(stderr, "das-memory: retained-image-words=0\n");
        fprintf(stderr, "das-memory: symbol-bucket-words=%u\n",
                DAS_SYM_BUCKETS);
        fprintf(stderr, "das-memory: symbol-cache-words=%u\n",
                DAS_SYM_CACHE_ENTRIES * DAS_SYM_CACHE_SLOT_WORDS);
        fprintf(stderr, "das-memory: symbol-spill-records=%u\n",
                user_records);
        fprintf(stderr, "das-memory: symbol-visibility-records=%u\n",
                visibility_records);
        fprintf(stderr, "das-memory: symbol-lookups=%u\n",
                c->sym_store.lookups);
        fprintf(stderr, "das-memory: symbol-probes=%u\n",
                c->sym_store.probes);
        fprintf(stderr, "das-memory: literal-spill-records=%u\n",
                c->lit_store.records);
        fprintf(stderr, "das-memory: literal-spill-words=%u\n",
                c->lit_store.words);
        fprintf(stderr, "das-memory: parser-classifications=%u\n",
                c->parser_classifications);
        fprintf(stderr, "das-memory: parser-token-probes=%u\n",
                c->parser_token_probes);
        fprintf(stderr, "das-memory: relocation-bitmap-words=%u\n",
                reloc_words);
        fprintf(stderr, "das-memory: peak-work-words=%u\n",
                c->peak_work_words);
    }
    free(relmap);
#endif
    store_close(c);
    return rc;
}

static int assemble_phase2_file(const char *phasefile, const char *outfile)
{
    FILE *phasein;
    int rc;

    phasein = fopen(phasefile, "rb");
    if (phasein == 0) {
        perror(phasefile);
        return 1;
    }
    rc = assemble_phase2_stream(phasein, outfile);
    if (fclose(phasein) != 0)
        rc = 1;
    (void)remove(phasefile);
    return rc;
}
#endif


#endif

#if !defined(DAS_NATIVE_PHASE1_ONLY) && !defined(DAS_NATIVE_PHASE2_ONLY) && !defined(DAS_PHASE2_PROGRAM)
static int assemble_file(const char *infile, const char *outfile,
                         int input_format)
{
    FILE *o;
#ifndef DAS_NATIVE
    struct asmctx local_ctx;
#endif
    struct asmctx *c;
    struct sym entry_sym;
    struct das_output output;
    struct das_cond_state cond;
    int sec;
    int pass2_sec;
    int rc;
    unsigned int image_words;
    unsigned int reloc_words;
    unsigned int emit_loc[4];
    das_word_t *relmap;

#ifdef DAS_NATIVE
    c = &das_native_ctx;
#else
    c = &local_ctx;
#endif
    memset(c, 0, sizeof(*c));
#ifndef DAS_NATIVE
    c->object_mode = das_object_mode;
#endif
    if (store_init(c, outfile) != 0)
        die("cannot create scratch files");
    if (ir_store_begin(c) != 0) {
        store_close(c);
        die("cannot initialize phase stream");
    }
    das_note_work(c, 0U);
    sec = DAS_SEC_TEXT;
    memset(&cond, 0, sizeof(cond));
    opt_reset(c);
    if (pass1_file(c, infile, &sec, 0, input_format, &cond, 0U, 0, 0U, 0)
#if DAS_ENABLE_OPTIMIZER
        || pass1_replay_indexed_xct(c)
#endif
        ) {
        store_close(c);
        return 1;
    }
#ifndef DAS_NATIVE
    if (c->object_mode) {
        if (c->entry_name[0] != 0 && !find_sym(c, c->entry_name, &entry_sym))
            die("undefined entry");
    } else
#endif
    if (c->entry_name[0]) {
        if (!find_sym(c, c->entry_name, &entry_sym))
            die("undefined entry");
        c->entry = sec_base(c, entry_sym.sec & DAS_SYM_SEC_MASK) +
            (unsigned int)(entry_sym.off & DAS_HALF_MASK);
    } else if (find_sym(c, "main", &entry_sym)) {
        c->entry = sec_base(c, entry_sym.sec & DAS_SYM_SEC_MASK) +
            (unsigned int)(entry_sym.off & DAS_HALF_MASK);
    }
    image_words = text_total(c) + c->loc[DAS_SEC_DATA];
#ifndef DAS_NATIVE
    if (image_words == 0U && c->loc[DAS_SEC_BSS] == 0U && !c->object_mode)
        die("empty image");
#else
    if (image_words == 0U && c->loc[DAS_SEC_BSS] == 0U)
        die("empty image");
#endif
#ifndef DAS_NATIVE
    if (!c->object_mode && image_words != 0U && c->entry >= image_words)
        die("entry outside image");
#else
    if (image_words != 0U && c->entry >= image_words)
        die("entry outside image");
#endif
    reloc_words = (image_words + 35U) / 36U;
    c->relmap_words = reloc_words;
    das_note_work(c, reloc_words);
#ifdef DAS_NATIVE
    if (image_words > EXEC_DXR_MAX_IMAGE_WORDS ||
        c->loc[DAS_SEC_BSS] > EXEC_DXR_MAX_BSS_WORDS ||
        image_words + c->loc[DAS_SEC_BSS] +
            EXEC_DXR_STACK_WORDS > 040000U)
        die("output exceeds native DXR process limit");
    if (reloc_words > DAS_NATIVE_RELMAP_WORDS)
        die("native relocation bitmap too large");
    relmap = das_native_relmap;
    memset(relmap, 0, reloc_words * sizeof(*relmap));
#else
    relmap = 0;
    if (!c->object_mode && reloc_words != 0U) {
        relmap = (das_word_t *)calloc(reloc_words, sizeof(*relmap));
        if (!relmap)
            die("out of memory");
    }
#endif
    o = fopen(outfile, "w+b");
    if (!o) {
        perror(outfile);
#ifndef DAS_NATIVE
        free(relmap);
#endif
        store_close(c);
        return 1;
    }
#ifndef DAS_NATIVE
    if (c->object_mode)
        rc = output_begin_object(&output, o, c, image_words);
    else
#endif
        rc = output_begin(&output, o, c->entry, image_words,
                          c->loc[DAS_SEC_BSS], relmap, reloc_words);
    if (rc != 0) {
        perror(outfile);
        fclose(o);
        remove(outfile);
#ifndef DAS_NATIVE
        free(relmap);
#endif
        store_close(c);
        return 1;
    }
    memset(emit_loc, 0, sizeof(emit_loc));
    pass2_sec = DAS_SEC_TEXT;
    memset(&cond, 0, sizeof(cond));
    c->set_serial = 0U;
    c->source_serial = 0U;
    opt_reset(c);
    rc = pass2_ir(c, &pass2_sec, emit_loc, &output);
    if (rc == 0)
        rc = fill_literals(c, &output);
    if (rc == 0 &&
        (emit_loc[DAS_SEC_TEXT] != c->loc[DAS_SEC_TEXT] ||
         emit_loc[DAS_SEC_DATA] != c->loc[DAS_SEC_DATA] ||
         emit_loc[DAS_SEC_BSS] != c->loc[DAS_SEC_BSS])) {
        fprintf(stderr, DAS_DIAG("das: source changed\n", "das: source changed between passes\n"));
        rc = 1;
    }
    if (rc == 0) {
#ifndef DAS_NATIVE
        if (c->object_mode)
            rc = output_finish_object(&output);
        else
#endif
            rc = output_finish(&output);
        if (rc != 0)
            perror(outfile);
    }
    if (fclose(o) != 0) {
        perror(outfile);
        rc = 1;
    }
    if (rc != 0)
        remove(outfile);
#ifndef DAS_NATIVE
    if (rc == 0 && write_labels_file(c, das_labels_out) != 0)
        rc = 1;
    if (rc == 0 && das_memory_report) {
        unsigned int user_records;
        unsigned int visibility_records;

        sym_record_counts(c, &user_records, &visibility_records);
        fprintf(stderr, "das-memory: retained-statement-words=0\n");
        fprintf(stderr, "das-memory: retained-image-words=0\n");
        fprintf(stderr, "das-memory: symbol-bucket-words=%u\n",
                DAS_SYM_BUCKETS);
        fprintf(stderr, "das-memory: symbol-cache-words=%u\n",
                DAS_SYM_CACHE_ENTRIES * DAS_SYM_CACHE_SLOT_WORDS);
        fprintf(stderr, "das-memory: symbol-spill-records=%u\n",
                user_records);
        fprintf(stderr, "das-memory: symbol-visibility-records=%u\n",
                visibility_records);
        fprintf(stderr, "das-memory: symbol-lookups=%u\n",
                c->sym_store.lookups);
        fprintf(stderr, "das-memory: symbol-probes=%u\n",
                c->sym_store.probes);
        fprintf(stderr, "das-memory: literal-spill-records=%u\n",
                c->lit_store.records);
        fprintf(stderr, "das-memory: literal-spill-words=%u\n",
                c->lit_store.words);
        fprintf(stderr, "das-memory: parser-classifications=%u\n",
                c->parser_classifications);
        fprintf(stderr, "das-memory: parser-token-probes=%u\n",
                c->parser_token_probes);
        fprintf(stderr, "das-memory: relocation-bitmap-words=%u\n",
                reloc_words);
        fprintf(stderr, "das-memory: peak-work-words=%u\n",
                c->peak_work_words);
    }
    free(relmap);
    free(c->obj_globals);
    free(c->obj_relocs);
    free(c->set_relocs);
#endif
    store_close(c);
    return rc;
}
#endif

#if !defined(DAS_NATIVE) && !defined(DAS_PHASE2_PROGRAM)
static void usage(void)
{
    fprintf(stderr,
        "usage: das [-C] [-B|-K] [-A|-S] [-F] [-P] [-M] [-L out.labels] "
        "-O output in.s\n");
}
#endif

#ifndef DAS_NATIVE
#ifndef DAS_PHASE2_PROGRAM
static int phase_path_make(const char *outfile, char *path, size_t cap)
{
    size_t n;

    n = strlen(outfile);
    if (n + 4U >= cap)
        return -1;
    strcopy(path, outfile, cap);
    strcopy(path + n, ".D2R", cap - n);
    return 0;
}

#endif

#ifndef DAS_PHASE2_PROGRAM
static int run_phase2_host(const char *argv0, const char *phasefile,
                           const char *outfile)
{
    char prog[DAS_MAX_LINE * 2U];
    char *av[9];
    const char *slash;
    size_t dirlen;
    int n;

    slash = strrchr(argv0, '/');
    if (slash != 0) {
        dirlen = char_distance(argv0, slash + 1);
        if (dirlen + 5U >= sizeof(prog))
            return -1;
        memcpy(prog, argv0, dirlen);
        strcopy(prog + dirlen, "das2", sizeof(prog) - dirlen);
    } else {
        strcopy(prog, "das2", sizeof(prog));
    }
    n = 0;
    av[n++] = prog;
    if (das_memory_report)
        av[n++] = "-M";
    if (das_labels_out != 0) {
        av[n++] = "-L";
        av[n++] = (char *)das_labels_out;
    }
    av[n++] = "-O";
    av[n++] = (char *)outfile;
    av[n++] = (char *)phasefile;
    av[n] = 0;
    if (slash != 0)
        execv(prog, av);
    else
        execvp(prog, av);
    return -1;
}

static int run_phase2_pipe_host(const char *argv0, const char *infile,
                                const char *outfile, int input_format)
{
    int fds[2];
    pid_t pid;
    int status;
    FILE *phaseout;
    int rc;

    if (pipe(fds) != 0)
        return 1;
    pid = fork();
    if (pid < 0) {
        close(fds[0]);
        close(fds[1]);
        return 1;
    }
    if (pid == 0) {
        char prog[DAS_MAX_LINE * 2U];
        char *av[9];
        const char *slash;
        size_t dirlen;
        int n;

        close(fds[1]);
        if (dup2(fds[0], STDIN_FILENO) < 0)
            _exit(127);
        close(fds[0]);
        slash = strrchr(argv0, '/');
        if (slash != 0) {
            dirlen = char_distance(argv0, slash + 1);
            if (dirlen + 5U >= sizeof(prog))
                _exit(127);
            memcpy(prog, argv0, dirlen);
            strcopy(prog + dirlen, "das2", sizeof(prog) - dirlen);
        } else {
            strcopy(prog, "das2", sizeof(prog));
        }
        n = 0;
        av[n++] = prog;
        av[n++] = "-P";
        if (das_memory_report)
            av[n++] = "-M";
        if (das_labels_out != 0) {
            av[n++] = "-L";
            av[n++] = (char *)das_labels_out;
        }
        av[n++] = "-O";
        av[n++] = (char *)outfile;
        av[n] = 0;
        if (slash != 0)
            execv(prog, av);
        else
            execvp(prog, av);
        _exit(127);
    }
    close(fds[0]);
    phaseout = fdopen(fds[1], "wb");
    if (phaseout == 0) {
        close(fds[1]);
        rc = 1;
    } else {
        rc = assemble_phase1_stream(infile, outfile, phaseout, input_format);
        if (fclose(phaseout) != 0)
            rc = 1;
    }
    if (waitpid(pid, &status, 0) != pid)
        return 1;
    if (rc != 0)
        return rc;
    if (!WIFEXITED(status))
        return 1;
    return WEXITSTATUS(status);
}

#endif
#ifdef DAS_PHASE2_PROGRAM
static int das2_main_text(int argc, char **argv)
{
    const char *out;
    const char *in;
    int pipe_input;
    int i;

    out = 0;
    in = 0;
    pipe_input = 0;
    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-O") == 0 && i + 1 < argc) {
            out = argv[++i];
        } else if (strcmp(argv[i], "-P") == 0) {
            pipe_input = 1;
        } else if (strcmp(argv[i], "-M") == 0) {
            das_memory_report = 1;
        } else if (strcmp(argv[i], "-L") == 0 && i + 1 < argc) {
            das_labels_out = argv[++i];
        } else if (argv[i][0] == '-') {
            fprintf(stderr,
                "usage: das2 [-P] [-M] [-L out.labels] -O output [phase.d2r]\n");
            return 1;
        } else {
            in = argv[i];
        }
    }
    if (out == 0 || (pipe_input ? in != 0 : in == 0)) {
        fprintf(stderr,
            "usage: das2 [-P] [-M] [-L out.labels] -O output [phase.d2r]\n");
        return 1;
    }
    if (pipe_input)
        return assemble_phase2_stream(stdin, out);
    return assemble_phase2_file(in, out);
}

#else
static int das_main_text(int argc, char **argv)
{
    const char *out;
    const char *in;
    const char *prog;
    char phasefile[DAS_MAX_LINE * 2U];
    int input_format;
    int pipe_mode;
    int compat_as;
    int compat_legacy;
    int i;
    int rc;

    out = NULL;
    in = NULL;
    input_format = DAS_INPUT_ASCII;
    pipe_mode = 0;
    prog = strrchr(argv[0], '/');
    prog = prog != NULL ? prog + 1 : argv[0];
    compat_as = strcmp(prog, "pdp10-dec-none-as") == 0;
    compat_legacy = compat_as;
    for (i = 1; i < argc; i++)
        if (strcmp(argv[i], "-o") == 0)
            compat_legacy = 1;
    for (i = 1; i < argc; i++) {
        if (compat_legacy && strcmp(argv[i], "-c") == 0) {
            das_object_mode = 1;
        } else if (compat_legacy && strcmp(argv[i], "-b") == 0) {
            das_strict_base = 1;
        } else if (compat_legacy && strcmp(argv[i], "-k") == 0) {
            das_strict_base = 1;
            das_kernel_mode = 1;
        } else if (compat_legacy && strcmp(argv[i], "-O") == 0) {
            das_optimize = 1;
        } else if (compat_legacy && strcmp(argv[i], "-a") == 0) {
            input_format = DAS_INPUT_ASCII;
        } else if (compat_legacy && strcmp(argv[i], "-s") == 0) {
            input_format = DAS_INPUT_S6REC;
        } else if (compat_legacy && strcmp(argv[i], "-p") == 0) {
            pipe_mode = 1;
        } else if (compat_legacy && strcmp(argv[i], "-m") == 0) {
            das_memory_report = 1;
        } else if (compat_legacy && strcmp(argv[i], "-l") == 0 &&
                   i + 1 < argc) {
            das_labels_out = argv[++i];
        } else if (compat_legacy && strcmp(argv[i], "-o") == 0 &&
                   i + 1 < argc) {
            out = argv[++i];
        } else if (strcmp(argv[i], "-O") == 0 && i + 1 < argc) {
            out = argv[++i];
        } else if (strcmp(argv[i], "-C") == 0) {
            das_object_mode = 1;
        } else if (strcmp(argv[i], "-B") == 0) {
            das_strict_base = 1;
        } else if (strcmp(argv[i], "-K") == 0) {
            das_strict_base = 1;
            das_kernel_mode = 1;
        } else if (strcmp(argv[i], "-F") == 0) {
            das_optimize = 1;
        } else if (strcmp(argv[i], "-A") == 0) {
            input_format = DAS_INPUT_ASCII;
        } else if (strcmp(argv[i], "-S") == 0) {
            input_format = DAS_INPUT_S6REC;
        } else if (strcmp(argv[i], "-P") == 0) {
            pipe_mode = 1;
        } else if (strcmp(argv[i], "-M") == 0) {
            das_memory_report = 1;
        } else if (strcmp(argv[i], "-L") == 0 && i + 1 < argc) {
            das_labels_out = argv[++i];
        } else if (argv[i][0] == '-') {
            usage();
            return 1;
        } else {
            in = argv[i];
        }
    }
    if (!out || !in) {
        usage();
        return 1;
    }
    if (das_object_mode && pipe_mode) {
        fprintf(stderr, "das: -P is not supported with -C\n");
        return 1;
    }
    if (das_object_mode)
        return assemble_file(in, out, input_format);
    if (pipe_mode)
        return run_phase2_pipe_host(argv[0], in, out, input_format);
    if (phase_path_make(out, phasefile, sizeof(phasefile)) != 0) {
        fprintf(stderr, "das: output path is too long for phase scratch\n");
        return 1;
    }
    (void)remove(phasefile);
    rc = assemble_phase1_file(in, out, phasefile, input_format);
    if (rc != 0) {
        (void)remove(phasefile);
        return rc;
    }
    if (run_phase2_host(argv[0], phasefile, out) != 0) {
        perror("das2");
        (void)remove(phasefile);
        return 1;
    }
    return 0;
}
#endif
#endif

#if defined(DAS_NATIVE) || defined(DAS_ARGV_SELFTEST)
static int das_counted_sixbit_arg_text(const das_word_t *arg, char *text,
                                       unsigned int cap)
{
    unsigned int n;
    unsigned int i;
    unsigned int slot;
    unsigned int pos;
    das_word_t word;
    unsigned int ch;

    if (arg == 0 || text == 0 || cap == 0U)
        return 1;
    n = (unsigned int)(arg[0] & DAS_HALF_MASK);
    if (n + 1U > cap)
        return 1;
    for (i = 0U; i < n; i++) {
        slot = 1U + i / 6U;
        pos = i % 6U;
        word = arg[slot];
        ch = (unsigned int)((word >> (30U - pos * 6U)) & DAS_W(077));
        ch += 040U;
        text[i] = (char)ch;
    }
    text[n] = 0;
    return 0;
}
#endif

#ifdef DAS_NATIVE

int das_native_main(int argc, kword_t **argv)
{
    char out[SYS_RUN_ARG_MAX_CHARS + 1U];
    char in[SYS_RUN_ARG_MAX_CHARS + 1U];
#if defined(DAS_NATIVE_PHASE1_ONLY)
    char phase[SYS_RUN_PATH_MAX_CHARS + 1U];
#endif
    char argtext[SYS_RUN_ARG_MAX_CHARS + 1U];
    int have_out;
    int have_in;
    int i;
#if defined(DAS_NATIVE_PHASE1_ONLY) || defined(DAS_NATIVE_PHASE2_ONLY)
    size_t n;
#endif

    /*
     * Native phases use explicit files and compact stderr diagnostics.  Release
     * inherited standard descriptors before opening phase/input/output files;
     * DAIMOS intentionally keeps the per-process descriptor table small.
     */
    (void)dsys_close(DSYS_STDIN);
    (void)dsys_close(DSYS_STDOUT);

    if (argc < 0 || argc > (int)SYS_RUN_ARG_MAX || argv == 0)
        return 1;
    have_out = 0;
    have_in = 0;
    for (i = 1; i < argc; i++) {
        if (das_counted_sixbit_arg_text((const das_word_t *)argv[i],
                argtext, sizeof(argtext)) != 0)
            return 1;
        if (strcmp(argtext, "-O") == 0) {
            if (++i >= argc || das_counted_sixbit_arg_text(
                    (const das_word_t *)argv[i], out, sizeof(out)) != 0)
                return 1;
            have_out = 1;
#if !defined(DAS_NATIVE_PHASE2_ONLY)
        } else if (strcmp(argtext, "-B") == 0) {
            das_strict_base = 1;
        } else if (strcmp(argtext, "-K") == 0) {
            das_strict_base = 1;
            das_kernel_mode = 1;
        } else if (strcmp(argtext, "-F") == 0) {
#if DAS_ENABLE_OPTIMIZER
            das_optimize = 1;
#endif
        } else if (strcmp(argtext, "-S") == 0) {
            /* Native DAS input is always S6REC. */
#endif
        } else {
            if (argtext[0] == '-')
                return 1;
            strcopy(in, argtext, sizeof(in));
            have_in = 1;
        }
    }
#if defined(DAS_NATIVE_PHASE2_ONLY)
    if (!have_out)
        return 1;
    if (!have_in) {
        n = strlen(out);
        if (n + 4U > SYS_RUN_PATH_MAX_CHARS)
            return 1;
        strcopy(in, out, sizeof(in));
        strcopy(in + n, ".D2R", sizeof(in) - n);
        have_in = 1;
    }
#else
    if (!have_out || !have_in)
        return 1;
#endif
#if defined(DAS_NATIVE_PHASE1_ONLY)
    n = strlen(out);
    if (n + 4U > KPATH_MAX_CHARS)
        return 1;
    strcopy(phase, out, sizeof(phase));
    strcopy(phase + n, ".D2R", sizeof(phase) - n);
    (void)remove(phase);
    return assemble_phase1_file(in, out, phase, DAS_INPUT_S6REC);
#elif defined(DAS_NATIVE_PHASE2_ONLY)
    return assemble_phase2_file(in, out);
#else
    return assemble_file(in, out, DAS_INPUT_S6REC);
#endif
}

#ifndef DAS_NO_MAIN
int main(int argc, kword_t **argv, kword_t **envp)
{
    (void)envp;
    return das_native_main(argc, argv);
}
#endif
#else
#ifndef DAS_NO_MAIN
int main(int argc, char **argv)
{
#ifdef DAS_PHASE2_PROGRAM
    return das2_main_text(argc, argv);
#else
    return das_main_text(argc, argv);
#endif
}
#endif
#endif
#endif /* DAS_NATIVE_CORE_ONLY */
