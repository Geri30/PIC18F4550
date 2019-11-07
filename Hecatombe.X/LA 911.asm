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
tabla7s db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67,0x79
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
    
    ;----configuro el puntero----;
    
    clrf TRISD	    ;ver digitos;
    clrf TRISB	    ;selector de mux y cables de la bomba;  
    movlw 0x83	    ;seleccion del timer 0
    movwf T0CON	
    movlw 0xA0
    movwf INTCON    ;la bandera de interupcion
    movlw .6	    ;comienzo de cuenta inicial
    movwf min_b
    movlw .5
    movwf min_a
    movlw .0
    movwf seg_b
    movlw .0
    movwf seg_a

displayada:    
    ;-- Segundos A --;
    clrf TBLPTRL
    movf seg_a, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    ;-- Segundos B --;
    clrf TBLPTRL
    movf seg_b, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    ;-- Minutos A --;
    clrf TBLPTRL
    movf min_a, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    ;-- Minutos B --;
    clrf TBLPTRL
    movf min_b, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,3
    call bucle2
    bsf LATB,3
    ;-----------------;
   
    
    goto displayada 
    
;----- Rutina de interrupcion --------;
nivela:
    bcf INTCON,TMR0IF
    movlw 0xDC
    movwf TMR0L
    movlw 0x0B
    movwf TMR0H
    movlw .0
    cpfseq min_b
    goto nivel2a
    goto nivel2b
;-------- Nivel 2 ---------;
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
;-------- Nivel 3 ---------;
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
;-------- Nivel 4 ---------;
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
    goto rojo
;------ Cuadros finales -----;
rosado:
    decf seg_a,f
    retfie
verde:
    decf seg_b,f
    movlw .9
    movwf seg_a
    retfie
azul:
    decf min_a,f
    movlw .5
    movwf seg_b
    movlw .9
    movwf seg_a
    retfie
amarillo:
    decf min_b,f
    movlw .9
    movwf min_a
    movlw .5
    movwf seg_b
    movlw .9
    movwf seg_a
    retfie
rojo:
    goto boom
    retfie

boom:    
    movlw .10	    
    movwf min_b
    movlw .0
    movwf min_a
    movlw .1
    movwf seg_b
    movlw .10
    movwf seg_a
    goto displayada
    
;------ Secuencia de retardo ----;    

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
    
    return 
    
    end