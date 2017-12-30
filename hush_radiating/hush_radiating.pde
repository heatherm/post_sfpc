int innerRadius = 75;
int lineLength = 150;
int outerRadius = innerRadius+lineLength;
int numLines = 40;

void setup(){
  size(500, 500);
  background(0);
  stroke(255);
  
  for (int i=0; i < numLines; i++){
    int angle = (360/numLines)*i;
    float rads = radians(angle);

    line(
      getX(innerRadius, rads),
      getY(innerRadius, rads),
      getX(outerRadius, rads),
      getY(outerRadius, rads)
    );
  }
}

float getX(int radius, float angle){
   return width/2 + radius * cos(angle);
}

float getY(int radius, float angle){
  return height/2 + radius * sin(angle);
}