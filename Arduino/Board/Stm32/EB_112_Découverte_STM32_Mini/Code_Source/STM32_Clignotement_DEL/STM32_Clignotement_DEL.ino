/*
   _===_ _           _                  ______ _     _             _ _ _
  |  ___| |         | |                 | ___ (_)   | |           (_) | |
  | |__ | | ___  ___| |_ _ __ ___ ______| |_/ /_  __| | ___  _   _ _| | | ___ _   _ _ __
  |  __|| |/ _ \/ __| __| '__/ _ \______| ___ \ |/ _` |/ _ \| | | | | | |/ _ \ | | | '__|
  | |___| |  __/ (__| |_| | | (_) |     | |_/ / | (_| | (_) | |_| | | | |  __/ |_| | |
  \____/|_|\___|\___|\__|_|  \___/      \____/|_|\__,_|\___/ \__,_|_|_|_|\___|\__,_|_|


  Bidouilleur Blink STM32 Mini
  Électro-Bidouilleur, Octobre 2016
*/  

//------------------------------------------------------------------------------
  // Définitions au compilateur
  
#define pinLED PC13

//------------------------------------------------------------------------------
  // Routine d'initialisation appelée au départ
  
void setup() {
  Serial.begin(9600);
  pinMode(pinLED, OUTPUT);
  Serial.println("START");  
}

//------------------------------------------------------------------------------
  // Boucle d'exécution appelée après l'initialisation.
  
void loop() {
  digitalWrite(pinLED, HIGH);
  delay(1000);
  digitalWrite(pinLED, LOW);
  delay(1000);
  Serial.println("Electro-Bidouilleur a un accent chouette !");  
}

