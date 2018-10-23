; program to implement gcd
; author:  R. Detmer
; date:  revised 5/18/2007 M. Boshart

.386
.MODEL FLAT

INCLUDE debug.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.STACK  4096             ; reserve 4096-byte stack

.DATA                    ; reserve storage for data

prompt1     BYTE   "Enter the first number:  ", 0
prompt2     BYTE   "Enter the second number:  ", 0
dividend    WORD   ?
remainder   WORD   ?
gcd         WORD   ?
result	    BYTE   "The greatest common divisor is ", 0


.CODE                               ; start of main program code
_start:

            ; obtain two numbers greater than zero

whileBadInput1:

            inputW prompt1, gcd
            cmp gcd, 0
            jle whileBadInput1

whileBadInput2:

            inputW prompt2, remainder
            cmp remainder, 0
            jle whileBadInput2

whileRemainderNotZero:

            ; gcd := num1
            ; remainder := num2
            ; while (remainder != 0)
            ;    dividend := gcd
            ;    gcd := remainder
            ;    remainder := dividend mod gcd
            ; end while
            
            cmp remainder, 0                    ; while remainder != 0
            je done

            mov ax, gcd                         ; dividend := gcd
            mov dividend, ax
 
            mov ax, remainder                   ; gcd := remainder
            mov gcd, ax

            mov ax, dividend
            mov dx, 0				; clear dx as the remainder will be placed here
            mov bx, gcd
            div bx
            mov remainder, dx                   ; remainder := dividend mod gcd (gcd is the divisor)
            jmp whileRemainderNotZero

done:

            output result
            outputW gcd
            output carriage

            INVOKE ExitProcess, 0   ; exit with return code 0

PUBLIC _start                       ; make entry point public

            END                     ; end of source code

