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
teibol1 db 0x81,0x42,0x24,0x18,0x24,0x42
    org 0x0300
;teibol2 db 0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0xC0,0xA0,0x90,0x88,0x84,0x82,0x81,0x83,0x85,0x89,0x91,0xA1,0xC1,0xE1,0xD1,0xC9,0xC5,0xC3,0xC7,0xCB,0xD3,0xE3,0xF3,0xEB,0xE7,0xEF,0xF7,0xFF,0x00,0xAA,0x55
teibol2 db 0xAA,0x55,0xAA,0x55,0xAA,0x55,0xAA,0x55,0xAA,0x55
    
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    clrf TRISD
    
inicio:
    btfss PORTB,0
    goto falsazo
verdaderazo:
    movlw UPPER teibol1
    movwf TBLPTRU
    movlw HIGH teibol1
    movwf TBLPTRH
    movlw LOW teibol1
    movwf TBLPTRL
otrazo1:    
    TBLRD*+
    movff TABLAT,LATD
    call delaymon
    movlw .5
    cpfsgt TBLPTRL
    goto otrazo1
    clrf TBLPTRL
    goto inicio

falsazo:
    movlw UPPER teibol2
    movwf TBLPTRU
    movlw HIGH teibol2
    movwf TBLPTRH
    movlw LOW teibol2
    movwf TBLPTRL
otrazo2:    
    TBLRD*+
    movff TABLAT,LATD
    call delaymon
    movlw .10
    cpfsgt TBLPTRL
    goto otrazo2
    clrf TBLPTRL
    goto inicio
    
delaymon:
    movlw .50
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
    movlw .20
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return
    
    end