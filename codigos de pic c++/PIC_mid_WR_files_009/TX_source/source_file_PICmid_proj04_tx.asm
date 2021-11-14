
_main:

;source_file_PICmid_proj04_tx.c,11 :: 		void main()
;source_file_PICmid_proj04_tx.c,14 :: 		TRISB = 0xFD;                               //configura RB2 como saída (TX)
	MOVLW      253
	MOVWF      TRISB+0
;source_file_PICmid_proj04_tx.c,15 :: 		UART1_Init(1200);                           //inicializa UART1 com 1200 baud rate
	MOVLW      207
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;source_file_PICmid_proj04_tx.c,16 :: 		delay_ms(100);                              //aguarda estabilizar
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	NOP
	NOP
;source_file_PICmid_proj04_tx.c,19 :: 		while(1)                                    //Loop Infinito
L_main1:
;source_file_PICmid_proj04_tx.c,21 :: 		if(!RB0_bit) tx_func('A',1);             //se RB0 em LOW, envia comando 'A' e dado 1
	BTFSC      RB0_bit+0, 0
	GOTO       L_main3
	MOVLW      65
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
	GOTO       L_main4
L_main3:
;source_file_PICmid_proj04_tx.c,22 :: 		else tx_func('A',0);                     //senão, envia comando 'A' e dado 0
	MOVLW      65
	MOVWF      FARG_tx_func_comand+0
	CLRF       FARG_tx_func_value+0
	CALL       _tx_func+0
L_main4:
;source_file_PICmid_proj04_tx.c,24 :: 		if(!RB1_bit) tx_func('B',1);             //se RB1 em LOW, envia comando 'B' e dado 1
	BTFSC      RB1_bit+0, 1
	GOTO       L_main5
	MOVLW      66
	MOVWF      FARG_tx_func_comand+0
	MOVLW      1
	MOVWF      FARG_tx_func_value+0
	CALL       _tx_func+0
	GOTO       L_main6
L_main5:
;source_file_PICmid_proj04_tx.c,25 :: 		else tx_func('B',0);                     //senão, envia comando 'B' e dado 0
	MOVLW      66
	MOVWF      FARG_tx_func_comand+0
	CLRF       FARG_tx_func_value+0
	CALL       _tx_func+0
L_main6:
;source_file_PICmid_proj04_tx.c,28 :: 		} //end while
	GOTO       L_main1
;source_file_PICmid_proj04_tx.c,30 :: 		} //end main
	GOTO       $+0
; end of _main

_tx_func:

;source_file_PICmid_proj04_tx.c,39 :: 		void tx_func(char comand, char value)
;source_file_PICmid_proj04_tx.c,42 :: 		UART1_Write(0xFF);                          //byte de start
	MOVLW      255
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;source_file_PICmid_proj04_tx.c,43 :: 		delay_ms(10);                               //aguarda
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_tx_func7:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func7
	DECFSZ     R12+0, 1
	GOTO       L_tx_func7
	NOP
	NOP
;source_file_PICmid_proj04_tx.c,44 :: 		UART1_Write(comand);                        //envia comando
	MOVF       FARG_tx_func_comand+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;source_file_PICmid_proj04_tx.c,45 :: 		delay_ms(10);                               //aguarda
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_tx_func8:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func8
	DECFSZ     R12+0, 1
	GOTO       L_tx_func8
	NOP
	NOP
;source_file_PICmid_proj04_tx.c,46 :: 		UART1_Write(value);                         //envia valor do dado
	MOVF       FARG_tx_func_value+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;source_file_PICmid_proj04_tx.c,47 :: 		delay_ms(10);                               //aguarda
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_tx_func9:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func9
	DECFSZ     R12+0, 1
	GOTO       L_tx_func9
	NOP
	NOP
;source_file_PICmid_proj04_tx.c,48 :: 		UART1_Write(~(char)(comand+value));         //faz checksum
	MOVF       FARG_tx_func_value+0, 0
	ADDWF      FARG_tx_func_comand+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	COMF       FARG_UART1_Write_data_+0, 1
	CALL       _UART1_Write+0
;source_file_PICmid_proj04_tx.c,49 :: 		delay_ms(10);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_tx_func10:
	DECFSZ     R13+0, 1
	GOTO       L_tx_func10
	DECFSZ     R12+0, 1
	GOTO       L_tx_func10
	NOP
	NOP
;source_file_PICmid_proj04_tx.c,52 :: 		} //end tx_func
	RETURN
; end of _tx_func
