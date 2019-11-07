    #include "p18F4550.inc"
    CONFIG FOSC = XT_XT
    CONFIG PWRT = ON
    CONFIG BOR = ON
    CONFIG BORV = 3
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON
    cblock 0x10
    temp
    endc
    org 0x000
    goto MAIN
    org 0x008
    goto TOCA_CONVERTIR
    org 0x0020
MAIN:
    setf TRISA
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG

    ;Puerto Analógico
    movlw 0x0E
    movwf ADCON1 ;AN0 Analógico, VREF=5V,0V
    movlw b'00110100';Fosc/4, 16TAD Justific.Izqu
    movwf ADCON2
    movlw b'00000001';Se prende el ADC,canal 0
    movwf ADCON0
    movlw 0x31
    movwf T1CON ;Se activa el TMR1 8us conteo
    bsf PIE1,TMR1IE
    bsf INTCON,PEIE
    bsf INTCON,GIE
INICIO:
    goto INICIO
TOCA_CONVERTIR:;Timer 1 cuenta cada 8us
    bcf PIR1,TMR1IF;La interrup = T =8us*65536=
    bsf ADCON0,GO ;T=0.5 seg
ESPERA:
    btfsc ADCON0,GO
    goto ESPERA
    movf ADRESH,W
    movwf temp
    ;25°C = 250mV -> 250mV/19.5mV = 12 niveles
    ;50°C = 500mV-> 500mV/19.5mV = 25 niveles
    movlw .12
    cpfsgt temp
    goto TBAJA
    movlw .25
    cpfsgt temp
    goto TNORMAL
    CALL BORRAR_LCD
    movlw 'A'
    call ENVIA_CHAR
    movlw 'l'
    call ENVIA_CHAR
    movlw 't'
    call ENVIA_CHAR
    movlw 'o'
    call ENVIA_CHAR
    retfie
TBAJA:
    CALL BORRAR_LCD
    movlw 'B'
    call ENVIA_CHAR
    movlw 'a'
    call ENVIA_CHAR
    movlw 'j'
    call ENVIA_CHAR
    movlw 'o'
    call ENVIA_CHAR
    retfie
TNORMAL:
    CALL BORRAR_LCD
    movlw 'N'
    call ENVIA_CHAR
    movlw 'o'
    call ENVIA_CHAR
    movlw 'r'
    call ENVIA_CHAR
    movlw 'm'
    call ENVIA_CHAR
    movlw 'a'
    call ENVIA_CHAR
    movlw 'l'
    call ENVIA_CHAR
    retfie
    #include "LCD_LIB.asm"
    END