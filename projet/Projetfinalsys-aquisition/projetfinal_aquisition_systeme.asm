
_main:

;projetfinal_aquisition_systeme.c,24 :: 		void main() {
;projetfinal_aquisition_systeme.c,25 :: 		ANSELA = 0x03;    // RA0 et RA1 analogiques
	MOVLW       3
	MOVWF       ANSELA+0 
;projetfinal_aquisition_systeme.c,26 :: 		ANSELB = 0x00;    // PORTB digital
	CLRF        ANSELB+0 
;projetfinal_aquisition_systeme.c,27 :: 		TRISA = 0xFF;     // Entrées
	MOVLW       255
	MOVWF       TRISA+0 
;projetfinal_aquisition_systeme.c,28 :: 		TRISB = 0xFF;     // RB6 = bouton en entrée
	MOVLW       255
	MOVWF       TRISB+0 
;projetfinal_aquisition_systeme.c,29 :: 		TRISC = 0b11000000;  // RC6/RC7 UART, RC2 PWM sortie
	MOVLW       192
	MOVWF       TRISC+0 
;projetfinal_aquisition_systeme.c,30 :: 		TRISD = 0x00;     // non utilisé ici
	CLRF        TRISD+0 
;projetfinal_aquisition_systeme.c,32 :: 		flag_rb6 = 0;
	BCF         _flag_rb6+0, BitPos(_flag_rb6+0) 
;projetfinal_aquisition_systeme.c,33 :: 		EEPROM_Used = 0;
	BCF         _EEPROM_Used+0, BitPos(_EEPROM_Used+0) 
;projetfinal_aquisition_systeme.c,35 :: 		UART1_Init(57600);
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       34
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;projetfinal_aquisition_systeme.c,36 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
	NOP
;projetfinal_aquisition_systeme.c,38 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;projetfinal_aquisition_systeme.c,39 :: 		Delay_ms(50);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	NOP
	NOP
;projetfinal_aquisition_systeme.c,40 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;projetfinal_aquisition_systeme.c,41 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;projetfinal_aquisition_systeme.c,43 :: 		PWM1_Init(5000);
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       99
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;projetfinal_aquisition_systeme.c,44 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;projetfinal_aquisition_systeme.c,45 :: 		PWM1_Set_Duty(0);
	CLRF        FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;projetfinal_aquisition_systeme.c,47 :: 		while (1) {
L_main2:
;projetfinal_aquisition_systeme.c,48 :: 		temp_raw = ADC_Read(0);   // RA0 : température
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temp_raw+0 
	MOVF        R1, 0 
	MOVWF       _temp_raw+1 
;projetfinal_aquisition_systeme.c,49 :: 		seuil_raw = ADC_Read(1);  // RA1 : seuil
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+4 
	MOVF        R1, 0 
	MOVWF       FLOC__main+5 
	MOVF        FLOC__main+4, 0 
	MOVWF       _seuil_raw+0 
	MOVF        FLOC__main+5, 0 
	MOVWF       _seuil_raw+1 
;projetfinal_aquisition_systeme.c,51 :: 		temp_deg = (float)temp_raw * 60.0 / 1023.0;
	MOVF        _temp_raw+0, 0 
	MOVWF       R0 
	MOVF        _temp_raw+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       112
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVF        FLOC__main+0, 0 
	MOVWF       _temp_deg+0 
	MOVF        FLOC__main+1, 0 
	MOVWF       _temp_deg+1 
	MOVF        FLOC__main+2, 0 
	MOVWF       _temp_deg+2 
	MOVF        FLOC__main+3, 0 
	MOVWF       _temp_deg+3 
;projetfinal_aquisition_systeme.c,52 :: 		seuil_deg = ((float)seuil_raw * 19.0 / 1023.0) + 1;
	MOVF        FLOC__main+4, 0 
	MOVWF       R0 
	MOVF        FLOC__main+5, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       24
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _seuil_deg+0 
	MOVF        R1, 0 
	MOVWF       _seuil_deg+1 
	MOVF        R2, 0 
	MOVWF       _seuil_deg+2 
	MOVF        R3, 0 
	MOVWF       _seuil_deg+3 
;projetfinal_aquisition_systeme.c,54 :: 		if (temp_deg > seuil_deg) {
	MOVF        FLOC__main+0, 0 
	MOVWF       R4 
	MOVF        FLOC__main+1, 0 
	MOVWF       R5 
	MOVF        FLOC__main+2, 0 
	MOVWF       R6 
	MOVF        FLOC__main+3, 0 
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;projetfinal_aquisition_systeme.c,55 :: 		pwm_val = (temp_deg - seuil_deg) * 10;
	MOVF        _seuil_deg+0, 0 
	MOVWF       R4 
	MOVF        _seuil_deg+1, 0 
	MOVWF       R5 
	MOVF        _seuil_deg+2, 0 
	MOVWF       R6 
	MOVF        _seuil_deg+3, 0 
	MOVWF       R7 
	MOVF        _temp_deg+0, 0 
	MOVWF       R0 
	MOVF        _temp_deg+1, 0 
	MOVWF       R1 
	MOVF        _temp_deg+2, 0 
	MOVWF       R2 
	MOVF        _temp_deg+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       _pwm_val+0 
	MOVF        R1, 0 
	MOVWF       _pwm_val+1 
;projetfinal_aquisition_systeme.c,56 :: 		if (pwm_val > 255) pwm_val = 255;
	MOVLW       0
	MOVWF       R2 
	MOVF        R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main16
	MOVF        R0, 0 
	SUBLW       255
L__main16:
	BTFSC       STATUS+0, 0 
	GOTO        L_main5
	MOVLW       255
	MOVWF       _pwm_val+0 
	MOVLW       0
	MOVWF       _pwm_val+1 
L_main5:
;projetfinal_aquisition_systeme.c,57 :: 		} else {
	GOTO        L_main6
L_main4:
;projetfinal_aquisition_systeme.c,58 :: 		pwm_val = 0;
	CLRF        _pwm_val+0 
	CLRF        _pwm_val+1 
;projetfinal_aquisition_systeme.c,59 :: 		}
L_main6:
;projetfinal_aquisition_systeme.c,61 :: 		PWM1_Set_Duty(pwm_val);
	MOVF        _pwm_val+0, 0 
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;projetfinal_aquisition_systeme.c,64 :: 		Lcd_Out(1, 1, "T:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_projetfinal_aquisition_systeme+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_projetfinal_aquisition_systeme+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;projetfinal_aquisition_systeme.c,65 :: 		FloatToStr(temp_deg, txt); Lcd_Out(1, 3, txt);
	MOVF        _temp_deg+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _temp_deg+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _temp_deg+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _temp_deg+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;projetfinal_aquisition_systeme.c,66 :: 		Lcd_Out(1, 11, "D:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_projetfinal_aquisition_systeme+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_projetfinal_aquisition_systeme+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;projetfinal_aquisition_systeme.c,67 :: 		FloatToStr(seuil_deg, txt); Lcd_Out(1, 13, txt);
	MOVF        _seuil_deg+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _seuil_deg+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _seuil_deg+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _seuil_deg+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;projetfinal_aquisition_systeme.c,68 :: 		Lcd_Out(2, 1, "PWM:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_projetfinal_aquisition_systeme+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_projetfinal_aquisition_systeme+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;projetfinal_aquisition_systeme.c,69 :: 		IntToStr(pwm_val, txt); Lcd_Out(2, 6, txt);
	MOVF        _pwm_val+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pwm_val+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _txt+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;projetfinal_aquisition_systeme.c,70 :: 		if (temp_deg > seuil_deg) Lcd_Out(2, 12, " ON");
	MOVF        _temp_deg+0, 0 
	MOVWF       R4 
	MOVF        _temp_deg+1, 0 
	MOVWF       R5 
	MOVF        _temp_deg+2, 0 
	MOVWF       R6 
	MOVF        _temp_deg+3, 0 
	MOVWF       R7 
	MOVF        _seuil_deg+0, 0 
	MOVWF       R0 
	MOVF        _seuil_deg+1, 0 
	MOVWF       R1 
	MOVF        _seuil_deg+2, 0 
	MOVWF       R2 
	MOVF        _seuil_deg+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_projetfinal_aquisition_systeme+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_projetfinal_aquisition_systeme+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
	GOTO        L_main8
L_main7:
;projetfinal_aquisition_systeme.c,71 :: 		else Lcd_Out(2, 12, "OFF");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_projetfinal_aquisition_systeme+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_projetfinal_aquisition_systeme+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
L_main8:
;projetfinal_aquisition_systeme.c,74 :: 		if (PORTB.F6 == 1 && flag_rb6 == 0) {
	BTFSS       PORTB+0, 6 
	GOTO        L_main11
	BTFSC       _flag_rb6+0, BitPos(_flag_rb6+0) 
	GOTO        L_main11
L__main14:
;projetfinal_aquisition_systeme.c,75 :: 		flag_rb6 = 1;
	BSF         _flag_rb6+0, BitPos(_flag_rb6+0) 
;projetfinal_aquisition_systeme.c,76 :: 		seuil_saved = seuil_raw;
	MOVF        _seuil_raw+0, 0 
	MOVWF       _seuil_saved+0 
	MOVF        _seuil_raw+1, 0 
	MOVWF       _seuil_saved+1 
;projetfinal_aquisition_systeme.c,77 :: 		EEPROM_Write(0x00, seuil_saved >> 8);
	CLRF        FARG_EEPROM_Write_address+0 
	MOVF        _seuil_raw+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;projetfinal_aquisition_systeme.c,78 :: 		EEPROM_Write(0x01, seuil_saved & 0xFF);
	MOVLW       1
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVLW       255
	ANDWF       _seuil_saved+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;projetfinal_aquisition_systeme.c,79 :: 		UART1_Write_Text(">> SEUIL SAUVEGARDE = ");
	MOVLW       ?lstr6_projetfinal_aquisition_systeme+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_projetfinal_aquisition_systeme+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;projetfinal_aquisition_systeme.c,80 :: 		WordToStr(seuil_saved, txt);
	MOVF        _seuil_saved+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _seuil_saved+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _txt+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;projetfinal_aquisition_systeme.c,81 :: 		UART1_Write_Text(txt);
	MOVLW       _txt+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;projetfinal_aquisition_systeme.c,82 :: 		UART1_Write(13); UART1_Write(10);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;projetfinal_aquisition_systeme.c,83 :: 		}
L_main11:
;projetfinal_aquisition_systeme.c,84 :: 		if (PORTB.F6 == 0) {
	BTFSC       PORTB+0, 6 
	GOTO        L_main12
;projetfinal_aquisition_systeme.c,85 :: 		flag_rb6 = 0;
	BCF         _flag_rb6+0, BitPos(_flag_rb6+0) 
;projetfinal_aquisition_systeme.c,86 :: 		}
L_main12:
;projetfinal_aquisition_systeme.c,88 :: 		Delay_ms(300);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_main13:
	DECFSZ      R13, 1, 1
	BRA         L_main13
	DECFSZ      R12, 1, 1
	BRA         L_main13
	DECFSZ      R11, 1, 1
	BRA         L_main13
	NOP
	NOP
;projetfinal_aquisition_systeme.c,89 :: 		}
	GOTO        L_main2
;projetfinal_aquisition_systeme.c,90 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
