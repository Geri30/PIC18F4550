#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
//include "ADC.h"

#define _XTAL_FREQ 48000000UL

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

int minutos = 0;
int segundos = 0;
int milisegundos = 0;

unsigned int T_PWM = 2000;
unsigned int T_on_min = 50;
unsigned int T_on_max = 250;
unsigned int T_on = 0;
unsigned int T_off = 0;

char tiempo_0_180 = 18;

void DIGITOS(int valor){
    digdmi = valor / 10000;
    temporal3 = valor - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void DO_PWM(float grados){
    T_on = T_on_min + ((grados * (T_on_max - T_on_min)) / 180.0);
    T_off = T_PWM - T_on;
    LATBbits.LB0 = 1;
    for(unsigned int i = 0; i < T_on; i++){
        __delay_us(10);
    }
    LATBbits.LB0 = 0;
    for(unsigned int j = 0; j < T_off; j++){
        __delay_us(10);
    }
}

void CAMPANADA(char veces){
    for(char i = 0; i < veces; i++){
        for(char j = 0; j < tiempo_0_180; j++){
            DO_PWM(180.0);
        }
        for(char j = 0; j < tiempo_0_180; j++){
            DO_PWM(0.0);
        }
    }
}

void main(void) {
    TRISD = 0;
    TRISBbits.RB0 = 0;
    RCONbits.IPEN = 1;      //Habilitamos las prioridades de interrupcion
    INTCONbits.GIEH = 1;    //Interrupciones globales HP ON
    INTCONbits.GIEL = 1;    //Interrupciones globales LP ON
    INTCON3bits.INT1E = 1;  //Habilitador de interrupciones de INT1
    INTCON3bits.INT1IP = 0; //Low priority para INT1
    IPR1bits.CCP1IP = 1;    //CCP alta prioridad
    //T1CON = 0x8B;           
    T1CON = 0xFA;           //Habilitando Timer1
    TMR1H = 0xFF;
    TMR1L = 0xFF;
    //CCPR1H = 0x80;
    CCPR1H = 0;
    //CCPR1L = 0x00;
    CCPR1L = 41;          //Valores iniciales de comparacion
    CCP1CON = 0x0B;         //Arrancamos el CCP en comparador 
    PIE1bits.CCP1IE = 1;    //Habilitamos la interrupcio  de CCP1
    
    __delay_ms(500);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
    DO_PWM(0.0);
    
    while(1){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("   Cronometro", 13);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Hora:   ",8);
        
        DIGITOS(minutos);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        ESCRIBE_MENSAJE(":",1);
        
        DIGITOS(segundos);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        ESCRIBE_MENSAJE(":",1);
        
        DIGITOS(milisegundos);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        
        if(segundos%5==0 & segundos>0){
            if(milisegundos < 15){
                if(T1CONbits.TMR1ON == 1){
                    CAMPANADA(1);
                }
            }
        }
        if(minutos > 0){
            if(segundos == 0){
                if(milisegundos < 15){
                    if(T1CONbits.TMR1ON == 1){
                        CAMPANADA(2);
                    }
                }
            }
        }
    }
}

void __interrupt(high_priority) Timer1_CCP(void){
    PIR1bits.CCP1IF = 0;      //bajamos la badera
    milisegundos = milisegundos + 1;
    if(milisegundos == 100){
        milisegundos = 0;
        segundos = segundos + 1;
        if(segundos == 60){
            segundos = 0;
            minutos = minutos + 1;
            if(minutos == 60){
                minutos = 0;
            }
        }
    }
}

void __interrupt(low_priority) Int1(void){
    INTCON3bits.INT1F = 0;      //bajamos la baderita
    T1CONbits.TMR1ON = !T1CONbits.TMR1ON;
}