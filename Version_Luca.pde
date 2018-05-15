//**********LIBRARIES**********//
import processing.video.*;

//**********GLOBAL VARIABLES**********//
PImage backImage, UpBtn, RightBtn, DownBtn, LeftBtn, LevelBar; //White Arrows Buttons
int dimSize = 900; //window size
float Points = -14.6; //Loading Bar counter (is intiliazed as -14.6 because of the click on the button, change it later)
int screen = 0; //Screen counter

int FrameCounter = 0;
float r, g, b;

PFont myFont;

PGraphics TopLayer; //Use this class if you need to draw into an off-screen graphics buffer

Movie ShadowDance;

boolean rectOver = false;
color rectColor;
color rectHighlight;
int rectX, rectY; 
int rectSize = 90; 

void setup() {
  size(900, 900);
  
  TopLayer = createGraphics(900, 900);
  
  //load white arrows
  UpBtn = loadImage("Up.png");
  RightBtn = loadImage("Right.png");
  LeftBtn = loadImage("Left.png");
  DownBtn = loadImage("Down.png");
  LevelBar = loadImage("LevelBar2.png");
  LevelBar.resize(408, 204);
  
  //load background
  backImage = loadImage("back.png");
  backImage.resize(dimSize, dimSize);
  /*background(backImage);

  //show white arrows
  image(UpBtn, 620, 40);
  image(RightBtn, 730, 40);
  image(LeftBtn, 400, 40);
  image(DownBtn, 510, 40);
  
  //point bar
  LevelBar.resize(408, 204);
  image(LevelBar,0, 0);*/
   
  //music
  
  
  
  
  //font
  myFont = createFont("AIJFont.ttf", 30);
  textFont(myFont);
  textSize(30);
  
  /*textAlign(CENTER, CENTER);
  text("Lv.1", 80,100);*/
  
  //video (REMEMBER TO PUT THE VIDEO IN A FOLDER CALLED "data")
  ShadowDance = new Movie(this, "ShadowDance.mp4");
  ShadowDance.loop();
  
  //play button
  rectColor = color(0);
  rectHighlight = color(51);
  rectX = width/2-rectSize-10;
  rectY = height/2-rectSize/2;
 
}

// We control which screen is active by settings / updating
// gameScreen variable. We display the correct screen according
// to the value of this variable.
//
// 0: Initial Screen
// 1: Level 1
// 2: Level 2
// 3: Level 3

void draw() {
  if(screen == 0) {
    initScreen();     
  }
  
   if(screen == 1) {
     levelOne();
  }  
  
}

/********* SCREEN CONTENTS *********/
void initScreen() {

  background(0);
  update(mouseX, mouseY);
  image(ShadowDance, 0, 0);
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectSize, rectSize);
}

void levelOne() {
  background(backImage);
  TopLayer.beginDraw();
    //this if command changes the background color
    if(FrameCounter == 20) {
      r = random(20, 255);
      g = random(20, 255);
      b = random(20, 255);
      TopLayer.tint(r,g,b);
      TopLayer.image(backImage, 0, 0);
      FrameCounter = 0;
    }
  TopLayer.endDraw();
  
  image(TopLayer,0,0);
  
  noTint();
  
  //show white arrows
  image(UpBtn, 620, 40);
  image(RightBtn, 730, 40);
  image(LeftBtn, 400, 40);
  image(DownBtn, 510, 40);
  
  //Loading bar
  noStroke();
  fill(46, 180, 7);
  rect(129, 87, Points, 32); //everytime I click the mouse the width of the bar grows
  
  //this if command checks if the target point is reached
  if (Points > 246) {
  textSize(60);
  fill(240, 236, 238);
  textAlign(CENTER, CENTER);
  text("YOU WIN!", width/2, height/2);
  noLoop(); //if the point target is reached it stops the loop
  }
  
  //Point Bar 
  image(LevelBar, 0, 0);
  
  //Level Text inside the Point Bar
  textSize(30);
  fill(240, 236, 238);
  textAlign(CENTER, CENTER);
  text("Lv.1", 80, 100);  
  FrameCounter = FrameCounter + 1;
}  

/********* OTHER METHODS *********/
void mouseClicked() {
  Points = Points + 14.6;  
}

void movieEvent(Movie m) { 
  m.read(); 
} 

// This method sets the necessary variables to start the game  
void changeScreen() {
  screen = screen +1;
}

void update(int x, int y) {
  if (overRect(rectX, rectY, rectSize, rectSize)) {
    rectOver = true;   
  } else {
    rectOver = false;
  }
}

//function to establish if the mouse is over the botton
boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

//When you click on the "PLAY" button the game starts
void mousePressed() {
  if (rectOver) {
    ShadowDance.stop();
    rectOver = false;
    changeScreen();   
  }
}