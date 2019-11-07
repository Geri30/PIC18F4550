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
    cuentasa
    endc
    
    org 0x0200
    digito1 db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67
    ;digito2 db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67,0x79,0x79,0x79,0x79,0x79
    
    
    org 0x0000			  ;Vector de reset
    goto configura
    org 0x0020	
    
configura:
    clrf TRISD
    movlw UPPER digito1
    movwf TBLPTRU
    movlw HIGH digito1
    movwf TBLPTRH
    movlw LOW digito1
    movwf TBLPTRL
    clrf cuentasa

inicio:
    call displayada
    incf cuentasa,f
    call delaymon
    movlw .10
    cpfseq cuentasa
    goto inicio
    clrf cuentasa
    goto inicio
    
displayada:
    clrf TBLPTRL
    movf cuentasa,W
    addwf TBLPTRL
    TBLRD*
    movff TABLAT,LATD
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
    movlw .100
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
    
    
    
    
