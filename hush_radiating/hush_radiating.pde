int innerRadius = 75;
int lineLength = 150;
int outerRadius = innerRadius+lineLength;
int numLines = 40;
float linePosition = 0;

void setup(){
  size(500, 500);
}

void draw(){
  background(0);

  translate(width/2, height/2);
  int diameter = 10;
  
  for (int i=0; i < numLines; i++){
    int z = floor((i + linePosition)) % numLines;
    int angle = (360/numLines)*z;
    float rads = radians(angle);
    pushMatrix();
    stroke(125);
    strokeWeight(2);
    rotate(rads);
    line(0,innerRadius, 0, lineLength+innerRadius);
    
    stroke(255);
    strokeWeight(1);
    fill(255);
    float x = abs(10.0 - (i  - 10.0)) / 20.0;
    float perlin = x * x * x * (x * ( x * 6 -15) + 10);
    float result = innerRadius+(perlin*lineLength);
    ellipse(
      0, 
      result,
      diameter * (2 * (perlin + .5)), 
      diameter * (1.5 * (perlin + .5))
    );
    
    popMatrix();
  }

  noFill();
  int circlePlace = 350;
  stroke(0,0,0,100);
  for (int i=circlePlace-100; i < circlePlace+50; i++){
      ellipse(0,0,i,i);
  }
  
  stroke(255,255,255,500);
  for (int i=circlePlace; i < circlePlace+10; i++){
      ellipse(0,0,i,i);
  }

  linePosition += 0.8; 
}