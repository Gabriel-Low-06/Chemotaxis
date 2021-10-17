int started=0; //how many viruses have been spawned;
int myX = 550; //x of ship
int myY = 350;//y of ship
float timer=0;//stores when new section starts
int level = 1; //level
float score = 1; //score (how many non-viruses are alive)
float allcount=1; //how many cells are alive
float myoldR = 0; //rotational position when ship started thrust (affects trajectory)
float mynewR = 0; //curent rotation (affects visual but not trajectory)
float myRV = 0; //rotational velocity
float myV = 0;//magnitutde of ships velocity
int[]highscore = new int[12]; //array to store highscores for levels
boolean newscore = false;//if you got a new highscore
class Cell {
  float x, y;
  int tint; //x coordinate, y coordinate, color
  float xv, yv, s; //x velocity, y velocity, size
  boolean alive, infected; //if cell is alive, if cell is infected
  Cell(int ax, int ay, int as) { //initializes cell
    x=ax;
    y=ay;
    s=as;
    tint=color(0, 0, (int)random(100, 300));
    xv=random(-3, 3);
    yv=random(-3, 3);
    alive=true;
    infected=false;
  }
  void show() {
    if (infected==false) { //if cell is not infected, add to score count
      score+=1;
    }
    noStroke();
    fill(tint, 99);
    if (s<200) { //if cell is not duplicating, draw normally
      ellipse(x, y, s, s);
      fill(0, 0, 100, 99);
      ellipse(x, y, s/2.3, s/2.3);
      if (infected==false) { //if cell is not infected, grow a little
        s+=.05;
      } else {
        s+=level/2; //if cell is infected, grow a LOT (grows more at harder levels)
      }
    } else { //if cell is greater than threshold split into two cells drifting apart
      fill(tint);
      ellipse(x-(s-200), y, 200-(s-200), 200-(s-200));
      ellipse(x+(s-200), y, 200-(s-200), 200-(s-200));
      fill(0, 0, 100);
      ellipse(x-(s-200), y, (200-(s-200))/2, (200-(s-200))/2);
      ellipse(x+(s-200), y, (200-(s-200))/2, (200-(s-200))/2);
      s+=1;
      if (s>300) { //once cells split, set main cell to right cell data and replaced data of random other cell with left cell
        s=90;
        x+=100;
        int j = (int)(random(0, 80));
        cells[j].x=x-200;
        cells[j].y=y;
        cells[j].tint=tint;
        cells[j].s=90;
        cells[j].infected=infected;
        cells[j].alive=alive;
      }
    }
  }
  void move() {
    if(infected==false || level<2){
    x+=random(-5, 5); //random walk
    y+=random(-5, 5);
    }else{
    xv+=random(-.3, .3); //random walk
    yv+=random(-.3, .3); 
    x+=xv; //update x and y position
    y+=yv;
    if ((x>1100&&xv>0) || (x<0&&xv<0)) { //if hit boundaries, bounce back
      xv=xv/-1;
    }
    if ((y>700&&yv>0)||(y<0&&yv<0)) {
      yv=yv/-1;
    }
    if (abs(xv)>5) { //if moving too fast, slow down
      xv*=.3;
    }
    if (abs(yv)>5) {
      yv*=.3;
    }
    }
    if (myX>(x-(s/2)) && myX<(x+(s/2)) && myY>(y-(s/2)) && myY<(y+(s/2)) && abs(myV)>1) { //if ship hits cell, kill cell
      alive=false;
      noFill();
      strokeWeight(5);
      stroke(300, 300, 300);
      ellipse(x, y, 250, 250); //draw brief flash
    }
    if (millis()-timer>3000 && started<level && random(1, 50)>48) { //infect some random cells at beginning of each game
      infected=true;
      tint=color(200, 0, 50);
      started+=1;
    }
  }
}

Cell[] cells = new Cell[100];//declare array of cells

void setup() {
  size(1100, 700);
  int x = 150; //initial ship coordinates
  int y = 100;
  for (int i=0; i<100; i++) { //initialize array of cells
    x+=90;
    if (x>1000) {
      x=150;
      y+=80;
    }
    cells[i]=new Cell((int)(random(x-25, x+25)), (int)(random(y-25, y+25)), (int)(random(70, 180)));
  }
  for(int i=0;i<12;i++){
    highscore[i]=0;
  }
}

void initgame() { //reset everything to initial values
  int x = 150;
  int y = 100;
  for (int i=0; i<100; i++) {
    x+=90;
    if (x>1000) {
      x=150;
      y+=80;
    }
    cells[i]=new Cell((int)(random(x-25, x+25)), (int)(random(y-25, y+25)), (int)(random(70, 180)));
  }
  score = 0;
  allcount=1;
  myoldR = 0;
  mynewR = 0;
  myRV = 0;
  myV = 0;
  myX=550;
  myY=350;
  timer=millis();
  started=0;
}

void draw() {

  if (level%2==1) { //if playing a level...
    background((allcount-score)*6, 0, (score/allcount)*200); //clear frame
    score=0;
    allcount=0;
    for (int i=0; i<80; i++) { //cycle through all cells
      if (cells[i].alive==true) { //if alive, draw the cell and update its position
        cells[i].show();
        cells[i].move();
        allcount+=1;
      }
    }
    if (keyPressed) {
      if (keyCode==RIGHT) { //controls movement of ship
        myRV+=.01;
      }
      if (keyCode==LEFT) {
        myRV-=.01;
      }
      if (keyCode==UP) {
        myV+=.3;
        if (myV<10) {
          myoldR=mynewR;
        }
      }
    } else {
      myV=myV*0.99; //slow down the ship if not moving
      myRV*=.85;
    }
    mynewR+=myRV;
    myX+=(int)(cos(myoldR)*myV); //update values based on current velocity
    myY+=(int)(sin(myoldR)*myV);

    myRV=constrain(myRV, -.1, .1); //constrain values to reasonable limits
    myV=constrain(myV, -10, 10);
    myX=constrain(myX, 50, 1050);
    myY=constrain(myY, 50, 650);

    fill(300, 300, 300);
    pushMatrix();
    translate(myX, myY);
    rotate(mynewR);
    triangle(40, 0, -40, 20, -40, -20); //draw ship
    translate(-myX, -myY);
    popMatrix();

    textSize(100);
    text((int)(score), 970, 85);//write score
    textSize(50);
    text("Level "+ (((level-1)/2)+1),10,50);
    
    if ((allcount-score==0 && millis()-timer>5000)||score==0) { //if you win or lose game, go to endscreen
     if(score>highscore[(((level-1)/2)+1)]){
        highscore[(((level-1)/2)+1)]=(int)score;
        newscore=true;
      }
      level+=1;
      timer=millis();
    }
  } else { //if at end screen
    fill(300, 300, 300);
    ellipse(550, 350, (millis()-timer)*2, (millis()-timer)*2); //wipe out screen with a growing circle effect
    if (millis()-timer>1000) { //after brief delay
      if (score!=0) { //if you won, show winnning screen
        textSize(200);
        fill(0, 0, 300);
        if(newscore==false){
        text("You Win!", 250, 350);
        }else{
          textSize(150);
          text("New Highscore!", 20, 350);
        }
        textSize(100);
        fill(0, 0, 0);
        text("Score: "+(int)score, 350, 500);
        textSize(50);
        fill(0,0,300);
        text("Highscore: "+ highscore[(level/2)], 10, 60);
        int tinty = abs(300-(millis()%600));
        int tinty2 = abs(900-(millis()%1800))/3;
        tinty=constrain(tinty, 10, 290);
        tinty2=constrain(tinty2, 10, 290);
        fill(tinty2, 300-tinty, tinty);
        text("Hit Left to play again", 100, 600);
        text("Hit Right to Level Up", 500, 650);
      } else {
        textSize(200); //if you lost, show losing screen
        fill(300, 0, 0);
        text("Sorry", 250, 350);
        textSize(75);
        fill(0, 0, 0);
        text("Hit Left to Try again", 200, 500);
      }
      if (keyPressed==true && keyCode==LEFT) { //control replaying and advancing to new level
        level-=1;
        initgame();
      }
      if (keyPressed==true && keyCode==RIGHT) {
        level+=1;
        initgame();
      }
    }
  }
}
