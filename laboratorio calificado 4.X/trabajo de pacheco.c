#include <xc.h>
#include "LCD.h"
#include "ADC.h"
#define _XTAL_FREQ 48000000UL
#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

//Declaración de variables globales:
float pre_cta_on_0 = 0;
float pre_cta_off_0 = 0;
float pre_cta_on_1 = 0;
float pre_cta_off_1 = 0;
float pre_cta_on_2 = 0;
float pre_cta_off_2 = 0;
unsigned int cta_on_0 = 0, cta_off_0 = 0;
unsigned int cta_on_1 = 0, cta_off_1 = 0;
unsigned int cta_on_2 = 0, cta_off_2 = 0;
char cta_msb_0, cta_lsb_0;
char cta_msb_1, cta_lsb_1;
char cta_msb_2, cta_lsb_2;
int resul_0 = 0;
int resul_1 = 0;
int resul_2 = 0;
char estado = 0;
int cent = 0;
int seg = 0;
int min = 0;
int cont = 0;
int cont2 = 0;
int dig_uni_cent = 0;
int dig_dec_cent = 0;
int dig_dec_seg = 0;
int dig_dec_min = 0;
int dig_uni_seg = 0;
int dig_uni_min = 0;
       
void calculon(int blablabla){
    pre_cta_on_0 = 63428 - (blablabla * 4.712); //63428 y 4.712
    pre_cta_off_0 = 70832 - cta_on_0;
    cta_on_0 = pre_cta_on_0;
    cta_off_0 = pre_cta_off_0;       
}
void calculon_2(int blablabla){
    pre_cta_on_1 = 63428 - (blablabla * 4.712); //63428 y 4.712
    pre_cta_off_1 = 70832 - cta_on_1;
    cta_on_1 = pre_cta_on_1;
    cta_off_1 = pre_cta_off_1;       
}
void calculon_3(int blablabla){
    pre_cta_on_2 = 63428 - (blablabla * 4.712); //63428 y 4.712
    pre_cta_off_2 = 70832 - cta_on_2;
    cta_on_2 = pre_cta_on_2;
    cta_off_2 = pre_cta_off_2;       
}
void DIGITOS(void){
    dig_dec_cent = cent/100;
    dig_uni_cent = (cent - (dig_dec_cent*100))/10;
    dig_dec_seg = seg/10;
    dig_uni_seg = seg - (dig_dec_seg*10);
    dig_dec_min = min/10;
    dig_uni_min = min - (dig_dec_min*10);       
}

void main(void) {
    TRISD = 0x00;        //Puerto D como salida (para LCD)
    TRISEbits.RE0 = 0;   //Puerto RE0 como salida (para el servo)
    TRISEbits.RE1 = 0;   //Puerto RE1 como salida (para el servo)
    TRISEbits.RE2 = 0;   //Puerto RE2 como salida (para el servo)
    T0CON = 0x81;       //Timer0 en FOsc/4, PSC 1:4, 16bits    
    LATEbits.LE0 = 0;
    LATEbits.LE1 = 0;
    LATEbits.LE2 = 0;
    RCONbits.IPEN = 1;      //Habilitamos prioridades en interrupciones
    TMR1H = 0xF0;
    TMR1L = 0x00;
    T1CON = 0x0F;
    RCONbits.IPEN = 1;      //Habilitamos prioridades en interrupciones
    INTCONbits.GIEH = 1;     //Habilito interrupciones globales
    INTCONbits.GIEL = 1;     //Habilito interrupciones globales
    //INTCONbits.GIEH = 1;     //Habilito interrupciones globales
    //INTCONbits.GIEL = 1;     //Habilito interrupciones globales
    //INTCONbits.TMR0IE = 1;
    INTCON = 0xA0;      //Interrupción: GIE = 1, TMR0IE = 1
    PIE1bits.TMR1IE = 1;
    PIR1bits.TMR1IF = 0;
    //PIE1bits.TMR1IE = 1;
    //PIR1bits.TMR1IF = 0;
    //CCP1CON = 0x0B;     //CCP en comparador evento especial de disparo
    //CCPR1H = 0x10;
    //CCPR1L = 0x00;      //Valor de comparacion entre CCP1 y Timer1 (cada 0.125 seg)
    //INTCONbits.PEIE = 1;//Habilitando interruptor de interrupciones de perifericos
    //PIE1bits.CCP1IE = 1;//Habilitando interruptor de interrupciones del CCP1
    __delay_ms(500);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
    while(1){
        ADC_CONFIG(0);
        resul_0 = ADC_CONVERTIR();
        calculon(resul_0);
        ADC_CONFIG(1);
        resul_1 = ADC_CONVERTIR();  
        calculon_2(resul_1);
        ADC_CONFIG(2);
        resul_2 = ADC_CONVERTIR();  
        calculon_3(resul_2);
        DIGITOS();
        CURSOR_HOME();
        POS_CURSOR(2, 4);
        ENVIA_CHAR(dig_dec_min + 0x30);
        ENVIA_CHAR(dig_uni_min + 0x30);
        ENVIA_CHAR(58);
        ENVIA_CHAR(dig_dec_seg + 0x30);
        ENVIA_CHAR(dig_uni_seg + 0x30);
        ENVIA_CHAR(58);
        ENVIA_CHAR(dig_dec_cent + 0x30);
        ENVIA_CHAR(dig_uni_cent + 0x30);
    }
}


void __interrupt(low_priority) Tmr1(void){
    PIR1bits.TMR1IF = 0;
    TMR1H = 0xF0;
    TMR1L = 0x00;
    cent = cent + 125;
    if (cent == 1000){
        cent = 0;
        seg++;
    }
    if (seg == 60){
        seg = 0;
        min++;
    }
    if (min == 60){
        min = 0;
    }
}

void __interrupt(high_priority) Tmr0ISR(void){
    if (estado < 10){
        if (PORTEbits.RE0 == 1){
            LATEbits.LE0 = 0;
            cta_msb_0 = cta_off_0 >> 8;
            cta_lsb_0 = cta_off_0 & 0x00ff;
            TMR0H = cta_msb_0;
            TMR0L = cta_lsb_0;
        }
        else{
            LATEbits.LE0 = 1;
            cta_msb_0 = cta_on_0 >> 8;
            cta_lsb_0 = cta_on_0 & 0x00ff;
            TMR0H = cta_msb_0;
            TMR0L = cta_lsb_0;
        }
        estado++;
    }
    
    else if (estado >= 10 && estado <20){
        if (PORTEbits.RE1 == 1){
            LATEbits.LE1 = 0;
            cta_msb_1 = cta_off_1 >> 8;
            cta_lsb_1 = cta_off_1 & 0x00ff;
            TMR0H = cta_msb_1;
            TMR0L = cta_lsb_1;
        }
        else{
            LATEbits.LE1 = 1;
            cta_msb_1 = cta_on_1 >> 8;
            cta_lsb_1 = cta_on_1 & 0x00ff;
            TMR0H = cta_msb_1;
            TMR0L = cta_lsb_1;
        }
        estado++;
    }
    else if (estado >= 20 && estado <30){
        if (PORTEbits.RE2 == 1){
            LATEbits.LE2 = 0;
            cta_msb_2 = cta_off_2 >> 8;
            cta_lsb_2 = cta_off_2 & 0x00ff;
            TMR0H = cta_msb_2;
            TMR0L = cta_lsb_2;
        }
        else{
            LATEbits.LE2 = 1;
            cta_msb_2 = cta_on_2 >> 8;
            cta_lsb_2 = cta_on_2 & 0x00ff;
            TMR0H = cta_msb_2;
            TMR0L = cta_lsb_2;
        }
        estado++;
    }
    else{
        estado = 0;
    }
    
    INTCONbits.TMR0IF = 0;
}