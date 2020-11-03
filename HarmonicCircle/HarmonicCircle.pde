boolean colorGradient = false;
color fromColor = #4E7DE0;
color toColor = #886400;

boolean fade = true;
float fadeValue = 1.75;

int counter = 0;

void drawElement(int centerX, int centerY, int radius, int nbSegment, float timeToTurnInMs, int speedFactor, float circleSize, boolean lines, boolean guide) {
  if (guide)
    circle(centerX, centerY, 2 * radius);
  
  fill(0);
  float oldX = 0, oldY = 0;
  float fX = 0, fY = 0;
  for (int i = 1; i <= nbSegment; i++) {
    float theta = (PI / nbSegment) * i;
    float maxX = cos(theta) * radius;
    float maxY = sin(theta) * radius;
    
    float startX = centerX + maxX, startY = centerY + maxY;
    float endX = centerX - maxX, endY = centerY - maxY;
    
    float percent = map(cos(theta + (millis() / timeToTurnInMs) * speedFactor), -1, 1, 0, 1);
    float x = lerp(startX, endX, percent);
    float y = lerp(startY, endY, percent);
    
    if (colorGradient)
      stroke(lerpColor(fromColor, toColor, percent));
    
    if (guide)
      line(startX, startY, endX, endY);
    
    
    circle(x, y, circleSize);
    
    
    if (lines) {
      if (fX == 0 && fY == 0) {
        fX = x;
        fY = y; 
      }
      if (oldX != 0 && oldY != 0) 
        line(oldX, oldY, x, y);
      oldX = x;
      oldY = y;
    }
  }
  
  if (lines)
    line(fX, fY, oldX, oldY);
}

void setup() {
  size(800, 800);
  frameRate(60);
  fill(255);
  rect(0, 0, 800, 800);
}

void drawPoints() {
  fade = false;
  drawElement(400, 400, 250, 5, 500, 1, 10, false, false);
}

void drawSimple() {
  drawElement(400, 400, 250, 4, 500, 1, 0, true, false);
}

void drawShape1(float x, float y, float radius, int depth, int maxShape) {
  if (depth > maxShape)
    return;
    
  drawElement((int) x, (int) y, (int) radius, maxShape + 3 - depth, 500, 1, 0, true, false);
  float halfRadius = radius / 2;
  drawShape1(x - halfRadius, y, halfRadius, depth + 1, maxShape);
  drawShape1(x + halfRadius, y, halfRadius, depth + 1, maxShape);
}

void drawShape2(float x, float y, float radius, int depth, int maxShape) {
  if (depth > maxShape)
    return;
    
  drawElement((int) x, (int) y, (int) radius, maxShape + 3 - depth, 500, (depth % 2 == 0) ?  -1 : 1, 0, true, false);
  float halfRadius = radius / 2;
  
  if (depth % 2 == 0) {
    drawShape2(x - halfRadius, y, halfRadius, depth + 1, maxShape);
    drawShape2(x + halfRadius, y, halfRadius, depth + 1, maxShape);
  }
  else {
    drawShape2(x, y - halfRadius, halfRadius, depth + 1, maxShape);
    drawShape2(x, y + halfRadius, halfRadius, depth + 1, maxShape);
  }
}

void draw() {
  // Background 
  if (fade)
    fill(255, fadeValue);
  else
    fill(255);
    
  rect(0, 0, 800, 800);
  
  //drawPoints();
  //drawSimple();
  //drawShape1(400, 400, 300, 0, 3);
  drawShape2(400, 400, 300, 0, 3);

    
  saveFrame(counter + ".png");
  counter++;
}
