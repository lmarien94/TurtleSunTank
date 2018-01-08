/**
 * The code for the turtle tank
 * author: Levi Mariën
 */
#include <dht.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <LiquidCrystal.h>
#include <RTClib.h>

#include "tabel.h"

#define DHT11_PIN 7
#define RELAY_PIN 8
#define LCD_I2C_ADDRESS 0x27
#define TEMPERATURE_LAMP_ON   25
#define TEMPERATURE_LAMP_OFF  23

//Set the LCD I2C address and pins on the I2C chip used for LCD connections.
LiquidCrystal_I2C lcd(LCD_I2C_ADDRESS, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);
RTC_DS1307 rtc;
dht DHT;

void calculateMainState();
void errorState();
int getTemperatureSunTank();
void displayTempAndHum();
void displayTempWater();
void switchRelayOnOff(bool switchOnOff);

//The different states for the state machine
enum MainStates {
        Day,              //Day state
        Night,            //Night state
        Error             //Error state
};
enum DayStates {
        DisplayTempAndHumidity, //Display the temperature and humidity of the sun tank
        DisplayTempWater, //Display the temperature of the water
        SwitchOffLamp,    //Switch off the lamp
        SwitchOnLamp      //Switch on the lamp
};

enum NightStates {
        sleep,
        wakeUp
};

enum MainStates mainState;
enum DayStates dayState;
enum NightStates nightState;

int temperatureSunTank;
int temperatureWater;
int check;

void setup(){

        Serial.begin(9600);
        lcd.begin(16,2);
        pinMode(RELAY_PIN, OUTPUT);

        dayState = DisplayTempAndHumidity;
}

/**
 * This function pulls the time of the RTC and sets the Day or Night state
 */
void calculateMainState() {

}

void errorState() {
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("!!Error!!");
        lcd.setCursor(0,1);
        lcd.print("!!Error!!");
}
int getTemperatureSunTank() {
        check = DHT.read11(DHT11_PIN);
        return (int)DHT.temperature;
}

void displayTempAndHum() {
        check = DHT.read11(DHT11_PIN);

        //Print to LCD
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Temp: ");
        lcd.print(DHT.temperature);
        lcd.print((char)223);
        lcd.print("C");
        lcd.setCursor(0,1);
        lcd.print("Humidity: ");
        lcd.print(DHT.humidity);
        lcd.print("%");

        //Display on Serial
        Serial.print("Temperature = ");
        Serial.println(DHT.temperature);
        Serial.print("Humidity = ");
        Serial.println(DHT.humidity);

}

void displayTempWater() {

}
void switchRelayOnOff(bool switchOnOff) {

//If switchOnOff is true --> switch on lamp
//if switchOnOff is false --> switch off lamp
        if (switchOnOff) {
                digitalWrite(RELAY_PIN, 0);
        } else {
                digitalWrite(RELAY_PIN, 1);

        }

}

void loop()
{
        calculateMainState();

        if (mainState == Day) {
                if (dayState == DisplayTempAndHumidity) {
                        displayTempAndHum();
                        delay(5000);
                        Serial.print("State: DisplayTempAndHumidity");
                        Serial.println();
                        dayState = DisplayTempWater;
                } else if (dayState == DisplayTempWater) {
                        displayTempWater();
                        delay(5000);
                        Serial.print("State: DisplayTempWater");
                        Serial.println();
                        temperatureSunTank = getTemperatureSunTank();
                        if (temperatureSunTank >= TEMPERATURE_LAMP_OFF) {
                                dayState = SwitchOffLamp;
                        } else if (temperatureSunTank <= TEMPERATURE_LAMP_ON) {
                                switchRelayOnOff(true);
                                dayState = SwitchOnLamp;
                        }
                } else if (dayState == SwitchOffLamp) {
                        switchRelayOnOff(false);
                        delay(5000);
                        Serial.print("State: SwitchOffLamp");
                        Serial.println();
                        calculateMainState();
                } else if (dayState == SwitchOnLamp) {
                        switchRelayOnOff(true);
                        delay(5000);
                        Serial.print("State: SwitchOnLamp");
                        Serial.println();
                        calculateMainState();
                }
        } else if (mainState == Night) {


        } else {
                errorState();
        }
}
