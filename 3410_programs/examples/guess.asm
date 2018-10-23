; program to implement number guessing game
; author:  R. Detmer
; date:  revised 5/18/2007 M. Boshart

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

MAX_GUESS    		EQU    	5
LOW_RANGE			EQU		1
HIGH_RANGE		EQU		1000

.STACK  4096

.DATA

secret                   			WORD   ?

prompt_player_1          	BYTE   "Player 1, please enter a secret number (between LOW and HIGH): ", 0
clear                    			BYTE   25 DUP (LF), 0           ; clear the screen with a bunch of line feeds
prompt_player_2          	BYTE   "Player 2, your guess (between LOW and HIGH)? ", 0

too_low_output           	BYTE   "Too low....", 0
too_high_output          	BYTE   "Too high....", 0
got_it_output            		BYTE   "You got it!", 0
num_guesses_prompt   	BYTE   "Number of guesses: ", 0
another_game_prompt  	BYTE   "Do you want to play again (y/n)?  ", 0
sorry_prompt            		BYTE   "Sorry, the number was ", 0

INCLUDE debug.h

.CODE
_start:

while_bad_input_secret: 
 
            inputW prompt_player_1, secret  ; get the secret number

            ; ensure that the input for the secret number is between LOW and HIGH
			;while ((secret < LOW_RANGE) or (secret > HIGH_RANGE))  //"do-while" loop
            cmp 	secret, LOW_RANGE
            jl 		while_bad_input_secret
            cmp 	secret, HIGH_RANGE
            jg 	while_bad_input_secret

            output clear

            mov    cx, 0            ; zero count

while_not_a_match: 

            cmp cx, MAX_GUESS
            jge lose

while_bad_input_guess:

		inputW prompt_player_2, ax

            ; ensure that the input is between LOW and HIGH
            cmp ax, LOW_RANGE
            jl while_bad_input_guess
            cmp ax, HIGH_RANGE
            jg while_bad_input_guess

            ; increment count of guesses
            inc    	cx   
            cmp    	ax, secret       	 	; compare guess and target
            jne    	if_less          	 		; guess = target ?

equal:  
    
            output got_it_output      		; display "you got it"
            output carriage
            jmp game_over

if_less:   
  
            jg    is_greater            	; guess < target ?
            output too_low_output        	; display "too low" and get another guess
            output carriage

            jmp while_not_a_match

is_greater:  

			output too_high_output      	; display "too high" and get another guess
            output carriage

            jmp while_not_a_match

lose:

            output sorry_prompt
            itoa text, secret
            output text
            output carriage

game_over:  ; ask if the players want to play again

            output num_guesses_prompt
            outputW cx
            output another_game_prompt
            output carriage

            input  	text, 3          					; get response (really only checks the first byte, but remember CR and LF are present as well, so we need a 3 here)
            cmp   	text, 'n'        					; response = 'n' ? check lower case
            je     	done             					; exit if so
            cmp    	text, 'N'        					; response = 'N' ? check upper case
            jne    	while_bad_input_secret  	; repeat the entire program if the response is anything other than 'n' or 'N'

done:
            INVOKE ExitProcess, 0

PUBLIC _start

            END 
