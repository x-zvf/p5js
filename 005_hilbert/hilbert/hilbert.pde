int drawOrder = 8;
int totalPoints = (int)pow(4, drawOrder);
int ci = 0;
int seglen;

PVector lastPos;

void setup() {
  size(1024,1024);
  seglen = (int) width / (int)pow(2,drawOrder);
  lastPos = new PVector(seglen/2, seglen/2);
  background(0);
  //stroke(255);
  strokeWeight(4);
  colorMode(HSB,totalPoints,1,1);
  
  while(ci < totalPoints) {
    drawHilbert();
  
    ci++;
  }
}

void draw() {
  /*
  if(ci == totalPoints) {
    ci = 1;
    lastPos = new PVector(seglen/2, seglen/2);
    background(0);
  }
  drawHilbert();
  
  ci++;*/
}

void drawHilbert() {
  stroke(ci,1,1);
  PVector cPos = hilbert(ci);
  cPos.mult(seglen);
  cPos.add(seglen/2, seglen/2);
  line(lastPos.x, lastPos.y, cPos.x, cPos.y);
  //text(ci, cPos.x + 5, cPos.y - 5);
  lastPos = cPos;
  
}
 //<>//
PVector hilbert(int i) {
  int z = i & 3;
  PVector[] order1 = {
    new PVector(0, 0), 
    new PVector(0, 1), 
    new PVector(1, 1), 
    new PVector(1, 0)
  };
  PVector vec = order1[z];

  for (int j = 1; j < drawOrder; j++) {
    i = i >>> 2;
    z = i & 3;
    float p = pow(2, j);
    
    float t;
    switch(z) {
      case 0:
        t = vec.x;
        vec.x = vec.y;
        vec.y = t;
        break;
      case 1:
        vec.y += p;
        break;
      case 2:
        vec.x += p;
        vec.y += p;
        break;
      case 3:
        t = p - 1 - vec.x;
        vec.x = p - 1 - vec.y;
        vec.y = t;
        vec.x += p;
        break;
    }
  }
  return vec;
}
