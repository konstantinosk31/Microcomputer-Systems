;
; Exercise2_1.asm
;
; Created: 16/05/2024 15:14:42
; Author : konst
;

.include "m328PBdef.inc"

.def number=r16

.org 0x0
	rjmp reset

.org 0x4
	rjmp isr1

reset:
	clr number ; Initialize number to 0

	ldi r24, LOW(RAMEND)
	out SPL, r24
	ldi r24, HIGH(RAMEND)
	out SPH, r24

	ser r24
	out DDRC,r24 ; Init PORTC as output
	clr r24
	out DDRD,r24 ; Init PORTD as input

	;Interrupt on rising edge of INT1 pin
	ldi r24, (1<<ISC11) | (1<<ISC10)
	sts EICRA, r24

	;Enable the INT1 interrupt
	ldi r24, (1<<INT1)
	out EIMSK, r24

	sei ; Enable general flag of interrupts

main0:
	in r18,PIND
    sbrs r18,7                        ;if PD7 Not pressed (input=1) skip next instruction
    rjmp freeze                    ;if input=0 (PD7 pressed) continue displaying the current number of interupts
	
	out PORTC,number ; Output number

	rjmp main0

freeze:
	cli ; Disable global interrupts (stops counting)
read_freeze:
	in r24,PIND ; Read input
	cpi r24,0b1000000 ; Check if PD7 is set
	brcc read_freeze ; PD7 is set -> don't resume counting
	sei ; Enable global interrupts (resume counting)
	rjmp main0 ; PD7 is clear -> unfreeze counting 

;External interrupt 1 service routine
isr1:
	push r23
	push r24
	push r25
	in r25, SREG
	push r25 ; save r23, r24, 25, SREG to stack

	ldi r23, 0xFF ; Set all pins of PORTB
	out PORTB, r23

	;Delay 500 mS
	ldi r24, low(16*100) ; Init r25, r24 for delay 100 mS
	ldi r25, high(16*100) ; CPU frequency = 16 MHz
delay1:
	ldi r23, 249 ; (1 cycle)
delay2:
	dec r23 ; 1 cycle
	nop ; 1 cycle
	brne delay2 ; 1 or 2 cycles
	sbiw r24, 1 ; 2 cycles
	brne delay1 ; 1 or 2 cycles

	ldi r24, (1 << INTF0)
	out EIFR, r24 ; Clear external interrupt 0 flag

	inc number ; Increase counter
	andi number, 0x0F ; Keep only last 4 digits
	out PORTC, number

skip:
	pop r25
	out SREG, r25
	pop r25
	pop r24
	pop r23 ; Retrieve r23, r24, 25, SREG from stack

	reti ; Return from interrupt
 


