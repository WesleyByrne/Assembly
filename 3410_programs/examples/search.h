.NOLIST
.386

EXTRN binary_search_proc:Near32
EXTRN linear_search_proc:Near32

binary_search	 MACRO   nbrArrayName, nbrElts, nbr
                   push ebx
				   
                      lea ebx, nbrArrayName
                      push ebx
                      mov ebx, 0
                      push nbrElts
                      push nbr
                      call binary_search_proc
					  
                   pop ebx
				   
                 ENDM

linear_search	 MACRO   nbrArrayName, nbrElts, nbr
                   push ebx
				   
                      lea ebx, nbrArrayName
                      push ebx
                      mov ebx, 0
                      push nbrElts
                      push nbr
                      call linear_search_proc
					  
                   pop ebx
                 ENDM
				 
.NOLISTMACRO
.LIST