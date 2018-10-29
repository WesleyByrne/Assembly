.386
.MODEL FLAT


PUBLIC	interpolate ; make procedure names visible outside the file containing them


INCLUDE debug.h
INCLUDE compute_b.h

array_addr EQU [EBP+16]
degree EQU [EBP+12]
arr_size EQU [EBP+8]

.CODE

interpolate 	PROC 	Near32

setup:

    push	ebp
	mov	ebp, esp	 ; establish stack frame (ebp contains a memory address)
                        
    pushd   0                ; add space on the stack for local variables

    push    ecx      ; save the registers used below (can't save them all as ax contains the index of the match)
    push    edx
	pushfd 			 ; save all flags (pushf needed, d for outputw)
                       
    xor     ecx, ecx

main_code:

    comp_b arr_size
    outputw ax


finish:

    ; of course, pop the items in the reverse order from push
	popfd			    ; restore flags and registers
    pop	    edx
    pop     ecx
	pop	    ebx

    mov     esp,ebp		; discard local variables

	pop	ebp
	ret	6		        ; return, discarding parameter

interpolate	ENDP

END