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
    
    dig1
    dig2
    dig3
    dig4
    endc
    
    org 0x0200
mensaje1 db 0x00,0x00,0x00,0x37,0x06,0x39,0x50,0x5C,0x039,0x5C,0x54,0x78,0x50,0x5C,0x38,0x77,0x5E,0x5C,0x50,0x79,0x6D,0x00,0x3E,0x73,0x39,0x00,0x09,0x0F,0x00,0x00,0x00
	    ;   ;    ;    ;M  ;i   ;c   ;r   ;o   ;c    ;o   ;n   ;t   ;r   ;o   ;l   ;a   ;d   ;o   ;r   ;e   ;s   ;    ;U   ;P   ;C   ;    ;:    ;)   ;    ;    ;                 
    org 0x0300
mensaje2 db 0x39,0x06,0x39,0x38,0x5C,0x00,0x5B,0x3F,0x06,0x67,0x40,0x06
	    ;C  ;i   ;c   ;l   ;o   ;    ;2   ;0   ;1   ;9   ;-   ;1   
    org 0x0400
mensaje3a db 0x00,0x00,0x00,0x38,0x77,0x00,0x1C,0x06,0x5E,0x77,0x00,0x79,0x6D,0x00,0x3E,0x54,0x77,0x00,0x79,0x6D,0x73,0x79,0x39,0x06,0x79,0x00,0x5E,0x79,0x00,0x7C,0x06,0x39,0x06    
	    ;   ;    ;    ;l   ;a   ;    ;v   ;i   ;d   ;a   ;    ;e   ;s   ;    ;u   ;n   ;a   ;    ;e   ;s   ;p   ;e   ;c   ;i   ;e   ;    ;d   ;e   ;    ;b   ;i   ;c   ;i          
    org 0x0500
mensaje3b  db 0x39,0x38,0x79,0x78,0x77,0x09,0x00,0x6D,0x06,0x00,0x67,0x3E,0x06,0x79,0x50,0x79,0x6D,0x00,0x37,0x77,0x54,0x78,0x79,0x54,0x79,0x50,0x78,0x79,0x00,0x79,0x54,0x00,0x79      
	    ;c  ;l   ;e   ;t   ;a   ;:   ;    ;s   ;i   ;    ;q   ;u   ;i   ;e   ;r   ;e   ;s   ;    ;m   ;a   ;n   ;t   ;e   ;n   ;e   ;r   ;t   ;e   ;    ;e   ;n   ;    ;e         
    org 0x0600
mensaje3c  db 0x67,0x3E,0x06,0x38,0x06,0x7C,0x50,0x06,0x5C,0x00,0x5E,0x79,0x7C,0x79,0x6D,0x00,0x73,0x79,0x5E,0x77,0x38,0x79,0x77,0x50,0x00,0x74,0x77,0x39,0x06,0x77,0x00,0x77,0x5E 
	    ;q  ;u   ;i   ;l   ;i   ;b   ;r   ;i   ;o   ;    ;d   ;e   ;b   ;e   ;s   ;    ;p   ;e   ;d   ;a   ;l   ;e   ;a   ;r   ;    ;h   ;a   ;c   ;i   ;a   ;    ;a   ;d     
    org 0x0700
mensaje3d   db 0x79,0x38,0x77,0x54,0x78,0x79,0x00,0x00,0x00
            ;e   ;l   ;a   ;n   ;t   ;e  ;    ;    ;
    org 0x0800
mensaje4 db 0x38,0x5C,0x00,0x67,0x3E,0x79,0x00,0x54,0x5C,0x00,0x37,0x79,0x00,0x37,0x77,0x78,0x77,0x04,0x00,0x37,0x79,0x00,0x77,0x38,0x06,0x37,0x79,0x54,0x78,0x77                    
	    ;L  ;o   ;    ;q   ;u   ;e   ;    ;n   ;o   ;    ;m   ;e   ;    ;m   ;a   ;t   ;a   ;,   ;    ;m   ;e   ;    ;a   ;l   ,i   ,m   ,e   ,n   ,t   ,a                         
    
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    clrf TRISD		;puerto D como salida
    
    ;puertos de seleccion
    bcf TRISA,0		
    bcf TRISE,0
    bcf TRISE,1
    bcf TRISE,2
    
    bsf LATA,0
    bsf LATE,0
    bsf LATE,1
    bsf LATE,2
    
    movlw HIGH mensaje1
    movwf TBLPTRH
    movlw LOW mensaje1
    movwf TBLPTRL
    
inicio:    
    movlw .0
    movwf dig1
    
    movlw .1 
    movwf dig2
    
    movlw .2 
    movwf dig3
    
    movlw .3 
    movwf dig4
    
    
    
repetir:
    call delaymon
    movlw .30
    cpfseq dig4
    goto falso
    goto verdad
falso:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto repetir
verdad:    
    clrf TBLPTRL
    goto inicio
	
    

    
;--------------------------------------;
delaymon:
    movlw .10
    movwf cta_a
otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return

bucle2:
    movlw .20
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
    call displayada
    decfsz cta_c, f
    goto otro3
    return
    
;--------------------------------------;
displayada:
    ;-- digito1 --;
    
    clrf TBLPTRL
    movf dig1, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATA,0
    nop
    bsf LATA,0
    ;-- digito2 --;
    clrf TBLPTRL
    movf dig2, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATE,0
    nop
    bsf LATE,0
    ;-- digito3 --;
    clrf TBLPTRL
    movf dig3, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATE,1
    nop
    bsf LATE,1
    ;-- digito4 --;
    clrf TBLPTRL
    movf dig4, W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT, LATD
    bcf LATE,2
    nop
    bsf LATE,2
    
    
    
    return
    

    
    end