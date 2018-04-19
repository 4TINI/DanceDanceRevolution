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
  public int stato;
  public int velocita;
};
ArrayList<freccia> freccein =new ArrayList<freccia>();

//va aggiunta una funzione che prenda le frecce da un file di testo che abbiamo preparato e idealmente 
//aggiunga a freccein tutte le frecce che servono, per ora aggiungo a frecce in 4 frecce
  //queste funzioni non funzionano, odio java, somebody help
 public void settempo( int tempof ) {
      tempo = tempof;
   }
   
public void setcolonna( int colonnaf ) {
      colonna = colonnaf;
   }
   
 public void setposizione( int posizionef ) {
      posizione = posizionef;
   }
   
 public void setstato( int statof ) {
      stato = statof;
   }
 public void setvelocita( int velocitaf ) {
      velocita = velocitaf;
   }
   
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

//questa parte è solo per prova
freccein.add(new freccia());
freccein.add(new freccia());
freccein.add(new freccia());
freccein.add(new freccia());
for (int i=0;i <freccein.size(0);i++){
freccia temp = freccein.get(0);
freccein.remove(0);
temp.settempo(i);
temp.setcolonna(i);
temp.setstato(1);
temp.setvelocita(5);
temp.setposizione(0);
freccein.add(temp);}

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
