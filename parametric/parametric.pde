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
int sensitivity = 0;
int magnitude = 128;
int magFloor = 0;
float decay = 0.97;
float prog = 0.07;
int renderedLinesCap = 100;
int renderCount;
float progression, kickSize, snareSize, hatSize;

void setup()
{
  size(1200, 1200);
  
  minim = new Minim(this);
  lineIn = minim.getLineIn(Minim.STEREO, 512);
  beat = new BeatDetect(lineIn.bufferSize(), lineIn.sampleRate());
  beat.setSensitivity(sensitivity);  
  kickSize = snareSize = hatSize = magnitude;
  bl = new BeatListener(beat, lineIn);  
  progression = 0;
}

void draw()
{
  translate(width/2, height/3);
  background(0);
  
  //for (int i =0; i < renderCount; i++){  
  //    beatLines.remove(0);
  //} 
  
    if (beatLines.size() > renderedLinesCap){
    for (int i = 0; i < renderedLinesCap/2; i++){  
        beatLines.remove(0);
        i++;
    }
  }
  
  //if (leftLines.size() > renderedLinesCap){
  //  for (int i = 0; i < renderedLinesCap/10; i++){  
  //      leftLines.remove(0);
  //      i++;
  //  }
  //}
   
  lines = beat.detectSize();
  renderCount = 0;
  for (int i = 0; i < lines; i++){
    //if (beat.isKick() && i % 2 == 0)
    //{
    //  float[] colorVals = setColor( kickSize);
    //  leftLines.add(new Line((progression+i*2), colorVals, snareSize, kickSize, 20));
    //}
    
        if (i % 2 == 0)
    {
   float[] colorVals = setColor(kickSize);

    beatLines.add(new Line((progression+i), colorVals, snareSize, kickSize, 20));
    renderCount++;
    }
  }

//  for (int i = 0; i < leftLines.size(); i++){
//    leftLines.get(i).display(i);
//  }
  
  for (int i = 0; i < beatLines.size(); i++){
    beatLines.get(i).display(i);
  }
  
  if ( beat.isKick() ) kickSize = magnitude;
  if ( beat.isSnare() ) snareSize = magnitude;
  if ( beat.isHat() ) hatSize = magnitude;
  
  progression += prog;

  kickSize = constrain(kickSize * decay, magFloor, magnitude);
  snareSize = constrain(snareSize * decay, magFloor, magnitude);
  hatSize = constrain(hatSize * decay, magFloor, magnitude);
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
      stroke(rgb[0], rgb[2], rgb[1], 30);
    }
    strokeWeight(size);
    //line(x2(z),y2(z), x1(z, 32),y1(z, 32));
    
    line(
      x(kick, z*snare, floor(size)),
      y(snare, z, floor(size)),
      x(kick, z, floor(size)),
      y(snare, z, floor(size))
    );
  }
  
  float x(float bound, float val, int power){
    power = ((power %4) * 2)+1;
    return bound*3 * (pow(cos(val), power));
  }
  
  float y(float bound, float val, int power){
    power = ((power %4) * 2)+3;
    return bound*3 * (pow(sin(val), power));
  }
  
  //float x1(float z, float snare){
  //  return sin(snare);
  //}
  //float y1(float z, float kick){
  //  return cos(z/10)*kick*(kick %5);
  //}
  //float x2(float z){
  //  return sin(z/3) *200 + sin(z)*(z % 4);
  //}
  //float y2(float z){
  //  return cos(z/20) + cos(z/10);
  //}
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
  return cos(variable*colorIdentifier) * variable * variable + 30;
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