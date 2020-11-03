// From https://github.com/cmllngf/planet_1/blob/master/sketch.js by cmllngf 
// Edited by Yann Zavattero, https://yann.fzcommunication.fr/

int seed;
float t = 0;
int numberBelts = 1;
int dotsBelts = 500;

class Planet {

  private PVector center;
  private int precision;
  private float radius;
  
  private float rotateSpeed;
  
  private int nbMoons;
  
  private float beltProbability;
  private float beltYAxis;
  
  private float colored;

  Planet(PVector center, float radius, int precision, float rotateSpeed, int nbMoons, float beltProbability, float beltYAxis) {
    this.center = center;
    this.radius = radius;
    this.precision = precision;
    this.rotateSpeed = rotateSpeed;
    this.nbMoons = nbMoons;
    this.beltProbability = beltProbability;
    this.beltYAxis = beltYAxis;
    this.colored = random(100);
  }
  

  Planet(PVector center, float radius, int precision) {
      this(center, radius, precision, 0.15, 0, 0.9, -20);
  }
  
  Planet(PVector center, float radius) {
      this(center, radius, 999, 0.15, 0, 0.9, -20);
  }
  
  Planet() {
    this(new PVector(width / 2, height / 2), 50, 999, 0.15, 0, 0.9, -20);
  }
  
  void draw() {
    //planet
    for (int i = 0; i < this.precision; i++) {
      float a = random(TWO_PI) + t * this.rotateSpeed;
      float y = random(-1, 1);
      float r = sqrt(1 - y * y);
      float z = sin(a);
      stroke(noise(y + this.colored) * 360, 100, 100);
      if (z > 0)
        point(cos(a) * this.radius * r + this.center.x, y * this.radius + z * r * 5 + this.center.y);
    }
    
    //belt //<>//
    if(random(1) < this.beltProbability) {
      for (int j = 0; j < numberBelts; j++) {
        color beltColor = color(random(360), random(20, 50), random(30, 70));
        stroke(beltColor);
  
        float stepX = 60 / numberBelts;
        float stepY = 10 / numberBelts;
  
        for (int i = 0; i < dotsBelts; i++) {
          float rx = random(-30 + stepX * j, -30 + stepX * j + stepX);
          float ry = random(-5 + stepY * j, -5 + stepY * j + stepY);
          float a = random(TWO_PI) + t * this.rotateSpeed;
          float xpos = cos(a) * (this.radius * 2 + rx) + this.center.x;
          float ypos = sin(a) * (this.radius + this.beltYAxis + ry) + this.center.y;
          if (ypos > this.center.y || dist(this.center.x, this.center.y, xpos , ypos) > this.radius + 5) {
            point(xpos, ypos);
          }
        }
      }
    }
    
    // moons
    for (int j = 0; j < this.nbMoons; j++) {
      float start = random(TWO_PI);
      float yoff = random(-75, 75);
      float yAxis = random(-10, 10);
      float size = random(10, 30);
      float speedFactor = random(0.5, 1.5);
      stroke(color(random(255), random(70, 100), random(40,70)));
      for (int i = 0; i < (int) (this.precision / 3); i++) {
        float a = random(TWO_PI) + t * this.rotateSpeed, y = random(-1, 1);
        float r = sqrt(1 - y * y);
        float z = sin(a);
        float zpos = sin(t * speedFactor + start);
        float xpos = cos(a) * size * r + cos(t * speedFactor + start) * 250 + this.center.x;
        float ypos = y * size + z * r * 5 + (this.center.y + yoff) + zpos * 25 * yAxis;
        if (z > 0 && (zpos > 0 || dist(this.center.x, this.center.y, xpos , ypos) > this.radius))
          point(xpos, ypos);
      }
    }
  }
  
}

ArrayList<Planet> planets = new ArrayList<Planet>();

void setup() {
  size(900, 900);
  colorMode(HSB);
  seed = (int) random(1000);
  numberBelts = int(random(1, 6));
  dotsBelts /= numberBelts;
  planets.add(new Planet(new PVector(width / 2 - 50, height / 2), 100, 5000, 0.15, 5, 0.9, 200));
  planets.add(new Planet(new PVector(150, 150), 50, 500, 0.25, 0, 0.2, 0));
  planets.add(new Planet(new PVector(800, 200), 60, 550, 0.35, 0, 0.7, -150));
  planets.add(new Planet(new PVector(50, 750), 25, 300, 0.15, 1, 1, 250));
  planets.add(new Planet(new PVector(800, 500), 75, 300, 0.15, 1, 0.0, 0));
  planets.add(new Planet(new PVector(700, 780), 15, 300, 0.15, 1, 0.6, -45));
}

int counter = 0;
void draw() {
  background(0);
  fill(255,255,255);
  randomSeed(seed);
  strokeWeight(1);
  for (int i = 0; i < 500; i++) {
    float x, y;
    do {
      x = random(900);
      y = random(900);
    } while(dist(width / 2, height / 2, x, y) < 55);
    stroke(random(360), random(0, 20), random(60, 100));
    point(x, y);
  }
  
  strokeWeight(2);
  
  //planet
  for (Planet p : planets) {
    p.draw();
  }

  t += 0.1;
  saveFrame(counter + " .png");
  counter++;
}
