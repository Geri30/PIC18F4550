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

#define _XTAL_FREQ 48000000UL

unsigned char min=0, seg=0,hora=47,megahora=13;
unsigned int cent=0;


int temp,dtemp,hum,dhum,status;
int chekin;
int tempB,dtempB,humB,dhumB,statusB;
int chekinB;



void valoresB(void){
    TRISCbits.RC6 = 0;  // salida
    LATCbits.LATC6 = 0;  // pulso 0
    __delay_ms(18);  // espera 18 ms
    LATCbits.LATC6= 1;  // puslo 1
    __delay_us(20);  // espera 20 us
    TRISCbits.RC6 = 1;  // ahora como entrada
    statusB = DHT11_CheckResponseB();   // ESTADO DE EL DHT11
    if (statusB){
        chekinB = DHT11_ReadDataB(&humB,&dhumB,&tempB,&dtempB);
        CURSOR_HOME();
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T:",2);
        POS_CURSOR(2,9);
        ESCRIBE_MENSAJE("H:",2);
        
        if (chekinB){
        POS_CURSOR(2,2);
        //Impresion de la temp en el LCD
        ENVIA_CHAR(tempB/10+'0');    
        ENVIA_CHAR(tempB%10+'0');
        ENVIA_CHAR('.');
        ENVIA_CHAR(dtempB+'0');
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        POS_CURSOR(2,11);
        //Impresion de la hum en el LCD
        ENVIA_CHAR(humB/10+'0');    
        ENVIA_CHAR(humB%10+'0');
        ENVIA_CHAR('.');
        ENVIA_CHAR(dhumB+'0');
        ENVIA_CHAR('%');
        }
       
    }
}

void valores(void){
    
    TRISCbits.RC7 = 0;  // salida
    LATCbits.LATC7 = 0;  // pulso 0
    __delay_ms(18);  // espera 18 ms
    LATCbits.LATC7= 1;  // puslo 1
    __delay_us(20);  // espera 20 us
    TRISCbits.RC7 = 1;  // ahora como entrada
    status = DHT11_CheckResponse();   // ESTADO DE EL DHT11
    if (status){
        chekin = DHT11_ReadData(&hum,&dhum,&temp,&dtemp);
        CURSOR_HOME();
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T:",2);
        POS_CURSOR(2,9);
        ESCRIBE_MENSAJE("H:",2);
        
        if (chekin){
        POS_CURSOR(2,2);
        //Impresion de la temp en el LCD
        ENVIA_CHAR(temp/10+'0');    
        ENVIA_CHAR(temp%10+'0');
        ENVIA_CHAR('.');
        ENVIA_CHAR(dtemp+'0');
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        POS_CURSOR(2,11);
        //Impresion de la hum en el LCD
        ENVIA_CHAR(hum/10+'0');    
        ENVIA_CHAR(hum%10+'0');
        ENVIA_CHAR('.');
        ENVIA_CHAR(dhum+'0');
        ENVIA_CHAR('%');
        }
      
    }
}


int salida= 0;







int main(void)
{
    
    TRISD =0x00; // PUERTO D SALIDA PARA DISPLAY 
    // CONFIGURACION DE LCD
    
    
    // CONFIG PARA LCD
    __delay_ms(50);
    LCD_CONFIG();
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
    
    // CONFIG PARA TECLADO MATRICIAL
    
    
    TRISB|=(15<<4);
    TRISB&=~(15<<0); 
    PORTB|=(15<1);
    
    INTCON = 0X00;
    INTCON2bits.RBPU = 0; // RESISTENCIAS PULLUP RB4-7
    //INTCONbits.GIE = 1; // INTERRUPCIONES GLOBALES
    INTCONbits.RBIE = 1 ; // INTERRUPCIONES PUERTO B
    INTCONbits.RBIF = 0 ; // BANDERA INTERRUPCIONES PUERTO B
    
    
    // CONFIG RTC 
    
    TMR1H=0xFF;     //cuenta inicial para el timer1 no se demore 16 seg 
    TMR1L=0xFF;     //al comienzo como un timer unico y detergente
    T1CON=0xEB;     //PSC 1:16 cristal externo 1110 10 10
    
    //coso del ccp1
    CCP1CON=0x0B; 
    CCPR1H=0x00;
    CCPR1L=41;
    PIE1bits.CCP1IE=1;  // CCP1 INTERRUPT 1 ENABLE 0 DISABLE
    IPR1bits.CCP1IP=1; // CCP1 PRIORITY INTERRUP 1 HIGH 0 LOW
    
    //coso del int1
    //INTCON2bits.INTEDG1=1; // INTERRUPCIONES EXTERNAS 0 EDGE 1 EN RISING 0 EN FALLING
    //INTCON3bits.INT1IE=1; //INT1 EXTERNAL INTERRUPT 1 ENABLE 0 DISABLE
    //INTCON3bits.INT1IP=0; // INT1 EXTERNAL INTERRUP PRIORITY 1 HIGH 0 LOW
    
    //coso para interrupciones
    RCONbits.IPEN = 1;      //activo interrupciones altas y bajas
    INTCONbits.GIEH = 1;    //interrupciones de alta prioridad
    INTCONbits.GIEL = 1;    //interrupciones de baja prioridad
    
    INTCONbits.PEIE=1; // INTERRUPCION DE PERIFERICOS 
    //WHEN IPEN =1 - 1 ENABLES ALL LOW PRIORITY INTERRUPS 
    //0 DISABLE ALL LOW PRIORITY INTERRUPS 
    //WHEN IPEN = 0 - ENABLES ALL UNMASKET PERIPHERLA INTERRUPS
    //0 DISABLES ALL PERIPHERAL INTERRUPS
    
    
    
    //MOSTRAR HORA
    
    CURSOR_HOME();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("TIMER:",6);
    POS_CURSOR(1,7);
    ENVIA_CHAR(megahora/10+'0');
    ENVIA_CHAR(megahora%10+'0');
    ENVIA_CHAR(':');
    ENVIA_CHAR(hora/10+'0');
    ENVIA_CHAR(hora%10+'0');
    ENVIA_CHAR(':');
    ENVIA_CHAR(min/10+'0');
    ENVIA_CHAR(min%10+'0');
        //ENVIA_CHAR((cent%10)+'0');
    while(1){
        
 
        
       
        
        
        for(int c=0;c<4;c++){
            PORTB&=~(1<<c); 
            PORTB|=(1<<c);
        }
   
        switch(salida){
            case 1:
                valores();
                break;
            case 2:
            
                valoresB();
                break;
                
            case 3:
                
                for(int cont=0;cont<6;cont++){
                valores();
                __delay_ms(2000);
                
                for (int cont2=0;cont2<6;cont2++) {
                __delay_ms(400);
                valoresB();
                cont=0;
                    }
                }
                
                break;
            case 4:
                
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("T:",2);
                POS_CURSOR(2,2);
        //Impresion de la temp en el LCD
                uint24_t Ftemp = 0;
                Ftemp= 32 + (temp * 1.8);
                ENVIA_CHAR(Ftemp/10+'0');    
                ENVIA_CHAR(Ftemp%10+'0');

                ENVIA_CHAR(0xDF);
                ENVIA_CHAR('F');
                
                break;
            default:
                break;
            
    }
    }}

int DHT11_CheckResponse(void){
    int cont = 0;
    while(PORTCbits.RC7){
        cont ++;
        if (cont == 500){
            return 0;
        }   
    };  // espera un 0 y se rompe
    cont = 0;
    while(PORTCbits.RC7==0 ){  // espera un 1 y se rompe
       cont ++;
        if (cont == 500){
            return 0;
        }
    };
    cont = 0;
    while(PORTCbits.RC7){  // espera un 0 y se rompe 
            cont ++;
        if (cont == 500){
            return 0;
        }
    };
    return 1; // conexion correcta 
}

int DHT11_ReadData(int *hum,int *dhum,int *temp, int *dtemp) {
    uint24_t bits[5];
    int data,cont_read;
    
    for (int i=0; i < 5; i++){
        data = 0;
    for(int j=0;j<8;j++)
    {
        cont_read = 0;
        while(PORTCbits.RC7==0){
        cont_read ++;
        if (cont_read == 500){
            return 0;
        }
        };  // se rompe si es 1
        __delay_us(30);         // tiempo para concer si el bit es 1 o 0
        if(PORTCbits.RC7) { // si al pasar el tiempo sigue en 1 entonces es 1   
          data = ((data<<1) | 1);
        }
        else{                  // si al sobrepasar el tiempo es 0 entonces es 0
          data = (data<<1);}
        cont_read = 0;
        while(PORTCbits.RC7){
        cont_read ++;
        if (cont_read == 500){
            return 0;
        }
        }; // se rompe si es 0
    }
        bits[i] = data;
    }
    if ((bits[0] + bits[1] + bits[2] + bits[3]) == bits[4])	//Pregunta por el chekin
	{
        *hum = bits[0];
        *dhum = bits[1];
        *temp = bits[2];
        *dtemp = bits[3];
        return 1;
    }
    return 0;
}

int DHT11_CheckResponseB(void){
    int contB = 0;
    while(PORTCbits.RC6){
        contB ++;
        if (contB == 500){
            return 0;
        }   
    };  // espera un 0 y se rompe
    contB = 0;
    while(PORTCbits.RC6==0 ){  // espera un 1 y se rompe
       contB ++;
        if (contB == 500){
            return 0;
        }
    };
    contB = 0;
    while(PORTCbits.RC6){  // espera un 0 y se rompe 
            contB ++;
        if (contB == 500){
            return 0;
        }
    };
    return 1; // conexion correcta 
}

int DHT11_ReadDataB(int *humB,int *dhumB,int *tempB, int *dtempB) {
    uint24_t bitsB[5];
    int dataB,cont_readB;
    
    for (int i=0; i < 5; i++){
        dataB = 0;
    for(int j=0;j<8;j++)
    {
        cont_readB = 0;
        while(PORTCbits.RC6==0){
        cont_readB ++;
        if (cont_readB == 500){
            return 0;
        }
        };  // se rompe si es 1
        __delay_us(30);         // tiempo para concer si el bit es 1 o 0
        if(PORTCbits.RC6) { // si al pasar el tiempo sigue en 1 entonces es 1   
          dataB = ((dataB<<1) | 1);
        }
        else{                  // si al sobrepasar el tiempo es 0 entonces es 0
          dataB = (dataB<<1);}
        cont_readB = 0;
        while(PORTCbits.RC6){
        cont_readB ++;
        if (cont_readB == 500){
            return 0;
        }
        }; // se rompe si es 0
    }
        bitsB[i] = dataB;
    }
    if ((bitsB[0] + bitsB[1] + bitsB[2] + bitsB[3]) == bitsB[4])	//Pregunta por el chekin
	{
        *humB = bitsB[0];
        *dhumB = bitsB[1];
        *tempB = bitsB[2];
        *dtempB = bitsB[3];
        return 1;
    }
    return 0;
}
void __interrupt(low_priority) teclado(void)
{   
    if(INTCONbits.RBIF==1){
    
        INTCONbits.RBIF = 0;//  bajamos la bandera
        int a;
        a=PORTB;
        __delay_us(1);
        
               
        
        if ((PORTBbits.RB4 == 0)&&(PORTBbits.RB0 == 0)){
                BORRAR_LCD();
                salida=1;
                }
        
        else if ((PORTBbits.RB5 == 0)&&(PORTBbits.RB0 == 0)){
                BORRAR_LCD();
                salida=2;}
        
        if ((PORTBbits.RB6 == 0)&&(PORTBbits.RB0 == 0)){
                BORRAR_LCD();
                salida=3;    }
            
        else if ((PORTBbits.RB7 == 0)&&(PORTBbits.RB0 == 0)){
                BORRAR_LCD();
                salida=4 ;  }
            
             
        



        if ((PORTBbits.RB4 == 0)&&(PORTBbits.RB1 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB4&RB1",7); }
            
        
        else if ((PORTBbits.RB5 == 0)&&(PORTBbits.RB1 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB5&RB1",7);}
            
        
        if ((PORTBbits.RB6 == 0)&&(PORTBbits.RB1 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB6&RB1",7);}
           
        
        else if ((PORTBbits.RB7 == 0)&&(PORTBbits.RB1 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB7&RB1",7);}
            
             




        if ((PORTBbits.RB4 == 0)&&(PORTBbits.RB2 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB4&RB2",7);}
              
        
        else if ((PORTBbits.RB5 == 0)&&(PORTBbits.RB2 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB5&RB2",7);}
      
        
        if ((PORTBbits.RB6 == 0)&&(PORTBbits.RB2 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB6&RB2",7);    }
         
         
        else if ((PORTBbits.RB7 == 0)&&(PORTBbits.RB2 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB7&RB2",7); }
           
          
        
        
        
        
        if ((PORTBbits.RB4 == 0)&&(PORTBbits.RB3 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB4&RB3",7);    }

        
        else if ((PORTBbits.RB5 == 0)&&(PORTBbits.RB3 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB5&RB3",7);    }

        
        if ((PORTBbits.RB6 == 0)&&(PORTBbits.RB3 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB6&RB3",7);  }
           
        
        else if ((PORTBbits.RB7 == 0)&&(PORTBbits.RB3 == 0)){
                BORRAR_LCD();
                CURSOR_HOME();
                POS_CURSOR(1,0);
                ESCRIBE_MENSAJE("MACHUCASTE",10);
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("RB7&RB3",7); }
            

   
    
        while((PORTBbits.RB4 == 0)||(PORTBbits.RB5 == 0)||(PORTBbits.RB6 == 0)||(PORTBbits.RB7 == 0));
        __delay_ms(30);
        while((PORTBbits.RB4 == 0)||(PORTBbits.RB5 == 0)||(PORTBbits.RB6 == 0)||(PORTBbits.RB7 == 0));
        __delay_ms(30);
        
    }}

void __interrupt(high_priority) elcomparador(void){
    PIR1bits.CCP1IF=0;
    cent=cent+1;
    if(cent==88){cent=0;seg++;}
    if(seg==60){seg=0;min++;}
    if(min==60){min=0;seg=0;cent=0;hora++;}
    if(hora==60){min=0;seg=0;hora=0;}
    if(megahora==24){min=0;seg=0;hora=0;megahora=0;megahora++;}
    }