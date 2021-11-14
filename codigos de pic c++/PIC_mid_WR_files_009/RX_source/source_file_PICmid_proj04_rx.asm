
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;source_file_PICmid_proj04_rx.c,31 :: 		void interrupt()
;source_file_PICmid_proj04_rx.c,33 :: 		rx_func(&comand, &value, &check);           //verifica comando e valor recebido
	MOVLW      _comand+0
	MOVWF      FARG_rx_func_cmd+0
	MOVLW      _value+0
	MOVWF      FARG_rx_func_val+0
	MOVLW      _check+0
	MOVWF      FARG_rx_func_ok+0
	CALL       _rx_func+0
;source_file_PICmid_proj04_rx.c,35 :: 		if(check)                                   //check verdadeiro?
	MOVF       _check+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt0
;source_file_PICmid_proj04_rx.c,38 :: 		if(comand == 'A') RB0_bit = value;       //se comand igual a 'A', atualiza RB0
	MOVF       _comand+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
	BTFSC      _value+0, 0
	GOTO       L__interrupt15
	BCF        RB0_bit+0, 0
	GOTO       L__interrupt16
L__interrupt15:
	BSF        RB0_bit+0, 0
L__interrupt16:
L_interrupt1:
;source_file_PICmid_proj04_rx.c,40 :: 		if(comand == 'B') RB5_bit = value;       //se comand igual a 'B', atualiza RB5
	MOVF       _comand+0, 0
	XORLW      66
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	BTFSC      _value+0, 0
	GOTO       L__interrupt17
	BCF        RB5_bit+0, 5
	GOTO       L__interrupt18
L__interrupt17:
	BSF        RB5_bit+0, 5
L__interrupt18:
L_interrupt2:
;source_file_PICmid_proj04_rx.c,43 :: 		} //end if ok
L_interrupt0:
;source_file_PICmid_proj04_rx.c,45 :: 		} //end interrupt
L__interrupt14:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;source_file_PICmid_proj04_rx.c,50 :: 		void main()
;source_file_PICmid_proj04_rx.c,52 :: 		CMCON = 0x07;                              //Desabilita comparadores
	MOVLW      7
	MOVWF      CMCON+0
;source_file_PICmid_proj04_rx.c,53 :: 		TRISB = 0xDE;                              //Configura RB0 e RB5 como saída
	MOVLW      222
	MOVWF      TRISB+0
;source_file_PICmid_proj04_rx.c,54 :: 		PORTB = 0xDE;                              //Inicializa PORTB
	MOVLW      222
	MOVWF      PORTB+0
;source_file_PICmid_proj04_rx.c,56 :: 		RCIE_bit = 0x01;                           //habilita interrupção da recepção serial
	BSF        RCIE_bit+0, 5
;source_file_PICmid_proj04_rx.c,57 :: 		GIE_bit  = 0x01;                           //habilita interrupção global
	BSF        GIE_bit+0, 7
;source_file_PICmid_proj04_rx.c,58 :: 		PEIE_Bit = 0x01;                           //habilita interrupção dos periféricos
	BSF        PEIE_bit+0, 6
;source_file_PICmid_proj04_rx.c,60 :: 		UART1_Init(1200);                          //Inicializa UART1 com 1200 baud rate
	MOVLW      207
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;source_file_PICmid_proj04_rx.c,61 :: 		delay_ms(100);                             //aguarda 100ms
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	NOP
	NOP
;source_file_PICmid_proj04_rx.c,65 :: 		while(1);                                  //Loop Infinito
L_main4:
	GOTO       L_main4
;source_file_PICmid_proj04_rx.c,67 :: 		} //end main
	GOTO       $+0
; end of _main

_rx_func:

;source_file_PICmid_proj04_rx.c,76 :: 		void rx_func(char *cmd, char *val, char *ok)
;source_file_PICmid_proj04_rx.c,80 :: 		*ok = 0;                                    //bit de verificação
	MOVF       FARG_rx_func_ok+0, 0
	MOVWF      FSR
	CLRF       INDF+0
;source_file_PICmid_proj04_rx.c,82 :: 		if(RCIF_bit)                                //houve interrupção na recepção serial?
	BTFSS      RCIF_bit+0, 5
	GOTO       L_rx_func6
;source_file_PICmid_proj04_rx.c,84 :: 		RCIF_bit = 0x00;                         //limpa flag
	BCF        RCIF_bit+0, 5
;source_file_PICmid_proj04_rx.c,86 :: 		buffer = Uart1_Read();                   //lê serial e armazena em buffer
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      rx_func_buffer_L0+0
;source_file_PICmid_proj04_rx.c,88 :: 		if(start)                                //se start verdadeiro
	MOVF       _start+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_rx_func7
;source_file_PICmid_proj04_rx.c,90 :: 		cnt++;                                //incrementa contador
	INCF       _cnt+0, 1
;source_file_PICmid_proj04_rx.c,92 :: 		if(cnt == 1) *cmd = buffer;           //atualiza cmd, se contador igual a 1
	MOVF       _cnt+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func8
	MOVF       FARG_rx_func_cmd+0, 0
	MOVWF      FSR
	MOVF       rx_func_buffer_L0+0, 0
	MOVWF      INDF+0
L_rx_func8:
;source_file_PICmid_proj04_rx.c,94 :: 		if(cnt == 2) *val = buffer;           //atualiza val, se contador igual a 2
	MOVF       _cnt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func9
	MOVF       FARG_rx_func_val+0, 0
	MOVWF      FSR
	MOVF       rx_func_buffer_L0+0, 0
	MOVWF      INDF+0
L_rx_func9:
;source_file_PICmid_proj04_rx.c,96 :: 		if(cnt == 3)                          //contador igual a 3?
	MOVF       _cnt+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func10
;source_file_PICmid_proj04_rx.c,99 :: 		start    = 0x00;                   //limpa start
	CLRF       _start+0
;source_file_PICmid_proj04_rx.c,101 :: 		if(checksum == ~(char)(*cmd + *val)) *ok = 1; //seta ok, se checksum estiver correto
	MOVF       FARG_rx_func_cmd+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       FARG_rx_func_val+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	ADDWF      R0+0, 1
	COMF       R0+0, 0
	MOVWF      R1+0
	MOVF       rx_func_buffer_L0+0, 0
	XORWF      R1+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func11
	MOVF       FARG_rx_func_ok+0, 0
	MOVWF      FSR
	MOVLW      1
	MOVWF      INDF+0
L_rx_func11:
;source_file_PICmid_proj04_rx.c,103 :: 		} //end if cnt 3
L_rx_func10:
;source_file_PICmid_proj04_rx.c,105 :: 		} //end if start
	GOTO       L_rx_func12
L_rx_func7:
;source_file_PICmid_proj04_rx.c,109 :: 		if(buffer == 0xFF)                    //buffer completo?
	MOVF       rx_func_buffer_L0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func13
;source_file_PICmid_proj04_rx.c,111 :: 		start = 0x01;                      //seta start
	MOVLW      1
	MOVWF      _start+0
;source_file_PICmid_proj04_rx.c,112 :: 		cnt   = 0x00;                      //reinicia contador
	CLRF       _cnt+0
;source_file_PICmid_proj04_rx.c,114 :: 		} //end if buffer
L_rx_func13:
;source_file_PICmid_proj04_rx.c,116 :: 		} //end else
L_rx_func12:
;source_file_PICmid_proj04_rx.c,118 :: 		} //end if RCIF
L_rx_func6:
;source_file_PICmid_proj04_rx.c,120 :: 		} //end rx_func
	RETURN
; end of _rx_func
