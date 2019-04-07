player player1;

blackhole blackhole1;

ArrayList<meteor> meteorList;

ArrayList<item> itemList;

boolean gameover = false;

//Scoring stuff
String[] scores;

int topScore;
int secondScore;
int thirdScore;

String topName;
String secondName;
String thirdName;

String currentString;

boolean scoreChanged = false; //when the scores get pushed down it only happenes once
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

boolean startedTyping = false;
boolean das = false; //das = delayed auto shift, basicly stops the key being pressed every frame
int dasTimer;

void setup() {
  size(800, 800);

  textAlign(CENTER, TOP);
  textSize(40);

  player1 = new player();

  blackhole1 = new blackhole();

  meteorList = new ArrayList<meteor>();

	itemList = new ArrayList<item>();

  scores = loadStrings("data/Scores.txt");

	topScore = int(scores[0]);
	secondScore = int(scores[1]);
	thirdScore = int(scores[2]);

	topName = scores[4];
	secondName = scores[5];
	thirdName = scores[6];

	currentString = scores[4];

	meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));

	menu = true;
	debug = false;

	framerate = 60;
	frameRate(framerate);
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
	text("Click to move!",width/2,height/6);
	text("Press any key to start!", width/2, (height/6)*2);

	text(currentString + ": " + topScore, width/2, (height/6)*3.5);
	text(secondName + ": " + secondScore, width/2, (height/6)*4);
	text(thirdName + ": " + thirdScore, width/2, (height/6)*4.5);

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
		if (player1.orbits >= topScore) { // you got the highest score
			if(!scoreChanged){
				thirdScore = secondScore; //moves the other scores down to the top score is now the second one
				thirdName = secondName;

				secondScore = topScore;
				secondName = topName;

				topScore = player1.orbits;
				scoreChanged = true; //the scores have been changed
			}

			text("You got the top score!", width/2, height/6);

			text(currentString + ": " + topScore, width/2, (height/6)*3.5);
			text(secondName + ": " + secondScore, width/2, (height/6)*4);
			text(thirdName + ": " + thirdScore, width/2, (height/6)*4.5);
			startedTyping = true;
			if(startedTyping == false || keyPressed && key == ENTER){ //finished typing
				topName = currentString;
				reset();
			}
    } else if (player1.orbits >= secondScore) { // you got the second  highest score
			if(!scoreChanged){
				thirdScore = secondScore; //moves the other scores down to the top score is now the second one
				thirdName = secondName;

				secondScore = player1.orbits;
				scoreChanged = true;
			}

			text("You got the second top score!", width/2, height/6);

			text(topName + ": " + topScore, width/2, (height/6)*3.5);
			text(currentString + ": " + player1.orbits, width/2, (height/6)*4);
			text(thirdName + ": " + thirdScore, width/2, (height/6)*4.5);
			startedTyping = true;
			if(startedTyping == false || keyPressed && key == ENTER){ //finished typing
				secondName = currentString;
				reset();
			}
		} else if (player1.orbits >= thirdScore) { // you got the second  highest score
			if(!scoreChanged){
	      thirdScore = player1.orbits;
				scoreChanged = true;
			}

			text("You got the third top score!", width/2, height/6);

			text(topName + ": " + topScore, width/2, (height/6)*3.5);
			text(secondName + ": " + secondScore, width/2, (height/6)*4);
			text(currentString+ ": " + player1.orbits, width/2, (height/6)*4.5);
			startedTyping = true;
			if(startedTyping == false || keyPressed && key == ENTER){ //finished typing
				thirdName = currentString;
				reset();
			}
		} else { // you didnt get a top score
			textAlign(CENTER, TOP);
			textSize(40);
    	text("Gameover!", width/2, height/6);
    	text("Score: "+player1.orbits, width/2, (height/6)*2);
    	text(topName + ": " + topScore, width/2, (height/6)*3.5);
    	text(secondName + ": " + secondScore, width/2, (height/6)*4);
    	text(thirdName + ": " + thirdScore, width/2, (height/6)*4.5);
			if (keyPressed) {
				reset();
			}
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
	if(itemList.size() < 1){
		itemList.add(new item((int)random(1,4),random(10,20),random(5,10),(int)random(1,5)));
	}
}

void checkGameover() {
  if (player1.checkCollision(blackhole1.x, blackhole1.y, blackhole1.radius)) {
    gameover = true;
  }
}

void reset() {
  player1 = new player();
	startedTyping = false;
	currentString = "enter your name";
	gameover = false;
	scoreChanged = false;

	for (int i = meteorList.size() - 1; i >= 0; i--) {
		meteorList.remove(i);
	}

	for (int i = itemList.size() - 1; i >= 0; i--) {
		itemList.remove(i);
	}

	meteorList.add(new meteor((int)random(1,5),(int)random(10,20),(int)random(5,10)));
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

void keyTyped() {
	if(startedTyping){
  	if (key == BACKSPACE && currentString.length() > 0) {
    	currentString = currentString.substring(0, currentString.length()-1);
  	} else if (key == BACKSPACE) {
  	} else if (key == ENTER) {
			startedTyping = false; //finished typing
			println("finsihed Typing");
		} else {
    	currentString += key;
  	}
	}
}

void exit() {
	saveStrings("data/Scores.txt", scores);
	super.exit();
}
