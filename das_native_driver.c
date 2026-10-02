#include "dsys.h"
#include <pdp10-sixbit.h>

#define DAS_DRIVER_RECORD_WORDS 18U
#define DAS_DRIVER_BLOCK_WORDS \
    (SYS_RUN_V2_FIXED_WORDS + DAS_DRIVER_RECORD_WORDS + \
     SYS_RUN_ARG_MAX * DAS_DRIVER_RECORD_WORDS + 1U)

static kword_t das1_path[] = {
    17UL,
    PDP10_SIX6('/','S','Y','S','T','E'),
    PDP10_SIX6('M','/','E','X','E','C'),
    PDP10_SIX6('/','D','A','S','1',' ')
};

static kword_t das2_path[] = {
    17UL,
    PDP10_SIX6('/','S','Y','S','T','E'),
    PDP10_SIX6('M','/','E','X','E','C'),
    PDP10_SIX6('/','D','A','S','2',' ')
};

static kword_t das2_name[] = {
    4UL,
    PDP10_SIX6('D','A','S','2',' ',' ')
};

static kword_t opt_o[] = {
    2UL,
    PDP10_SIX6('-','O',' ',' ',' ',' ')
};

static int
s6_char(kword_t *s, unsigned int i)
{
    unsigned int slot;
    unsigned int pos;

    slot = 1U + i / 6U;
    pos = i % 6U;
    return (int)(((s[slot] >> (30U - pos * 6U)) & 077UL) + 040UL);
}

static unsigned int
record_words(kword_t *record)
{
    unsigned int chars;

    if (record == 0)
        return 0U;
    chars = (unsigned int)(record[0] & 0777777UL);
    if (chars == 0U || chars > SYS_RUN_ARG_MAX_CHARS)
        return 0U;
    return 1U + (chars + 5U) / 6U;
}

static int
copy_record(kword_t *block, unsigned int *used, kword_t *record)
{
    unsigned int words;
    unsigned int i;

    words = record_words(record);
    if (words == 0U || *used > DAS_DRIVER_BLOCK_WORDS - words)
        return -1;
    for (i = 0U; i < words; i++)
        block[(*used)++] = record[i];
    return 0;
}

static int
is_output_option(kword_t *s)
{
    int ch;

    if (s == 0 || (unsigned int)(s[0] & 0777777UL) != 2U)
        return 0;
    if (s6_char(s, 0U) != '-')
        return 0;
    ch = s6_char(s, 1U);
    return ch == 'O';
}

static kword_t *
find_output(int argc, kword_t **argv)
{
    int i;

    for (i = 1; i + 1 < argc; i++) {
        if (is_output_option(argv[i]))
            return argv[i + 1];
    }
    return 0;
}

static int
run_child(kword_t *path, kword_t **argv, unsigned int argc)
{
    kword_t block[DAS_DRIVER_BLOCK_WORDS];
    struct sys_run_v2 *run;
    kword_t status;
    unsigned int used;
    unsigned int i;
    int pid;

    if (argc == 0U || argc > SYS_RUN_ARG_MAX)
        return 126;
    used = SYS_RUN_V2_FIXED_WORDS;
    if (copy_record(block, &used, path) != 0)
        return 126;
    for (i = 0U; i < argc; i++) {
        if (copy_record(block, &used, argv[i]) != 0)
            return 126;
    }
    if (used >= DAS_DRIVER_BLOCK_WORDS)
        return 126;
    block[used++] = SYS_RUN_FD_MAP(2U, 2U);

    run = (struct sys_run_v2 *)block;
    run->version_words = SYS_RUN_HEADER(SYS_RUN_VERSION_2, used);
    run->flags = SYS_RUN_PGRP_INHERIT;
    run->pgrp = 0UL;
    run->fdmap_count = 1UL;
    run->argc = (kword_t)argc;
    run->envc = 0UL;
    pid = dsys_run(run);
    if (pid < 0)
        return 126;
    status = 0UL;
    if (dsys_wait((unsigned int)pid, &status, 0U) != pid)
        return 126;
    if (SYS_WAIT_STATUS_KIND(status) != SYS_WAIT_EXITED)
        return 126;
    return (int)SYS_WAIT_STATUS_VALUE(status);
}

int
main(int argc, kword_t **argv)
{
    kword_t *phase2_argv[3];
    kword_t *output;
    int rc;

    if (argc < 1 || argv == 0)
        return 1;
    output = find_output(argc, argv);
    if (output == 0)
        return 1;

    rc = run_child(das1_path, argv, (unsigned int)argc);
    if (rc != 0)
        return rc;

    phase2_argv[0] = das2_name;
    phase2_argv[1] = opt_o;
    phase2_argv[2] = output;
    return run_child(das2_path, phase2_argv, 3U);
}
