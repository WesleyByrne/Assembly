.NOLIST
.386

EXTRN interpolate:Near32

interpolate_call       	MACRO   array_name, array_size, degree

                    lea ebx, array_name
                    push ebx 
                    push degree
                    push array_size

                    call interpolate
                ENDM

.LIST       
