class meteor{

  float x;
  float y;
  float radius;

  float speed;
  float rotation;

  float xMoveSpeed;
  float yMoveSpeed;

  // meteor(random(20,50),random(20,50),random(5,10),random(5,30),random(0,PI*2))
  meteor(float _x, float _y, float _r, float _s, float _ro){
    x = _x;
    y = _y;
    radius = _r;

    speed = _s;
    rotation = _ro;

    initRotation();
  }

  void initRotation(){
    //x & y values are random 20 - 50, depending on rotation add width +| height
    //Clock face but in PI
    //       2*PI
    // PI*1.5    PI/2
    //       PI
    if(rotation >= 0 && rotation <= PI/2){
      //going top right
      x = 0 - x;
      y = y + height;
    } else if(rotation >= PI/2 && rotation <= PI){
      //going bottom right
      x = 0 - x;
      y = 0 - y;
    } else if(rotation >= PI && rotation <= PI*1.5){
      //going bottom left
      x = x + width;
      y = 0 - y;
    } else {
      //going top left
      x = x + width;
      y = y + height;
    }
  }

  void run(){
    display();
    move();
  }

  void display(){
    ellipse(x,y,radius,radius);
  }

  void move(){
    x += xMoveSpeed;
    y += yMoveSpeed;
  }

  boolean checkCollision(player e){
    if(dist(x,y,e.x,e.y) < e.radius + radius){
      return true;
    } else {
      return false;
    }
  }

  boolean checkOutOfBounds(){
    if(x > width + radius * 3){
      return true;
    } else if (x < 0 - radius * 3){
      return true;
    } else if (y > height + radius * 3){
      return true;
    } else if (y < 0 - radius * 3){
      return true;
    } else {
      return false;
    }
  }
}
