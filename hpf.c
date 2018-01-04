// DAC module connections
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
// End DAC module connections

unsigned int value;

void InitMain() {
  TRISA0_bit = 1;                        // Set RA0 pin as input
  TRISA1_bit = 1;                        // Set RA1 pin as input
  Chip_Select = 1;                       // Deselect DAC
  Chip_Select_Direction = 0;             // Set CS# pin as Output
  SPI1_Init();                           // Initialize SPI module
}

// DAC increments (0..4095) --> output voltage (0..Vref)
void DAC_Output(unsigned int valueDAC) {
  char temp;

  Chip_Select = 0;                       // Select DAC chip

  // Send High Byte
  temp = (valueDAC >> 8) & 0x0F;         // Store valueDAC[11..8] to temp[3..0]
  temp |= 0x30;                          // Define DAC setting, see MCP4921 datasheet
  SPI1_Write(temp);                      // Send high byte via SPI

  // Send Low Byte
  temp = valueDAC;                       // Store valueDAC[7..0] to temp[7..0]
  SPI1_Write(temp);                      // Send low byte via SPI

  Chip_Select = 1;                       // Deselect DAC chip
}

void main() {
int s=0;
double i;
double y0=0;
double y1=0;

double x0=0;
double x1=0;

ADC_Init();



  TRISC  = 0;
  TRISB  = 0;

 for(i=0;i<1000;i=i+0.00005){
    x0 =(double) ADC_Read(2);
    y0=0.96907*y1-628.3185307*x0;


    y1=y0;


                                             //   the output in the mid-range
    InitMain();

    DAC_Output(x0);
                 // Send value to DAC chip
  //  Delay_us(50);
    }                       // Slow down key repeat pace

}