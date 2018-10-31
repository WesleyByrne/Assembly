; find the cube root of a float
; Author:  Mark Boshart
; Date:    10/16/2007

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE debug.h
INCLUDE float.h
INCLUDE cube_root.h
INCLUDE compare_floats.h

.STACK  4096

.DATA

prompt      BYTE   	"Enter a float: ", 0
result      	BYTE   		"The cube root is: ", 0
val         	BYTE    	10 DUP(?)
float       	DWORD   	?   ; REAL4 == DWORD if not given a starting value
root        	DWORD   	?   ; the macro will place the final result here
tol         	REAL4   	0.00001

f1				REAL4		15.71
f2				REAL4		15.7001

.CODE
_start:

		compare_floats f1, f2, tol
		outputW ax
		
		push f1
		push f2
		push tol
		call compare_floats_proc
		outputW ax
		
        output prompt
        input val, 10

        atof val, float  ; convert from ASCII to float, place in float
		
        ftoa float, WORD PTR 3, WORD PTR 10, text
        output text
        output carriage
		
		cube_root_loop float, tol, root

        ftoa root, WORD PTR 6, WORD PTR 10, text
        output result
        output text
		output carriage

        cube_root_rec float, tol, root

        ftoa root, WORD PTR 3, WORD PTR 10, text
        output result
        output text
        output carriage

        INVOKE  ExitProcess, 0

PUBLIC _start
END
