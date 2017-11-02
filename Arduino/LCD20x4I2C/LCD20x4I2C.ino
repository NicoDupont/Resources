

// Library for LCD and I2C
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>


// Setup LCD I2C
LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display
//LiquidCrystal_I2C lcd(0x3F,20,4);

void setup()
{
 lcd.init(); // initialisation de l'afficheur
}
void loop()
{
 lcd.backlight();
 // Envoi du message
 lcd.setCursor(0, 0);
 lcd.print(" Go Tronic");
 lcd.setCursor(0,1);
 lcd.print(" test");
 lcd.setCursor(0, 2);
 lcd.print(" I2C Serial");
 lcd.setCursor(0, 3);
 lcd.print(" LCD");
}
