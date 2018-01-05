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
  float widthOverTime = sin(linePosition) + 1;
  float placeOnLine = widthOverTime * lineLength/2;
  
  for (int i=0; i < numLines; i++){
    int angle = (360/numLines)*i;
    float rads = radians(angle);
    pushMatrix();
    stroke(125);
    strokeWeight(2);
    rotate(rads);
    line(0,innerRadius, 0, lineLength+innerRadius);
    
    stroke(255);
    strokeWeight(1);
    fill(255);
    ellipse(
      0, 
      innerRadius+placeOnLine, 
      diameter + (diameter/2)*widthOverTime, 
      diameter
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

  linePosition += 0.04; 
}