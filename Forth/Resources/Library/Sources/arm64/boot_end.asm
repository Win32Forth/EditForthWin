; Last contribution to |.bootptr|, so the boot walk has an end address.

        AREA |.bootptr|, DATA, READONLY, ALIGN=3

        EXPORT bootptr_end
bootptr_end

        END
