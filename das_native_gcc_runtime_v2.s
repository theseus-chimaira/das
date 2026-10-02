; Minimal GCC PDP-10 runtime support required by native DAS.
;
; GCC emits a call to __main for C constructor initialization even when a
; program has no constructors.  Native DAS has none, so the correct runtime
; implementation is an immediate return.
;
; %BADL9 is GCC's 9-bit byte-pointer indexing table.  The generated native
; assembler phases reference it directly when indexing C char arrays.

        .text
        .globl __main
__main:
        popj 17,

        .data
        .globl %BADL9
        140000000003
        0
        100000000002
        0
        040000000001
        0
        0
%BADL9: 000000000000
        0
        737777777777
        0
        677777777776
        0
        637777777775
