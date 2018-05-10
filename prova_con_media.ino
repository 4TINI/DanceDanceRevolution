#include <CapacitiveSensor.h>

//const byte ledPin = 13;
//const byte interruptPin = 3;
//volatile byte state = HIGH;
CapacitiveSensor cs_4_2 = CapacitiveSensor(2, 4);
long total1;
CapacitiveSensor cs_5_3 = CapacitiveSensor(3, 5);
long total2;


void setup(){
  Serial.begin(9600);
  
 // cs_4_2.reset_CS_AutoCal();
 // cs_4_2.set_CS_Timeout_Millis(2000);
  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
}


void loop(){
   total1 =  cs_4_2.capacitiveSensor(60);
   total2= cs_5_3.capacitiveSensor(60);
   //Serial.print("Primo: ");
   Serial.println(total1);
   //Serial.print("Secondo: ");
   Serial.println(total2); 
   delay(400);
}


