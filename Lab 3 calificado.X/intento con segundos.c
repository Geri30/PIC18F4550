// Made by Doctor Mejia

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)//definir cristal principal

#define _XTAL_FREQ 48000000UL
//invoco a la libreria de XC
#include <xc.h>
#include "LCD.h"

unsigned char min=0, seg=0, cent=0;

void main(void) {
    //configura
    TRISD =0x00;
    T1CON=0x0F;
    __delay_ms(20);
    LCD_CONFIG();
    BORRAR_LCD();
    TMR1H=0xFE;
    TMR1L=0xB8;
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    ESCRIBE_MENSAJE("HORA:",5);
    PIE1bits.TMR1IE=1;
    INTCONbits.GIE=1;
    INTCONbits.PEIE=1;
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("00:00",5);
    //no hacer nada
    while(1);
}

void __interrupt(high_priority) timer1(void){
    PIR1bits.TMR1IF=0;
    TMR1H=0xFE;
    TMR1L=0xB8;
    cent++;
    if(cent==100){
        cent=0;
        seg++;
    }
    if(seg==60){
        seg=0;
        min++;
        
    }
    if(min==60){
        T1CONbits.T1OSCEN=0;
        min=59, seg=59, cent=99;
    }
    POS_CURSOR(2,0);
    ENVIA_CHAR(min/10+'0');
    ENVIA_CHAR(min%10+'0');
    ENVIA_CHAR(':');
    ENVIA_CHAR(seg/10+'0');
    ENVIA_CHAR(seg%10+'0');
    ENVIA_CHAR(':');
    ENVIA_CHAR(cent/10+'0');
    ENVIA_CHAR(cent%10+'0');
    
}