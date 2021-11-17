#line 1 "C:/Users/Israel/Documents/MeuPc/Projetos/Autonomo/modulo16f628.c"



int Converter(int n1, int n2, int n3);

void main() {
 int date = 0;
 CMCON = 7;
 TRISA = 0b00010000;
 TRISB = 0b10000001;
 PORTA = 0;
 PORTB = 0;


 while(1){

 date = Converter( RB7_bit ,  RB0_bit ,  RA4_bit );
 if (date == 1){
 PORTA = 0xA;
 PORTB = 0x28;
 }
 else if(date == 2){
 PORTA = 0;
 PORTB = 0;
 }
 else if(date == 3){
 PORTA = 0x5;
 PORTB = 0x50;
 }
 else if(date == 4){
 PORTA = 0x5;
 PORTB = 0x28;
 }
 else if(date == 5){
 PORTA = 0xA;
 PORTB = 0x50;
 }

 delay_ms(100);
 }

}
int Converter(int n1, int n2, int n3){
 int valor = 0;
 if (n1 == 1){
 valor = valor + 4;
 }
 if (n2 == 1){
 valor = valor + 2;
 }
 if (n3 == 1){
 valor = valor + 1;
 }
 return(valor);
}
