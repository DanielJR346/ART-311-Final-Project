// Idea: drawing cell duplication

class Cell {
  // Size of the cell
  float size = 3;
  // Position of the cell
  PVector pos = new PVector();
  // Movement of the cell (will be added to pos continuously)
  PVector movement = new PVector();
  // Color of cell (RGB value)
  float[] col = new float[3];
  
  // Constructor
  Cell(float posX, float posY, float moveX, float moveY, float cellSize) {
    pos.x = posX;
    pos.y = posY;
    movement.x = moveX;
    movement.y = moveY;
    size = cellSize;
    // Brown color
    //col[0] = random(155-20,155+20);
    //col[1] = random(103-20,103+20);
    //col[1] = random(60-20,60+20);
    // Green color
    col[0] = random(105-10,105+10);
    col[1] = random(124-20,124+30);
    col[2] = random(18-10,18+10);
  }

  // Constructor with color
  Cell(float posX, float posY, float moveX, float moveY, float cellSize, float colR, float colG, float colB) {
    pos.x = posX;
    pos.y = posY;
    movement.x = moveX;
    movement.y = moveY;
    size = cellSize;
    //if (colR == 255 && colG == 255 && colB == 255) setCol(255,255,255); // no colr variation if white is chosen
    //else setCol(random(colR-20, colR+20),random(colG-20, colG+20),random(colB-20,colB+20));
    setCol(colR,colG,colB);
  }
  
  // Setter for size
  void setSize(int x) {
    size = x;
  }
  
  // Settter for position
  void setPos(int x, int y) {
    pos.x = x;
    pos.y = y;
  }
  
  // Setter for color
  void setCol(float x, float y, float z) {
    col[0] = random(x-20,x+20);
    col[1] = random(y-20,y+20);
    col[2] = random(z-20,z+20);
  }
  
  // Draw method for cell
  void spawnCell() {
    circle(pos.x, pos.y, size);
    fill(col[0],col[1],col[2]);
  }
  
  // Increment pos vector by movement vector
  void moveCell() {
    // Check if cell is against a wall
    if (pos.x <= 0 || pos.x >= width) switchX();
    if (pos.y <= 0 || pos.y >= height) switchY();
    
    // Repel cells from mouse
    //repel(mouseX, mouseY, 100);
    
    // Repel from avoidSpots
    //for(Cell i: avoidSpots) repel(i.pos.x,i.pos.y, i.size);
    //repel(avoidSpots);
    
    pos.add(movement);
    if (movement.x >= 2.5) movement.x = 2.5;
    if (movement.y >= 2.5) movement.y = 2.5;
  }
  
  // Switch diretions of cells on x-axis
  void switchX() {
    movement.x *= -1;
  }

  // Switch diretions of cells on y-axis
  void switchY() {
    movement.y *= -1;
  }
  
  // Repell from list of cells
  void repel(ArrayList<Cell> list) {
    for (Cell i: list) repel(i.pos.x,i.pos.y, i.size);
  }
  
  // Repell from certain position
  void repel(float avoidX, float avoidY, float radius) {
    if (dist(avoidX, avoidY, pos.x, pos.y) <= radius) {
      if (movement.x > 0 && avoidX > pos.x) {
        movement.x  *= -1;
        movement.x -= .2;
      }
      else if (movement.x < 0 && avoidX < pos.x) {
        movement.x  *= -1;
        movement.x += .2;
      }
      if (movement.y > 0 && avoidY > pos.y) {
        movement.y  *= -1;
        movement.y -= .2;
      }
      else if (movement.y < 0 && avoidY < pos.y) {
        movement.y *= -1;
        movement.y += .2;
      }
    }
  }
  
}

// Arraylist that holds all cell info
ArrayList<Cell> cells = new ArrayList<Cell>();
// Arraylist that holds all avoid cell info
ArrayList<Cell> avoidSpots = new ArrayList<Cell>();
// ArrayList for iteration 1
ArrayList<Cell> it1 = new ArrayList<Cell>();
// ArrayList for leaves
ArrayList<Cell> leaves = new ArrayList<Cell>();

void setup() {
  size(1200,1000);
  noStroke();
  
  // First cells for final iteration
  cells.add(new Cell(width/2, height/2, 0.8, 0.8, 30));
  for (int i = 0; i < 4; i++) cells.add(new Cell(random(0, width), random(0,height), random(-2,2), random(-2,2), random(20,30)));
  // Set up for it1
  it1.add(new Cell( width/2, height/2, 4,4,30,255,255,255));
  // Set up for leaves
  for (int i = 0; i < 10; i++) leaves.add(new Cell(random(0, width), random(0,height), random(-2,2), random(-2,2), random(20,30)));
}

// Draw line from cell to avoid spot if close enough
// DO NOT USE WITH LOTS OF CELLS! WILL SLOW DOWN EXPONENTIALLY
void line(ArrayList<Cell> list1, ArrayList<Cell> list2) {
  for(Cell i: list1) {
    for(Cell j: list2) {
      if (dist(i.pos.x, i.pos.y, j.pos.x, j.pos.y) <= 150) {
        line(i.pos.x, i.pos.y, j.pos.x, j.pos.y);
        stroke(j.col[0], j.col[1], j.col[2]);
      }
    }
  }
}

// Whether or not to draw lines
boolean drawLines = false;
// Will determine which iteration of the project is being depicted
int progress = 1;
// different color leaf occurrence (closer to 1 means more likely)
int redLeaf = 12;
int yellowLeaf = 11;
int orangeLeaf = 5;
// Background RGBs for leaves
float leavesR = 255;
float leavesG = 218;
float leavesB = 3;
// Increment leaves backgroud to turn yellow to brown
float incR = (128-255)/16;
float incG = (9-218)/16;
float incB = (32-3)/16;

void draw() {
  //background(105,124,18); // Green background
  //background(155,103,60); // Autumn brown background
  //background(152,86,41); // Fox-color
  //background(255,218,3); // Sunflower yellow
  
  // Draw cells
  //for (Cell i: cells) {
  //  i.spawnCell();
  //  i.moveCell();
  //}
  
  // Progress == 1
  // Latest project iteration
  if (progress == 1) {
    background(255,218,3); // Sunflower yellow
    // Draw cells with connecting lines
    for (int i = 0; i < cells.size(); i++) {
      Cell a = cells.get(i);
      if (i+1 != cells.size() && drawLines) {
        line(cells.get(i).pos.x,cells.get(i).pos.y,cells.get(i+1).pos.x,cells.get(i+1).pos.y);
        stroke(a.col[0],a.col[1],a.col[2]);
      }
      a.spawnCell();
      a.repel(mouseX,mouseY, 100);
      a.repel(avoidSpots);
      a.moveCell();
    }
  }
  
  // Progress == 2
  // First iteration of the project
  else if (progress == 2) {
    background(180); // Grey
    for (Cell i: it1) {
      i.spawnCell();
      i.moveCell();
    }
  }
  
  else if (progress == 3) {
    background(leavesR, leavesG, leavesB); // Sunflower yellow
    // Draw cells with connecting lines
    for (int i = 0; i < leaves.size(); i++) {
      Cell a = leaves.get(i);
      a.spawnCell();
      a.repel(mouseX,mouseY, 100);
      a.repel(avoidSpots);
      a.moveCell();
    }
    
  }
  
}

void keyPressed() {
  println("keyCode == " + keyCode);
  // Spacebar pressed
  if (keyCode == 32) {
    // Duplicate cells with different properties depending on the mode
    println("Duplicated cells!");
    if (progress == 1) {
      // Duplicate every cell in cells
      for (int i = cells.size()-1; i >= 0; i--) {
        Cell j = cells.get(i);
        cells.add(new Cell(j.pos.x, j.pos.y, random(-1,1)*j.movement.x, random(-1,1)*j.movement.y, j.size / 1.5));
      }
    }
    if (progress == 2) {
      // Duplicate every cell in cells
      for (int i = it1.size()-1; i >= 0; i--) {
        Cell j = it1.get(i);
        it1.add(new Cell(j.pos.x, j.pos.y, -j.movement.x, -j.movement.y, j.size,255,255,255));
      }
    }
    if (progress == 3) {
      // Duplicate every leaf in leaves
      // Make variant color leaves more common
      if (redLeaf >5)redLeaf-=1;
      if (orangeLeaf > 3)orangeLeaf-=1;
      if (yellowLeaf > 4)yellowLeaf-=1;
      for (int i = leaves.size()-1; i >= 0; i--) {
        Cell j = leaves.get(i);
        // Change leaf colors of old leaves if conditions apply
        if (i%redLeaf == 0) j.setCol(127,40,43);
        else if (i%yellowLeaf == 0) j.setCol(214,156,18);
        else if (i%orangeLeaf == 0) j.setCol(222,89,28);
        
        // Add variation of leaf color for new leaves
        if (i%redLeaf == 0) leaves.add(new Cell(j.pos.x, j.pos.y, random(-1,1)*j.movement.x, random(-1,1)*j.movement.y, j.size / 1.5, 127, 40, 43)); // Red
        else if (i%yellowLeaf == 0) leaves.add(new Cell(j.pos.x, j.pos.y, random(-1,1)*j.movement.x, random(-1,1)*j.movement.y, j.size / 1.5, 214,156,18)); // Yellow
        else if (i%orangeLeaf == 0) leaves.add(new Cell(j.pos.x, j.pos.y, random(-1,1)*j.movement.x, random(-1,1)*j.movement.y, j.size / 1.5, 222,89,28)); // Orange
        leaves.add(new Cell(j.pos.x, j.pos.y, random(-1,1)*j.movement.x, random(-1,1)*j.movement.y, j.size / 1.5));
        
      }
      println("redLeaf: " + redLeaf + " orangeLeaf: " + orangeLeaf + " yellowLeaf: " + yellowLeaf);
      // Progress background color
      leavesR += incR;
      leavesG += incG;
      leavesB += incB;

    }
  }
  // R is pressed
  // Delete all cells and reinput starting cells
  if (keyCode == 82) {
    drawLines = false;
    cells.clear();
    it1.clear();
    leaves.clear();
    avoidSpots.clear();
    for (int i = 0; i < 4; i++) cells.add(new Cell(random(0, width), random(0,height), random(-1,1), random(-1,1), random(20,30)));
    it1.add(new Cell( width/2, height/2, 4,4,30));
    it1.get(0).setCol(255,255,255);
    for (int i = 0; i < 10; i++) leaves.add(new Cell(random(0, width), random(0,height), random(-2,2), random(-2,2), random(20,30)));
    leavesR = 255;
    leavesG = 218;
    leavesB = 3;
    
  }
  // L is pressed
  // Draw lines or don't idrc
  if (keyCode == 76) {
    drawLines = !drawLines;
  }
  // Backspace is pressed
  // Remove all "duplicates"
  if (keyCode == 8) {
    // Remove duiplicate cells 
    if (progress == 1 && cells.size() >1) {
      int x = cells.size();
      for (int i = x-1; i >= x/2; i--) cells.remove(i);
    }
    // Remove duplicate leaves and revert color changes
    if (progress == 3 && leaves.size() >1) {
      if (redLeaf < 12) redLeaf++;
      if (orangeLeaf < 5) orangeLeaf++;
      if (yellowLeaf < 11) yellowLeaf++;
      int x = leaves.size();
      for (int i = x-1; i >= x/2; i--) {
        leaves.remove(i);
      }
      // Revert
      leavesR -= incR;
      leavesG -= incG;
      leavesB -= incB;
      
    }
  }
  // P is pressed
  // Remove all avoid spots
  if (keyCode == 80) {
    avoidSpots.clear();
  }
  
  
  // 1 key pressed
  if (keyCode == 49) {
    progress = 1;
  }  
  // 2 key pressed
  if (keyCode == 50) {
    progress = 2;
    noStroke();
  }
  // 3 key pressed
  if (keyCode == 51) {
    progress = 3;
    noStroke();
  }
  
  
}

void mouseClicked() {
  // Add avoidSpot at mouse position
  avoidSpots.add(new Cell(mouseX,mouseY,0,0, random(50,150)));
  
}
