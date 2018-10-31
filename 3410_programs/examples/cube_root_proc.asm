 .386
.MODEL FLAT

EXTRN compare_floats_proc : Near32
INCLUDE compare_floats.h
INCLUDE debug.h
INCLUDE float.h

root_rec    	EQU [ebp + 16]
x           		EQU [ebp + 12]
tol         		EQU [ebp + 8]
old         		EQU [ebp - 4]
root        		EQU [ebp - 8]

PUBLIC cube_root_proc, cube_root_rec_start

.DATA

; some convenient constants to have in memory
one     	REAL4   1.0
two     	REAL4   2.0
three   	REAL4   3.0

.CODE

cube_root_proc     PROC   NEAR32

        push   ebp           
        mov    ebp, esp
        pushd  0         
        pushd  0
        push eax
        pushfd

        ; make sure to leave the floating point stack in the same state as at the beginning

        fld1   ; load one onto the floating point stack
        fstp DWORD PTR root ; move it to the local var
        ;fldz   ; load zero onto the floating point stack
        ;fstp DWORD PTR old ; move it to the local var

whileLoop:

        ; store the current root in old
        fld DWORD PTR root
        fstp DWORD PTR old
        ; stack empty

        ; x/(root*root)
        fld DWORD PTR root
        fld st ; copy the root
        fmul
        fld DWORD PTR x
        fdivr ; st/st(1)

        ; 2*root
        fld two
        fld DWORD PTR root
        fmul

        ; add the two above terms together
        fadd

        ; divide the total by 3
        fld three
        fdiv ; st(1)/st
        
        fstp DWORD PTR root 
        ; stack should be empty now, with the new root stored in root
		
        ftoa DWORD PTR root, WORD PTR 3, WORD PTR 10, text
		output text
		output carriage
		
		; determine if root has significantly changed from old
        pushd root  ; f1      
        pushd old   ; f2
		pushd tol
        call compare_floats_proc
        
        cmp ax, 0
        jne whileLoop             ; if root has significantly changed from old, need another iteration

endWhile:

        ; the floating point stack should be in the same state as at the beginning

        ; return the result in ST 
        fld DWORD PTR root

        popfd
        pop 	eax              
        mov esp, ebp       
        pop 	ebp            
        ret    8               

cube_root_proc     ENDP

cube_root_rec_start     PROC   NEAR32

        push   ebp           
        mov    ebp, esp     
        push   eax         ; ax is used to compare floats in the recursive method
        pushfd              

        push one
        push DWORD PTR x
        push DWORD PTR tol
        call cube_root_rec

        popfd      
        pop eax            
        mov    esp, ebp       
        pop    ebp            
        ret    8               

cube_root_rec_start     ENDP

cube_root_rec     PROC   NEAR32

        push   ebp           
        mov    ebp, esp
        pushd  0              ; room for old_root local variable
        pushfd

        ; make sure to leave the floating point stack in the same state as at the beginning

        ; store the current root in old
        fld DWORD PTR root_rec
        fstp DWORD PTR old
        ; stack empty

        ; x/(root*root)
        fld DWORD PTR root_rec
        fld st ; copy the root
        fmul
        fld DWORD PTR x
        fdivr ; st/st(1)

        ; 2*root
        fld two
        fld DWORD PTR root_rec
        fmul

        ; add the two above terms together
        fadd

        ; divide the total by 3
        fld three
        fdiv ; st(1)/st
        
        fstp DWORD PTR root_rec
        ; stack should be empty now, with the new root stored in root_rec
		
		ftoa DWORD PTR root_rec, WORD PTR 3, WORD PTR 10, text
		output text
		output carriage

        compare_floats DWORD PTR root_rec, DWORD PTR old, DWORD PTR tol
        cmp ax, 0 ; need to save and restore eax!
        je result ; if |root - old| <= tol, we are done

        push DWORD PTR root_rec
        push DWORD PTR x
        push DWORD PTR tol
        call cube_root_rec
        jmp finish         ; returning from recursion, nothing left to do

        ; the floating point stack should be in the same state as at the beginning
result:

        ; return the result in ST 
        fld DWORD PTR root_rec

finish:

        popfd                  
        mov    esp, ebp       
        pop    ebp            
        ret    12               

cube_root_rec     ENDP

END
