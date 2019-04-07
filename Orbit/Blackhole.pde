class blackhole {
  float x;
  float y;
  float radius;

  blackhole() {
    x = width/2;
    y = width/2;
    radius = 40;

    println("init: " + this);
  }

  void run() {
    display();
    getBigger();
  }

  void display() {
    fill(0);
    ellipse(x, y, radius*2, radius*2);
  }

  void getBigger() { //makes the blackhole bigger when u have more than 40 points
    if (pastSecond != second()) {
      holeTimer++;
    }
    if (holeTimer >= 10 && player1.orbits > 40) {
      radius += 0.1;
      holeTimer = 0;
    }
  }
}
