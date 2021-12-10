#line 1 "C:/Users/Israel/Documents/codigos de pic c++/pic16f877a/MyProject.c"
void main()
{

 TRISB = 0x00;
 PORTB = 0x00;


 while(1)
 {
 PORTB = 0x20;
 delay_ms(200);
 PORTB = 0x00;
 delay_ms(200);

 }
}
