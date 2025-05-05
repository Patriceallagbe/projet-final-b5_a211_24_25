// === LCD PORTB : RS=RB4, EN=RB5, D4-D7 = RB0 à RB3 ===
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

unsigned int temp_raw, seuil_raw, pwm_val;
float temp_deg, seuil_deg;
char txt[16];

unsigned int seuil_saved;
bit EEPROM_Used;
bit flag_rb6;

void main() {
  ANSELA = 0x03;    // RA0 et RA1 analogiques
  ANSELB = 0x00;    // PORTB digital
  TRISA = 0xFF;     // Entrées
  TRISB = 0xFF;     // RB6 = bouton en entrée
  TRISC = 0b11000000;  // RC6/RC7 UART, RC2 PWM sortie
  TRISD = 0x00;     // non utilisé ici

  flag_rb6 = 0;
  EEPROM_Used = 0;

  UART1_Init(57600);
  Delay_ms(100);

  Lcd_Init();
  Delay_ms(50);
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);

  PWM1_Init(5000);
  PWM1_Start();
  PWM1_Set_Duty(0);

  while (1) {
    temp_raw = ADC_Read(0);   // RA0 : température
    seuil_raw = ADC_Read(1);  // RA1 : seuil

    temp_deg = (float)temp_raw * 60.0 / 1023.0;
    seuil_deg = ((float)seuil_raw * 19.0 / 1023.0) + 1;

    if (temp_deg > seuil_deg) {
      pwm_val = (temp_deg - seuil_deg) * 10;
      if (pwm_val > 255) pwm_val = 255;
    } else {
      pwm_val = 0;
    }

    PWM1_Set_Duty(pwm_val);

    // Affichage LCD
    Lcd_Out(1, 1, "T:");
    FloatToStr(temp_deg, txt); Lcd_Out(1, 3, txt);
    Lcd_Out(1, 11, "D:");
    FloatToStr(seuil_deg, txt); Lcd_Out(1, 13, txt);
    Lcd_Out(2, 1, "PWM:");
    IntToStr(pwm_val, txt); Lcd_Out(2, 6, txt);
    if (temp_deg > seuil_deg) Lcd_Out(2, 12, " ON");
    else Lcd_Out(2, 12, "OFF");

    // RB6 = Sauvegarde SEUIL
    if (PORTB.F6 == 1 && flag_rb6 == 0) {
      flag_rb6 = 1;
      seuil_saved = seuil_raw;
      EEPROM_Write(0x00, seuil_saved >> 8);
      EEPROM_Write(0x01, seuil_saved & 0xFF);
      UART1_Write_Text(">> SEUIL SAUVEGARDE = ");
      WordToStr(seuil_saved, txt);
      UART1_Write_Text(txt);
      UART1_Write(13); UART1_Write(10);
    }
    if (PORTB.F6 == 0) {
      flag_rb6 = 0;
    }

    Delay_ms(300);
  }
}
