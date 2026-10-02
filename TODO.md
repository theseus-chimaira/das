# DAS TODO

## 1. Bring KCC-built resident phases back under the image budget

The resident DAS architecture is working and the public driver is KCC-built,
but current KCC output for DAS1/DAS2 exceeds the 036000-word loader ceiling.
The accepted transitional build compiles those two phases with PDP-10 GCC and
keeps them below the stricter 034000-word regression budget.

Optimize KCC code generation and/or the phase compilation surface until both
DAS1 and DAS2 meet 034000 words when KCC-built.  Do not raise the loader limit
or merge the phases to hide this requirement.

## 2. Extend DAIMOS-resident regression coverage

The public DAS -> DAS1 -> DAS2 file-based phase chain now builds and runs under
DAIMOS, produces output identical to the development assembler for the target
probe, and executes the generated DXR successfully.

Extend that target regression to cover the remaining complex source paths:

- nested includes;
- macros and nested macro invocation;
- ".REPT", ".IRP", and ".IRPC" expansion;
- failure propagation and private ".D2R" cleanup on phase errors;
- larger source/output equivalence cases;
- measured runtime stack/high-water behavior in addition to the static process
  image budgets.

## 3. Evaluate optional phase-pipe transport

The file-based "DASIR2" transport is the proven low-memory path. Measure whether
using a DAIMOS pipe between DAS1 and DAS2 provides a useful speed improvement.
Add "-P" support to the DAIMOS-resident driver only if that benefit justifies
the additional code and resident-memory cost; otherwise retain the simpler
file transport.
