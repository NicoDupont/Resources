Créé le : 22/01/2017  
Dernière maj : 22/01/2017  
Auteur : Nicolas DUPONT   
Contact :   
Lien Github :    

# STM32 micro controlleur
---
### Différents liens :
 - [Électro-Bidouilleur STM32 Youtube](https://www.youtube.com/watch?v=yJ4LGhuMXgc)
 - [Arduino goes STM32](http://grauonline.de/wordpress/?page_id=1004)
 - [Github files Librairies Arduino ide](https://github.com/rogerclarkmelbourne/Arduino_STM32)
 - [Flash stm32 si bloqué](http://www.stm32duino.com/viewtopic.php?f=20&t=747)
 - [STM32 Forum](http://www.stm32duino.com/index.php)

---
### Sommaire :

1. Installation dans l'a
3. Blink led 13 Électro-Bidouilleur
2. Démos Interfaces (SPI, I2C)
---
## 1) Installation :

You can develop for STM32 using the Arduino IDE. Here are the steps:

What you need:

STM32F103C8T6 module (ARM32 Cortex-M3, 72 Mhz, 64K flash, 20K SRAM, 33 I/O pins, 3.3V),
you can find cheap modules on eBay
Serial-to-USB-module (3.3V level, e.g. CH340)

Steps:

![stm32 serial](http://grauonline.de/wordpress/wp-content/uploads/arduino_stm32f103c8t6.jpg)
![stm32 shema](http://grauonline.de/wordpress/wp-content/uploads/arduino_stm32f103c8t6_schematics.png)

 - 1) - Wire STM32 module and Serial-to-USB module as shown above :
 - 2) - Download and install Arduino IDE (I did use 1.6.3)
 - 3) - Download ‘https://github.com/rogerclarkmelbourne/Arduino_STM32‘, extract it and copy the folder ‘Arduino_STM32-master’ to your Arduino/hardware folder (C:\Programs\Arduino\hardware).
 - 4) - Run Arduino IDE, choose settings:
‘Board: Generic STM32F103C series‘
‘Variant: STM32F103C8 (20k RAM, 64k Flash)’
‘Upload method: Serial‘
‘Port: <the COM port of your USB-to-serial adapter>’
 - 5) - Compile this sketch:

```c++
#define pinLED PC13

void setup() {
  Serial.begin(9600);
  pinMode(pinLED, OUTPUT);
  Serial.println("START");  
}

void loop() {
  digitalWrite(pinLED, HIGH);
  delay(1000);
  digitalWrite(pinLED, LOW);
  Serial.println("Hello World");  
}
```

 - 6) - On the board, set ‘BOOT0‘ to 1 (will boot from system memory which contains an UART to flash uploader). Press RESET button.
 - 7) - In the Arduino IDE, choose ‘Upload‘. On the board, the blue LED will start to flash.
 - 8) - After upload completed, your sketch will start. If you want your uploaded sketch to boot automatically after next power-on/reset, set ‘BOOT0‘ back to 0 (will boot from program memory). Press RESET button.

---
## 2) Blink led 13 Électro-Bidouilleur :

```c++
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
```

---
## 3) Démos Interfaces (SPI, I2C) :

Arduino demo code for STM32F103C8T6:

 - 1) - SPI interface

```c++
#include "SPI.h"

#define pinLED PC13
#define pinRST PB0
#define pinIRQ PB1

#define pinSPI_SS  PA4  
#define pinSPI_CLK PA5
#define pinSPI_MISO PA6
#define pinSPI_MOSI PA7

volatile int irqCounter = 0;
int lastIrqCounter = 0;

void handleIRQ(){
  irqCounter++;
}

void setup(){  
  pinMode(pinLED, OUTPUT);
  pinMode(pinSPI_SS, OUTPUT);
  pinMode(pinRST, OUTPUT);
  pinMode(pinIRQ, INPUT);  

  Serial.begin(115200);
  Serial.println("START");
  attachInterrupt(pinIRQ, handleIRQ, RISING);

  // Initializes the SPI bus by setting SCK, MOSI, and SS to outputs, pulling SCK and MOSI low, and SS high.
  SPI.begin();  

  digitalWrite(pinRST, LOW);
  delay(200);
  digitalWrite(pinRST, HIGH);
  delay(100);
}

void spiTest(){
  unsigned long msg = 0;
  SPI.beginTransaction(SPISettings(16000000L, MSBFIRST, SPI_MODE0));
  digitalWrite(pinSPI_SS, LOW);
  SPI.transfer(0x00);
  msg = SPI.transfer(0x00);
  msg = (msg << 8) + SPI.transfer(0x00);
  msg = (msg << 8) + SPI.transfer(0x00);
  msg = (msg << 8) + SPI.transfer(0x00);  
  digitalWrite(pinSPI_SS, HIGH);
  SPI.endTransaction();  
  Serial.println(msg, HEX);  
}

void loop(){
  digitalWrite(pinLED, HIGH);
  delay(100);
  digitalWrite(pinLED, LOW);
  delay(100);  
  if (irqCounter != lastIrqCounter){
    Serial.println(irqCounter);
    lastIrqCounter = irqCounter;
  }
  spiTest();
  delay(2000);
}
```

 - 2) - I2C interface:

```c++
#include <Wire.h>

#define OLED_address  0x3C

int pinSDA = PB4;
int pinSCL = PB5;

TwoWire MyWire(pinSCL, pinSDA);

MyWire.beginTransmission(OLED_address); //start transmission to device
MyWire.write(0x80);        // send register address
MyWire.write(0);        // send value to write
MyWire.endTransmission(); //end transmission
```
