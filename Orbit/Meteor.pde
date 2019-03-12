class meteor {

  float x;
  float y;
  float radius;

  float speed;
  float rotation;

  float xMoveSpeed;
  float yMoveSpeed;

  // meteor(random(20,50),random(20,50),random(10,20),random(5,10),random(0,PI*2))
  meteor(float _x, float _y, float _r, float _s, float _ro) {
    x = _x;
    y = _y;
    radius = _r;

    speed = _s;
    rotation = _ro;

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

    //replace these with randoms thanks
    if (rotation >= 0 && rotation <= PI/2) {
      //going top right
      x = 0 - x;
      y = 0 - y;
    } else if (rotation >= PI/2 && rotation <= PI) {
      //going bottom right
      x = 0 - x;
      y = y + height;
    } else if (rotation >= PI && rotation <= PI*1.5) {
      //going bottom left
      x = x + width;
      y = y + height;
    } else if (rotation >= PI*1.5 && rotation <= PI*2) {
      //going top left
      x = x + width;
      y = 0 - y;
    }

    /*
    change everything to this pleasseee

    int position = random(1,4); whatever im tires now

    if pos 1 - bottom half of the screen, rotation is random(PI*1.5, PI/2);
    if pos 2 - top half rotation is random(PI/2, PI*1.5);
    if pos 3 - left half rotation is random(0,PI);
    if pos 4 - right half rotation is random(PI,PI*2);

    also do random for x & y values that make sence thanks ttyl
    */
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
