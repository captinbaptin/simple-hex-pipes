color water=color(128, 128, 255),
      pipe=color(255, 128, 128),
      selected=color(100, 128, 0),
      deselected=color(0, 128, 0),
      selectedHover=color(100, 128, 64),
      deselectedHover=color(0, 128, 64);




class HexGrid {
  int s;
  HexCell[][] cell;
  boolean[][] filled;
  HexGrid(int ts) {
    s=ts;
    cell=new HexCell[s][s];
    filled=new boolean[s][s];
    for(int i=0; i<s; i++) { for(int j=0; j<s; j++) {
      cell[i][j]=new HexCell();
    } }
  }
  
  boolean solved() {
    filled=new boolean[s][s];
    int numFilled=1;
    int[][] nextXY=new int[s*s][2];
    int nextInd=0;
    filled[0][0]=true;
    boolean[] checking=listConnectedDirections(0, 0);
    for(int i=0; i<6; i++) { if(checking[i]) {
      int x2=int(i==0)-int(i==2)-int(i==3)+int(i==5), y2=int(i==1||i==2)-int(i==4||i==5);
      filled[x2][y2]=true;
      nextXY[nextInd][0]=x2; nextXY[nextInd][1]=y2;
      nextInd++;
      numFilled++;
    } }
    while(nextInd>0) {
      nextInd--;
      int thisX=nextXY[nextInd][0], thisY=nextXY[nextInd][1];
      checking=listConnectedDirections(thisX, thisY);
      for(int i=0; i<6; i++) { if(checking[i]) {
        int x2=thisX+int(i==0)-int(i==2)-int(i==3)+int(i==5), y2=thisY+int(i==1||i==2)-int(i==4||i==5);
        if(!filled[x2][y2]) {
          filled[x2][y2]=true;
          nextXY[nextInd][0]=x2; nextXY[nextInd][1]=y2;
          nextInd++;
          numFilled++;
        }
      } }
    }
    return(numFilled==s*s);
  }
  boolean[] listConnectedDirections(int x, int y) {
    boolean[] ans=new boolean[6];
    for(int i=0; i<6; i++) {
      int x2=x+int(i==0)-int(i==2)-int(i==3)+int(i==5), y2=y+int(i==1||i==2)-int(i==4||i==5);
      int h1s=i-cell[x][y].rot+6*int(cell[x][y].rot>i);
      ans[i]=cell[x][y].edge[h1s]==0 && x2>=0 && x2<s && y2>=0 && y2<s && cell[x2][y2].edge[(i+3-cell[x2][y2].rot)%6+6*int(cell[x2][y2].rot>i+3)]==0;
    }
    return(ans);
  }
  
  
  void disp(float px, float py, float z) {
    if(cheats&&keyPressed && key==' ') {
      for(int i=0; i<s; i++) { for(int j=0; j<s; j++) {
        cell[i][j].dispCheat(px+(i+j/2)*z+z/2+int(j%2==1)*z/2, py+sqrt3div2*(j*z+z/2), z, false);
      } }
    }
    else {
      updateHexM();
      for(int i=0; i<s; i++) { for(int j=0; j<s; j++) {
        cell[i][j].disp(filled[i][j], px+(i+j/2)*z+z/2+int(j%2==1)*z/2, py+sqrt3div2*(j*z+z/2), z, i==hexMX&&j==hexMY);
      } }
    }
  }
}




class HexCell {
  int[] edge;
  int rot;
  boolean locked;
  HexCell() {
    edge=new int[6];
    rot=0;
    locked=false;
  }
  
  void dispCheat(float px, float py, float z, boolean mouseOver) {
    stroke(0); fill(0, 128, 128*int(mouseOver)); strokeWeight(1);
    ellipse(px, py, z, z);
    stroke(0, 0, 255); strokeWeight(z*0.1);
    for(int i=0; i<6; i++) { if(edge[i]==0) {
      float edgeang=PI*((i+rot)%6)/3;
      line(px, py, px+cos(edgeang)*z/2, py+sin(edgeang)*z/2);
    } }
  }
  
  void disp(boolean filled, float px, float py, float z, boolean mouseOver) {
    stroke(0);
    if(locked&&mouseOver) { fill(selectedHover); }
    else if(locked&&!mouseOver) { fill(selected); }
    else if(mouseOver) { fill(deselectedHover); }
    else { fill(deselected);  }
    //fill(128*int(locked), 128+64*int(locked), 128*int(mouseOver));
    strokeWeight(1);
    ellipse(px, py, z, z);
    if(filled) { stroke(water); }
    else { stroke(pipe); }
    //stroke(255*int(!filled), 0, 255*int(filled));
    strokeWeight(z*0.1);
    for(int i=0; i<6; i++) { if(edge[i]==0) {
      float edgeang=PI*((i+rot)%6)/3;
      line(px, py, px+cos(edgeang)*z/2, py+sin(edgeang)*z/2);
    } }
  }
}
