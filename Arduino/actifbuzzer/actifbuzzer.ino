const char BUZ = 2; // pin 2 digital
boolean buzzer=0;

void setup() {

}

void loop() {
  // put your main code here, to run repeatedly:
 if(buzzer==1){
    tone(BUZ,500,1000);
  }
 buzzer= !buzzer;
 delay(2500);
}
