    list p=18f4550    
    #include "p18f4550.inc"
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0000			;Vector de reset
    goto inicio
    org 0x0020

inicio:
    setf TRISB			;entrada bsf
    clrf TRISD			;salida bcf
pregunta1:
    btfss PORTB,0
    goto falsa1
    goto verdad1
falsa1:
    btfss PORTB,1
    goto falsa2 
    goto verdad2
verdad1:
    btfss PORTB,1
    goto verdad2
    goto falsa2
falsa2:
    btfss PORTB,2
    goto xor0
    goto xor1
verdad2:
    btfss PORTB,2
    goto xor1
    goto xor0
xor1:
    bsf LATD,0
    goto pregunta1
xor0:
    bcf LATD,0
    goto pregunta1   
    
    
    end