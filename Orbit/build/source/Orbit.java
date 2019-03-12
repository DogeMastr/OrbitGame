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

  meteorList.add(new meteor((int)random(1,2),(int)random(1,2),random(5,10),random(5,30)));
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
      meteorList.add(new meteor((int)random(1,2),(int)random(1,2),random(5,10),random(5,30)));
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

  float speed;
  float rotation;

  float xMoveSpeed;
  float yMoveSpeed;

  // meteor(random(1,2),random(1,2),random(5,10),random(5,30))
  meteor(int _x, int _y, float _r, float _s) {
    x = _x;
    y = _y;
    radius = _r;

    speed = _s;
    rotation = 0;

    initRotation();

    yMoveSpeed = speed*cos(rotation);
    xMoveSpeed = speed*sin(rotation);
    println("init: "+ this);
  }

  public void initRotation() {
    //x & y values are random 20 - 50, depending on rotation add width +| height
    //Clock face but in PI
    //       2*PI
    // PI*1.5    PI/2
    //       PI
    if (x == 1){
      x = random(-60, -20);
    } else if (x == 2){
      x = random(width + 20, width + 60);
    }

    if(y == 1){
      y = random(-60, -20);
    } else if(y ==2){
      y = random(width + 20, width + 60);
    }
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
    if (dist(x, y, e.x, e.y) < e.radius + radius) {
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
