/* dxrcheck - host checker for DAIMOS DXR V1 container files. */
#include <stdio.h>
#include <stdlib.h>

#define DXR_WORD_MASK 0777777777777ULL
#define DXR_HIGH_MASK (~DXR_WORD_MASK)
#define DXR_HALF_MASK 0777777U
#define DXR_MAGIC ((((unsigned long long)044) << 12) | (((unsigned long long)070) << 6) | 062ULL)
#define DXR_BSS_MASK 0177777U
#define DXR_F_PURE 0200000U
#define DXR_F_IMPURE 0400000U
#define DXR_LH(w) ((unsigned int)(((w) >> 18) & DXR_HALF_MASK))
#define DXR_RH(w) ((unsigned int)((w) & DXR_HALF_MASK))

struct dxr_file {
    unsigned long long *words;
    unsigned long long nwords;
};

static int read_word(FILE *f, unsigned long long *out, unsigned long long wordno)
{
    unsigned long long w;
    int i, c;

    w = 0;
    for (i = 0; i < 8; i++) {
        c = fgetc(f);
        if (c == EOF) {
            if (i != 0) {
                fprintf(stderr, "dxrcheck: partial container word at byte %llu\n",
                        wordno * 8ULL + (unsigned long long)i);
                return -1;
            }
            return 0;
        }
        w |= ((unsigned long long)(unsigned char)c) << (i * 8);
    }
    if ((w & DXR_HIGH_MASK) != 0) {
        fprintf(stderr, "dxrcheck: word %llu has nonzero container high bits\n", wordno);
        return -1;
    }
    *out = w;
    return 1;
}

static void usage(void)
{
    fprintf(stderr, "usage: dxrcheck [-q] [-d|--dump] [-r|--relocs] file.dxr\n");
}

static int load_file(const char *path, struct dxr_file *dxr)
{
    FILE *f;
    unsigned long long cap, w;
    int r;

    dxr->words = NULL;
    dxr->nwords = 0;
    cap = 0;
    f = fopen(path, "rb");
    if (!f) {
        perror(path);
        return 2;
    }
    for (;;) {
        r = read_word(f, &w, dxr->nwords);
        if (r < 0) {
            fclose(f);
            free(dxr->words);
            dxr->words = NULL;
            dxr->nwords = 0;
            return 1;
        }
        if (r == 0) break;
        if (dxr->nwords == cap) {
            unsigned long long ncap;
            unsigned long long *nw;

            ncap = cap ? cap * 2ULL : 64ULL;
            nw = (unsigned long long *)realloc(dxr->words, (size_t)(ncap * sizeof(dxr->words[0])));
            if (!nw) {
                fprintf(stderr, "dxrcheck: out of memory\n");
                fclose(f);
                free(dxr->words);
                dxr->words = NULL;
                dxr->nwords = 0;
                return 2;
            }
            dxr->words = nw;
            cap = ncap;
        }
        dxr->words[dxr->nwords++] = w & DXR_WORD_MASK;
    }
    if (ferror(f)) {
        perror(path);
        fclose(f);
        free(dxr->words);
        dxr->words = NULL;
        dxr->nwords = 0;
        return 2;
    }
    fclose(f);
    return 0;
}

static int bit_is_set(unsigned long long map, unsigned int bit)
{
    return (map & (1ULL << (35U - bit))) != 0;
}

static int validate(const struct dxr_file *dxr,
                    unsigned int *entry_out,
                    unsigned int *image_out,
                    unsigned int *bss_out,
                    unsigned int *reloc_out,
                    unsigned int *header_out)
{
    unsigned long long w0, w1, image_end, reloc_end;
    unsigned int entry, image_words, bss_words, reloc_words, header_words;

    if (dxr->nwords < 2) {
        fprintf(stderr, "dxrcheck: short header: got %llu words, need 2\n", dxr->nwords);
        return 1;
    }
    w0 = dxr->words[0];
    w1 = dxr->words[1];
    if (DXR_LH(w0) != DXR_MAGIC) {
        fprintf(stderr, "dxrcheck: bad magic at word 0: got %06o expected %06o\n",
                DXR_LH(w0), (unsigned int)DXR_MAGIC);
        return 1;
    }
    entry = DXR_RH(w0);
    image_words = DXR_LH(w1);
    bss_words = DXR_RH(w1) & DXR_BSS_MASK;
    if (image_words == 0U && bss_words == 0U) {
        fprintf(stderr, "dxrcheck: image and bss are both zero\n");
        return 1;
    }
    if ((image_words == 0U && entry != 0U) ||
        (image_words != 0U && entry >= image_words)) {
        fprintf(stderr, "dxrcheck: entry %06o outside image size %06o\n",
                entry, image_words);
        return 1;
    }
    reloc_words = (image_words + 35U) / 36U;

    /*
     * DXR1 has a two-word header.  DXR2 adds exactly one metadata word.
     * Diagnose files shorter than even DXR1 before deciding which header
     * form was intended; otherwise the detailed truncation checks below
     * are unreachable behind the exact-length test.
     */
    image_end = 2ULL + (unsigned long long)image_words;
    reloc_end = image_end + (unsigned long long)reloc_words;
    if (dxr->nwords < image_end) {
        fprintf(stderr, "dxrcheck: truncated image: got %llu words, need %llu "
                        "(2 header + %u image)\n",
                dxr->nwords, image_end, image_words);
        return 1;
    }
    if (dxr->nwords < reloc_end) {
        fprintf(stderr, "dxrcheck: truncated relocation bitmap: got %llu words, need %llu "
                        "(2 header + %u image + %u reloc)\n",
                dxr->nwords, reloc_end, image_words, reloc_words);
        return 1;
    }
    if (dxr->nwords > reloc_end + 1ULL) {
        fprintf(stderr, "dxrcheck: trailing words: got %llu words expected %llu or %llu\n",
                dxr->nwords, reloc_end, reloc_end + 1ULL);
        return 1;
    }
    if (dxr->nwords == reloc_end) {
        header_words = 2U;
    } else {
        header_words = 3U;
        if (DXR_LH(dxr->words[2]) > image_words) {
            fprintf(stderr, "dxrcheck: text size exceeds image size\n");
            return 1;
        }
        if (DXR_RH(dxr->words[2]) != 0647022ULL) {
            fprintf(stderr, "dxrcheck: bad DXR2 text metadata tag\n");
            return 1;
        }
    }
    *entry_out = entry;
    *image_out = image_words;
    *bss_out = bss_words;
    *reloc_out = reloc_words;
    *header_out = header_words;
    return 0;
}


static void relocs_file(const struct dxr_file *dxr,
                        unsigned int image_words,
                        unsigned int reloc_words,
                        unsigned int header_words)
{
    unsigned int i, b, off, nrel;

    nrel = 0;
    for (i = 0; i < reloc_words; i++) {
        unsigned long long map;

        map = dxr->words[header_words + image_words + i];
        for (b = 0; b < 36U; b++) {
            off = i * 36U + b;
            if (off >= image_words) break;
            if (bit_is_set(map, b)) nrel++;
        }
    }
    printf("RELOCS count=%u", nrel);
    for (i = 0; i < reloc_words; i++) {
        unsigned long long map;

        map = dxr->words[header_words + image_words + i];
        for (b = 0; b < 36U; b++) {
            off = i * 36U + b;
            if (off >= image_words) break;
            if (bit_is_set(map, b)) printf(" %06o", off);
        }
    }
    printf("\n");
}

static void dump_file(const struct dxr_file *dxr,
                      unsigned int entry,
                      unsigned int image_words,
                      unsigned int bss_words,
                      unsigned int reloc_words,
                      unsigned int header_words)
{
    unsigned int i, b, off;

    printf("DXR magic=DXR entry=%06o image=%06o bss=%06o reloc=%06o words=%llu purity=%s\n",
           entry, image_words, bss_words, reloc_words, dxr->nwords,
           (DXR_RH(dxr->words[1]) & DXR_F_IMPURE) ? "IMPURE" :
           ((DXR_RH(dxr->words[1]) & DXR_F_PURE) ? "PURE" : "UNKNOWN"));
    printf("HEADER 000000 %012llo ; DXR,,%06o\n", dxr->words[0], entry);
    printf("HEADER 000001 %012llo ; image,,bss\n", dxr->words[1]);
    for (i = 0; i < image_words; i++) {
        printf("IMAGE  %06o %012llo\n", i, dxr->words[header_words + i]);
    }
    for (i = 0; i < reloc_words; i++) {
        unsigned long long map;

        map = dxr->words[header_words + image_words + i];
        printf("RELOC  %06o %012llo", i, map);
        for (b = 0; b < 36U; b++) {
            off = i * 36U + b;
            if (off >= image_words) break;
            if (bit_is_set(map, b)) printf(" %06o", off);
        }
        printf("\n");
    }
}

int main(int argc, char **argv)
{
    const char *path;
    struct dxr_file dxr;
    unsigned int entry, image_words, bss_words, reloc_words, header_words;
    int quiet, dump, relocs, argi, rc;

    quiet = 0;
    dump = 0;
    relocs = 0;
    argi = 1;
    while (argi < argc && argv[argi][0] == '-') {
        if (argv[argi][1] == 'q' && argv[argi][2] == 0) {
            quiet = 1;
        } else if ((argv[argi][1] == 'd' && argv[argi][2] == 0) ||
                   (argv[argi][1] == '-' && argv[argi][2] == 'd' && argv[argi][3] == 'u' &&
                    argv[argi][4] == 'm' && argv[argi][5] == 'p' && argv[argi][6] == 0)) {
            dump = 1;
        } else if ((argv[argi][1] == 'r' && argv[argi][2] == 0) ||
                   (argv[argi][1] == '-' && argv[argi][2] == 'r' && argv[argi][3] == 'e' &&
                    argv[argi][4] == 'l' && argv[argi][5] == 'o' && argv[argi][6] == 'c' &&
                    argv[argi][7] == 's' && argv[argi][8] == 0)) {
            relocs = 1;
        } else {
            usage();
            return 2;
        }
        argi++;
    }
    if (argi + 1 != argc) {
        usage();
        return 2;
    }
    path = argv[argi];
    rc = load_file(path, &dxr);
    if (rc != 0) return rc;
    rc = validate(&dxr, &entry, &image_words, &bss_words, &reloc_words, &header_words);
    if (rc == 0) {
        if (dump) {
            dump_file(&dxr, entry, image_words, bss_words, reloc_words, header_words);
        } else if (relocs) {
            relocs_file(&dxr, image_words, reloc_words, header_words);
        } else if (!quiet) {
            printf("DXR image=%06o bss=%06o entry=%06o reloc=%06o\n",
                   image_words, bss_words, entry, reloc_words);
        }
    }
    free(dxr.words);
    return rc;
}
