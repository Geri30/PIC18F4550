    list p=18f4550		;Modelo del microcontrolador
    #include <p18f4550.inc>	;libreria de nombres
    
;zona de configuracion de los bits de configuracion del microcontrolador
   
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
   
    org 0x0000			;Vector de reset
    goto configura
    
    org 0x0020			;zona de programa de usuario
configura:
    bsf TRISB, 0
    bsf TRISB, 1
    bsf TRISB, 2
    
    bcf TRISD, 0
    bcf TRISD, 1
inicio:
    btfss PORTB, 0
    goto falsoA
    goto verdadA
verdadA:
    btfss PORTB, 1
    goto verdadAfalsoB
    goto verdadAverdadB
falsoA:
    btfss PORTB, 1
    goto falsoAfalsoB
    goto falsoAverdadB
falsoAfalsoB:
    bcf LATD, 0
    bcf LATD, 1
    goto inicio
verdadAverdadB:
    bcf LATD, 0
    bcf LATD, 1
    goto inicio
falsoAverdadB:
    bsf LATD, 0
    btfss PORTB, 2
    goto enero
    goto febrero
verdadAfalsoB:
    bsf LATD, 0
    btfss PORTB, 2
    goto marzo
    goto abril
enero:
    bcf LATD, 1
    goto inicio
febrero:
    bsf LATD, 1
    goto inicio
marzo:
    bcf LATD, 1
    goto inicio
abril:
    bsf LATD, 1
    goto inicio
    end