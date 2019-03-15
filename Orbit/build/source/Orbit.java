import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Orbit extends PApplet {

player player1;

blackhole blackhole1;

ArrayList<meteor> meteorList;

boolean gameover = false;

//Scoring stuff
String[] scores;
int highScore;

public void setup() {
  

  textAlign(CENTER, TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();

  meteorList = new ArrayList<meteor>();

  scores = loadStrings("data/Scores.txt");
  highScore = PApplet.parseInt(scores[0]);

  meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
}

public void draw() {
  background(0, 0, 85);

  if (gameover == true) {
    //you died
    if (player1.orbits > highScore) {
      highScore = player1.orbits;
    }

    text("Gameover!", width/2, height/3);
    text("Score: "+player1.orbits, width/2, height/2);
    text("Highscore: " + highScore, width/2, (height/3)*2);

    if (keyPressed) {
      gameover = false;
      reset();
    }
  } else {

    player1.run();

    blackhole1.run();

    runMeteors();

    checkGameover();
  }
}

public void runMeteors() {
  for (int i = meteorList.size() - 1; i >= 0; i--) {

    meteorList.get(i).run();

    if (meteorList.get(i).checkCollision(player1)) {
      gameover = true;
    } else if (meteorList.get(i).checkOutOfBounds()) {
      meteorList.remove(i);
      meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
    }
  }
}

public void checkGameover() {
  if (player1.checkCollision(blackhole1.x, blackhole1.y, blackhole1.radius)) {
    gameover = true;
  }
}

public void reset() {
  player1 = new player();
}

public void exit() {
  println(highScore);
  scores[0] = str(highScore);
  println(scores[0]);
  saveStrings("data/Scores.txt", scores);
  super.exit();
}
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

  public void run() {
    display();
  }

  public void display() {
    ellipse(x, y, radius*2, radius*2);
  }
}
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

  public void initRotation() {
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
      rotation = random(PI*1.5f,PI*2.5f);

			x = -60;
			y = random(-60, height + 60);;

    } else if(pos == 2){
      rotation = random(PI/2, PI*1.5f);

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

  public void run() {
    display();
    move();
  }

  public void display() {
    ellipse(x, y, radius, radius);
  }

  public void move() {
    x += xMoveSpeed;
    y += yMoveSpeed;
  }

  public boolean checkCollision(player e) {
    if (dist(x, y, e.x, e.y) < e.radius/2 + radius) {
      return true;
    } else {
      return false;
    }
  }

  public boolean checkOutOfBounds() {
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
  player() {
    centerX = width/2;
    centerY = height/2;

    radius = 10;

    orbitTime = 800;
    orbitRadius = 400;

    orbits = 0;

    println("init: "+ this);
  }

  public void run() {
    move();
    display();
    countOrbits();
  }

  public void move() {
    orbitTime += 4/orbitRadius;
    if (mousePressed) {
      orbitRadius++;
    } else {
      orbitRadius -= 0.8f;
    }
    x = (centerX + orbitRadius * cos(orbitTime));
    y = (centerY + orbitRadius * sin(orbitTime));
  }

  public void display() {
    fill(255);
    ellipse(x, y, radius, radius);
  }

  public void countOrbits() {
    text(orbits, width/2, height/4);

    if (x > width/2 && y < height/2 && scorecounting == false) {
      println("scorecounted");
      orbits++;
      scorecounting = true;
    } else if (y > height/2) {
      scorecounting = false;
    }
  }

  public boolean checkCollision(float eX, float eY, float eR) {
    if (dist(x, y, eX, eY) < eR + radius) {
      return true;
    } else {
      return false;
    }
  }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Orbit" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
