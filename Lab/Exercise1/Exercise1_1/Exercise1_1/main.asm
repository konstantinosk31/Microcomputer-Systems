;******************************************************************
;                               EXERCISE1_1
;******************************************************************
.include "m328PBdef.inc"    ;ATmega328P microcontroller definitions
.def A=r17
.def B=r18
.def C=r19
.def D=r20


;Init Stack Pointer
    ldi r24, LOW(RAMEND)
    out SPL, r24 
    ldi r24, HIGH(RAMEND)
    out SPH, r24

;Init PORT? as input
    clr r26       
    out DDRB, r26 

;Init PORTC as output
	ser r26
	out DDRC, r26

;Read input (We will be working with the LSB of each register)
	in r16, PORTB
	mov A, r16
	lsr r16
	mov B, r16
	lsr r16
	mov C, r16
	lsr r16
	mov D, r16

;Calculate F0
	mov r21, D
	and r21, B	; r21 = B*D
	
	mov r22, B
	com r22		; r22 = B'
	and r22, A		; r22 = A*B'

	or r21, r22		; r21 = F0

;Calculate F1
	mov r22, B
	com r22		; r22 = B'
	or r22, D		; r22 = B'+D

	mov r23, A		; r23 = A
	com	r23		; r23 = A'
	mov r24, C	; r24 = C
	com r24		; r24 = C'
	or r23, r24	; r23 = A'+C'

	and r22, r23 ; r22 = F1

;Output
	andi r21, 0x01	; r21 = F0 (all bits)
	andi r22, 0x01	; r22 = F1 (all bits)
	lsl r22		; r22 = 2*F1 (all bits)
	or r21, r22		; r21 = 0000 00(F1)(F0)

	out PORTC, r21