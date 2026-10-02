# DAS current status

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

The default transport is a private ".D2R" phase file.  "-P" carries the
same sequential intermediate stream over a pipe.  DOBJ output remains an
in-process path.

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

- public DAS driver, built by KCC: image 000741, BSS 000000, process 002741
  words;
- DAS1, currently built by PDP-10 GCC: image 033106, BSS 002412, process
  037520 words;
- DAS2, currently built by PDP-10 GCC: image 030601, BSS 002722, process
  035523 words.

The resident phase-image acceptance budget is 034000 words, below the DAIMOS
loader's 036000-word hard image ceiling.  The same phase sources built by the
current KCC measured about 045673 words for DAS1 and 042514 words for DAS2,
which the loader cannot run.  The public driver therefore uses KCC while the
two large phases deliberately retain PDP-10 GCC as a transitional build input.
This is a code-size limitation, not a separate resident ABI: all three images
use the current DAIMOS CRT0/syscall interface and the DAS_NATIVE source path.

During native bring-up this oversized-KCC path also exposed a KCC loop
strength-reduction bug: a derived pointer kept live across a general IF could
be spilled on only one branch and restored at the common continuation.  The
compiler now rejects that unsafe strength reduction while retaining the safe
terminal IF/CONTINUE form.  The full target DAS assemble/verify/execute
regression passes with the corrected compiler.

DAS1 uses 256 resident symbol hash heads. Symbol capacity remains spill-backed;
the smaller table saves 0400 resident words versus the previous 512-head table
without removing assembler functionality. DAS2 keeps a separate 0100-word
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

DOBJ supports "-F" optimization.  Optimizer word rewrites share the normal optimizer path
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

"-F" enables the bounded peephole/folding optimizer for DXR and DOBJ output.  "-O FILE" selects the output path.
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
the small public resident driver.  Until KCC can keep the large phases below
the resident image budget, PDP-10 GCC compiles DAS1/DAS2 from the same
DAS_NATIVE source and DLINK links them with the current DAIMOS CRT0/syscall
veneers.  No DAS source is copied into the DAIMOS tree.

DAS.SIXMD is the authoritative command manual and is a mandatory validated
build input.
