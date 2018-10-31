.NOLIST     ; turn off listing
.386

EXTRN compute_b:Near32

compute_b_call       	MACRO   addr, n, m
                   push addr
                   push n 
                   push m 
                   call compute_b
                ENDM

.LIST       