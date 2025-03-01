/* ============================================================================

     Controle de Portão Codificado com módulos TXRX 433MHz
     
     Software do Receptor


     MCU: PIC16F628A    Clock: Interno 4MHz


     Autor: Eng. Wagner Rambo    Data: Maio de 2018



============================================================================ */


// ============================================================================
// --- Protótipo das Funções ---
void rx_func(char *cmd, char *val, char *ok);  //Recebimento de dados seriais


// ============================================================================
// --- Variáveis Globais ---
char start, cnt;                               //start e contador auxiliar
char comand, value, check;                     //bytes a serem recebidos


// ============================================================================
// --- Interrupção ---
void interrupt()
{
   rx_func(&comand, &value, &check);           //verifica comando e valor recebido

   if(check)                                   //check verdadeiro?
   {                                           //Sim...

      if(comand == 'A') RB0_bit = value;       //se comand igual a 'A', atualiza RB0

      if(comand == 'B') RB5_bit = value;       //se comand igual a 'B', atualiza RB5


   } //end if ok

} //end interrupt


// ============================================================================
// --- Função Principal ---
void main()
{
    CMCON = 0x07;                              //Desabilita comparadores
    TRISB = 0xDE;                              //Configura RB0 e RB5 como saída
    PORTB = 0xDE;                              //Inicializa PORTB
  
    RCIE_bit = 0x01;                           //habilita interrupção da recepção serial
    GIE_bit  = 0x01;                           //habilita interrupção global
    PEIE_Bit = 0x01;                           //habilita interrupção dos periféricos
  
    UART1_Init(1200);                          //Inicializa UART1 com 1200 baud rate
    delay_ms(100);                             //aguarda 100ms



    while(1);                                  //Loop Infinito

} //end main


// ============================================================================
// --- Desenvolvimento das Funções ---


// ============================================================================
// --- Função para Recebimento de Dados Seriais ---
void rx_func(char *cmd, char *val, char *ok)
{
   char buffer;                                //variável local para buffer de dados
   char checksum;                              //variável de checksum
   *ok = 0;                                    //bit de verificação

   if(RCIF_bit)                                //houve interrupção na recepção serial?
   {                                           //sim
      RCIF_bit = 0x00;                         //limpa flag
      
      buffer = Uart1_Read();                   //lê serial e armazena em buffer
      
      if(start)                                //se start verdadeiro
      {
         cnt++;                                //incrementa contador
         
         if(cnt == 1) *cmd = buffer;           //atualiza cmd, se contador igual a 1

         if(cnt == 2) *val = buffer;           //atualiza val, se contador igual a 2

         if(cnt == 3)                          //contador igual a 3?
         {                                     //sim
            checksum = buffer;                 //checksum recebe o valor do buffer
            start    = 0x00;                   //limpa start
            
            if(checksum == ~(char)(*cmd + *val)) *ok = 1; //seta ok, se checksum estiver correto

         } //end if cnt 3
         
      } //end if start
      
      else                                     //senão
      {
         if(buffer == 0xFF)                    //buffer completo?
         {                                     //sim
            start = 0x01;                      //seta start
            cnt   = 0x00;                      //reinicia contador
            
         } //end if buffer
      
      } //end else
      
   } //end if RCIF

} //end rx_func









