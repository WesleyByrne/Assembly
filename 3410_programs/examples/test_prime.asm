.386
.MODEL FLAT

INCLUDE sqrt.h

PUBLIC test_prime_proc

.CODE

                ; ax will contain 0 if candidate is prime
                ; ax will contain -1 if candidate is not prime

candidate       	EQU [ebp + 8]
root            		EQU [ebp - 2]

test_prime_proc       PROC   Near32

     	push	ebp
		mov		ebp, esp	  

        pushw	0                      ; make room for local variable

        push    ecx
        push    edx

		pushf 			     

                   mov ecx, 0           
                   mov cx, 2           ; the current number that will be divided into candidate (cx is the divisor)

                   sqrt WORD PTR candidate      ; be very careful here as candidate is register indirect!
                   mov root, ax                 ; store the sqrt
                   mov ax, candidate 

                   ; check easy cases
                   cmp ax, 1
                   jle not_prime
                   cmp ax, 4
                   jl prime

		while_loop:

                      ; see if a prime number has been detected (only need to compute up to the sqrt of candidate)
                      cmp cx, root
                      jg prime

                      ; division to see if the remainder is zero (not a prime number)
                      ; the divisor is already in cx
                      mov ax, candidate  ; the dividend is the candidate (ax, dx overwritten by division)
                      mov dx, 0          ; extend dividend for unsigned division
                      div cx
                      ; the remainder is in dx
                      cmp dx, 0
                      je not_prime
  
                      inc cx          	; prepare to divide by the next number
                      jmp while_loop

prime:

                   mov ax, 0          	; the candidate is a prime number
                   jmp done

not_prime: 

                   mov ax, -1         	; the candidate is not a prime number

done:

		popf			     

        pop	edx
        pop 	ecx

        mov	esp, ebp

		pop	ebp
		ret	2		; return, discarding parameters by moving ESP up 2 (2 bytes were added as parameters)

test_prime_proc      ENDP

END                    
