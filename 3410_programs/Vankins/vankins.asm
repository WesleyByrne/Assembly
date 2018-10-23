.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

INCLUDE debug.h
INCLUDE io.h
INCLUDE sqrt.h

.DATA

row WORD ?
col WORD ?
rowcol WORD ?

tmp WORD ?
curr_row WORD ? 
tmp_col WORD ? 

down WORD ?
right WORD ?

vankins_mile WORD 100 DUP (?)
solution_grid WORD 100 DUP (?)

solution_values BYTE 20 DUP (?)

outputW_nocarriage    	MACRO   var
                    itoa text, var
                    output text
                ENDM

inputW_noprompt         MACRO  location
                   input text, 8
                   atoi text
                   mov location, ax
                ENDM

display_array MACRO arr
                    local disp_vankins, linefeed_print, lf_done, done

                    xor ecx, ecx
                    lea ebx, arr
                    mov dx, col
                    inc dx
                    disp_vankins:
                        cmp dx, 0
                        dec dx
                        je linefeed_print
                    lf_done:
                        cmp cx, rowcol
                        jae done
                        outputW_nocarriage [ebx]
                        inc cx
                        add ebx, 2
                        jmp disp_vankins
                    linefeed_print: 
                        output carriage
                        mov dx, col
                        jmp lf_done
                    done:
                        output carriage
                ENDM

move_to_index MACRO arr, row_, col_ ;retrieves index of specified position of the 2D array
                                    ;stored in ax register
                    xor eax, eax
                    mov ax, row_
                    dec ax
                    imul col
                    
                    mov bx, col_
                    dec bx
                    
                    add ax, bx
                    add ax, ax

                    lea ebx, arr
                    add ebx, eax
                ENDM

getElement MACRO matrix_addr, row_, col_, loc ;(loc is where to place the number pulled from the matrix, WORD register or .DATA variable)
                    local checkrht, jmprht
                    mov ax, col
                    inc ax
                    cmp col_, ax
                    je checkrht
                    move_to_index matrix_addr, row_, col_
                    mov ax, [ebx]
                    mov loc, ax
                    jmp jmprht
                    checkrht:
                        mov ax, 0
                        mov loc, ax
                    jmprht:
                ENDM
				
setElement MACRO matrix_addr, row_, col_, loc ;(loc is where to obtain the number to be placed into the matrix, WORD register or .DATA variable)
                    move_to_index matrix_addr, row_, col_
					mov ax, loc
                    mov [ebx], ax
                ENDM

fill_solution_grid MACRO 
                    local optimal, cycle_through_row, highdown, highright, done, sol_, jmprht, checkrht
                    ;start on last row, last column
                    ;fill solution grid from 
                    
                    xor ecx, ecx
                    mov ax, row
                    inc ax
                    mov curr_row, ax

                    optimal:
                        mov ax, curr_row
                        dec ax
                        cmp ax, 0
                        jbe done
                        mov curr_row, ax 
                        mov cx, col
                        
                        cycle_through_row:

                            ;retrieve down first
                            mov ax, curr_row
                            inc ax
							mov tmp, ax
							mov tmp_col, cx
                            getElement solution_grid, tmp, tmp_col, down ;25

                            ;retrieve right next
							inc cx
							mov tmp_col, cx
                            getElement solution_grid, curr_row, tmp_col, right
							dec cx
							mov tmp_col, cx
                            ;compare and fill solution grid
                            mov ax, down
                            cmp ax, right
                            jl highright
                            highdown:
                                mov ax, down
                                jmp sol_

                            highright:
                                mov ax, right

                            sol_:
                            mov tmp, ax
                            
							getElement solution_grid, curr_row, tmp_col, dx
                            add tmp, dx
                            setElement solution_grid, curr_row, tmp_col, tmp
                            dec cx
							
                            jne cycle_through_row
                            jmp optimal

                    done:
                ENDM


display_optimal MACRO
                    local done, cyclesol, movedown, moveright, moveon
                    mov curr_row, 1
                    mov tmp_col, 1
                    lea ebx, solution_grid

                    lea ecx, solution_values
                    cyclesol:
                    
                        mov ax, row
                        cmp curr_row, ax
                        jg done
                        mov ax, col
                        cmp tmp_col, ax
                        jg done
                        
                        mov ax, curr_row
                        inc ax
                        mov tmp, ax
                        getElement solution_grid, tmp, tmp_col, down
                        mov ax, tmp_col
                        inc ax
                        mov tmp, ax
                        getElement solution_grid, curr_row, tmp, right
                        mov ax, down
                        cmp ax, right
                        jl moveright
                        
                        movedown:
                        
                            mov al, 'd'
                            mov [ecx], al
                            mov ax, curr_row
                            inc ax
                            mov curr_row, ax
                            jmp moveon

                        moveright:
                            mov al, 'r'
                            mov [ecx], al
                            mov ax, tmp_col
                            inc ax
                            mov tmp_col, ax

                        moveon:
                        add ecx, 1
                        jmp cyclesol
                        
                done:
                output solution_values
                output carriage
                ENDM
.CODE
_start:
;read input from file
;recieve # of rows followed by # of columns
inputW_noprompt row
inputW_noprompt col

mov ax, row
imul col
mov rowcol, ax

;fill vankins_mile with input numbers until it reaches row*col
xor eax, eax
xor ecx, ecx
lea ebx, vankins_mile
fill_vankins_mile:
    inputW_noprompt ax
    mov [ebx], ax
    inc cx
    add ebx, 2
    cmp cx, rowcol
    jb fill_vankins_mile


lea eax, vankins_mile
lea edx, solution_grid
xor ecx, ecx
mov cx, rowcol

copy_for_solution_grid:
    mov  ebx, [eax]
    mov [edx], ebx
    add eax, 2
    add edx, 2
    dec ecx
    jne copy_for_solution_grid

fill_solution_grid
display_array vankins_mile
display_array solution_grid
display_optimal

PUBLIC _start
END