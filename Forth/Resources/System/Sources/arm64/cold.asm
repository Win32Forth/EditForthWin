; Cold source, matching Mac forth_init_str. The .fth files are bytes in the
; image. kernel_init interprets them once. INCLUDE is not this path.
; vocemit.fth and the later Mac blobs stay out until this image is proven.

        AREA |.rdata|, DATA, READONLY

        EXPORT forth_init_str
        EXPORT forth_init_end

forth_init_str
        INCBIN  Forth/kernel1.fth
        INCBIN  Forth/kernel2.fth
        INCBIN  Forth/vocemit.fth
        INCBIN  Forth/app-output.fth
        INCBIN  Forth/app-points.fth
        INCBIN  Forth/vocsys.fth
        INCBIN  Forth/xref.fth
        INCBIN  Forth/boot-fix.fth
        DCB     0
forth_init_end

        END
