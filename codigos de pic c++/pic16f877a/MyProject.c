void main()
{

   TRISB = 0x00;     // SETA AS PORTAS B COMO SAIDAS
   PORTB = 0x00;       // INICIA AS POETAS EM LOW


   while(1)
   {
      PORTB = 0x20;
      delay_ms(200);
      PORTB = 0x00;
      delay_ms(200);
   
   }
}