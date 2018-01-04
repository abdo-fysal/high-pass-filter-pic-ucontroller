#line 1 "C:/Users/aboda/Desktop/New folder (13)/New folder (12)/hpf.c"

sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;


unsigned int value;

void InitMain() {
 TRISA0_bit = 1;
 TRISA1_bit = 1;
 Chip_Select = 1;
 Chip_Select_Direction = 0;
 SPI1_Init();
}


void DAC_Output(unsigned int valueDAC) {
 char temp;

 Chip_Select = 0;


 temp = (valueDAC >> 8) & 0x0F;
 temp |= 0x30;
 SPI1_Write(temp);


 temp = valueDAC;
 SPI1_Write(temp);

 Chip_Select = 1;
}

void main() {
int s=0;
double i;
double y0=0;
double y1=0;

double x0=0;
double x1=0;

ADC_Init();



 TRISC = 0;
 TRISB = 0;

 for(i=0;i<1000;i=i+0.00005){
 x0 =(double) ADC_Read(2);
 y0=0.96907*y1-628.3185307*x0;


 y1=y0;



 InitMain();

 DAC_Output(x0);


 }

}
