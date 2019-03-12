class meteor {

  float x;
  float y;
  float radius;

  float speed;
  float rotation;

  float xMoveSpeed;
  float yMoveSpeed;

  // meteor(random(1,2),random(1,2),random(5,10),random(5,30))
  meteor(int _x, int _y, float _r, float _s) {
    x = _x;
    y = _y;
    radius = _r;

    speed = _s;
    rotation = 0;

    initRotation();

    yMoveSpeed = speed*cos(rotation);
    xMoveSpeed = speed*sin(rotation);
    println("init: "+ this);
  }

  void initRotation() {
    //x & y values are random 20 - 50, depending on rotation add width +| height
    //Clock face but in PI
    //       2*PI
    // PI*1.5    PI/2
    //       PI
    if (x == 1){
      x = random(-60, -20);
    } else if (x == 2){
      x = random(width + 20, width + 60);
    }

    if(y == 1){
      y = random(-60, -20);
    } else if(y ==2){
      y = random(width + 20, width + 60);
    }
  }

  void run() {
    display();
    move();
  }

  void display() {
    ellipse(x, y, radius, radius);
  }

  void move() {
    x += xMoveSpeed;
    y += yMoveSpeed;
  }

  boolean checkCollision(player e) {
    if (dist(x, y, e.x, e.y) < e.radius + radius) {
      return true;
    } else {
      return false;
    }
  }

  boolean checkOutOfBounds() {
    if (x > width + radius * 6) {
      return true;
    } else if (x < 0 - radius * 6) {
      return true;
    } else if (y > height + radius * 6) {
      return true;
    } else if (y < 0 - radius * 6) {
      return true;
    } else {
      return false;
    }
  }
}
