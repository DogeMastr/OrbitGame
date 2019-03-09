player player1;

blackhole blackhole1;

boolean gameover = false;

//Scoring stuff
String[] scores;
int highScore;

void setup(){
  size(800,800);

  textAlign(CENTER,TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();

  scores = loadStrings("data/Scores.txt");
  highScore = int(scores[0]);
}

void draw(){
  background(0,0,85);

  if(gameover == true){

    if(player1.orbits > highScore){
      highScore = player1.orbits;
    }

    text("Gameover!",width/2,height/3);
    text("Score: "+player1.orbits,width/2,height/2);
    text("Highscore: " + highScore,width/2,(height/3)*2);
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

void exit() {
  println(highScore);
  scores[0] = str(highScore);
  println(scores[0]);
  saveStrings("data/Scores.txt",scores);
  super.exit();
}
