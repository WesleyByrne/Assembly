.386
.MODEL FLAT


PUBLIC	interpolate ; make procedure names visible outside the file containing them

INCLUDE compute_b.h

; array_name, array_size, xcord, toler, degree
array_addr EQU [EBP+22]
array_size EQU [EBP+20]
xcoor EQU [EBP+16]
tol EQU [EBP+12]
degree EQU [EBP+8]
total EQU [EBP-4]
tmp_float EQU [EBP-8]

retr7t89 MACRO index 
        xor eax, eax
        mov ebx, index
        mov eax, 8
        imul ebx
        mov edi, eax
        mov ebx, array_addr
        ENDM
        
retrieve_x MACRO index ;store in eax
        retr7t89 index
        mov eax, [ebx+edi] 
        ENDM

retrieve_y MACRO index 
        retr7t89 index
        mov eax, [ebx+edi+4] 
        ENDM

.CODE

interpolate 	PROC 	Near32

setup:

    push	ebp
	mov	ebp, esp	 ; establish stack frame (ebp contains a memory address)
                        
    pushd   0                ; add space on the stack for local variables
    pushd   0                ; add space on the stack for local variables

    push    ecx      ; save the registers used below (can't save them all as ax contains the index of the match)
    push    edx
	pushfd 			 ; save all flags (pushf needed, d for outputw)
                       
    xor     ecx, ecx

main_code:

    xor ecx, ecx ; zero counter and set to degree
    mov total, ecx ; zero total
    fld REAL4 PTR degree
    fistp DWORD PTR degree ;converted into int value to use as counter value
    mov cx, degree

    fld REAL4 PTR total
    
    interpolate_loop:
        cmp cx, 0
        je loop_done
        
        compute_b_call array_addr, ecx, 0
        mov tmp_float, eax
        fld REAL4 PTR tmp_float
        
        
        fadd ;add bn to total

        fld REAL4 PTR xcoor 

        dec cx
        retrieve_x ecx
        mov tmp_float, eax
        fld REAL4 PTR tmp_float

        fsub ;(x-x(n-1))
        fmul ;total * (x-x(n-1))

        jmp interpolate_loop

    loop_done:
        retrieve_y 0
        mov tmp_float, eax
        fld REAL4 PTR tmp_float
        fadd 

        fstp REAL4 PTR tmp_float
        mov eax, tmp_float

finish:

    ; of course, pop the items in the reverse order from push
	popfd			    ; restore flags and registers
    pop	    edx
    pop     ecx
	pop	    ebx

    mov     esp,ebp		; discard local variables

	pop	ebp
	ret	14		        ; return, discarding parameter

interpolate	ENDP

END