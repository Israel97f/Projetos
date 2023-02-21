/*
 * File:   main.c
 * Author: Israel Costa farias
 *
 * Created on 12 de Fevereiro de 2023, 15:33
 */

// PIC16F628 Configuration Bit Settings

// 'C' source line config statements

// CONFIG
#pragma config FOSC = HS        // Oscillator Selection bits (HS oscillator: High-speed crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = ON       // Power-up Timer Enable bit (PWRT enabled)
#pragma config MCLRE = ON       // RA5/MCLR pin function select (RA5/MCLR pin function is MCLR)
#pragma config BOREN = OFF      // Brown-out Reset Enable bit (BOD Reset disabled)
#pragma config LVP = OFF        // Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data Code Protection bit (Data memory code protection off)
#pragma config CP = OFF         // Code Protection bits (Program memory code protection off)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#define _XTAL_FREQ 16000000     //16000000 para 16MHz
#include <xc.h>
#include <pic16f628.h>
#include "Usart.h"

// Variaveis globais
char unpressed_button;

void __interrupt() interruptions(void){
    //Uart_interrupt();
    //Uart_write(uart_buff[11]);
    if (INTCONbits.T0IF){
        if (PORTAbits.RA0 || PORTAbits.RA1 || PORTAbits.RA2 || PORTAbits.RA3 ||
            PORTAbits.RA4 || PORTBbits.RB0){
            
            if(PORTAbits.RA0){
                Uart_write_text("A1");
            }
            if(PORTAbits.RA1){
                Uart_write_text("B1");
            }
            if(PORTAbits.RA2){
                Uart_write_text("C1");
            }
            if(PORTAbits.RA3){
                Uart_write_text("D1");
            }
            if(PORTAbits.RA4){
                Uart_write_text("F1");
            }
            if(PORTBbits.RB0){
                Uart_write_text("G1");
            }
            unpressed_button = 1;
        }else if(unpressed_button){
            Uart_write_text("E1");
            unpressed_button = 0;
        }
        INTCONbits.T0IF = 0;
    }
}

void main(void) {
    CMCONbits.CM = 0x07;               // Desabilita os cmparadores
    TRISAbits.TRISA0 = 1;              // Configura RA0 como entrada digital
    TRISAbits.TRISA1 = 1;              // Configura RA1 como entrada digital
    TRISAbits.TRISA2 = 1;              // Configura RA2 como entrada digital
    TRISAbits.TRISA3 = 1;              // Configura RA3 como entrada digital
    TRISAbits.TRISA4 = 1;              // Configura RA4 como entrada digital
    TRISBbits.TRISB0 = 1;              // Configura RA5 como entrada digital
    
    Uart_interrupt_init();
    Uart_init(1200);                   // Configura u baud rate de 1200 
    
    OPTION_REG = 0b10000110;           // Configura interupição no TMR0 com prescale 1:128
    INTCONbits.T0IE = 1;               // Habilita interrupção por estouro do Timer 0
    
    while(1){
        __delay_ms(5200);
    }
    return;
}
