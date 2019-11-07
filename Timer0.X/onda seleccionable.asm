    list p=18f4550
    #include <p18f4550.inc>
    ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
    CONFIG FOSC = XT_XT
    CONFIG PWRT =ON
    CONFIG BOR= OFF
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG LVP = OFF

    cblock 0x0020
    temporal   
    endc
    
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    bcf TRISD,0
    movlw 0xC1
    movwf T0CON
    
inicio:
    movf PORTB, W
    andlw 0x03
    movwf temporal
    movlw 0x00
    cpfseq temporal
    goto otro1
    goto sel_10

otro1:
    movlw 0x01
    cpfseq temporal
    goto otro2
    goto sel_30
otro2:
    movlw 0x02
    cpfseq temporal
    goto sel_100
    goto sel_70
    
sel_10:
    bsf LATD,0
    movlw .231
    movwf TMR0L
nan1:
    btfss INTCON, TMR0IF
    goto nan1
    bcf INTCON, TMR0IF
    bcf LATD,0
    movlw .31
    movwf TMR0L
nan2:
    btfss INTCON, TMR0IF
    goto nan2
    goto finalon

sel_30:
    bsf LATD,0
    movlw .181
    movwf TMR0L
nan3:
    btfss INTCON, TMR0IF
    goto nan3
    bcf INTCON, TMR0IF
    bcf LATD,0
    movlw .81
    movwf TMR0L
nan4:
    btfss INTCON, TMR0IF
    goto nan4
    goto finalon

sel_70:
    bsf LATD,0
    movlw .81
    movwf TMR0L
nan5:
    btfss INTCON, TMR0IF
    goto nan5
    bcf INTCON, TMR0IF
    bcf LATD,0
    movlw .181
    movwf TMR0L
nan6:
    btfss INTCON, TMR0IF
    goto nan6
    goto finalon
    
sel_100:
    bsf LATD,0
    movlw .181
    goto finalon
    
finalon:
    bcf INTCON, TMR0IF
    goto inicio
    
    end


    
    
    
    
    
    