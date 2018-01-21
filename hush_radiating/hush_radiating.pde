int innerRadius = 75;
int lineLength = 150;
int outerRadius = innerRadius+lineLength;
int numLines = 40;
float linePosition = 0;
int circlePlace = 350;

void setup(){
  size(500, 500, P3D);
}

void draw(){
  background(0);

  translate(width/2, height/2);
  int diameter = 10;
  
  for (int i=0; i < numLines; i++){
    float zz = (i + linePosition) % numLines;
    int angle = (360/numLines)*i;
    float rads = radians(angle);
    pushMatrix();
    stroke(125);
    strokeWeight(2);
    rotate(rads);
    line(0,innerRadius, 0, lineLength+innerRadius);
    
    float t = zz % (numLines/4);
    float x = abs(2.5 - (t  - 2.5)) / 5.0;
    //float perlin = x * x * x * (x * ( x * 6 -15) + 10);
    float perlin = cos(PI * x) * cos(PI * x); 
    float result = innerRadius+(perlin*lineLength);
    
    float rValue = red(perlin);
    float gValue = green(perlin);
    float bValue = blue(perlin);
    fill(rValue, gValue, bValue);
    stroke(rValue, gValue, bValue);
    strokeWeight(1);

    if (t > 0 && t < 5){
      translate(0,0,1);
    }
    
    ellipse(
      0, 
      result,
      diameter * (2 * (perlin + .5)), 
      diameter * (1.5 * (perlin + .5))
    );
    
    popMatrix();
  }

  drawRing(0,0,0,100,-100,50);
  drawRing(255,255,255,500,0,10);

  linePosition += 0.02; 
}

void drawRing(int r, int g, int b, int a, int start, int end){
  noFill();
  stroke(r,g,b,a);
  for (int i=circlePlace+start; i < circlePlace+end; i++){
      ellipse(0,0,i,i);
  }
}

float red(float i){
  return rainbowConvert(i, 2);
}
float green(float i){
  return rainbowConvert(i, 0);
}
float blue(float i){
  return rainbowConvert(i, 4);
}
float rainbowConvert(float variable, int colorIdentifier){
  return sin((PI*2/2)*variable+colorIdentifier) * 128 + 127;
}