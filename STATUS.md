# DAS current status

## 2026-11-23 v1881: single-process EXEC phase chain, RAM gate PASS

The native DAS launcher now `EXEC`s DAS1, and the internally marked
DAS1 invocation `EXEC`s DAS2 after successful phase-file generation.
This removes concurrent driver+DAS1 residence; standalone DAS1 still
performs only phase 1. Native symbol-index RAM was reduced from 128/13
bucket/cache entries to 64/7 without reducing spill-backed capacity.

Measured native image/BSS/process sizes (octal words, 02000 stack):

| Process | Image | BSS | Full process |
| --- | ---: | ---: | ---: |
| Launcher | 000571 | 000000 | 002571 |
| DAS1 | 034331 | 001423 | **037754** |
| DAS2 | 031037 | 001114 | 034153 |

The **steady-state maximum is 037754 octal = 16,364 decimal words**, 20
words below 16K. The new independent testkit gate and driver-to-DAS1,
DAS1-to-DAS2 `EXEC` launch-block tests pass. Host assembler suites pass.
Transactional kernel `EXEC` VM staging and an end-to-end native guest
run remain unverified. The separate, unchanged phase-image ceilings
034000/031000 still **FAIL** by 000331/000037, respectively. These must
be satisfied before final native acceptance is claimed.

## 2026-11-23 v1877: packed phase-2 opcode metadata, image gate OPEN

The complete 390-opcode table has been preserved while the 364 three-
through five-letter native phase-2 entries combine compressed name
keys and opcode/nonbase metadata. The 26 six-letter entries retain
exact separate decoding. The frozen independent 390-opcode test oracle
passes. Native image sizes are **034101** (DAS1) and **031037** (DAS2),
with BSS **001655/001346**. The strict 034000/031000 image ceilings
remain exceeded by **000101/000037**. Both full-process ceilings pass;
physical guest acceptance is still open.

## 2026-11-23 v1876: scratch path BSS and diagnostic fix; image gate OPEN

Native DAS1/DAS2 images are **034101/031117** octal words. BSS is now
**001655/001346** after replacing per-wordfile path buffers with a
shared output basename and immutable suffixes, and reusing the parser
temporary for include-directory lookup. Both full-process budgets pass:
DAS1 is 037756 and DAS2 is 034465 against 040000 with stack included.
Both strict image ceilings **034000/031000** still fail, by
**000101/000117** respectively. Invalid `.DIRECTIVE` handling now uses
a numeric native diagnostic in both phases instead of passing a string
pointer. Native mock tests cover path creation, cleanup, and boundary
conditions; physical guest acceptance remains OPEN.

## 2026-11-23 v1871: packed directive index; image/process gates OPEN

The current KCC/PDP-6 native DAS1/DAS2 phase images are
**034054/031076 octal words** with unchanged BSS **002103/001573**.
The unchanged 034000/031000 image limits still fail by 000054/000076.
Including the mandatory 02000-word reserved stack, DAS1's total
process size is **040157** (000157 over the 040000 ceiling), while
DAS2's process size is **034671** (within the process ceiling).

V1870 uses sequential character consumption for packed ASCII/SIXBIT
output. V1871 combines six five-bit directive letters and the six-bit
token tag in one 36-bit entry for each of 43 classified keywords.
The independent keyword/alias C89 oracle passes; existing host fast/full,
KCC, directive word/transport and OWGBP checks also pass. All native
guest acceptance remains open. The size profiler now reports total
process usage, not just image excess.

## 2026-11-23 v1868: native I/O and operand savings, size gate OPEN

Native DAS1/DAS2 images now measure **034114/031161** octal words,
with unchanged BSS **002103/001573** and unchanged mandatory ceilings
**034000/031000**. Both image limits still fail, by **000114/000161**.
V1865-v1868 remove redundant dotted mnemonic copying and effective
address trimming and consolidate native partial scratch-file transfers;
phase 2 also uses the common transfer path for output writes. The
experimental shared quotient/remainder sign correction was rejected
because it grew both images. Native guest acceptance remains open.

## 2026-11-23 v1864: further measured reductions, phase gate still OPEN

Current KCC/PDP-6 source-built phase images are **034135/031253**
(octal); unchanged BSS **002103/001573**. Both are still over their
mandatory image ceilings **034000/031000** by **000135/000253**.
Shared expression symbol returns, one double-comma search, and fixed
text-packing widths further reduced code from v1861 without adding BSS.
Full/fast host regressions, direct text/BYTE/LONG oracle, exhaustive
OWGBP selectors, and native comment-scanner contract pass; full native
DAIMOS guest acceptance remains open.

## 2026-11-23: Strict native phase image-size acceptance remains OPEN

The current installed KCC/PDP-6 profile differs from the historical
November 16 acceptance below. Source-backed size reductions through
v1861 brought native DAS1/DAS2 to **034173/031344 octal words** with
BSS **002103/001573**. Both remain oversized against their unchanged
**034000/031000** image ceilings by **000173/000344**. The source
changes share parsed directive operands, canonicalizer copies,
conditional classification, expression addition/subtraction, and
literal opcode normalization without increasing static BSS.

The independent directive oracle and existing host fast/full suites
cover the modified semantics. Neither this native image contract nor
an end-to-end native DAIMOS guest run has been accepted. The older
size-pass measurements below are historical and must not be used as
current release evidence. Further measured reductions are required.

## 2026-11-16: Native size gate passes; guest scratch access pending

The PDP-6 KCC `-O` comment reader now emits exactly **68 instructions**
against the unchanged 68-instruction limit (originally 94). An exact
matching quote delimiter clears quote state with one conditional XOR;
comment entry and exit use one increment/decrement respectively.
The `das_read_line` gate remains **133/136**.

Native DAS2 now keeps its relocation bitmap in a bounded `.DRM` scratch
wordfile. The old static array reserved 2,731 words in resident BSS to
handle the complete `0300000`-word DXR image ceiling. The replacement
uses the existing 64-word output buffer to initialize and append the
bitmap, and performs random-access read-modify-write only when setting
relocation bits. This preserves supported image sizes without a large
resident bitmap. Native size/phase ownership checks pass:

| Phase | Image (octal) | BSS (octal) | Process including stack (octal) |
| --- | --- | --- | --- |
| DAS1 | 033233 | 002032 | 037265 |
| DAS2 | 027751 | 001523 | 033474 |

All **nine fast and two full** independent DAS host suite entries pass.
The new native relocation mock checks maximum bitmap size, separated
relocation bits, late updates to earlier words and scratch I/O errors.
The full DAS1/DAS2 native phase-chain verifier passes.

**Full DAIMOS guest acceptance is still OPEN.** The guest-side preflight
can stat `/TEMP` as mode `01777` and can stat `/TEMP/TEST.S`, but opening
a new output/scratch file fails before running either DAS phase. This is
an independent guest filesystem/mount issue, not a passing end-to-end
native assembler test. Earlier historical guest-pass claims do not cover
this current image.


## 2026-11-16: Native comment-scanner size investigation

The current KCC PDP-6 `-O` build originally emitted 94 instructions for
`das_strip_c_comments`, failing the independent testkit's 68-instruction
limit. The source scanner now has one character-output path, one input
pointer, and signed quote/escape state instead of duplicate byte stores and
an escape flag. The measured function shrank to **72 instructions** (22
fewer); `das_read_line` remains at 133 against its 136-instruction limit.
These are function instruction counts, not native image-size measurements.

The independent testkit's host DAS suites pass with the source change:
eight fast and two full registered tests. Its input-reader fixtures now
initialize `cstate`, and its comment-reader tests exercise escaped quotes,
consecutive comments, and multiline transitions. The original and updated
source both pass the expanded comment-reader oracle.

**Native acceptance is still OPEN.** The existing 68-instruction limit has
not been raised or bypassed. A clean build of the full resident DAS
driver/phase chain and a current native guest execution PASS have not yet
been established for this revision. Earlier image-size and guest-acceptance
measurements below are historical, not fresh acceptance evidence.

## Build

The current source builds cleanly with the normal "MAKE" target using C99. The development build produces:

- "DAS"
- "DAS2"
- "PDP10-DEC-NONE-AS"
- "DXRCHECK"
- "DXRCONVERT"
- "S6FILTER"
- "S6TEXT"

## Assembly architecture

Normal DXR assembly is split into two sequential processes.

Phase 1 owns source input, comment filtering, includes, conditionals, macro, ".REPT", ".IRP", and ".IRPC" expansion, parsing, symbol definition, and pass 1.  It exports the
versioned "DASIR2" intermediate stream.

Private "DAS2" imports "DASIR2" and performs pass 2, final symbol resolution,
peephole optimization, relocation, and DXR output.

The default host transport is a private ".D2R" phase file.  Host "-P" carries
the same sequential intermediate stream over a pipe.  DOBJ output remains an
in-process path.  The DAIMOS-resident driver does not implement "-P" and uses
the private file-backed DASIR2 phase transport exclusively.

Resident work is bounded.  Large symbol, literal, repeated/macro-source, and
intermediate data use scratch backing rather than unbounded resident tables.
The assembler enforces a 65536-word work-memory ceiling.

## Two-phase DAIMOS images

The DAIMOS-resident command uses a small public driver plus private DAS1 and
DAS2 images. The driver runs the phases sequentially through the same versioned
"DASIR2" file format used by the development two-process path.

The public command is installed as "/OPTION/BASE/EXEC/DAS".  DAS1 and DAS2
are private implementation executables under "/OPTION/BASE/LIBEXEC/DAS" and
are invoked by absolute path; they never occupy the command-search namespace.

Current measured images with the standard 02000-word process stack are:

- public DAS driver, built by KCC: image 000745, BSS 000000, process 002745
  words;
- DAS1, built by KCC: image 033244, BSS 002032, process 037276 words;
- DAS2, built by KCC: image 027501, BSS 002342, process 034043 words.

The resident phase-image acceptance budget is 034000 words, below the DAIMOS
loader's 036000-word hard image ceiling.  Both KCC-built phases now satisfy
the stricter 034000 budget and remain below the 040000-word process ceiling
including BSS and the standard stack reserve.  The former transitional
PDP-10 GCC phase build is no longer used.  All three images use the current
DAIMOS CRT0/syscall interface and the DAS_NATIVE source path.

The native phase assembly rules depend on the selected KCC executable itself,
so installing a new compiler automatically regenerates DAS1/DAS2 assembly in
incremental builds even when the DAS sources are unchanged.

The resident shrink came from structural lifetime and representation changes
rather than removing assembler language support: the peephole/folding
optimizer remains host-only; phase 1 omits phase-2-only instruction decoding;
duplicate conditional, repetition, and macro line recognizers use the
canonical parser; identical error exits share cleanup tails; native byte
memory and numeric helpers implement only the contracts DAS uses; and the
spill-backed symbol index uses 128 resident hash heads.  KCC also shares one
fixed-frame return epilogue across early returns, eliminating repeated frame
teardown sequences throughout both phases.

During native bring-up this oversized-KCC path also exposed a KCC loop
strength-reduction bug: a derived pointer kept live across a general IF could
be spilled on only one branch and restored at the common continuation.  The
compiler now rejects that unsafe strength reduction while retaining the safe
terminal IF/CONTINUE form.  The full target DAS assemble/verify/execute
regression passes with the corrected compiler.

The final KCC-only transition exposed a second KCC correctness bug: object
optimization could push a MOVN backward through unsigned division/remainder,
incorrectly treating unsigned quotient/remainder as odd under negation.  DAS's
packed opcode lookup then selected JUMPN (0326) instead of MOVEI (0201) for
mnemonic index 319.  KCC now rejects that invalid P_UIDIV transformation; the
minimized unsigned-remainder regression passes on PDP-6, KA10, KI10, and KS10,
and the native DAS assemble/execute regression passes.

DAS1 uses 128 resident symbol hash heads. Symbol capacity remains spill-backed;
the smaller table is only a lookup accelerator and does not limit symbol
capacity. DAS2 keeps a separate 0100-word
DASIR2 line-decode buffer so source-record reads cannot overwrite pending
optimized output words.

The testkit boots DAIMOS, invokes the public DAS driver, runs DAS1 and DAS2,
assembles an S6REC source file, compares the produced DXR words with the
development assembler result, and executes the generated program successfully.

## Output formats

DXR is the default directly loadable output.

"-C" emits DOBJ1 relocatable objects with text, data, and BSS section identity,
global definitions, unresolved global imports, and RH18/LH18 relocation forms.
DOBJ objects are consumed by "DLINK".

DOBJ supports host-build "-F" optimization.  Optimizer word rewrites share the normal optimizer path
and update DOBJ relocation records when an operand relocation is replaced or
removed.  Rewrites that only change opcode or accumulator fields preserve the
existing object relocation.  DOBJ still rejects "-P" because it is not
processed through the normal two-phase DXR path.

DXR readers mask reserved purity flag bits from the BSS size.  Purity may be
pure, impure, or unknown; unknown is not treated as pure.

## Source features

Implemented source facilities include:

- PDP-6/PDP-10 memory-reference and I/O instructions.
- Generic "UUO OPCODE,EA" syntax.
- Strict base mode and kernel/I/O mode.
- Text, data, BSS, and compatible section aliases.
- ".GLOBAL"/".GLOBL", ".EXTERN", ".COMM", and ".LCOMM".
- ".EQU", ".SET", ".ORG", and ".ALIGN".
- ".WORD", ".LONG", ".BYTE", ".ASCII", ".ASCIZ", ".SIXBIT", "POINT", "GIW",
  and "OWGBP" data forms.
- ".INCLUDE".
- ".IF", ".IFDEF", ".IFNDEF", ".ELSE", and ".ENDIF".
- GAS-style ".MACRO"/".ENDM" with at most nine arguments and eight active macro
  invocations.
- ".REPT"/".ENDR" with counts from 0 through 65535.
- GAS-style ".IRP" list iteration and ".IRPC" character iteration.  Null
  value lists expand once with an empty substitution.
- ".REPT", ".IRP", and ".IRPC" share the eight-level active repetition limit.
- GAS-style block comments.
- C/GAS-style integer syntax in expression contexts.
- Optional label-map output.
- Optional memory/work reporting.

".IFDEF" and ".IFNDEF" use source-order visibility.  A later definition does
not make a symbol visible earlier in the source.

Macro definitions are source ordered.  Macro bodies and invocation argument
text use scratch backing.  Direct and indirect recursion are rejected.  Macro
substitution supports named parameters, positional "\1" through "\9", "\@",
"\()", and escaped backslash.  Nested macro definitions are not supported.

Repetition bodies and iterator specifications use the same scratch-backed
expansion store.  Includes are supported inside repeated bodies.  Conditionals
may not cross macro or repetition expansion boundaries.  Nested iterators may
shadow an outer iterator name; the outer value resumes after the inner ".ENDR".

## Optimizer

Host-build "-F" enables the bounded peephole/folding optimizer for DXR and
DOBJ output.  Resident DAS accepts "-F" for interface compatibility but does
not include the optimizer.  "-O FILE" selects the output path.
The optimizer includes local value/move/halfword folds, relocation-aware store
forwarding, JRST-to-next-label removal, and conditional jump/JRST inversion:

"""TEXT
JUMPN 1,L1
JRST L2
L1:
"""

May become the one-word equivalent "JUMPE 1,L2" followed by "L1:".  The
transform preserves DOBJ relocation identity.

A more general skip/JRST/one-instruction fold was investigated but is not
implemented: it requires an additional relocation-aware instruction lookahead
and insert/shift path for a small code-size return.  DAS deliberately keeps the
optimizer bounded and simple instead.  ADDI/SUBI-plus-jump to AOJ/SOJ is also
not a general peephole because PDP-6 flag semantics can differ.

## Known language limitations

".RADIX" is recognized but deliberately rejected.  DAS uses the normal C/GAS
numeric syntax instead.

The public phase driver and private phase images build against the current
DAIMOS ABI and are covered by an end-to-end DAIMOS execution regression.

Host-only POSIX support is explicitly selected with DAS_HOST while resident
builds use DAS_NATIVE; selecting neither profile is a build error.  KCC builds
the public driver and both private resident phases, and DLINK links them with
the current DAIMOS CRT0/syscall veneers.  No DAS source is copied into the
DAIMOS tree.

DAS.SIXMD is the authoritative command manual and is a mandatory validated
build input.
