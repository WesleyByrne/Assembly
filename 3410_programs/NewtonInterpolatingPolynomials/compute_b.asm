.386
.MODEL FLAT

PUBLIC	compute_b

;there's a fld1 for 1.0, and fldz for 0.0
array_addr EQU [ebp + 16] 
n EQU [ebp+12]
m EQU [ebp+8]
tmp_float EQU [ebp - 4] 
a_val EQU [ebp - 8]
b_val EQU [ebp - 12]

retr789 MACRO index 
        xor eax, eax
        mov ebx, index
        mov eax, 8
        imul ebx
        mov edi, eax
        mov ebx, array_addr
        ENDM

retrieve_x MACRO index ;store in eax
        retr789 index
        mov eax, [ebx+edi] 
        ENDM

retrieve_y MACRO index 
        retr789 index
        mov eax, [ebx+edi+4] 
        ENDM

call_computeb MACRO n_, m_
        push array_addr
        push n_ 
        push m_ 
        call compute_b 
ENDM
.CODE

compute_b 	PROC 	Near32

setup:
        push	ebp
	mov	ebp, esp	 ; establish stack frame (ebp contains a memory address)
                        
        pushd   0                
        pushd   0                
        pushd   0                ; add space on the stack for local variables

	push    ebx		 ; save the registers used below (can't save them all as ax contains the index of the match)
        push    ecx
        push    edx
	pushf 			 ; save all flags
                       
        mov     cx, 0

codestuff:
        xor eax, eax
        mov ax, m
        cmp ax, n 
        je f_x 

        inc ax

        call_computeb n, eax
        mov a_val, eax
        
        xor eax, eax
        mov ax, n 
        dec ax

        call_computeb eax, m
        mov b_val, eax

        fld REAL4 ptr a_val
        fld REAL4 ptr b_val

        fsub

        retrieve_x n 
        mov tmp_float, eax
        fld REAL4 ptr tmp_float

        retrieve_x m
        mov tmp_float, eax
        fld REAL4 ptr tmp_float


        fsub
        fdiv 

        fstp REAL4 PTR tmp_float
        mov eax, tmp_float
        
        jmp finish
f_x:
        ;retrieve array's coordinate y value and return it 
        retrieve_y n
        
finish:

        ; of course, pop the items in the reverse order from push
	popf			; restore flags and registers
        pop	edx
        pop     ecx
	pop	ebx

        mov     esp,ebp		; discard local variables

	pop	ebp
	ret	12		; return, discarding parameter

compute_b	ENDP

END

