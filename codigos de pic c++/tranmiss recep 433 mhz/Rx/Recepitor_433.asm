
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Recepitor_433.c,33 :: 		void interrupt()
;Recepitor_433.c,35 :: 		rx_func(&comand, &value, &check);           //verifica comando e valor recebido
	MOVLW      _comand+0
	MOVWF      FARG_rx_func_cmd+0
	MOVLW      _value+0
	MOVWF      FARG_rx_func_val+0
	MOVLW      _check+0
	MOVWF      FARG_rx_func_ok+0
	CALL       _rx_func+0
;Recepitor_433.c,37 :: 		if(check)                                   //check verdadeiro?
	MOVF       _check+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt0
;Recepitor_433.c,40 :: 		if(comand == 'A')
	MOVF       _comand+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;Recepitor_433.c,42 :: 		RB0_bit = value;       //se comand igual a 'A', atualiza RB0
	BTFSC      _value+0, 0
	GOTO       L__interrupt28
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L__interrupt29
L__interrupt28:
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
L__interrupt29:
;Recepitor_433.c,43 :: 		RB5_bit = value;       //se comand igual a 'A', atualiza RB5
	BTFSC      _value+0, 0
	GOTO       L__interrupt30
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__interrupt31
L__interrupt30:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__interrupt31:
;Recepitor_433.c,44 :: 		}
L_interrupt1:
;Recepitor_433.c,46 :: 		if(comand == 'B')
	MOVF       _comand+0, 0
	XORLW      66
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;Recepitor_433.c,48 :: 		RB1_bit = value;       //se comand igual a 'B', atualiza RB1
	BTFSC      _value+0, 0
	GOTO       L__interrupt32
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__interrupt33
L__interrupt32:
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
L__interrupt33:
;Recepitor_433.c,49 :: 		RB6_bit = value;       //se comand igual a 'B', atualiza RB6
	BTFSC      _value+0, 0
	GOTO       L__interrupt34
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__interrupt35
L__interrupt34:
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
L__interrupt35:
;Recepitor_433.c,50 :: 		}
L_interrupt2:
;Recepitor_433.c,52 :: 		if(comand == 'C')
	MOVF       _comand+0, 0
	XORLW      67
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Recepitor_433.c,54 :: 		RB0_bit = value;       //se comand igual a 'C', atualiza RB0
	BTFSC      _value+0, 0
	GOTO       L__interrupt36
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
	GOTO       L__interrupt37
L__interrupt36:
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
L__interrupt37:
;Recepitor_433.c,55 :: 		RB6_bit = value;       //se comand igual a 'C', atualiza RB6
	BTFSC      _value+0, 0
	GOTO       L__interrupt38
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
	GOTO       L__interrupt39
L__interrupt38:
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
L__interrupt39:
;Recepitor_433.c,56 :: 		}
L_interrupt3:
;Recepitor_433.c,58 :: 		if(comand == 'D')
	MOVF       _comand+0, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Recepitor_433.c,60 :: 		RB5_bit = value;       //se comand igual a 'D', atualiza RB6
	BTFSC      _value+0, 0
	GOTO       L__interrupt40
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L__interrupt41
L__interrupt40:
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
L__interrupt41:
;Recepitor_433.c,61 :: 		RB1_bit = value;       //se comand igual a 'D', atualiza RB1
	BTFSC      _value+0, 0
	GOTO       L__interrupt42
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L__interrupt43
L__interrupt42:
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
L__interrupt43:
;Recepitor_433.c,62 :: 		}
L_interrupt4:
;Recepitor_433.c,64 :: 		if(comand == 'E')
	MOVF       _comand+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
;Recepitor_433.c,66 :: 		automatico = 'e';
	MOVLW      101
	MOVWF      _automatico+0
;Recepitor_433.c,67 :: 		}
L_interrupt5:
;Recepitor_433.c,69 :: 		} //end if ok
L_interrupt0:
;Recepitor_433.c,71 :: 		} //end interrupt
L_end_interrupt:
L__interrupt27:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Recepitor_433.c,76 :: 		void main()
;Recepitor_433.c,78 :: 		CMCON = 0x07;                              //Desabilita comparadores
	MOVLW      7
	MOVWF      CMCON+0
;Recepitor_433.c,79 :: 		TRISB = 0x9C;                              //Configura RB0, RB1, RB5 e RB6 como saída
	MOVLW      156
	MOVWF      TRISB+0
;Recepitor_433.c,80 :: 		PORTB = 0x9C;                              //Inicializa PORTB
	MOVLW      156
	MOVWF      PORTB+0
;Recepitor_433.c,82 :: 		TRISC = 0x80;
	MOVLW      128
	MOVWF      TRISC+0
;Recepitor_433.c,83 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Recepitor_433.c,85 :: 		adcon0 = 0x01;                             //Seleciona A0 como entrada analogica
	MOVLW      1
	MOVWF      ADCON0+0
;Recepitor_433.c,87 :: 		RCIE_bit = 0x01;                           //habilita interrupção da recepção serial
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Recepitor_433.c,88 :: 		GIE_bit  = 0x01;                           //habilita interrupção global
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Recepitor_433.c,89 :: 		PEIE_Bit = 0x01;                           //habilita interrupção dos periféricos
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Recepitor_433.c,91 :: 		UART1_Init(1200);                          //Inicializa UART1 com 1200 baud rate
	MOVLW      207
	MOVWF      SPBRG+0
	BCF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Recepitor_433.c,92 :: 		delay_ms(100);                             //aguarda 100ms
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
;Recepitor_433.c,94 :: 		PWM1_Init(5000);
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Recepitor_433.c,95 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;Recepitor_433.c,96 :: 		PWM1_Set_Duty(duti);
	MOVF       _duti+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Recepitor_433.c,99 :: 		while(1)
L_main7:
;Recepitor_433.c,101 :: 		if(automatico == 'e')
	MOVF       _automatico+0, 0
	XORLW      101
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;Recepitor_433.c,103 :: 		leitura1 = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _leitura1+0
	MOVF       R0+1, 0
	MOVWF      _leitura1+1
	CLRF       _leitura1+2
	CLRF       _leitura1+3
;Recepitor_433.c,105 :: 		duti = 0xCC;
	MOVLW      204
	MOVWF      _duti+0
;Recepitor_433.c,106 :: 		PWM1_Set_Duty(duti);
	MOVLW      204
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Recepitor_433.c,108 :: 		automatico = 'b';
	MOVLW      98
	MOVWF      _automatico+0
;Recepitor_433.c,110 :: 		RB0_bit = 1;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;Recepitor_433.c,111 :: 		RB5_bit = 1;
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
;Recepitor_433.c,113 :: 		if(leitura1 > 97)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _leitura1+3, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVF       _leitura1+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVF       _leitura1+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVF       _leitura1+0, 0
	SUBLW      97
L__main45:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
;Recepitor_433.c,114 :: 		{   Delay_ms(10);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	NOP
	NOP
;Recepitor_433.c,115 :: 		RB0_bit = 0;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;Recepitor_433.c,116 :: 		RB5_bit = 0;
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
;Recepitor_433.c,117 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
;Recepitor_433.c,118 :: 		RB1_bit = 1;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;Recepitor_433.c,119 :: 		RB6_bit = 1;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;Recepitor_433.c,120 :: 		Delay_ms(500);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
	NOP
;Recepitor_433.c,121 :: 		RB1_bit = 0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;Recepitor_433.c,122 :: 		RB6_bit = 0;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;Recepitor_433.c,124 :: 		if(direcao)
	MOVF       _direcao+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;Recepitor_433.c,126 :: 		RB0_bit = 1;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;Recepitor_433.c,127 :: 		RB6_bit = 1;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;Recepitor_433.c,128 :: 		Delay_ms(1200);
	MOVLW      25
	MOVWF      R11+0
	MOVLW      90
	MOVWF      R12+0
	MOVLW      177
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	DECFSZ     R11+0, 1
	GOTO       L_main15
	NOP
	NOP
;Recepitor_433.c,129 :: 		RB0_bit = 0;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;Recepitor_433.c,130 :: 		RB6_bit = 0;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;Recepitor_433.c,131 :: 		direcao = !direcao;
	MOVF       _direcao+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _direcao+0
;Recepitor_433.c,132 :: 		}else
	GOTO       L_main16
L_main14:
;Recepitor_433.c,134 :: 		RB1_bit = 1;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;Recepitor_433.c,135 :: 		RB5_bit = 1;
	BSF        RB5_bit+0, BitPos(RB5_bit+0)
;Recepitor_433.c,136 :: 		Delay_ms(1200);
	MOVLW      25
	MOVWF      R11+0
	MOVLW      90
	MOVWF      R12+0
	MOVLW      177
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	DECFSZ     R11+0, 1
	GOTO       L_main17
	NOP
	NOP
;Recepitor_433.c,137 :: 		RB1_bit = 0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;Recepitor_433.c,138 :: 		RB5_bit = 0;
	BCF        RB5_bit+0, BitPos(RB5_bit+0)
;Recepitor_433.c,139 :: 		direcao = !direcao;
	MOVF       _direcao+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _direcao+0
;Recepitor_433.c,140 :: 		}
L_main16:
;Recepitor_433.c,142 :: 		}
L_main10:
;Recepitor_433.c,143 :: 		duti = 0xFF;
	MOVLW      255
	MOVWF      _duti+0
;Recepitor_433.c,144 :: 		}
L_main9:
;Recepitor_433.c,145 :: 		}                                  //Loop Infinito
	GOTO       L_main7
;Recepitor_433.c,147 :: 		} //end main
L_end_main:
	GOTO       $+0
; end of _main

_rx_func:

;Recepitor_433.c,156 :: 		void rx_func(char *cmd, char *val, char *ok)
;Recepitor_433.c,160 :: 		*ok = 0;                                    //bit de verificação
	MOVF       FARG_rx_func_ok+0, 0
	MOVWF      FSR
	CLRF       INDF+0
;Recepitor_433.c,162 :: 		if(RCIF_bit)                                //houve interrupção na recepção serial?
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_rx_func18
;Recepitor_433.c,164 :: 		RCIF_bit = 0x00;                         //limpa flag
	BCF        RCIF_bit+0, BitPos(RCIF_bit+0)
;Recepitor_433.c,166 :: 		buffer = Uart1_Read();                   //lê serial e armazena em buffer
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      rx_func_buffer_L0+0
;Recepitor_433.c,168 :: 		if(start)                                //se start verdadeiro
	MOVF       _start+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_rx_func19
;Recepitor_433.c,170 :: 		cnt++;                                //incrementa contador
	INCF       _cnt+0, 1
;Recepitor_433.c,172 :: 		if(cnt == 1) *cmd = buffer;           //atualiza cmd, se contador igual a 1
	MOVF       _cnt+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func20
	MOVF       FARG_rx_func_cmd+0, 0
	MOVWF      FSR
	MOVF       rx_func_buffer_L0+0, 0
	MOVWF      INDF+0
L_rx_func20:
;Recepitor_433.c,174 :: 		if(cnt == 2) *val = buffer;           //atualiza val, se contador igual a 2
	MOVF       _cnt+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func21
	MOVF       FARG_rx_func_val+0, 0
	MOVWF      FSR
	MOVF       rx_func_buffer_L0+0, 0
	MOVWF      INDF+0
L_rx_func21:
;Recepitor_433.c,176 :: 		if(cnt == 3)                          //contador igual a 3?
	MOVF       _cnt+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func22
;Recepitor_433.c,179 :: 		start    = 0x00;                   //limpa start
	CLRF       _start+0
;Recepitor_433.c,181 :: 		if(checksum == ~(char)(*cmd + *val)) *ok = 1; //seta ok, se checksum estiver correto
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
	GOTO       L_rx_func23
	MOVF       FARG_rx_func_ok+0, 0
	MOVWF      FSR
	MOVLW      1
	MOVWF      INDF+0
L_rx_func23:
;Recepitor_433.c,183 :: 		} //end if cnt 3
L_rx_func22:
;Recepitor_433.c,185 :: 		} //end if start
	GOTO       L_rx_func24
L_rx_func19:
;Recepitor_433.c,189 :: 		if(buffer == 0xFF)                    //buffer completo?
	MOVF       rx_func_buffer_L0+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_rx_func25
;Recepitor_433.c,191 :: 		start = 0x01;                      //seta start
	MOVLW      1
	MOVWF      _start+0
;Recepitor_433.c,192 :: 		cnt   = 0x00;                      //reinicia contador
	CLRF       _cnt+0
;Recepitor_433.c,194 :: 		} //end if buffer
L_rx_func25:
;Recepitor_433.c,196 :: 		} //end else
L_rx_func24:
;Recepitor_433.c,198 :: 		} //end if RCIF
L_rx_func18:
;Recepitor_433.c,200 :: 		} //end rx_func
L_end_rx_func:
	RETURN
; end of _rx_func
