int innerRadius = 75;
int lineLength = 150;
int outerRadius = innerRadius+lineLength;
int numSpokes = 40;
int circlePlace = 350;
int diameter = 10;
float dx = 0;

void setup(){
  size(500, 500, P3D);
}

void draw(){
  background(0);
  translate(width/2, height/2);
  
  for (int spoke=0; spoke < numSpokes; spoke++){    
    pushMatrix();
    
    drawSpoke(spoke); 
    float ease = setXYZPositionBasedOnEasingFn(spoke, 4);
    setColor(ease);
    drawBall(ease);
    
    popMatrix();
  }

  drawRing(0,0,0,100,-100,50);
  drawRing(255,255,255,500,0,10);

  dx += 0.02; 
}

float setXYZPositionBasedOnEasingFn(float spoke, int divisions){
  float startSpoke = (spoke + dx) % numSpokes;
  int spokesPerDivision = numSpokes/divisions;
  float ballsEasingInPerDivision = spokesPerDivision / 2.0;
  float spokeWithinDivision = startSpoke % spokesPerDivision;
  float distanceFromMidSpoke = abs(ballsEasingInPerDivision/2 - (spokeWithinDivision  - ballsEasingInPerDivision/2.0)) / ballsEasingInPerDivision;
  float x = distanceFromMidSpoke;
  
  if (shouldBeInForeground(spokeWithinDivision, ballsEasingInPerDivision)){
    translate(0,0,1);
  }
  
  // Easing fns to try
  //return x * x * x * (x * ( x * 6 -15) + 10);
  return cos(PI * x) * cos(PI * x);
}

boolean shouldBeInForeground(float spokeWithinDivision, float ballsEasingInPerDivision){
  return spokeWithinDivision > 0 && spokeWithinDivision < ballsEasingInPerDivision;
}

void drawSpoke(int spoke){
  int spokeAngle = (360/numSpokes)*spoke;
  float spokeRadians = radians(spokeAngle);
  rotate(spokeRadians);
  
  stroke(125);
  strokeWeight(2);
  line(0,innerRadius, 0, lineLength+innerRadius);
}

void drawBall(float ease){
  float distanceFromInner = innerRadius+(ease*lineLength);
  ellipse(
    0, 
    distanceFromInner,
    diameter * (2 * (ease + .5)), 
    diameter * (1.5 * (ease + .5))
  );
}

void drawRing(int r, int g, int b, int a, int start, int end){
  noFill();
  stroke(r,g,b,a);
  for (int i=circlePlace+start; i < circlePlace+end; i++){
      ellipse(0,0,i,i);
  }
}

void setColor(float ease){
  float rValue = red(ease);
  float gValue = green(ease);
  float bValue = blue(ease);
  fill(rValue, gValue, bValue);
  stroke(rValue, gValue, bValue);
  strokeWeight(1);
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