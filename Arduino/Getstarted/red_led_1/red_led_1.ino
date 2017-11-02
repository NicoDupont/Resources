// Le 27/12/2016
// Création : Nicolas DUPONT (contact me : nicolas.dupont@outlook.com)
// Faire clignoter une led rouge
// on vient modifier l'état de la led toute les 2 secondes.
// définition de la broche 2 de la carte en tant que variable
const int red_led = 2;

// fonction d'initialisation de la carte
void setup()
{
    // initialisation de la broche 2 comme étant une sortie
    pinMode(red_led, OUTPUT);
}

// fonction principale, elle se répète (s’exécute) à l'infini
void loop()
{
    // écriture en sortie (broche 2) d'un état BAS
    digitalWrite(red_led, LOW);
    // on fait une pause du programme pendant 2000ms, soit 2 secondes
    delay(2000);
    // écriture en sortie (broche 2) d'un état HAUT
    digitalWrite(red_led, HIGH);
    // on fait une pause du programme pendant 2000ms, soit 2 secondes
    delay(2000);
}
