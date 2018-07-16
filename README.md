# DanceDanceRevolution

For the sensors laboratory at Politecnico di Milano we were asked to realize the well known game from the 90s building from scratch the capacitive sensors to realize the platform controller of the game. An Arduino Board was chosen to control all the sensors. A graphical interface was also a request of the assignment. We decided to realize it with Processing a Java based IDE. The two components, ArduinoMicro and graphical computer interface communicate through serial communication.

## Table of Contents
- [Introduction](#introduction)
  - [Original Gameplay](#original-gameplay)
- [Hardware](#hardware)
  - [Electrical Circuit](#electrical-circuit)
  - [Sensor's Design](#sensors-design)
  - [Sensor's electrical model](#sensors-electrical-model)
- [Firmware](#firmware)
  - [Serial Comunication](#serial-comunication)
- [Software](#software)
  - [Game Architecture](#game-architecture)
  - [The class "SlidingArrow"](#the-class-slidingarrow)
  - [Score Management](#score-management)
- [Conclusion](#conclusion)

## Introduction

### Original Gameplay
The video game Dance Dance Revolution is a music-based game of timing. The game plays music and shows patterns of arrows synchronized with the music. The player stands on a platform marked with the same four arrows shown in the game and earns a score based on how closely his steps match the timing of the video game. A pattern of steps for a given song is called a step chart, and each step chart has a difficulty based on the speed of the music and the number of arrows.

## Hardware
In order to replicate the game we had to design a platform. In this sense we created a styrofoam base on which four arrow shaped buttons are placed. Every key is a capacitive sensor connected to a microcontroller board through appropriate resistors. Sensors’ signals are calibrated and send to the computer via serial communication.

### Electrical circuit
The platform is made of very basic hardware component:
• Arduino Micro
• four 1MΩ resistors
• four hand-made capacitive sensors
Arduino Micro is a microcontroller board based on the ATmega32U4, with 20 digital input/output pins, 7 of which can be used as analog inputs, and an USB connection. The sensors were linked to 8 pins through the resistors. The USB connection was made use of in order to send these data through the serial USB port of the computer. The same port would then be occupied by Processing, a graphic software that has been used to show the data obtained from Arduino.

![screenshot 67](https://user-images.githubusercontent.com/32873849/41253351-5728d4fc-6dc0-11e8-8f6a-4985048e05cf.png)

### Sensor's design

![screenshot 69](https://user-images.githubusercontent.com/32873849/41255247-39bc1b1c-6dc6-11e8-97c5-c4520ee0252a.png)

Sensors were made folding aluminum cooking foils and wrapping them in copper leaves. Size and spacing of the capacitive sensor are both very important to the sensor's performance. In addition to the size of the sensor, and its spacing relative to the ground plane, the type of ground plane used is very important. Since the parasitic capacitance of the sensor is related to the electric field's path to ground, it is important to choose a ground plane that limits the concentration of e-field lines with no conductive object present. For this reason, the whole structure leans on a styrofoam layer. To have a keyboard-like interface, we placed a foam rectangle under each sensor and covered them with a cardboard rectangle to simulate the single key.

### Sensor's electrical model
The sensors are basically electrical conductors. A small voltage is applied to this layer, resulting in a uniform electrostatic field. Since the sensors are insulated from the ground, given the styrofoam strata, the field doesn’t change unless a conductor links the aluminum to the ground. When a body, such as human finger enters the region of the sensor a capacitor is dynamically formed, the electrostatically field decreases. The sensor and the body act like plates of a capacitor, whose capacity changes as the distance between the plates increases or decreases. This behavior is resume din the following equation:

![cap7](https://user-images.githubusercontent.com/32873849/41253317-35065b56-6dc0-11e8-8b27-332d534128ee.png)

with C being the capacity, ε0 and εr being the vacuum and the mean electric permittivity, A being the overlapping surface of the two plates and d the distance between them.
As A and d change, the overall capacity will change. Thus, the entire process can be studied as a RC circuit which discharges when the external body gets closer to the sensor, creating a way for the current to flow from the sensor to the ground, and that charges when the sensor is left insulated.

![screenshot 68](https://user-images.githubusercontent.com/32873849/41253447-ac03abdc-6dc0-11e8-98ee-7b3e06d746f6.png)

A possible model for the capacity could be:

<p align="center">        
Csensed=C1+ΔC
</p>

where C1 is the capacity when nobody is near the sensor and ΔC represents the capacity of the body when it couples with the sensor.
Csensed will then change, as said before, according to the changing distance between the plates. The function loaded on Arduino allows to detect touch or proximity. It constantly switches Send_Pin from HIGH to LOW and viceversa, thus inducing an electrical transient in the capacitive load (R + Csense). A current will flow according to the RC time constant in that moment, which depends on the capacity of the system. By measuring the current flowing through the resistor between the Send_Pin and the Receive_Pin, one can infer the distance between the plates, although this depends on the calibration of the system.

## Firmware
The Arduino library CapacitiveSensor.h allows to read capacitance values and its variation in time.
The function CapacitiveSensor requires two pins as input variables: one is used as SendPin and the other one is used as ReceivePin (see Figure 5). Between them a high value resistor is preferable to limit the current that the function requires to measure the capacitance. This results in a RC circuit whose time constant depends on both R and C. We have chosen a 1MΩ resistor since our project is based on direct contact with the sensor, so the region of interest is the sensor itself.
The function mentioned above sets the pins and the overall system for the reading.
The function which actually reads the capacitance values is capacitiveSensor. This function requires a sampling time as input: depending on this time, capacitiveSensor will read the values of the capacitance and store them in an output variable (integer type).
At every loop Arduino’s code reads and stores the capacitive values of all the sensors. Of course, the values are highly dependent on the shape and the mass of the capacitor. To simply the calibration procedure we tried as much as we could to build the buttons with the same shape and amount of conductive material. This way we’ve been able to identify a common threshold to establish whether the contact was happening or not.

### Serial Comunication
Arduino can exploit the Serial Port to send data via various functions. In particular we opt for Serial.println( ). This function takes as an input both a string type or an integer variable but outputs just string type variables. To ensure the function to work properly Standard Firmata protocol is loaded on Arduino: this protocol allows the microcontroller to communicate with the software on the host computer and vice versa. In our project, communications from computer to Arduino was not necessary.

As can be understood from the above figure Processing’s function SerialEvent( ) runs only if there’s something inside the serial buffer.
Our first idea was to send the values to Processing every time a loop occurred, whether the value was over the threshold or not. Inside the SerialEvent( ) function a counting variable from 1 to 4 kept track of the input data to trace back to the original sensor’s index.
Even if this method worked we were afraid that even a small error in the serial communication would bring to a completely wrong indexing of the sensors in all the following loops.
To avoid such a possibility we implemented Arduino’s code at every loop to choose and send among the capacitance values only the ones over the set threshold. The string that is sent in the Serial Port is a two-characters string which simply states which sensor is over threshold (eg: if the Right Arrow sensor is touched, then the value that Arduino reads will be higher than the threshold and it will send “dx” (meaning ‘right’) in the Serial Port.

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
Every time the user presses a button on the platform the software selects one of the four lanes in which the arrows slide and it calculates the distance from the target. According to the accuracy of the player a score is assigned and a points combo multiplier, initially set to 1, is incremented. When an arrow is missed the combo points bonus is lost reinitializing the multiplier to 1. multiplier to 1.

![screenshot 45](https://user-images.githubusercontent.com/32873849/41251154-5cd76b9a-6db9-11e8-9a2f-b6a41fa6d2ff.png)

## Conclusion
The four capacitive sensors are responsive and send successfully the input caused by the pressing of the buttons to Processing through Arduino.
Being the sensors’ calibration very complex, we opted for a more intuitive solution with the sensors: evaluating the difference between a high input and a low one. This solution proved to be successful and the sensors ended up working very well.
Processing uses this information to confront in real time the arrows present on the screen with the input, determining the result.
The problem with this could have been that a single input from the sensors could unleash multiple reactions from the Processing software, but our code proved to be solid enough to exclude this instance, for example limiting the simultaneous inputs to one.
We are ultimately very satisfied with the result we achieved, by the promptness of the sensor and by how we utilized the interface, and the problems that we were afraid could ruin the execution ended up being less relevant than we thought and we were easily able to solve them, managing to achieve a very good game.
