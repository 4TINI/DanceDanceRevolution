PImage freccia1;
PImage freccia2;
PImage freccia3;
PImage freccia4;
PImage frecce1;
PImage frecce2;
PImage frecce3;
PImage frecce4;

void setup(){
  
  size(450 , 900);
     background(150);
     stroke(255);
     

freccia1=loadImage("freccia1.png");
freccia2=loadImage("freccia2.png");
freccia3=loadImage("freccia3.png");
freccia4=loadImage("freccia4.png");
frecce1=loadImage("frecce1.png");
frecce2=loadImage("frecce2.png");
frecce3=loadImage("frecce3.png");
frecce4=loadImage("frecce4.png");
}

void draw(){

image(freccia1, 10, 30, 90, 90);
image(freccia2, 125, 30, 90, 90);
image(freccia3,240, 30, 90, 90);
image(freccia4, 355, 30, 90, 90);
image(frecce1, 10, 300, 90, 90);
image(frecce2, 125, 300, 90, 90);
image(frecce3, 240, 300, 90, 90);
image(frecce4, 355, 300, 90, 90);

  


}
