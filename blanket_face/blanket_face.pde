//import ddf.minim.*;
//import ddf.minim.analysis.*;

//Minim minim;
//BeatDetect beat;
//BeatListener bl;
//AudioInput lineIn;
//float kickSize, snareSize, hatSize;
//VerletPhysics2D physics;
//Cluster cluster;

//void setup()
//{
//  size(600, 600);
  
//  minim = new Minim(this);
//  lineIn = minim.getLineIn(Minim.STEREO, 512);
//  beat = new BeatDetect(lineIn.bufferSize(), lineIn.sampleRate());
//  beat.setSensitivity(300);  
//  kickSize = snareSize = hatSize = 16;
//  bl = new BeatListener(beat, lineIn); 
  
//  physics = new VerletPhysics2D();
//  cluster = new Cluster(8,100,new Vec2D(width/2,height/2));
//}

//void draw()
//{
//  physics.update();

//  background(255);
//  cluster.display();

//  //progression += 0.1;

//  kickSize = constrain(kickSize * 0.95, 16, 32);
//  snareSize = constrain(snareSize * 0.95, 16, 32);
//  hatSize = constrain(hatSize * 0.95, 16, 32);
//}

//float red(float i){
//  return rainbowConvert(i, 2);
//}

//float green(float i){
//  return rainbowConvert(i, 4);
//}

//float blue(float i){
//  return rainbowConvert(i, 0);
//}

//float rainbowConvert(float variable, int colorIdentifier){
//  return sin((PI*2/2)*variable+colorIdentifier) * 128 + 127;
//}

//float[] setColor(float ease){
//  float rValue = red(ease);
//  float gValue = green(ease);
//  float bValue = blue(ease);
//  float[] array = new float[3]; 
//  array[0] = rValue;
//  array[1] = gValue;
//  array[2] = bValue;
//  return array;
//}

//class BeatListener implements AudioListener
//{
//  private BeatDetect beat;
//  private AudioInput source;
  
//  BeatListener(BeatDetect beat, AudioInput source)
//  {
//    this.source = source;
//    this.source.addListener(this);
//    this.beat = beat;
//  }
  
//  void samples(float[] samps)
//  {
//    beat.detect(source.mix);
//  }
  
//  void samples(float[] sampsL, float[] sampsR)
//  {
//    beat.detect(source.mix);
//  }
//}

class Cell
{
  PVector loc;
  color c;
  Cell(int _x, int _y, color _c)
  {
    loc = new PVector(_x, _y);
    c = _c;
  }
}

ArrayList<Cell> cells = new ArrayList<Cell>();
boolean use_manhattan = false;
void setup()
{
  size(400, 400);
  for(int i = 0; i < 5; ++i)
    cells.add(new Cell((int)random(0,width), (int)random(0,height), color(random(0,255), random(0,255), random(0,255))));
}

void draw()
{
  cells.get(0).loc.x = mouseX;
  cells.get(0).loc.y = mouseY;
  background(0);
  
  // Draw the voronoi cells
  drawVoronoi();
  
  // Draw the points
  for(int i = 0; i < cells.size(); ++i)
    ellipse(cells.get(i).loc.x, cells.get(i).loc.y, 5, 5);
}

void drawVoronoi()
{
  loadPixels();
  int offset = 0;
  
  // Iterate over every pixel
  for(int y = 0; y < height; y++)
  {
    for(int x = 0; x < width; x++)
    {
      float shortest = 1E12;
      int index = -1;
      
      // Find the closest cell
      for(int i = 0; i < cells.size(); ++i)
      {
        Cell cc = cells.get(i);
        float d;
        
        
        if(use_manhattan)
        {
          // Manhattan Distance
          d = abs(x - cc.loc.x) + abs(y - cc.loc.y);
        }
        else
        {
          // Euclidean distance, dont need to sqrt it since actual distance isnt important
          d = sq(x-cc.loc.x) + sq(y-cc.loc.y);
        }
        
        if(d < shortest)
        {
          shortest = d;
          index = i;
        }
      }
      // Set the pixel to the cells color
      pixels[offset++] = cells.get(index).c;
    }
  }
  updatePixels();
}

void keyPressed()
{
  if(key == 'a')
    cells.add(new Cell(mouseX, mouseY, color(random(0,255), random(0,255), random(0,255))));
  if(key == ' ')
    cells.subList(5, cells.size()).clear();
  if(key == 't')
    use_manhattan = !use_manhattan;
}