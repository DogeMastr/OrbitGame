class item {
  /*
		Items are the same as metoers but its good if you hit them

		type 1 = +1 point
		type 2 = +2 points

		idk what type 3 - 5 are yet
   */

  int type; //ummmmmmm yes

  float x;
  float y;
  float radius;
  float pos;

  float speed;
  float rotation;

  float xMoveSpeed;
  float yMoveSpeed;


  /*
		itemList.add(new item((int)random(1,4),random(10,20),random(5,10),(int)random(1,5)));
   */

  item(float _pos, float _r, float _s, int _type) {

    radius = _r/2;
    pos = _pos;

    speed = _s;

    initRotation();

    type = _type;

    println("init: "+ this);
  }

  void initRotation() {
    if (pos == 1) {
      rotation = random(0.523599, 2.094395);

      x = -60;
      y = random(-60, height + 60);
    } else if (pos == 2) {
      rotation = random(2.094395, 3.665191);

      x = width + 60;
      y = random(-60, height + 60);
    } else if (pos == 3) {
      rotation = random(3.665191, 5.235988);

      x = random(-60, width + 60);
      y = width + 60;
    } else {
      rotation = random(5.235988, 6.806784);

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
    fill(255, 170, 0); //change fill depending on type please
    ellipse(x, y, radius, radius);
    if (debug) {
      textAlign(CENTER, TOP);
      textSize(20);
      text(rotation, x, y+radius);
    }
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


  void collected() {
    //checks the type and does the stuff that its ment to do
    if (type == 1) {
      //gives a point
      player1.addScore(1);
    } else if (type == 2) {
      //gives 2 points
      player1.addScore(2);
    } else if (type == 3) {
      //
    } else if (type == 4) {
      //
    } else if (type == 5) {
    } else {
      //lmao what
    }
  }
}
