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
  }

  void display() {
		fill(0);
    ellipse(x, y, radius*2, radius*2);
  }
}
