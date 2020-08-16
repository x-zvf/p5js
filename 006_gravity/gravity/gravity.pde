import java.util.ArrayList;
Body[] bodies = new Body[10];
float sw = 20;
void setup() {
  size(800,800);
  colorMode(HSB);
  background(0);
  for(int i = 0; i < bodies.length; i++) {
    bodies[i] = new Body();
    bodies[i].h = i*((255.0/(bodies.length-1.0))); 
  }
}

float expFalloff(float i, float n, float s, float e) {
   return s + ((e-s) * ((i+1)/n));
}

void draw() {
  
  
  
  for(int i = 0; i < bodies.length; i++) {
     for(int j = 0; j < bodies.length; j++) {
        if(i == j) continue;
          bodies[i].attract(bodies[j]);
      }
  }
  
  strokeWeight(sw);
  
  //translate(width/2, height/2);
  
  for(int i = 0; i < bodies.length; i++) {
    bodies[i].update();
    //point(bodies[i].pos.x, bodies[i].pos.y);
    int ps = bodies[i].positions.size();
    for(int j = 1; j < ps; j++){
      stroke(bodies[i].h, expFalloff(j, ps, 40, 255), expFalloff(j, ps, 0, 255));
      strokeWeight(expFalloff(j, ps, 0, sw));
      line(bodies[i].positions.get(j-1).x, bodies[i].positions.get(j-1).y, bodies[i].positions.get(j).x, bodies[i].positions.get(j).y); //<>//
    }
  }
  
  if((int)random(0,100) == 0) {
    int i = (int) random(0,bodies.length-1);
    bodies[i] = new Body();
    bodies[i].h = 255.0f*random(0,1); 
  }
  
}



class Body {
  PVector pos, vel, acc;
  float mass;
  float h;
  ArrayList<PVector> positions;
  public Body() {
   positions = new ArrayList<PVector>();
   randomize();
  }
  
  public void randomize() {
    mass = random(10, 100);
    pos = new PVector(random(0,width), random(0, height));
    vel = new PVector(0,0);
    acc = new PVector(0,0);
  }
  
  public void attract(Body b) {
    PVector force = PVector.sub(b.pos, pos);
    force.normalize();
    float dist = PVector.dist(b.pos, pos) - 2*sw;
    if(dist > 0) {
      force.div(pow(dist,2)); 
    } else {
      //force.mult(-1);
    }
    force.mult(mass * b.mass);
    force.limit(0.5);
    acc.add(force);
  }
  
  public void update() {

    acc.limit(2);
    
    vel.add(acc);
    acc.mult(0);
    pos.add(vel);
    vel.limit(10);
    vel.mult(0.99);
    if(pos.x >= (width-sw)){
      pos.x = width-sw;
      vel.x *= -0.1;
    }
    if(pos.y >= (height-sw)){
      pos.y = height-sw;
      vel.y *= -0.1;
    }
    if(pos.x <= (0-sw)){
      pos.x = sw;
      vel.x *= -0.1;
    }
    if(pos.y <= (0-sw)){
      pos.y = sw;
      vel.y *= -0.1;
    }
   positions.add(pos.copy());
   if(positions.size() > 50) {
      positions.remove(0);
   }
  }
 
}
