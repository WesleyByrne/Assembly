.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE debug.h

.STACK  4096

BUFFER_SIZE	EQU	30

.DATA
prompt1 	BYTE "Please enter your name:  ", 0
prompt2 	BYTE "Hello, "   
nametext 	BYTE BUFFER_SIZE DUP(?), 0

prompt3 	BYTE "Please enter your age:  ", 0
prompt4 	BYTE "Your age in hex:  ", 0
agehex  	BYTE 2 DUP(?), 0Dh, 0Ah, 0

convert_to_ASCII 	MACRO byte_to_convert, memory_location
               ; this macro won't work if A-F appear in the age in hex (i.e. someone 10 years old, etc)

 			   mov dl, byte_to_convert  		; two copies of the byte to convert
 			   mov dh, byte_to_convert  	; work separately on each hex digit

 			   shr dh, 4   							; get rid of lower 4 bits  
			   add dh, 30h 							; convert from a single digit hex integer to an ASCII digit
															; note this instruction only works for number to decimal digit conversion
															; conversion to A-F won't work

			   shl dl, 4   								; get rid of upper 4 bits
 			   shr dl, 4   								; fills upper 4 bits with zeroes
			   add dl, 30h

			   mov memory_location, dh
               mov memory_location + 1, dl ; arithmetic (+1) done by assembler (adjusts the mem addr in the instruction)
 			ENDM

.CODE
_start:
        output prompt1
        input nametext, BUFFER_SIZE
        output carriage

        output prompt2
        output carriage

        inputW prompt3, ax				; get input, convert the ASCII to a WORD, place result in ax (ah has no meaningful data)
        convert_to_ASCII al, agehex

        output prompt4
        output agehex
		
		; demonstrate little endian
		; need WORD PTR as agehex has been declared as a BYTE

		;mov ax, WORD PTR agehex
		;outputW ax
		
		;mov agehex, al
		;mov agehex + 1, ah
		;output agehex
		
		; PTR also needed in ambiguous cases
		;mov ebx, eax ; register direct
		;mov [ebx], eax ; register indirect
		;mov ebx, 11 ; immediate
		;mov [ebx + 77], eax ; displacement
		
		;mov ebx, 0 ; this crashes as I need the absolute address
		;mov WORD PTR [ebx], 0 ; instructions must be unambiguous
		
		;mov agehex + 1, '('
		
        INVOKE  ExitProcess, 0

PUBLIC _start
END
