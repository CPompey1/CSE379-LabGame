    .data

	.global prompt
	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global output_character	; This is from your Lab #6 Library
	.global read_string		; This is from your Lab #6 Library
	.global output_string		; This is from your Lab #6 Library
	.global uart_init		; This is from your Lab #6 Library
	.global simple_read_character
	.global labGame
	.global output_string_nw
	.global parse_string
	.global int2string_nn
	.global output_string_withlen_nw
	.global tiva_pushbtn_init
	.global int2string
	.global Timer_init
	.global movCursor_down
	.global movCursor_up
	.global movCursor_right
	.global movCursor_left
	.global print_cursor_location
	.global num_1_string
	.global num_2_string

prompt:	.string "Press SW1 or a key (q to quit)", 0
ball_data_block: .word 0
paddle_game_data_block: .word 0
spacesMoved_block: .word 0
data_block: 	   .word 0

start_prompt:	.string "Breakout Game", 0
rows_prompt: 	.string "Firstly, press sw2 for 1 row of brick, sw3 for 2 rows of brick, sw4 for 3 rows of bricks, or sw5 for 4 rows of string", 0
instructions_prompt:	.string "Press a or d to move the paddle left or right respectivly, press sw1 to pause if needed, press space key to start", 0

paddle:	.string "-----"
score_str: .string "Score: "
score_val: .word 0

bricks: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;28 bricks


top_bottom_borders: .string "+---------------------+", 0
side_borders: .string "|                    |", 0 ;The board is 20 characters by 20 characters in size (actual size inside the walls).
cursor_position: .string 27, "[" ;set up a cursor position variable that will be 10 - 10
home: .string 27, "[1;1H",0
clear_screen: .string 27, "[2J",0 ; clear screen cursor position moved to home row 0, line 0zzz
backspace:	.string 27, "[08", 0
asterisk:	.string 27, "*", 0
num_1_string: .string 27, "   "
num_2_string: .string 27, "   "
saveCuror:	  .string 27, "[s",0
restoreCuror: .string 27, "[u",0


	.text

ptr_to_rows_prompt: 	        .word rows_prompt
ptr_to_start_prompt:	        .word start_prompt
ptr_to_instructions_prompt:		.word instructions_prompt
ptr_to_paddle:		            .word paddle
ptr_to_score_str:		        .word score_str
ptr_to_score_val:		        .word score_val

ptr_to_prompt:				    .word prompt
prt_to_dataBlock: 			    .word data_block
prt_to_spacesMoved_block:	    .word spacesMoved_block

ptr_to_top_bottom_borders:		.word top_bottom_borders
ptr_to_side_borders:		    .word side_borders
ptr_to_cursor_position: 	    .word cursor_position
ptr_to_clear_screen: 		    .word clear_screen
ptr_to_backspace:				.word backspace
ptr_to_asterisk:				.word asterisk
ptr_to_home: 					.word home
ptr_num_1_string: 				.word num_1_string
ptr_num_2_string: 				.word num_2_string
ptr_saveCuror:					.word saveCuror
ptr_restoreCuror:				.word restoreCuror
ptr_ball_data_block				.word ball_data_block
ptr_paddle_game_data_block		.word paddle_game_data_block

labGame:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack

	BL uart_init
	bl tiva_pushbtn_init
	BL uart_interrupt_init
	BL gpio_interrupt_init

	;Clear screen
	ldr r0, ptr_to_clear_screen
	bl output_string_nw

	;Go to gome
	ldr r0, ptr_to_home
	bl output_string_nw



	mov r0,#1
	mov r1,#1
	bl print_cursor_location

	mov r0,#2
	mov r1,#7
	bl print_cursor_location

	mov r0,#5
	mov r1,#5
	bl print_cursor_location



	POP {lr}
	MOV pc, lr



Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed
	; for Lab #5, but will be used in Lab #6.  It is referenced here
	; because the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	;Preserve registers
	PUSH {lr}
	PUSH {r4-r11}

	;Clear timer interrupt (1)->0th bit of 0x40030024
	MOV r0 ,#0x0024
	MOVT r0, #0x4003
	LDR r1, [r0]
	ORR r1, #1
	str r1,[r0]


	POP {r4-r11}
	POP {lr}
	BX LR



Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {lr}
	PUSH {r4-r11}


	;clear interrupt register GPIOICR
	MOV r0, #0x541C
	MOVT r0, #0x4002
	LDR r1,[r0]
	ORR r1, r1,#16
	STR r1, [r0]

	;Incrament switch presses (Speed)
	ldr r0,prt_to_dataBlock
	LDRB r1,[r0, #2]		;Modify third byte
	ADD r1, r1,#1
	STRB r1,[r0, #2]

	POP {r4-r11}
	POP {lr}
	BX lr       	; Return

UART0_Handler:

	PUSH {lr}
	; Remember to preserver registers r4-r11 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r11}

	;Clear Interrupt: Set the bit 4 (RXIC) in the UART Interrupt Clear Register (UARTICR)
	;UART0 Base Address: 0x4000C000
	;UARTICR Offset: 0x044
	;UART0 Bit Position: Bit 4

	MOV r0, #0xC000
	MOVT r0, #0x4000
	LDR r2, [r0, #0x44]
	ORR r2, r2, #16		;bit 4 has 1
	STR r2, [r0, #0x44]	;clearing interrupt bit



	POP{r4-r11}
	POP {lr}
	BX lr

exit:
	MOV r0, r9
	BL output_string
	;move the counter for # of moves into the register that int2string uses as an argument
	;int2string on that register

***************************HELER SUBROUTINES ****************************************
border_check:
	push {lr}


	pop {lr}
	mov pc,lr

;Print_borders
print_borders:
    PUSH{lr}
	;print "Score: " (might have to move the cursor to the middle of the board before printing to center it like it shows
					 ; in the lab doc)
	LDR r0, ptr_to_score_str
	BL output_string
	;int2string on score
	LDR r0, ptr_to_score_val
	BL int2string
	;print output of int2string
	;LDR r0, whatever the output of int2string is in
	;BL output_string

    LDR r0, ptr_to_top_bottom_borders ;move top and bottom border to the register used as an argument in output_string
    BL output_string ; branch to output_string

    MOV r1, #0 ;move 0 into r1 (or any free register) to use as a counter

    LDR r0, ptr_to_side_borders ; move side borders to the register used as an argument in output_string (could do it in the loop but this is a bit faster i think)
    BL side_loop ; branch to loop that will print out the sides of the board

side_loop:
    CMP r1, #20  ;(or #21?) compare to see if we have entered the loop 20 times (if we have printed all the side borders)
    BEQ bottom ;if all the sides are done we just have to print the bottom border

	push {r0-r4}
	LDR r0, ptr_to_side_borders
    BL output_string ;r0 should already hold the side borders
	pop {r0-r4}
    ADD r1, r1, #1 ;increment counter
    B side_loop ;Branch back to the loop to print the next line or

bottom:
    LDR r0, ptr_to_top_bottom_borders ;move top and bottom border to the register used as an argument in output_string
    BL output_string ; branch to output_string

insert_paddle:
	;put paddle into its expected position 
	; x = 9 y = 16
	;LDR r0, ptr_to_paddle_start ;starting inital position
	BL output_string
	LDR r0, ptr_to_paddle
	BL output_string

insert_asterisk:
	MOV r0, #42
	bl output_character
	;Move back
	mov r0, #8
	bl output_character


	;Incrament spaces
	ldr r0, prt_to_dataBlock
	ldrb r2, [r0,#2]
	ldr r1, prt_to_spacesMoved_block
	ldr r0,[r1]
	add r0,r0, r2
	str r0,[r1]

	;Check borders
	bl border_check

    POP {lr}
	MOV pc, lr


	.end
