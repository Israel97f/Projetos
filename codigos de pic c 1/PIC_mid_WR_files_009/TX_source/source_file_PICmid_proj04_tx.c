/* ============================================================================

     Controle de Port�o Codificado com m�dulos TXRX 433MHz

     Software do Transmissor


     MCU: PIC16F628A    Clock: Interno 4MHz


     Autor: Eng. Wagner Rambo    Data: Maio de 2018



============================================================================ */


// ============================================================================
// --- Prot�tipo das Fun��es ---
void tx_func(char comand, char value);         //Fun��o para envio de dados tx


// ============================================================================
// --- Fun��o Principal ---
void main()
{

   TRISB = 0xFD;                               //configura RB2 como sa�da (TX)
   UART1_Init(1200);                           //inicializa UART1 com 1200 baud rate
   delay_ms(100);                              //aguarda estabilizar
     
     
   while(1)                                    //Loop Infinito
   {
      if(!RB0_bit) tx_func('A',1);             //se RB0 em LOW, envia comando 'A' e dado 1
      else tx_func('A',0);                     //sen�o, envia comando 'A' e dado 0

      if(!RB1_bit) tx_func('B',1);             //se RB1 em LOW, envia comando 'B' e dado 1
      else tx_func('B',0);                     //sen�o, envia comando 'B' e dado 0


   } //end while

} //end main


// ============================================================================
// --- Prot�tipo das Fun��es ---


// ============================================================================
// --- Fun��o para envio de dados tx ---
void tx_func(char comand, char value)
{

   UART1_Write(0xFF);                          //byte de start
   delay_ms(10);                               //aguarda
   UART1_Write(comand);                        //envia comando
   delay_ms(10);                               //aguarda
   UART1_Write(value);                         //envia valor do dado
   delay_ms(10);                               //aguarda
   UART1_Write(~(char)(comand+value));         //faz checksum
   delay_ms(10);
   
   
} //end tx_func













