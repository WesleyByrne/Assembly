; horner's method
; author:  M. Boshart
; date:  07/29/2008

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

MAX_DEGREE EQU 5

.DATA

val         				WORD   ?
coeffs      				WORD   MAX_DEGREE DUP(0)

degree  				BYTE   ?
prompt_degree 		BYTE   "Enter the degree of the polynomial: ", 0
prompt_coeff     	BYTE   "Enter a coefficient: ", 0
prompt_val     		BYTE   "Enter an integer: ", 0

INCLUDE debug.h

.CODE

							; assumes a WORD array and a BYTE index
move_to_index   	MACRO array_name, index

								lea ebx, array_name
								mov al, index

								movzx eax, al
								add eax, eax
								add ebx, eax

							ENDM

horners     MACRO coeff_array_name, degree, value
               
			   local while_loop, done
			   
			   ; advance to the array index where the x^degree coefficient is stored
			   move_to_index  coeff_array_name, degree

			   mov eax, 0
			   mov ecx, 0
			   
               mov ax, [ebx]              ; get the first coefficient, place into ax
               mov cl, degree
			   inc cl ;to handle degree 0 correctly

while_loop:

                  dec cl
                  cmp cl, 0               ; are there any more coeffs to process?
                  je done

				  ;multiply by x
                  mov dx, value        ; have to move this back in each time through the loop
                  imul dx                 ; ignore high bits, result in ax (dx is overwritten)

				  ;obtain the address of the next coefficient
                  sub ebx, 2
				  
				  ;add the next coeff
                  mov dx, [ebx]
                  add ax, dx

                  jmp while_loop

done:

             ENDM
			 
_start:
			
			; obtain and store the degree of the polynomial
			mov ecx, 0  ; for the loop instruction
			inputW prompt_degree, cx
			outputW cx
			mov degree, cl
			inc cl  ; need to obtain degree + 1 coefficients
			; mov ebx, DWORD PTR coeffs (incorrect!)
			lea ebx, coeffs
			
get_coeffs_loop:
			
				inputW prompt_coeff, ax  ; read in the coeffs from the file
				outputW ax
				mov [ebx], ax 
				add ebx, 2
			loop get_coeffs_loop
			
            inputW prompt_val, ax           ; get user input and store in val
			outputW ax							; the user indicates the value used to evaluate the polynomial
			mov val, ax
            horners coeffs, degree, val

            outputW ax              

            INVOKE ExitProcess, 0

PUBLIC _start

END

