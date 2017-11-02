// Le 27/12/2016
// Nicolas DUPONT (contact me : nicolas.dupont@outlook.com)
// Just output on serial the temperature mesured with a simple lm35 temperature sensor and turn on the correct led because of the temperature

// définition de la broche 2 de la carte en tant que variable (constante) pour la led rouge
const int red_led = 2;
// définition de la broche 3 de la carte en tant que variable (constante) pour la led bleue
const int blue_led = 3;
// définition de la broche 4 de la carte en tant que variable (constante) pour la led verte
const int green_led = 4;

float temperature_celcius;
int valeur_brute;

void setup() {

  //initialisation de la sortie serie de la carte
  Serial.begin(9600);
  // Améliore la précision de la mesure en réduisant la plage de mesure
  //analogReference(INTERNAL); // Pour Arduino UNO => mesure incorrecte quand activé?
  // analogReference(INTERNAL1V1); // Pour Arduino Mega2560

  // initialisation de la broche 2 comme étant une sortie
  pinMode(red_led, OUTPUT);
  // initialisation de la broche 3 comme étant une sortie
  pinMode(blue_led, OUTPUT);
  // initialisation de la broche 4 comme étant une sortie
  pinMode(green_led, OUTPUT);

  // on éteind les 3 leds
  digitalWrite(red_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
  digitalWrite(blue_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
  digitalWrite(green_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT

}

void loop() {
  
  valeur_brute = analogRead(A0);
  temperature_celcius = valeur_brute * (5.0 / 1023.0 * 100.0);
  Serial.println(temperature_celcius);

  //gestion des 3 leds
  // si inférieur à 20, on allume la led verte uniquement
  // si entre 20 et 25, on allume la bleue uniquement
  // si > 25, on affiche la rouge uniquement
  if ( temperature_celcius<20 )
  {
    digitalWrite(red_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
    digitalWrite(blue_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
    digitalWrite(green_led, LOW);  // écriture en sortie (broche 2) d'un état BAS
  }
  else if( temperature_celcius>20 and temperature_celcius<=25 ) 
  {
    digitalWrite(red_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
    digitalWrite(blue_led, LOW);  // écriture en sortie (broche 2) d'un état BAS
    digitalWrite(green_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
  }
  else 
  {
    digitalWrite(red_led, LOW);  // écriture en sortie (broche 2) d'un état BAS
    digitalWrite(blue_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
    digitalWrite(green_led, HIGH);  // écriture en sortie (broche 2) d'un état HAUT
  }
  //attendre 2 secondes
  delay(2000);
}
