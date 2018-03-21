class Circle {
  float x,y,r;
  boolean growing;
  
  Circle(float x_, float y_){
    growing = true;
    x = x_;
    y = y_;
    r = 1;
  }
  
  void show(){
    stroke(255);
    strokeWeight(2);
    noFill();
    ellipse(x,y,r*2,r*2);
  }
  
  void grow(){
    if (growing){  
      r = r+2;
    }
  }
  
  boolean edges(){
    return (
      ((x+r) > width) ||
      ((x-r) < 0) ||
      ((y+r) > height) ||
      ((y-r) < 0)
      );
  }
}

ArrayList<Circle> circles;

void setup(){
  size(640,360);
  circles = new ArrayList<Circle>();
}

void draw(){
  background(0);
  frameRate(30);

  int total = 10;
  int count = 0;
  int attempts = 0;
  
  while (count < total){
    Circle newC = newCircle();
    if (newC != null){
      circles.add(newC);
      count++;
    } 
    attempts++;
    if (attempts > 40){
      noLoop();
      println("done");
      break;
    }
  }
  
  for(Circle c: circles){
    if (c.growing){
      if (c.edges()){
        c.growing = false;
      } else {
        for (Circle other: circles){
          if (c != other) {
            float d = dist(c.x,c.y, other.x, other.y);
            if ((d - 2) < (c.r + other.r)){
              c.growing = false;
              break;
            }
          }
        }
      }
    }
    c.show();
    c.grow();
  }
}

Circle newCircle(){
  float x = random(width);
  float y = random(height);
  
  boolean valid = true;
  
  for (Circle c : circles){
    float d = dist(x,y,c.x,c.y);
    if (d < c.r) {
      valid = false;
      break;
    }
  }
  
  if (valid){
    return new Circle(x,y);
  } else {
    return null;
  }
}