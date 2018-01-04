
_InitMain:

;hpf.c,8 :: 		void InitMain() {
;hpf.c,9 :: 		TRISA0_bit = 1;                        // Set RA0 pin as input
	BSF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;hpf.c,10 :: 		TRISA1_bit = 1;                        // Set RA1 pin as input
	BSF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
;hpf.c,11 :: 		Chip_Select = 1;                       // Deselect DAC
	BSF        RC0_bit+0, BitPos(RC0_bit+0)
;hpf.c,12 :: 		Chip_Select_Direction = 0;             // Set CS# pin as Output
	BCF        TRISC0_bit+0, BitPos(TRISC0_bit+0)
;hpf.c,13 :: 		SPI1_Init();                           // Initialize SPI module
	CALL       _SPI1_Init+0
;hpf.c,14 :: 		}
L_end_InitMain:
	RETURN
; end of _InitMain

_DAC_Output:

;hpf.c,17 :: 		void DAC_Output(unsigned int valueDAC) {
;hpf.c,20 :: 		Chip_Select = 0;                       // Select DAC chip
	BCF        RC0_bit+0, BitPos(RC0_bit+0)
;hpf.c,23 :: 		temp = (valueDAC >> 8) & 0x0F;         // Store valueDAC[11..8] to temp[3..0]
	MOVF       FARG_DAC_Output_valueDAC+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVLW      15
	ANDWF      R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
;hpf.c,24 :: 		temp |= 0x30;                          // Define DAC setting, see MCP4921 datasheet
	MOVLW      48
	IORWF      FARG_SPI1_Write_data_+0, 1
;hpf.c,25 :: 		SPI1_Write(temp);                      // Send high byte via SPI
	CALL       _SPI1_Write+0
;hpf.c,29 :: 		SPI1_Write(temp);                      // Send low byte via SPI
	MOVF       FARG_DAC_Output_valueDAC+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;hpf.c,31 :: 		Chip_Select = 1;                       // Deselect DAC chip
	BSF        RC0_bit+0, BitPos(RC0_bit+0)
;hpf.c,32 :: 		}
L_end_DAC_Output:
	RETURN
; end of _DAC_Output

_main:

;hpf.c,34 :: 		void main() {
;hpf.c,35 :: 		int s=0;
;hpf.c,37 :: 		double y0=0;
;hpf.c,38 :: 		double y1=0;
;hpf.c,40 :: 		double x0=0;
	CLRF       main_x0_L0+0
	CLRF       main_x0_L0+1
	CLRF       main_x0_L0+2
	CLRF       main_x0_L0+3
;hpf.c,43 :: 		ADC_Init();
	CALL       _ADC_Init+0
;hpf.c,47 :: 		TRISC  = 0;
	CLRF       TRISC+0
;hpf.c,48 :: 		TRISB  = 0;
	CLRF       TRISB+0
;hpf.c,50 :: 		for(i=0;i<1000;i=i+0.00005){
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
	CLRF       main_i_L0+2
	CLRF       main_i_L0+3
L_main0:
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	MOVF       main_i_L0+0, 0
	MOVWF      R0+0
	MOVF       main_i_L0+1, 0
	MOVWF      R0+1
	MOVF       main_i_L0+2, 0
	MOVWF      R0+2
	MOVF       main_i_L0+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main1
;hpf.c,51 :: 		x0 =(double) ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      main_x0_L0+0
	MOVF       R0+1, 0
	MOVWF      main_x0_L0+1
	MOVF       R0+2, 0
	MOVWF      main_x0_L0+2
	MOVF       R0+3, 0
	MOVWF      main_x0_L0+3
;hpf.c,59 :: 		InitMain();
	CALL       _InitMain+0
;hpf.c,61 :: 		DAC_Output(x0);
	MOVF       main_x0_L0+0, 0
	MOVWF      R0+0
	MOVF       main_x0_L0+1, 0
	MOVWF      R0+1
	MOVF       main_x0_L0+2, 0
	MOVWF      R0+2
	MOVF       main_x0_L0+3, 0
	MOVWF      R0+3
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      FARG_DAC_Output_valueDAC+0
	MOVF       R0+1, 0
	MOVWF      FARG_DAC_Output_valueDAC+1
	CALL       _DAC_Output+0
;hpf.c,50 :: 		for(i=0;i<1000;i=i+0.00005){
	MOVF       main_i_L0+0, 0
	MOVWF      R0+0
	MOVF       main_i_L0+1, 0
	MOVWF      R0+1
	MOVF       main_i_L0+2, 0
	MOVWF      R0+2
	MOVF       main_i_L0+3, 0
	MOVWF      R0+3
	MOVLW      23
	MOVWF      R4+0
	MOVLW      183
	MOVWF      R4+1
	MOVLW      81
	MOVWF      R4+2
	MOVLW      112
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_i_L0+0
	MOVF       R0+1, 0
	MOVWF      main_i_L0+1
	MOVF       R0+2, 0
	MOVWF      main_i_L0+2
	MOVF       R0+3, 0
	MOVWF      main_i_L0+3
;hpf.c,64 :: 		}                       // Slow down key repeat pace
	GOTO       L_main0
L_main1:
;hpf.c,66 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
