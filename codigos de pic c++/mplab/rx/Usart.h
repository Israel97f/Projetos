/* 
 * File:   Usart.h
 * Author: Filho
 *
 * Created on 14 de Fevereiro de 2023, 21:07
 */
//~~~~~~~~~~
#ifndef USART_H
    #define	USART_H
    #include <xc.h>
    #ifndef XTAL_FREQ
        #define _XTAL_FREQ 16000000
    #endif
    #ifndef UART_BUFF
        #define LEN_UART_BUFF 12
        char uart_buff[LEN_UART_BUFF];
        int cont;
        char comand, val, checksum;
    #endif
    // metodos
    char Uart_init (const long int baldRate);
    void Uart_write(char data);
    char Uart_tx_empty();
    void Uart_write_text(char *text);
    char Uart_check_data ();
    char Uart_read();
    char Uart_read_text (char *output, unsigned len);
    void Uart_interrupt_init();
    void Uart_interrupt ();
    char Uart_checksum(char *text_);

#endif	/* USART_H */

// metodos
char Uart_init (const long int baldRate){
    unsigned int generatorSpeed;
    generatorSpeed = (_XTAL_FREQ / (64 * baldRate)) - 1;        // Calculo do bald rate de baixa velocidade
    
    if (generatorSpeed > 255) {
        generatorSpeed = (_XTAL_FREQ / 16 * baldRate) - 1;
        TXSTAbits.BRGH = 1;
    } 
    if (generatorSpeed < 256) {
        SPBRG = generatorSpeed;                                 // Passa o valor associado ao bald rate desejado
        TXSTAbits.TX9 = 0;                                      // Configuraa transmissão em 9 bits
        TXSTAbits.TXEN = 1;                                     // Habilida a transmissão de dados
        TXSTAbits.SYNC = 0;                                     // Habilita o modulo assincrono
        RCSTAbits.SPEN = 1;                                     // Habilita a porta serial
        RCSTAbits.CREN = 1;                                     // Habilita a recepição continua de dados
        TRISCbits.TRISC6 = 0;                                   // Configura o pino RC6 como saída digital
        TRISCbits.TRISC7 = 1;                                   // Configura o pino RC7 como entrada digital
        return 1;
    } else{
        return 0;
    }
    
} 

void Uart_write(char data){
    while(!TXSTAbits.TRMT);
    TXREG = data;                                                // Transmite os dados
}

char Uart_tx_empty(){
    return TXSTAbits.TRMT;
}

void Uart_write_text(char *text){
    for (int i = 0; text[i] != '\0'; i++ ){
        Uart_write(text[i]);
    }
    Uart_write(Uart_checksum(text));
}

char Uart_check_data (){
    return PIR1bits.RCIF;
}

char Uart_read(){
    while(!PIR1bits.RCIF);
    return RCREG;
}

char Uart_read_text (char *output, unsigned len){
    int i;
    for (i = 0; i < len ;  i++){
        output[i] = Uart_read();
    }
}

void Uart_interrupt_init(){
    INTCONbits.GIE = 1;                                          // Habilita  a interrupção global
    INTCONbits.PEIE = 1;                                         // Habilita  a interrupção por perifericos
    PIE1bits.RCIE = 1;                                           // Habilita  a interrupção da Uart
}

void Uart_interrupt (){
    char temp = RCREG;
    cont++;
    
    if (cont == 1) comand = temp;
    else if (cont == 2) val = temp;
    else if (cont == 3){ 
        checksum = temp;
        char _data[] = {comand, val, '\0'};
        Uart_write(Uart_checksum(_data));
        if (checksum == Uart_checksum(_data)){
            int i;
            for (i = 0; i < (LEN_UART_BUFF - 3); i++){
                uart_buff[i] = uart_buff[i+3];
            }
            uart_buff[LEN_UART_BUFF - 5] = comand;
            uart_buff[LEN_UART_BUFF - 4] = val;
            uart_buff[LEN_UART_BUFF - 3] = checksum;
          
        }
        cont = 0;
    }
    
    PIR1bits.RCIF = 0;
}

char Uart_checksum(char *text_){
    char bit_0 = 0x00;
    char sum = 0x00;
    for (int i = 0; text_[i] != '\0'; i++){
        bit_0 = (sum + text_[i]) & 0x01;
        sum = (sum + text_[i]) >> 1;
        sum += bit_0;
    }
    if (sum > 0xFF){
        sum >>= 1;
    }
    return ~(char) sum;   
}