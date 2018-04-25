import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
AudioInput lineIn;
ArrayList<Line> beatLines = new ArrayList<Line>();
ArrayList<Line> leftLines = new ArrayList<Line>();

int lines = 10;
int renderCount;
float progression, kickSize, snareSize, hatSize;

void setup()
{
  size(1200, 1200);
  
  minim = new Minim(this);
  lineIn = minim.getLineIn(Minim.STEREO, 512);
  beat = new BeatDetect(lineIn.bufferSize(), lineIn.sampleRate());
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = 16;
  bl = new BeatListener(beat, lineIn);  
  progression = 0;
}

void draw()
{
  background(0);
  for (int i =0; i < renderCount; i++){  
      beatLines.remove(0);
  } 
  if (leftLines.size() > 100){
    for (int i = 0; i < 10; i++){  
        leftLines.remove(0);
        i++;
    }
  }
  
  translate(width/2, height/2);
  
  lines = beat.detectSize();
  renderCount = 0;
  for (int i = 0; i < lines; i++){
    if (beat.isKick() && i % 3 == 0)
    {
      float[] colorVals = setColor( kickSize);
       leftLines.add(new Line((progression+i*2), colorVals, snareSize, kickSize, 20));

    }
    beatLines.add(new Line((progression+i), null, snareSize, kickSize, kickSize/4.0));
    renderCount++;
  }

  for (int i = 0; i < leftLines.size(); i++){
    leftLines.get(i).display(i);
  }
  
  for (int i = 0; i < beatLines.size(); i++){
    beatLines.get(i).display(i);
  }
  
  if ( beat.isKick() ) kickSize = 32;
  if ( beat.isSnare() ) snareSize = 32;
  if ( beat.isHat() ) hatSize = 32;
  
  progression += 0.1;

  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

class Line {
  float z, y, snare, kick, size;
  float[] rgb;
  
  Line(float z_, float[] colorVals, float snare_, float kick_, float size_){
    z = z_;
    rgb = colorVals;
    snare = snare_;
    kick = kick_;
    size = size_;
  }
  
  void display(int i){
    if (rgb == null){
      stroke(20,20,20, 160+i);
    } else {
      stroke(rgb[0], rgb[1], rgb[2], 50+i);
    }
    strokeWeight(size);
    line(x2(z),y2(z), x1(z, 32),y1(z, 32));
  }
  
  float x1(float z, float snare){
    return sin(snare);
  }
  float y1(float z, float kick){
    return cos(z/10)*kick*(kick %5);
  }
  float x2(float z){
    return sin(z/3) *200 + sin(z)*(z % 4);
  }
  float y2(float z){
    return cos(z/20) + cos(z/10);
  }
}

float red(float i){
  return rainbowConvert(i, 2);
}

float green(float i){
  return rainbowConvert(i, 4);
}

float blue(float i){
  return rainbowConvert(i, 0);
}

float rainbowConvert(float variable, int colorIdentifier){
  return sin((PI*2/2)*variable+colorIdentifier) * 128 + 127;
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