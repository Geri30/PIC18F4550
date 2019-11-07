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
    
    vel
    flecha
    
    indicaconfig
    pase
    endc
    
    org 0x1000
mensaje1   db 0x00,0x00,0x00,0x00,0x37,0x06,0x39,0x50,0x5C,0x039,0x5C,0x54,0x78,0x50,0x5C,0x38,0x77,0x5E,0x5C,0x50,0x79,0x6D,0x00,0x3E,0x73,0x39,0x00,0x09,0x0F,0x00,0x00,0x00,0x00
	      ;   ;    ;    ;    ;M   ;i   ;c   ;r   ;o   ;c    ;o   ;n   ;t   ;r   ;o   ;l   ;a   ;d   ;o   ;r   ;e   ;s   ;    ;U   ;P   ;C   ;    ;:   ;)                   
    org 0x1100
mensaje2   db 0x00,0x00,0x00,0x00,0x39,0x06,0x39,0x38,0x5C,0x00,0x5B,0x3F,0x06,0x67,0x40,0x06,0x00,0x00,0x00,0x00
	      ;   ;    ;    ;    ;C   ;i   ;c   ;l   ;o   ;    ;2   ;0   ;1   ;9   ;-   ;1      
    org 0x1200
mensaje3  db 0x00,0x00,0x00,0x00,0x38,0x77,0x00,0x1C,0x06,0x5E,0x77,0x00,0x79,0x6D,0x00,0x3E,0x54,0x77,0x00,0x79,0x6D,0x73,0x79,0x39,0x06,0x79,0x00,0x5E,0x79,0x00 
	      ;   ;    ;    ;    ;l   ;a   ;    ;v   ;i   ;d   ;a   ;    ;e   ;s   ;    ;u   ;n   ;a   ;    ;e   ;s   ;p   ;e   ;c   ;i   ;e   ;    ;d   ;e   ;    ;b   ;i   ;c             
	  db 0x7C,0x06,0x39,0x06,0x39,0x38,0x79,0x78,0x77,0x09,0x00,0x6D,0x06,0x00,0x67,0x3E,0x06,0x79,0x50,0x79,0x6D,0x00,0x37,0x77,0x54,0x78,0x79,0x54,0x79,0x50   
	      ;b   ;i   ;c  ;i   ;c   ;l   ;e   ;t   ;a   ;:   ;    ;s   ;i   ;    ;q   ;u   ;i   ;e   ;r   ;e   ;s   ;    ;m   ;a   ;n   ;t   ;e   ;n   ;e   ;r   ;t   ;e   ;                
	  db 0x78,0x79,0x00,0x79,0x54,0x00,0x79,0x67,0x3E,0x06,0x38,0x06,0x7C,0x50,0x06,0x5C,0x00,0x5E,0x79,0x7C,0x79,0x6D,0x00,0x73,0x79,0x5E,0x77,0x38,0x79,0x77
	      ;t  ;e   ;    ;e   ;n   ;    ;e   ;q   ;u   ;i   ;l   ;i   ;b   ;r   ;i   ;o   ;    ;d   ;e   ;b   ;e   ;s   ;    ;p   ;e   ;d   ;a   ;l   ;e   ;a   ;r   ;    ;h              
	  db 0x50,0x00,0x74,0x77,0x39,0x06,0x77,0x00,0x77,0x5E,0x79,0x38,0x77,0x54,0x78,0x79,0x00,0x00,0x00,0x00
              ;r   ;   ;h   ;a   ;c   ;i   ;a   ;    ;a   ;d   ;e   ;l   ;a   ;n   ;t   ;e   ;    ;    ;    ;
    org 0x1600
mensaje4   db 0x00,0x00,0x00,0x00,0x38,0x5C,0x00,0x67,0x3E,0x79,0x00,0x54,0x5C,0x00,0x37,0x79,0x00,0x37,0x77,0x78,0x77,0x04,0x00,0x37,0x79,0x00,0x77,0x38,0x06,0x37                
	       ;   ;    ;    ;    ;L   ;o   ;    ;q   ;u   ;e   ;    ;n   ;o   ;    ;m   ;e   ;    ;m   ;a   ;t   ;a   ;,   ;    ;m   ;e   ;    ;a   ;l   ;i   ;m   ;e   ;n   ;t   
	   db 0x79,0x54,0x78,0x77,0x00,0x00,0x00,0x00
	       ;e  ;n   ;t   ;a   ;    ;    ;    ;  
    org 0x1800
mensaje5   db  0x00,0x10,0x30,0x21,0x03,0x42,0x50,0x18,0x08
	      ;0  ;1   ;2   ;3   ;4   ;5   ;6   ;7   ;8
    org 0x1900
mensaje6   db  0x21,0x03,0x42,0x50,0x18,0x0C,0x44,0x60
	      ;0  ;1   ;2   ;3   ;4   ;5   ;6   ;7   
    org 0x2000
mensaje7   db  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x73,0x50,0x5C,0x71,0x79,0x00,0x39,0x74,0x1C,0x73,0x79,0x37,0x79,0x00,0x38,0x77,0x00,0x73,0x06,0x54,0x6F,0x77,0x00,0x00,0x00,0x00
   
    org 0x0000
    goto configura
    
    org 0x0008
    goto memachucaron
    
    org 0x0020
configura:
    clrf TRISD		;puerto D como salida
    
    ;puertos de seleccion
    bcf TRISA,0		
    bcf TRISE,0
    bcf TRISE,1
    bcf TRISE,2
    ; setear a 1
    bsf LATA,0
    bsf LATE,0
    bsf LATE,1
    bsf LATE,2
    ; valores iniciales
    movlw .0
    movwf flecha
    movlw .10
    movwf vel
    movlw .1
    movwf pase
    
    movlw HIGH mensaje1
    movwf TBLPTRH
    movlw LOW mensaje1
    movwf TBLPTRL
    movlw .0
    movwf dig1
    movlw .0 
    movwf dig2
    movlw .0
    movwf dig3
    movlw .0
    movwf dig4
    
    ;----vaina para el teclad matricial----;
    clrf LATB		
    movlw 0xF0		;B del  7 al 4 (columnas) son entrada 
    movwf TRISB		;B del  3 al 0 (filas) son salida
    bcf INTCON2,RBPU 
    bsf INTCON,RBIE 
    bsf INTCON,GIE
    
apreguntar:
    movlw .1
    cpfseq indicaconfig
    goto sa
    goto configura1
sa:
    movlw .2
    cpfseq indicaconfig
    goto saa
    goto configura2
saa:
    movlw .3
    cpfseq indicaconfig
    goto saaa
    goto configura3
saaa:
    movlw .4
    cpfseq indicaconfig
    goto saaaa
    goto configura4
saaaa:
    movlw .5
    cpfseq indicaconfig
    goto saaaaa
    goto configura5
saaaaa:
    movlw .6
    cpfseq indicaconfig
    goto saaaaaa
    goto configura6
saaaaaa:
    movlw .7
    cpfseq indicaconfig
    goto apreguntar
    goto configura7
    
;-----configuracion de mensaje 1----;    
configura1:
    movlw .1
    cpfseq pase
    goto salta1
    goto entra1
entra1:
    movlw .0
    movwf pase
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
salta1:
    ; aplicar la tabla
    movlw HIGH mensaje1
    movwf TBLPTRH
    movlw LOW mensaje1
    movwf TBLPTRL
inicio1:
    call delaymon
    movlw .0
    cpfseq flecha
    goto dere1
    goto izqui1
dere1:
    movlw .0
    cpfseq dig1
    goto falso1
    goto verdad1
falso1:
    decf dig1,f
    decf dig2,f
    decf dig3,f
    decf dig4,f
    goto inicio1
verdad1:    
    clrf TBLPTRL
    movlw .29
    movwf dig1
    movlw .30
    movwf dig2
    movlw .31
    movwf dig3
    movlw .32 
    movwf dig4
    goto apreguntar
izqui1:
    movlw .32
    cpfseq dig4
    goto falso2
    goto verdad2
falso2:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto inicio1
verdad2:    
    clrf TBLPTRL
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
    goto apreguntar
    
;-----configuracion de mensaje 2----;    
configura2:
    movlw .1
    cpfseq pase
    goto salta2
    goto entra2
entra2:    
    movlw .0
    movwf pase
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
salta2:
    ; aplicar la tabla
    movlw HIGH mensaje2
    movwf TBLPTRH
    movlw LOW mensaje2
    movwf TBLPTRL
inicio2:
    call delaymon
    movlw .0
    cpfseq flecha
    goto dere2
    goto izqui2
dere2:
    movlw .0
    cpfseq dig1
    goto falso3
    goto verdad3
falso3:
    decf dig1,f
    decf dig2,f
    decf dig3,f
    decf dig4,f
    goto inicio2
verdad3:    
    clrf TBLPTRL
    movlw .16
    movwf dig1
    movlw .17 
    movwf dig2
    movlw .18
    movwf dig3
    movlw .19 
    movwf dig4
    goto apreguntar
izqui2:
    movlw .19
    cpfseq dig4
    goto falso4
    goto verdad4
falso4:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto inicio2
verdad4:    
    clrf TBLPTRL
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
    goto apreguntar

;-----configuracion de mensaje 3----;    
configura3:
    movlw .1
    cpfseq pase
    goto salta29
    goto entra29
entra29:    
    movlw .0
    movwf pase
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
salta29:
    ; aplicar la tabla
    movlw HIGH mensaje3
    movwf TBLPTRH
    movlw LOW mensaje3
    movwf TBLPTRL
inicio29:
    call delaymon
    movlw .0
    cpfseq flecha
    goto dere29
    goto izqui29
dere29:
    movlw .0
    cpfseq dig1
    goto falso39
    goto verdad39
falso39:
    decf dig1,f
    decf dig2,f
    decf dig3,f
    decf dig4,f
    goto inicio29
verdad39:    
    clrf TBLPTRL
    movlw .106
    movwf dig1
    movlw .107 
    movwf dig2
    movlw .108
    movwf dig3
    movlw .109 
    movwf dig4
    goto apreguntar
izqui29:
    movlw .109
    cpfseq dig4
    goto falso49
    goto verdad49
falso49:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto inicio29
verdad49:    
    clrf TBLPTRL
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
    goto apreguntar
    
;-----configuracion de mensaje 4----;
configura4:
    movlw .1
    cpfseq pase
    goto salta294
    goto entra294
entra294:    
    movlw .0
    movwf pase
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
salta294:
    ; aplicar la tabla
    movlw HIGH mensaje4
    movwf TBLPTRH
    movlw LOW mensaje4
    movwf TBLPTRL
inicio294:
    call delaymon
    movlw .0
    cpfseq flecha
    goto dere294
    goto izqui294
dere294:
    movlw .0
    cpfseq dig1
    goto falso394
    goto verdad394
falso394:
    decf dig1,f
    decf dig2,f
    decf dig3,f
    decf dig4,f
    goto inicio29
verdad394:    
    clrf TBLPTRL
    movlw .38
    movwf dig1
    movlw .39 
    movwf dig2
    movlw .40
    movwf dig3
    movlw .41
    movwf dig4
    goto apreguntar
izqui294:
    movlw .41
    cpfseq dig4
    goto falso494
    goto verdad494
falso494:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto inicio294
verdad494:    
    clrf TBLPTRL
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
    goto apreguntar
    
;-----mensaje 5--;
configura5:
    clrf TBLPTRL
    movlw HIGH mensaje5
    movwf TBLPTRH
    movlw LOW mensaje5
    movwf TBLPTRL
    movlw .1
    movwf dig1
    movlw .0 
    movwf dig2
    movlw .0
    movwf dig3
    movlw .0
    movwf dig4
tope1:
    call delaymon
    movlw .7
    cpfseq dig1
    goto unafalsa
    goto unaverdad
unafalsa:
    incf dig1,f
    goto tope1
unaverdad:
    movlw .8
    movwf dig1
    incf dig2,f
    call delaymon
    movlw .0
    movwf dig1
    movlw .2
    movwf dig2
    movlw .0
    movwf dig3
    movlw .0
    movwf dig4
tope2:
    call delaymon
    movlw .7
    cpfseq dig2
    goto unafalsa1
    goto unaverdad1
unafalsa1:
    incf dig2,f
    goto tope2
unaverdad1:
    movlw .8
    movwf dig2
    incf dig3
    call delaymon
    movlw .0
    movwf dig1
    movlw .0
    movwf dig2
    movlw .2
    movwf dig3
    movlw .0
    movwf dig4
tope3:
    call delaymon
    movlw .7
    cpfseq dig3
    goto unafalsa2
    goto unaverdad2
unafalsa2:
    incf dig3,f
    goto tope3
unaverdad2:
    movlw .8
    movwf dig3
    incf dig4
    call delaymon
    movlw .0
    movwf dig1
    movlw .0
    movwf dig2
    movlw .0
    movwf dig3
    movlw .2
    movwf dig4 
tope4:
    call delaymon
    movlw .8
    cpfseq dig4
    goto unafalsa3
    goto unaverdad3
unafalsa3:
    incf dig4,f
    goto tope4
unaverdad3:
    movlw .0
    movwf dig4
    call delaymon
    goto apreguntar
;-----------mensaje6-----------;
configura6:
    clrf TBLPTRL
    movlw HIGH mensaje6
    movwf TBLPTRH
    movlw LOW mensaje6
    movwf TBLPTRL
corto:
    movlw .0
    movwf dig1
    movlw .0
    movwf dig2
    movlw .0
    movwf dig3
    movlw .0
    movwf dig4
    goto inicio6
inicio6:
    call delaymon
    movlw .7
    cpfseq dig1
    goto aunno
    goto yatta
aunno:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto inicio6
yatta:
    goto apreguntar
;-----mensaje 7-------------;
configura7:
    movlw .1
    cpfseq pase
    goto salta17
    goto entra17
entra17:
    movlw .0
    movwf pase
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
salta17:
    ; aplicar la tabla
    movlw HIGH mensaje7
    movwf TBLPTRH
    movlw LOW mensaje7
    movwf TBLPTRL
inicio17:
    call delaymon
    movlw .0
    cpfseq flecha
    goto dere17
    goto izqui17
dere17:
    movlw .0
    cpfseq dig1
    goto falso17
    goto verdad17
falso17:
    decf dig1,f
    decf dig2,f
    decf dig3,f
    decf dig4,f
    goto inicio17
verdad17:    
    clrf TBLPTRL
    movlw .15
    movwf dig1
    movlw .16
    movwf dig2
    movlw .17
    movwf dig3
    movlw .18 
    movwf dig4
    goto apreguntar
izqui17:
    movlw .18
    cpfseq dig4
    goto falso2
    goto verdad2
falso27:
    incf dig1,f
    incf dig2,f
    incf dig3,f
    incf dig4,f
    goto inicio1
verdad27:    
    clrf TBLPTRL
    movlw .0
    movwf dig1
    movlw .1 
    movwf dig2
    movlw .2 
    movwf dig3
    movlw .3 
    movwf dig4
    goto apreguntar
    
;-------secuencia para mostrar el display por un tiempo-----------;
delaymon:
    movff vel,cta_a
otro1:
    call bucle2
    decfsz cta_a, f
    goto otro1
    return
bucle2:
    movlw .5
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
;------rafaga de muestra------;
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
;------rutina de interrupcion------;
    org 0x3000
memachucaron:
    call displayada
    bcf INTCON,RBIF	;bajar bandera
    btfss PORTB,4 
    goto COL1 
    btfss PORTB,5 
    goto COL2 
    btfss PORTB,6 
    goto COL3 
    btfss PORTB,7 
    goto COL4 
    retfie
COL1:
    movlw 0x0F		;0F = 00001111
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto tablear1
    btfss PORTB,1 
    goto tablear4
    btfss PORTB,2 
    goto tablear7
    btfss PORTB,3 
    goto izqui
    goto SALIR
COL2:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto tablear2
    btfss PORTB,1 
    goto tablear5
    btfss PORTB,2 
    goto SALIR
    btfss PORTB,3 
    goto SALIR
    goto SALIR
COL3:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto tablear3
    btfss PORTB,1 
    goto tablear6
    btfss PORTB,2 
    goto SALIR
    btfss PORTB,3 
    goto dere
    goto SALIR
COL4:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto velo1
    btfss PORTB,1 
    goto velo2
    btfss PORTB,2 
    goto velo3
    btfss PORTB,3 
    goto velo4
    goto SALIR
    ;-----cajas de seleccion----;
tablear1:
    movlw .1
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
tablear2:
    movlw .2
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
tablear3:
    movlw .3
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
tablear4:
    movlw .4
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
tablear5:
    movlw .5
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
tablear6:
    movlw .6
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
tablear7:
    movlw .7
    movwf indicaconfig
    movlw .1
    movwf pase
    goto SALIR
velo1:
    movlw .5
    movwf vel
    goto SALIR
velo2:
    movlw .7
    movwf vel
    goto SALIR
velo3:
    movlw .10
    movwf vel
    goto SALIR
velo4:
    movlw .20
    movwf vel
    goto SALIR
izqui:
    movlw .0
    movwf flecha
    goto SALIR
dere:
    movlw .1
    movwf flecha
    goto SALIR
SALIR:
    movlw 0xF0
    movwf TRISB
    retfie
        
    end