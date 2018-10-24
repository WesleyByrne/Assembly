.386
.MODEL FLAT

PUBLIC	sqrt_proc ; make procedure names visible outside the file containing them

number     EQU     [ebp + 8] 
larger       	EQU     [ebp - 2] 
smaller      EQU     [ebp - 4]

.CODE

; Procedure to find the square root of a number
; Parameters: 1) number to find the square root of (assumed positive)
; The square root is returned in ax

sqrt_proc 	PROC 	Near32

setup:

     	push	ebp
	mov	ebp, esp	 ; establish stack frame (ebp contains a memory address)
                        
        pushd   0                ; add space on the stack for local variables

	push    ebx		 ; save the registers used below (can't save them all as ax contains the index of the match)
        push    ecx
        push    edx
	pushf 			 ; save all flags
                       
        mov     cx, 0

whileLessThan:

           ; progress is stored in cx
           inc  cx
           mov  ax, cx
           mul  ax              ; the result is in ax 
           cmp  ax, number      ; see if the number squared is still less than the parameter
                             
           jl   whileLessThan

loopFinished:

        ; try to improve the result by selecting whether result or (result - 1) is closer to the answer 
        ; check the "larger" number
        mov ax, cx
        mul ax
        mov bx, number
        sub ax, bx
        mov larger, ax ; (ax - bx) -> larger

        ; check the "smaller" number
        dec cx
        mov ax, cx
        mul ax
        sub bx, ax
        mov smaller, bx ; (bx - ax) -> smaller

        ; determine which is closer and report the best value
        mov bx, larger
        mov dx, smaller
        cmp bx, dx
        mov ax, cx ; cx still contains result - 1
        jge finish ; if "larger" is larger than "smaller", report result - 1 (don't increment ax)
        inc ax

finish:

        ; of course, pop the items in the reverse order from push
	popf			; restore flags and registers
        pop	edx
        pop     ecx
	pop	ebx

        mov     esp,ebp		; discard local variables

	pop	ebp
	ret	2		; return, discarding parameter

sqrt_proc	ENDP

END

