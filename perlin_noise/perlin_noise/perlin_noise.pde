import ddf.minim.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import ddf.minim.analysis.*;
import com.hamoid.*;

Minim minim;
BeatDetect beat;
AudioPlayer song;
VideoExport videoExport;

float inc = 0.1;
float scl = 50;
int cols, rows, count;
float zOff = 0.0;
Particle[] particles;
PVector[] flowfield;
float kickSize, snareSize, hatSize;

float movieFPS = 60;
float soundDuration = 20.03;

void setup() {
  size(500, 500, P2D);
  
  videoExport = new VideoExport(this, "circle_deep.mp4");
  videoExport.setFrameRate(movieFPS);
  videoExport.setAudioFileName("deep.mp3");
  
  minim = new Minim(this);
  song = minim.loadFile("data/deep.mp3", 1024);
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 32;
  song.play();

  cols = floor(width/scl);
  rows = floor(height/scl);
  
  colorMode(HSB, 255);
  
  flowfield = new PVector[201];
  particles = new Particle[100];
  for (int i =0; i <100; i++){
    particles[i] = new Particle();
  }

  background(0, 0, 0);
  videoExport.startMovie();

}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}

void draw() {
  beat.detect(song.mix);
  
   float yOff = 0.0;
   for (int y=0; y < rows; y++){
     float xOff = 0.0;
        for (int x=0; x <cols; x++){
          int index = x+y*cols;
          float angle = noise(xOff, yOff,zOff) * PI;
          PVector v = PVector.fromAngle(angle);
          v.setMag(10);
          flowfield[index] = v; 
          xOff += inc;
         }
       yOff += inc;
       zOff += 0.001;
   }
   
   for (Particle particle : particles) {
     particle.follow(flowfield);
     particle.update(beat);
     particle.show(beat);
     particle.edges();
   }
   
  kickSize = constrain(kickSize * 0.92, 8, 32);
  snareSize = constrain(snareSize * 0.92, 8, 32);
  hatSize = constrain(hatSize * 0.92, 8, 32);
   
  println(frameRate);
  //rect(frameCount * frameCount % width, 0, 40, height);
  videoExport.saveFrame();
  
  if(frameCount > round(movieFPS * soundDuration)) {
    videoExport.endMovie();
    exit();
  } 
}

class Particle {
  PVector pos, vel, acc, prevPos;
  int maxSpeed, h;
  
  Particle(){
    this.pos = new PVector(random(width), random(height));
    this.vel = new PVector(0,0);
    this.acc = new PVector(0,0);
    this.maxSpeed = 2;
    this.h = 1;
    this.prevPos = this.pos.copy();
  }
  
  void update(BeatDetect beat){
    
  if ( beat.isKick() ) kickSize = 32;
  if ( beat.isSnare() ) snareSize = 32;
  if ( beat.isHat() ) hatSize = 32;
  
    if (beat.isKick()){
      this.vel.lerp(this.acc.mult(3), .8);
      this.vel.limit(this.maxSpeed*3);
    } else {
      this.vel.lerp(this.acc.mult(.2), .4);
      this.vel.limit(this.maxSpeed);
    }
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  void follow(PVector[] flowfield){
    int x = floor(this.pos.x/scl);
    int y = floor(this.pos.y/scl);
    int index = x+y*cols;
    PVector force = flowfield[index];
    this.applyForce(force);
  }
  
  void applyForce(PVector force){
    if (force == null){
      
    }else {
      this.acc.add(force);
    }
    
  }
  
  void show(BeatDetect beat){    
    if (beat.isKick()){
      this.h = this.h + 4;
    }
    if (beat.isSnare()){
      this.h = this.h + 2;
    }
    if (this.h > 200){
      this.h = 1;
    }
    float x = snareSize/32.0 + (this.h/200 + .01);
     float ease = x * x * x * (x * ( x * 6 -15) + 10);
     setColor(ease);
    //stroke(348, this.h, 60, 50);
    //fill(348, this.h, 60, 50);
    strokeWeight(snareSize+kickSize);
    //rotate(-PI/6);
    line(this.pos.x, this.pos.y, this.prevPos.x, this.prevPos.y);
    this.updatePrev();
  }
  
  void updatePrev(){
     this.prevPos.x = this.pos.x;
     this.prevPos.y = this.pos.y;
  }
  
  void edges() {
    if (this.pos.x > width){
      this.pos.x = 0;
      this.updatePrev();
    }
    if (this.pos.x < 0){
      this.pos.x = width;
      this.updatePrev();
    }
    if (this.pos.y > height){
      this.pos.y = 0;
      this.updatePrev();

    }
    if (this.pos.y < 0){
      this.pos.y = height;
      this.updatePrev();
    }
  }
}

void setColor(float ease){
  float rValue = red(ease);
  float gValue = green(ease);
  float bValue = blue(ease);
  fill(rValue, gValue, bValue, 50);
  stroke(rValue, gValue, bValue, 50);
  strokeWeight(1);
}

float red(float i){
  return rainbowConvert(i, 0);
}

float green(float i){
  return rainbowConvert(i, 0);
}

float blue(float i){
  return rainbowConvert(i, 2);
}

float rainbowConvert(float variable, int colorIdentifier){
  return sin((PI*2/2)*variable+colorIdentifier) * 128 + 127;
}