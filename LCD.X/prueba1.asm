    #include "p18F4550.inc"
    CONFIG FOSC = INTOSCIO_EC ;XT_XT
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG BORV = 3
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON
    CONFIG LVP = OFF
 
    org 0x0000
    goto MAIN	
    org 0x0020
MAIN:
    clrf TRISD	    ;Puertos como salida (conexión hacia el LCD
    call DELAY15MSEG	;Para inicializar el LCD para que arranque y funcione con interface de 4 bits
    call LCD_CONFIG
    CALL CURSOR_OFF

INICIO:
    CALL BORRAR_LCD
    movlw "H"	    ;Caracter H se almacena en W (valor HEX de su ASCII)
    call ENVIA_CHAR
    movlw "e"	    ;Caracter e se almacena en W (valor HEX de su ASCII)
    call ENVIA_CHAR
    movlw "l"	    ;Caracter l se almacena en W (valor HEX de su ASCII)
    call ENVIA_CHAR
    movlw "l"	    ;Caracter l se almacena en W (valor HEX de su ASCII)
    call ENVIA_CHAR
    movlw "o"	    ;Caracter o se almacena en W (valor HEX de su ASCII)
    call ENVIA_CHAR
FIN:
    NOP 
    GOTO FIN
    #include "LCD_LIB.asm"
    end
    