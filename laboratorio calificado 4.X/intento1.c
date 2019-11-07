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
#include "LCD.h"
#include "ADC.h"
#include "Serial.h"
#include "DHT11_libreria.h"
#define _XTAL_FREQ 48000000UL

int entrada=0;

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

int temp,dtemp,hum,dhum,status;
int chekin;
    
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

void muestra_menu(void){
    TX_MENSAJE_EUSART("\fMicrocontroladores\n",20);
    TX_MENSAJE_EUSART("\rBienvenidos al LB4\n",20);
    TX_MENSAJE_EUSART("\rLa final de finales\n",21);
    TX_MENSAJE_EUSART("\rOpciones del menu:\n",20);
    TX_MENSAJE_EUSART("\r(A) - Visualizar en consola la temperatura\n",44);
    TX_MENSAJE_EUSART("\r(B) - Visualizar en consola la humedad\n",40);
    TX_MENSAJE_EUSART("\r(C) - Visualizar en servo la temperatura\n",42);
    TX_MENSAJE_EUSART("\r(D) - Visualizar en servo la humedad\n",38);
    TX_MENSAJE_EUSART("\r(E) - El servo artista\n",24);
    TX_MENSAJE_EUSART("\rIngreso:",9);
}

void valores(void){
    
    DHT11_init();
        status = DHT11_CheckResponse();
               
        if (status){
            chekin = DHT11_ReadData(&hum,&dhum,&temp,&dtemp);
            
            CURSOR_HOME();
            ESCRIBE_MENSAJE("TEMPERA:",8);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("HUMEDAD:",8);
            
            if (chekin){
            POS_CURSOR(1,9);
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
void main (void){
    //coso de puertos
    TRISD =0x00;
    
    // coso de LCD
    __delay_ms(50);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
    //coso del dht11
    
    //coso del serial
    
    //mensaje de bienvenida
    Abrir_Serial(_9600);
    muestra_menu();
    
    while(1){
        valores();
        switch(entrada){
            case 1:
                DIGITOS(temp);
                TX_CHAR_EUSART('\r');
                TX_CHAR_EUSART(digdec+'0');    //Impresion de la hora en el LCD
                TX_CHAR_EUSART(diguni+'0');
                TX_CHAR_EUSART('.');
                TX_CHAR_EUSART(dtemp+'0');
                TX_CHAR_EUSART('`');
                TX_CHAR_EUSART('C');
                if (entrada==0){muestra_menu();}
                break;
            
            case 2:
                DIGITOS(hum);
                TX_CHAR_EUSART('\r');
                TX_CHAR_EUSART(digdec+'0');    //Impresion de la hora en el LCD
                TX_CHAR_EUSART(diguni+'0');
                TX_CHAR_EUSART('.');
                TX_CHAR_EUSART(dhum+'0');
                TX_CHAR_EUSART('`');
                TX_CHAR_EUSART('C');
                if (entrada==0){muestra_menu();}
                break;
            case 3:
                TX_MENSAJE_EUSART("\rtemp en servo",14);
                if (entrada==0){muestra_menu();}
                break;
            
            case 4:
                TX_MENSAJE_EUSART("\rhume en servo",14);
                if (entrada==0){muestra_menu();}
                break;
            
            default:
                break;
            
        }
        
    }
    
}

void __interrupt (high_priority) ingreso(void){
    PIR1bits.RCIF = 0;
    if (RCREG == 'a'||RCREG == 'A'){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("aaaaaaaaa",8);
        
        TX_MENSAJE_EUSART("\fELIGIO TEMPERATURA EN CONSOLA:\n",32);
        TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
        
        entrada=1;
    }
    else if (RCREG == 'b' || RCREG == 'B'){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("bbbbbbbb",8);
        TX_MENSAJE_EUSART("\fELIGIO HUMEDAD EN CONSOLA:\n",28);
        TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
        entrada=2;
    }
    if (RCREG == 'c'||RCREG == 'C'){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("cccccccc",8);
        
        TX_MENSAJE_EUSART("\fELIGIO TEMPERATURA EN SERVO:\n",30);
        TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
        
        entrada=3;
    }
    else if (RCREG == 'd' || RCREG == 'D'){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("dddddddd",8);
        TX_MENSAJE_EUSART("\fELIGIO HUMEDAD EN SERVO:\n",26);
        TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
        
        entrada=4;
    }
    else if (RCREG == '\r'){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("achorao ",8);
        entrada=0;
    }
    
    
}