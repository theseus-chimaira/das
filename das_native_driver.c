/* Native DAS launcher.  EXEC replaces this process with DAS1, so the
 * 16K-word user-memory budget is not consumed by a waiting driver.
 * DAS1 chains to DAS2 only after it has committed its phase file.
 */
#include "dsys.h"
#include <pdp10-sixbit.h>

#define DAS_DRIVER_RECORD_WORDS 18U
#define DAS_DRIVER_EXEC_WORDS \
    (SYS_EXEC_V1_FIXED_WORDS + DAS_DRIVER_RECORD_WORDS + \
     SYS_RUN_ARG_MAX * DAS_DRIVER_RECORD_WORDS)

static const kword_t das1_path[] = {
    29UL,
    PDP10_SIX6('/','O','P','T','I','O'),
    PDP10_SIX6('N','/','B','A','S','E'),
    PDP10_SIX6('/','L','I','B','E','X'),
    PDP10_SIX6('E','C','/','D','A','S'),
    PDP10_SIX6('/','D','A','S','1',' ')
};

/* A private argv[0] marker allows direct DAS1 use to remain a one-pass
 * operation while the DAS driver requests the complete two-phase chain.
 * Replacing argv[0] does not change argc or the allowed user arguments. */
static const kword_t das1_chain_name[] = {
    9UL,
    PDP10_SIX6('D','A','S','1','C','H'),
    PDP10_SIX6('A','I','N',' ',' ',' ')
};

static unsigned int
record_words(const kword_t *record)
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
append_record(kword_t *block, unsigned int *used,
              const kword_t *record)
{
    unsigned int count;
    unsigned int i;

    count = record_words(record);
    if (count == 0U || *used > DAS_DRIVER_EXEC_WORDS - count)
        return -1;
    for (i = 0U; i < count; i++)
        block[(*used)++] = record[i];
    return 0;
}

static int
is_output_option(const kword_t *s)
{
    return s != 0 && s[0] == 2UL &&
        s[1] == PDP10_SIX6('-','O',' ',' ',' ',' ');
}

int
main(int argc, kword_t **argv)
{
    kword_t block[DAS_DRIVER_EXEC_WORDS];
    struct sys_exec_v1 *exec;
    unsigned int used;
    unsigned int i;
    int have_output;

    if (argc < 1 || argc > (int)SYS_RUN_ARG_MAX || argv == 0)
        return 1;
    have_output = 0;
    for (i = 1U; i < (unsigned int)argc; i++) {
        if (record_words(argv[i]) == 0U)
            return 1;
        if (is_output_option(argv[i]) && i + 1U < (unsigned int)argc)
            have_output = 1;
    }
    if (!have_output)
        return 1;

    used = SYS_EXEC_V1_FIXED_WORDS;
    if (append_record(block, &used, das1_path) != 0 ||
        append_record(block, &used, das1_chain_name) != 0)
        return 126;
    for (i = 1U; i < (unsigned int)argc; i++)
        if (append_record(block, &used, argv[i]) != 0)
            return 126;

    exec = (struct sys_exec_v1 *)block;
    exec->version_words = SYS_RUN_HEADER(SYS_EXEC_VERSION_1, used);
    exec->argc = (kword_t)argc;
    exec->envc = 0UL;
    /* A successful EXEC cannot return through this image. */
    return dsys_exec(exec) < 0 ? 126 : 1;
}
