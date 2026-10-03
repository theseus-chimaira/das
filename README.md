# DAIMOS DAS

DAS is the assembler used by the DAIMOS PDP-6/PDP-10 toolchain. It accepts a
GAS-like assembly language and produces directly loadable DAIMOS DXR images or
DOBJ relocatable objects for "DLINK".

Memory consumption is a primary design constraint. Symbols, literals, expanded
source, and intermediate records use bounded resident caches with scratch-file
backing. Normal DXR assembly is split into two sequential phases so both large
phases do not need to remain resident together.

## Programs

- "DAS" - public assembler command and phase driver.
- "DAS2" - private second-phase program used by development builds.
- "PDP10-DEC-NONE-AS" - compatibility name for "DAS".
- "DXRCHECK" - validates and inspects DXR files.
- "DXRCONVERT" - converts DXR images to simulator deposits and paper-tape forms.
- "S6FILTER" - converts text to DAIMOS S6REC/SIXBIT records.
- "S6TEXT" - encodes, decodes, and validates S6REC text.

## Building

"""SH
MAKE
"""

Installation uses "PDP10_PREFIX" when it is set, otherwise "PREFIX":

"""SH
MAKE INSTALL PDP10_PREFIX=/PATH/TO/PDP10-PREFIX
"""

The DAIMOS-resident public driver and private DAS1/DAS2 images are built from
this repository and consumed externally by the DAIMOS boot build:

"""SH
MAKE NATIVE PDP10_PREFIX=/PATH/TO/PDP10-PREFIX DAIMOS_REPO=/PATH/TO/DAIMOS
"""

Host-only POSIX support is selected with "DAS_HOST"; DAIMOS-resident builds
select "DAS_NATIVE".  The modes are mutually exclusive and one must be chosen.
The resident driver and both private phases are compiled by KCC.  The native
profile omits host-only optimizer machinery and phase-2-only decoding work so
each resident phase remains below the DAIMOS image/process budgets.  All
resident images use the current DAIMOS CRT0/syscall ABI and are linked by
DLINK.  See "STATUS.md" for measured phase sizes.

The native installation keeps only the public command on the normal optional
software PATH:

"/OPTION/BASE/EXEC/DAS"

The private resident phases are implementation details and live outside the
command namespace:

"/OPTION/BASE/LIBEXEC/DAS/DAS1"
"/OPTION/BASE/LIBEXEC/DAS/DAS2"

"DAS.SIXMD" is the authoritative command manual.  Host and native builds both
validate it with "sixmd-check" before producing assembler binaries.

The current phase images and their memory budgets are documented in
"STATUS.md".

## Assembler usage

The canonical public interface is:

"""TEXT
das [-C] [-B OR -K] [-A OR -S] [-F] [-M] [-L OUT.LABELS] -O OUTPUT INPUT
"""

Important options:

- "-C" emits DOBJ instead of DXR.
- "-B" restricts instructions to the base PDP-6/KA10 set.
- "-K" enables the corresponding kernel/I/O instruction mode.
- "-A" selects ordinary ASCII source input.
- "-S" selects S6REC source input.
- "-F" enables the peephole/folding optimizer in host builds.  Resident DAS
  accepts it for command-line compatibility but does not compile the optimizer.
- "-P" is implemented by the host assembler but is not implemented by the
  DAIMOS-resident driver.  Resident DAS uses the private file-backed DASIR2
  phase transport until a measured benefit justifies adding pipe transport.
- "-M" prints assembler memory/work statistics.
- "-L FILE" writes the label map.
- "-O FILE" selects the output file.

DAS uses uppercase short options only. "-O FILE" always selects the output
file.  Host DAS uses "-F" to enable optimization; resident DAS accepts "-F"
as a compatibility no-op. DAIMOS filesystem text is S6REC, so "-S" is the
normal source form when DAS runs under DAIMOS.

DOBJ mode is linked by "DLINK" from "PDP10-TOOLS". "-C" and "-F" may be used
together; optimized DOBJ output retains the required relocation records.

## Source language

DAS implements PDP-6/PDP-10 instructions, I/O instructions, generic "UUO"
syntax, sections, symbols, relocations, literals, includes, conditional
assembly, bounded GAS-style macros, bounded ".REPT" expansion, and bounded
GAS-style ".IRP"/".IRPC" iteration.

Integer syntax follows C/GAS conventions: decimal by default, legacy leading
zero for octal, and explicit "0O", "0X", and "0B" prefixes. "0D" remains
accepted as an explicit decimal form.

DAS accepts GAS-style "/* ... */" comments without interpreting comment markers
inside quoted text.

Detailed current implementation state and limitations are in "STATUS.md".
Remaining planned work is in "TODO.md".

## License

DAS is distributed under the MIT license. See "LICENCE".
