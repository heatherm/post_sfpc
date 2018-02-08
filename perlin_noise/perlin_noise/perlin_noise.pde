import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import com.hamoid.*;

Minim minim;
BeatDetect beat;
AudioPlayer song;
VideoExport videoExport;

float inc = 0.01;
float scl = 50;
int cols, rows, count;
float zOff = 0.0;
Particle[] particles;
PVector[] flowfield;
float kickSize, snareSize, hatSize;

float soundDuration = 20.03;
String SEP = "|";
float movieFPS = 30;
float frameDuration = 1 / movieFPS;
BufferedReader reader;

void setup() {
  size(500, 500, P2D);
  
  frameRate(1000);
  String audioFilePath = "deep.mp3";
  
  audioToTextFile(audioFilePath);
  reader = createReader(audioFilePath + ".txt");
  
  videoExport = new VideoExport(this, "circle_deep.mp4");
  videoExport.setFrameRate(movieFPS);
  videoExport.setAudioFileName(audioFilePath);
  
  minim = new Minim(this);
  song = minim.loadFile("data/deep.mp3", 1024);
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 32; 
  
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
  String line;
  try {
    line = reader.readLine();
  }
  catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if ((line == null) || (frameCount > round(movieFPS * soundDuration))){
    videoExport.endMovie();
    exit();
  } else {
    String[] p = split(line, SEP);
    float soundTime = float(p[0]);

    while (videoExport.getCurrentTime() < soundTime + frameDuration * 0.5) {
      
      background(0);
      noStroke();

      for (int i=1; i<p.length; i++) {
        float value = float(p[i]);
        
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
           zOff += 0.00011;
         }
     
         for (Particle particle : particles) {
           particle.follow(flowfield);
           particle.update(value, i);
           particle.show(value, i);
           particle.edges();
         }
      }
      videoExport.saveFrame();
    }
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
  
  void update(float freqValue, int index){
    boolean isKick = ((index > 0 && index < 20) && freqValue > 150);
    boolean isSnare = (( index > 19 && index < 40 ) && freqValue > 150);
   
    if ( isKick ) kickSize = freqValue/3;
    if ( isSnare ) snareSize = freqValue/3;
    if ( index > 39 ) hatSize = freqValue/3;
    
    kickSize = constrain(kickSize * 0.92, 8, 32);
    snareSize = constrain(snareSize * 0.92, 8, 32);
    hatSize = constrain(hatSize * 0.92, 8, 32);
  
    if (isKick){
      this.vel.lerp(this.acc.mult(1.001), .8);
      this.vel.limit(this.maxSpeed*1.5);
    } else {
      this.vel.lerp(this.acc.mult(.002), .4);
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
  
  void show(float freqValue, int index){   
    boolean isKick = ((index > 0 && index < 20) && freqValue > 150);
    boolean isSnare = (( index > 19 && index < 40 ) && freqValue > 150);
    
    if (isKick){
      this.h = this.h + 4;
    }
    if (isSnare){
      this.h = this.h + 2;
    }
    if (this.h > 200){
      this.h = 1;
    }
    float x = snareSize/32.0 + (this.h/200 + .01);
     float ease = x * x * x * (x * ( x * 6 -15) + 10);
     setColor(ease);
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

void audioToTextFile(String fileName) {
  PrintWriter output;

  Minim minim = new Minim(this);
  output = createWriter(dataPath(fileName + ".txt"));

  AudioSample track = minim.loadSample(fileName, 2048);

  int fftSize = 1024;
  float sampleRate = track.sampleRate();

  float[] fftSamplesL = new float[fftSize];
  float[] fftSamplesR = new float[fftSize];

  float[] samplesL = track.getChannel(AudioSample.LEFT);
  float[] samplesR = track.getChannel(AudioSample.RIGHT);  

  FFT fftL = new FFT(fftSize, sampleRate);
  FFT fftR = new FFT(fftSize, sampleRate);

  fftL.logAverages(22, 3);
  fftR.logAverages(22, 3);

  int totalChunks = (samplesL.length / fftSize) + 1;
  int fftSlices = fftL.avgSize();

  for (int ci = 0; ci < totalChunks; ++ci) {
    int chunkStartIndex = ci * fftSize;   
    int chunkSize = min( samplesL.length - chunkStartIndex, fftSize );

    System.arraycopy( samplesL, chunkStartIndex, fftSamplesL, 0, chunkSize);      
    System.arraycopy( samplesR, chunkStartIndex, fftSamplesR, 0, chunkSize);      
    if ( chunkSize < fftSize ) {
      java.util.Arrays.fill( fftSamplesL, chunkSize, fftSamplesL.length - 1, 0.0 );
      java.util.Arrays.fill( fftSamplesR, chunkSize, fftSamplesR.length - 1, 0.0 );
    }

    fftL.forward( fftSamplesL );
    fftR.forward( fftSamplesL );

    StringBuilder msg = new StringBuilder(nf(chunkStartIndex/sampleRate, 0, 3).replace(',', '.'));
    for (int i=0; i<fftSlices; ++i) {
      msg.append(SEP + nf(fftL.getAvg(i), 0, 4).replace(',', '.'));
      msg.append(SEP + nf(fftR.getAvg(i), 0, 4).replace(',', '.'));
    }
    output.println(msg.toString());
  }
  track.close();
  output.flush();
  output.close();
}