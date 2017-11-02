/*
 * ------------------------------------
 * Created :       17/10/2017  (fr)
 * Last update :   17/10/2017  (fr)
 * Author(s) : Nicolas Dupont
 * Contributor(s) :
 * Arduino : Uno
 * Arduino 1.8.4 (Ubuntu 16.04.3)
 *-------------------------------------
*/

const int L1 = 2;

void setup() {

  pinMode(L1, OUTPUT);

}

void loop() {

   digitalWrite(L1, !digitalRead(L1));
   delay(1500);

}
