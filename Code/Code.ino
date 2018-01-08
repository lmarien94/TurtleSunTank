/**
 * The code for the turtle tank
 * author: Levi Mariën
 */
#include <dht.h>
#include <Wire.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <LiquidCrystal_I2C.h>
#include <LiquidCrystal.h>
#include <RTClib.h>

#include "tabel.h"

#define DS18B20_PIN 9
#define DHT11_PIN 10
#define RELAY_PIN1 11
#define RELAY_PIN2 12
#define LCD_I2C_ADDRESS 0x27
#define TEMPERATURE_LAMP_ON   21
#define TEMPERATURE_LAMP_OFF  25

//Set the LCD I2C address and pins on the I2C chip used for LCD connections.
LiquidCrystal_I2C lcd(LCD_I2C_ADDRESS, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);
RTC_DS1307 rtc;
OneWire oneWire(DS18B20_PIN);
DallasTemperature sensors(&oneWire);
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

char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
int temperatureSunTank;
int temperatureWater;
int check;

void setup(){

        Serial.begin(9600);
        lcd.begin(16,2);
        pinMode(RELAY_PIN1, OUTPUT);
        sensors.begin();
        if (!rtc.begin()) {
                Serial.println("Couldn't find RTC");
                while (1) ;
        }

        calculateMainState();

        if (!rtc.isrunning()) {
                Serial.println("RTC is NOT running!");
                // following line sets the RTC to the date & time this sketch was compiled
                rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
                // This line sets the RTC with an explicit date & time, for example to set
                // January 21, 2014 at 3am you would call:
                // rtc.adjust(DateTime(2014, 1, 21, 3, 0, 0));
        }
}

/**
 * This function pulls the time of the RTC and sets the Day or Night state
 */
void calculateMainState() {

        DateTime now = rtc.now();
        Serial.print(now.year(), DEC);
        Serial.print('/');
        Serial.print(now.month(), DEC);
        Serial.print('/');
        Serial.print(now.day(), DEC);
        Serial.print(" (");
        Serial.print(daysOfTheWeek[now.dayOfTheWeek()]);
        Serial.print(") ");
        Serial.print(now.hour(), DEC);
        Serial.print(':');
        Serial.print(now.minute(), DEC);
        Serial.print(':');
        Serial.print(now.second(), DEC);
        Serial.println();

        mainState = Day;
        if (mainState == Day) {
                dayState = DisplayTempAndHumidity;
        }
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

        sensors.requestTemperatures();
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Water Temp: ");
        lcd.setCursor(0,1);
        lcd.print(sensors.getTempCByIndex(0));
        lcd.print((char)223);
        lcd.print("C");

        Serial.print("Water temperature = ");
        Serial.println(sensors.getTempCByIndex(0));

}
void switchRelayOnOff(bool switchOnOff) {

//If switchOnOff is true --> switch on lamp
//if switchOnOff is false --> switch off lamp
        if (switchOnOff) {
                digitalWrite(RELAY_PIN1, 0);
        } else {
                digitalWrite(RELAY_PIN1, 1);
        }
}

void loop()
{
        //calculateMainState();

        if (mainState == Day) {
                if (dayState == DisplayTempAndHumidity) {
                        displayTempAndHum();
                        delay(500);
                        Serial.print("State: DisplayTempAndHumidity");
                        Serial.println();
                        dayState = DisplayTempWater;
                        delay(500);
                } else if (dayState == DisplayTempWater) {
                        displayTempWater();
                        delay(500);
                        Serial.print("State: DisplayTempWater");
                        Serial.println();
                        temperatureSunTank = getTemperatureSunTank();
                        delay(500);
                        if (temperatureSunTank >= TEMPERATURE_LAMP_OFF) {
                                dayState = SwitchOffLamp;
                                delay(500);
                        } else if (temperatureSunTank <= TEMPERATURE_LAMP_ON) {
                                dayState = SwitchOnLamp;
                                delay(500);
                        } else {
                                calculateMainState();
                                delay(500);
                        }
                } else if (dayState == SwitchOffLamp) {
                        switchRelayOnOff(false);
                        delay(500);
                        Serial.print("State: SwitchOffLamp");
                        Serial.println();
                        calculateMainState();
                        delay(500);
                } else if (dayState == SwitchOnLamp) {
                        switchRelayOnOff(true);
                        delay(500);
                        Serial.print("State: SwitchOnLamp");
                        Serial.println();
                        calculateMainState();
                        delay(500);
                }
        } else if (mainState == Night) {


        } else {
                errorState();
        }
}
