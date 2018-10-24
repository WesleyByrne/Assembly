.NOLIST
.386

EXTRN test_prime_proc:Near32

; test_prime will test each odd number up to the sqrt of candidate to determine if it is a prime number
; how would this change if you decide to pass in the array of all previous primes?
test_prime  	MACRO   candidate

						push candidate       ; pass by copy
						call test_prime_proc  

					ENDM

.NOLISTMACRO
.LIST