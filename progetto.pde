PImage freccia1;
PImage freccia2;
PImage freccia3;
PImage freccia4;
PImage frecce1;
PImage frecce2;
PImage frecce3;
PImage frecce4;
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


   
void setup(){
  
  size(900 , 900);
     background(150);
     stroke(255); 
risultati = new ArrayList<scritte>();
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

}
void draw(){
  background(150);
image(freccia1, 460, 30, 90, 90);
image(freccia2, 575, 30, 90, 90);
image(freccia3, 690, 30, 90, 90);
image(freccia4, 805, 30, 90, 90);
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
if(carlo){
  //qui va inserito l'input di arduino
  
for (int i=0;i<frecceout.size();i++){
 // if (frecceout.get(i).colonna=inputcolonna){
 //questo if è commentato perchè ancora non abbiamo una variabile inputcolonna
  if(abs(frecceout.get(i).posizione - 30)<10){
  scrivere ("Perfetto!");
  score=score+5;
  if (score>100)
  score=100;
  frecceout.remove(i);
  break;
  }
  else if(abs(frecceout.get(i).posizione - 30)<30){
  scrivere ("Grande!");
  score=score+3;
  if (score>100)
  score=100;
  frecceout.remove(i);
  break;
  }
 else  if(abs(frecceout.get(i).posizione - 30)<50){
  scrivere ("Buono!");
  score=score+2;
  if (score>100)
  score=100;
  frecceout.remove(i);
  break;
  }
  else if(abs(frecceout.get(i).posizione - 30)<70){
  scrivere ("OK!");
  frecceout.remove(i);
  break;
  }
 else if(abs(frecceout.get(i).posizione - 30)<90){
  scrivere ("Cattivo!");
  score=score-3;
  frecceout.remove(i);
  break;
  }
}
//}
}
for (int i=0;i<frecceout.size();i++){
  movimento(frecceout.get(i));
  if (frecceout.get(i).colonna==1)
  image(frecce1,460,frecceout.get(i).posizione,90,90);
  if (frecceout.get(i).colonna==2)
  image(frecce2,575,frecceout.get(i).posizione,90,90);
  if (frecceout.get(i).colonna==3)
  image(frecce3,690,frecceout.get(i).posizione,90,90);
  if (frecceout.get(i).colonna==4)
  image(frecce4,805,frecceout.get(i).posizione,90,90);
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
}

void movimento (freccia f){
 f.posizione=f.posizione-f.velocita; 
}
void scrivere (String res){
risultati.add(new scritte(res,60));
}
