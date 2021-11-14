
_main:

;tranmissor_433_mhz.c,30 :: 		void main()
;tranmissor_433_mhz.c,33 :: 		TRISB = 0xFB;                               //configura RB2 como saída (TX)
	MOVLW      251
	MOVWF      TRISB+0
;tranmissor_433_mhz.c,34 :: 		UART1_Init (1200);                          //inicializa UART1 com 1200 baud rate
	MOVLW      207
	MOVWF      SPBRG+0
	BCF        TXSTA+0, 2
	CALL       _UART1_Init+0
;tranmissor_433_mhz.c,35 :: 		delay_ms(100);                              //aguarda estabilizar
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
;tranmissor_433_mhz.c,38 :: 		while(1)                                    //Loop Infinito
L_main1:
;tranmissor_433_mhz.c,40 :: 		if(!RB0_bit) tx_func('A',1);             //se RB0 em LOW, envia comando 'A' e dado 1
	BTFSC      RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L_main3
	MOVLW      65
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
L_main3:
;tranmissor_433_mhz.c,42 :: 		if(!RB3_bit) tx_func('B',1);             //se RB1 em LOW, envia comando 'B' e dado 1
	BTFSC      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_main4
	MOVLW      66
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
L_main4:
;tranmissor_433_mhz.c,44 :: 		if(!RB5_bit) tx_func('C',1);             //se RB2 em LOW, envia comando 'C' e dado 1
	BTFSC      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_main5
	MOVLW      67
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
L_main5:
;tranmissor_433_mhz.c,46 :: 		if(!RB6_bit) tx_func('D',1);             //se RB3 em LOW, envia comando 'D' e dado 1
	BTFSC      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L_main6
	MOVLW      68
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
L_main6:
;tranmissor_433_mhz.c,48 :: 		if(!RB4_bit) tx_func('E',1);             //se RB4 em LOW, envia comando 'E' e dado 1
	BTFSC      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L_main7
	MOVLW      69
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
L_main7:
;tranmissor_433_mhz.c,51 :: 		if(RB0_bit & RB3_bit & RB5_bit & RB6_bit & RB4_bit)     //  se todas as portas estãoem HIGH evia o dado 0
	BTFSS      RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L__main14
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L__main14
	BSF        3, 0
	GOTO       L__main15
L__main14:
	BCF        3, 0
L__main15:
	BTFSS      3, 0
	GOTO       L__main16
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__main16
	BSF        112, 0
	GOTO       L__main17
L__main16:
	BCF        112, 0
L__main17:
	BTFSS      112, 0
	GOTO       L__main18
	BTFSS      RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__main18
	BSF        3, 0
	GOTO       L__main19
L__main18:
	BCF        3, 0
L__main19:
	BTFSS      3, 0
	GOTO       L__main20
	BTFSS      RB4_bit+0, BitPos(RB4_bit+0)
	GOTO       L__main20
	BSF        112, 0
	GOTO       L__main21
L__main20:
	BCF        112, 0
L__main21:
	BTFSS      112, 0
	GOTO       L_main8
;tranmissor_433_mhz.c,53 :: 		tx_func('A',0);
	MOVLW      65
	MOVWF      FARG_tx_func_comand+0
	CLRF       FARG_tx_func_value+0
	CALL       _tx_func+0
;tranmissor_433_mhz.c,54 :: 		tx_func('B',0);
	MOVLW      66
	MOVWF      FARG_tx_func_comand+0
	CLRF       FARG_tx_func_value+0
	CALL       _tx_func+0
;tranmissor_433_mhz.c,55 :: 		tx_func('C',0);
	MOVLW      67
	MOVWF      FARG_tx_func_comand+0
	CLRF       FARG_tx_func_value+0
	CALL       _tx_func+0
;tranmissor_433_mhz.c,56 :: 		tx_func('D',0);
	MOVLW      68
	MOVWF      FARG_tx_func_comand+0
	CLRF       FARG_tx_func_value+0
	CALL       _tx_func+0
;tranmissor_433_mhz.c,57 :: 		}
L_main8:
;tranmissor_433_mhz.c,60 :: 		} //end while
	GOTO       L_main1
;tranmissor_433_mhz.c,62 :: 		} //end main
L_end_main:
	GOTO       $+0
; end of _main

_tx_func:

;tranmissor_433_mhz.c,71 :: 		void tx_func(char comand, char value)
;tranmissor_433_mhz.c,74 :: 		UART1_Write(0xFF);                          //byte de start
	MOVLW      255
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;tranmissor_433_mhz.c,75 :: 		delay_ms(times);                               //aguarda
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_tx_func9:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func9
	DECFSZ     R12+0, 1
	GOTO       L_tx_func9
	NOP
;tranmissor_433_mhz.c,76 :: 		UART1_Write(comand);                        //envia comando
	MOVF       FARG_tx_func_comand+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;tranmissor_433_mhz.c,77 :: 		delay_ms(times);                               //aguarda
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_tx_func10:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func10
	DECFSZ     R12+0, 1
	GOTO       L_tx_func10
	NOP
;tranmissor_433_mhz.c,78 :: 		UART1_Write(value);                         //envia valor do dado
	MOVF       FARG_tx_func_value+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;tranmissor_433_mhz.c,79 :: 		delay_ms(times);                               //aguarda
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_tx_func11:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func11
	DECFSZ     R12+0, 1
	GOTO       L_tx_func11
	NOP
;tranmissor_433_mhz.c,80 :: 		UART1_Write(~(char)(comand+value));         //faz checksum
	MOVF       FARG_tx_func_value+0, 0
	ADDWF      FARG_tx_func_comand+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	COMF       FARG_UART1_Write_data_+0, 1
	CALL       _UART1_Write+0
;tranmissor_433_mhz.c,81 :: 		delay_ms(times);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_tx_func12:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func12
	DECFSZ     R12+0, 1
	GOTO       L_tx_func12
	NOP
;tranmissor_433_mhz.c,84 :: 		} //end tx_func
L_end_tx_func:
	RETURN
; end of _tx_func
