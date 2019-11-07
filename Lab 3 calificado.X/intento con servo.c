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

unsigned char min=0, seg=0,pasa=0,pulsa=0;
unsigned int cent=0, campana=0;

void mover (void){
    char w=10;
    for(int j=0;j<w;j++){
        LATBbits.LB0 = 1;
        __delay_us(700);
        LATBbits.LB0 = 0;
        __delay_ms(19);
        __delay_us(400);
    }
    for(int j=0;j<w;j++){
        LATBbits.LB0 = 1;
        __delay_us(300);
        __delay_ms(2);
        LATBbits.LB0 = 0;
        __delay_ms(17);
        __delay_us(700);
    }
}

void contador_de_campanas (void){
    campana++;
    if(campana==1000){campana=0;}
    if(campana==1){
    POS_CURSOR(2,1);
    ESCRIBE_MENSAJE("001 Campanada ",14);
    } 
    else{
    POS_CURSOR(2,1);
    ENVIA_CHAR(campana/100+'0');
    ENVIA_CHAR((campana%100)/10+'0');
    ENVIA_CHAR((campana%10)+'0');
    ESCRIBE_MENSAJE(" Campanadas",11);
    }
    
}

void main(void) {
    //coso de puertos
    TRISD =0x00;
    TRISBbits.RB0=0;
    
    // coso de LCD
    __delay_ms(50);
    LCD_CONFIG();
    BORRAR_LCD();
    POS_CURSOR(1,0);
    CURSOR_ONOFF(OFF);
    ESCRIBE_MENSAJE("TIMER:",6);
    POS_CURSOR(2,1);
    ESCRIBE_MENSAJE("000 Campanadas",14);
    
    //coso de Timer1
    TMR1H=0xFF;     //cuenta inicial pa q el timer1 no se demore 16 seg 
    TMR1L=0xFF;     //al comienzo como un timer unico y detergente
    T1CON=0xEA;     //PSC 1:16 cristal externo y otras cosas que no me acuerdo
    
    //coso del ccp1
    CCP1CON=0x0B;
    CCPR1H=0x00;
    CCPR1L=41;
    PIE1bits.CCP1IE=1;
    IPR1bits.CCP1IP=1;
    
    //coso del int1
    INTCON2bits.INTEDG1=1;
    INTCON3bits.INT1IE=1;
    INTCON3bits.INT1IP=0;
    
    //coso para interrupciones
    RCONbits.IPEN = 1;      //activo interrupciones altas y bajas
    INTCONbits.GIEH = 1;    //interrupciones de alta prioridad
    INTCONbits.GIEL = 1;    //interrupciones de baja prioridad
    INTCONbits.PEIE=1;
        
    //case de preguntas
    while(1){
        //secuencia de muestra en LCD
        POS_CURSOR(1,7);
        ENVIA_CHAR(min/10+'0');
        ENVIA_CHAR(min%10+'0');
        ENVIA_CHAR(':');
        ENVIA_CHAR(seg/10+'0');
        ENVIA_CHAR(seg%10+'0');
        ENVIA_CHAR(':');
        ENVIA_CHAR(cent/100+'0');
        ENVIA_CHAR((cent%100)/10+'0');
        //ENVIA_CHAR((cent%10)+'0');
        
        if(seg%15==0 && seg>0 && (cent==5 || cent==10 )){
            contador_de_campanas ();
            mover();
        }
        if(min>0 && seg==0 && (cent==5 || cent==10 )){
            contador_de_campanas ();
            mover();
            contador_de_campanas ();
            mover();
        }
        if((min==0 && seg==0 && (cent==5 || cent==10 )) && pasa==1){
            pasa=0;
            contador_de_campanas ();
            mover();
            contador_de_campanas ();
            mover();
        }
    }
}
void __interrupt(high_priority) elcomparador(void){
    PIR1bits.CCP1IF=0;
    cent=cent+5;
    if(cent==1000){cent=0;seg++;}
    if(seg==60){seg=0;min++;}
    if(min==60){min=0;seg=0;cent=0;pasa=1;}
    }

void __interrupt(low_priority) elboton(void){
    INTCON3bits.INT1IF=0;
    pulsa++;
    if(pulsa==1 || pulsa==2){T1CONbits.TMR1ON=!T1CONbits.TMR1ON;}
    else;
    }

