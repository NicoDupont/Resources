// Le 27/12/2016
// Nicolas DUPONT (contact me : nicolas.dupont@outlook.com)
// Simuler un feu de croisement // simulate a traffic lights
// on vient modifier des leds toutes les 5 secondes et le orange seulement 1 seconde 
// All 5 seconds, the state of the red or green led is modified with a transition for the orange led during 1 second
// version 2 : simple amélioration

// définition de la broche 2 de la carte en tant que variable (constante) pour le feu rouge
const int red_led = 2;
// définition de la broche 3 de la carte en tant que variable (constante) pour le feu orange
const int orange_led = 3;
// définition de la broche 4 de la carte en tant que variable (constante) pour le feu vert
const int green_led = 4;



// fonction d'initialisation de la carte
void setup()
{
    // initialisation de la broche 2 comme étant une sortie
    pinMode(red_led, OUTPUT);
    // initialisation de la broche 3 comme étant une sortie
    pinMode(orange_led, OUTPUT);
    // initialisation de la broche 4 comme étant une sortie
    pinMode(green_led, OUTPUT);

}

// fonction principale, elle se répète (s’exécute) à l'infini
void loop()
{
    // feu rouge
    digitalWrite(red_led, LOW);  // écriture en sortie (broche 3) d'un état HAUT
    digitalWrite(orange_led, HIGH);  // écriture en sortie (broche 3) d'un état HAUT
    digitalWrite(green_led, HIGH);   // écriture en sortie (broche 4) d'un état HAUT
    // on fait une pause du programme pendant 5000ms, soit 5 secondes
    delay(5000);
     // feu orange (transition rouge => vert)
    digitalWrite(red_led, HIGH);    // écriture en sortie (broche 2) d'un état HAUT
    digitalWrite(orange_led, LOW);  // écriture en sortie (broche 3) d'un état BAS
    // on fait une pause du programme pendant 1000ms, soit 1 secondes
    delay(1000);
    // feu vert
    digitalWrite(orange_led, HIGH);  // écriture en sortie (broche 3) d'un état HAUT
    digitalWrite(green_led, LOW);   // écriture en sortie (broche 4) d'un état BAS
    // on fait une pause du programme pendant 5000ms, soit 5 secondes
    delay(5000);
     // feu orange (transition vert => rouge)
    digitalWrite(orange_led, LOW);  // écriture en sortie (broche 3) d'un état BAS
    digitalWrite(green_led, HIGH);   // écriture en sortie (broche 4) d'un état HAUT
    // on fait une pause du programme pendant 1000ms, soit 1 secondes
    delay(1000);
}
