    list p=18f4550
    #include <p18f4550.inc>
    ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
    CONFIG FOSC = XT_XT
    CONFIG PWRT =ON
    CONFIG BOR= OFF
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG LVP = OFF

    
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    bcf TRISD,0
    movlw 0xC8
    movwf T0CON
    
inicio:
    movlw .6
    movwf TMR0L
papa:
    btfss INTCON, TMR0IF
    goto papa
    clrf INTCON, TMR0IF
    btg LATD,0
    goto inicio
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    