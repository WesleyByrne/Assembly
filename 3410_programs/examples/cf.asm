; program to convert Celsius temperature to Fahrenheit
; uses formula  F = (9/5)*C + 32 = (9*C + 160)/5
; author:  R. Detmer
; date:  revised 9/97

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

.DATA
prompt      BYTE   "This program will convert a Celsius temperature to the Fahrenheit scale.", CR, LF, LF, "Enter Celsius temperature:  ", 0
answer      BYTE   "The temperature in Fahrenheit is: ", 0

numerator			WORD	0
denominator		WORD	0

INCLUDE debug.h
INCLUDE round.h

.CODE
_start:
			; Celsius to Fahrenheit
            inputW prompt, ax

			mov bx, 9
			mul bx
			
			add ax, 160
			mov bx, 5
			
			mov numerator, ax
			mov denominator, bx
            round  numerator, denominator           ; the corrected dividend is in numerator
			mov ax, numerator
			mov bx, denominator
			
			cwd					;sign extend ax to dx::ax (minimizes quotient will not fit issue)
			idiv bx 				;div bl can cause a problem if the quotient doesn't fit in al
			
			;movsx ax, al ;necessary if the divisor had been a BYTE (and need to use outputW)

            output answer
            outputW ax

            INVOKE ExitProcess, 0
			
			PUBLIC _start
END
