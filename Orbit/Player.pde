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

  void run(){
    move();
    display();
    countOrbits();
  }

  void move(){
    orbitTime += 4/orbitRadius;
    if(mousePressed){
      orbitRadius++;
    } else {
      orbitRadius -= 0.8;
    }
    x = (centerX + orbitRadius * cos(orbitTime));
    y = (centerY + orbitRadius * sin(orbitTime));
  }

  void display(){
    fill(255);
    ellipse(x,y,radius,radius);
  }

  void countOrbits(){
    text(orbits,width/2,height/4);
  }

  boolean checkCollision(float eX, float eY, float eR){
    if(dist(x,y,eX,eY) < eR + radius){
      return true;
    } else {
      return false;
    }
  }
}
