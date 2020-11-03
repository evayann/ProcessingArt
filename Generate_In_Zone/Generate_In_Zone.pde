PGraphics textMask;
color textMaskColor = color(255, 255, 255);
color generateMaskColor = color(255, 0, 0);

int wS = 800, hS = 250; 

void setup() {
  size(800, 250);
  frameRate(1);
  
  background(255);
  generateMask("Nice Jobs !");
  generateElements();
  saveFrame("Test.png");
  //image(textMask, 0, 0);
}

void drawRect(float x, float y, float w, float h, float d, color f) {
    PVector shape[] = {
      new PVector (x - random(-d, d), y - random(-d, d)),
      new PVector (x + w - random(-d, d), y - random(-d, d)),
      new PVector (x + w - random(-d, d), y + h - random(-d, d)),
      new PVector (x - random(-d, d), y + h - random(-d, d))
    };
  
    stroke(20);
    fill(f);
    strokeJoin(ROUND);

    // Fill
    beginShape();
    for (PVector v : shape)
      vertex(v.x, v.y);
    endShape();
    
    // Remove position on textMask to don't generate other element 
    // on this position and add gap
    textMask.beginDraw();
    textMask.fill(generateMaskColor);
    textMask.strokeJoin(ROUND);
    textMask.beginShape();
    textMask.vertex(shape[0].x - gapW, shape[0].y - gapH);
    textMask.vertex(shape[1].x + gapW, shape[1].y - gapH);
    textMask.vertex(shape[2].x + gapW, shape[2].y + gapH);
    textMask.vertex(shape[3].x - gapW, shape[3].y + gapH);
    textMask.endShape();
    textMask.endDraw();

    // Stroke
    noFill();
    beginShape();
    vertex(x - random(-d, d), y - random(-d, d));
    vertex(x + w - random(-d, d), y - random(-d, d));
    vertex(x + w - random(-d, d), y + h - random(-d, d));
    vertex(x - random(-d, d), y + h - random(-d, d));
    endShape();
}

void generateMask(String text) {
  PFont font = createFont("Bitstream Vera Sans Bold", 132, true);
  textMask = createGraphics(wS, hS);
  textMask.beginDraw();
  textMask.fill(textMaskColor);
  textMask.textFont(font);
  textMask.text(text, 0, 150);
  textMask.endDraw();
}

boolean checkMask(int x, int y) {
  return textMask.get(x, y) == textMaskColor;
} //<>//

int maxSquarreWidth = 30;
int maxSquarreHeight = 20;
int gapW = 5;
int gapH = 2;

color colors[] = {#CD9331, #813913, #9273B5, #FF6EFF};

int currX = 0, currY = 0;

void generateElements() {
  while (currY <= hS) {
    currX++;
    
    if (checkMask(currX, currY)) { // Check of Top Left corner is on mask
      // Place others points
      int h, w;
      // Start with Bottom Left
      h = int(random(10, maxSquarreHeight));
      do {
        h--;
      }
      while (!checkMask(currX, currY + h) && h > 5);
      
      // Check Top Right
      w = int(random(10, maxSquarreWidth));
      do {
        w--;
      }
      while (!checkMask(currX + w, currY) && w > 5);
      
      // Check Bottom Right
      do {
        w--;
      }
      while (!checkMask(currX + w, currY + h) && w > 5);
      
      if (w > 5 && h > 5) {
        color f = colors[int(random(colors.length))];
        drawRect(currX, currY, w, h, 2, f);
        currX += w + gapW;  
      }
    }
    
    // Go to next line
    if (currX >= wS) {
      currX = 0;
      currY ++;
    }
  }
  currX = 0; currY = 0;
}
