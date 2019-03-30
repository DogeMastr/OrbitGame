class player {
  float centerX;
  float centerY;

  float x;
  float y;
  float radius;

  float orbitTime;
  float orbitRadius;

  int orbits; //score
  boolean scorecounting;

	boolean showPlusOne;
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

		showPlusOne = false;

		fade = 255;

    println("init: "+ this);
  }

  void run() {
    move();
    display();
    countOrbits();
		plusOne();
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
    fill(18,231,18);
    ellipse(x, y, radius, radius);
  }

  void countOrbits() {
    if (x > width/2 && y < height/2 && scorecounting == false) {
      println("scorecounted");
      addScore();
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

	void addScore(){
		orbits++;
		showPlusOne = true;
		fade = 255;
		plusX = x + radius;
		plusY = y + radius;
	}

	void plusOne() {
	  if (showPlusOne) {

	    fill(255, 255, 255, fade);
	    textSize(20);

	    text("+1", plusX, plusY);

	    if (fade < 0) {
	      showPlusOne = false;
				fade = 255;
	    } else {
	      fade = fade - 5;
	      plusY = plusY - 2;
	    }
	  }
	}
}
