.NOLIST
.386

EXTRN sqrt_proc:Near32

; the sqrt is returned in ax
; number is assumed to be a WORD

sqrt       	MACRO   number
                   push number      ; use pushw/pushd ONLY if there is ambiguity about the size
                                    ; this will depend on what is passed to the MACRO
                                    ; use the convention that a register will be used rather than an immediate
                                    ; then there will not be any ambiguity and push will suffice
                   call sqrt_proc
                ENDM

.LIST       
