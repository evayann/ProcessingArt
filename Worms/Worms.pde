// Global debugging values
boolean pause = false;

// ---- 

private int nbWorms = 50;
private ArrayList<Worm> worms = new ArrayList<Worm>();
private float spaceBetweenWorm = 80;
private color backgroundColor = #403F02;

class Worm {

  private color startColor;
  private color endColor;


  private ArrayList<PVector> wormPoints;
  private float size;
  private int nbPoints;
  private PVector velocity;
  
  private PVector direction;
  private ArrayList<PVector> applyDirection;

  public Worm(int x, int y) {
    wormPoints = new ArrayList<PVector>();
    applyDirection = new ArrayList<PVector>();
    nbPoints = int(random(25, 50));
    size = random(3, 7);
    
    startColor = #595500;
    endColor = #8E8636;
    
    direction = new PVector(floor(random(-1, 1)), floor(random(-1, 1)));
    velocity = new PVector(random(1, 2), random(1, 2));
    wormPoints.add(new PVector(x, y));
  }

  public void draw() {
    update();

    beginShape();
    int i = 0;
    for (PVector v : wormPoints) {
      float largeValue = abs(0.5 - i / (float) wormPoints.size());
      strokeWeight((1 - largeValue) * size);
      stroke(lerpColor(startColor, endColor, map(largeValue, 0, 0.5, 0, 1)));
      curveVertex(v.x, v.y);
      i++;
    }
    endShape();
  }

  public void update() {
    randomDirection();
    
    if (wormPoints.size() > nbPoints)
      wormPoints.remove(0);
      
    PVector last = wormPoints.get(wormPoints.size() - 1);
    float x = (last.x + direction.x * velocity.x);
    float y = (last.y + direction.y * velocity.y);
    
    checkBox(x, y) ;
    checkCollision();
    computeDirection();
    
    
    applyDirection.clear(); // Let new points arrive and remove xeite point
    wormPoints.add(new PVector(x, y));
  }
  
  private void computeDirection() {
    if (applyDirection.size() == 0)
      return;

    for (PVector ad : applyDirection)
      direction.add(ad);
    
    direction.normalize();
  }
  
  private void setDirection(PVector toGo) {
    applyDirection.add(toGo);
  }
  
  private void randomDirection() {
    if (0.05 > random(1))
      setDirection(new PVector(random(-1, 1), 0));
    if (0.05 > random(1))
      setDirection(new PVector(0, random(-1, 1)));      
  }
  
  private void checkCollision() {
    for (Worm w : worms) {
      PVector nearest = toNear(w);
      
      if (nearest == null)
        continue;
      
      float dist = nearest.dist(getHead());
      if (dist <= 0.01)
        continue;
        
      PVector vecNear = PVector.sub(nearest, getHead());  
      vecNear.setMag(- 1 / dist);
      setDirection(vecNear);
    }
  }
    
  private PVector toNear(Worm w) {
    float dist = Float.MAX_VALUE;
    PVector nearest = null;
    PVector head = getHead();
    ArrayList<PVector> pts = w.getPoints();
    for (int i = 0; i < pts.size(); i++) {
      PVector v = pts.get(i);
      float currDist = v.dist(head);
      if (currDist < spaceBetweenWorm && currDist < dist) {
        nearest = v;
        dist = currDist;
      }
    }
    return nearest;
  }
  
  private void checkBox(float x, float y) {
    if (x > width || x < 0) 
      direction.x *= -1;
    if (y > height || y < 0)
      direction.y *= -1;
  }
  
  public ArrayList<PVector> getPoints() {
    return wormPoints;
  }

  public PVector getHead() {
    return wormPoints.get(wormPoints.size() - 1);
  }
}

void keyPressed() {
  if (key == 'p')
    pause = ! pause;
}

void setup() {
  size(500, 500, P3D);
  noFill();
  strokeJoin(ROUND);
  frameRate(60);
  for (int i = 0; i < nbWorms; i++) {
    worms.add(new Worm(int(random(width)), int(random(height))));
  }
}

int counter = 0;
void draw() {
  if (!pause) {
    background(backgroundColor);
    for (Worm w : worms) {
      w.draw();
    }
    saveFrame(counter + ".png");
    counter++;
  }  
}
