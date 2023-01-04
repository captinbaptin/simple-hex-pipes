float sqrt3div2=0.86602540378443864676372317075294;

int xpos=50, ypos=50, hexSize=50;
int size=12;
DisjointSet hexMaze;
boolean[] hexWalls;
HexGrid boi;
int hexMX=-1, hexMY=-1;
boolean cheats=true;
int time, doneTime;




void setup() {
  size(1400, 900, JAVA2D);
  hexSize=min(width/((3*size+4)/2), int(height/((size+2)*sqrt3div2)));
  xpos=hexSize; ypos=xpos;
  reset();
}




void draw() {
  boolean done=boi.solved();
  background(128+int(!done), 128+int(done)*64, 128);
  if(doneTime<0 && done) { doneTime=millis()-time; }
  boi.disp(xpos, ypos, hexSize);
  fill(0);
  String tt="";
  if(doneTime<0) { tt+=millisToString(millis()-time); }
  else { tt+=millisToString(doneTime); }
  float TS=0.75*hexSize;
  textAlign(CENTER); textSize(TS);
  text(tt, width/2, height-0.1*TS);
  textAlign(LEFT); text("TIME:", xpos, height-0.1*TS);
}




void keyPressed() {
  if(key==ESC) { key=0; }
  if(key=='n') { reset(); }
}




void mousePressed() {
  updateHexM();
  if(hexMX>=0&&hexMY>=0) {
    if(mouseButton==LEFT && !boi.cell[hexMX][hexMY].locked) { boi.cell[hexMX][hexMY].rot++; boi.cell[hexMX][hexMY].rot%=6; }
    else if(mouseButton==RIGHT) { boi.cell[hexMX][hexMY].locked=!boi.cell[hexMX][hexMY].locked; }
  }
}




void reset() { makeHexPipes(); time=millis(); doneTime=-1; }




void makeHexPipes() {
  hexMaze=new DisjointSet(size*size);
  hexWalls=new boolean[size*size*3]; for(int i=0; i<hexWalls.length; i++) { hexWalls[i]=true; }
  int[] hexWallRandomOrder=randomOrder(hexWalls.length);
  for(int i=0; i<hexWalls.length; i++) {
    int x=hexWallRandomOrder[i]/(size*3), y=(hexWallRandomOrder[i]/3)%size, dir=hexWallRandomOrder[i]%3;
    int x2=x+int(dir==0)-int(dir==2), y2=y+int(dir==1||dir==2);
    if(x2>=0 && x2<size && y2<size) {
      int h1=x*size+y, h2=x2*size+y2;
      int h1rep=hexMaze.find(h1), h2rep=hexMaze.find(h2);
      if(h1rep!=h2rep) {
        hexMaze.merge(h1, h2);
        hexWalls[hexWallRandomOrder[i]]=false;
      }
    }
  }
  boi=new HexGrid(size);
  for(int i=0; i<hexWalls.length; i++) {
    int x=i/(size*3), y=(i/3)%size, dir=i%3;
    int x2=x+int(dir==0)-int(dir==2), y2=y+int(dir==1||dir==2); x2+=size*int(x2<0); x2%=size; y2%=size;
    boi.cell[x][y].edge[dir]=int(hexWalls[i]);
    boi.cell[x2][y2].edge[dir+3]=int(hexWalls[i]);
  }
  for(int i=0; i<size; i++) { for(int j=0; j<size; j++) {
    boi.cell[i][j].rot=int(random(6));
  } }
}




void updateHexM() {
  float tmx=mouseX-xpos, tmy=mouseY-ypos;
  tmy/=sqrt3div2;
  tmy/=hexSize;
  tmx-=int(int(tmy)%2==1)*hexSize/2;
  tmx/=hexSize;
  float offx=tmx%1, offy=tmy%1; offx-=0.5; offy-=0.5;
  if(offx*offx+offy*offy<0.25) {
    hexMY=int(tmy);
    hexMX=int(tmx);
    if(hexMX>=size+hexMY/2 || hexMY>=size) { hexMX=-1; hexMY=-1; }
    else { hexMX-=hexMY/2; }
    if(hexMX<0||hexMX>=size||hexMY<0||hexMY>=size) { hexMX=-1; hexMY=-1; }
  }
  else { hexMX=-1; hexMY=-1; }
}
