
PointManager pm;

class PointManager {
  
  private int nbPoints;
  private float distanceToDraw;
  private float strokeSize;
  private ArrayList<Point> pts;
  private ArrayList<Line> lines;
  
  PointManager(int nbPts, float distToDraw, float ss) {
    nbPoints = nbPts;
    distanceToDraw = distToDraw;
    strokeSize = ss;
    pts = new ArrayList<Point>();
    lines = new ArrayList<Line>();
    for (int i = 0; i < nbPoints; i++) 
      pts.add(new Point(random(width), random(height)));    
  }

  void update(float deltaTime) {
    lines.clear(); // Clear previous element
    
    // Move point
    for (Point p : pts)
      p.update(deltaTime);
      
    // Make lines
    for (Point p1 : pts)
      for (Point p2 : pts) {
        PVector pos1 = p1.pos;
        PVector pos2 = p2.pos;
        float distance = dist(pos1.x, pos1.y, pos2.x, pos2.y);
        if (distance < distanceToDraw) {
          Line newLine = new Line(pos1, pos2, (distance / distanceToDraw) * strokeSize, 1 - distance / distanceToDraw);

          if (crossing) {
            lines.add(newLine);
          }
          else {
            // Test if make intersection
            boolean intersect = false;
            for (Line l : lines) {
              if (newLine.intersection(l)) {
                intersect = true;
                break;
              }
            }
            
            if (! intersect)
              lines.add(newLine);
          }
        }
      }
  }
  
  void draw() {
    for (Line l : lines) {
      stroke(255, 0, 255);
      l.draw();
    }
  }
  
}

class Point {

  private PVector pos;
  private PVector acc;
  private PVector dir;
  
  Point(float x, float y) {
    pos = new PVector(x, y);
    acc = new PVector();
    dir = new PVector(random(-1, 1), random(-1, 1));
  }
  
  void update(float deltaTime) {
    acc.set(2, 2);
    
    if (pos.x < 0 || pos.x > width) 
      dir.x *= -1;
    if (pos.y < 0 || pos.y > height) 
      dir.y *= -1;
      
    acc.setMag(20);
    acc.x *= dir.x;
    acc.y *= dir.y;
    pos.add(PVector.mult(acc, deltaTime));
  }
}

public static int orientation(PVector p, PVector q, PVector r) {
  double val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
  if (val == 0.0)
      return 0; // colinear
  return (val > 0) ? 1 : 2; // clock or counterclock wise
}

public static float transparentCompute(float x) {
  return 10 * pow(x, 3); 
}

class Line {

  private PVector start;
  private PVector end;
  private float size;
  private float alphaPercent;
  
  Line(PVector start, PVector end, float size, float alphaPercent) {
    this.start = start; 
    this.end = end;
    this.size = size;
    this.alphaPercent = alphaPercent;
  }
  
  public void draw() {
    strokeWeight(size);
    color lineColor = lerpColor(startColor, endColor, start.y / height); 
    stroke(red(lineColor), green(lineColor), blue(lineColor), transparentCompute(alphaPercent) * 255);
    line(start.x, start.y, end.x, end.y);
  }

  public boolean intersection(Line l) {
    // Don't take the extremeity of each segment 
    PVector s1 = start.copy(), e1 = end.copy();
    float xLength = (end.x - start.x);
    float yLength = (end.y - start.y);
    s1 = new PVector(start.x + xLength * 0.01, start.y + yLength * 0.01);
    e1 = new PVector(start.x + xLength * 0.99, start.y + yLength * 0.99);
    
    PVector s2 = l.start.copy(), e2 = l.end.copy();
    xLength = (l.end.x - l.start.x);
    yLength = (l.end.y - l.start.y);
    s2 = new PVector(l.start.x + xLength * 0.01, l.start.y + yLength * 0.01);
    e2 = new PVector(l.start.x + xLength * 0.99, l.start.y + yLength * 0.99);
    
    int o1 = orientation(s1, e1, s2);
    int o2 = orientation(s1, e1, e2);
    int o3 = orientation(s2, e2, s1);
    int o4 = orientation(s2, e2, e1);

    if (o1 != o2 && o3 != o4)
        return true;

    return false;
  }
}

int previousMillis;
boolean crossing = false;
color startColor = #A3F5A7;
color endColor = #003C00;

void setup() {
  size(800, 800);
  frameRate(60);
  pm = new PointManager(40, 250, 3);
}

int counter = 0;
void draw() {
  background(20);
  int millisElapsed = millis() - previousMillis;
  previousMillis = millis();
  
  pm.update(millisElapsed / 1000f);
  pm.draw();
  
  saveFrame(counter + ".png");
  counter++;
}
