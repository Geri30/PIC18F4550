    list p=18f4550
    #include <p18f4550.inc>
    
CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
CONFIG  LVP = OFF
    
cblock 0x0020
    cta_a
    cta_b
    cta_c    
    endc
    
    org 0x0000
    goto configura
    
    org 0x0020
    
configura:
    bcf TRISD,0
    
inicio:
    bsf LATD,0
    call delaymon
    bcf LATD,0
    call delaymon
    goto inicio
    
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
    movlw .10
    movwf cta_c
otro3:
    nop
    decfsz cta_c, f
    goto otro3
    return
    
    end
    
    
    
