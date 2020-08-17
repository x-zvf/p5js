PVector[] flowField;
int scale = 1;
int rows, cols;

float friction = 0.9f;
float noiseScale =1000f;
float zOff = 0;

ArrayList<Particle> particles;

int nParticles = 0;

void setup() {
  size(480, 480);
  colorMode(HSB);
  rows = height/scale;
  cols = width/scale;
  flowField = new PVector[rows * cols];
  particles = new ArrayList<Particle>();

  for (int i = 0; i<20000; i++) addParticle();
}

void addParticle() {
  Particle p = new Particle(new PVector(random(0, width), random(0, height)));
  //p.c = color(255.0f * (((++nParticles) * 1.0f/99.0f) % 1.0f), 250, 250);
  p.c = color(255, 127);
  particles.add(p);
}Q

void updateFF() {
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      flowField[x+y*cols] = PVector.fromAngle(4*TWO_PI * noise(x/noiseScale, y/noiseScale, zOff)).mult(0.1);
    }
  }
  zOff += 0.003;
}

void draw() {
  background(0);
  updateFF();
  loadPixels();
/*
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      pixels[x+y*cols] = color(flowField[x+y*cols].heading() * 255.0f / TWO_PI);
    }
  } */

 
  for (Particle p : particles) {
    p.followFF();
    p.update();
    p.draw();
  }
  //println(frameRate);
  updatePixels();
}

class Particle {
  PVector pos, vel, acc;
  color c;
  Particle(PVector pos) {
    this.pos = pos;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }

  void applyForce(PVector f) {
    this.acc.add(f);
  }
  void followFF() {
    int x = (int)pos.x / scale;
    int y = (int)pos.y / scale;
    if (y < 0 || x < 0 || x >= cols || y >= rows) return;
    applyForce(flowField[x + y]);
  }

  void draw() {
    int x = (int)pos.x;
    int y = (int)pos.y;
    if (y < 0 || x < 0 || x >= width || y >= height) return;
    pixels[x + y * cols] = c;
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    if (pos.x >= width) pos.x = 0;
    if (pos.y >= height) pos.y = 0;
    if (pos.x < 0) pos.x = width-1;
    if (pos.y < 0) pos.y = height-1;

    acc.mult(0);
    vel.mult(friction);
    vel.limit(3);
  }
}
