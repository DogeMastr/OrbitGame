player player1;

blackhole blackhole1;

ArrayList<meteor> meteorList;

ArrayList<item> itemList;

boolean gameover = false;

//Scoring stuff
String[] scores;
int highScore;

//timing stuff
int pastSecond;
boolean timer;
int meteorTimer;
int holeTimer;
int itemTimer;

boolean menu;

boolean debug;
int framerate;
boolean slowmode = false;

void setup() {
  size(800, 800);

  textAlign(CENTER, TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();

  meteorList = new ArrayList<meteor>();

	itemList = new ArrayList<item>();

  scores = loadStrings("data/Scores.txt");
  highScore = int(scores[0]);

	meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));

	menu = true;
	debug = false;

	framerate = 60;
	frameRate(framerate);

	println(itemList.size());
}

void draw() {
  background(0, 0, 85);
	if(menu){
		menu();
	} else {
		play();
	}
}

void menu(){
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
void play(){
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
		runTimer();

    player1.run();

    blackhole1.run();

    runMeteors();

		runItems();

    checkGameover();

		textSize(40);
		textAlign(CENTER,CENTER);
		fill(255);
		text(player1.orbits, width/2, height/2);

		debugMode();
  }
}

void runTimer(){ //universal timer that sets to true for one frame every second
	if(pastSecond != second()){
		pastSecond = second();
		timer = true;
	} else {
		timer = false;
	}
}

void runMeteors() {
  for (int i = meteorList.size() - 1; i >= 0; i--) {

    meteorList.get(i).run();

    if (meteorList.get(i).checkCollision(player1)) {
      gameover = true;
    } else if (meteorList.get(i).checkOutOfBounds()) {
      meteorList.remove(i);
      meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
    }

		if (meteorList.get(i).checkNMissCollision(player1)){
			player1.addScore(1);
		}
  }

	//getting another meteor every so often
	if(timer){
		meteorTimer++;
	}
	if(meteorTimer >= 30){
		meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
		meteorTimer = 0;
	}
}

void runItems(){
	for (int i = itemList.size() - 1; i >= 0; i--) {

		itemList.get(i).run();

		if (itemList.get(i).checkCollision(player1)) {
			itemList.get(i).collected();
			itemList.remove(i);

		} else if (itemList.get(i).checkOutOfBounds()) {
			itemList.remove(i);
		}
	}

	//getting another item every so often
	if(timer){
		itemTimer++;
	}
	if(itemTimer >= 2){
		itemList.add(new item((int)random(1,4),random(10,20),random(5,10),(int)random(1,5)));
		itemTimer = 0;
	}
}

void checkGameover() {
  if (player1.checkCollision(blackhole1.x, blackhole1.y, blackhole1.radius)) {
    gameover = true;
  }
}

void reset() {
  player1 = new player();

	for (int i = meteorList.size() - 1; i >= 0; i--) {
		meteorList.remove(i);
	}

	for (int i = itemList.size() - 1; i >= 0; i--) {
		itemList.remove(i);
	}
}

void exit() {
  println(highScore);
  scores[0] = str(highScore);
  println(scores[0]);
  saveStrings("data/Scores.txt", scores);
  super.exit();
}

void debugMode(){
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
