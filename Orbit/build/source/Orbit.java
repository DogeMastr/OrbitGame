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

//timing stuff
int pastSecond;
int meteorTimer;
int holeTimer;

boolean menu;

boolean debug;
int framerate;
boolean slowmode = false;
public void setup() {
  

  textAlign(CENTER, TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();

  meteorList = new ArrayList<meteor>();

  scores = loadStrings("data/Scores.txt");
  highScore = PApplet.parseInt(scores[0]);

	meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));

	menu = true;
	debug = false;

	framerate = 60;
	frameRate(framerate);
}

public void draw() {
  background(0, 0, 85);
	if(menu){
		menu();
	} else {
		play();
	}
}

public void menu(){
	//draws the main menu, displays highscore & can activate debug mode
	text("Click to move!",width/2,height/5);
	text("Press any key to start!", width/2, (height/5)*2);
	text("Highsscore: "+highScore, width/2, (height/5)*3);

	if(keyPressed){
		if(key == 'b'){
			debug = true;
			menu = false;
		} else {
			menu = false;
		}
	}
}
public void play(){
	if (gameover == true) {
    //you died
    if (player1.orbits > highScore) {
      highScore = player1.orbits;
    }
		textAlign(CENTER, TOP);
		textSize(40);
    text("Gameover!", width/2, height/3);
    text("Score: "+player1.orbits, width/2, height/2);
    text("Highscore: " + highScore, width/2, (height/3)*2);
    if (keyPressed) {
      gameover = false;
      reset();
			meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
    }
  } else {
		//ye still be playin

    player1.run();

    blackhole1.run();

    runMeteors();

    checkGameover();

		textSize(40);
		textAlign(CENTER,CENTER);
		text(player1.orbits, width/2, height/2);

		debugMode();
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

	//getting another meteor every so often
	if(pastSecond != second()){
		pastSecond = second();
		meteorTimer++;
		holeTimer++;
	}
	if(meteorTimer >= 30){
		meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
		meteorTimer = 0;
	}
	if(holeTimer >= 10 && player1.orbits > 0){
		blackhole1.radius += 0.1f;
	}
}

public void checkGameover() {
  if (player1.checkCollision(blackhole1.x, blackhole1.y, blackhole1.radius)) {
    gameover = true;
  }
}

public void reset() {
  player1 = new player();

	for (int i = meteorList.size() - 1; i >= 0; i--) {
		meteorList.remove(i);
	}
}

public void exit() {
  println(highScore);
  scores[0] = str(highScore);
  println(scores[0]);
  saveStrings("data/Scores.txt", scores);
  super.exit();
}

public void debugMode(){
	if(debug){
		textAlign(LEFT,BOTTOM);
		textSize(20);
		text("Debug: "+ debug,0,20);
		text("Metors: "+meteorList.size(),0,40);
		text("Distance: "+player1.orbitRadius,0,60);
		text("framerate: " + framerate, 0,80);
		text("meteor timer: " + meteorTimer, 0,100);
		text("blackhole timer: " + holeTimer, 0,100);
		if(mousePressed){
			if(mouseButton == 3){
				slowmode = !slowmode;
			}
		}
		if(slowmode){
			framerate = 10;
			frameRate(framerate);
		} else {
			framerate = 60;
			frameRate(framerate);
		}
	}
}
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

  public void run() {
    display();
  }

  public void display() {
		fill(0);
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
  }

  public void initRotation() {
    if(pos == 1){
			rotation = random(0.523599f,2.094395f);

			x = -60;
			y = random(-60, height + 60);

    } else if(pos == 2){
      rotation = random(2.094395f,3.665191f);

			x = width + 60;
			y = random(-60, height + 60);

    } else if(pos == 3){
			rotation = random(3.665191f,5.235988f);

			x = random(-60, width + 60);
			y = width + 60;

    } else {
			rotation = random(5.235988f,6.806784f);

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
		fill(219,49,49);
    ellipse(x, y, radius, radius);
		if(debug){
  		textAlign(CENTER, TOP);
			textSize(20);
			text(rotation,x,y+radius);
		}
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
    fill(18,231,18);
    ellipse(x, y, radius, radius);
  }

  public void countOrbits() {
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
