# DAS TODO

## 0. Restore the native comment-scanner code-size gate

The PDP-6 KCC `-O` comment scanner is now 72 instructions, down from 94,
but still exceeds the strict 68-instruction testkit limit. Complete a
semantically equivalent reduction without changing the limit or creating
out-of-bounds byte pointers. Preserve the current host comment-reader,
input-format, and streaming tests; then rerun full native phase-image,
resident-budget, and DAIMOS guest acceptance. Do not claim the historical
native PASS for a new build until those checks actually run.

## 1. Extend DAIMOS-resident regression coverage

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

## 2. Evaluate optional phase-pipe transport

The file-based "DASIR2" transport is the proven low-memory path. Measure whether
using a DAIMOS pipe between DAS1 and DAS2 provides a useful speed improvement.
Add "-P" support to the DAIMOS-resident driver only if that benefit justifies
the additional code and resident-memory cost; otherwise retain the simpler
file transport.
