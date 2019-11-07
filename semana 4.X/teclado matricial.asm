    ;CODIGO DE MATRIZ
    list p=18f4550
    #include "p18f4550.inc"


    CONFIG  FOSC = XT_XT          ; Oscillator Selection bits (XT oscillator (XT))
    CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
    CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
    CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
    CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

    var1 EQU 0x20
    var2 EQU 0x21
 
    org 0x700
TABLA db 0xBF, 0x86, 0xDB, 0xCF, 0xE6, 0xED, 0xFC, 0x87, 0xFF, 0xE7, 0x77, 0x7C, 0xB9, 0x5E, 0x1B, 0x49
        ; 0     1     2     3     4     5     6     7      8    9      A    B     C      D    #     *
    
    org 0x0000
    goto MAIN
    
    org 0x0008
    goto RUT_ALTAP
  
    org 0x0020
  
MAIN:
    movlw HIGH TABLA 
    movwf TBLPTRH 
    clrf LATD
    movlw 0x80 ;
    movwf TRISD ;Hace salida el RD 0 al 6
    clrf LATB ;Apaga el display
    movlw 0xF0  ;B del  7 al 4 (columnas) son entrada 
    movwf TRISB  ;B del  3 al 0 (filas) son salida
    bcf INTCON2,RBPU 
    bsf INTCON,RBIE 
    bsf INTCON,GIE
    
INICIO:
    goto INICIO
    
RUT_ALTAP: 
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
    movlw 0x0F ;0F = 11110000
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    movlw .1 
    btfss PORTB,1 
    movlw .4 
    btfss PORTB,2 
    movlw .7 
    btfss PORTB,3 
    movlw .14 
    goto SALIR
COL2:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    movlw .2 
    btfss PORTB,1 
    movlw .5 
    btfss PORTB,2 
    movlw .8 
    btfss PORTB,3 
    movlw .0 
    goto SALIR
COL3:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    movlw .3 
    btfss PORTB,1 
    movlw .6 
    btfss PORTB,2 
    movlw .9 
    btfss PORTB,3 
    movlw .15 
    goto SALIR
COL4:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    movlw .10 
    btfss PORTB,1 
    movlw .11
    btfss PORTB,2 
    movlw .12 
    btfss PORTB,3 
    movlw .13 
    goto SALIR
    
SALIR:
    movwf TBLPTRL 
    TBLRD*
    movff TABLAT,LATD 
    movlw 0xF0
    movwf TRISB
    call RETARDO
    bcf INTCON,RBIF 
    retfie
    
RETARDO: 
    movlw .100 
    movwf var1
    
RET1:
    movlw .200 
    movwf var2
    
RET2:
    decfsz var2,f 
    goto RET2 
    decfsz var1,f 
    goto RET1 
    return
    end