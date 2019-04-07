class player {
  float centerX;
  float centerY;

  float x;
  float y;
  float radius;

  float orbitTime;
  float orbitRadius;

  int orbits; //score
  boolean scorecounting; //if the player is in the scorecounting area (top left)

  boolean showPlusNumber;
  int points; //the number for the +1 thing so it can show more than one number

  float plusX;
  float plusY;
  int fade;
  player() {
    centerX = width/2;
    centerY = height/2;

    radius = 10;

    orbitTime = 800;
    orbitRadius = 400;

    orbits = 0;

    showPlusNumber = false;

    fade = 255;

    println("init: "+ this);
  }

  void run() {
    move();
    display();
    countOrbits();
    plusNumber();
  }

  void move() {
    orbitTime += 4/orbitRadius;
    if (mousePressed) {
      orbitRadius++;
    } else {
      orbitRadius -= 0.8;
    }
    x = (centerX + orbitRadius * cos(orbitTime));
    y = (centerY + orbitRadius * sin(orbitTime));
  }

  void display() {
    fill(18, 231, 18);
    ellipse(x, y, radius, radius);
  }

  void countOrbits() {
    if (x > width/2 && y < height/2 && scorecounting == false) {
      addScore(1);
      scorecounting = true;
    } else if (y > height/2) {
      scorecounting = false;
    }
  }

  boolean checkCollision(float eX, float eY, float eR) {
    if (dist(x, y, eX, eY) < eR + radius) {
      return true;
    } else {
      return false;
    }
  }

  void addScore(int _points) {
    points = _points; //points is used for plusNumber()
    orbits = orbits + points;
    showPlusNumber = true;
    fade = 255;
    plusX = x + radius;
    plusY = y + radius;
		println("scorecounted");
  }

  void plusNumber() { //the +1 animation that appears whenever you get a point
    if (showPlusNumber) {

      fill(255, 255, 255, fade);
      textSize(20);

      text("+" + points, plusX, plusY);

      if (fade < 0) {
        showPlusNumber = false;
        fade = 255;
      } else {
        fade = fade - 5;
        plusY = plusY - 2;
      }
    }
  }
}
