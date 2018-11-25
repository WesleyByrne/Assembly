.386
.MODEL FLAT

PUBLIC	output_str_proc, analyze_str_proc

include io.h
include str_utils.h

retr_addr MACRO ind, len, dest
	push eax
	push edx
	xor eax, eax
	mov ax, ind
	mul len
	sub ax, len
	mov dest, eax
	mov eax, [ebp+18]
	add dest, eax
	pop edx
	pop eax
	ENDM

swap_positions MACRO
	inc cx
	retr_addr cx, WORD PTR [ebp+14], [ebp-8]
	push ebx
	push [ebp-8]
	call swap_str_proc
	ENDM


.code

;char_matches [ebp+8], pw_index [ebp+10], num_strs [ebp+12], length [ebp+14], str_array [ebp+18]; new list size store in eax
analyze_str_proc 	PROC 	Near32 
	setup:
		push ebp
		mov	ebp, esp                 ; establish stack frame (ebp contains a memory address)
		pushd 0						 ; main addr (last addr, with pw in it)
		pushd 0                      ; tmp addr
		pushw 0						 ; swap last pw back boolean
		push ebx					 ; save registers
		push ecx
		push edx
		pushfd                       ; save all flags
	code:
		
		xor ecx, ecx ;new str_array length, and curr. will be saved in eax
		xor edx, edx ;index
		mov ebx, [ebp+18]
		retr_addr WORD PTR [ebp+10], WORD PTR [ebp+14], [ebp-8] ; pw_index
		retr_addr WORD PTR [ebp+12], WORD PTR [ebp+14], [ebp-4] ; last string index
		mov ax, [ebp+10]
		dec ax
		mov [ebp+10], ax ; decrement pw_index to 0-based
		
		push [ebp-4]
		push [ebp-8]
		call swap_str_proc ; move pw_index to last string position

		push [ebp-8]
		push [ebp-4]
		call num_char_matches ; compare final word with pw_index
	
		cmp ax, [ebp+8] 
		jne _code
		mov WORD PTR [ebp-10], 1 ; set "boolean" to true if char matches

	_code:
		cmp dx, WORD PTR [ebp+10] ;skip pw_index position
		je no_match
	
		push ebx
		push [ebp-4]
		call num_char_matches
		cmp ax, [ebp+8]
		jne no_match
		swap_positions ; mov current string to new array position if matches align

	no_match:
		add ebx, [ebp+14]
		inc dx
		cmp dx, [ebp+12]
		jb _code

	mov_final_pw:
		cmp WORD PTR [ebp-10], 1 ; if "boolean" is true, 
		jne finish				 ; mov the last word to the last position in the new string
		swap_positions
		
	finish:                         ; pop the items in the reverse order from push
		mov eax, ecx
		popfd
		pop edx			            ; restore flags and registers
		pop ecx
		pop ebx
		mov esp,ebp                 ; discard local variables
		pop	ebp
		ret	12		                ; return, discarding parameter
analyze_str_proc ENDP

num_char_matches 	PROC 	Near32 ;source [ebp+8], dest [ebp+12]; result in eax
	setup:
		push ebp
		mov	ebp, esp                 ; establish stack frame (ebp contains a memory address)
		push ecx 					 ; save flags and registers
		push esi
		push edi
		pushfd 
	code:
		push [ebp+8]
		call strlen_proc
		mov cx, ax ;retr string length
		inc cx ;+1 for str matching
		xor eax, eax
		mov esi, [ebp+8] 
		mov edi, [ebp+12] ;set strings
		jmp loop_str

	equa:
		inc ax ;num char matches
	loop_str:
		repne cmpsb
		inc cx ;fix position before loop decrements cx
		loop equa
		
	finish:                         ; pop the items in the reverse order from push
		popfd 					    ; restore flags and registers
		pop edi						
		pop esi
		pop ecx
		mov esp,ebp                 ; discard local variables
		pop	ebp
		ret	8		                ; return, discarding parameter
num_char_matches ENDP

swap_str_proc 	PROC 	Near32 ;source [ebp+8], dest [ebp+12]
	setup:
		push ebp
		mov	ebp, esp                 ; establish stack frame (ebp contains a memory address)
		pushad						 ; save all registers
		pushfd                       ; save all flags
	code:
		xor eax, eax
		push [ebp+8]
		call strlen_proc
		mov ecx, eax
		mov edi, [ebp+8]
		mov esi, [ebp+12]
	while_loop:
		lodsb ;load tmp char
		dec esi ;reset source position
		xchg edi, esi
		movsb ;mov dest char to source
		xchg esi, edi
		dec edi ;reset dest position
		stosb ;store tmp char
		cmp ecx, 0
		dec ecx
		jne while_loop
		mov edi, [ebp+8]
		mov esi, [ebp+12]
	finish:                         ; pop the items in the reverse order from push
		popfd			            ; restore flags and registers
		popad
		mov esp,ebp                 ; discard local variables
		pop	ebp
		ret	8		                ; return, discarding parameter
swap_str_proc ENDP

output_str_proc 	PROC 	Near32 ; num_strs [ebp+8], length [ebp+10], str_array [ebp+14]
	setup:
		push ebp
		mov	ebp, esp                 ; establish stack frame (ebp contains a memory address)
		push DWORD PTR 0A0Dh         ; carriage return [ebp-4]
		pushad						 ; save all registers
		pushfd                       ; save all flags
	code:
		mov cx, [ebp+8]
		mov ebx, [ebp+14]
		outputloop:
			cmp ecx, 0
			je finish
			output [ebx]
			output [ebp-4]
			add ebx, [ebp+10]
			dec cx
			jmp outputloop
	finish:                         ; pop the items in the reverse order from push
		popfd			            ; restore flags and registers
		popad
		mov esp,ebp                 ; discard local variables
		pop	ebp
		ret	10		                ; return, discarding parameter
output_str_proc	ENDP

END