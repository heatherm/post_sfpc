int innerRadius = 75;
int lineLength = 150;
int outerRadius = innerRadius+lineLength;
int numLines = 40;
float linePosition = 0;

void setup(){
  size(500, 500);
  background(0);
  stroke(255);
}

void draw(){
  background(0);
  
  for (int i=0; i < numLines; i++){
    int angle = (360/numLines)*i;
    float rads = radians(angle);

    line(
      getX(innerRadius, rads),
      getY(innerRadius, rads),
      getX(outerRadius, rads),
      getY(outerRadius, rads)
    );
    
    fill(255);
    int diameter = 10;
    float placeOnLine = (sin(linePosition) + 1) * lineLength/2;
    ellipse(
      getX(innerRadius + placeOnLine, rads), 
      getY(innerRadius + placeOnLine, rads), 
      diameter, 
      diameter
    );
  }
  
  linePosition += 0.02; 
}

float getX(float radius, float angle){
   return width/2 + radius * cos(angle);
}

float getY(float radius, float angle){
  return height/2 + radius * sin(angle);
}