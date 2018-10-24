.386
.MODEL FLAT

INCLUDE move_to_index.h
INCLUDE debug.h

PUBLIC	binary_search_proc

first       					EQU     [ebp + 18] ; first index (for binary search)
last        					EQU     [ebp + 16] ; last index (for binary search)

nbr_array_addr    		EQU     [ebp + 12] ; the address of the array (address of index 0) (DWORD)
nbr_elements     		EQU     [ebp + 10] ; the number of elements in the array (WORD)
nbr_search         		EQU     [ebp + 8]  ; the number being searched for (the array holds WORDs) (WORD)

mid         					EQU     [ebp - 2]

.CODE


; Procedure to find a match in an array using a recursive binary search
; Parameters: 
;             1) first index (needed for binary search)
;             2) last index (needed for binary search)
;             3) address of array
;             4) the number of elements in the array
;             5) the number being searched for

; The index of the match is returned in ax
; If no match is found, -1 is returned in ax

binary_search_proc 	PROC 	Near32

setup:

     	push	ebp
		mov		ebp, esp	       
    
        push    ecx
		pushfd
		
			; show push vs. pushw (the 66 prefix byte is not placed in the instruction)
			;push cx
			;pushw cx
			
			; show the pitfall of a double square brackets
			;mov ax, [nbr_array_addr] ;won't work [[ebp + 12]]
			;outputW ax
			;mov ebx, nbr_array_addr
			;mov ax, [ebx]
			;outputW ax
		
        ; check for an empty array
        mov    	ax, 0           
        cmp    	ax, nbr_elements     ; in case there is nothing in the array, any number is automatically not found 
        jne     recurse

        mov ax, -1
        jmp done

recurse:

			mov cx, nbr_elements
			sub cx, 1
			pushw 0 ; first
			push cx ; last
			pushd nbr_array_addr
			pushw nbr_elements
			pushw nbr_search
			call binary_search_rec

done:

		popfd
        pop     	ecx
        mov     esp, ebp         
		pop		ebp
		ret		8		

binary_search_proc	ENDP

EXTRN move_to_index_proc:Near32

binary_search_rec 	PROC 	Near32

setup:

     	push		ebp
		mov			ebp, esp           
        pushw 	0 ; for the mid local variable              
		pushf

			; check for base case (first > last) (no match found)
			mov ecx, 0
			mov bx, first  
			mov cx, last
			cmp bx, cx
			
			jg no_match

			; compute mid from first and last
			add     cx, bx
			shr     cx, 1           ; divide by two to get mid (mid = (first + last)/2)
			; cx contains index mid

			; here I obtain the number in the array from index mid and compare with the number being searched for
			mov     mid, cx ; store mid in the local mid variable zero based
			
			pushd nbr_array_addr
			push cx
			call move_to_index_proc 
			;move_to_index DWORD PTR nbr_array_addr, cx

			; I can use eax here as all of the computations occur before recursion
			mov     ax, [ebx]

			cmp     ax, nbr_search
			je      found

			jl      search_later

search_earlier:

			; cx still contains mid
			sub cx, 1

			pushw first
			push cx
			pushd nbr_array_addr
			pushw nbr_elements
			pushw nbr_search
			call binary_search_rec

			jmp finish  ; returning after recursion, basically done

search_later:

			; cx still contains mid
			add cx, 1

			push cx
			pushw last
			pushd nbr_array_addr
			pushw nbr_elements
			pushw nbr_search
			call binary_search_rec

			jmp finish  ; returning after recursion, basically done

found:

			; move mid into ax and finish (mid was the index where a match was found)
			mov     ax, mid
			jmp     finish

no_match:

			mov	ax, -1           ; no match found

finish:

	popf
	mov     esp, ebp         
	pop		ebp
	ret		12		 

binary_search_rec	ENDP

linear_search_proc 	PROC 	Near32

setup:

     	push	ebp
		mov	ebp, esp	
                                                
		push    ebx		
        push    edx
		pushf 			


        mov   	ebx, nbr_array_addr   ; put the address of the beginning of the array in ebx in order to search through the array

        mov    	ax, 0           ; counter to keep track of index for the return
        cmp    	ax, nbr_elements     ; in case there is nothing in the array, any number is automatically not found 
        je     	not_found
                
while_loop:
            
                  mov dx, [ebx]     ; get the number out of the array (need to dereference with the brackets)
                  cmp dx, nbr_search       ; the number being searched for is on the stack
                  je  finish        ; the number asked for and the number at the current index are the same--  success! (index already in ax so just finish)
                  inc ax            ; advance the index counter
                  cmp ax, nbr_elements   ; compare the index and the size of the array
                  je  not_found     ; searched the whole array and didn't find a match
                  add ebx, 2        ; check the next integer in the array
                  jmp while_loop    ; back to search for another integer

not_found:

        mov	ax, -1           ; a match was not found

finish:

		popf			 
        pop	edx
		pop	ebx

        mov     esp, ebp         

		pop	ebp
		ret	8		 ; return, discarding parameters by moving ESP up 8 (4 + 2 + 2 bytes were added as parameters)

linear_search_proc	ENDP

END
