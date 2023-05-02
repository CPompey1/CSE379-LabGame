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
	.global MOD
	.global num_1_string
	.global num_2_string
	.global int2string_nn
	.global movCursor_right
	.global num_1_string
	.global num_2_string
	.global enable_rgb

initialCyclesT:	.equ 0x0030
initialCyclesB: .equ 0xD400
decreaseRateT:	.equ 0x0004
decreaseRateB:	.equ 0xE200

	.global gpio_btn_and_LED_init

prompt:	.string "Press SW1 or a key (q to quit)", 0
ball_data_block: .word 0
ball_data_block1: .word 0
spacesMoved_block: .word 0
data_block: 	   .word 0
paddleDataBlock: .word 0
game_data_block: .word 0


start_prompt:	.string "BREAKOUT GAME", 0
row_instructions: .string "Select rows of bricks:", 0
rows_prompt: 	.string "[sw2] 4 rows    [sw3] 3 rows    [sw4] 2 rows    [sw5] 1 row", 0
game_instructions: .string "How to play:",0
instructions_prompt:	.string " Press a to move paddle left, press d to move paddle left, press sw1 to pause", 0
space_prompt:	.string "[PRESS SPACE TO START]",0

paddle:	.string "-----", 0
score_str: .string "Score: ", 0
score_val: .word 0

bricks: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;28 bricks
ran_state: .word 1


pause_string: .string "PAUSE", 0
pause_clear: .string "     ", 0
gameOver: .string " ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠖⠛⣻⣿⣻⣿⣿⣶⠶⣤⡀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠶⣦⡀⠀⠀⠀⠀⠀⠀⢀⡴⢋⣤⠶⣟⣛⣿⡿⠿⣿⣿⣷⡾⣿⣆",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⣤⣿⡇⠀⠀⠀⠀⠀⢀⡞⣦⣨⣿⡳⠉⢛⣋⣤⣤⣘⣷⣿⡇⣼⣿⣷⡀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⢸⠉⣿⣭⡇⠀⠀⠀⠀⠀⢸⡁⣿⡟⠉⠉⠓⠻⠿⠿⠟⠛⠉⠀⠀⠉⢫⣿⡇⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠈⠀⠇⠀⠀⠀⠀⠀⢸⡿⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⣿⡇⠀⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⢸⣦⣤⡿⣂⠀⠀⠀⠀⠀⠘⣿⣿⡶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⡄⠀⠀",10,13," ⠀⠀⠀⠀⠀⠀⠀⠈⡇⠙⠋⢸⠀⠀⠀⠀⠀⢀⢿⣿⠁⠀⢀⣀⣤⣀⣀⠆⠀⣀⣤⣴⣶⣾⣿⣿⣿⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⣠⠤⣿⠀⠀⢸⣀⣀⡀⠀⠀⣿⣻⣻⡂⠚⣫⣽⠿⣻⠟⢁⠀⣿⠛⠛⠹⠛⢿⣿⣿⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⣾⠀⠀⠸⣇⣈⢹⣤⣄⠻⡿⡝⣇⠀⠀⠀⠈⠉⠀⠘⠚⣷⣄⠀⠀⠀⠘⣿⡏⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⣼⠟⠛⣿⠀⠀⠙⢯⠉⠳⣿⠾⣷⡿⣷⢮⢷⡀⠀⠀⣠⠦⣗⠀⣹⣽⣆⠀⠀⢠⡿⠀⠀⠀",10,13,"⠀⠀⠀⠀⠀⢀⡞⠉⡇⢸⡟⣆⠀⠀⠀⠀⠀⡤⢧⡈⡇⠈⠻⣆⠙⢤⣼⣯⣀⣈⣛⣿⠿⣯⡗⢀⣾⠃⠀⠀⠀",10,13,"⠀⠀⠀⠀⠀⣿⠛⠀⡇⢶⠀⠸⡄⠀⠀⠀⢸⠁⠀⢹⡇⠀⣰⣿⣄⠈⠃⠙⢿⣦⣤⡴⣾⢿⠇⢸⡿⠀⠀⠀⠀",10,13,"⠀⠀⠀⠀⠀⠹⡀⢰⡇⠀⠀⠀⢻⠀⠀⠀⢸⡆⠀⠀⣷⣾⣿⣿⠈⢳⡀⠀⠀⠹⣷⣮⡵⠟⠀⣼⠇⠀⠀⠀⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠐⠂⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣧⡀⠘⠳⣄⠀⠀⠀⠀⢀⡴⣻⠀⠀⠰⣤⡀⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠹⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣦⡀⠈⠙⠒⠒⣺⣿⣶⣿⣿⣿⣶⣽⣿⣿⣦⣄⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠈⠓⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣯⢳⣀⠀⢀⣼⣷⣤⣞⣛⠿⣿⠈⠀⢹⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⢄⣀⡀⠀⠀⠀⠄⢰⡿⢿⣿⣿⣿⣿⣿⣿⣧⡻⣿⡿⠁⠈⠛⢿⣛⣻⣿⠀⠀⠀⢿⣿⣿⣿⣿⡀⠀⣀⣀⣤⣤⣴⣶⡾⠿⠿⣿⡄⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⠀⠀⣀⣤⠖⠋⣠⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⢹⠿⢛⣦⣀⣀⣨⣿⣿⣿⣿⣿⡿⢻⣿⣻⣭⣭⣤⣤⣄⠀⣿⣇⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠟⠛⠉⠁⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⣀⣠⣤⣴⣿⣶⡿⠿⠿⠛⠛⢩⣭⢻⣷⣿⣿⡿⠿⠈⣿⣿⠉⠻⣿⡆⠸⣿⠀⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⠠⣎⣁⣠⣴⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠛⠋⣙⣽⣦⣄⠀⢿⣷⡀⠀⢸⣿⠘⣿⣧⠀⠀⠀⠀⢹⣿⣶⣾⣿⣇⠀⣿⣆⠀",10,13,"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢿⡛⣿⣯⣭⣴⣾⣿⠁⠀⠀⢰⣿⡟⠛⢿⣷⠈⢿⣧⠀⢸⣿⠀⢹⣿⣿⠿⠇⠀⠘⣿⡏⠉⢹⣿⡄⢸⣿⠀",10,13,"⠀⠀⠀⢀⣀⣀⣤⣤⣶⣾⡿⠿⢿⠻⠛⠋⣽⣅⠀⠀⢠⣿⣇⠸⣿⡟⠋⠉⠁⠀⠀⠀⠘⣿⡇⠀⠸⣿⡆⠈⢿⣷⣸⣿⠀⠘⣿⣇⢀⣀⣀⡄⢹⣿⡄⠈⠿⠷⠘⣿⡆",10,13,"⠰⣶⡿⠿⠛⣛⣫⣉⠉⠀⢠⣾⣿⣿⣷⡄⢸⣿⣷⣤⣾⣿⣿⠀⣿⣷⣤⣶⣦⠀⠀⠀⠀⢿⣿⠀⠀⣿⣧⠀⠈⢿⣿⣿⠀⠀⢿⣿⠿⠿⠛⠃⢈⣋⣤⣤⣴⣶⣶⡿⠇ ",10,13,"⠀⣿⣇⠀⣼⣿⠿⢿⣿⣆⣿⣿⠀⠈⢿⣷⠈⣿⡏⢿⣿⠉⣿⡇⢸⣿⡏⠉⠁⠀⠀⠀⠀⠘⢿⣷⣶⣿⠏⠀⠀⠈⠛⢃⣀⣀⣤⣴⣶⣾⠿⠿⠿⠛⠋⠉⠉⠀⠀⠀⠀",10,13,"⠀⠸⣿⠀⢿⣿⠀⠀⢙⣃⠘⣿⣷⣶⣾⣿⡆⢻⣿⠀⠀⠀⢻⣿⠈⣿⣷⣶⣶⣿⠇⠀⠀⠀⢀⣈⣉⣤⣴⣶⣶⠿⠿⠟⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",10,13,"⠀⠀⣿⡇⢸⣿⡆⢸⣿⣿⡀⢿⣿⠉⠈⣿⣧⠸⣿⣧⠀⠀⠘⠿⡃⢘⣉⣡⣤⣤⣴⣾⠿⠿⠟⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",10,13,"⠀⠀⢸⣿⠀⢿⣷⣤⣼⣿⠀⠸⣿⠆⠀⠘⣛⣀⣩⣥⣤⣶⣶⣿⠿⠟⠛⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",10,13,"⠀⠀⠈⣿⡇⠀⠉⠛⣋⣡⣤⣤⣶⣶⣶⠿⠟⠛⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",10,13,"⠀⠀⠀⢻⣿⣾⠿⠿⠟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",0
game_over_options: .string "PRESS [e] TO END THE GAME							PRESS [r] TO RESTART THE GAME", 0
top_bottom_borders: .string "+---------------------+", 0
side_borders: .string "|                     |", 0 ;The board is 20 characters by 20 characters in size (actual size inside the walls).
cursor_position: .string 27, "[" ;set up a cursor position variable that will be 10 - 10
home: .string 27, "[1;1H",0
clear_screen: .string 27, "[2J",0 ; clear screen cursor position moved to home row 0, line 0zzz
backspace:	.string 27, "[08", 0
asterisk:	.string 27, "*", 0
saveCuror:	  .string 27, "[s",0
restoreCuror: .string 27, "[u",0
num_1_string: .string 27, "   "
num_2_string: .string 27, "   "
test_esc_string: .string 27, "[48;5;255m",0
test_esc_string1: .string 27, "[38;5;232m",0
;test_esc_string: .string 27, "[38;5;30mHello",27,"[48;5;233m",27,"[38;5;164mThere",0

	.text

ptr_to_start_prompt:	        .word start_prompt
ptr_to_row_instructions_prompt: .word row_instructions
ptr_to_rows_prompt: 	        .word rows_prompt
ptr_to_game_instructions_prompt: .word game_instructions
ptr_to_instructions_prompt:		.word instructions_prompt
ptr_to_space_prompt: 			.word space_prompt

ptr_to_paddle:		            .word paddle
ptr_to_score_str:		        .word score_str
ptr_to_score_val:		        .word score_val

ptr_to_prompt:				    .word prompt
prt_to_dataBlock: 			    .word data_block
ptr_to_game_data_block:	        .word game_data_block


ptr_to_game_over_options:				.word game_over_options
ptr_to_gameOver: 				.word gameOver
ptr_to_pause: 					.word pause_string
ptr_to_pause_clear: 					.word pause_clear
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
ptr_ball_data_block:			.word ball_data_block
ptr_ball_data_block1:			.word ball_data_block1
ptr_test_esc_string: 			.word test_esc_string
ptr_bricks:						.word bricks
ptr_ran_state:					.word ran_state
ptr_test_esc_string1:			.word test_esc_string1
ptr_paddleDataBlock:				.word paddleDataBlock



labGame:	; This is your main routine which is called from your C wrapper
	PUSH {lr}   		; Store lr to stack

	BL uart_init
	bl tiva_pushbtn_init
	BL uart_interrupt_init
	BL gpio_interrupt_init
	BL enable_rgb
	BL gpio_btn_and_LED_init
	BL Timer_init

	ldr r0, ptr_test_esc_string
	bl output_string_nw

		;Clear screen
	LDR r0, ptr_to_clear_screen ;clear the screen and moves cursor to 0,0
	BL output_string
	ldr r0, ptr_to_home
	bl output_string_nw

	ldr r0, ptr_test_esc_string1
	bl output_string_nw
	ldr r0, ptr_to_home
	bl output_string_nw

	BL print_start_menu

	BL determine_brick_rows




loop:
;	BL read_from_push_btns
;	CMP r0, #1
;	BEQ determine_brick_rows

	LDR r0, ptr_paddleDataBlock
	LDRB r1, [r0, #3]
	CMP r1, #4
	BEQ end_loop

	b loop
end_loop:
	POP {lr}
	MOV pc, lr



;read_from_push_btns:
;	PUSH {lr}

; 	MOV r1, #0x7000
; 	MOVT r1, #0x4000
; 	LDRB r0, [r1, #0x3FC]
 ;	CMP r0, #0x10
; 	BEQ off1
;	MOV r0, #1
;	B exit_push_btns1
;off1:
; 	MOV r0, #0
;	B exit_push_btns1

;exit_push_btns1:

;	POP {lr}
;	MOV pc, lr


determine_brick_rows:
	;this subroutine determines how many bricks should be printed based on the number of pushbuttons pressed in the Alice Board
	;SW2 -> 4
	;SW3 -> 3
	;SW4 -> 2
	;SW5 -> 1
	;the number of rows to be printed is stored in memory
	PUSH{lr}
	;pushbuttons: Port D, Pins 0 – 3
	;Port D address: 0x40007000
	;data register offset: 0x3FC
	MOV r0, #0x73FC
	MOVT r0, #0x4000

	ldr r2, ptr_paddleDataBlock			;r2 has the datablock address

determine_brick_rows_checks:			;tentative pool
	LDRB r1, [r0]
	AND r1, r1, #0xF			;masking the four last bits(?)
	CMP r1, #0
	BNE determine_brick_rows_checkOne
	B determine_brick_rows_checks				;we should go back to checking it if no button is pressed, right?

determine_brick_rows_checkOne:
	CMP r1, #1									;0001
	BNE determine_brick_rows_checkTwo
	MOV r0, #1									;set r0 to be 1
	STRB r0, [r2, #2]							;store in memory
	B determine_brick_rows_end

determine_brick_rows_checkTwo:
	CMP r1, #2									;0010
	BNE determine_brick_rows_checkThree
	MOV r0, #2									;set r0 to be 2
	STRB r0, [r2, #2]							;store in memory
	B determine_brick_rows_end

determine_brick_rows_checkThree:
	CMP r1, #4									;0100
	BNE determine_brick_rows_checkFour
	MOV r0, #3									;set r0 to be 3
	STRB r0, [r2, #2]							;store in memory
	B determine_brick_rows_end

determine_brick_rows_checkFour:
	CMP r1, #8									;1000
	MOV r0, #4
	STRB r0, [r2, #2]							;store in memory

determine_brick_rows_end:
	POP{lr}
	MOV pc, lr


update_lives_LED:
	;this subroutine updates the number of LEDs that are lit up acoording to the number of lives remaining
	;should be called as we start the game, and every time a live is lost (needs to be updated)

	PUSH{lr}
	PUSH{r4-r6}

	LDR r0, ptr_to_game_data_block			;number of lives is stored in the first byte of this pointer
	;Alice board LEDs: Port B, Pins 0-3
	MOV r1, #0x53FC
	MOVT r1, #0x4000						;r1 has the led data register address

	LDRB r4, [r0]							;r4 has the number of lives remaining
	LDRB r5, [r1]							;r5 has the data from the led data register

	CMP r4, #4
	BNE update_lives_LED_checkThreeLife
	ORR r5, r5, #0xF
	STRB r5, [r1]
	B update_lives_LED_end

update_lives_LED_checkThreeLife:
	CMP r4, #3
	BNE update_lives_LED_checkTwoLife
	MVN r6, #0x8						;r6 last 4 bits: 0111
	AND r5, r5, r6
	STRB r5, [r1]
	B update_lives_LED_end

update_lives_LED_checkTwoLife:
	CMP r4, #2
	BNE update_lives_LED_checkOneLife
	MVN r6, #0xC						;r6 last 4 bits: 0011
	AND r5, r5, r6
	STRB r5, [r1]
	B update_lives_LED_end

update_lives_LED_checkOneLife:
	CMP r4, #1
	BNE update_lives_LED_checkZeroLife
	MVN r6, #0xE						;r6 last 4 bits: 0001
	AND r5, r5, r6
	STRB r5, [r1]
	B update_lives_LED_end

update_lives_LED_checkZeroLife:
	CMP r4, #0
	BNE update_lives_LED_end
	MVN r6, #0xF							;r6 has zeroes in bits 0-3
	AND r5, r5, r6							;putting zeroes in bits 0-3 (turning the LEDs off)
	STRB r5, [r1]

update_lives_LED_end:
	POP{r4-r6}
	POP{lr}
	MOV pc, lr


change_RGB_LED:
	;should be called every time the ball hits a brick
	;r4 SHOULD HAVE THE ADDRESS OF THE BRICK JUST HIT
	PUSH{lr}
	PUSH{r4-r9}
	MOV r5, #2		;RED
	MOV r6, #8		;GREEN
	MOV r7, #4		;BLUE
	MOV r8, #10		;YELLOW
	MOV r9, #6		;PURPLE

	;GPIO RGB LED Port F address: 0x40025000
	;GPIO data register offset: 0x3FC
	;LDRB r0, [r4, #2]	;retrieving the brick's color stored in memory

	MOV r1, #0x53FC
	MOVT r1, #0x4002		;r1 has the Port F data register address

	CMP r0, #0				;checking if r0 has the red color representation
	BNE change_RGB_LED_checkGreen
	STRB r5, [r1]			;lighitng up RGB as RED
	B change_RGB_LED_end
change_RGB_LED_checkGreen:


	CMP r0, #1				;checking if r0 has the green color represenation
	BNE change_RGB_LED_checkPurple
	STRB r6, [r1]			;lighting up RGB as GREEN
	B change_RGB_LED_end


change_RGB_LED_checkPurple:
	CMP r0, #2				;checking if r0 has the purple color representation
	BNE change_RGB_LED_checkBlue
	STRB r9, [r1]			;lighting up RGB as PURPLE
	B change_RGB_LED_end
change_RGB_LED_checkBlue:
	CMP r0, #3				;checking if r0 has the blue color representation
	BNE change_RGB_LED_checkYellow
	STRB r7, [r1]
	B change_RGB_LED_end
change_RGB_LED_checkYellow:
	CMP r0, #4
	BNE change_RGB_LED_end
	STRB r8, [r1]
change_RGB_LED_end:

	POP{r4-r9}
	POP{lr}
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

	;update random sta
	ldr r0, ptr_ran_state
	ldr r0, [r0,#0]
	add r0, r0,#1
	ldr r1, ptr_ran_state
	str r0, [r1,#0]

	LDR r0, ptr_paddleDataBlock
	LDRB r1, [r0, #3]
	CMP r1, #1
	BNE exit_timer_handler

	bl ball_movement


exit_timer_handler:
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



	LDR r0, ptr_paddleDataBlock	; if switch pressed check game state
	LDRB r1, [r0, #3]

	CMP r1, #1 ;if game state = 1 or 2 then pause
	BEQ pause
	B exit_switch_handler ;exit handler after returning

	CMP r1, #3 ;if game state = 3 currently then unpause
	BEQ unpause
	B exit_switch_handler ;exit handler after returning



exit_switch_handler:
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


	BL keystroke_access ;see game state and keystroke and do corresponding action

	B direction_end
direction_end:			;note: if the char is NONE of the above, the direction remains the same
	POP{r4-r11}
	POP {lr}
	BX lr

exit:
	MOV r0, r9
	BL output_string
	;move the counter for # of moves into the register that int2string uses as an argument
	;int2string on that register
paddle_move_right:
	;paddle movement illusion is created by writing a " - " character to the right of the paddle end
	;and erasing the left most " - " character
	PUSH {lr}
	ldr r2, ptr_paddleDataBlock		;r2 has a pointer to the data block
	LDRB r0, [r2]
	LDRB r1, [r2, #1]						;loading paddle coordinates into r0 and r1
	CMP r1, #18
	BGE paddle_move_right_end				;CHECK IF PADDLE END IS NOT AT THE RIGHT BORDER

	BL print_cursor_location
	MOV r0, #5					;move cursor to paddleEnd location +1 , gathered from data block
	BL movCursor_right

	MOV r0, #45					;- char =45
	BL output_character				;print the - character

	MOV r0, #5
	BL movCursor_left

	MOV r0, #127							; ascii delete = 127
	BL output_character						;delete the first - character

	ldr r2, ptr_paddleDataBlock		;r2 has a pointer to the data block
	LDRB r1, [r2, #1]
	ADD r1, r1, #1
	STRB r1, [r2, #1]					;paddleStart=paddleStart+1

paddle_move_right_end:
	POP{lr}
	MOV pc, lr

paddle_move_left:
	;paddle movement illusion is created by writing a " - " character to the left of the paddle
	;and erasing the right most " - " character
	PUSH {lr}
	ldr r2, ptr_paddleDataBlock		;loading datablock address into r2
	LDRB r0, [r2]
	LDRB r1, [r2, #1]						;loading the paddle coordinates into r0 and r1

	CMP r1, #2								;CHECK IF PADDLE START IS NOT AT THE LEFT BORDER
	BEQ paddle_move_left_end


	BL print_cursor_location				;move cursor to paddleStart location -1
	MOV r0, #1
	BL movCursor_left

	MOV r0, #45								;- char =45
	BL output_character						;print the - character

	MOV r0, #5						;move cursor to paddleEnd
	BL movCursor_right

	MOV r0, #127								;ascii delete= 127, ascii backspace=8
	BL output_character

	ldr r2, ptr_paddleDataBlock		;loading datablock address into r2
	LDRB r1, [r2, #1]
	SUB r1, r1, #1
	STRB r1, [r2, #1]							;paddleStart= paddleStart-1

paddle_move_left_end:
	POP{lr}
	MOV pc, lr
;print_all_bricks
;	Description:
;		Prints all bricks from 0-->27 to the teminal with randomly generated colors
;		while also storing brick info in memory
print_all_bricks:
	PUSH {lr}

	mov r3,r0
	mov r0,#0
	mov r1,#0
	ldr r2,ptr_bricks

pab_loop:
	push {r0-r3}
	bl print_brick
	pop {r0-r3}

	add r0,r0,#1
	cmp r0,#7
	bne pab_loop
	add r1,r1,#1
	mov r0, #0
	cmp r1, r3
	bne pab_loop


	POP {lr}
	mov pc,lr
***************************HELER SUBROUTINES ****************************************
;brick_check
;	Description:
;		Checks if the ball is currently at any brick, if it is:
;		clear the brick, incrament hit bricks, hange y trjectory
;		of ball
;
;	Outputs:
;		r0 - brickX location
;		r1 - brickY location
brick_check:
	PUSH {lr}
	PUSH {r4-r8}
	;Initialize X and Y to 0
	mov r0, #0
	mov r1, #0



	;Get current x and y ball location
	ldr r4, ptr_ball_data_block
	;r6 = ball crusor locationX
	ldrb r6, [r4,#0]
	;r7 = ball cursor locationY
	ldrb r7, [r4,#1]

brick_check_loop:
	;Get corresponding brick location
	;r5 = start(r2) + (r0 + 7(r1))*4
	ldr r2, ptr_bricks
	mov r3,#7
	MUL r3, r1, r3
	add r3,r0,r3
	mov r4,#4
	MUL r3,r3,r4
	add r5, r3,r2

	;Get brick cursor x and y
	;r3 = cursorx
	;r4 = cursory
	ldrb  r3, [r5,#0]
	ldrb  r4, [r5,#1]

	cmp  r3, r6
	beq check_y
	b not_hit

check_y
	;check all brick ys
	cmp r4,r7
	beq brick_hit

	sub r5,r4,#1
	cmp r5,r7
	beq brick_hit

	sub r5,r5,#1
	cmp r5,r7
	beq brick_hit



	add r4, r4,#1
	cmp r4,r7
	beq brick_hit

	add r4, r4,#1
	cmp r4,r7
	beq brick_hit



not_hit:
	;incrament x
	add r0,r0,#1
	cmp r0, #7
	bne brick_check_loop

	;incrament y
	;reset x
	mov r0, #0
	add r1, r1,#1
	cmp r1, #4
	bne brick_check_loop
	b end_brick_check

brick_hit:
	PUSH {r0-r3}
	bl clear_brick
	POP {r0-r3}

end_brick_check:
	POP {r4-r8}
	POP {lr}
	MOV pc,lr
;print_brick
;	Description
;		Printes a randomly colored brick at the cursor location that
;		coorosponds to the brick coordinate location. Also stores the brick coordinateX
;		brick coordinateY, and randomly selected brick color at the corresponding brick
;		whos base pointer is r2.
;
;	inputs
;		r0- x brick coordinate location
;		r1- y brick coordinate location
;		r2 - pointer to start of bricks in memory
;
;
;		brickMemoryLocation = r2 + offset
;		offset = (r0 + 7(r1))*4
;		brickCursorStartX = 3(r0) + 2
;		brickCursorStartY = r1 + 3
print_brick:
	push {lr}
	PUSH {r4}



	;r3 = random number
	push {r0-r2}
	bl ran_4
	bl num2colorcode
	mov r3, r0
	pop {r0-r2}

	;calc pointer offset
	mov r4, #7
	MUL r4,r4,r1
	add r4, r4,r0
	MOV R5,#4
	MUL r4, r5,r4
	add r2,r4,r2

	;store brick info in memory
	;color
	STRB r3, [r2,#2]	;ADGUST

	;set brick to on
	mov r4, #1
	STRB r4, [r2,#3]


	;calculate cursor locations
	;r0 = 3(r0) + 2
	MOV r4, #3
	MUL r0, r0, r4
	ADD r0, r0, #2

	;r1 = r1 + 3
	add r1,r1,#3

	mov r4, r0
	mov r0,r1
	mov r1,r4

	;Store x position in memory
	STRB r0, [r2,#0]
	;Store y position in memory
	STRB r1, [r2,#1]

	;print color
	;Move color to r2
	mov r2, r3
	push {r0-r3}
	bl print_color
	pop {r0-r3}


	;incrament x
	add r1,r1,#1
	;print color
	push {r0-r3}
	bl print_color
	pop {r0-r3}
	;incrament x
	add r1,r1,#1
	;print color
	push {r0-r3}
	bl print_color
	pop {r0-r3}


	POP {r4}
	pop {lr}
	mov pc,lr

;Clear brick
;	-Description:
;		Clear the brick at the brick coordinate provided
;	-Inputs:
;		r0 - Brick x coordinate
;		r1 - Brick y coordinate
;		r2 - Bricks base pointer
;		brickMemoryLocation = r2 + offset
;		offset = (r0 + 7(r1))*4
clear_brick:
	PUSH {lr}
	PUSH {r4-r5}
	;Calculate brick location in memory
	;brickpointer = r2 + (r0 + 7(r1))*4
	mov r4, #7
	mul r4,r1,r4
	add r4, r4,r0
	mov r5, #4
	MUL r4, r4, r5
	add r4, r2,r4

	ldrb r5,[r4,#3]
	cmp r5,#0
	beq exit_clear_brick


	;set brick as not printed
	mov r5,#0
	STRB r5, [r4,#3]


	;calculate cursor location
	bl brick2cursor

	;go to cursor location
	PUSH {r0-r3}
	bl print_cursor_location
	POP {r0-r3}


	;move right by 3 spaces
	PUSH {r0-r3}
	MOV r0, #3
	bl movCursor_right
	POP {r0-r3}

	;Delete 3 times
	PUSH {r0-r3}
	mov r0, #127
	bl output_character
	POP {r0-r3}

	PUSH {r0-r3}
	mov r0, #127
	bl output_character
	POP {r0-r3}

	PUSH {r0-r3}
	mov r0, #127
	bl output_character
	POP {r0-r3}

	;illuminate RGB led
	LDRB r0, [r4, #2]
	BL change_RGB_LED

	;Change ball color
	ldr r1, ptr_ball_data_block1
	strb r0, [r1,#0]

	;Deflect the ball
	ldr r0, ptr_ball_data_block
	mov r1, #1d
	strb r1, [r0,#2]


	;incrament bricks hit
	ldr r0, ptr_to_game_data_block
	ldrb r1, [r0,#3]
	add r1, r1,#1
	strb r1, [r0,#3]

	;update score
	ldr r0, ptr_to_score_val
	ldr r1,[r0,#0]
	ldr r2, ptr_to_game_data_block
	ldrb r3, [r2,#2]
	add r1,r1,r3
	str r1,[r0,#0]


	;print score
	push {r0-r3}
	mov r0,#0
	mov r1,#13
	bl print_cursor_location
	pop {r0-r3}
	mov r0, r1
	ldr r1, ptr_num_1_string
	bl int2string_nn
	mov r1,r0
	ldr r0, ptr_num_1_string
	bl output_string_withlen_nw







exit_clear_brick:

	POP {r4-r5}
	POP {lr}
	mov pc,lr

;ran_
;	Description
;		Returns a random number in the inclusive interval [0,4]
;		4 can be easily changed to any number (to change the interval)
;		by changing the modulus modifier
ran_4:
	push {lr}

	;The seed

	ldr r0, ptr_ran_state
	ldr r0, [r0,#0]

	;seed = seed ^ (seed << 12)
	lsl r1, r0, #12
	EOR r0, r0,r1

	;seed = seed ^ seed >> 15
	lsr r1, r0, #15
	EOR r0, r0, r1

	;seed = (seed ^ seed << 3)%modulus
	lsl r1,r0,#3
	EOR r0,r0,r1
	mov r1, #5
	bl MOD

	ldr r1, ptr_ran_state
	str r0, [r1,#0]

	pop {lr}
	mov pc,lr
;print_color
;	-Printes the foreground color of a cursor location on the terminal
;	-code format: ESC[38;5;160m
;	-Inputs
;		-r0: cursorX
;		-r1: cursorY
;		-r2: color code
print_color:
	push {lr}
	push {r4-r5}
	mov r5,r2


	;go to particular cursor location
	bl print_cursor_location


	;change cursor color
	mov r0, #27
	bl output_character	;output ESC

	mov r0, #91
	bl output_character ;output '['

	;output 48 for foreground
	mov r0, #52
	bl output_character
	mov r0, #56
	bl output_character
	;output ;
	mov r0, #59
	bl output_character
	;output 5 for foreground
	mov r0, #53
	bl output_character
	;output ;
	mov r0, #59
	bl output_character
	;ouptut given code
	mov r0, r5
	ldr r1, ptr_num_1_string
	bl int2string_nn
	mov r1,r0
	ldr r0, ptr_num_1_string
	bl output_string_withlen_nw
	;output m
	mov r0, #109
	bl output_character

	;print a space
	mov r0, #32
	bl output_character

	;output null
	mov r0, #0
	bl output_character

	;change cursor bacground color back to black
	mov r0, #27
	bl output_character	;output ESC
	mov r0, #91
	bl output_character ;output '['
	;output 48 for foreground
	mov r0, #52
	bl output_character
	mov r0, #56
	bl output_character
	;output ;
	mov r0, #59
	bl output_character
	;output 5 for foreground
	mov r0, #53
	bl output_character
	;output ;
	mov r0, #59
	bl output_character
	;ouptut black code
	mov r0, #232
	ldr r1, ptr_num_1_string
	bl int2string_nn
	ldr r0, ptr_num_1_string
	mov r1, #3
	bl output_string_withlen_nw

	;output null
	mov r0, #0
	bl output_character

	pop {r4-r5}
	pop {lr}
	mov pc,lr


;brick2cursor
;	Description
;		- Translates the brick coordinate (with shape (4,7)) location  to its
;		  corresponding starting cursor (with shape (4,21)) location
;			brickCursorStartX = 3(r0) + 2
;			brickCursorStartY = r1 +3
;	Inputs
;		r0 - brick x coordinate
;		r1 - brick y coordinate
;	Outputs
;		r0- cursor x coordinate
;		r1 -cursor y ccoorinate
brick2cursor:
	PUSH {lr}

	PUSH {r4}
	;calculate cursor locations
	;r0 = 3(r0)  +  2
	MOV r4, #3
	MUL r0, r0, r4
	ADD r0, r0, #2


	;r1 = r1 + 3
	add r1,r1,#3

	;cursor plane is reflected on the diagnol line eg: x->y y->x
	mov r4, r0
	mov r0,r1
	mov r1,r4

	POP {r4}
	POP {LR}
	MOV pc,lr
;cursor2brick
;	Description
;		- Translates the starting cursor coordinate (with shape (4,21)) location  to its
;		  corresponding  brick (with shape (4,7)) location
;			brickX = (r0 -2)/3
;			brickY = r1 - 3
;
;	Outputs
;		r0 - brick x coordinate
;		r1 - brick y coordinate
;	Inputs
;		r0- cursor x coordinate
;		r1 -cursor y ccoorinate
cursor2brick:
	PUSH {lr}

	mov r2, #3
	sub r0,r0,#2
	sdiv r0,r0,r2

	sub r1, r1,r2

	POP {lr}
	mov pc,lr
;num2colorcode
;	Description:
;		Stores the number stored in r0 in the interval [0,4] to the color codes
;		{red,green,purple,blue,yellow} respectively in r0
num2colorcode:
	PUSH {lr}

	;check red
	cmp r0, #0
	bne n2cc_not_0
	mov r0, #1
	b n2cc_end
n2cc_not_0
	;check ggreen
	cmp r0, #1
	bne n2cc_not_1
	mov r0, #2
	b n2cc_end
n2cc_not_1
	;check purple
	cmp r0, #2
	bne n2cc_not_2
	mov r0, #5
	b n2cc_end
n2cc_not_2

	;check blue
	cmp r0, #3
	bne n2cc_not_3
	mov r0, #4
	b n2cc_end
n2cc_not_3

	;check yellow
	cmp r0, #4
	bne n2cc_not_4
	mov r0, #3
	b n2cc_end
n2cc_not_4

n2cc_end
	pop {LR}
	mov pc,lr



;Print_borders
print_hui:
    PUSH{lr}

	;move cursor to middle of the first row
	MOV r0, #0 ; x = 0 (or 7 depending on indexing)
	MOV r1, #6 ; y = 6
	BL print_cursor_location

	LDR r0, ptr_to_score_str ;print "Score: "
	BL output_string_nw

	;print score
	LDR r0, ptr_to_score_val
	ldr r0,[r0,#0]
	ldr r1, ptr_num_1_string
	BL int2string
	ldr r0, ptr_num_1_string
	bl output_string
	;move cursor to start of second row to start printing the board
	;MOV r0, #1 ;x value
	;MOV r1, #0 ;y value


    LDR r0, ptr_to_top_bottom_borders ;move top and bottom border to the register used as an argument in output_string
    BL output_string ; branch to output_string

    MOV r1, #0 ;move 0 into r1 (or any free register) to use as a counter

    LDR r0, ptr_to_side_borders ; move side borders to the register used as an argument in output_string (could do it in the loop but this is a bit faster i think)
    BL side_loop ; branch to loop that will print out the sides of the board

side_loop:
    CMP r1, #16
    BEQ bottom ;if all the sides are done we just have to print the bottom border

    PUSH {r0-r4}
    LDR r0, ptr_to_side_borders
    BL output_string ;r0 should already hold the side borders
    POP {r0-r4}
    ADD r1, r1, #1 ;increment counter
    B side_loop ;Loop again to check if all side borders have been printed

bottom:
    LDR r0, ptr_to_top_bottom_borders ;move top and bottom border to the register used as an argument in output_string
    BL output_string ; branch to output_string

insert_paddle:
	LDR r0, ptr_paddleDataBlock ;store paddle location
	MOV r1, #17
	STRB r1, [r0, #0]
	MOV r1, #10
	STRB r1, [r0, #1]

	;put paddle into its expected position
	MOV r0, #17 ;xvalue
	MOV r1, #10 ;yvalue (if top left of terminal = 0,0)
	BL print_cursor_location

	LDR r0, ptr_to_paddle ;starting inital position
	BL output_string


insert_asterisk:
	MOV r0, #10 ;yvalue
	MOV r1, #12 ;xvalue
	BL print_cursor_location

	MOV r0, #42
	BL output_character
	;Move back (update: not needed since output_character should overwrite the whitespace
	;mov r0, #8
	;bl output_character

	;Check borders
	;bl border_check

	;inistialize ball location
	LDR r0, ptr_ball_data_block
	MOV r1, #10
	STRB r1, [r0, #0]
	MOV r1, #12
	STRB r1, [r0, #1]
	MOV r2, #1
	STRB r2, [r0, #2]
	MOV r2, #0
	STRB r2, [r0, #3]



   	POP {lr}
	MOV pc, lr



ball_movement:
	PUSH{lr} ; start
	;get x and y position and direction for x and y add each direction to its corresponding position (ie xposition + xdirection)

	LDR r2, ptr_ball_data_block
	LDRSB r0,[r2, #0] ; X location
	LDRSB r1, [r2, #1] ; Y location
	add r1,r1,#1
	BL print_cursor_location ;move cursor to current asterisk

	MOV r0, #127 ;delete to get rid of the old asterisk
	BL output_character

	LDR r2, ptr_ball_data_block ;load the data block again incase register r2 was changed in one of the past branches
	LDRSB r0,[r2, #0] ; get X location again because the branches might have changed register value
	LDRSB r1,[r2, #2] ; X direction (min, max = -2, 2)
	ADD r0, r1, r0
	STRB r0,[r2, #0] ; store the new x location into the 1st byte of the block

	LDRSB r0,[r2, #1] ; Y location
	LDRSB r1,[r2, #3] ; Y direction (min, max = -2, 2)
	ADD r0, r1, r0
	STRB r0,[r2, #1] ; store the new y location into the 2nd byte of the block


	bl paddle_check
	bl brick_check
	bl ball_border_check
	bl level_check
	ldr r0, ptr_ball_data_block1
	ldrb r0, [r0,#0]
	bl change_cursor_color
	bl print_ball
	mov r0 ,#232
	bl change_cursor_color

	POP {lr}
	mov pc,lr
ball_border_check:
	PUSH {lr}

	LDR r0, ptr_ball_data_block ;load the data block again incase register r2 was changed in one of the past branches
	LDRSB r1,[r0, #0] ; get new X location again because the branches might have changed register value

	CMP r1, #3 ;compare new x location with row right under top border
	BLT top ;if it is less than this value this means the border is hit or passed

	;BOTTOM BORDER WILL BE CHECKED BY PADDLE CHECK

	LDRSB r1, [r0, #1] ;compare new y coordinate with both 1 and 21 for left and right borders

	CMP r1, #2
	BLT left

	CMP r1, #21
	BGT right

	B exit1


top:
	MOV r1, #3 ;in this case we want to set the x location to 2 which is the highest the ball should be at
	STRB r1,[r0, #0]

	LDRSB r2, [r0, #2] ;get direction bit to negate it
	MOV r1, #-1 ;get negative one in a register
	MUL  r2, r2, r1 ;multiply direction bit with -1 to negate it
	STRB r2, [r0,#2]

	LDRSB r1, [r0, #1] ;compare new y coordinate with both 1 and 21 for left and right borders (edgcase if we were at a corner and we went over both a side and the top)

	CMP r1, #2
	BLE left

	CMP r1, #21
	BGT right

	B exit1 ;if it is not at a top corner then exit this subroutine


left:
	LDR r0, ptr_ball_data_block ;load the data block again incase register r2 was changed in one of the past branches
	LDRSB r1,[r0, #1]
	MOV r1, #2 ;in this case we want to set the y location to 1 which is the leftmost location the ball should be at
	STRB r1,[r0, #1]

	LDRSB r2, [r0, #3] ;get direction bit to negate it
	MOV r1, #-1 ;get negative one in a register
	MUL  r2, r2, r1 ;multiply direction bit with -1 to negate it
	STRB r2, [r0,#3]

	;no additional checks since top bottom was checked first and bottom will be done by paddle check
	B exit1

right:

	MOV r1, #21 ;in this case we want to set the y location to 21 which is the rightmost location the ball should be at
	STRB r1,[r0, #1]

	LDRSB r2, [r0, #3] ;get direction bit to negate it
	MOV r1, #-1 ;get negative one in a register
	MUL  r2, r2, r1 ;multiply direction bit with -1 to negate it
	STRB r2, [r0,#3]

	;no additional checks since top bottom was checked first and bottom will be done by paddle check
	B exit1

exit1:
	POP {lr}
	MOV pc, lr


print_ball:
	PUSH {lr}

	LDR r2, ptr_ball_data_block
	LDRSB r0,[r2, #0] ; Final X location after intial update and border checks
	LDRSB r1, [r2, #1] ; Final Y location after intial update and border checks
	BL print_cursor_location ;move cursor to where asterisk should be

	MOV r0, #42
	BL output_character

	POP {lr}
	MOV pc, lr
;paddle_check
;	Description
;		Checks if the ball is at the x location at the paddle. If it is
;		and the y cursor location is at a portion of the paddle, deflect the ball,
;		else start a new life.
paddle_check:
	PUSH {lr}
	PUSH {R4}
	;r0 = ball x cursor locaiton
	;r1 = ball y cursor location
	ldr r2, ptr_ball_data_block
	ldrb r0, [r2, #0]
	ldrb r1, [r2,#1]

	cmp r0, #15
	IT GE
	SUBGE r0,r0,#1
	;r3 = paddle start x
	;r4 = paddle start y
	ldr r2, ptr_paddleDataBlock
	ldrb r3, [r2,#0]
	ADD r3,r3,#-1
	ldrb r4, [r2,#1]

	;check if ball cursor x location is greater than or equal to paddle x location.
	cmp r0,r3

	;If not, return.
	blt exit_paddle_check

	;else check if it is anywhere on the y location of paddle
	cmp r1, r4
	bne paddle_check_y1
	;update location and direction to 60deg left
	;location
	mov r0, r3
	ldr r2, ptr_ball_data_block
	strb r0, [r2,#0]
	;direction
	mov r0, #-1
	strb r0, [r2,#2]
	mov r0, #0xFFFE
	strb r0, [r2,#3]

	b exit_paddle_check

paddle_check_y1:
	add r4,r4,#1
	cmp r1, r4
	bne paddle_check_y2
	;update location and direction to 45deg left
	;location
	mov r0, r3
	ldr r2, ptr_ball_data_block
	strb r0, [r2,#0]
	;direction
	mov r0, #-1
	strb r0, [r2,#2]
	strb r0, [r2,#3]

	b exit_paddle_check
paddle_check_y2:
	add r4,r4,#1
	cmp r1, r4
	bne paddle_check_y3
	;update location and direction to up
	;location
	mov r0, r3
	ldr r2, ptr_ball_data_block
	strb r0, [r2,#0]
	;direction
	mov r0,#-1
	strb r0, [r2,#2]
	mov  r0, #0
	strb r0, [r2,#3]
	b exit_paddle_check
paddle_check_y3:
	add r4,r4,#1
	cmp r1, r4
	bne paddle_check_y4
	;update location and direction to 45deg right
	;location
	mov r0, r3
	ldr r2, ptr_ball_data_block
	strb r0, [r2,#0]
	mov r0, #1
	strb r0, [r2,#2]
	strb r0, [r2,#3]
	b exit_paddle_check
paddle_check_y4:
	add r4,r4,#1
	cmp r1, r4
	bne paddle_new_life
	;update location and direction to 60deg right
	mov r0, r3
	ldr r2, ptr_ball_data_block
	strb r0, [r2,#0]
	mov r0, #-1
	strb r0, [r2,#2]
	mov r0, #2
	strb r0, [r2,#3]
	b exit_paddle_check

paddle_new_life:
	bl new_life


exit_paddle_check:
	POP {r4}
	POP {lr}
	mov pc,lr
;level_check
;	Desctiption
;		- If the bricksHit == rows * 7, update the level, timer speed, call print bricks,
;		  else do nothing.
;
level_check
	PUSH {lr}

	;r1 = bricksHit
	ldr r0, ptr_to_game_data_block
	ldrb r1,[r0,#3]

	;r4 = r3(rows} * 7d
	ldr r2, ptr_paddleDataBlock
	ldrb r3,[r2,#2]
	mov r4, #7
	mul r4,r3,r4

	cmp r1,r4
	bne end_level_check
	;Else update level & speed
	;first reset bricks hit
	mov r1,#0
	strb r1,[r0,#3]
	;incrament level
	ldrb r1, [r0,#2]
	add r1,r1,#1
	strb r1,[r0,#2]
	mov r3,r1

	;Temporarily disable timer
	;disable GPTMCTL TAEN (1)->1st bit of:  0x4003000C
	MOV r0, #0x000C
	MOVT r0, #0x4003
	ldr r1, [r0]
	mvn r2, #1
	and r1,r1,r2
	str r1, [r0]

	;Calculate num cycles
	mov r0, #initialCyclesB
	movt r0,#initialCyclesT
	mov r1, #decreaseRateB
	movt r1, #decreaseRateT
	mul r3,r3,r1
	sub r3, r0,r3

	;update cycles
	;Set Interrupt interval period (GPTMTAILR) register0x40030028
	MOV r0, #0x0028
	MOVT r0, #0x4003
	str r3, [r0]

	;Enable timer
	;Enable timer 1->1st bit of 0x4003000C
	MOV r0, #0x000C
	MOVT r0, #0x4003
	ldr r1, [r0]
	orr r1, r1, #1
	str r1, [r0]

	;print_all bricks
	ldr r2, ptr_paddleDataBlock
	ldrb r3,[r2,#2]
	mov r0, r3
	bl print_all_bricks
	ldr r0, ptr_test_esc_string
	bl output_string_nw

end_level_check:
	POP {lr}
	mov pc,lr
;new_life
;	Description
;		- Decraments current lives, calls lives2ked subroutine, centers the ball, calls gameover
;		  if lives ==0
new_life:
	PUSH {lr}

	;check amount of lives left, if 0 branch to game over
	LDR r0, ptr_to_game_data_block
	LDRB r1, [r0, #0] ;lives are in bit 0
	CMP r1, #0 ;if lives are equal to 0
	BEQ game_over ;branch to game_over print game over menu
	B exit_new_life

	;else
	SUB r1, r1, #1 ;subtract lives by 1 and store
	STRB r1, [r0, #0]

	;Check if lives ==0
	;Call life2led

	;center ball in memory and on terminal
	ldr r0,ptr_ball_data_block
	; x = 9 y = 17
	MOV r1, #10 ;xvalue
	strb r1, [r0,#0]
	MOV r1, #12 ;yvalue (if top left of terminal = 0,0)
	strb r1, [r0,#1]
	;print cursor
	mov r0, #10
	mov r1, #12
	BL print_cursor_location
	MOV r0, #42
	BL output_character

	;reinitialize paddle
	;delete old paddle
	ldr r2, ptr_paddleDataBlock		;r2 has a pointer to the data block
	LDRB r0, [r2,#0]
	LDRB r1, [r2,#1]
	add r1, r1,#5
	bl print_cursor_location

	mov r0, #234
	bl change_cursor_color
	MOV r0, #127 ;delete to get rid of the old asterisk
	BL output_character
	MOV r0, #127 ;delete to get rid of the old asterisk
	BL output_character
	MOV r0, #127 ;delete to get rid of the old asterisk
	BL output_character
	MOV r0, #127 ;delete to get rid of the old asterisk
	BL output_character
	MOV r0, #127 ;delete to get rid of the old asterisk
	BL output_character

	;print new paddle
	; x = 10 y = 17
	MOV r0, #17 ;xvalue
	MOV r1, #10 ;yvalue (if top left of terminal = 0,0)
	ldr r2, ptr_paddleDataBlock
	strb r0, [r2,#0]
	strb r1, [r2,#1]
	BL print_cursor_location

	LDR r0, ptr_to_paddle ;starting inital position
	BL output_string_nw
	B exit_new_life

exit_new_life:
	POP {lr}
	MOV PC,LR

;change_cursor_color
;	Descritions
;		- Changes cursor foreground color to given color code in r0
;	Inputs
;		r0 - input color code
change_cursor_color:
	push {lr}
	push {r4-r5}
	mov r5,r0


	;change cursor color
	mov r0, #27
	bl output_character	;output ESC

	mov r0, #91
	bl output_character ;output '['

	;output 38 for foreground
	mov r0, #51
	bl output_character
	mov r0, #56
	bl output_character
	;output ;
	mov r0, #59
	bl output_character
	;output 5 for foreground
	mov r0, #53
	bl output_character
	;output ;
	mov r0, #59
	bl output_character
	;ouptut given code
	mov r0, r5
	ldr r1, ptr_num_1_string
	bl int2string_nn
	mov r1,r0
	ldr r0, ptr_num_1_string
	bl output_string_withlen_nw
	;output m
	mov r0, #109
	bl output_character

	POP {R4-R5}
    POP {LR}
    MOV pc,lr

pause:
	; print pause
	; turn led blue
	PUSH {lr}

	;disable timer
	MOV r0 ,#0x000C
	MOVT r0, #0x4003
	LDR r1, [r0]
	ORR r1, #0 ;to disable timer
	STR r1,[r0]

	;set game state to paused
	LDR r0, ptr_paddleDataBlock
	MOV r1, #3
	STRB r1, [r0, #3]

	;move cursor
	MOV r0, #8 ;yvalue
	MOV r1, #12 ;xvalue
	BL print_cursor_location

	;print "PAUSE" to center of screen
	LDR r0, ptr_to_pause
	BL output_string_nw

	;LED = blue 0x40025000
	MOV r1, #0x5000
	MOVT r1, #0x4002
	MOV r0, #0x04 ; blue
	STRB r0, [r1]

	POP {lr}
	MOV pc, lr


unpause:
	PUSH {lr}

	;set game state to unpaused they should be back in game so set to 1
	LDR r0, ptr_paddleDataBlock
	MOV r1, #1
	STRB r1, [r0, #3]

	;move cursor
	MOV r0, #8 ;yvalue
	MOV r1, #12 ;xvalue
	BL print_cursor_location

	;print "     " to center of screen to get rid of the "PAUSE"
	LDR r0, ptr_to_pause_clear
	BL output_string_nw

	;move ball back to its location (in case "Pause" string was overwriting the ball)
	LDR r2, ptr_ball_data_block
	LDRB r0, [r2, #0]
	LDRB r1, [r2, #1]
	BL print_cursor_location


	ldr r1, ptr_ball_data_block1
	LDRB r0, [r1,#0] ;r2 now has color of last hit brick befor pause since pause did not update it

	MOV r1, #0x5000
	MOVT r1, #0x4002
	STRB r0, [r1]

	;enable timer
	MOV r0 ,#0x000C
	MOVT r0, #0x4003
	LDR r1, [r0]
	ORR r1, #0 ;to disable timer
	STR r1,[r0]

	POP {lr}
	MOV pc, lr
	;we want to restore the location of the ball we also want to restore the old color of the light (if ball had hit a red brick before pause it should be red again after pause
	; we also need to know how to stop the timer_handler from working during pause otherwise ball will keep moving
	; we also want to disable keystrokes otherwise player can move the paddle during pause


keystroke_access:
	PUSH{lr}

	BL simple_read_character		;retrieving the character pressed r0
	MOV r3, r0 ;store char read in r3

	LDR r0, ptr_paddleDataBlock
	LDRB r1, [r0, #3]
	;check game state 0 = start 1 = in game 2 = game over menu 3 = paused
	CMP r1, #0
	BL check_space
	CMP r1, #1
	BL check_a_d
	CMP r1, #2
	BL check_end

	BL keystroke_made ;if game state = 3 user tried to press keyboard during pause do nothing

check_a_d:
		CMP r3, #100		;if char== 'd'
		BNE check_a_char
		BL paddle_move_right	;MOVE PADDLE RIGHT
		B keystroke_made
check_a_char:
		CMP r3, #97		;if char== 'a'
		BNE keystroke_made ;if not a or d during the game then its invalid input do nothing
		BL paddle_move_left		;MOVE PADDLE LEFT
		B keystroke_made

check_space:
	CMP r3, #32
	BNE keystroke_made

	LDR r0, ptr_to_clear_screen ;clear the screen and moves cursor to 0,0
	BL output_string
	ldr r0, ptr_to_home
	bl output_string_nw

	;set game state to in game
	LDR r0, ptr_paddleDataBlock
	MOV r1, #1
	STRB r1, [r0, #3]

	;print hui and bricks
	BL print_hui 	;CALL START GAME SUBROUTINE

	LDR r1, ptr_paddleDataBlock
	LDRB r0, [r1, #2]
	BL print_all_bricks
	B keystroke_made

check_end:
	CMP r3, #101		;if char != 'e'
	BNE check_r_char

	;else e was pressed
	LDR r0, ptr_paddleDataBlock
	LDRB r1, [r0, #3]
	MOV r1, #4 ;user pressed e, set to 4 for the loop to catch and end the game
	STRB r1, [r0, #3]
	B keystroke_made

check_r_char:
		CMP r0, #114	;if char != 'r' e or r not pressed in game over menu iinvalid input do nothing
		BNE keystroke_made

		BL print_start_menu ;else r was pressed and we restart the game
		B keystroke_made
keystroke_made:
	POP {lr}
	MOV pc, lr

game_over:
	PUSH {lr}

	;set the bit = to 2 to make sure they cannot press a or d or spacebar
	LDR r0, ptr_paddleDataBlock
	LDRB r1, [r0, #3]
	MOV r1, #2
	STRB r1, [r0, #3]

	;Clear screen
	LDR r0, ptr_to_clear_screen ;clear the screen and moves cursor to 0,0
	BL output_string
	ldr r0, ptr_to_home
	bl output_string_nw

	;move cursor to middle of screen
	MOV r0, #10 ;xvalue
	MOV r1, #8 ;yvalue 8 so the space char in "GAME OVER" is in the center of the screen
	BL print_cursor_location


	;		"GAME OVER"
	; 		"PRESS [e] TO END THE GAME"
	;  		"PRESS [r] TO RESTART THE GAME"
	LDR r0, ptr_to_gameOver
	BL output_string

	LDR r0, ptr_to_pause_clear ;priint an empty string just to create some spaces between the ascii art and the optiions
	BL output_string
	LDR r0, ptr_to_pause_clear ;priint an empty string just to create some spaces between the ascii art and the optiions
	BL output_string

	LDR r0, ptr_to_game_over_options
	BL output_string


	POP {lr}
	MOV pc, lr


print_start_menu:
	PUSH {lr}

	;set game state to start game
	LDR r0, ptr_paddleDataBlock
	MOV r1, #0 ;game state set to start game
	STRB r1, [r0, #3]

	;Clear screen first
	LDR r0, ptr_to_clear_screen ;clear the screen and moves cursor to 0,0
	BL output_string
	ldr r0, ptr_to_home
	bl output_string_nw

	;move cursor to middle of screen
	MOV r0, #10 ;xvalue
	MOV r1, #6 ;yvalue 6 so the "u" char in "Breakout Game" is in the center of the screen
	BL print_cursor_location
	;output "Breakout Game"
	LDR r0, ptr_to_start_prompt
	BL output_string

	;move cursor to one row down middle of screen
	MOV r0, #11 ;xvalue
	MOV r1, #1 ;yvalue
	BL print_cursor_location
	LDR r0, ptr_to_row_instructions_prompt
	BL output_string

	MOV r0, #12 ;xvalue
	MOV r1, #5 ;yvalue (+ 4 spaces for a tab)
	BL print_cursor_location
	LDR r0, ptr_to_rows_prompt
	BL output_string

	MOV r0, #13 ;xvalue
	MOV r1, #1 ;yvalue x
	BL print_cursor_location
	LDR r0, ptr_to_game_instructions_prompt
	BL output_string


	MOV r0, #14 ;xvalue
	MOV r1, #5 ;yvalue (+ 4 spaces for a tab)
	BL print_cursor_location
	LDR r0, ptr_to_instructions_prompt
	BL output_string


	MOV r0, #15 ;xvalue
	MOV r1, #1 ;yvalue (+ 4 spaces for a tab)
	BL print_cursor_location
	LDR r0, ptr_to_space_prompt
	BL output_string

	POP {lr}
	MOV pc, lr


	.end
