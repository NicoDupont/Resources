Créé le : 29/01/2017  
Dernière maj : 03/03/2017  
Auteur : Nicolas DUPONT   
Contact :   
Lien Github :

# Arduino Nano V3 Non Official (ATmega328 + USB CH340)
---

Quelques Liens :  
 - Achat:[Ebay](http://www.ebay.fr/itm/191493195939?_trksid=p2057872.m2749.l2649&var=490575158673&ssPageName=STRK%3AMEBIDX%3AIT)  
 - [Arduino](https://www.arduino.cc/en/Main/ArduinoBoardNano)  
 - [Driver Windows](http://www.aht.li/2700355/driver_arduino_CH340.ZIP)
 - [Driver CH340 mac](http://www.wch.cn/download/CH341SER_MAC_ZIP.html)
 - [Driver CH340 windows](http://www.wch.cn/download/CH341SER_EXE.html)   
 - [Explications driver](http://sparks.gogo.co.nz/ch340.html)
 - [Github Driver OSX](https://github.com/adrianmihalko/ch340g-ch34g-ch34x-mac-os-x-driver)
 - [Explications Driver 2](http://kig.re/2014/12/31/how-to-use-arduino-nano-mini-pro-with-CH340G-on-mac-osx-yosemite.html)   

## Sommaire :

 1. Installation du driver sous windows
 2. Programme de test
 3.  Documentation du site site Arduino sur le NANO

### Installation du driver sous windows
Dans le cas d'un NANO non officiel avec le chips USB : CH340  

30/01/2017 sous windows 10  (+ Arduino IDE v 1.8.1)  
01/03.2017 sous Ubuntu 16.04.2 (+ Arduino IDE v 1.8.1)  
=> je n'ai pas eu besoin d'installer un driver supplémentaire !  
=> bien détecté dans le gestionnaire de péréphérique.

[Archive Driver Windows lien-1](http://www.aht.li/2700355/driver_arduino_CH340.ZIP)  
[Archive Driver Windows lien-2](http://www.aht.li/2700355/driver_arduino_CH340.ZIP)  

Une fois le driver téléchargé , enregistré le sur votre ordinateur   
C'est un fichier ZIP il est donc nécessaire de le décompresser.   
Lancez ensuite le programme setup , cliquez sur sur le bouton install, le driver sera automatiquement installé.

Linux / Macosx  
=> pas besoin de driver supplémentaire

---
### Programme de test

Use your Arduino Nano on the Arduino Desktop IDE  
If you want to program your Arduino Nano while offline you need to install the Arduino Desktop IDE To connect the Arduino Nano to your computer, you'll need a Mini-B USB cable.   
This also provides power to the board, as indicated by the blue LED (which is on the bottom of the Arduino Nano 2.x and the top of the Arduino Nano 3.0).  
Open your first sketch  
Open the LED blink example sketch: File > Examples >01.Basics > Blink.  
Select your board type and port  
You'll need to select the entry in the Tools > Board menu that corresponds to your Nano board.  
Upload and Run your first Sketch  
To upload the sketch to the Arduino Nano, click the Upload button in the upper left to load and run the sketch on your board:  

---
### Documentation du site site Arduino sur le NANO

*Technical Specs* |  
----------| ------
Microcontroller |	ATmega328
Architecture |	AVR
Operating Voltage |	5 V
Flash Memory |	32 KB of which 2 KB used by bootloader
SRAM |	2 KB
Clock Speed |	16 MHz
Analog I/O Pins |	8
EEPROM |	1 KB
DC Current per I/O Pins |	40 mA (I/O Pins)
Input Voltage |	7-12 V
Digital I/O Pins | 22
PWM Output |	6
Power Consumption |	19 m a
PCB Size |	18 x 45 mm
Weight |	7 g
Product Code |	A000005

##### **Power**
The Arduino Nano can be powered via the Mini-B USB connection, 6-20V unregulated external power supply (pin 30), or 5V regulated external power supply (pin 27). The power source is automatically selected to the highest voltage source.

##### **Memory**
The ATmega328 has 32 KB, (also with 2 KB used for the bootloader. The ATmega328 has 2 KB of SRAM and 1 KB of EEPROM.

##### **Input and Output**

Each of the 14 digital pins on the Nano can be used as an input or output, using pinMode(), digitalWrite(), and digitalRead() functions.   
They operate at 5 volts.   
Each pin can provide or receive a maximum of 40 mA and has an internal pull-up resistor (disconnected by default) of 20-50 kOhms.  
In addition, some pins have specialized functions:
 - Serial: 0 (RX) and 1 (TX). Used to receive (RX) and transmit (TX) TTL serial data. These pins are connected to the corresponding pins of the FTDI USB-to-TTL Serial chip.
 - External Interrupts: 2 and 3. These pins can be configured to trigger an interrupt on a low value, a rising or falling edge, or a change in value. See the attachInterrupt() function for details.
 - PWM: 3, 5, 6, 9, 10, and 11. Provide 8-bit PWM output with the analogWrite() function.
 - SPI: 10 (SS), 11 (MOSI), 12 (MISO), 13 (SCK). These pins support SPI communication, which, although provided by the underlying hardware, is not currently included in the Arduino language.
 - LED: 13. There is a built-in LED connected to digital pin 13. When the pin is HIGH value, the LED is on, when the pin is LOW, it's off.
The Nano has 8 analog inputs, each of which provide 10 bits of resolution (i.e. 1024 different values). By default they measure from ground to 5 volts, though is it possible to change the upper end of their range using the analogReference() function. Analog pins 6 and 7 cannot be used as digital pins. Additionally, some pins have specialized functionality:
 - I2C: 4 (SDA) and 5 (SCL). Support I2C (TWI) communication using the Wire library (documentation on the Wiring website).
There are a couple of other pins on the board:
 - AREF. Reference voltage for the analog inputs. Used with analogReference().
 - Reset. Bring this line LOW to reset the microcontroller. Typically used to add a reset button to shields which block the one on the board.


##### **Communication**

The Arduino Nano has a number of facilities for communicating with a computer, another Arduino, or other microcontrollers. The ATmega328 provide UART TTL (5V) serial communication, which is available on digital pins 0 (RX) and 1 (TX). An FTDI FT232RL on the board channels this serial communication over USB and the FTDI drivers (included with the Arduino software) provide a virtual com port to software on the computer. The Arduino software includes a serial monitor which allows simple textual data to be sent to and from the Arduino board. The RX and TX LEDs on the board will flash when data is being transmitted via the FTDI chip and USB connection to the computer (but not for serial communication on pins 0 and 1).
A SoftwareSerial library allows for serial communication on any of the Nano's digital pins.
The ATmega328 also support I2C (TWI) and SPI communication. The Arduino software includes a Wire library to simplify use of the I2C bus. To use the SPI communication, please see ATmega328 datasheet.

##### **Programming**

The Arduino Nano can be programmed with the Arduino software (download). Select "Arduino Duemilanove or Nano w/ ATmega328" from the Tools > Board menu (according to the microcontroller on your board).
The ATmega328 on the Arduino Nano comes preburned with a bootloader that allows you to upload new code to it without the use of an external hardware programmer. It communicates using the original STK500 protocol.
You can also bypass the bootloader and program the microcontroller through the ICSP (In-Circuit Serial Programming) header using Arduino ISP or similar.

##### **Automatic (Software) Reset**

Rather then requiring a physical press of the reset button before an upload, the Arduino Nano is designed in a way that allows it to be reset by software running on a connected computer. One of the hardware flow control lines (DTR) of the FT232RL is connected to the reset line of the ATmega328 via a 100 nanofarad capacitor. When this line is asserted (taken low), the reset line drops long enough to reset the chip. The Arduino software uses this capability to allow you to upload code by simply pressing the upload button in the Arduino environment. This means that the bootloader can have a shorter timeout, as the lowering of DTR can be well-coordinated with the start of the upload.
This setup has other implications. When the Nano is connected to either a computer running Mac OS X or Linux, it resets each time a connection is made to it from software (via USB). For the following half-second or so, the bootloader is running on the Nano. While it is programmed to ignore malformed data (i.e. anything besides an upload of new code), it will intercept the first few bytes of data sent to the board after a connection is opened. If a sketch running on the board receives one-time configuration or other data when it first starts, make sure that the software with which it communicates waits a second after opening the connection and before sending this data.
