    list p=18f4550
    #include "p18f4550.inc"
    
    CONFIG FOSC = XT_XT;INTOSCIO_EC
    CONFIG PWRT = ON 
    CONFIG BOR = OFF
    CONFIG BORV = 3
    CONFIG VREGEN = OFF
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON
    ;Falta el siguiente bit de configuración en la guía
    ;CONFIG LVP = OFF
    
    org 0x0008
    goto BOTONinterrup
    
    org 0x0018
    goto TMRinterrup

    ORG 0x0000
    goto CONFIGURA
    
    ORG 0x7000
NUMEROS: da "0123456789"
    ORG 0X7020
DOS_PUNTOS: da ":"
    ORG 0X7040
MSJ_AM: da " AM@"
    ORG 0X7060
MSJ_PM: da " PM@"
    ORG 0X7080
MSJ_AMPM_VACIO: da "   @"
    ORG 0X70A0
Modo_Reloj: da "Reloj           @"
    ORG 0X70C0
Modo_Alarmon: da "Cambia la Alarma@"
    ORG 0X70E0
Modo_Cronometro: da "Cronometro      @"
 
    cblock 0x0020			;zona de declaracion de etiquetas a los registros GPR (variables)
    AUXILIOmeDESMAYO
    decHoras_12h
    uniHoras_12h
    decHoras
    uniHoras
    decMinutos
    uniMinutos
    decSegundos
    uniSegundos
    PuertoBfiltrado
    Modo
    set24to12horas
    dime_am_pm
    Alarma
    decHoras_Alarma
    uniHoras_Alarma
    decMinutos_Alarma
    uniMinutos_Alarma
    decSegundos_Alarma
    uniSegundos_Alarma
    decHoras_Crono
    uniHoras_Crono
    decMinutos_Crono
    uniMinutos_Crono
    decSegundos_Crono
    uniSegundos_Crono
    enable_Crono
    cta_a
    cta_b
    cta_c
    endc
	
    ORG 0x0020
CONFIGURA:
    ;Momentaneo (condensadores)
    ;movlw 0x60
    ;movwf OSCCON
    ;--------------------
    ;Configuracion de interrupciones:
    bsf RCON, IPEN	    ;habilita interrupciones altas y bajas
    
    movlw b'11001000'
    movwf INTCON
    bsf INTCON, INT0IE	    ;HABILITA INT0
    bsf INTCON2, INTEDG0
    
    bsf INTCON3, INT1IE	    ;HABILITA INT1
    bsf INTCON2, INTEDG1
    bsf INTCON3, INT1IP
    
    
    bsf INTCON3, INT2IE	    ;HABILITA INT1
    bsf INTCON2, INTEDG2
    bsf INTCON3, INT2IP
    
    ;bcf INTCON3, INT1IF
    ;bcf INTCON3, INT2IF
    
    bsf INTCON2, RBIP	    ;RB alta prioridad
    bcf IPR1, CCP1IP	    ;CCP baja prioridad
    
    movlw 0x8B
    movwf T1CON		    ;Habilitamos el Timer1
    
    movlw 0x80
    movwf CCPR1H
    movlw 0x00
    movwf CCPR1L	    ;Cargamos el valor de referencia del comparador (1000)
    movlw 0x0B
    movwf CCP1CON	    ;Arrancamos el CCP en comparador evento especial de disparo
    movlw 0x04
    movwf PIE1		    ;Habilitamos interrupción del CCP1
    
    ;--------------------
    ;Configuracion del display:
    
    clrf TRISD
    call DELAY100uS
    call LCD_CONFIG 
    call CURSOR_OFF
    
    ;--------------------
    ;Valores iniciales necesarios
    
    setf TRISB
    
    clrf AUXILIOmeDESMAYO
    
    clrf Modo
    clrf Alarma
    clrf set24to12horas
    clrf dime_am_pm
    
    movlw .1
    movwf decHoras_12h
    movlw .2
    movwf uniHoras_12h
    
    clrf decHoras
    clrf uniHoras
    clrf decMinutos
    clrf uniMinutos
    clrf decSegundos
    clrf uniSegundos
    
    clrf decHoras_Alarma	;alarma predeterminada: 07:00:00
    movlw .7
    movwf uniHoras_Alarma
    clrf decMinutos_Alarma
    clrf uniMinutos_Alarma
    clrf decSegundos_Alarma
    clrf uniSegundos_Alarma
    
    call predet_cronometro
    
    goto INICIO
    
predet_cronometro:
    clrf enable_Crono
    
    clrf decHoras_Crono
    clrf uniHoras_Crono
    clrf decMinutos_Crono
    clrf uniMinutos_Crono
    clrf decSegundos_Crono
    clrf uniSegundos_Crono
    return