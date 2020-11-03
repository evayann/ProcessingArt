// Cellular Automata

boolean DEAD  = false;
boolean ALIVE = true;

int start_nb = 500;
int x = 500, y = 500, r_size = 10;
int r_x = (int) x / r_size, r_y = (int) y / r_size;

int seed;
boolean displaySeed = true;

boolean curr[][] = new boolean[r_x][r_y];
boolean next[][] = new boolean[r_x][r_y];

boolean play = false;
 
void update(boolean[][] _toUpdate, boolean[][] _values) {
    for(int i=0; i < _toUpdate.length; i++)
      for(int j=0; j < _toUpdate[i].length; j++)
        _toUpdate[i][j] = _values[i][j];
}

void updateGen() {
    for (int i=0; i < r_x; i++) {
      for (int j=0; j < r_y; j++) {
          rule(i, j, curr, next);
      }
    }
    update(curr, next);
}

void setup() {
  seed = (int) random(1000000);
  textSize(32);
  stroke(255);
  randomSeed(seed);
  int curr_nb = 0;
  while (start_nb > curr_nb) {
    int xCell = (int) random((float) 0, (float) r_x), yCell = (int) random((float) 0, (float) r_y);
    if (curr[xCell][yCell] == DEAD) {
        curr_nb++;
        curr[xCell][yCell] = ALIVE;
    }
  }
  drawGrid();
  update(next, curr);
  size(500, 500);
  frameRate(10);
} 
           
void draw() {
    if (!play)
      return;
    drawGrid();
    updateGen();
}

void drawGrid() {
    for (int i=0; i < r_x; i++) {
      for (int j=0; j < r_y; j++) {
          int colors = curr[i][j] ? 255 : 0; 
          stroke(255 - colors);
          fill(colors);
          rect(i * r_size, j * r_size, r_size, r_size);
      }
    }
    
    if (displaySeed) {
      fill(255, 102, 153);
      text("Seed : " + seed, 10, 30);
    }
}

void keyPressed() {
     if (key == 'p')
       play = true;
     if (key == 's')
       play = false;
     if (key == 'r')
       setup();
}  

void mousePressed() {
    int x = mouseX / r_size, y = mouseY / r_size;
    curr[x][y] = !curr[x][y]; 
    drawGrid();
}

void rule(int x, int y, boolean[][] curr, boolean[][] next) {
    game_of_life(x, y, curr, next);
}
    
int count_neighbours(int x, int y, boolean[][] curr) {
    int neighbours = 0;
    for (int i = x - 1; i < x + 2; i++) {
        if (i < 0 || i >= r_x)
            continue;
        for (int j = y - 1; j < y + 2; j++) {
            if (j < 0 || j >= r_y || (i == x && j == y))
                continue;
            if (curr[i][j] == ALIVE)
                neighbours += 1;
        }
    }
    return neighbours;
}
    
void r1(int x, int y, boolean[][] curr, boolean[][] next) {
    int neighbours = count_neighbours(x, y, curr);
    if (neighbours < 3)
        next[x][y] = ALIVE;
    else if (4 > neighbours)
        next[x][y] = DEAD;
    else if (neighbours > 5 && curr[x][y] == ALIVE)
        next[x][y] = DEAD;
    else
        next[x][y] = ALIVE;
}

void game_of_life(int x, int y, boolean[][] curr, boolean[][] next) {
    int neighbours = count_neighbours(x, y, curr);
    if (curr[x][y] == DEAD && neighbours == 3)
        next[x][y] = ALIVE;
    else if (curr[x][y] == ALIVE && (neighbours == 3 || neighbours == 2))
        next[x][y] = ALIVE;
    else
        next[x][y] = DEAD;
}
