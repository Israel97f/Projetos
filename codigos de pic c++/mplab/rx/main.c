/*
 * File:   main.c
 * Author: Filho
 *
 * Created on 17 de Fevereiro de 2023, 19:50
 */

// PIC16F877A Configuration Bit Settings

// 'C' source line config statements

// CONFIG
#pragma config FOSC = HS        // Oscillator Selection bits (HS oscillator)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = ON       // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOREN = OFF      // Brown-out Reset Enable bit (BOR disabled)
#pragma config LVP = OFF        // Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
#pragma config WRT = OFF        // Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
#pragma config CP = OFF         // Flash Program Memory Code Protection bit (Code protection off)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#include "Usart.h"

#define _XTAL_FREQ 16000000                                 // Cofigura um uma frequencia de 16Mz
#define ENGINE1bit1 PORTBbits.RB0
#define ENGINE1bit2 PORTBbits.RB1
#define ENGINE2bit1 PORTBbits.RB2
#define ENGINE2bit2 PORTBbits.RB3
// prototipos
void muve(char direction);
//void change_direction (char comand, char *arg);

// variaveis globais
char direction = 's';
long int cont_dut = 0;
// interrupção
void __interrupt() interruptions(){
    Uart_interrupt ();
    if (uart_buff[7] == 'E'){
        direction = 's';
    }
    if (uart_buff[7] == 'B'){
        direction = 'd';
    }
    if (uart_buff[7] == 'A'){
        direction = 'u';
    }
    if (uart_buff[7] == 'C'){
        direction = 'r';
    }
    if (uart_buff[7] == 'D'){
        direction = 'l';
    }
    // incrementar dut cicly
    if (uart_buff[7] == 'F'){
        CCPR1L++; 
        CCPR2L++;
    }
    if (uart_buff[7] == 'G'){
        CCPR1L--;
        CCPR2L--;
    }
    cont_dut = 0;
    
}

void main(void) {
    CMCON = 0x07;                                           // Desabilita os comparadores
    TRISBbits.TRISB0 = 0;                                   // Configura RB0 como saida digital
    TRISBbits.TRISB1 = 0;                                   // Configura RB1 como saida digital
    TRISBbits.TRISB2 = 0;                                   // Configura RB2 como saida digital
    TRISBbits.TRISB3 = 0;                                   // Configura RB3 como saida digital
    Uart_init(1200);                                        // Cofigura uma counicação com 1200 de baud rate
    Uart_interrupt_init();
    
    PR2 = 0xFF;                                             // Inicia o regitrador de comtrole do timer 2 em 255
    T2CON = 0x06;                                           // Ativa o TMR2 com prescale de 1;16
    CCPR1L = 0x7F;                                          // Inicia com duty de 50%
    CCP1CON = 0x0C;                                         // Ativa o modo de PWM
    CCPR2L = 0x7F;                                          // Inicia com duty de 50%
    CCP2CON = 0x0C;                                         // Ativa o modo de PWM
    TRISCbits.TRISC2 = 0;
    TRISCbits.TRISC1 = 0;
    
    while(1){ 
        muve(direction);
        __delay_ms(10);
    }
    return;
}

void muve(char direction){
    if (direction == 'l'){
        ENGINE1bit1 = 1;
        ENGINE1bit2 = 0;
        ENGINE2bit1 = 0;
        ENGINE2bit2 = 1;
    }
    if (direction == 'r'){
        ENGINE1bit1 = 0;
        ENGINE1bit2 = 1;
        ENGINE2bit1 = 1;
        ENGINE2bit2 = 0;
    }
    if (direction == 'u'){
        ENGINE1bit1 = 1;
        ENGINE1bit2 = 0;
        ENGINE2bit1 = 1;
        ENGINE2bit2 = 0;
    }
    if (direction == 'd'){
        ENGINE1bit1 = 0;
        ENGINE1bit2 = 1;
        ENGINE2bit1 = 0;
        ENGINE2bit2 = 1;
    }
    if (direction == 's'){
        ENGINE1bit1 = 0;
        ENGINE1bit2 = 0;
        ENGINE2bit1 = 0;
        ENGINE2bit2 = 0;
    }
}
