import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
AudioInput lineIn;
//ArrayList<Line> beatLines = new ArrayList<Line>();
//ArrayList<Line> leftLines = new ArrayList<Line>();

//int lines = 10;
//int renderCount;
float progression, kickSize, snareSize, hatSize;


int cuantos = 200;
Pelo[] lista ;
float[] z = new float[cuantos]; 
float[] phi = new float[cuantos]; 
float[] largos = new float[cuantos]; 
float radio;
float rx = 0;
float ry =0;

void setup() {
  size(640, 360, P3D);
  
   minim = new Minim(this);
  lineIn = minim.getLineIn(Minim.STEREO, 512);
  beat = new BeatDetect(lineIn.bufferSize(), lineIn.sampleRate());
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  bl = new BeatListener(beat, lineIn);  
  progression = 0;
  
  radio = height/3;
  lista = new Pelo[cuantos];
  for (int i=0; i<cuantos; i++) {
    lista[i] = new Pelo();
  }
  noiseDetail((int)snareSize);
}

void draw() {
  
  background(255);
  translate(width/2, height/2);

  //cuantos = beat.detectSize() * 15;

  float rxp = ((450/kickSize*3-(width/2))*0.005);
  float ryp = ((200/kickSize*3-(height/2))*0.005);
  rx = (rx*0.9)+(rxp*0.1) * kickSize/100;
  ry = (ry*0.9)+(ryp*0.1) * kickSize/100;

  rotateY(rx);
  rotateX(ry);
  noFill();
  noStroke();
  sphereDetail(3, 3);
  sphere(radio);
println("radio: " + radio);
  for (int i = 0; i < cuantos; i++) {
    lista[i].dibujar();
  }
  
  if ( beat.isKick() ) kickSize = 30;
  if ( beat.isSnare() ) snareSize = 30;
  if ( beat.isHat() ) hatSize = 32;
  
  progression += 0.001 * kickSize/2;

  kickSize = constrain(kickSize * 0.99, 5, 30);
  snareSize = constrain(snareSize * 0.99, 5, 30);
  
  //println("rx: " + rx);
  //println("ry: " + ry);
}


class Pelo {

  float z = random(-radio, radio);
  float phi = random(TWO_PI);
  float largo = random(1,2 * (ease(progression)));
  float theta = asin(z/radio);

  void dibujar() {
    float off = 100  + (( progression + millis()*kickSize/200 * 0.0005)-4.2) * 0.7;
    float offb = 10  + (( progression* 0.0007)-0.2) * 0.1;

    float thetaff = theta+off;
    float phff = phi+offb;
    
  //        println("thetaff: " + thetaff);
  //println("phff: " + phff);
    float x = radio * cos(theta) * cos(phi);
    float y = radio * cos(theta) * sin(phi);
    float z = radio * sin(theta);

    float xo = radio * cos(thetaff) * cos(phff);
    float yo = radio * cos(thetaff) * sin(phff);
    float zo = radio * cos(thetaff);

    float xb = xo * largo;
    float yb = yo * largo;
    float zb = zo * largo;

    beginShape();
    noFill();
    stroke(0);
    strokeWeight(.35);
    vertex(x, y, z);
    quadraticVertex(xb*2, yb*2, zb*3, zb*2);
    endShape();
  //    println("xb: " + xb);
  //println("yb: " + yb);
  //println("zb: " + zb);
  }

}

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioInput source;
  
  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

float ease(float x){
  return x * x * x * (x * ( x * 6 -15) + 10);
  //return cos(PI * x) * cos(PI * x);
}