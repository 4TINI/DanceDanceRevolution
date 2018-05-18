//**********LIBRARIES**********//
import processing.video.*;

//**********GLOBAL VARIABLES**********//
PImage UpBtn, RightBtn, DownBtn, LeftBtn, LevelBar; //White Arrows Buttons
PImage backImage;
PImage pauseBtn1;
PImage pauseBtn2;

int dimSize = 900; //window size
float Score = -14.6; //Loading Bar counter (is intiliazed as -14.6 because of the click on the button, change it later)
int screen = 0; //Screen counter

int FrameCounter = 0;

PFont myFont;

PGraphics TopLayer; //Use this class if you need to draw into an off-screen graphics buffer

Movie ShadowDance;

boolean BtnStartOver = false;
boolean BtnScoreOver = false;
boolean BtnExitOver = false;
boolean BtnBackOver = false;
boolean circleOver = false;

//rect of the "New Game" rectangle
int rectStartX, rectStartY;
int sizeStartX, sizeStartY;

//rect of the "High Score" rectangle
int rectScoreX, rectScoreY;
int sizeScoreX, sizeScoreY;

//rect of the "Exit" rectangle
int rectExitX, rectExitY;
int sizeExitX, sizeExitY;

//rect of the "Back" button
int rectBackX, rectBackY;
int sizeBackX, sizeBackY;

//circle of the "pause" button
int circleX, circleY;
int circleSize = 96;

//High scores table
Table table;

void setup() {
  size(900, 900);
  
  
  TopLayer = createGraphics(900, 900);
  
  //load images
  UpBtn = loadImage("Up.png");
  RightBtn = loadImage("Right.png");
  LeftBtn = loadImage("Left.png");
  DownBtn = loadImage("Down.png");
  LevelBar = loadImage("LevelBar3.png");
  LevelBar.resize(408, 204);
  pauseBtn1 = loadImage("pause.png");
  pauseBtn1.resize(43, 64);
  pauseBtn2 = loadImage("pause.png");
  pauseBtn2.resize(32, 48);
  
  //load background
  backImage = loadImage("back.png");
  backImage.resize(dimSize, dimSize);
     
  //music
  
  
  
  
  //font
  myFont = createFont("AIJFont.ttf", 30);
  textFont(myFont);
  
  //video (REMEMBER TO PUT THE VIDEO IN A FOLDER CALLED "data")
  ShadowDance = new Movie(this, "ShadowDance.mp4");
  ShadowDance.loop();
  
  //rect of the "New Game" Button
  rectStartX = width/2;
  rectStartY = height/2 + 190;
  sizeStartX = 390;
  sizeStartY = 50;
  
  //rect of the "High Scores" Button
  rectScoreX = width/2;
  rectScoreY = height/2 + 250;
  sizeScoreX = 500;
  sizeScoreY = 50;
  
  //rect of the "Exit" Button
  rectExitX = width/2;
  rectExitY = height/2 + 310;
  sizeExitX = 180;
  sizeExitY = 50;
  
  //rect of the "Back" Button
  rectBackX = width/2;
  rectBackY = height/2 + 310;
  sizeBackX = 220;
  sizeBackY = 50;
  
  //circle of the "pause" Button
  circleX = 81;
  circleY = 102;
  
  
  //load the .csv file in which are stored the high scores
  table = loadTable("HighScore.csv", "header");
  
}

// We control which screen is active by settings / updating
// gameScreen variable. We display the correct screen according
// to the value of this variable.
//
// 0: Initial Screen
// 1: Level 1
// 2: Level 2
// 3: Level 3
// 4: High Scores

void draw() {
  if(screen == 0) {
    initScreen();     
  }
  
   if(screen == 1) {
     levelOne();
  } 
  
  if(screen == 4) {
     HighScores();
  }  
  
}

/********* SCREEN CONTENTS *********/

/********* MAIN MENU **********/
void initScreen() {
  update(mouseX, mouseY);
  
  //I set a black background
  background(0);
 
  fill(200);
  textSize(60);   
  textAlign(LEFT);
  text("  \nDance\n    Dance\n        Revolution", 100, 210);
  
  //rectangular background for the "New Game" Button
  noStroke();
  fill(0);
  rectMode(CENTER);
  rect(rectStartX, rectStartY, sizeStartX, sizeStartY);
  rect(rectScoreX, rectScoreY, sizeScoreX, sizeScoreY);
  rect(rectExitX, rectExitY, sizeExitX, sizeExitY);
  
  TopLayer.beginDraw();
    //this if command changes the background color 
    if(FrameCounter == 20){
      TopLayer.colorMode(HSB);
      TopLayer.tint(random(255), 255, 255);
      
      FrameCounter = 0;
    }
  TopLayer.image(ShadowDance, width-475, 30);
  TopLayer.endDraw();
  
  image(TopLayer,0,0);
  
  noTint();
  
  //checks if the mouse is over the "New Game Button" it highlights it changing color
  textSize(60);
  if (BtnStartOver) {
    fill(200); 
  } else {
    fill(100);
  }  
     
  textAlign(CENTER, CENTER);
  text("New Game", width/2, height/2+180);
  
  //checks if the mouse is over the "High Scores" Button it highlights it changing color
  if (BtnScoreOver) {
    fill(200); 
  } else {
    fill(100);
  }  
    
  textAlign(CENTER, CENTER);
  text("High Scores", width/2, height/2+240);
  
  //checks if the mouse is over the "Exit" Button it highlights it changing color
  if (BtnExitOver) {
    fill(200); 
  } else {
    fill(100);
  }  
    
  textAlign(CENTER, CENTER);
  text("Exit", width/2, height/2+300);
   
  //update the framecounter
  FrameCounter = FrameCounter + 1;
}

/*********LEVEL 1**********/
void levelOne() {
  update3(mouseX, mouseY);
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
  rectMode(CORNER);
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
  
  if (circleOver) {
    fill(20,75);
    noStroke();
    ellipseMode(CENTER);
    ellipse(circleX, circleY,circleSize, circleSize);
    image(pauseBtn1,59,72);
  } else {
    fill(140,75);
    noStroke();
    ellipseMode(CENTER);
    ellipse(circleX, circleY,circleSize, circleSize);
    image(pauseBtn2,65,80);
   
  }
  
  //Point Bar   
  image(LevelBar, 0, 0);
  
  //Level Text inside the Point Bar
  textSize(25);
  fill(240, 236, 238);
  textAlign(CENTER, CENTER);
  //text("Lv.1", 80, 100);  
  text("Livello 1", 295, 65);
  FrameCounter = FrameCounter + 1;
}

/********* HIGH SCORES WINDOW *********/
//Here in this tab should be called a .txt file where the best scores should be listed
void HighScores() {
  update2(mouseX, mouseY);

  background(0);
  textSize(60);
  fill(240, 236, 238);
  textAlign(CENTER, CENTER);
  text("HIGH SCORES", width/2, 100);
  int ind = 350;
  
  textSize(60);
  if (BtnBackOver) {
    fill(200); 
  } else {
    fill(100);
  }  
     
  textAlign(CENTER, CENTER);
  text("Back", width/2, height/2+300);
  
  for (TableRow row : table.rows()) {
    String name = row.getString("name");
    int points = row.getInt("score");
    //println(name + ".........." + points);
    textSize(40);
    fill(240, 236, 238);
    textAlign(LEFT);
    text(name + ".........." + points, 170, ind);  
    ind = ind + 50;
  }

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
  screen = screen + 1;
}

void update(int x, int y) {
  if (overBtn(rectStartX, rectStartY, sizeStartX, sizeStartY)) {
    BtnStartOver = true;
    BtnExitOver = false;
    BtnScoreOver = false;
  } else if (overBtn(rectScoreX, rectScoreY, sizeScoreX, sizeScoreY)) {
    BtnStartOver = false;
    BtnScoreOver = true;
    BtnExitOver = false;
  } else if (overBtn(rectExitX, rectExitY, sizeExitX, sizeExitY)) {
    BtnStartOver = false;
    BtnScoreOver = false;
    BtnExitOver = true;   
  }  
  else {
    BtnStartOver = false;
    BtnScoreOver = false;
    BtnExitOver = false;    
  }
}

void update2(int x, int y) {
  if (overBtn(rectBackX, rectBackY, sizeBackX, sizeBackY)) {
    BtnBackOver = true;
  }     
  else {
   BtnBackOver = false; 
  }
}

void update3(int x, int y) {
  if ( overCircle(circleX, circleY, circleSize) ) {
    circleOver = true;
  }
   else {
    circleOver = false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
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
  if (BtnStartOver) {
    ShadowDance.stop();
    BtnStartOver = false;
    Score = -14.6;
    changeScreen();   
  }
  
  if (BtnScoreOver) {
    ShadowDance.stop();
    BtnScoreOver = false;
    screen = 4;   
  }
  
  if (BtnExitOver) {
    ShadowDance.stop();
    BtnStartOver = false;
    exit();    
  }
  
  if (BtnBackOver) {
    BtnBackOver = false;
    ShadowDance.loop();
    screen = 0;  
  }
  
  if(circleOver){
  noLoop();
  }
}


    