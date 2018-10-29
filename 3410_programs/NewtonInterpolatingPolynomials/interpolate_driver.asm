.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

INCLUDE debug.h
INCLUDE io.h
INCLUDE sqrt.h
INCLUDE interpolate.h
INCLUDE float.h
INCLUDE sort_points.h
.DATA

array REAL4 20 DUP (?)
tol REAL4 0.0001
xcoor REAL4 ?
degree REAL4 ?

array_size WORD ?



p1 BYTE "Enter the x-coordinate of the desired interpolated y.", Lf, 0
p2 BYTE "Enter the degree of the interpolating polynomial.", Lf, 0
p3 BYTE "You may enter up to 20 points, one at a time.", Lf, 0
p4 BYTE "enter 'q' to quit", Lf, 0


;outputw_nocarriage    	MACRO   var
 ;                   itoa text, var
  ;                  output text
   ;             ENDM

;inputw_noprompt         MACRO  location
 ;                   input text, 8
  ;                  atoi text
   ;                 mov location, ax
    ;            ENDM

display_float_array MACRO to_display, sz
                    local display, done
                    output carriage
                    
                    xor ecx, ecx
                    lea ebx, to_display
                    outputw sz
                    display:
                        cmp cx, sz
                        je done
                 
                        mov ax, 3
                        mov dx, 6
                        ftoa [ebx], ax, dx, text 
                        
                        output text
                        output carriage
                        add ebx, 4
                        inc cx

                        jmp display
                    done:

                ENDM

.CODE
_start:

output p1
input text, 8
output text
output carriage
atof text,  xcoor

output p2
input text, 8
output text
output carriage
atof text,  degree


output p3
output p4

lea ebx, array
xor ecx, ecx
fill_array:
    input text, 8
    output text
    output carriage
    cmp [text], 'q'
    je fin

    atof text, DWORD PTR [ebx]
    add ebx, 4
    inc cx
    jmp fill_array

fin:
output carriage

mov ax, cx
cwd
mov bx, 2
idiv bx

mov array_size, ax

sort_points array, xcoor, tol, array_size
print_points array, array_size

interpolate_call array, array_size, degree

;non-header call: 
;push var
;call proc

PUBLIC _start
END