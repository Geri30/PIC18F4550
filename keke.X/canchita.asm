    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0000
    goto inicio
    
    org 0x0020
    
inicio:
    BCF TRISB,0		;SALIDA
    BSF TRISD,0		;ENTRADA
    
PREGUNTA:
    BTFSS PORTD,0
    GOTO FALSO
    GOTO VERDAD
    
FALSO:
    BSF LATB,0
    GOTO PREGUNTA
VERDAD:
    BCF LATB,0
    GOTO PREGUNTA
    
    end
