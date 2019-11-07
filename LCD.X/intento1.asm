    #include "p18F4550.inc"
    CONFIG FOSC = XT_XT
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG BORV = 3
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG MCLRE = ON
    CONFIG LVP = OFF
    
    cblock 0x10
    temp
    entra7bit
    endc
 
    org 0x200
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
 org 0x0020
configura:
    setf TRISA
    clrf TRISD
    clrf TRISB
    call DELAY15MSEG
    call LCD_CONFIG
    movlw 0x1C ;0X0E
    movwf ADCON1
    movlw b'00110100'
    movwf ADCON2
    movlw HIGH TEM
    movwf TBLPTRH
    movlw LOW TEM
    movwf TBLPTRL
    call CURSOR_OFF
    ;bcf TRISC,2
    ;bcf LATC,2
    
    
CONF1:
    ; CONFIGURO QUE SALIDA QUIERO RECUERDA QUE DEBES VER LA TABLA PARA QUE SEAN 3 
    movlw b'00000001' ; selecione canal 0 , active la conversion , empiezo 
    movwf ADCON0
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
    
TOCA_CONVERTIR:
    bsf ADCON0,GO
ESPERA:
    btfsc ADCON0,GO
    goto ESPERA
    movlw .0 ; POSICION DE COLUMNA QUE VOY A USAR 
    call POS_CUR_FIL2 ; DONDE VOY A PONER LA FILA 1 O 2 
    
    movf ADRESH, W
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
    movlw 'C'
    call ENVIA_CHAR
    movlw '°'
    call ENVIA_CHAR
    
    
    
    
    goto TOCA_CONVERTIR 

#include "LCD_LIB.asm"
 END