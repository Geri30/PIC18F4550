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

int temp,dtemp,hum,dhum,status;
int chekin;

unsigned int T_PWM = 2000;
unsigned int T_on_min = 50;
unsigned int T_on_max = 250;
unsigned int T_on = 0;
unsigned int T_off = 0;
    
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
    TX_MENSAJE_EUSART("\rIngrese una opcion:",20);
}

void valores(void){
    DHT11_init();
    status = DHT11_CheckResponse();
    if (status){
        chekin = DHT11_ReadData(&hum,&dhum,&temp,&dtemp);
        CURSOR_HOME();
        ESCRIBE_MENSAJE("TEMPERA: ",9);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("HUMEDAD: ",9);
        
        if (chekin){
        POS_CURSOR(1,9);
        //Impresion de la temp en el LCD
        ENVIA_CHAR(temp/10+'0');    
        ENVIA_CHAR(temp%10+'0');
        ENVIA_CHAR('.');
        ENVIA_CHAR(dtemp+'0');
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        POS_CURSOR(2,9);
        //Impresion de la hum en el LCD
        ENVIA_CHAR(hum/10+'0');    
        ENVIA_CHAR(hum%10+'0');
        ENVIA_CHAR('.');
        ENVIA_CHAR(dhum+'0');
        ENVIA_CHAR('%');
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

void ANGULO_SERVO(float grados){
    T_on = T_on_min + ((grados * (T_on_max - T_on_min)) / 180.0);
    T_off = T_PWM - T_on;
    LATEbits.LE0 = 1;
    for(unsigned int i = 0; i < T_on; i++){
        __delay_us(10);
    }
    LATEbits.LE0 = 0;
    for(unsigned int j = 0; j < T_off; j++){
        __delay_us(10);
    }
}

void main (void){
    //coso de puertos
    TRISD =0x00;
    TRISEbits.RE0=0;
    
    // coso de LCD
    __delay_ms(50);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
    
    //coso del serial
    Abrir_Serial(_9600);
    
    //mensaje de bienvenida
    muestra_menu();
    LATEbits.LE0= 0;
    
    while(1){
        valores();
        switch(entrada){
            case 1:
                TX_MENSAJE_EUSART("\fELIGIO TEMPERATURA EN CONSOLA:\n",32);
                TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
                TX_CHAR_EUSART('\r');
                TX_CHAR_EUSART(temp/10+'0');    
                TX_CHAR_EUSART(temp%10+'0');
                TX_CHAR_EUSART('.');
                TX_CHAR_EUSART(dtemp+'0');
                TX_CHAR_EUSART('`');
                TX_CHAR_EUSART('C');
                entrada=0;
                break;
            case 2:
                TX_MENSAJE_EUSART("\fELIGIO HUMEDAD EN CONSOLA:\n",28);
                TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
                TX_CHAR_EUSART('\r');
                TX_CHAR_EUSART(hum/10+'0');    
                TX_CHAR_EUSART(hum%10+'0');
                TX_CHAR_EUSART('.');
                TX_CHAR_EUSART(dhum+'0');
                TX_CHAR_EUSART('%');
                entrada=0;
                break;
            case 3:
                //rutina de servo
                for(int i=0;i<15;i++){
                ANGULO_SERVO(180-(temp*4.5+dtemp*0.45));
                }
                break;
            case 4:
                //rutina de servo
                for(int i=0;i<15;i++){
                ANGULO_SERVO(180-(hum-60)*4.5);
                }
                break;
            case 5:
                //rutina de servo
                for(int i=0;i<15;i++){
                ANGULO_SERVO(180);
                }
                for(int i=0;i<15;i++){
                ANGULO_SERVO(0);
                }
                break;
            default:
                break;
        }
    }
}

void __interrupt(high_priority) interrupcion(void){
        ///TRANSMISION SERIAL
        if (RCREG == 'a'||RCREG == 'A'){
            entrada=1;
        }
        else if (RCREG == 'b' || RCREG == 'B'){
            entrada=2;
        }
        if (RCREG == 'c'||RCREG == 'C'){
            TX_MENSAJE_EUSART("\fELIGIO TEMPERATURA EN SERVO:\n",30);
            TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
            entrada=3;
        }
        else if (RCREG == 'd' || RCREG == 'D'){
            TX_MENSAJE_EUSART("\fELIGIO HUMEDAD EN SERVO:\n",26);
            TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
            entrada=4;
        }
        else if (RCREG == 'e' || RCREG == 'E'){
            TX_MENSAJE_EUSART("\fELIGIO SERVO ARTISTA:\n",23);
            TX_MENSAJE_EUSART("\rPara ver el menu presione (ENTER)\n\r",36);
            entrada=5;
        }
        else if (RCREG == '\r'){
            muestra_menu();
            entrada=0;
        }
        else{
            TX_CHAR_EUSART(7);
        }
    PIR1bits.RCIF = 0;
}