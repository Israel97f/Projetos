/* ============================================================================

     Controle de robo com módulos TXRX 433MHz

     Software do Transmissor


     MCU: PIC16F628    Clock: Interno 16MHz


     Autor: Eng. Wagner Rambo; Lic. Israel Farias    Data: Janeiro de 2021



============================================================================ */


// ============================================================================
// --- Protótipo das Funções ---
void tx_func(char comand, char value);         //Função para envio de dados tx


// ============================================================================
//---- Variaveis ----

const times = 5;

//=============================================================================
// --- Função Principal ---
void main()
{

   TRISB = 0xFB;                               //configura RB2 como saída (TX)
   UART1_Init (1200);                          //inicializa UART1 com 1200 baud rate
   delay_ms(100);                              //aguarda estabilizar


   while(1)                                    //Loop Infinito
   {
      if(!RB0_bit) tx_func('A',1);             //se RB0 em LOW, envia comando 'A' e dado 1

      if(!RB3_bit) tx_func('B',1);             //se RB1 em LOW, envia comando 'B' e dado 1

      if(!RB5_bit) tx_func('C',1);             //se RB2 em LOW, envia comando 'C' e dado 1

      if(!RB6_bit) tx_func('D',1);             //se RB3 em LOW, envia comando 'D' e dado 1

      if(!RB4_bit) tx_func('E',1);             //se RB4 em LOW, envia comando 'E' e dado 1
      //else  tx_func('E',0);
      
      if(RB0_bit & RB3_bit & RB5_bit & RB6_bit & RB4_bit)     //  se todas as portas estãoem HIGH evia o dado 0
       {
           tx_func('A',0);
           tx_func('B',0);
           tx_func('C',0);
           tx_func('D',0);
       }


   } //end while

} //end main


// ============================================================================
// --- Protótipo das Funções ---


// ============================================================================
// --- Função para envio de dados tx ---
void tx_func(char comand, char value)
{

   UART1_Write(0xFF);                          //byte de start
   delay_ms(times);                               //aguarda
   UART1_Write(comand);                        //envia comando
   delay_ms(times);                               //aguarda
   UART1_Write(value);                         //envia valor do dado
   delay_ms(times);                               //aguarda
   UART1_Write(~(char)(comand+value));         //faz checksum
   delay_ms(times);


} //end tx_func