    list p=18f4550
    #include <p18f4550.inc>
    
    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    org 0x0200
tabla7s db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67,0x79,0x79,0x79,0x79,0x79
    
    org 0x0000			;Vector de reset
    goto configura
    org 0x0020	
    
configura:
    clrf TRISD
    movlw UPPER tabla7s
    movwf TBLPTRU
    movlw HIGH tabla7s
    movwf TBLPTRH
    movlw LOW tabla7s
    movwf TBLPTRL
inicio:
    clrf TBLPTRL
    movf PORTB,W
    andlw 0x0F
    addwf TBLPTRL
    TBLRD*
    movff TABLAT,LATD
    goto inicio
    
    end
    
    
    
    
    
    
    
    
    
    
    
    
    