.NOLIST
.386

EXTRN interpolate:Near32

interpolate_call       	MACRO   array_name, array_size, xcord, toler, degree

                    lea ebx, array_name
                    push ebx 
                    push array_size
                    push xcord
                    push toler
                    push degree

                    call interpolate
                ENDM

.LIST       
