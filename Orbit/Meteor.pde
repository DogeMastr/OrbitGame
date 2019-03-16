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
		println(rotation);
  }

  void initRotation() {
    if(pos == 1){
			rotation = random(0.523599,2.094395);

			x = -60;
			y = random(-60, height + 60);

    } else if(pos == 2){
      rotation = random(2.094395,3.665191);

			x = width + 60;
			y = random(-60, height + 60);

    } else if(pos == 3){
			rotation = random(3.665191,5.235988);

			x = random(-60, width + 60);
			y = width + 60;

    } else {
			rotation = random(5.235988,6.806784);

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
