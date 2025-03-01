#line 1 "C:/You Tube - Meu Canal/ZZZ_Séries_Patrocinadas/Projetos Aplicados com PIC Mid-Range/PIC_MidRange_011__Controle_de_Portão_Codificado__p3/PIC_mid_WR_files_011/TX_source/source_file_PICmid_proj04_tx.c"





void tx_func(char comand, char value);




void main()
{

 TRISB = 0xFD;
 UART1_Init(1200);
 delay_ms(100);


 while(1)
 {
 if(!RB0_bit) tx_func('A',1);
 else tx_func('A',0);

 if(!RB1_bit) tx_func('B',1);
 else tx_func('B',0);


 }

}








void tx_func(char comand, char value)
{

 UART1_Write(0xFF);
 delay_ms(10);
 UART1_Write(comand);
 delay_ms(10);
 UART1_Write(value);
 delay_ms(10);
 UART1_Write(~(char)(comand+value));
 delay_ms(10);


}
