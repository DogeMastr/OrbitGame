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

boolean gameover = false;

public void setup(){
  

  textAlign(CENTER,TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();
}

public void draw(){
  background(0,0,85);

  if(gameover == true){

  } else {

  player1.run();

  blackhole1.run();

  checkGameover();

  }
}

public void checkGameover(){
  if(player1.checkCollision(blackhole1.x,blackhole1.y,blackhole1.radius)){
    gameover = true;
  }
}
class blackhole{
  float x;
  float y;
  float radius;

  blackhole(){
    x = width/2;
    y = width/2;
    radius = 20;

    println("init: " + this);
  }

  public void run(){
    display();
  }

  public void display(){
    ellipse(x,y,radius*2,radius*2);
  }
}
class player{
  float centerX;
  float centerY;

  float x;
  float y;
  float radius;

  float orbitTime;
  float orbitRadius;

  int orbits; //score
  player(){
    centerX = width/2;
    centerY = height/2;

    radius = 10;

    orbitTime = 800;
    orbitRadius = 400;

    orbits = 0;

    println("init: "+ this);
  }

  public void run(){
    move();
    display();
    countOrbits();
  }

  public void move(){
    orbitTime += 4/orbitRadius;
    if(mousePressed){
      orbitRadius++;
    } else {
      orbitRadius -= 0.8f;
    }
    x = (centerX + orbitRadius * cos(orbitTime));
    y = (centerY + orbitRadius * sin(orbitTime));
  }

  public void display(){
    fill(255);
    ellipse(x,y,10,10);
  }

  public void countOrbits(){
    text(orbits,width/2,height/4);
  }

  public boolean checkCollision(float eX, float eY, float eR){
    if(dist(x,y,eX,eY) < eR + radius){
      return true;
    } else {
      return false;
    }
  }
}
  public void settings() {  size(800,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Orbit" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
