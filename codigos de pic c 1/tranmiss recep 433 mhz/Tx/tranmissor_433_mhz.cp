#line 1 "C:/Users/Israel/Documents/codigos de pic c++/tranmiss recep 433 mhz/Tx/tranmissor_433_mhz.c"
#line 20 "C:/Users/Israel/Documents/codigos de pic c++/tranmiss recep 433 mhz/Tx/tranmissor_433_mhz.c"
void tx_func(char comand, char value);





const times = 5;



void main()
{

 TRISB = 0xFB;
 UART1_Init (1200);
 delay_ms(100);


 while(1)
 {
 if(!RB0_bit) tx_func('A',1);

 if(!RB3_bit) tx_func('B',1);

 if(!RB5_bit) tx_func('C',1);

 if(!RB6_bit) tx_func('D',1);

 if(!RB4_bit) tx_func('E',1);


 if(RB0_bit & RB3_bit & RB5_bit & RB6_bit & RB4_bit)
 {
 tx_func('A',0);
 tx_func('B',0);
 tx_func('C',0);
 tx_func('D',0);
 }


 }

}








void tx_func(char comand, char value)
{

 UART1_Write(0xFF);
 delay_ms(times);
 UART1_Write(comand);
 delay_ms(times);
 UART1_Write(value);
 delay_ms(times);
 UART1_Write(~(char)(comand+value));
 delay_ms(times);


}
