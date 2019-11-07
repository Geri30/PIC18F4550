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



#include <xc.h>
#include "DHT11_libreria.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;


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



void main(void) {
   
    int temp,dtemp,hum,dhum,status;
    int chekin;
  
    
     //Configuracion del LCD
    __delay_ms(500);
    TRISD = 0x00;       //Puerto donde esta conectado el LCD
    LCD_CONFIG();       //Configuracion inicial del LCD
    __delay_ms(15);
    CURSOR_ONOFF(OFF);     //Cursor apagao
     
    TRISD = 0;
    
    
    while(1){
        
        DHT11_init();
        status = DHT11_CheckResponse();
               
        if (status){
            chekin = DHT11_ReadData(&hum,&dhum,&temp,&dtemp);
            
            CURSOR_HOME();
            ESCRIBE_MENSAJE("TEMPERTRE:",10);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("HUMIDITY:",9);
            
            if (chekin){
            POS_CURSOR(1,10);
            DIGITOS(temp);
            ENVIA_CHAR(digdec+0x30);    //Impresion de la hora en el LCD
            ENVIA_CHAR(diguni+0x30);
            ENVIA_CHAR(0x2E);
            ENVIA_CHAR(dtemp+0x30);
            ENVIA_CHAR(0xDF);
            ENVIA_CHAR(0x43);
            POS_CURSOR(2,9);
            DIGITOS(hum);
            ENVIA_CHAR(digdec+0x30);    //Impresion de la hora en el LCD
            ENVIA_CHAR(diguni+0x30);
            ENVIA_CHAR(0x2E);
            ENVIA_CHAR(dhum+0x30);
            ENVIA_CHAR(0x25);
            }
            
            else{
                CURSOR_HOME();
            
                ESCRIBE_MENSAJE("    ERROR DE    ",16);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("    CHECKSUM    ",16);
            
                __delay_ms(3000);
            
            }
        }
     }
    
}