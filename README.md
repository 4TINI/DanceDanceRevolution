# DanceDanceRevolution

For the sensors laboratory at Politecnico di Milano we were asked to realize the well known game from the 90s building from scratch the capacitive sensors to realize the platform controller of the game. An Arduino Board was chosen to control all the sensors. A graphical interface was also a request of the assignment. We decided to realize it with Processing a Java based IDE. The two components, ArduinoMicro and graphical computer interface communicate through serial communication.

## Table of Contents
- [Introduction](#introduction)
  - [Original Gameplay](#original-gameplay)
- [Hardware](#hardware)
  - [Electrical Circuit](#electrical-circuit)
  - [Sensor's Design](#sensor's-design)
  - [Sensor's electrical model](#)
- [Firmware](#firmware)
- [Software](#software)

## Introduction

### Original Gameplay
The video game Dance Dance Revolution is a music-based game of timing. The game plays music and shows patterns of arrows synchronized with the music. The player stands on a platform marked with the same four arrows shown in the game and earns a score based on how closely his steps match the timing of the video game. A pattern of steps for a given song is called a step chart, and each step chart has a diculty based on the speed of the music and the number of arrows.

## Hardware
In order to replicate the game we had to design a platform. In this sense we created a styrofoam base on which four buttons arrow shaped are placed. Every key is a capacitive sensor connected to a microcontroller board through appropriate resistors. Sensors’ signals are sent to the computer. 

### Electrical circuit
The platform is made of very basic hardware component: 
* Arduino Micro, 
* four 1MΩ resistors 
* four hand-made electrodes.

![screenshot 67](https://user-images.githubusercontent.com/32873849/41253351-5728d4fc-6dc0-11e8-8f6a-4985048e05cf.png)

### Sensor's design

![screenshot 69](https://user-images.githubusercontent.com/32873849/41255247-39bc1b1c-6dc6-11e8-97c5-c4520ee0252a.png)

Electrodes have been made by folding aluminium cooking foils and by wrapping them in copper leaves.
Their electrical properties result from both aluminium and copper, and depend on the dimensions and quantities of materials. Hence, the four sensor had to be the same size and had to be made with the same quantity of aluminium and copper. 
To have a keyboard-like interface, we placed a foam rectangle under each sensor and covered them with a cardboard rectangle to simulate the single key; under the part of the cardboard that is near to the sensor, we have put a copper leave in order to have more conductivity when we push the key.
The sensors were later put on a layer of styrofoam, which insulates them from the ground.

### Sensor's electrical model
The sensors are basically electrical conductors. Therefore, each of them, under current, generates an electrical field in the surrounding space. Since the sensors are insulated from the ground (they are fixed on a styrofoam platform), the field doesn’t change unless a conductor links the aluminium to the ground. When a body enters the region of a sensor, the electrical field generated by it decreases, and so electrical charges moves from it to the body. The closer the body gets to the foil, the more charges will carry away from it, and this is exactly how a capacitor works. The sensor and the body act like plates of a capacitor, whose capacity changes due to increasing and decreasing distance between the plates themselves:

![cap7](https://user-images.githubusercontent.com/32873849/41253317-35065b56-6dc0-11e8-8b27-332d534128ee.png)

with C being the capacity, ε0 and εr being the vacuum and the mean electric permittivity, A being the overlapping surface of the two plates and d the distance between them.
As A and d change, the overall capacity will change. Thus, the whole process can be studied as a RC circuit which discharges when the external body gets closer to the sensor, creating a way for the current to flow from the sensor to the ground, and that charges when the sensor is left insulated.

![screenshot 68](https://user-images.githubusercontent.com/32873849/41253447-ac03abdc-6dc0-11e8-98ee-7b3e06d746f6.png)

A possible model for the capacity could be:

<p align="center">        
Csensed=C1+ΔC
</p>

where C1 is the capacity when no body is near the sensor and ∆C represents the capacity of the body when it couples with the sensor.
Csensed will then change, as above said, according to the changing distance between the plates. The function loaded on Arduino allows to detect touch or proximity. It constantly switches Send_Pin from HIGH to LOW and viceversa, thus inducing an electrical transient in the capacitive load (R + Csense). A current will flow according to the RC time constant in that moment, which depends on the capacity of the system. By measuring the current flowing through the resistor between the Send_Pin and the Receive_Pin, one can infer the distance between the plates, although this depends on the calibration of the system. 

## Firmware
The Arduino library CapacitiveSensor.h allows to read capacitance values and their variations of capacitive sensors. The function used is CapacitiveSensor which requires two pins as input variables: one is used as SendPin and the other one is used as ReceivePin. Between them a high value resistor is required in order to limit the current that the function requires to measure the capacitance. 
Thus, an RC circuit is built, whose time constant depends on both R and C: we used a 1MΩ resistor since our project is based on direct contact with sensor, so the region of interest is the sensor itself.
The above mentioned function sets the pins and the overall system for the reading. The function which actually reads the capacitance values is capacitiveSensor: according to a sampling time, which is required as function input, the function samples the value and save it (also an ouput variable is required, an integer since the value of the capacitance will be a number).

The Arduino code was written in order for it to read the values of the capacitances at every loop cycle: every time, it reads the “Left Arrow” sensor’s capacitance, then the “Bottom Arrow” and so on. As we noticed, the values are highly dependent on the shape and the mass of the capacitor, so we chose not to calibrate the system but to build the sensors in order for them to me as much alike to one another as possible. Thus, the values that the function got were reasonable and increased (only) when the sensors were directly touched. Since the calibration was basically building all the sensors with the same size and quantity of material, 

we set an empirical threshold capacitance value, which the sensors reach only if touched, to determine whether the contact was happening or not.

### Serial Communication
Arduino can exploit the Serial Port to send data via different functions: we used Serial.println(), which takes as an input both a string type or an integer variable but only gives as output a string type variable. This is possible only if the Standard Firmata protocol is loaded on Arduino: this protocol allows Arduino to communicate with softwares on the host computer and vice versa. In our project, communications from computer to Arduino was not necessary.

Our first idea was to send the values to Processing every time a loop occurred, whether the value was over the threshold or not, and Processing would read the values via the function SerialEvent which activates every time the serial Port is occupied. This happened at every Arduino loop, so a counting variable was created in Processing which counted how many times the serial port was being occupied: thus, we could know from which sensor the function was getting that particular value. This way, the threshold was set in Processing because all the sensed values were directly sent to it, but since the output of the Serial communication was a string, we had to use the function parseInt() on Java which converts a string into an int.
Even though this method worked, it still could bring up some issues: if the Port missed an Arduino loop then the counting variable missed one increment and all the values that would be read after that were going to be referred to the wrong sensor. 

Therefore we rejected this idea. 
The communication instead starts from Arduino filtering which readings are to pass to Processing: in every loop, Arduino reads the values from all the four sensors and sends a string in the Serial Port only if the value read is bigger then the threshold. The string that is sent in the Serial Port is a two-characters string which simply states which sensor is over threshold (eg: if the Right Arrow sensor is touched, then the value that Arduino reads will be higher than the threshold and it will send “dx” (meaning ‘right’) in the Serial Port. 

## Software
The Graphical interface has been realized through Processing, a Java based Integrated Development Environment (IDE).

### Game Architecture
The Architecture of the game is inspired by the classical arcade video games that had an extremely simple layout for the options with a large, dominating logo taking up the majority of the screen real estate and a quickly scannable list of options.

![screenshot 27](https://user-images.githubusercontent.com/32873849/41108901-02cc2488-6a76-11e8-8d1b-451ce2a5d2ce.png)

In the scheme in figure below is showed the structure of all the game screens and the logic operation to pass from a level to the following.

![screenshot 36](https://user-images.githubusercontent.com/32873849/41250773-2f8de066-6db8-11e8-9e5f-e0f259ce779a.png)

In the following figure we can observe how the game layout is organized. During normal gameplay, arrows scroll upwards from the bottom of the screen and pass over a set of stationary arrows near at the top-right corner (referred to as the "guide arrows" or "receptors", officially known as the Step Zone). When the scrolling arrows overlap the stationary ones, the player must step on the corresponding arrows on the dance platform, and the player is given a judgement for their accuracy of every streaked notes (From highest to lowest: Perfect, Great, Nice, Ok, Almost, Miss).
Successfully hitting the arrows in time with the music fills the score bar, while failure to do so drains it. If the bar is fully exhausted during gameplay or if it isn’t filled completely at the end of the song, the player will fail the level, and the game will be over. Otherwise, the player is taken to the next level.
The player is free to pause the game as he/she pleases pressing the space bar on the keyboard or the pause button with the mouse next to the score bar.
  
![screenshot 43](https://user-images.githubusercontent.com/32873849/41250729-0c59290c-6db8-11e8-99d2-91a16c7fa8a7.png)

### The class "SlidingArrow"
A class is a user defined blueprint or prototype from which objects are created. It represents the set of properties or methods that are common to all objects of one type. Our object Arrow is made by four instances declared in the class “SlidingArrow”:
* time
* column
* speed
* position

The pattern of arrows for each song is stored in “.Json” file created with a Matlab code which was run just once setting the average arrows distance in terms of time, the difficulty level of the song in terms of sliding speed and duration of the song. Through a “for” cycle a random pattern of arrows with the four instances listed before was created.
At the beginning of each level Processing scans the relative “.Json” file and creates an arraylist of “Arrow” objects. At each “draw()” iteration the position of each arrow is updated according to a “sliding” function that interpolates position according to the set speed.
  
![screenshot 40](https://user-images.githubusercontent.com/32873849/41251025-f2b01460-6db8-11e8-92a0-e5632aae18d9.png)

![screenshot 46](https://user-images.githubusercontent.com/32873849/41251043-0c22d61c-6db9-11e8-8897-f17c517ff531.png)

### Score Management
Let’s now focus on the key aspect of the game: player’s timing and the attribution of points.
Everytime the user presses a button on the platform the software selects one of the four lanes in which the arrows slide and it calculates the distance from the target. According to the accuracy of the player a score is assigned and a points combo multiplier, initially set to 1, is incremented. When an arrow is missed the combo points bonus is lost reinitializing the multiplier to 1.

![screenshot 45](https://user-images.githubusercontent.com/32873849/41251154-5cd76b9a-6db9-11e8-9a2f-b6a41fa6d2ff.png)
