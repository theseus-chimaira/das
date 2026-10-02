/* dxrconvert - host converter for DAIMOS DXR V1 container files. */
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
#define DXR_WORD(lh,rh) ((((unsigned long long)(lh) & DXR_HALF_MASK) << 18) | ((unsigned long long)(rh) & DXR_HALF_MASK))

struct dxr_file {
    unsigned long long *words;
    unsigned long long nwords;
    unsigned int entry;
    unsigned int image_words;
    unsigned int bss_words;
    unsigned int reloc_words;
    unsigned int header_words;
    unsigned int text_words;
};

enum out_mode { MODE_NONE, MODE_SIMH, MODE_RIM, MODE_PT, MODE_PDP6_READIN };

static void usage(void)
{
    fprintf(stderr, "usage: dxrconvert (--simh|--rim|--pt|--pdp6-readin) -b base_octal [-g] in.dxr out\n");
}

static int streq(const char *a, const char *b)
{
    while (*a && *b && *a == *b) { a++; b++; }
    return *a == 0 && *b == 0;
}

static unsigned int octal_arg(const char *s)
{
    unsigned int v;

    v = 0;
    if (!*s) return 0;
    while (*s) {
        if (*s < '0' || *s > '7') return 0;
        v = (v << 3) + (unsigned int)(*s - '0');
        s++;
    }
    return v & DXR_HALF_MASK;
}

static int read_word(FILE *f, unsigned long long *out, unsigned long long wordno)
{
    unsigned long long w;
    int i, c;

    w = 0;
    for (i = 0; i < 8; i++) {
        c = fgetc(f);
        if (c == EOF) {
            if (i != 0) {
                fprintf(stderr, "dxrconvert: partial container word at byte %llu\n",
                        wordno * 8ULL + (unsigned long long)i);
                return -1;
            }
            return 0;
        }
        w |= ((unsigned long long)(unsigned char)c) << (i * 8);
    }
    if ((w & DXR_HIGH_MASK) != 0) {
        fprintf(stderr, "dxrconvert: word %llu has nonzero container high bits\n", wordno);
        return -1;
    }
    *out = w & DXR_WORD_MASK;
    return 1;
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
    if (!f) { perror(path); return 2; }
    for (;;) {
        r = read_word(f, &w, dxr->nwords);
        if (r < 0) { fclose(f); free(dxr->words); dxr->words = NULL; return 1; }
        if (r == 0) break;
        if (dxr->nwords == cap) {
            unsigned long long ncap;
            unsigned long long *nw;

            ncap = cap ? cap * 2ULL : 64ULL;
            nw = (unsigned long long *)realloc(dxr->words, (size_t)(ncap * sizeof(dxr->words[0])));
            if (!nw) {
                fprintf(stderr, "dxrconvert: out of memory\n");
                fclose(f);
                free(dxr->words);
                dxr->words = NULL;
                return 2;
            }
            dxr->words = nw;
            cap = ncap;
        }
        dxr->words[dxr->nwords++] = w;
    }
    fclose(f);
    return 0;
}

static int validate(struct dxr_file *dxr)
{
    unsigned long long image_end, reloc_end;

    if (dxr->nwords < 2) {
        fprintf(stderr, "dxrconvert: short DXR header\n");
        return 1;
    }
    if (DXR_LH(dxr->words[0]) != DXR_MAGIC) {
        fprintf(stderr, "dxrconvert: bad DXR magic\n");
        return 1;
    }
    dxr->entry = DXR_RH(dxr->words[0]);
    dxr->image_words = DXR_LH(dxr->words[1]);
    dxr->bss_words = DXR_RH(dxr->words[1]) & DXR_BSS_MASK;
    if (dxr->image_words == 0) {
        fprintf(stderr, "dxrconvert: image_words is zero\n");
        return 1;
    }
    if (dxr->entry >= dxr->image_words) {
        fprintf(stderr, "dxrconvert: entry outside image\n");
        return 1;
    }
    dxr->reloc_words = (dxr->image_words + 35U) / 36U;

    /* Diagnose truncation against the two-word DXR1 form first. */
    image_end = 2ULL + (unsigned long long)dxr->image_words;
    reloc_end = image_end + (unsigned long long)dxr->reloc_words;
    if (dxr->nwords < image_end) {
        fprintf(stderr, "dxrconvert: truncated image\n");
        return 1;
    }
    if (dxr->nwords < reloc_end) {
        fprintf(stderr, "dxrconvert: truncated relocation bitmap\n");
        return 1;
    }
    if (dxr->nwords > reloc_end + 1ULL) {
        fprintf(stderr, "dxrconvert: trailing words after relocation bitmap\n");
        return 1;
    }
    if (dxr->nwords == reloc_end) {
        dxr->header_words = 2U;
        dxr->text_words = 0U;
    } else {
        dxr->header_words = 3U;
        dxr->text_words = DXR_LH(dxr->words[2]);
        if (dxr->text_words > dxr->image_words) {
            fprintf(stderr, "dxrconvert: text size exceeds image size\n");
            return 1;
        }
        if (DXR_RH(dxr->words[2]) != 0647022ULL) {
            fprintf(stderr, "dxrconvert: bad DXR2 text metadata tag\n");
            return 1;
        }
    }
    return 0;
}

static int bit_is_set(unsigned long long map, unsigned int bit)
{
    return (map & (1ULL << (35U - bit))) != 0;
}

static int make_abs_image(const struct dxr_file *dxr,
                          unsigned int base,
                          unsigned long long **image_out)
{
    unsigned long long *image;
    unsigned int i, b, off;

    image = (unsigned long long *)calloc(dxr->image_words, sizeof(image[0]));
    if (!image) {
        fprintf(stderr, "dxrconvert: out of memory\n");
        return 2;
    }
    for (i = 0; i < dxr->image_words; i++) image[i] = dxr->words[dxr->header_words + i] & DXR_WORD_MASK;
    for (i = 0; i < dxr->reloc_words; i++) {
        unsigned long long map;

        map = dxr->words[dxr->header_words + dxr->image_words + i];
        for (b = 0; b < 36U; b++) {
            off = i * 36U + b;
            if (off >= dxr->image_words) break;
            if (bit_is_set(map, b)) {
                unsigned int ea;

                ea = (DXR_RH(image[off]) + base) & DXR_HALF_MASK;
                image[off] = (image[off] & 0777777000000ULL) | (unsigned long long)ea;
            }
        }
    }
    *image_out = image;
    return 0;
}

static int write_simh(FILE *out, const struct dxr_file *dxr,
                      const unsigned long long *image, unsigned int base,
                      int go_flag)
{
    unsigned int i;

    for (i = 0; i < dxr->image_words; i++) {
        fprintf(out, "deposit %06o %012llo\n", (base + i) & DXR_HALF_MASK, image[i] & DXR_WORD_MASK);
    }
    if (go_flag) fprintf(out, "go %06o\n", (base + dxr->entry) & DXR_HALF_MASK);
    return ferror(out) ? 2 : 0;
}

static int rim_byte(FILE *out, unsigned int b)
{
    return fputc((int)(0200U | (b & 077U)), out) == EOF ? -1 : 0;
}

static int write_rim_word(FILE *out, unsigned long long word)
{
    int shift;

    word &= DXR_WORD_MASK;
    for (shift = 30; shift >= 0; shift -= 6) {
        if (rim_byte(out, (unsigned int)((word >> shift) & 077ULL)) < 0) return -1;
    }
    return 0;
}

static int write_rim10b(FILE *out, const struct dxr_file *dxr,
                        const unsigned long long *image, unsigned int base,
                        int go_flag)
{
    unsigned int i, count, origin;
    unsigned long long iowd, checksum, jrst;

    /* Standard RIM10B bootstrap header. */
    if (write_rim_word(out, DXR_WORD(0777762U, 0)) < 0) return 2;
    for (i = 0; i < 14U; i++) if (write_rim_word(out, 0) < 0) return 2;

    count = dxr->image_words;
    origin = base & DXR_HALF_MASK;
    iowd = DXR_WORD((unsigned int)((-((int)count)) & (int)DXR_HALF_MASK), (origin - 1U) & DXR_HALF_MASK);
    checksum = iowd;
    if (write_rim_word(out, iowd) < 0) return 2;
    for (i = 0; i < count; i++) {
        checksum = (checksum + (image[i] & DXR_WORD_MASK)) & DXR_WORD_MASK;
        if (write_rim_word(out, image[i]) < 0) return 2;
    }
    if (write_rim_word(out, checksum) < 0) return 2;
    if (go_flag) {
        jrst = (((unsigned long long)0254U) << 27) | ((unsigned long long)((base + dxr->entry) & DXR_HALF_MASK));
        if (write_rim_word(out, jrst) < 0) return 2;
    }
    return ferror(out) ? 2 : 0;
}

static int write_pdp6_readin(FILE *out, const struct dxr_file *dxr,
                             const unsigned long long *image, unsigned int base,
                             int go_flag)
{
    unsigned int i;
    unsigned long long datai, jrst;

    /*
     * PDP-6 executable read-in stream.  The bootstrap reads a word into
     * scratch memory and executes it.  Each DATAI PTR,address instruction
     * therefore causes the following tape word to be deposited at address.
     */
    for (i = 0; i < dxr->image_words; i++) {
        datai = 0710440000000ULL |
                (unsigned long long)((base + i) & DXR_HALF_MASK);
        if (write_rim_word(out, datai) < 0) return 2;
        if (write_rim_word(out, image[i]) < 0) return 2;
    }
    if (go_flag) {
        jrst = (((unsigned long long)0254U) << 27) |
               (unsigned long long)((base + dxr->entry) & DXR_HALF_MASK);
        if (write_rim_word(out, jrst) < 0) return 2;
        /* The PDP-6 read-in bootstrap pipelines one complete word ahead.
         * Supply that harmless drain word instead of depending on an EOF
         * event being reported as DONE by a simulator. */
        if (write_rim_word(out, 0) < 0) return 2;
    }
    return ferror(out) ? 2 : 0;
}

int main(int argc, char **argv)
{
    const char *infile, *outfile;
    enum out_mode mode;
    unsigned int base;
    int base_set, go_flag, argi, rc;
    struct dxr_file dxr;
    unsigned long long *image;
    FILE *out;

    mode = MODE_NONE;
    base = 0;
    base_set = 0;
    go_flag = 1;
    argi = 1;
    while (argi < argc && argv[argi][0] == '-') {
        if (streq(argv[argi], "--simh")) mode = MODE_SIMH;
        else if (streq(argv[argi], "--rim")) mode = MODE_RIM;
        else if (streq(argv[argi], "--pt")) mode = MODE_PT;
        else if (streq(argv[argi], "--pdp6-readin")) mode = MODE_PDP6_READIN;
        else if (streq(argv[argi], "-b") || streq(argv[argi], "--base")) {
            argi++;
            if (argi >= argc) { usage(); return 2; }
            base = octal_arg(argv[argi]);
            base_set = 1;
        } else if (streq(argv[argi], "-g") || streq(argv[argi], "--go")) go_flag = 1;
        else if (streq(argv[argi], "--no-go")) go_flag = 0;
        else { usage(); return 2; }
        argi++;
    }
    if (mode == MODE_NONE || !base_set || argi + 2 != argc) {
        usage();
        return 2;
    }
    infile = argv[argi];
    outfile = argv[argi + 1];
    rc = load_file(infile, &dxr);
    if (rc != 0) return rc;
    rc = validate(&dxr);
    if (rc != 0) { free(dxr.words); return rc; }
    rc = make_abs_image(&dxr, base, &image);
    if (rc != 0) { free(dxr.words); return rc; }
    out = fopen(outfile, mode == MODE_SIMH ? "w" : "wb");
    if (!out) {
        perror(outfile);
        free(image);
        free(dxr.words);
        return 2;
    }
    if (mode == MODE_SIMH) rc = write_simh(out, &dxr, image, base, go_flag);
    else if (mode == MODE_PDP6_READIN)
        rc = write_pdp6_readin(out, &dxr, image, base, go_flag);
    else rc = write_rim10b(out, &dxr, image, base, go_flag);
    if (fclose(out) != 0 && rc == 0) rc = 2;
    free(image);
    free(dxr.words);
    return rc;
}
