    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    bcf TRISB,0	    ;salida b0
    bcf TRISB,1	    ;salida b1
    bsf TRISB,2	    ;entrada b2
    bsf TRISB,3	    ;entrada b3
    clrf TRISD
    movlw 0xC2
    movwf T0CON
    
cambia:
    btfss PORTB,3
    goto escero
    goto esuno
escero:
    movlw 0x3F
    movwf LATD
    goto laonda
esuno:  
    movlw 0x06
    movwf LATD
    goto laonda
laonda:
    btfss PORTB,2
    goto normal
    goto volteado
normal:    
    bsf LATB,0
    bcf LATB,1
    goto primero
volteado:
    bcf LATB,0
    bsf LATB,1
    goto primero
primero:
    movlw .219
    movwf TMR0L
continuaprimero:    
    btfss INTCON,TMR0IF
    goto continuaprimero
    btg LATB,0
    btg LATB,1
    bcf INTCON, TMR0IF
    movlw .219 
    movwf TMR0L
segundo:    
    btfss INTCON,TMR0IF
    goto segundo
    btg LATB,0
    btg LATB,1
    bcf INTCON, TMR0IF
    movlw .219
    movwf TMR0L
tercero:
    btfss INTCON,TMR0IF
    goto tercero
    btg LATB,0
    btg LATB,1
    bcf INTCON,TMR0IF
    movlw .119
    movwf TMR0L
cuarto:
    btfss INTCON,TMR0IF
    goto cuarto
    btg LATB,0
    btg LATB,1
    bcf INTCON,TMR0IF
    goto cambia
    end
    
   
    
    
    
    
    