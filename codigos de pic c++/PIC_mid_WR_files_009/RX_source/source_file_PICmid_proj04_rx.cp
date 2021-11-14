#line 1 "C:/You Tube - Meu Canal/ZZZ_Séries_Patrocinadas/Projetos Aplicados com PIC Mid-Range/PIC_MidRange_011__Controle_de_Portão_Codificado__p3/PIC_mid_WR_files_011/RX_source/source_file_PICmid_proj04_rx.c"
#line 20 "C:/You Tube - Meu Canal/ZZZ_Séries_Patrocinadas/Projetos Aplicados com PIC Mid-Range/PIC_MidRange_011__Controle_de_Portão_Codificado__p3/PIC_mid_WR_files_011/RX_source/source_file_PICmid_proj04_rx.c"
void rx_func(char *cmd, char *val, char *ok);




char start, cnt;
char comand, value, check;




void interrupt()
{
 rx_func(&comand, &value, &check);

 if(check)
 {

 if(comand == 'A') RB0_bit = value;

 if(comand == 'B') RB5_bit = value;


 }

}




void main()
{
 CMCON = 0x07;
 TRISB = 0xDE;
 PORTB = 0xDE;

 RCIE_bit = 0x01;
 GIE_bit = 0x01;
 PEIE_Bit = 0x01;

 UART1_Init(1200);
 delay_ms(100);



 while(1);

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
