.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK  4096

INCLUDE debug.h
INCLUDE io.h
INCLUDE sqrt.h

.DATA
eyex WORD ? ;input variables
eyey WORD ?
eyez WORD ?
lookx WORD ?
looky WORD ?
lookz WORD ?
v_upx WORD ?
v_upy WORD ?
v_upz WORD ?

nx WORD ? ;solution variables
ny WORD ? 
nz WORD ? 
denomn WORD 0

vx WORD ?  
vy WORD ? 
vz WORD ? 
denomv WORD 0

ux WORD ? 
uy WORD ? 
uz WORD ? 
denomu WORD 0

num WORD ? ;debug
denom WORD ? ;debug

txt BYTE 40 DUP (0) ;print variables
txt_coor BYTE 40 DUP (0)
txt_letter BYTE "x: ", Lf, 0
prompt BYTE "Enter the d-coordinate of the ", 0
eyepoint BYTE "camera eyepoint:  ", Lf, 0
atpoint BYTE "look at point:  ", Lf, 0
uppoint BYTE "camera up direction:  ", Lf, 0
			
dotproduct MACRO x, x2, y, y2, z, z2, d ;solution result in d.
				mov ax, x
				imul ax, x2
				mov bx, y
				imul bx, y2
				mov cx, z
				imul cx, z2
				add ax, bx
				add ax, cx
				mov d, ax
			ENDM
					
input_Coordinates MACRO thing, x, y, z
				mov prompt+10, 'x'
				output prompt
				inputW thing, x
				mov prompt+10, 'y'
				output prompt
				inputW thing, y
				mov prompt+10, 'z'
				output prompt
				inputW thing, z
				output_Coordinates x, y, z
			ENDM
			
output_Coordinates	MACRO x, y, z
				output carriage
				mov txt_coor, '('
				itoa txt_coor+1, x
				mov txt_coor+7, ','
				itoa txt_coor+8, y
				mov txt_coor+14, ','
				itoa txt_coor+15, z
				mov txt_coor+21, ')'
				output txt_coor
				output carriage
			ENDM
			
output_Sol MACRO numx, denomx, numy, denomy, numz, denomz
				output txt_letter
				mov txt, '('
				itoa txt+5, denomx
				itoa txt+1, numx
				mov txt+7, '/'
				mov txt+11, ','
				itoa txt+16, denomy
				itoa txt+12, numy
				mov txt+18, '/'
				mov txt+22, ','
				itoa txt+27, denomz
				itoa txt+23, numz
				mov txt+29, '/'
				mov txt+33, ')'
				output txt
				output carriage
			ENDM

compute_vcoor MACRO a, b, sol ;n var = a, v_up var = b, sol = v?
				mov bx, eyex
				imul bx, b		
				mov ax, eyey
				imul ax, a
				add ax, bx
				mov sol, ax
			ENDM

cross_multiply MACRO a1, a2, b2, b1, sol ;used in computing u
				mov ax, a1
				imul ax, b2
				mov bx, a2
				imul bx, b1
				sub ax, bx
				mov sol, ax
			ENDM
			
.CODE
_start:
		mov num, -12345 ;test material
		mov denom, -12 ;test material
		
		output carriage
		input_Coordinates eyepoint, eyex, eyey, eyez
		input_Coordinates atpoint, lookx, looky, lookz
		input_Coordinates uppoint, v_upx, v_upy, v_upz
		
		;Do the Math???
		
		;compute n (E-A)
		mov ax, eyex 
		sub ax, lookx
		mov nx, ax
		mov ax, eyey
		sub ax, looky
		mov ny, ax
		mov ax, eyez
		sub ax, lookz
		mov nz, ax
		
		dotproduct nx, nx, ny, ny, nz, nz, denomn ; compute denominator for n 
		mov ax, denomn
		mov eyex, ax ;eye and look input mem addresses no longer needed, will be used for scalers in v
		sqrt denomn
		mov denomn, ax
		
		;compute v (???)
		
		dotproduct nx, v_upx, ny, v_upy, nz, v_upz, eyey ; compute first scaler
		;mov ax, eyey ; make it negative
		;imul ax, -1
		;mov eyey, ax
		neg eyey ; make it negative 
		
		compute_vcoor nx, v_upx, vx 
		compute_vcoor ny, v_upy, vy
		compute_vcoor nz, v_upz, vz
		
		dotproduct vx, vx, vy, vy, vz, vz, denomv ; compute denominator for v
		sqrt denomv
		mov denomv, ax
		
		;compute u (v x n)
		cross_multiply vy, vz, nz, ny, ux ;a1*b2 - a2*b1 
		cross_multiply vz, vx, nx, nz, uy
		cross_multiply vx, vy, ny, nx, uz
		
		dotproduct ux, ux, uy, uy, uz, uz, denomu ; compute denominator for v
		sqrt denomu
		mov denomu, ax
		
		output carriage ;display results
		output carriage
		mov txt_letter, 'u'
		output_Sol ux, denomu, uy, denomu, uz, denomu
		mov txt_letter, 'v'
		output_Sol vx, denomv, vy, denomv, vz, denomv
		mov txt_letter, 'n'
		output_Sol nx, denomn, ny, denomn, nz, denomn
		
		INVOKE  ExitProcess, 0  ; exit with return code 0
		
PUBLIC _start
END