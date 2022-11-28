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
    col[0] = random(105-20,105+20);
    col[1] = random(124-30,124+30);
    col[2] = random(18-20,18+20);
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
    repel(mouseX, mouseY, 100);
    
    // Repel from avoidSpots
    for(Cell i: avoidSpots) repel(i.pos.x,i.pos.y, i.size);
    
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

void setup() {
  size(1200,1000);
  noStroke();
  
  // First cells
  cells.add(new Cell(width/2, height/2, 0.8, 0.8, 30));
  for (int i = 0; i < 4; i++) cells.add(new Cell(random(0, width), random(0,height), random(-1,1), random(-1,1), random(20,30)));
}

void draw() {
  //background(105,124,18); // Green background
  //background(155,103,60); // Autumn brown background
  //background(152,86,41); // Fox-color
  background(255,218,3); // Sunflower yellow
  
  // Draw cells
  for (Cell i: cells) {
    i.spawnCell();
    i.moveCell();
  }
  
}

void keyPressed() {
  println("keyCode == " + keyCode);
  // Spacebar pressed
  if (keyCode == 32) {
    println("spacebar pressed!");
    // Duplicate every cell
    for (int i = cells.size()-1; i >= 0; i--) {
      Cell j = cells.get(i);
      cells.add(new Cell(j.pos.x, j.pos.y, random(-1,1)*j.movement.x, random(-1,1)*j.movement.y, j.size / 1.5));
    }
  }
  
  // R is pressed
  // Delete all cells and reinput starting cells
  if (keyCode == 82) {
    cells.clear();
    for (int i = 0; i < 4; i++) cells.add(new Cell(random(0, width), random(0,height), random(-1,1), random(-1,1), random(20,30)));
  }
}

void mouseClicked() {
  // Add avoidSpot at mouse position
  avoidSpots.add(new Cell(mouseX,mouseY,0,0, random(50,150)));
  
}
