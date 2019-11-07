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
    bsf TRISD,7
    bsf TRISB,7
    movlw UPPER tabla7s
    movwf TBLPTRU
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL
    movlw .1
    movwf dece
    movlw .5
    movwf uni
    call displayada
    goto debounce1
    
sele:
    call delaymon
    call displayada
    btfsc PORTD,7
    goto inicioarriba
    goto inicioabajo
    
inicioabajo:
    movlw .1
    cpfseq dece
    goto decefalso
    goto deceverdad
    
decefalso:
    movlw .0
    cpfseq uni
    goto unifalso
    goto univerdad

unifalso:
    decf uni,f
    goto debounce2
    
univerdad:
    movlw .9
    movwf uni
    decf dece,f
    goto debounce2
    
deceverdad:
    movlw .5
    cpfseq uni
    goto unifalso1
    goto univerdad1

unifalso1:
    decf uni,f
    goto debounce2
    
univerdad1:
    movlw .6
    movwf dece
    movlw .4
    movwf uni
    goto debounce2
    
;________________________________;
inicioarriba:
    movlw .6
    cpfseq dece
    goto decefalso1
    goto deceverdad1
    
decefalso1:
    movlw .9
    cpfseq uni
    goto unifalso2
    goto univerdad2

unifalso2:
    incf uni,f
    goto debounce2
    
univerdad2:
    movlw .0
    movwf uni
    incf dece,f
    goto debounce2
    
deceverdad1:
    movlw .4
    cpfseq uni
    goto unifalso3
    goto univerdad3

unifalso3:
    incf uni,f
    goto debounce2
    
univerdad3:
    movlw .1
    movwf dece
    movlw .5
    movwf uni
    goto debounce2
;______________________________;  
    
debounce1:
    btfss PORTB,7
    goto debounce1
    call bucle2
    goto sele
    
debounce2:
    btfsc PORTB,7
    goto debounce2
    call bucle2
    goto debounce1
;______________________________;
displayada:
    clrf TBLPTRL
    movf uni, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    
    clrf TBLPTRL
    movf dece, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATB
    return 
    
;_______________________________;
delaymon: 
    movlw .30
    movwf cta_a

otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return 
bucle2:
    movlw .30
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
    