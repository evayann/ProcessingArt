boolean useColor = false; 
color fromColor = #4E7DE0;
color toColor = #886400;

void drawLine(int x, int y, int block, int spaceBLine, int nbLine) {
  boolean left = false;
  if (random(0, 1) < 0.5)
    left = true; 
    
  for (int i = - nbLine / 2; i <= nbLine / 2; i++) {
    int incX = x, incY = (left) ? y - i * spaceBLine : y + i * spaceBLine;
    
    if (useColor)
      stroke(lerpColor(fromColor, toColor, ((float) (incX + block) / width + (float) (incY + block) / width) / 2.0));

    if (left)
      line(incX, incY, incX + block, incY + block);
    else 
      line(incX, incY + block, incX + block, incY);

  }
}

void setup() {
  size(800, 800);
  int nbLines = 5;
  int width = 800, nbBlock = 10;
  int block = int(width / nbBlock);
  for (int i = 0; i < width; i += block)
    for (int j = 0; j < height; j += block)
      drawLine(i, j, block, int(block / 10), nbLines);  
}
