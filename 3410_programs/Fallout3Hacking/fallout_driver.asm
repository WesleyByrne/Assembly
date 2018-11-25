.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

INCLUDE io.h
INCLUDE fallout_procs.h

.DATA

MAX EQU 20
LEN EQU 13

CR EQU 0Dh   ; carriage return character
LF EQU 0Ah   ; linefeed character

str_array BYTE MAX*LEN DUP (?) ; string of all input words
num_strs WORD ?
pw_index WORD ?
char_matches WORD ?
_carriage    BYTE     CR, LF, 0
txt        BYTE     LEN DUP(?)

enterastring BYTE "Enter a string: ", 0
numberstringsentered BYTE "The number of strings entered is ", 0
enterindexpsw BYTE "Enter the index for the test password (1-based): ",0
entercharmatches BYTE "Enter the number of exact character matches:  ",0
prompt BYTE "Command?", 0
			
inputw          MACRO  prompt, location
		output prompt
		input txt, LEN
		output txt
		output _carriage
		atoi txt
		mov location, ax
	ENDM

.CODE
_start:

	lea ebx, str_array
	xor edx, edx
	cld
	fill_array:
		output enterastring
		input txt, LEN
		output txt
		output _carriage
		cmp [txt], 'x'
		je fin

		lea esi, txt
		mov edi, ebx 
		mov ecx, LEN 
		rep movsb
		add ebx, LEN

		inc edx
		jmp fill_array

	fin:
	mov num_strs, dx

	output _carriage
	output numberstringsentered
	itoa txt, num_strs
	output txt
	output _carriage
	output _carriage
	output_str_array str_array, LEN, num_strs

	filter_pws: 
		inputw enterindexpsw, pw_index
		inputw entercharmatches, char_matches
		analyze_array_matches str_array, LEN, num_strs, pw_index, char_matches
		mov num_strs, ax

		;output _carriage
		output_str_array str_array, LEN, num_strs
		
	cmp num_strs, 1
	jne filter_pws
	INVOKE  ExitProcess, 0  ; exit with return code 0
PUBLIC _start
END