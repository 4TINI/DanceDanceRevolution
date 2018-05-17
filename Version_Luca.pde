//**********LIBRARIES**********//
import processing.video.*;

//**********GLOBAL VARIABLES**********//
PImage backImage, UpBtn, RightBtn, DownBtn, LeftBtn, LevelBar; //White Arrows Buttons

int dimSize = 900; //window size
float Score = -14.6; //Loading Bar counter (is intiliazed as -14.6 because of the click on the button, change it later)
int screen = 0; //Screen counter

int FrameCounter = 0;

PFont myFont;

PGraphics TopLayer; //Use this class if you need to draw into an off-screen graphics buffer

Movie ShadowDance;

PImage playBtn;
boolean BtnOver = false;

/*Button
int BtnX;
int BtnY;
int BtnSizeX; 
int BtnSizeY;*/

//rect
int rectX, rectY;
int sizeX, sizeY;

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
     
  //music
  
  
  
  
  //font
  myFont = createFont("AIJFont.ttf", 30);
  textFont(myFont);
  textSize(30);
  
  //video (REMEMBER TO PUT THE VIDEO IN A FOLDER CALLED "data")
  ShadowDance = new Movie(this, "ShadowDance.mp4");
  ShadowDance.loop();
  
  /*play button
  playBtn = loadImage("play3.png");
  BtnX = width/2;
  BtnY = height/2;
  BtnSizeX = playBtn.width;
  BtnSizeY = playBtn.height;*/
  
  //rect
  rectX = width/2;
  rectY = height/2 + 10;
  sizeX = 400;
  sizeY = 70;
  
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
  fill(255);
  rectMode(CENTER);
  rect(rectX, rectY, sizeX, sizeY);
  update(mouseX, mouseY);
  
  TopLayer.beginDraw();
    //this if command changes the background color 
    if(FrameCounter == 20){
      TopLayer.colorMode(HSB);
      TopLayer.tint(random(255), 255, 255);
      
      FrameCounter = 0;
    }
  TopLayer.image(ShadowDance, width/2-240, 30);
  TopLayer.endDraw();
  
  image(TopLayer,0,0);
  
  noTint();
  
  textSize(60);
  if (BtnOver) {
    colorMode(HSB);
    fill(330, 2, 94); 
  } else {
    fill(250, 100, 94);
  }  
  //image(playBtn, BtnX, BtnY);   
  textAlign(CENTER, CENTER);
  text("New Game", width/2, height/2);
  
  //update the framecounter
  FrameCounter = FrameCounter + 1;
}

void levelOne() {
  background(backImage);
  TopLayer.beginDraw();
    //this if command changes the background color
    if(FrameCounter == 20) {
      TopLayer.colorMode(HSB);
      TopLayer.tint(random(255),255, 255);
      TopLayer.image(backImage, 0, 0);
      FrameCounter = 0;
    }
  TopLayer.endDraw();
  
  image(TopLayer, 0, 0);
  
  noTint();
  
  //show white arrows
  image(UpBtn, 620, 40);
  image(RightBtn, 730, 40);
  image(LeftBtn, 400, 40);
  image(DownBtn, 510, 40);
  
  //Loading bar
  noStroke();
  fill(46, 180, 7);
  rect(129, 87, Score, 32); //everytime I click the mouse the width of the bar grows
  
  //this if command checks if the target point is reached
  if (Score > 246) {
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

/********* OTHER METHODS AND FUNCTIONS *********/
void mouseClicked() {
  Score = Score + 14.6;  
}

void movieEvent(Movie m) { 
  m.read(); 
} 

// This method sets the necessary variables to start the game  
void changeScreen() {
  screen = screen +1;
}

void update(int x, int y) {
  if (overBtn(rectX, rectY, sizeX, sizeY)) {
    BtnOver = true;   
  } else {
    BtnOver = false;
  }
}

//function to establish if the mouse is over the button
boolean overBtn(int x, int y, int width, int height)  {
  if (mouseX >= x-width/2 && mouseX <= x+width/2 && 
      mouseY >= y-height/2 && mouseY <= y+height/2) {
    return true;
  } else {
    return false;
  }
}

//When you click on the "PLAY" button the game starts
void mousePressed() {
  if (BtnOver) {
    ShadowDance.stop();
    BtnOver = false;
    changeScreen();   
  }
}


    