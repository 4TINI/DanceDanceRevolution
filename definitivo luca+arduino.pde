//**********LIBRARIES**********//
import processing.video.*;
import processing.sound.*;
import ddf.minim.*;
import processing.serial.*; 

//**********GLOBAL VARIABLES**********//


//*******ARDUINO*******//
Serial myPort;
String inString;
String val_in;
int num=0;


//***luca non lo so***//
PImage UpBtn, RightBtn, DownBtn, LeftBtn, LevelBar; //White Arrows Buttons
PImage UpArrow, RightArrow, LeftArrow, DownArrow;  //the images of the sliding arrows
PImage backImage;
PImage pauseBtn1;
PImage pauseBtn2;

int dimSize = 900; //window size
float Points = -14.6; //Loading Bar counter (is intiliazed as -14.6 because of the click on the button, change it later)
int screen = 0; //Screen counter

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

//music files
Minim minim;
AudioPlayer menuSong;
AudioPlayer song1;

int inputcolonna=1;
int score = 100;
boolean carlo = false; //questa variabile serve a non far entrare mai il programma nell'if in cui riceve l'input, che va ancora elaborato
public class freccia
 {
   public int tempo;
   public int colonna;
   public int posizione;
   public int velocita;
   
   public freccia(int tempo, int colonna, int velocita){
     this.tempo=tempo;
     this.colonna=colonna;
     this.posizione=900;
     this.velocita=velocita;
   }
     
 };

public class scritte
{
  public String scritta;
  public int tempo;  
  public scritte(String scritta, int tempo){
  this.scritta=scritta;
  this.tempo=tempo;
  }
};
ArrayList<freccia> freccein; 
ArrayList<freccia> frecceout;
ArrayList<scritte> risultati; 

void setup() {
  size(900, 900);
    
  TopLayer = createGraphics(900, 900);
  
  //Arduino
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n');
    

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
  song1 = minim.loadFile("blue.mp3");
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
  
  //circle of the "pause" Button
  circleX = 81;
  circleY = 102;
 
  //load the .csv file in which are stored the high scores
  table = loadTable("HighScore.csv", "header");
  
  //Here we'll be dealing woth the sliding arrows
  risultati = new ArrayList<scritte>();
  freccein = new ArrayList<freccia>();
  frecceout = new ArrayList<freccia>();
  JSONArray frecce = loadJSONArray("canzone_1.json");
  for ( int i=0; i<frecce.size(); i++){
  JSONObject freccia = frecce.getJSONObject(i);
  int tempo = freccia.getInt("tempo");
  int colonna = freccia.getInt("colonna");
  int velocita = freccia.getInt("velocita");
  freccein.add(new freccia(tempo, colonna, velocita));
 }
  
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
// 5: Pause Menù
 

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
  rect(129, 87, Points, 32); //everytime I click the mouse the width of the bar grows
  
  //this if command checks if the target point is reached
  if (Points > 246) {
  textSize(60);
  fill(240, 236, 238);
  textAlign(CENTER, CENTER);
  text("YOU WIN!", width/2, height/2);
  noLoop(); //if the point target is reached it stops the loop
  song1.close();
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
  
  //From now on the code is related to the sliding arrows
  if (freccein.size()!=0){
    for (int i=0;i<freccein.size();i++){
      freccein.get(i).tempo=freccein.get(i).tempo-1;
      if(freccein.get(i).tempo==0){
      frecceout.add(freccein.get(i));
      freccein.remove(i);
      i--;
      }
    }
  }
  
  //if(carlo){
  //qui va inserito l'input di arduino
  
  for (int i=0;i<frecceout.size();i++){
    if (frecceout.get(i).colonna == inputcolonna){
      if(num>400){  
          if(abs(frecceout.get(i).posizione - 30)<10){
          scrivere ("Perfetto!");
          score = score+5;
          if (score > 100)
          score = 100;
          frecceout.remove(i);
          carlo = false;
          break;
          }
          else if(abs(frecceout.get(i).posizione - 30)<30){
          scrivere ("Grande!");
          score=score+3;
          if (score > 100)
          score = 100;
          frecceout.remove(i);
          carlo = false;
          break;
          }
          else  if(abs(frecceout.get(i).posizione - 30)<50){
          scrivere ("Buono!");
          score=score+2;
          if (score > 100)
          score=100;
          frecceout.remove(i);
          carlo = false;
          break;
          }
          else if(abs(frecceout.get(i).posizione - 30)<70){
          scrivere ("OK!");
          frecceout.remove(i);
          carlo = false;
          break;
          }
          else if(abs(frecceout.get(i).posizione - 30)<90){
          scrivere ("Cattivo!");
          score = score - 3;
          frecceout.remove(i);
          carlo = false;
          break;
          }
      }
    }
  }
//}
  
  if(inputcolonna==4)
      inputcolonna=1;
  else
      inputcolonna++;

for (int i=0;i<frecceout.size();i++){
  movimento(frecceout.get(i));
  if (frecceout.get(i).colonna == 1)
  image(LeftArrow, 400, frecceout.get(i).posizione);
  if (frecceout.get(i).colonna == 2)
   image(DownArrow, 510, frecceout.get(i).posizione);
  if (frecceout.get(i).colonna == 3)
   image(UpArrow, 620, frecceout.get(i).posizione);
  if (frecceout.get(i).colonna == 4)
   image(RightArrow, 730, frecceout.get(i).posizione);
  if(frecceout.get(i).posizione==0){
    frecceout.remove(i);
    scrivere ("Mancato!");
    score=score-10;
  }
}  

if (risultati.size()!=0){
  for (int i=0;i<risultati.size();i++){
  text(risultati.get(i).scritta,350,200+(i*90));
  risultati.get(i).tempo= risultati.get(i).tempo-1;
  if (risultati.get(i).tempo==0)
  risultati.remove(i);
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
  int ind = 350;
  
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
    ind = ind + 50;
  }

}

/************PAUSE MENU***********/
void PauseMenu() {
  update4(mouseX, mouseY); 
  
  textSize(60);
  if (BtnBackOver2) {
    fill(200); 
  } else {
    fill(150);
  }  
     
  textAlign(CENTER, CENTER);
  text("Back", width/2, height/2+300);
}

/********* OTHER METHODS AND FUNCTIONS *********/
void mouseClicked() {
  Points = Points + 14.6;  
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
    BtnBackOver1 = true;
  }     
  else {
   BtnBackOver1 = false; 
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

void update4(int x, int y) {
  if (overBtn(rectBackX, rectBackY, sizeBackX, sizeBackY)) {
    BtnBackOver2 = true;
  }     
  else {
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
    Points = -14.6;     
    BtnStartOver = false;
    changeScreen();
    delay(2000);  
    song1.play();
    
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
  
  if (BtnBackOver1) {
    BtnBackOver1 = false;
    ShadowDance.loop();
    screen = 0;  
  }
  
  if (BtnBackOver2) {
    BtnBackOver2 = false;
    menuSong.loop();
    ShadowDance.loop();
    screen = 0;  
  }
  
  if(circleOver){
  song1.pause();
  circleOver = false;
  fill(50,120);
  rect(0, 0,900,900); 
  TopLayer.clear();
  screen = 5;
  }
}

void movimento (freccia f){
  f.posizione=f.posizione-f.velocita; 
 }
 
  void scrivere (String res){
  risultati.add(new scritte(res,60));
}

/*void keyPressed() {
  if (key == CODED) {
    carlo = true;
    if (keyCode == LEFT) {
      inputcolonna = 1;
    } else if (keyCode == DOWN) {
      inputcolonna = 2;
    } else if (keyCode == UP) {
      inputcolonna = 3;
    } else if (keyCode == RIGHT) {
      inputcolonna = 4;
    }
    
}


}    */


void serialEvent(Serial myPort) {
    
    val_in = myPort.readStringUntil('\n');
    //if (val_in != null) {
       //trim whitespace and formatting characters (like carriage return)
       val_in = trim(val_in);
       num =Integer.parseInt(val_in);
 /*      if(inputcolonna==4)
           inputcolonna=1;
       else
           inputcolonna++;*/
           
    println("freccia : " + num);
    //}
}
