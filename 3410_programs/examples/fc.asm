; program to convert Fahrenheit temperature to Fahrenheit Celsius
; uses formula  C = (F - 32)*5/9
; author:  R. Detmer
; date:  revised 9/97

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096 

.DATA
prompt      BYTE   "This program will convert a Fahrenheit temperature to the Celsius scale.", CR, LF, LF, "Enter Fahrenheit temperature:  ", 0
answer      BYTE   "The temperature in Celsius is: ", 0
numerator			WORD	0
denominator		WORD	0

INCLUDE debug.h
INCLUDE round.h

.CODE
_start:
			; Fahrenheit to Celsius
            inputW prompt, ax

            ; the arithmetic is done a little differently than in cf.asm
            sub    ax, 32           ; F - 32
            imul   ax, 5            ; (F - 32)*5
            mov    bx, 9

			mov numerator, ax
			mov denominator, bx
            round  numerator, denominator           ; the corrected dividend is in numerator
			mov ax, numerator
			mov bx, denominator

            cwd                     ; sign extend to prepare for division
            idiv   bx               ; (F - 32)*5/9 (quotient is in ax)

            output answer
            outputW ax

            INVOKE ExitProcess, 0
PUBLIC _start
            END

