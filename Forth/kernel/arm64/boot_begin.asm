; First contribution to |.bootptr|, so the boot walk has a start address.

        AREA |.bootptr|, DATA, READONLY, ALIGN=3

        EXPORT bootptr_start
bootptr_start

        END
