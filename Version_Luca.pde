//**********LIBRARIES**********//
import processing.video.*;
import processing.sound.*;
import ddf.minim.*;

//**********GLOBAL VARIABLES**********//
PImage UpBtn, RightBtn, DownBtn, LeftBtn, LevelBar; //White Arrows Buttons
PImage UpArrow, RightArrow, LeftArrow, DownArrow;  //the images of the sliding arrows
PImage backImage;
PImage pauseBtn1;
PImage pauseBtn2;

int startTime; //a timing variable
int wait = 5000;
boolean check = true;

int dimSize = 900; //window size
int screen = 0; //Screen counter
int LevelIndex = 1;
int JsonIndex = 0;
String[] JsonFiles = {"canzone_1.json", "canzone_2.json", "canzone_3.json" };

int FrameCounter = 0; //to count frames and change the tint of the background every n frames

PFont myFont;

PGraphics TopLayer; //Use this class if you need to draw into an off-screen graphics buffer

Movie ShadowDance;

//here I list all the buttons of the game 
boolean BtnStartOver = false;
boolean BtnScoreOver = false;
boolean BtnExitOver = false;
boolean BtnBackOver1 = false;
boolean BtnBackOver2 = false;
boolean circleOver = false;
boolean BtnResumeOver = false;

boolean PerfectMatch = false;
boolean GreatMatch = false;
boolean NiceMatch = false;
boolean OkMatch = false;
boolean AlmoustMatch = false;
boolean MissMatch = false;
int ComboCounter = 0;

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

//rect of the "Back" button
int rectBack2X, rectBack2Y;
int sizeBack2X, sizeBack2Y;

//circle of the "pause" button
int circleX, circleY;
int circleSize = 96;

//rect of the "Resume Game" button
int rectResumeX, rectResumeY;
int sizeResumeX, sizeResumeY;

//High scores table
Table table;
int[] scoreList = new int[5];
ArrayList<TEXTBOX> textboxes = new ArrayList<TEXTBOX>();
boolean logged = false; // DEMO
String Text = "";

//music files
Minim minim;
AudioPlayer[] player = new AudioPlayer[3];
AudioPlayer menuSong;

int multiplier = 30;  //this is the time for a single result apperance
int columnInput;
int GeneralScore = 0;
int score = 100;
boolean carlo = false; //questa variabile serve a non far entrare mai il programma nell'if in cui riceve l'input, che va ancora elaborato

ArrayList<SlidingArrow> arrowsIn; 
ArrayList<SlidingArrow> arrowsOut;

/************SETUP*************/
void setup() {
  size(900, 900);
  
  TEXTBOX userTB = new TEXTBOX();
   userTB.X = width/2;
   userTB.Y = height/2;
   userTB.W = 300;
   userTB.H = 50;
   
   textboxes.add(userTB);
    
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
  
  UpArrow = loadImage("UpArrow.png");
  UpArrow.resize(120, 120);
  RightArrow = loadImage("RightArrow.png");
  RightArrow.resize(120, 120);
  LeftArrow = loadImage("LeftArrow.png");
  LeftArrow.resize(120, 120);
  DownArrow = loadImage("DownArrow.png");
  DownArrow.resize(120, 120);
  
  //load background
  backImage = loadImage("back.png");
  backImage.resize(dimSize, dimSize);
     
  //music
  minim = new Minim(this);
  menuSong = minim.loadFile("menuSong.mp3");  
  player[0] = minim.loadFile("blue2.mp3");
  player[1] = minim.loadFile("1.mp3");
  menuSong.loop();
    
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
  
  //rect of the "Back2" Button
  rectBack2X = width/2;
  rectBack2Y = height/2+60;
  sizeBack2X = 220;
  sizeBack2Y = 50;
  
  //rect of the "Resume Game" Button
  rectResumeX = width/2;
  rectResumeY = height/2;
  sizeResumeX = 525;
  sizeResumeY = 50;
  
  //circle of the "pause" Button
  circleX = 81;
  circleY = 102;
 
  //load the .csv file in which are stored the high scores
  table = loadTable("HighScore.csv", "header");
  for(int i = 0; i < table.getRowCount(); i++) {
    scoreList[i] = table.getInt(i, "score");
    println(scoreList[i]);
  }
  
  //Here we'll be dealing woth the sliding arrows
  
  arrowsIn = new ArrayList<SlidingArrow>();
  arrowsOut = new ArrayList<SlidingArrow>();
  
}

// We control which screen is active by settings / updating
// gameScreen variable. We display the correct screen according
// to the value of this variable.
//
// 0: Initial Screen
// 1: Levels
// 4: High Scores
// 5: Pause Menù
 

void draw() {
  if(screen == 0) {
    initScreen();     
  }
  
   if(screen == 1) {
     levels();
  } 
  
  if(screen == 4) {
     HighScores();
  }  
  
  if(screen == 5) {
     PauseMenu();
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
  text("quit", width/2, height/2+300);
   
  //update the framecounter
  FrameCounter = FrameCounter + 1;
}

/*********LEVEL STRUCTURE**********/
void levels() {   
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
  //this if command checks if the target point is reached
  if (score/5 > 248) {
    rect(129, 87, 248, 32);
  }
  else {
    
    rect(129, 87, score / 5, 32); //everytime I click the mouse the width of the bar grows  
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
   
  text("Livello " + LevelIndex, 295, 65);
  
  //From now on the code is related to the sliding arrows
  if (arrowsIn.size() != 0){
    for (int i = 0; i < arrowsIn.size(); i++){
      arrowsIn.get(i).time = arrowsIn.get(i).time-1;
      
      if(arrowsIn.get(i).time == 0){
      arrowsOut.add(arrowsIn.get(i));
      arrowsIn.remove(i);
      i--;
      }
    }
  }
  
  if(carlo){
  //qui va inserito l'input di arduino
   
  for (int i = 0; i < arrowsOut.size(); i++){
    if (arrowsOut.get(i).column == columnInput){
      
      if(abs(arrowsOut.get(i).position - 30) < 10){
      MissMatch = false;
      PerfectMatch = true;
      GreatMatch = false;
      NiceMatch = false;
      OkMatch = false;
      AlmoustMatch = false;
      score = score + 5 * ComboCounter;      
      arrowsOut.remove(i);
      carlo = false;
      ComboCounter = ComboCounter + 1;
      break;
      }
      
      else if(abs(arrowsOut.get(i).position - 30) < 30) {
      MissMatch = false;
      PerfectMatch = false;
      GreatMatch = true;
      NiceMatch = false;
      OkMatch = false;
      AlmoustMatch = false;
      score = score + 3 * ComboCounter;      
      arrowsOut.remove(i);
      carlo = false;
      ComboCounter = ComboCounter + 1;
      break;
      }
      
      else  if(abs(arrowsOut.get(i).position - 30) < 50){
      MissMatch = false;
      PerfectMatch = false;
      GreatMatch = false;
      NiceMatch = true;
      OkMatch = false;
      AlmoustMatch = false;
      score = score + 2 * ComboCounter;     
      arrowsOut.remove(i);
      carlo = false;
      ComboCounter = ComboCounter + 1;
      break;
      }
      
      else if(abs(arrowsOut.get(i).position - 30) < 70){
      MissMatch = false;
      PerfectMatch = false;
      GreatMatch = false;
      NiceMatch = false;
      OkMatch = true;
      AlmoustMatch = false;
      arrowsOut.remove(i);
      carlo = false;
      ComboCounter = ComboCounter + 1;
      break;
      }
      
      else if(abs(arrowsOut.get(i).position - 30) < 90){
      MissMatch = false;
      PerfectMatch = false;
      GreatMatch = false;
      NiceMatch = false;
      OkMatch = false;
      AlmoustMatch = true;
      score = score - 3;
      arrowsOut.remove(i);
      carlo = false;
      ComboCounter = ComboCounter + 1;
      break;
      }
    }
  }
}

//Here the actual sliding arrows are created and let slide
for (int i = 0; i < arrowsOut.size(); i++){
  movimento(arrowsOut.get(i));
  
  if (arrowsOut.get(i).column == 1)
  image(LeftArrow, 400, arrowsOut.get(i).position);
  
  if (arrowsOut.get(i).column == 2)
   image(DownArrow, 510, arrowsOut.get(i).position);
   
  if (arrowsOut.get(i).column == 3)
   image(UpArrow, 620, arrowsOut.get(i).position);
   
  if (arrowsOut.get(i).column == 4)
   image(RightArrow, 730, arrowsOut.get(i).position);
   
  if(arrowsOut.get(i).position == 0){
    arrowsOut.remove(i);
    MissMatch = true;
    PerfectMatch = false;
    GreatMatch = false;
    NiceMatch = false;
    OkMatch = false;
    AlmoustMatch = false;
    ComboCounter = 0;
    score = score - 10;
  }
}  

textSize(50);
fill(240, 236, 238);

if (ComboCounter > 0)
  text("Combo " + ComboCounter, 200, 350);
if (MissMatch)
  text("Miss", 200, 250);
else if(PerfectMatch)
  text("Perfect", 200, 250);
else if(GreatMatch)
  text("Great", 200, 250);
else if(NiceMatch)
  text("Nice", 200, 250);
else if(AlmoustMatch)
  text("Almoust", 200, 250);
else if(OkMatch)
  text("Ok", 200, 250);
  
  if (!player[LevelIndex-1].isPlaying() && score > 246) {
    if(check){
      startTime = millis();
      check = false;
    }
    if (LevelIndex == 2 && GeneralScore > scoreList[0]) {           
      if(millis() > startTime + 2000){ 
        textSize(40);
        text("Type your name!", width/2, height/2-100);
        text("(Enter to submit)", width/2, height/2+100);
        for (TEXTBOX t : textboxes) {
          t.DRAW();
        }
        if (logged) {
          table.removeRow(0);
          TableRow newRow = table.addRow();
          newRow.setString("name", Text);
          newRow.setString("score", str(GeneralScore));
          table.sort(1);
          
          for(int i = 0; i < table.getRowCount(); i++) {
            scoreList[i] = table.getInt(i, "score");
            println(scoreList[i]);
          }
          
          screen = 4;
          TopLayer.clear();
          menuSong.loop();
          score = 100;
          check = true;
        }
      }
      else {
        textSize(60);
        text("New Highscore!", width/2, height/2);  
      }
    }
    else {
      textSize(80);
      text("You Win!", width/2, height/2);      
      if(millis() > startTime + 5000){ 
        GeneralScore = GeneralScore + score;
        ReadJson();
        score = 100;
        BtnBackOver2 = false;
        MissMatch = false;
        PerfectMatch = false;
        GreatMatch = false;
        NiceMatch = false;
        OkMatch = false;
        AlmoustMatch = false;
        ComboCounter = 0;
        LevelIndex = LevelIndex + 1;
        JsonIndex = JsonIndex + 1;
        player[LevelIndex-1].play();
        check = true;
      }
    }
  }
  
  //if the score is not enough high you lose and you go back to the main menù
  else if (!player[LevelIndex-1].isPlaying() && score < 246) { 
    if(check){
      startTime = millis();
      check = false;
    }
    textSize(80);
    text("You Lost!", width/2, height/2); 
    if(millis() > startTime + 5000){     
      TopLayer.clear();
      menuSong.loop();
      score = 100;
      ShadowDance.loop();
      check = true;
      screen = 0;
    }
  }
  
  //if the score goes under zero it goes back to the main menù
  else if (score < 0) {
    if(check){
      startTime = millis();
      check = false;
    }
    player[LevelIndex-1].pause();
    textSize(80);
    text("You Lost!", width/2, height/2); 
    arrowsIn.clear();
    arrowsOut.clear();
    
    if(millis() > startTime + 5000){    
      TopLayer.clear();
      score = 100;
      LevelIndex = 1;     
      menuSong.loop();
      ShadowDance.loop();
      check = true;
      screen = 0;  
    }
  }  
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
  int ind = 550;
  
  textSize(60);
  if (BtnBackOver1) {
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
    ind = ind - 50;
  }

}

/************PAUSE MENU***********/
void PauseMenu() {
  update4(mouseX, mouseY); 
  textSize(60);
  //checks if the mouse is over the "High Scores" Button it highlights it changing color
  if (BtnResumeOver) {
    fill(200); 
  } else {
    fill(150);
  }  
    
  textAlign(CENTER, CENTER);
  text("Resume Game", width/2, height/2-10);
  
  if (BtnBackOver2) {
    fill(200); 
  } else {
    fill(150);
  }  
     
  textAlign(CENTER, CENTER);
  text("Back", width/2, height/2+50);
}

/********* OTHER METHODS AND FUNCTIONS *********/

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
    BtnBackOver1 = true;
  }     
  else {
   BtnBackOver1 = false; 
  }
}

void update3(int x, int y) {
  if (overCircle(circleX, circleY, circleSize)) {
    circleOver = true;
  }
   else {
    circleOver = false;
  }
}

void update4(int x, int y) {
  if (overBtn(rectBack2X, rectBack2Y, sizeBack2X, sizeBack2Y)) {
    BtnBackOver2 = true;
    BtnResumeOver = false;
  }     
  else if (overBtn(rectResumeX, rectResumeY, sizeResumeX, sizeResumeY)) {
   BtnResumeOver = true;
   BtnBackOver2 = false;    
  }
  else {
   BtnResumeOver = false;
   BtnBackOver2 = false;
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

//What happens when you click on a button
void mousePressed() {
  if (BtnStartOver) {
    ShadowDance.stop();
    menuSong.pause();
    menuSong.rewind();    
    BtnStartOver = false;
    ReadJson();     
    player[LevelIndex-1].rewind();
    player[LevelIndex-1].play();
    changeScreen();    
  }
  
  if (BtnScoreOver) {
    ShadowDance.pause();
    BtnScoreOver = false;
    screen = 4;   
  }
  
  if (BtnExitOver) {
    ShadowDance.stop();
    saveTable(table, "HighScore.csv");
    BtnStartOver = false;
    exit();    
  }
  
  if (BtnBackOver1) {
    BtnBackOver1 = false;
    ShadowDance.loop();
    screen = 0;  
  }
  
  if (BtnBackOver2) {
    BtnBackOver2 = false;
    MissMatch = false;
    PerfectMatch = false;
    GreatMatch = false;
    NiceMatch = false;
    OkMatch = false;
    AlmoustMatch = false;
    ComboCounter = 0;
    menuSong.loop();
    ShadowDance.loop();
    score = 100;
    LevelIndex = 1;
    arrowsIn.clear();
    arrowsOut.clear();    
    screen = 0;  
  }
  
  if(circleOver){
    player[LevelIndex-1].pause();
    circleOver = false;
    fill(50,120);
    rect(0, 0, 900, 900); 
    TopLayer.clear();
    screen = 5;
  }
  
  if(BtnResumeOver) {
    BtnResumeOver = false;
    player[LevelIndex-1].play();
    screen = 1;
  }
  
}

void movimento (SlidingArrow f){
  f.position = f.position - f.speed; 
}
 


//Here the code checks the keyboard keys pressed
void keyPressed() {
  if (key == CODED) {
    carlo = true;
    if (keyCode == LEFT) {
      columnInput = 1;
    } else if (keyCode == DOWN) {
      columnInput = 2;
    } else if (keyCode == UP) {
      columnInput = 3;
    } else if (keyCode == RIGHT) {
      columnInput = 4;
    }    
  }
  
  for (TEXTBOX t : textboxes) {
      if (t.KEYPRESSED(key, (int)keyCode)) {
         logged = true;
      }
   }
   
   if (keyCode == 32 && screen == 1) {
    player[LevelIndex-1].pause();
    fill(50,120);
    rect(0, 0, 900, 900); 
    TopLayer.clear();
    screen = 5;  
   }
   
   else if (keyCode == 32 && screen == 5) {
    player[LevelIndex-1].play();
    screen = 1; 
   }
}

void ReadJson(){
 JSONArray ArrowsList = loadJSONArray(JsonFiles[JsonIndex]);
  for (int i = 0; i < ArrowsList.size(); i++) {
    JSONObject SlidingArrow = ArrowsList.getJSONObject(i);
    int time = SlidingArrow.getInt("tempo");
    int column = SlidingArrow.getInt("colonna");
    int speed = SlidingArrow.getInt("velocita");
    arrowsIn.add(new SlidingArrow(time, column, speed));
  } 
}