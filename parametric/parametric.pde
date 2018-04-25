import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
ArrayList<Line> beatLines = new ArrayList<Line>();
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
float t;
int lines = 10;
AudioInput lineIn;
int count;


float kickSize, snareSize, hatSize;

class Line {
  float z, snare, kick;
  float[] rgb;
  
  Line(float z_, float[] colorVals, float snare_, float kick_){
    z = z_;
    rgb = colorVals;
    snare = snare_;
    kick = kick_;
  }
  
  void display(){
    if (rgb == null){
      stroke(40, 40, 40);
    } else {
      stroke(rgb[0], rgb[1], rgb[2]);
    }
    strokeWeight(snare/7.0);
    line(x1(z, snare),y1(z, kick),x2(z),y2(z));
  }
  
  float x1(float t, float snare){
    return sin(t/10) *snare*5 + sin(t/5)*20;
  }
  float y1(float t, float kick){
    return cos(t/10)*kick*5;
  }
  float x2(float t){
    return sin(t/10) *200 + sin(t)*2;
  }
  float y2(float t){
    return cos(t/20) * 200 + cos(t/12)*20;
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


float[] setColor(float ease){
  float rValue = red(ease);
  float gValue = green(ease);
  float bValue = blue(ease);
  float[] array = new float[3]; 
  array[0] = rValue;
  array[1] = gValue;
  array[2] = bValue;
  return array;
}

float red(float i){
  return rainbowConvert(i, 2);
}

float green(float i){
  return rainbowConvert(i, 2);
}

float blue(float i){
  return rainbowConvert(i, 2);
}

float rainbowConvert(float variable, int colorIdentifier){
  return sin((PI*2/2)*variable+colorIdentifier) * 30 + 120;
}

void setup()
{
  size(1200, 1200, P3D);
  
  minim = new Minim(this);
  lineIn = minim.getLineIn(Minim.STEREO, 512);
  //song = minim.loadFile("imnotright.mp3", 1024);
  //song.play();

  //beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat = new BeatDetect(lineIn.bufferSize(), lineIn.sampleRate());
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  bl = new BeatListener(beat, lineIn);  
  t = 0;
}

void draw()
{
  background(0);
  for (int i =0; i < count; i++){  

      beatLines.remove(0);
    
  }
  
  translate(width/2, height/2);
  lines = beat.detectSize();
  count = 0;
  for (int i = 0; i < lines; i++){
    if ( i < 9 && beat.isOnset(i) && beat.isRange(0, 8, 2))
    {
      float[] colorVals = setColor(cos(PI * kickSize) * cos(PI * kickSize));
      beatLines.add(new Line((t + i+ lines), colorVals, snareSize, kickSize));
      count++;
        t += 5.0/kickSize;

    }
    if ( i > 8 && i < 19 && beat.isOnset(i) && beat.isRange(9, 18, 2))
    {
      float[] colorVals = setColor(cos(PI * snareSize) * cos(PI * snareSize));
      beatLines.add(new Line((t + i+ lines), colorVals, snareSize, kickSize));
      count++;
        t += 5.0/snareSize;

    }
        if ( i > 18 && i < 27 && beat.isOnset(i) && beat.isRange(19, 26, 2))
    {
      float[] colorVals = setColor(cos(PI * hatSize) * cos(PI * hatSize));
      beatLines.add(new Line((t +i + lines), colorVals, snareSize, kickSize));
      count++;
        t += 5.0/hatSize;
    }
    beatLines.add(new Line((t+i), null, snareSize, kickSize));
    count++;
  }

    for (int i = 0; i < beatLines.size(); i++){
      beatLines.get(i).display();
    }

  
  if ( beat.isKick() ) kickSize = 32;
  if ( beat.isSnare() ) snareSize = 32;
  if ( beat.isHat() ) hatSize = 32;
  
  t += 0.2;

  kickSize = constrain(kickSize * 0.999, kickSize*.85, kickSize*1.02);
  snareSize = constrain(snareSize * 0.999, snareSize*.85, snareSize*1.02);
  hatSize = constrain(hatSize * 0.999, hatSize*.85, hatSize*1.02);
}