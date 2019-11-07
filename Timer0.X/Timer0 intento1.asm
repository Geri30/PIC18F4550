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
	cta_a
	cta_b
	cta_c
	uni
	dece
    endc

    org 0x0200
tabla7s db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x79, 0x79,0x79,0x79,0x79,0x79
  
    org 0X0000
    goto configura
    org 0x0020
    
configura:
    clrf TRISD ;definiendo D como salida
    clrf TRISB ;definiendo B como salida
    movlw 0x80
    movwf TRISD 
    movlw UPPER tabla7s
    movwf TBLPTRU
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL
    
inicio:
    btfss PORTD,7
    goto abajo
    goto arriba

arriba:
    movlw .9
    cpfseq uni
    goto incrementauni
    clrf uni
    movlw .3
    cpfseq dece
    goto incrementadece
    clrf dece
    goto visual

incrementauni:
    incf uni
    goto visual
    
incrementadece:
    incf dece
    goto visual
    
abajo:
    movlw .0
    cpfseq uni
    goto desciendeuni
    movlw .9
    movwf uni
    movlw .0
    cpfseq dece
    goto desciendedece
    movlw .3
    movwf dece
    goto visual

desciendeuni:
    decf uni
    goto visual
    
desciendedece:
    decf dece
    goto visual

visual:
    clrf TBLPTRL
    movf uni, W
    movwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    
    clrf TBLPTRL
    movf dece, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATB
    call delaymon
    goto inicio
    
;_______________________________;
delaymon: 
    movlw .50
    movwf cta_a

otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return 
    
bucle2:
    movlw .90
    movwf cta_b
    
otro2:
    call bucle3
    decfsz cta_b, f
    goto otro2
    return 

bucle3:
    movlw .10
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return

    end
    
    
    
    