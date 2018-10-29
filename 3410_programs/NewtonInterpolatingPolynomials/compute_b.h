.NOLIST     ; turn off listing
.386

EXTRN compute_b:Near32

comp_b       	MACRO   number
                   push number 
                   call compute_b
                ENDM

.LIST       