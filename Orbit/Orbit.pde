player player1;

blackhole blackhole1;

ArrayList<meteor> meteorList;

boolean gameover = false;

//Scoring stuff
String[] scores;
int highScore;

void setup() {
  size(800, 800);

  textAlign(CENTER, TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();

  meteorList = new ArrayList<meteor>();

  scores = loadStrings("data/Scores.txt");
  highScore = int(scores[0]);

  meteorList.add(new meteor(random(20,50),random(20,50),random(10,20),random(5,10),random(0,PI*2)));
}

void draw() {
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

void runMeteors() {
  for (int i = meteorList.size() - 1; i >= 0; i--) {

    meteorList.get(i).run();

    if (meteorList.get(i).checkCollision(player1)) {
      gameover = true;
    } else if (meteorList.get(i).checkOutOfBounds()) {
      meteorList.remove(i);
      meteorList.add(new meteor(random(20,50),random(20,50),random(10,20),random(5,10),random(0,PI*2)));
    }
  }
}

void checkGameover() {
  if (player1.checkCollision(blackhole1.x, blackhole1.y, blackhole1.radius)) {
    gameover = true;
  }
}

void reset() {
  player1 = new player();
}

void exit() {
  println(highScore);
  scores[0] = str(highScore);
  println(scores[0]);
  saveStrings("data/Scores.txt", scores);
  super.exit();
}
