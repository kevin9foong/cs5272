#include <ArduinoBLE.h> 
#include <Servo.h>
#include <EEPROM.h> 

#define LOW 0 
#define HIGH 1 

/* 
Servo related fields. 
*/ 
Servo servo; 

/*
BLE related fields. 
*/ 
const char * deviceServiceUuid = "7ba0d744-2692-45f6-b875-ebd7f5e0aab7"; 
const char * deviceStateUuid = "01f9d212-8a5b-4cec-bba7-a0034901d34b"; 

BLEService flipperService(deviceServiceUuid); 
BLEByteCharacteristic flipperStateCharacteristic(deviceStateUuid, BLERead | BLEWrite);   

/* 
Servo related functions  
*/ 
void switch_on(Servo servo) {
  servo.write(180);
}

void switch_off(Servo servo) {
    servo.write(0);
}

/*
EEProm to save the state when turned off. 
*/
unsigned int address = 0; 
byte saved_state;  

/* 
Arduimo control functions 
*/ 
void setup() {
  saved_state = EEPROM.read(address); 

  // connect servo to GPIO#9 
  servo.attach(8); 

  // enable console logs 
  Serial.begin(9600); // enable console logs? - baud rate of 9600 
  while(!Serial) { delay(10); };  

  // give device a short name - used for unique ID of device providing same service. 
  BLE.setDeviceName("flip01"); 
  BLE.setLocalName("flip01"); 

  if (!BLE.begin()) {
    // then start BLE 
    Serial.println("- Starting BLE module failed"); 
    while(1); 
  }

  BLE.setAdvertisedService(flipperService); // how the central will id the BLE service. 
  flipperService.addCharacteristic(flipperStateCharacteristic); 
  BLE.addService(flipperService); 

  // init to off state when boot 
  flipperStateCharacteristic.writeValue(saved_state);
  Serial.println("Prev state: " + saved_state); 

  uint8_t state = flipperStateCharacteristic.value(); 
  if (state == LOW) {
    switch_off(servo); 
  } else if (state == HIGH) {
    switch_on(servo); 
  }

  Serial.println("- Peripheral flip01 advertising start"); 

  // start advertising
  BLE.advertise(); 
}

// unsigned long previousDays = 0; 

void loop() {
  BLEDevice central = BLE.central(); // hub device 
  Serial.println(" - Discovering central device"); 
  delay(500); // ms 

  unsigned long currentDays = millis() / (1000 * 60 * 24); 

  // if (currentDays - previousDays >= 1) {
  //   previousDays = currentDays; 
  //   EEPROM.update(address, flipperStateCharacteristic.value());
  // }

  if (central) {
    // once found, establish connection 
    Serial.println("- Connected to central"); 

    while (central.connected()) {
      if (flipperStateCharacteristic.written()) {
        uint8_t state = flipperStateCharacteristic.value(); 
        Serial.println("- Updating flipper state");
        EEPROM.update(address, state); 
        if (state == LOW) {
          switch_off(servo); 
        } else if (state == HIGH) {
          switch_on(servo); 
        }
      }
    }
  }
}