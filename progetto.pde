PImage freccia1;
PImage freccia2;
PImage freccia3;
PImage freccia4;
PImage frecce1;
PImage frecce2;
PImage frecce3;
PImage frecce4;

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

ArrayList<freccia> freccein; 
ArrayList<freccia> frecceout;

//va aggiunta una funzione che prenda le frecce da un file di testo che abbiamo preparato e idealmente 
//aggiunga a freccein tutte le frecce che servono, per ora aggiungo a frecce in 4 frecce
  //queste funzioni non funzionano, odio java, somebody help

   
void setup(){
  
  size(450 , 900);
     background(150);
     stroke(255);
     
freccein = new ArrayList<freccia>();
frecceout = new ArrayList<freccia>();
JSONArray frecce = loadJSONArray("canzone1.json");
for ( int i=0; i<frecce.size(); i++){
 JSONObject freccia = frecce.getJSONObject(i);
 int tempo = freccia.getInt("tempo");
 int colonna = freccia.getInt("colonna");
 int velocita = freccia.getInt("velocita");
 freccein.add(new freccia(tempo, colonna, velocita));
}
freccia1=loadImage("freccia1.png");
freccia2=loadImage("freccia2.png");
freccia3=loadImage("freccia3.png");
freccia4=loadImage("freccia4.png");
frecce1=loadImage("freccia1.png");
frecce2=loadImage("freccia2.png");
frecce3=loadImage("freccia3.png");
frecce4=loadImage("freccia4.png");

//for (int i=0;i <=3;i++){
//  freccein.add(new freccia(i*30,i+1,4));
//}
}
void draw(){
  background(150);
image(freccia1, 10, 30, 90, 90);
image(freccia2, 125, 30, 90, 90);
image(freccia3,240, 30, 90, 90);
image(freccia4, 355, 30, 90, 90);
//image(frecce1, 10, 300, 90, 90);
//image(frecce2, 125, 300, 90, 90);
//image(frecce3, 240, 300, 90, 90);
//image(frecce4, 355, 300, 90, 90);
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
for (int i=0;i<frecceout.size();i++){
  
  movimento(frecceout.get(i));
  if (frecceout.get(i).colonna==1)
  image(frecce1,10,frecceout.get(i).posizione,90,90);
  if (frecceout.get(i).colonna==2)
  image(frecce2,125,frecceout.get(i).posizione,90,90);
  if (frecceout.get(i).colonna==3)
  image(frecce3,240,frecceout.get(i).posizione,90,90);
  if (frecceout.get(i).colonna==4)
  image(frecce4,355,frecceout.get(i).posizione,90,90);
 if(frecceout.get(i).posizione==0)
 frecceout.remove(i);
}
}

void movimento (freccia f){
 f.posizione=f.posizione-f.velocita; 
}
