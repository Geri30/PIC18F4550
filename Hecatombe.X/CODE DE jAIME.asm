    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;libreria de nombres
    
;zona de configuracion de los bits de configuracion del microcontrolador
   
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    org 0x0200
tabla7s db 0xBF,0x86,0xDB,0xCF,0xE6,0xED,0xFD,0x87,0xFF,0xE7
    
    cblock 0x0020
	cta_a
	cta_b
	cta_c
	seg_a
	seg_b
	min_a
	min_b
	endc
 
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0008
    goto nivela
    
    org 0x0020			;zona de programa de usuario
    
    
configura:
    movlw UPPER tabla7s
    movwf TBLPTRU
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL
    ;configuro el puntero
    clrf TRISD	;ver digitos;
    clrf TRISA
    clrf TRISB  ;selector de mux y cables de la bomba;  
    movlw 0x83
    movwf T0CON
    movlw 0xA0
    movwf INTCON
    movlw .1
    movwf min_b
    movlw .0
    movwf min_a
    movwf seg_b
    movwf seg_a
    bsf TRISE, 0
    bsf TRISE, 1
    bsf TRISB, 4
    bsf TRISB, 5
    bsf TRISB, 6
    bsf TRISB, 7
    
    
    
inicio:
    bcf LATA, 0
    bcf LATA, 1
    bcf LATA, 2
    movlw .1
    movwf min_b
    movlw .0
    movwf min_a
    movwf seg_b
    movwf seg_a
    movlw 0xBF
    movwf LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    movlw 0xBF
    movwf LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    movlw 0xBF
    movwf LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    movlw 0x86
    movwf LATD
    bcf LATB,3
    call bucle2
    bsf LATB,3
    btfsc PORTC, 7
    goto inicio
    goto real
    
real:
    call displayada
    btfsc PORTB, 4
    goto win
    bcf LATE, 0
    btfsc PORTB, 5
    goto lose
    bcf LATE, 1
    btfsc PORTB, 6
    goto duplica
    btfsc PORTB, 7
    goto divide
    goto real
    
lose:
    bsf LATA, 2
    movlw 0x37
    movwf LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    
    movlw 0x3F
    movwf LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    
    movlw 0x3F
    movwf LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    
    movlw 0x7C
    movwf LATD
    bcf LATB,3
    call bucle2
    bsf LATB,3
   
    goto lose
win:
    bsf LATA, 1
    movlw 0x76
    movwf LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    
    movlw 0x77
    movwf LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    
    movlw 0x79
    movwf LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    
    movlw 0x6E
    movwf LATD
    bcf LATB,3
    call bucle2
    bsf LATB,3
    goto win

duplica:
    movlw 0x81
    movwf T0CON
    movlw 0xA0
    movwf INTCON
    btfsc PORTB, 7
    goto iniciofinal
    goto inicioafterduplica
    
divide: 
    movlw .0
    movwf min_b
    movlw .1
    movwf min_a
    movlw .0
    movwf seg_b
    movlw .0
    movwf seg_a
    btfsc PORTB, 6
    goto iniciofinal
    goto inicioafterdivide    
    
inicioafterduplica:   
    call displayada
    btfsc PORTB, 4
    goto win
    bcf LATE, 0
    btfsc PORTB, 5
    goto lose
    bcf LATE, 1
    btfsc PORTB, 7
    goto divide
    goto inicioafterduplica
    
inicioafterdivide:    
    call displayada
    btfsc PORTB, 4
    goto win
    bcf LATE, 0
    btfsc PORTB, 5
    goto lose
    bcf LATE, 1
    btfsc PORTB, 6
    goto duplica
    goto inicioafterdivide
    
iniciofinal:
    call displayada
    btfsc PORTB, 4
    goto win
    bcf LATE, 0
    btfsc PORTB, 5
    goto lose
    bcf LATE, 1
    goto iniciofinal
    
    
displayada:
    clrf TBLPTRL
    movf seg_a, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    ;-----------------;
    clrf TBLPTRL
    movf seg_b, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    ;----------------;
    clrf TBLPTRL
    movf min_a, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    ;-----------------;
    clrf TBLPTRL
    movf min_b, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,3
    call bucle2
    bsf LATB,3
    ;-----------------;
    return
    
    ;-----------------------------;
    org 0x0300
nivela:
    btg LATA, 0
    bcf INTCON,TMR0IF
    movlw 0xDC
    movwf TMR0L
    movlw 0x0B
    movwf TMR0H
    movlw .0
    cpfseq min_b
    goto nivel2a
    goto nivel2b
;-----------------------------;
nivel2a:
    movlw .0
    cpfseq min_a
    goto nivel3a
    goto nivel3b
nivel2b:
    movlw .0
    cpfseq min_a
    goto nivel3c
    goto nivel3d
;----------------------------;    
nivel3a:
    movlw .0
    cpfseq seg_b
    goto nivel4a
    goto nivel4b
nivel3b:
    movlw .0
    cpfseq seg_b
    goto nivel4c
    goto nivel4d
nivel3c:
    movlw .0
    cpfseq seg_b
    goto nivel4e
    goto nivel4f
nivel3d:
    movlw .0
    cpfseq seg_b
    goto nivel4g
    goto nivel4h
;----------------------------;
nivel4a:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto verde
nivel4b:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto azul
nivel4c:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto verde
nivel4d:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto amarillo
nivel4e:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto verde
nivel4f:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto azul
nivel4g:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto verde
nivel4h:
    movlw .0
    cpfseq seg_a
    goto rosado
    goto lose
;----------------;
rosado:
    decf seg_a,f
    btg LATA, 0
    retfie
verde:
    decf seg_b,f
    movlw .9
    movwf seg_a
    btg LATA, 0
    retfie
azul:
    decf min_a,f
    movlw .5
    movwf seg_b
    movlw .9
    movwf seg_a
    btg LATA, 0
    retfie
amarillo:
    decf min_b,f
    movlw .9
    movwf min_a
    movlw .5
    movwf seg_b
    movlw .9
    movwf seg_a
    btg LATA, 0
    retfie

    
;----------------------------------------------;    

delaymon:
    movlw .100
    movwf cta_a
otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return

bucle2:
    movlw .10
    movwf cta_b
otro2:
    call bucle3
    decfsz cta_b, f
    goto otro2
    return

bucle3:
    movlw .100
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return
    
fin:	
    nop
    goto fin
       
    end