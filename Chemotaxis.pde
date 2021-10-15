boolean started=false;
int myX = 550;
int myY = 350;
int score = 0;
float myoldR = 0;
float mynewR = 0;
float myV = 0;
class Cell{
  int x,y,t, infected;
  float xv, yv, s;
  boolean alive;
  Cell(int ax, int ay, int as){
    x=ax;
    y=ay;
    s=as;
    t=(int)random(100,300);
    infected = 0;
    xv=random(-1,1);
    yv=random(-1,1);
    alive=true;
  }
  void show(){
    if(infected==0){
      score+=1;
    }
    noStroke();  
    fill(0,infected,t-infected,99);
    if(s<200){
    ellipse(x,y,s,s);
    fill(0,infected,t/2,99);
    ellipse(x,y,s/2.3,s/2.3);
    if(infected==0){
    s+=.05;
    }else{
      s+=2;
    }
    }else{
      fill(0,infected,t-infected);
      ellipse(x-(s-200),y,200-(s-200),200-(s-200));
      ellipse(x+(s-200),y,200-(s-200),200-(s-200)); 
      fill(0,infected,t/2);
     ellipse(x-(s-200),y,(200-(s-200))/2,(200-(s-200))/2);
     ellipse(x+(s-200),y,(200-(s-200))/2,(200-(s-200))/2);     
      s+=1;
      if(s>300){
        s=90;
        x+=100;
        
       int j = (int)(random(0,80));
       cells[j].x=x-200;
       cells[j].y=y;
       cells[j].t=t;
       cells[j].s=90;
       cells[j].infected=infected;
       cells[j].alive=alive;
      }
    }
  }
  void move(){
    //if(a<30){
    //  x+=5;
    //}else{
      xv+=random(-.3,.3);
      yv+=random(-.3,.3);
      x+=xv;
      y+=yv;
      if((x>1100&&xv>0) || (x<0&&xv<0)){
        xv=xv/-1;
      }
      if((y>700&&yv>0)||(y<0&&yv<0)){
        yv=yv/-1;
      }
  if(abs(xv)>5){
    xv*=.3;
  }  
  if(abs(yv)>5){
    yv*=.3;
  }
  if(myX>(x-(s/2)) && myX<(x+(s/2)) && myY>(y-(s/2)) && myY<(y+(s/2)) && abs(myV)>1){
    //infected=150;
    alive=false;
  }
  if(millis()>3000 && started==false && random(1,50)>48){
    infected=150;
    started=true;
  }
}
}

Cell[] cells = new Cell[100];

void setup(){
  size(1100,700);
  int x = 150;
  int y = 100;
  for(int i=0; i<100; i++){
    x+=90;
    if(x>1000){
      x=150;
      y+=80;
    }
    cells[i]=new Cell((int)(random(x-25,x+25)),(int)(random(y-25,y+25)),(int)(random(70,180)));
  }
}

void draw(){
  background(80,80,250);
  score=0;
 for(int i=0; i<80; i++){
   if(cells[i].alive==true){
    cells[i].show();
    cells[i].move();
   }  
  }
  if(keyPressed){
   if(keyCode==RIGHT){ mynewR+=.1; } 
   if(keyCode==LEFT){mynewR-=.1;}
   if(keyCode==UP){myV+=.3;myoldR=mynewR;}  
  }else{
    myV=myV*0.98;
  }
  myX+=(int)(cos(myoldR)*myV);
  myY+=(int)(sin(myoldR)*myV);
  myX=constrain(myX,50,1050);
  myY=constrain(myY,50,650);
  fill(300,300,300);
  pushMatrix();
  translate(myX+40,myY);
  rotate(mynewR);
  triangle(40,0,-40,20,-40,-20);  
  translate(-myX-40,-myY);
  popMatrix();
  textSize(100);
  text(score,990,75);
}


