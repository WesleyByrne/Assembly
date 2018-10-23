; program to use the quadratic equation

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

.DATA

_a_           				WORD   ?
_b_           				WORD   ?
_c_           				WORD   ?

discrim      			WORD   ?
root1        				WORD   ?
root2        				WORD   ?

numer					WORD ?
denom					WORD ?

prompt_a      			BYTE   "Enter a: ", 0
prompt_b      			BYTE   "Enter b: ", 0
prompt_c      			BYTE   "Enter c: ", 0

answer1      			BYTE   "The first root is: ", 0
answer2      			BYTE   "The second root is: ", 0
complex_roots		BYTE   "Complex roots, good luck with that.", 0

INCLUDE debug.h
INCLUDE sqrt.h
;INCLUDE round.h

.CODE
_start:

;what does the macro overwrite?
divide		MACRO   dividend, divisor
                   mov ax, dividend
				   
				   ;mov numer, ax
				   ;mov denom, divisor
                   ;round numer, denom   ; corrected dividend is in ax
				   ;mov ax, numer
				   ;mov divisor, denom
				   
                   cwd
                   idiv divisor
				   ;where are the quotient and the remainder?
				   
                   mov dividend, ax
                ENDM

            ; sample roots 4, -6 (using the input file numbers)
            inputW prompt_a, _a_   ; 7
            outputW _a_
            inputW prompt_b, _b_   ; 14
            outputW _b_
            inputW prompt_c, _c_   ; -168
            outputW _c_
			
			;cmp aa, 0 ;(what if a is zero? can't use quadratic equation)
			;je linear

			mov ax, _b_
			imul ax
			mov cx, ax
			outputW cx ; b^2
			
			; cx contains b squared     
			
			mov ax, _a_
			mov bx, 4
			imul bx
			outputW ax ; 4a
			
			; ax contains 4a (result could be negative)			

			mov bx, _c_
			imul bx
			
			; ax contains 4ac (result could be negative)			

			sub ax, cx
			neg ax
			outputW ax ; b^2-4ac
			
			; ax contains the discriminant
			
			;cmp ax, 0  ;(what if discriminant < 0?  imaginary roots)
			;jl complex


            ; the sqrt is not very accurate, so roots should be integers
            sqrt ax        			; get the sqrt of the discriminant (discriminant assumed to be positive)
            mov  discrim, ax  	; store the square root of the discriminant (also still in ax right now)
			
			outputW ax ; sqrt b^2-4ac
			
			mov bx, _b_
			neg bx
			
			; bx contains -b (takes the 2s complement)			

			mov cx, _a_
			add cx, cx
			
			; cx contains 2a			

			add ax, bx
			mov root1, ax
			outputW root1
			
			; root1 contains -b + sqrt(discrim)			

			mov ax, discrim
			neg ax
			add ax, bx
			mov root2, ax
			outputW root2
			
			; root2 contains -b - sqrt(discrim)			

            divide root1, cx  	; result in root1
            divide root2, cx  	; result in root2
            
            output answer1
            outputW root1
            output answer2
            outputW root2
			
			;jmp done
			
;complex:
			;output complex_roots
			;jmp done
			
;linear:
			; bx + c = 0			x = -c/b
			;mov ax, cc
			;neg ax
			;mov bx, bb
			;cwd
			;idiv bx
			;mov root1, ax
			
			;output answer1
            ;outputW root1
			
;done:

            INVOKE ExitProcess, 0

PUBLIC _start
END
