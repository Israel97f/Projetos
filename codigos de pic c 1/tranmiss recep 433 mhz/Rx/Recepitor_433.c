/* ============================================================================

     Controle de Robo com módulos TXRX 433MHz

     Software do Receptor


     MCU: PIC16F877A    Clock: Externo 16MHz


     Autor: Eng. Wagner Rambo; Lic. Israel Farias    Data: Janeiro de 2021



============================================================================ */


// ============================================================================
// --- Protótipo das Funções ---
void rx_func(char *cmd, char *val, char *ok);  //Recebimento de dados seriais


// ============================================================================
// --- Variáveis Globais ---
char start, cnt;                               //start e contador auxiliar
char comand, value, check;                     //bytes a serem recebidos
char automatico;
char direcao;
unsigned short duti = 0xFF;
long int leitura1;
// ============================================================================
// --- Interrupção ---
void interrupt()
{
   rx_func(&comand, &value, &check);           //verifica comando e valor recebido

   if(check)                                   //check verdadeiro?
   {                                           //Sim...

      if(comand == 'A')
      {
         RB0_bit = value;       //se comand igual a 'A', atualiza RB0
         RB5_bit = value;       //se comand igual a 'A', atualiza RB5
      }

      if(comand == 'B')
      {
         RB1_bit = value;       //se comand igual a 'B', atualiza RB1
         RB6_bit = value;       //se comand igual a 'B', atualiza RB6
      }

       if(comand == 'C')
      {
         RB0_bit = value;       //se comand igual a 'C', atualiza RB0
         RB6_bit = value;       //se comand igual a 'C', atualiza RB6
      }

      if(comand == 'D')
      {
         RB5_bit = value;       //se comand igual a 'D', atualiza RB6
         RB1_bit = value;       //se comand igual a 'D', atualiza RB1
      }
      
      if(comand == 'E')
      {
         automatico = 'e';
      }

   } //end if ok

} //end interrupt


// ============================================================================
// --- Função Principal ---
void main()
{
    CMCON = 0x07;                              //Desabilita comparadores
    TRISB = 0x9C;                              //Configura RB0, RB1, RB5 e RB6 como saída
    PORTB = 0x9C;                              //Inicializa PORTB
    
    TRISC = 0x80;
    PORTC = 0x00;
    
    adcon0 = 0x01;                             //Seleciona A0 como entrada analogica

    RCIE_bit = 0x01;                           //habilita interrupção da recepção serial
    GIE_bit  = 0x01;                           //habilita interrupção global
    PEIE_Bit = 0x01;                           //habilita interrupção dos periféricos

    UART1_Init(1200);                          //Inicializa UART1 com 1200 baud rate
    delay_ms(100);                             //aguarda 100ms
    
    PWM1_Init(5000);
    PWM1_Start();
    PWM1_Set_Duty(duti);


    while(1)
    {
        if(automatico == 'e')
       {   
            leitura1 = ADC_Read(0);
            
            duti = 0xCC;
            PWM1_Set_Duty(duti);
            
            automatico = 'b';
            
            RB0_bit = 1;
            RB5_bit = 1;

            if(leitura1 > 97)
            {   Delay_ms(10);
                RB0_bit = 0;
                RB5_bit = 0;
                Delay_ms(100);
                RB1_bit = 1;
                RB6_bit = 1;
                Delay_ms(500);
                RB1_bit = 0;
                RB6_bit = 0;
                
                if(direcao)
                {
                   RB0_bit = 1;
                   RB6_bit = 1;
                   Delay_ms(1200);
                   RB0_bit = 0;
                   RB6_bit = 0;
                   direcao = !direcao;
                }else
                {
                   RB1_bit = 1;
                   RB5_bit = 1;
                   Delay_ms(1200);
                   RB1_bit = 0;
                   RB5_bit = 0;
                   direcao = !direcao;
                }

            }
            duti = 0xFF;
        }
    }                                  //Loop Infinito

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