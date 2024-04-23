.def FLAG=r16
.def TRAIN=r17

;Init PORTD as output
	ser r16
	out DDRD, r16

;Initializations
	ldi FLAG, 0x01 ; FLAG = 1 = GO_LEFT
	ldi TRAIN, 0x01 ; Initialize train to be at LSB
Output:
	out PORTD, TRAIN
	;wait 2 seconds
Start:
	cpi FLAG, 0x01
	brne Right
Left:
	clc
	rol TRAIN
	brcc Output
	;wait 1 second
	clr FLAG
	ldi TRAIN, 0x80
	jmp Output

Right:
	clc
	ror TRAIN
	brcc Output
	;wait 1 second
	ldi FLAG, 0x01
	ldi TRAIN, 0x01
	jmp Output