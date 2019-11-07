#pragma config PLLDIV = 1       
#pragma config CPUDIV = OSC1_PLL2
#pragma config FOSC = XTPLL_XT     
#pragma config PWRT = ON       
#pragma config BOR = ON        
#pragma config BORV = 3        
#pragma config WDT = OFF      
#pragma config PBADEN = OFF     
#pragma config MCLRE = ON       
#pragma config LVP = OFF 
#include <xc.h>
#include <pic18f4550.h>
#include "LCD.h"
#define SUBE 1
#define BAJA 3
char estado = 0;
signed int angulo=0;
char grados[]={0x0C,0x12,0x12,0x0C,0x00,0x00,0x00,0x00};
void main()
{
    LATCbits.LATC0=0;
    LATCbits.LATC1=0;
    TRISCbits.RC0=0;
    TRISCbits.RC1=0;
    TRISD = 0;
    TRISB = 0xFF;
    __delay_ms(15);
    LCD_CONFIG();
    GENERACARACTER(grados,0);
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("ANGULO: ",8);
    CURSOR_ONOFF(OFF);
    if(angulo<0)
    {
        ENVIA_CHAR('-');
        ENVIA_CHAR((angulo*-1)/10+'0');
        ENVIA_CHAR((angulo*-1)%10+'0');
    }
    else 
    {
        ENVIA_CHAR((angulo)/10+'0');
        ENVIA_CHAR((angulo)%10+'0');
    }
    ENVIA_CHAR(0);
    CCP1CON = 0x0B; //Modo de comparaci?n especial.
    CCPR1H = 0x75;
    CCPR1L = 0x21;
    TMR1L  = 0;
    TMR1H  = 0;
    T1CON  = 0x31; //Timer 1 ON, Prescaler = 8
    T0CON =  0x02; //Timer 0 OFF, Prescaler = 8,modo 16bits
    PIE1bits.CCP1IE=1;
    INTCONbits.TMR0IE=1;
    TMR0 = 65050; // 65091
    INTCONbits.INT0IE=1;
    INTCON3bits.INT1IE=1;
    INTCONbits.PEIE=1;
    INTCONbits.GIE=1;
    while(1)
    {
        switch(estado)
        {
            case SUBE:
                estado = 0;
                if(angulo<-90)
                {
                    angulo=-90;
                    POS_CURSOR(2,0);
                    ESCRIBE_MENSAJE("ESTA AL MINIMO",14);
                    break;
                }
                if(angulo>90)
                {
                    angulo=90;
                    POS_CURSOR(2,0);
                    ESCRIBE_MENSAJE("ESTA AL MAXIMO",14);
                    break;
                }
                if(angulo<0)
                {
                    POS_CURSOR(2,0);
                    ESCRIBE_MENSAJE("              ",14);
                    POS_CURSOR(1,8);
                    ENVIA_CHAR('-');
                    ENVIA_CHAR((angulo*-1)/10+'0');
                    ENVIA_CHAR((angulo*-1)%10+'0');
                }
                else 
                {
                    POS_CURSOR(2,0);
                    ESCRIBE_MENSAJE("              ",14);
                    POS_CURSOR(1,8);
                    ENVIA_CHAR((angulo)/10+'0');
                    ENVIA_CHAR((angulo)%10+'0');
                }
                ENVIA_CHAR(0);
                break;   
        }
    }
}
void interrupt high_priority periodo(void){
    int var=0;
    if(PIR1bits.CCP1IF==1)
    {
        LATCbits.LATC0=1;
        var = 90+angulo;
        TMR0 = 65097-var*15; // 65097
        T0CONbits.TMR0ON=1;
        PIR1bits.CCP1IF=0;
    }
    else if(INTCONbits.TMR0IF==1)
    {
        LATCbits.LATC0=0;
        T0CONbits.TMR0ON=0;
        INTCONbits.TMR0IF=0;
    }
    else if(INTCONbits.INT0IF==1)
    {
        INTCONbits.INT0IF=0;
        angulo++;
        estado = SUBE;
    }
    else if(INTCON3bits.INT1IF==1)
    {
        INTCON3bits.INT1IF=0;
        angulo--;
        estado = SUBE;
    }
}