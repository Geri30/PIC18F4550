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
tabla7s db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67
    
    cblock 0x0020
	cta_a
	cta_b
	cta_c
	UNI
	DECE
	CENT
	UNIP
	DECEP
	CENTP
	
    endc
    
    org 0x0000			;Vector de reset
    goto configura
    org 0x0008
    goto contador
    org 0x0020		

configura:
    movlw UPPER tabla7s
    movwf TBLPTRU
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL
    ;configuro el puntero
    clrf TRISD	    ;Display
    clrf TRISB	    ;mux
    bsf TRISB,3	    ;sube o baja
    
    ;-- CUENTA NORMAL,PAR O IMPAR --;
    bsf TRISB,4
    bsf TRISB,5
    bsf TRISB,6
    movlw 0x81
    movwf T0CON
    movlw 0xA0
    movwf INTCON
    ;---------------
    movlw .0
    movwf UNI
    movlw .0
    movwf DECE
    movlw .0
    movwf CENT
    ;----------------
    movlw .0
    movwf UNIP
    movlw .0
    movwf DECEP
    movlw .0
    movwf CENTP
   
inicio:
    btfss PORTB,4
    goto salto
    call displayada
salto:
    btfss PORTB,5
    goto inicio
    call displayadaa

    
;--------- INTERRUPCION ----------;
contador:
    bcf INTCON,TMR0IF
    movlw 0x3C
    movwf TMR0L
    movlw 0xB0
    movwf TMR0H
    btfss PORTB,4
    goto segundo
    goto normal
segundo:
    btfss PORTB,5
    retfie
    goto par

    
;--- Cuenta normal ---;
normal:    
;--- ARRIBA O ABAJO ---;
    btfss PORTB,3
    goto arriba
    goto abajo
;----- UP -----;
arriba:
    movlw .9
    cpfseq CENT
    goto nivel2a
    goto nivel2b
nivel2a:
    movlw .9
    cpfseq DECE
    goto nivel3a
    goto nivel3b
nivel2b:
    movlw .9
    cpfseq DECE
    goto nivel3c
    goto nivel3d
nivel3a:
    movlw .9
    cpfseq UNI
    goto verde
    goto celeste
nivel3b:
    movlw .9
    cpfseq UNI
    goto verde
    goto amarillo
nivel3c:
    movlw .9
    cpfseq UNI
    goto verde
    goto celeste
nivel3d:
    movlw .9
    cpfseq UNI
    goto verde
    goto rojo
;----- DOWN ------;
abajo:
    movlw .0
    cpfseq CENT
    goto nivel2c
    goto nivel2d
nivel2c:
    movlw .0
    cpfseq DECE
    goto nivel3e
    goto nivel3f
nivel2d:
    movlw .0
    cpfseq DECE
    goto nivel3g
    goto nivel3h
nivel3e:
    movlw .0
    cpfseq UNI
    goto naranja
    goto morado
nivel3f:
    movlw .0
    cpfseq UNI
    goto naranja
    goto plomo
nivel3g:
    movlw .0
    cpfseq UNI
    goto naranja
    goto morado
nivel3h:
    movlw .0
    cpfseq UNI
    goto naranja
    goto rojo
;---Acciones finales---------;
verde:
    incf UNI,f
    retfie
celeste:
    movlw .0
    movwf UNI
    incf DECE,f
    retfie
amarillo:
    movlw .0
    movwf UNI
    movlw .0
    movwf DECE
    incf CENT,f
    retfie
naranja:
    decf UNI,f
    retfie
morado:
    movlw .9
    movwf UNI
    decf DECE,f
    retfie
plomo:
    movlw .9
    movwf UNI
    movlw .9
    movwf DECE
    decf CENT,f
    retfie
rojo:
    retfie
    
;--- Cuenta par ---;
par:  
;--- ARRIBA O ABAJO ---;
    btfss PORTB,3
    goto arribaP
    goto abajoP
;----- UP -----;
arribaP:
    movlw .9
    cpfseq CENTP
    goto nivel2aP
    goto nivel2bP
nivel2aP:
    movlw .9
    cpfseq DECEP
    goto nivel3aP
    goto nivel3bP
nivel2bP:
    movlw .9
    cpfseq DECEP
    goto nivel3cP
    goto nivel3dP
nivel3aP:
    movlw .8
    cpfseq UNIP
    goto verdeP
    goto celesteP
nivel3bP:
    movlw .8
    cpfseq UNIP
    goto verdeP
    goto amarilloP
nivel3cP:
    movlw .8
    cpfseq UNIP
    goto verdeP
    goto celesteP
nivel3dP:
    movlw .8
    cpfseq UNIP
    goto verdeP
    goto rojoP
;----- DOWN ------;
abajoP:
    movlw .0
    cpfseq CENTP
    goto nivel2cP
    goto nivel2dP
nivel2cP:
    movlw .0
    cpfseq DECEP
    goto nivel3eP
    goto nivel3fP
nivel2dP:
    movlw .0
    cpfseq DECEP
    goto nivel3gP
    goto nivel3hP
nivel3eP:
    movlw .0
    cpfseq UNIP
    goto naranjaP
    goto moradoP
nivel3fP:
    movlw .0
    cpfseq UNIP
    goto naranjaP
    goto plomoP
nivel3gP:
    movlw .0
    cpfseq UNIP
    goto naranjaP
    goto moradoP
nivel3hP:
    movlw .0
    cpfseq UNIP
    goto naranjaP
    goto rojoP
;---Acciones finales---------;
verdeP:
    incf UNIP,f
    incf UNIP,f
    retfie
celesteP:
    movlw .0
    movwf UNIP
    incf DECEP,f
    retfie
amarilloP:
    movlw .0
    movwf UNIP
    movlw .0
    movwf DECEP
    incf CENTP,f
    retfie
naranjaP:
    decf UNIP,f
    decf UNIP,f
    retfie
moradoP:
    movlw .8
    movwf UNIP
    decf DECEP,f
    retfie
plomoP:
    movlw .8
    movwf UNIP
    movlw .9
    movwf DECEP
    decf CENTP,f
    retfie
rojoP:
    retfie
    

    
;-----Displayada y delaymon----;
displayada:
    clrf TBLPTRL
    movf UNI, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    ;-----------------;
    clrf TBLPTRL
    movf DECE, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    ;----------------;
    clrf TBLPTRL
    movf CENT, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    ;-----------------;
    return
displayadaa:
    clrf TBLPTRL
    movf UNIP, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,0
    call bucle2
    bsf LATB,0
    ;-----------------;
    clrf TBLPTRL
    movf DECEP, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,1
    call bucle2
    bsf LATB,1
    ;----------------;
    clrf TBLPTRL
    movf CENTP, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATB,2
    call bucle2
    bsf LATB,2
    ;-----------------;
    return

    
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
    movlw .1
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return
    return
    end
    