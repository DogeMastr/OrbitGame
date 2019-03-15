class meteor {

  float x;
  float y;
  float radius;
  float pos;

  float speed;
  float rotation;

  float xMoveSpeed;
  float yMoveSpeed;

  // meteor(random(int)(1,4),random(10,20),random(5,10));
  meteor(float _pos, float _r, float _s) {

    radius = _r/2;
    pos = _pos;

    speed = _s;

    initRotation();

    println("init: "+ this);
    println(pos);
  }

  void initRotation() {
    //x & y values are random 20 - 50, depending on rotation add width +| height
    //Clock face but in PI
    //       PI*2
    // PI*1.5    PI/2
    //       PI

    // //replace these with randoms thanks
    // if (rotation >= 0 && rotation <= PI/2) {
    //   //going top right
    //   x = 0 - x;
    //   y = 0 - y;
    // } else if (rotation >= PI/2 && rotation <= PI) {
    //   //going bottom right
    //   x = 0 - x;
    //   y = y + height;
    // } else if (rotation >= PI && rotation <= PI*1.5) {
    //   //going bottom left
    //   x = x + width;
    //   y = y + height;
    // } else if (rotation >= PI*1.5 && rotation <= PI*2) {
    //   //going top left
    //   x = x + width;
    //   y = 0 - y;
    // }

    /*
    change everything to this pleasseee

    int position = random(1,4); whatever im tires now

    if pos 1 - bottom half of the screen, rotation is random(PI*1.5, PI/2);
    if pos 2 - top half rotation is random(PI/2, PI*1.5);
    if pos 3 - left half rotation is random(0,PI);
    if pos 4 - right half rotation is random(PI,PI*2);

    also do random for x & y values that make sence thanks ttyl
    pos 1 - y is width + 60 x is random(-60, width + 60);
    pos 2 - y is - 60 x is the same as last time
    pos 3 swap the x and y in pos 1 bit hieght
    pos 4 wowie
    */

    if(pos == 1){
      rotation = random(PI*1.5,PI*2.5);

			x = -60;
			y = random(-60, height + 60);;

    } else if(pos == 2){
      rotation = random(PI/2, PI*1.5);

			x = width + 60;
			y = random(-60, height + 60);

    } else if(pos == 3){
      rotation = random(0,PI);

			x = random(-60, width + 60);
				y = width + 60;

    } else {
      rotation = random(PI, PI/2);

			x = random(-60, width + 60);
			y = -60;
    }

      yMoveSpeed = speed*cos(rotation);
      xMoveSpeed = speed*sin(rotation);
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
    if (dist(x, y, e.x, e.y) < e.radius/2 + radius) {
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
