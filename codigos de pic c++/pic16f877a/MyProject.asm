
_main:

;MyProject.c,1 :: 		void main()
;MyProject.c,4 :: 		TRISB = 0x00;     // SETA AS PORTAS B COMO SAIDAS
	CLRF       TRISB+0
;MyProject.c,5 :: 		PORTB = 0x00;       // INICIA AS POETAS EM LOW
	CLRF       PORTB+0
;MyProject.c,8 :: 		while(1)
L_main0:
;MyProject.c,10 :: 		PORTB = 0x20;
	MOVLW      32
	MOVWF      PORTB+0
;MyProject.c,11 :: 		delay_ms(200);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
;MyProject.c,12 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;MyProject.c,13 :: 		delay_ms(200);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
;MyProject.c,15 :: 		}
	GOTO       L_main0
;MyProject.c,16 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
