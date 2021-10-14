class Cell{
  int x,y,t, infected;
  float xv, yv, s;
  Cell(int ax, int ay, int as){
    x=ax;
    y=ay;
    s=as;
    t=(int)random(100,300);
    infected = 0;
    xv=random(-1,1);
    yv=random(-1,1);
  }
  void show(){
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
  if(mousePressed==true && mouseX>(x-(s/2)) && mouseX<(x+(s/2)) && mouseY>(y-(s/2)) && mouseY<(y+(s/2))){
    infected=150;
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
 for(int i=0; i<80; i++){
    cells[i].show();
    cells[i].move();
  }
  
}

