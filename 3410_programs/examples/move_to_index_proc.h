 .NOLIST
.386

EXTRN move_to_index_proc:Near32

; array_index is assumed to be a WORD
; array_element_size is either [1, 2, or 4] and is assumed to be an unambiguous WORD
; array indexing is assumed to be 0-based

; ebx will contain the requested array address
move_to_index_array_name   MACRO   array_name, array_index, array_element_size
							
							lea ebx, array_addr_name
							push ebx
							
							push array_index
							push array_element_size
							
							call move_to_index_proc
								
							ENDM
						
; ebx will contain the requested array address
move_to_index_array_addr   MACRO   array_addr, array_index, array_element_size
							
							push array_addr
							
							push array_index
							push array_element_size
							
							call move_to_index_proc
								
							ENDM

.NOLISTMACRO
.LIST