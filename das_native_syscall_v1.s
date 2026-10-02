; Minimal current-DAIMOS syscall veneers used by native DAS.
;
; Keep this list deliberately small: native DAS is a low-memory tool and does
; not need the complete userspace syscall veneer object.  C arguments arrive
; in AC1..AC3; direct monitor UUOs return their result in AC1.

        .text
        .globl dsys_exit
        .globl dsys_open
        .globl dsys_close
        .globl dsys_unlink
        .globl dsys_read_words
        .globl dsys_write_words
        .globl dsys_writechar
        .globl dsys_seek
        .globl dsys_run
        .globl dsys_wait

dsys_exit:             uuo 040,0(1)
                       popj 17,
dsys_open:             uuo 041,0(1)
                       popj 17,
dsys_close:            uuo 042,0(1)
                       popj 17,
dsys_unlink:           uuo 052,0(1)
                       popj 17,
dsys_read_words:       uuo 055,0(1)
                       popj 17,
dsys_write_words:      uuo 056,0(1)
                       popj 17,
dsys_writechar:        uuo 062,0(1)
                       popj 17,
dsys_run:              uuo 074,0(1)
                       popj 17,
dsys_wait:             uuo 075,0(1)
                       popj 17,

dsys_seek:             move 4,3
                       move 3,2
                       move 2,1
                       movei 1,032
                       uuo 077,0(1)
                       popj 17,
