.NOLIST
.386

EXTRN cube_root_proc : Near32
EXTRN cube_root_rec_start : Near32

; result in st(0)
cube_root_loop    MACRO val, tol, loc

							push val
							push tol
							call cube_root_proc 
							fstp loc

						ENDM

cube_root_rec     MACRO val, tol, loc

							push val
							push tol
							call cube_root_rec_start
							fstp loc

						ENDM

.NOLISTMACRO
.LIST