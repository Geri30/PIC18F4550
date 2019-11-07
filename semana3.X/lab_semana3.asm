    #include "p18f4550.inc"
    CONFIG FOSC = XT_XT
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG BORV = 3
    CONFIG VREGEN = OFF
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON

    cblock 0x10
    var1
    var2
    cont
    endc
    
    org 0x700
CLAVE: db .1,.2,.3,.4,.5
    org 0x740
TABLA: db 0x40,0x79,0x24,0x30,0x19,0x12,0x03,0x78,0x00,0x18
    org 0x00
    goto MAIN
    org 0x20
MAIN:
    setf TRISB
    setf LATD
    movlw 0x80
    movwf TRISD
    lfsr FSR0,0x100
    movlw UPPER CLAVE
    movwf TBLPTRU
    movlw HIGH CLAVE
    movwf TBLPTRH
    movlw LOW CLAVE
    movwf TBLPTRL
    bcf INTCON2,RBPU
INICIO:
    movlw 0xFF
    cpfseq PORTB
    goto SIGUE
    goto INICIO
SIGUE:
    btfss PORTB,0
    goto UNO
    btfss PORTB,1
    goto DOS
    btfss PORTB,2
    goto TRES
    btfss PORTB,3
    goto CUATRO
    btfss PORTB,4
    goto CINCO
    btfss PORTB,7
    goto VERIFICA
    goto INICIO
UNO:
    movlw 0x41
    goto SALIR
DOS:
    movlw 0x42
    goto SALIR
TRES:
    movlw 0x43
    goto SALIR
CUATRO:
    movlw 0x44
    goto SALIR
CINCO:
    movlw 0x45
    goto SALIR
SALIR:
    movwf TBLPTRL
    TBLRD*
    movff TABLAT,LATD
    movwf cont
    movlw 0x40
    subwf cont,W
    movwf INDF0
    incf FSR0L
    call RETARDO
    goto INICIO
VERIFICA:
    lfsr FSR0,0x100
    clrf cont
BUCLE:
    movff FSR0L,TBLPTRL
    TBLRD*
    movf TABLAT,W
    cpfseq INDF0
    goto SALTO
    incf cont,f
SALTO:
    incf FSR0L,f
    movlw .5
    cpfseq FSR0L
    goto BUCLE
    lfsr FSR0,0x100
    movlw .5
    cpfseq cont
    goto FALLO
    goto CORRECTO
FALLO:
    movlw b'00000100'
    movwf LATD
    call RETARDO
    goto INICIO
CORRECTO:
    movlw b'00001001'
    movwf LATD
    call RETARDO
    goto INICIO
RETARDO:
    movlw .250
    movwf var1
RET1:
    movlw .250
    movwf var2
RET2:
    decfsz var2,f
    goto RET2
    decfsz var1,f
    goto RET1
    return
    END

    