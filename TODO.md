# DAS TODO

## 0. Complete the native DAIMOS guest acceptance

The 68-instruction comment scanner and native 64-word scratch-backed
relocation bitmap have prior independent acceptance. The CURRENT
v1861 KCC-built DAS1/DAS2 phase images are 034173/031344 octal words,
still above the unchanged 034000/031000 ceilings by 000173/000344.
Continue shrinking both images without increasing BSS or relaxing the
limits, then repeat the strict phase-image checker and native guest
acceptance. Earlier phase-image passes were historical compiler states.
The full guest currently fails its independent `/TEMP` file-creation
preflight even though `/TEMP` is mode `01777` and the input exists.
Investigate the actual boot mount mode and D6FS write-service availability;
do not alter the size limits or weaken the guest contract. Once the
guest can create temporary files, execute DAS1, DAS2, validate the output
DXR word-for-word, and run the assembled program. Re-run native acceptance
before marking this item complete.

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
