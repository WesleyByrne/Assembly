; compute and display the first MAXNBRS prime numbers

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

MAXNBRS     EQU    500   ; size of number array

.STACK      4096

.DATA
primes      			WORD  MAXNBRS DUP (?)
candidate   		WORD  ?

INCLUDE test_prime.h

INCLUDE move_to_index.h
INCLUDE search.h

INCLUDE print_array.h
INCLUDE debug.h

.CODE
_start:

                lea ebx, primes

                mov WORD PTR [ebx], 2

                mov ecx, 0           ; prime numbers found count - 1
                mov candidate, 3     ; the next prime candidate

while_loop:

                ; set up for the next prime
                cmp cx, MAXNBRS
                je end_while

                test_prime candidate
                cmp   ax, -1

                je not_prime          ; the number is not prime
       
prime:

                ; obtain the correct index in the array
                inc cx                ; a new prime number was found, so increment prime count

                ; get the address in the prime numbers array based on prime count
				; address is returned in ebx
                move_to_index primes, cx  

                mov ax, candidate
                mov [ebx], ax        ; update the array with the new prime number
       
not_prime:

                ; whether a new prime number was found or not, increment candidate and continue
                add candidate, 2
                jmp while_loop

end_while:

				mov cx, MAXNBRS
                print_array primes, cx
				
				mov candidate, 1867
				
				binary_search primes, cx, candidate
				outputW ax

done:

            INVOKE ExitProcess, 0

PUBLIC _start
END                   
