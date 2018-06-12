#include <CapacitiveSensor.h>

//const byte ledPin = 13;
//const byte interruptPin = 3;
//volatile byte state = HIGH;
CapacitiveSensor cs_6_2 = CapacitiveSensor(2, 6);
long sx;
CapacitiveSensor cs_7_3 = CapacitiveSensor(3, 7);
long su;
CapacitiveSensor cs_8_4 = CapacitiveSensor(4,8);
long dx;
CapacitiveSensor cs_9_5 = CapacitiveSensor(5,9);
long giu;


void setup(){
  Serial.begin(9600);
  
 // cs_4_2.reset_CS_AutoCal();
 // cs_4_2.set_CS_Timeout_Millis(2000);
//  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
}


void loop(){
   sx =  cs_6_2.capacitiveSensor(60);
   su= cs_7_3.capacitiveSensor(60);
   dx= cs_8_4.capacitiveSensor(60);
   giu= cs_9_5.capacitiveSensor(60);

   if (sx > 100) {
     Serial.print("sx.");  
   }
   
   if (dx > 100) {
     Serial.print("dx.");  
   }
   
   if (su > 100) {
     Serial.print("su.");  
   }
   
   if (giu > 100) {
     Serial.print("giu.");  
   } 
   delay(70);  
}


