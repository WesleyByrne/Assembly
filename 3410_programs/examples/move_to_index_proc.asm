.386
.MODEL FLAT

PUBLIC move_to_index_proc

						; the address will be returned in ebx (assumes a WORD array)
array_addr      	EQU [ebp + 12]   ; the address of index 0 of the array (DWORD)
index           		EQU [ebp + 10]    	; the requested index (WORD) 1-based
element_size		EQU [ebp + 8]

; pretend you need a local variable WORD
;local_var			EQU [ebp - 2]

.CODE

move_to_index_proc      PROC   Near32

     	push	ebp
		mov		ebp, esp
		;pushw 0
		push    eax		     
		pushf 			   

               ; get the address in the array (random access)
               mov ebx, array_addr
               mov eax, 0 
               mov ax, index
               
			   cmp WORD PTR element_size, 1
			   je move_to_index_done ; array elements are BYTEs
			   
			   add eax, eax       	; multiply ax by 2 for the correct address in the array

			   cmp WORD PTR element_size, 2 ; array elements are WORDs
			   je move_to_index_done
			   
			   add eax, eax ; array elements are DWORDs
			   
move_to_index_done:
               add ebx, eax

		popf			    
		pop		eax
        mov		esp, ebp	      ; skip over local variables 
		pop		ebp
		ret		8		      ; return, discarding parameters by moving ESP up 8 (4 + 2 + 2 bytes were added as parameters)

move_to_index_proc      ENDP

END                    
