; program to average some grades together
; author:  Mark Boshart
; date:  5/12/2006

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

NUMGRADES   EQU    4 

.STACK  4096

.DATA
grade1      WORD   ?
grade2      WORD   ?
grade3      WORD   ?
grade4      WORD   ?

quotient    WORD   ?
remainder   WORD   ?

prompt1     BYTE   "Enter the first grade:  ", 0
prompt2     BYTE   "Enter the second grade: ", 0
prompt3     BYTE   "Enter the third grade:  ", 0
prompt4     BYTE   "Enter the fourth grade: ", 0
result     	BYTE   "The average is: ", 0

decimal     BYTE   ".", 0
feedback	BYTE   50 DUP(?)

INCLUDE debug.h

.CODE
_start:

            inputW prompt1, grade1  ; note that there can't be too many grades (multiply the sum by 100 and using WORDs)
			outputW grade1
            inputW prompt2, grade2
			outputW grade2
            inputW prompt3, grade3
			outputW grade3
            inputW prompt4, grade4
			outputW grade4

            mov    eax, 0
            add    ax, grade1       	; sum up the four grades and store the result in eax
            add    ax, grade2       
            add    ax, grade3
            add    ax, grade4 

            mov    	bx, 100          		; want results correctly rounded to two decimal places
            mul    	bx 		    			; multiply the sum of the grades by 100
            mov    	bx, NUMGRADES 

            mov dx, 0                     ; sign extend the dividend to dx:ax
            div bx                  			; unsigned division since grades are assumed positive (quotient in ax)

            ; extract out the pieces before and after the decimal point
            mov bx, 100					; 100 will generate two decimal places
            cwd                     			; mov dx, 0 perhaps better here since the sign is positive
            div bx
            mov quotient, ax        	; store the quotient in "quotient" (move from ax)
            mov remainder, dx       	; store the remainder in "remainder" (move from dx)

            ; display the inputted grades
            mov feedback, "1"
            mov feedback + 1, ":"
            itoa feedback + 2, grade1 ; 6 spaces to display the integer
            mov feedback + 8, ","
            mov feedback + 9, " "
            mov feedback + 10, "2"
            mov feedback + 11, ":"
            itoa feedback + 12, grade2
            mov feedback + 18, ","
            mov feedback + 19, " "
            mov feedback + 20, "3"
            mov feedback + 21, ":"
            itoa feedback + 22, grade3
            output feedback
            output carriage

            ; output the result in ddd.dd form
            itoa feedback + 3, remainder
            itoa feedback, quotient
            mov feedback + 6, '.'
			mov feedback + 9, 0
            output feedback + 4 ;skip the leading zeroes
			output carriage

            INVOKE ExitProcess, 0
PUBLIC _start
            END
