/*
 * main.c
 *
 * Created: 5/16/2024 4:38:16 PM
 *  Author: konst
 */ 

#include <xc.h>
#define F_CPU 16000000UL
#include<avr/io.h>
#include<avr/interrupt.h>
#include<util/delay.h>

int number = 0;

ISR(INT1_vect) // External INT1 ISR
{
	if(number != 3000){
		number = -1000;
		PORTB = 0xFF;
	}
	else{
		number = 0;
	}
	EIFR = (1 << INTF1); // Clear the flag of interrupt INTF1
}

int main(void)
{
	// Interrupt on rising edge of INT1 pin
	EICRA = (1<<ISC11) | (1<<ISC10);
	
	// Enable the INT1 interrupt (PD3))
	EIMSK=(1<<INT1);
	
	sei(); // Enable global interrupts
	
	DDRB=0xFF; // Set PORTB as output
	
	PORTB=0x00; // Turn off all LEDs of PORTB
	
    while(1)
    {
        for(; number < 3000; number++){ //CHANGE TO 3000
			if(number >= 0 && number <= 1){
				PORTB = 1;
			}
			_delay_ms(1);
		}
		PORTB = 0;
    }
}