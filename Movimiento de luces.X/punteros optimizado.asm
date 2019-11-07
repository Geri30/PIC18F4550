    list p=18f4550
    #include <p18f4550.inc>

    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
    
    cblock 0x0020
    cta_a
    cta_b
    cta_c    
    endc
    
    org 0x0200
tablaton db 0x00,0x00,0x00,0x38,0x77,0x00,0x1C,0x06,0x5E,0x77,0x00,0x79,0x6D,0x00,0x3E,0x54,0x77,0x00,0x79,0x6D,0x73,0x79,0x39,0x06,0x79,0x00,0x5E,0x79,0x00,0x7C,0x06,0x39,0x06    
	    ;   ;    ;    ;l   ;a   ;    ;v   ;i   ;d   ;a   ;    ;e   ;s   ;    ;u   ;n   ;a   ;    ;e   ;s   ;p   ;e   ;c   ;i   ;e   ;    ;d   ;e   ;    ;b   ;i   ;c   ;i          
    org 0x0300
segunda  db 0x39,0x38,0x79,0x78,0x77,0x09,0x00,0x6D,0x06,0x00,0x67,0x3E,0x06,0x79,0x50,0x79,0x6D,0x00,0x37,0x77,0x54,0x78,0x79,0x54,0x79,0x50,0x78,0x79,0x00,0x79,0x54,0x00,0x79      
	    ;c  ;l   ;e   ;t   ;a   ;:   ;    ;s   ;i   ;    ;q   ;u   ;i   ;e   ;r   ;e   ;s   ;    ;m   ;a   ;n   ;t   ;e   ;n   ;e   ;r   ;t   ;e   ;    ;e   ;n   ;    ;e         
    org 0x0400
tercera  db 0x67,0x3E,0x06,0x38,0x06,0x7C,0x50,0x06,0x5C,0x00,0x5E,0x79,0x7C,0x79,0x6D,0x00,0x73,0x79,0x5E,0x77,0x38,0x79,0x77,0x50,0x00,0x74,0x77,0x39,0x06,0x77,0x00,0x77,0x5E 
	    ;q  ;u   ;i   ;l   ;i   ;b   ;r   ;i   ;o   ;    ;d   ;e   ;b   ;e   ;s   ;    ;p   ;e   ;d   ;a   ;l   ;e   ;a   ;r   ;    ;h   ;a   ;c   ;i   ;a   ;    ;a   ;d     
    org 0x0500
cuarta   db 0x79,0x38,0x77,0x54,0x78,0x79,0x00,0x00,0x00
            ;e   ;l   ;a   ;n   ;t   ;e  ;    ;    ;
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    clrf TRISD
    movlw HIGH tablaton
    movwf TBLPTRH
    movlw LOW tablaton
    movwf TBLPTRL
    
inicio:
    
    TBLRD*+
    movff TABLAT,LATD
    call delaymon
    movlw .32
    cpfsgt TBLPTRL
    goto inicio
    clrf TBLPTRL
parte2:
    movlw HIGH segunda
    movwf TBLPTRH
    movlw LOW segunda
    movwf TBLPTRL
    clrf TBLPTRL
secuencia2:
    TBLRD*+
    movff TABLAT,LATD
    call delaymon
    movlw .32
    cpfsgt TBLPTRL
    goto secuencia2
    clrf TBLPTRL
parte3:
    movlw HIGH tercera
    movwf TBLPTRH
    movlw LOW tercera
    movwf TBLPTRL
    clrf TBLPTRL
secuencia3:
    TBLRD*+
    movff TABLAT,LATD
    call delaymon
    movlw .32
    cpfsgt TBLPTRL
    goto secuencia3
    clrf TBLPTRL
parte4:
    movlw HIGH cuarta
    movwf TBLPTRH
    movlw LOW cuarta
    movwf TBLPTRL
    clrf TBLPTRL
secuencia4:
    TBLRD*+
    movff TABLAT,LATD
    call delaymon
    movlw .8
    cpfsgt TBLPTRL
    goto secuencia4
    clrf TBLPTRL
    goto configura
	
    
    
    
delaymon:
    movlw .5
    movwf cta_a
otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return

bucle2:
    movlw .40
    movwf cta_b
otro2:
    call bucle3
    decfsz cta_b, f
    goto otro2
    return

bucle3:
    movlw .150
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return
    
    end