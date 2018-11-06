.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

INCLUDE io.h
INCLUDE interpolate.h
INCLUDE float.h
INCLUDE sort_points.h

CR          EQU    0Dh   ; carriage return character
LF          EQU    0Ah   ; linefeed character

.DATA

array REAL4 20 DUP (?)
tol REAL4 0.0001
xcoor REAL4 ?
degree REAL4 ?

array_size WORD ?

carriage    BYTE     CR, LF, 0
text        BYTE     13 DUP(?)

p1 BYTE "Enter the x-coordinate of the desired interpolated y.", Lf, 0
p2 BYTE "Enter the degree of the interpolating polynomial.", Lf, 0
p3 BYTE "You may enter up to 20 points, one at a time.", Lf, 0
p4 BYTE "enter 'q' to quit", Lf, 0
r1 BYTE "The result:             ", cr, lf, 0

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

    atof text, REAL4 PTR [ebx]
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

interpolate_call array, array_size, xcoor, tol, degree

ftoa eax, 3, 7, text
lea esi, text
lea edi, r1 
add edi, 12   
mov ecx, 8 
rep movsb  

output carriage
output r1
output carriage

PUBLIC _start
END