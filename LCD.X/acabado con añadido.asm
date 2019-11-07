    #include "p18F4550.inc"
    #include "LCD_LIB.asm"
    CONFIG FOSC = XT_XT
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG BORV = 3
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON
    CONFIG LVP = OFF
    cblock 0x10
    indicapantalla
    superior
    medio
    inferior
    pase
    endc
    org 0x2000
TEM:db .0,.1, .1,.2, .2,.3, .3,.4, .4,.5, .5,.6, .6,.7, .7,.8, .8,.9, .9
    db .10, .10,.11, .11,.12, .12,.13, .13,.14, .14,.15, .15,.16, .16,.17, .17,.18, .18,.19, .19
    db .20, .20,.21, .21,.22, .22,.23, .23,.24, .24,.25, .25,.26, .26,.27, .27,.28, .28,.29, .29
    db .30, .30,.31, .31,.32, .32,.33, .33,.34, .34,.35, .35,.36, .36,.37, .37,.38, .38,.39, .39
    db .40, .40,.41, .41,.42, .42,.43, .43,.44, .44,.45, .45,.46, .46,.47, .47,.48, .48,.49, .49
    db .50, .50,.51, .51,.52, .52,.53, .53,.54, .54,.55, .55,.56, .56,.57, .57,.58, .58,.59, .59
    db .60, .60,.61, .61,.62, .62,.63, .63,.64, .64,.65, .65,.66, .66,.67, .67,.68, .68,.69, .69
    db .70, .70,.71, .71,.72, .72,.73, .73,.74, .74,.75, .75,.76, .76,.77, .77,.78, .78,.79, .79
    db .80, .80,.81, .81,.82, .82,.83, .83,.84, .84,.85, .85,.86, .86,.87, .87,.88, .88,.89, .89
    db .90, .90,.91, .91,.92, .92,.93, .93,.94, .94,.95, .95,.96, .96,.97, .97,.98, .98,.99, .99
    db .100, .100,.101, .101,.102, .102,.103, .103,.104, .104,.105, .105,.106, .106,.107, .107,.108, .108,.109, .109
    db .110, .110,.111, .111,.112, .112,.113, .113,.114, .114,.115, .115,.116, .116,.117, .117,.118, .118,.119, .119
    db .120, .120,.121, .121,.122, .122,.123, .123,.124, .124,.125, .125,.126, .126,.127, .127,.128, .128

    org 0x000
    goto configura
    org 0x0008
    goto memachucaron
    org 0x0020
configura:
    ;----vaina para el LCD----;
    clrf TRISD
    call DELAY15MSEG
    call LCD_CONFIG
    movlw .1
    movwf indicapantalla
    ;----vaina para el buzzer y LED ---;
    bcf TRISC,2
    bcf LATC,2
    bcf TRISE,2
    bcf LATE,2
    ;----vaina para tabla---;
    movlw HIGH TEM
    movwf TBLPTRH
    movlw LOW TEM
    movwf TBLPTRL
    ;----vaina para el teclad matricial----;
    clrf LATB		
    movlw 0xF0		;B del  7 al 4 (columnas) son entrada 
    movwf TRISB		;B del  3 al 0 (filas) son salida
    bcf INTCON2,RBPU 
    bsf INTCON,RBIE 
    bsf INTCON,GIE
    ;----vaina para el AD----;
    movlw 0x1C ;0X0E
    movwf ADCON1
    movlw b'00110100'
    movwf ADCON2
    
inicio:
    ;-------selector de preguntar cual voy a mostrar------;
    movlw .1
    cpfseq indicapantalla
    goto sa
    goto configura1
sa:
    movlw .2
    cpfseq indicapantalla
    goto saa
    goto configura2
saa:
    movlw .3
    cpfseq indicapantalla
    goto saaa
    goto configura3
saaa:
    movlw .4
    cpfseq indicapantalla
    goto saaaa
    goto configura4
saaaa:
    movlw .5
    cpfseq indicapantalla
    goto saaaaa
    goto configura5
saaaaa:
    movlw .6
    cpfseq indicapantalla
    goto saaaaaa
    goto configura6
saaaaaa:
    movlw .7
    cpfseq indicapantalla
    goto inicio
    goto configura7
    
;-----ver temperatura----;
configura1:
    CALL BORRAR_LCD
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "T"	    
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "M"
    call ENVIA_CHAR
    movlw "P"	   
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "A"	   
    call ENVIA_CHAR
    movlw "T"	   
    call ENVIA_CHAR
    movlw "U"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "A"
    call ENVIA_CHAR
    movlw ":"	    
    call ENVIA_CHAR
convierto11:
    call ubicador
    movlw b'00000001' ; selecione canal 0 , active la conversion , empiezo 
    movwf ADCON0
    movlw .1
    cpfseq indicapantalla
    goto inicio
    bsf ADCON0,GO
espera11:
    btfsc ADCON0,GO
    goto espera11
    movff ADRESH,medio
    movlw .0 ; POSICION DE COLUMNA QUE VOY A USAR 
    call POS_CUR_FIL2 ; DONDE VOY A PONER LA FILA 1 O 2 
    movf medio, W
    movwf TBLPTRL
    TBLRD*
    movf TABLAT,W
    ;ENVIO DATOS
    call BIN_BCD ; CONVERSION DE BIT A BINARIO Y LE SUMO PARTE POR PARTE UN ASCCI DEL CERO 
    movf BCD2,W
    addlw '0'
    call ENVIA_CHAR
    movf BCD1,W
    addlw '0'
    call ENVIA_CHAR
    movf BCD0,W
    addlw '0'
    call ENVIA_CHAR
    movlw .223
    call ENVIA_CHAR
    movlw 'C'
    call ENVIA_CHAR
    goto convierto11

;-----valor superior----;
configura2:
    CALL BORRAR_LCD
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "L"	    
    call ENVIA_CHAR
    movlw "."	    
    call ENVIA_CHAR
    movlw "S"	   
    call ENVIA_CHAR
    movlw "U"
    call ENVIA_CHAR
    movlw "P"	   
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "I"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw ":"	    
    call ENVIA_CHAR
convierto21:
    call ubicador
    movlw b'00000101' ; selecione canal 1 , active la conversion , empiezo 
    movwf ADCON0
    movlw .2
    cpfseq indicapantalla
    goto inicio
    bsf ADCON0,GO
espera21:
    btfsc ADCON0,GO
    goto espera21
    movff ADRESH,superior
    movlw .0 ; POSICION DE COLUMNA QUE VOY A USAR 
    call POS_CUR_FIL2 ; DONDE VOY A PONER LA FILA 1 O 2 
    movf superior, W
    movwf TBLPTRL
    TBLRD*
    movf TABLAT,W
    ;ENVIO DATOS
    call BIN_BCD ; CONVERSION DE BIT A BINARIO Y LE SUMO PARTE POR PARTE UN ASCCI DEL CERO 
    movf BCD2,W
    addlw '0'
    call ENVIA_CHAR
    movf BCD1,W
    addlw '0'
    call ENVIA_CHAR
    movf BCD0,W
    addlw '0'
    call ENVIA_CHAR
    goto convierto21
    
;-------valor inferior-------;
configura3:
    CALL BORRAR_LCD
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "L"	    
    call ENVIA_CHAR
    movlw "."	    
    call ENVIA_CHAR
    movlw "I"	   
    call ENVIA_CHAR
    movlw "N"
    call ENVIA_CHAR
    movlw "F"	   
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "I"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw ":"	    
    call ENVIA_CHAR
convierto31:
    call ubicador
    movlw b'00001001' ; selecione canal 2 , active la conversion , empiezo 
    movwf ADCON0
    movlw .3
    cpfseq indicapantalla
    goto inicio
    bsf ADCON0,GO
espera31:
    btfsc ADCON0,GO
    goto espera31
    movff ADRESH,inferior
    movlw .0 ; POSICION DE COLUMNA QUE VOY A USAR 
    call POS_CUR_FIL2 ; DONDE VOY A PONER LA FILA 1 O 2 
    movf inferior, W
    movwf TBLPTRL
    TBLRD*
    movf TABLAT,W
    ;ENVIO DATOS
    call BIN_BCD ; CONVERSION DE BIT A BINARIO Y LE SUMO PARTE POR PARTE UN ASCCI DEL CERO 
    movf BCD2,W
    addlw '0'
    call ENVIA_CHAR
    movf BCD1,W
    addlw '0'
    call ENVIA_CHAR
    movf BCD0,W
    addlw '0'
    call ENVIA_CHAR
    goto convierto31
    ;-----la zona oscura----;
configura4:
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "E"	    
    call ENVIA_CHAR
    movlw "S"	    
    call ENVIA_CHAR
    movlw "T"	   
    call ENVIA_CHAR
    movlw "A"
    call ENVIA_CHAR
    movlw "S"	   
    call ENVIA_CHAR
    movlw " "	   
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "N"	   
    call ENVIA_CHAR
    movlw " "	   
    call ENVIA_CHAR
    movlw "M"	   
    call ENVIA_CHAR
    movlw "E"	    
    call ENVIA_CHAR
    movlw "D"	    
    call ENVIA_CHAR
    movlw "I"	    
    call ENVIA_CHAR
    movlw "O"	    
    call ENVIA_CHAR
    movlw .0 
    call POS_CUR_FIL2
    movlw "D"	    
    call ENVIA_CHAR
    movlw "E"	    
    call ENVIA_CHAR
    movlw " "	    
    call ENVIA_CHAR
    movlw "L"	    
    call ENVIA_CHAR
    movlw "A"	    
    call ENVIA_CHAR
    movlw " "
    call ENVIA_CHAR
    movlw "M"	    
    call ENVIA_CHAR
    movlw "A"	    
    call ENVIA_CHAR
    movlw "C"	    
    call ENVIA_CHAR
    movlw "U"	    
    call ENVIA_CHAR
    movlw "M"	    
    call ENVIA_CHAR
    movlw "B"	    
    call ENVIA_CHAR
    movlw "A"	    
    call ENVIA_CHAR
label:
    call ubicador
    movlw .0
    cpfseq pase
    goto label
    movlw .1
    movwf indicapantalla   
    goto inicio
    
;---------boton 5 y 6---------;
configura5:
    CALL BORRAR_LCD
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "L"	    
    call ENVIA_CHAR
    movlw "."	    
    call ENVIA_CHAR
    movlw "S"	   
    call ENVIA_CHAR
    movlw "U"
    call ENVIA_CHAR
    movlw "P"	   
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "I"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
control1:
    call ubicador
    movlw .5
    cpfseq indicapantalla
    goto inicio
    movf medio,W
    cpfsgt superior
    goto canchita1
    goto canchita2
canchita1:
    movlw .0 
    call POS_CUR_FIL2
    movlw "O"	    
    call ENVIA_CHAR
    movlw "N"	    
    call ENVIA_CHAR
    movlw " "	    
    call ENVIA_CHAR
    goto control1
canchita2:
    movlw .0 
    call POS_CUR_FIL2
    movlw "O"	    
    call ENVIA_CHAR
    movlw "F"	    
    call ENVIA_CHAR
    movlw "F"	    
    call ENVIA_CHAR
    goto control1
    
configura6:
    CALL BORRAR_LCD
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "L"	    
    call ENVIA_CHAR
    movlw "."	    
    call ENVIA_CHAR
    movlw "I"	   
    call ENVIA_CHAR
    movlw "N"
    call ENVIA_CHAR
    movlw "F"	   
    call ENVIA_CHAR
    movlw "E"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "I"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
control11:
    call ubicador
    movlw .6
    cpfseq indicapantalla
    goto inicio
    movf medio,W
    cpfslt inferior
    goto canchita11
    goto canchita21
canchita11:
    movlw .0 
    call POS_CUR_FIL2
    movlw "O"	    
    call ENVIA_CHAR
    movlw "N"	    
    call ENVIA_CHAR
    movlw " "	    
    call ENVIA_CHAR
    goto control11
canchita21:
    movlw .0 
    call POS_CUR_FIL2
    movlw "O"	    
    call ENVIA_CHAR
    movlw "F"	    
    call ENVIA_CHAR
    movlw "F"	    
    call ENVIA_CHAR
    goto control11
configura7:
    CALL BORRAR_LCD
    call CURSOR_OFF
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    ; BORRO LCD Y MANDO LOS PRIMEROS VALORES
    CALL BORRAR_LCD
    movlw "G"	    
    call ENVIA_CHAR
    movlw "E"	    
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "A"
    call ENVIA_CHAR
    movlw "R"	   
    call ENVIA_CHAR
    movlw "D"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw " "	   
    call ENVIA_CHAR
    movlw "G"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw "N"	   
    call ENVIA_CHAR
    movlw "Z"	   
    call ENVIA_CHAR
    movlw "A"	   
    call ENVIA_CHAR
    movlw "L"	   
    call ENVIA_CHAR
    movlw "O"	   
    call ENVIA_CHAR
    movlw .0 
    call POS_CUR_FIL2
    movlw "M"	    
    call ENVIA_CHAR
    movlw "E"	    
    call ENVIA_CHAR
    movlw "J"	    
    call ENVIA_CHAR
    movlw "I"	    
    call ENVIA_CHAR
    movlw "A"	    
    call ENVIA_CHAR
    movlw " "	    
    call ENVIA_CHAR
    movlw "A"	    
    call ENVIA_CHAR
    movlw "L"	    
    call ENVIA_CHAR
    movlw "D"	    
    call ENVIA_CHAR
    movlw "O"	    
    call ENVIA_CHAR
    movlw "R"	    
    call ENVIA_CHAR
    movlw "A"	    
    call ENVIA_CHAR
    movlw "D"	    
    call ENVIA_CHAR
    movlw "I"	    
    call ENVIA_CHAR
    movlw "N"	    
    call ENVIA_CHAR
camote:
    call ubicador
    movlw .7
    cpfseq indicapantalla
    goto inicio
    goto camote
    
    
    ;------------subrutina de saber que activar-----------;
    
ubicador:
    movlw .0
    movwf pase
    movlw b'00000001' ; selecione canal 0 , active la conversion , empiezo 
    movwf ADCON0
convierto1:
    bsf ADCON0,GO
espera1:
    btfsc ADCON0,GO
    goto espera1
    movff ADRESH,medio
    movlw b'00000101' ; selecione canal 1 , active la conversion , empiezo 
    movwf ADCON0
convierto2:
    bsf ADCON0,GO
espera2:
    btfsc ADCON0,GO
    goto espera2
    movff ADRESH,superior
    movlw b'00001001' ; selecione canal 2 , active la conversion , empiezo 
    movwf ADCON0
convierto3:
    bsf ADCON0,GO
espera3:
    btfsc ADCON0,GO
    goto espera3
    movff ADRESH,inferior
pregunta1:
    movf medio,W
    cpfsgt superior
    goto pregunta2a
    goto pregunta2b
pregunta2a:
    movf medio,W
    cpfslt inferior
    goto Zonaoscura
    goto buzzer
pregunta2b:
    movf medio,W
    cpfslt inferior
    goto LED
    goto nada
Zonaoscura:
    movlw .1
    movwf pase
    bsf LATC,2
    bsf LATE,2
    movlw .4
    movwf indicapantalla
    return
buzzer:
    bsf LATC,2
    bcf LATE,2
    return
LED:
    bcf LATC,2
    bsf LATE,2
    return
nada:
    bcf LATC,2
    bcf LATE,2
    return
    
    ;--------secuencia de interrupcion--------;
    org 0x1000
memachucaron:
    bcf INTCON,RBIF	;bajar bandera
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
    movlw 0x0F		;0F = 00001111
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto valor1
    btfss PORTB,1 
    goto valor6
    btfss PORTB,2
    goto pafuera
    btfss PORTB,3 
    goto pafuera
    goto pafuera
COL2:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto valor2
    btfss PORTB,1 
    goto valor4
    btfss PORTB,2 
    goto pafuera
    btfss PORTB,3 
    goto pafuera
    goto pafuera
COL3:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto valor3
    btfss PORTB,1 
    goto valor5
    btfss PORTB,2 
    goto pafuera
    btfss PORTB,3 
    goto pafuera
    goto pafuera
COL4:
    movlw 0x0F 
    movwf TRISB 
    clrf LATB 
    btfss PORTB,0 
    goto pafuera
    btfss PORTB,1 
    goto pafuera
    btfss PORTB,2 
    goto pafuera
    btfss PORTB,3 
    goto pafuera
    goto pafuera
    ;-----cajas de seleccion----;
valor1:
    movlw .1
    movwf indicapantalla
    goto pafuera
valor2:
    movlw .2
    movwf indicapantalla
    goto pafuera
valor3:
    movlw .3
    movwf indicapantalla
    goto pafuera
valor4:
    movlw .5
    movwf indicapantalla
    goto pafuera
valor5:
    movlw .6
    movwf indicapantalla
    goto pafuera
valor6:
    movlw .7
    movwf indicapantalla
    goto pafuera
pafuera:
    movlw 0xF0
    movwf TRISB
    retfie
 END