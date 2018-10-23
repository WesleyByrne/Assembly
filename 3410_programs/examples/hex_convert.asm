.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096           

.DATA                   
prompt     	BYTE   "Enter a number to convert to hex:  ", 0
convert    	BYTE   4 DUP(?), 0

INCLUDE debug.h

; convert a byte register that contains a 0-15 to a hex digit
hex_digit  	MACRO  byte_register, mem_addr
					local digit

					cmp byte_register, 9
					jle digit
					add byte_register, 7h
digit:
					add byte_register, 30h
					mov mem_addr, byte_register
				
				ENDM

.CODE                              
_start:
			; words > approx. 4000 will generate exceptions (quotient doesn't fit)
            inputW prompt, ax

            lea ebx, convert
            add ebx, 3       	; start at the end of the array and move backwards
            mov cl, 4        	; counter to get all of the hex digits (four for a WORD)
            mov ch, 16

hex_loop:

            cmp cl, 0
            je done

            div ch		; ah:al
            ; remainder in ah

            ; convert the remainder to a hex digit
            hex_digit ah, [ebx]

            movzx ax, al     ; overwrite remainder, use new quotient as dividend

            sub ebx, 1
            dec cl

            jmp hex_loop

done:
            output convert   ; display the result

            INVOKE ExitProcess, 0  

PUBLIC _start                     

            END                 
