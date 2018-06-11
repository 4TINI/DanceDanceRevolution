# DanceDanceRevolution
## 1.Introduction
### Assignment
For the sensors laboratory at Politecnico di Milano we were asked to realize the well known game from the 90s building from scratch the capacitive sensors to realize the platform controller of the game. An Arduino Board was chosen to control all the sensors. A graphical interface was also a request of the assignment. We decided to realize it with Processing a Java based IDE. The two components, ArduinoMicro and graphical computer interface communicate through serial communication.

### Original Gameplay
The video game Dance Dance Revolution is a music-based game of timing. The game plays music and shows patterns of arrows synchronized with the music. The player stands on a platform marked with the same four arrows shown in the game and earns a score based on how closely his steps match the timing of the video game. A pattern of steps for a given song is called a step chart, and each step chart has a diculty based on the speed of the music and the number of arrows.

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
