# TurtleSunTank
Since reptiles are classified as ectothermic, which means that they are unable to regulate their body temperature internally and rely on the outer temperature. My turtles need a place to sun and with them growing their current sunningplace becomes a bit to small. Therefore I've designed an automated sun tank that can be placed on their current living space. Afcourse being an electronic enthousiast, the tank is fully automated.

It can perform the following tasks:
- Switch the lights automatically on/off based on the time,
- Adjust the lighting depending on the temperature & humidity in the sun tank,
- Displaying the temperature & humidity in the sun tank on an LCD,
- Displaying the temperature of the water on an LCD.

For this project I've decided to design an small microcontroller based on an Atmega 2560 with an RTC on board:
![alt tag](https://i.imgur.com/WsGML3I.png "PCB design")

Major components used in this project:
- MCU: Atmega 2560
- RTC: DS1307
- temperature sensor: ds18b20 (waterproof version)
- temperature & humidity sensor: DHT11
- LCD: standard 16x2 I2C LCD
- Relay module: standard 2 channel relay module

The project contains the following folders:
- PCB design: here you can find everything of the PCB design.
- 3D printing: an OpenSCAD model of the enclossure I've build (based on the The Ultimate Parametric Box by Heartman).
- Lasercutting: the design of the plexiglass used for the turtle sun tank.
- Code: the code written for the project.
