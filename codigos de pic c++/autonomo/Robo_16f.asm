
_main:

;Robo_16f.c,6 :: 		void main() {
;Robo_16f.c,7 :: 		int date = 0;
	CLRF       main_date_L0+0
	CLRF       main_date_L0+1
;Robo_16f.c,8 :: 		CMCON = 7;
	MOVLW      7
	MOVWF      CMCON+0
;Robo_16f.c,9 :: 		TRISA = 0b00010000;
	MOVLW      16
	MOVWF      TRISA+0
;Robo_16f.c,10 :: 		TRISB = 0b10000001;
	MOVLW      129
	MOVWF      TRISB+0
;Robo_16f.c,11 :: 		PORTA = 0;
	CLRF       PORTA+0
;Robo_16f.c,12 :: 		PORTB = 0;
	CLRF       PORTB+0
;Robo_16f.c,15 :: 		while(1){
L_main0:
;Robo_16f.c,17 :: 		date = Converter(bit2, bit1, bit0);
	MOVLW      0
	BTFSC      RB7_bit+0, BitPos(RB7_bit+0)
	MOVLW      1
	MOVWF      FARG_Converter_n1+0
	CLRF       FARG_Converter_n1+1
	MOVLW      0
	BTFSC      RB0_bit+0, BitPos(RB0_bit+0)
	MOVLW      1
	MOVWF      FARG_Converter_n2+0
	CLRF       FARG_Converter_n2+1
	MOVLW      0
	BTFSC      RA4_bit+0, BitPos(RA4_bit+0)
	MOVLW      1
	MOVWF      FARG_Converter_n3+0
	CLRF       FARG_Converter_n3+1
	CALL       _Converter+0
	MOVF       R0+0, 0
	MOVWF      main_date_L0+0
	MOVF       R0+1, 0
	MOVWF      main_date_L0+1
;Robo_16f.c,18 :: 		if (date == 1){   //SE MOVE PARA FRENTE
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main16
	MOVLW      1
	XORWF      R0+0, 0
L__main16:
	BTFSS      STATUS+0, 2
	GOTO       L_main2
;Robo_16f.c,19 :: 		PORTA = 0xA;
	MOVLW      10
	MOVWF      PORTA+0
;Robo_16f.c,20 :: 		PORTB = 0x28;
	MOVLW      40
	MOVWF      PORTB+0
;Robo_16f.c,21 :: 		}
	GOTO       L_main3
L_main2:
;Robo_16f.c,22 :: 		else if(date == 2){    // PARA
	MOVLW      0
	XORWF      main_date_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main17
	MOVLW      2
	XORWF      main_date_L0+0, 0
L__main17:
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;Robo_16f.c,23 :: 		PORTA = 0;
	CLRF       PORTA+0
;Robo_16f.c,24 :: 		PORTB = 0;
	CLRF       PORTB+0
;Robo_16f.c,25 :: 		}
	GOTO       L_main5
L_main4:
;Robo_16f.c,26 :: 		else if(date == 3){    //SE MOVE PARA TRÁS
	MOVLW      0
	XORWF      main_date_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main18
	MOVLW      3
	XORWF      main_date_L0+0, 0
L__main18:
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;Robo_16f.c,27 :: 		PORTA = 0x5;
	MOVLW      5
	MOVWF      PORTA+0
;Robo_16f.c,28 :: 		PORTB = 0x50;
	MOVLW      80
	MOVWF      PORTB+0
;Robo_16f.c,29 :: 		}
	GOTO       L_main7
L_main6:
;Robo_16f.c,30 :: 		else if(date == 4){    //VIRA PARA ESQUERDA
	MOVLW      0
	XORWF      main_date_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main19
	MOVLW      4
	XORWF      main_date_L0+0, 0
L__main19:
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;Robo_16f.c,31 :: 		PORTA = 0x5;
	MOVLW      5
	MOVWF      PORTA+0
;Robo_16f.c,32 :: 		PORTB = 0x28;
	MOVLW      40
	MOVWF      PORTB+0
;Robo_16f.c,33 :: 		}
	GOTO       L_main9
L_main8:
;Robo_16f.c,34 :: 		else if(date == 5){    //VIRA PARA DIREITA
	MOVLW      0
	XORWF      main_date_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main20
	MOVLW      5
	XORWF      main_date_L0+0, 0
L__main20:
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;Robo_16f.c,35 :: 		PORTA = 0xA;
	MOVLW      10
	MOVWF      PORTA+0
;Robo_16f.c,36 :: 		PORTB = 0x50;
	MOVLW      80
	MOVWF      PORTB+0
;Robo_16f.c,37 :: 		}
L_main10:
L_main9:
L_main7:
L_main5:
L_main3:
;Robo_16f.c,39 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
;Robo_16f.c,40 :: 		}
	GOTO       L_main0
;Robo_16f.c,42 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_Converter:

;Robo_16f.c,43 :: 		int Converter(int n1, int n2, int n3){
;Robo_16f.c,44 :: 		int valor = 0;
	CLRF       Converter_valor_L0+0
	CLRF       Converter_valor_L0+1
;Robo_16f.c,45 :: 		if (n1 == 1){
	MOVLW      0
	XORWF      FARG_Converter_n1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Converter22
	MOVLW      1
	XORWF      FARG_Converter_n1+0, 0
L__Converter22:
	BTFSS      STATUS+0, 2
	GOTO       L_Converter12
;Robo_16f.c,46 :: 		valor = valor + 4;
	MOVLW      4
	ADDWF      Converter_valor_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       Converter_valor_L0+1, 1
;Robo_16f.c,47 :: 		}
L_Converter12:
;Robo_16f.c,48 :: 		if (n2 == 1){
	MOVLW      0
	XORWF      FARG_Converter_n2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Converter23
	MOVLW      1
	XORWF      FARG_Converter_n2+0, 0
L__Converter23:
	BTFSS      STATUS+0, 2
	GOTO       L_Converter13
;Robo_16f.c,49 :: 		valor = valor + 2;
	MOVLW      2
	ADDWF      Converter_valor_L0+0, 1
	BTFSC      STATUS+0, 0
	INCF       Converter_valor_L0+1, 1
;Robo_16f.c,50 :: 		}
L_Converter13:
;Robo_16f.c,51 :: 		if (n3 == 1){
	MOVLW      0
	XORWF      FARG_Converter_n3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Converter24
	MOVLW      1
	XORWF      FARG_Converter_n3+0, 0
L__Converter24:
	BTFSS      STATUS+0, 2
	GOTO       L_Converter14
;Robo_16f.c,52 :: 		valor = valor + 1;
	INCF       Converter_valor_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Converter_valor_L0+1, 1
;Robo_16f.c,53 :: 		}
L_Converter14:
;Robo_16f.c,54 :: 		return(valor);
	MOVF       Converter_valor_L0+0, 0
	MOVWF      R0+0
	MOVF       Converter_valor_L0+1, 0
	MOVWF      R0+1
;Robo_16f.c,55 :: 		}
L_end_Converter:
	RETURN
; end of _Converter
