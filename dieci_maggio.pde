import processing.serial.*;
Serial myPort;

PImage freccia1;
PImage freccia2;
PImage freccia3;
PImage freccia4;
PImage frecce1;
PImage frecce2;
PImage frecce3;
PImage frecce4;
int tempo, colonna, stato, posizione, velocita;
String val_in;
int punti=0;


void setup(){
  
    size(450 , 900);
    background(150);
    stroke(255);
  
    printArray(Serial.list());
    myPort = new Serial(this, Serial.list()[2], 9600);
    myPort.bufferUntil('\n');
     

    freccia1=loadImage("freccia1.png");
    freccia2=loadImage("freccia2.png");
    freccia3=loadImage("freccia3.png");
    freccia4=loadImage("freccia4.png");
    frecce1=loadImage("frecce1.png");
    frecce2=loadImage("frecce2.png");
    frecce3=loadImage("frecce3.png");
    frecce4=loadImage("frecce4.png");
    
}
 int x=900;
void draw(){
    background(0);
    image(freccia1, 10, 30, 90, 90);
    image(freccia2, 125, 30, 90, 90);
    image(freccia3,240, 30, 90, 90);
    image(freccia4, 355, 30, 90, 90);
    image(frecce1, 10, 300, 90, 90);
    image(frecce2, 125, x, 90, 90);
    image(frecce3, 240, 300, 90, 90);
    image(frecce4, 355, 300, 90, 90);
   
    x--;
    
    textSize(18);
    text("punteggio= "+ punti, 10, 20); 
    fill(0, 102, 153); 

}

int i=0, num=0;
int preso=0, basta=0;
void serialEvent( Serial myPort) {
    val_in = myPort.readStringUntil('\n');
    if (val_in != null) {
       //trim whitespace and formatting characters (like carriage return)
       val_in = trim(val_in);
       num =Integer.parseInt(val_in);
       if(i==1)
           i=0;
       else
           i++;
       println("valore da " + i+ " : " + num);
       if((x>=25)&&(x<=125)&&(i==0)&&(preso==0)){
           if(num>1000){
               punti=punti+10;
               preso=1;
          }
       }
       if(preso==0){
           if((x<25)&&(i==1)&&(basta==0)){
               punti=punti-10;
               basta=1;
           }
       }
       else if((x==0)||(preso==1))
           basta=0;
       }
}
