player player1;

blackhole blackhole1;

boolean gameover = false;

void setup(){
  size(800,800);

  textAlign(CENTER,TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();
}

void draw(){
  background(0,0,85);

  if(gameover == true){

  } else {

  player1.run();

  blackhole1.run();

  checkGameover();

  }
}

void checkGameover(){
  if(player1.checkCollision(blackhole1.x,blackhole1.y,blackhole1.radius)){
    gameover = true;
  }
}
