class blackhole {
  float x;
  float y;
  float radius;

  blackhole() {
    x = width/2;
    y = width/2;
    radius = 10;

    println("init: " + this);
  }

  void run() {
    display();
  }

  void display() {
    ellipse(x, y, radius*2, radius*2);
  }
}
