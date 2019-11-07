// Made by Doctor Mejia
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
//definir cristal principal
#define _XTAL_FREQ 4000000UL
//invoco a la libreria de XC
#include <xc.h>


void main(void) {
    //heyyy declaro puerto de salida
    TRISD=0xFC;
    
    while(1){
        for(int i=0;i<255;i++){
            LATDbits.LD0=1;
            LATDbits.LD1=0;
            for(int j=0;j<i;j++){
                __delay_us(10);
            }
            LATDbits.LD0=0;
            LATDbits.LD1=1;
            for(int j=0;j<255-i;j++){
                __delay_us(10);
            }
        }
        
        for(int i=0;i<255;i++){
            LATDbits.LD0=0;
            LATDbits.LD1=1;
            for(int j=0;j<i;j++){
                __delay_us(10);
            }
            LATDbits.LD0=1;
            LATDbits.LD1=0;
            for(int j=0;j<255-i;j++){
                __delay_us(10);
            }
        }
    }
    //return;
}
