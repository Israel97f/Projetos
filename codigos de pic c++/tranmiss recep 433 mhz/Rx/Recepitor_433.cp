#line 1 "C:/Users/Israel/Documents/codigos de pic c++/tranmiss recep 433 mhz/Rx/Recepitor_433.c"
#line 20 "C:/Users/Israel/Documents/codigos de pic c++/tranmiss recep 433 mhz/Rx/Recepitor_433.c"
void rx_func(char *cmd, char *val, char *ok);




char start, cnt;
char comand, value, check;
char automatico;
char direcao;
unsigned short duti = 0xFF;
long int leitura1;


void interrupt()
{
 rx_func(&comand, &value, &check);

 if(check)
 {

 if(comand == 'A')
 {
 RB0_bit = value;
 RB5_bit = value;
 }

 if(comand == 'B')
 {
 RB1_bit = value;
 RB6_bit = value;
 }

 if(comand == 'C')
 {
 RB0_bit = value;
 RB6_bit = value;
 }

 if(comand == 'D')
 {
 RB5_bit = value;
 RB1_bit = value;
 }

 if(comand == 'E')
 {
 automatico = 'e';
 }

 }

}




void main()
{
 CMCON = 0x07;
 TRISB = 0x9C;
 PORTB = 0x9C;

 TRISC = 0x80;
 PORTC = 0x00;

 adcon0 = 0x01;

 RCIE_bit = 0x01;
 GIE_bit = 0x01;
 PEIE_Bit = 0x01;

 UART1_Init(1200);
 delay_ms(100);

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
 { Delay_ms(10);
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
 }

}








void rx_func(char *cmd, char *val, char *ok)
{
 char buffer;
 char checksum;
 *ok = 0;

 if(RCIF_bit)
 {
 RCIF_bit = 0x00;

 buffer = Uart1_Read();

 if(start)
 {
 cnt++;

 if(cnt == 1) *cmd = buffer;

 if(cnt == 2) *val = buffer;

 if(cnt == 3)
 {
 checksum = buffer;
 start = 0x00;

 if(checksum == ~(char)(*cmd + *val)) *ok = 1;

 }

 }

 else
 {
 if(buffer == 0xFF)
 {
 start = 0x01;
 cnt = 0x00;

 }

 }

 }

}
