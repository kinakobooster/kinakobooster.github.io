/**
 *    drag to erase Wall <br />
 *    press W and drag to draw wall again <br />
 *     <br />
 *    press S or G and drag to put Start or Goal <br />
 *    press number... put an object! <br />
 *     <br />
 *    
 *    works by standard Processing. <br />
 *
 *    <form id="form-form"><!-- empty --></form>
 *    <!-- the following css adds a tiny bit of layout -->
 *    <style>textarea,input,label,select{display:block;width:50%}select{width:97.5%}
 *    input[type=checkbox],input[type=radio]{width: auto}textarea{height:5em}</style>
 */

//korekara TODO
// 
// *** enable maze diffeernces
// * generate mazes
// 


//maze setup
Maze maze;
String[][] menuItems;

// dafault input values
int currentMaze = 0;
int Dmazex = 5;
int Dmazey = 5;
int mazeCellsDefault = 80;

int DwallWidth = 3;
int DfloorWidth = 45;

public int DstoneSize = 30;
public  int DstoneStroke= 15;


//shape options
public PShape black, white;

//WALL var
static final int WALL = 0;
static final int FLOOR = 1;
static final int BLACK = 10;
static final int WHITE = 11;


// export options
String mazeName = "igo";
int madeDate = 160000;
public PGraphics pg = createGraphics(2400, 3160);
public PGraphics isi;
public PGraphics pgisi = createGraphics(2400, 3160);



void setup(){
  size(400, 526, P2D);
  frameRate(20);
  isi = createGraphics(width,height);
  
  maze = new Maze(Dmazex,Dmazey,DwallWidth,DfloorWidth);
  uiSetup();
  maze.refresh();
}

void draw(){
  maze.refresh();
  // show edit cursotr
  fill(0,50);
  ellipse(mouseX,mouseY,30,30);
}

boolean RectOver( int x, int y, int w,int h){
  //mouseover on rect?
  if (mouseX >= x && mouseX <= x+w &&
    mouseY >= y && mouseY <= y+h) {
      return true;
      } else {
        return false;
      }
    }



void mouseClicked(){
 //edit maze
 maze.putStone();
}



void MazeSetup(int n,int m){
  //aim get maze size n, make 2n + 1 wall Array and n floor Arr.
 // maze = new Maze(n,m);
  maze.refresh();
}


class Maze{

  //grid size
  int x;
  int y;

  //widths
  int wallwidth;
  int floorwidth;
  int stoneSize;
  float stoneStroke;
  
  //wall var
  int cell[][];
  
  int offsetx;
  int offsety;


  Maze(int x,int y, int ww, int fw){
    //init cells
    this.x = x;
    this.y = y;
    this.cell = new int[2 * mazeCellsDefault + 1 ][2 * mazeCellsDefault + 1];
    for (int i = 0; i < 2 * mazeCellsDefault + 1 ; i++){
      for(int j = 0; j < 2 * mazeCellsDefault + 1 ; j++){
        if(i % 2 == 0) cell[i][j] = WALL;
        else if (j % 2 == 0) cell[i][j] = WALL;
        else cell[i][j] = FLOOR;
      }
    }

  //init widths
  this.wallwidth = ww;
  this.floorwidth = fw;
  this.stoneSize = DstoneSize;
  this.stoneStroke = DstoneStroke/10;
  
  
  //init offsets
  this.makeoffsets();
  

  }
  
  void putStone(){
  //put stone on mouse
  
  int status = 0;
  //change maze state at (0,0),(0,2),(2,2),,,
   editMaze(0,mouseX,mouseY);
  
  
  }
  
  

  void makeoffsets(){
  // maze centering offset 
  int mazewidth  = int(x * floorwidth + x  * wallwidth + int(wallwidth));
  int mazeheight = int(y * floorwidth + y  * wallwidth + int(wallwidth));
  
  offsetx = int((width  - mazewidth ) /2);  
  offsety = int((height - mazeheight) /2);
  
  //println("offx is "+ offsetx + ", offy is" +offsety );
  
  }
  
  
  
  void refresh(){
    refreshxn(1);
  }

  void refreshxn(int n){
    //refresh All
    noStroke();
    fill(255);
    rect(0,0,width,height);
    this.makeoffsets();
    isi.background(0,0);
    
    //draw maze
    int tmpw,tmph,posx,posy;
    tmpw = 0;
    tmph = 0;
    posx = offsetx;
    posy = offsety;
    
    //draw maze
    for(int j = 0; j < 2 * y + 1 ; j++){
      for (int i = 0; i < 2 * x + 1 ; i++){

        //val wall
        if(j % 2 == 0) tmph = int(this.wallwidth * n);
        else tmph = int(this.floorwidth * n);

        //col wall
        if (i % 2 == 0) tmpw = int(this.wallwidth * n);
        else tmpw = int(this.floorwidth * n);

        //wall? floor? other?
        if (cell[i][j] == WALL) fill(0);
        else noFill();
        
        //draw rect (wall,floor)
        rect(posx,posy,tmpw,tmph);
        
        //draw mats
        
        if (cell[i][j] == BLACK){ 
          isi.beginDraw();
          isi.fill(0);
          isi.stroke(0);
          isi.ellipse(posx + wallwidth/2,posy + wallwidth/2, DstoneSize,DstoneSize);
          isi.noStroke();
          isi.endDraw();
        }
       
        if (cell[i][j] == WHITE){
          isi.beginDraw();
          isi.fill(255);
          isi.stroke(0);
          isi.strokeWeight(stoneStroke);
          isi.ellipse(posx + wallwidth/2,posy + wallwidth/2, DstoneSize,DstoneSize);
          isi.noStroke();
          isi.endDraw();
        }
        
        
        
        posx += tmpw;
        
      }
      posx = offsetx;
      posy += tmph;
    }
      image(isi,0,0);
  }

  
   //this function is to export pg ... noubrain ...
  void refreshpg(int n){
    //refresh All
    pg.noStroke();
    pg.fill(255);
    pg.rect(0,0,width,height);
    this.makeoffsets();
    pgisi.background(0,0);
    
    //draw maze
    int tmpw,tmph,posx,posy;
    tmpw = 0;
    tmph = 0;
    posx = offsetx;
    posy = offsety;
    
    //draw maze
    for(int j = 0; j < 2 * y + 1 ; j++){
      for (int i = 0; i < 2 * x + 1 ; i++){

        //val wall
        if(j % 2 == 0) tmph = int(this.wallwidth * n);
        else tmph = int(this.floorwidth * n);

        //col wall
        if (i % 2 == 0) tmpw = int(this.wallwidth * n);
        else tmpw = int(this.floorwidth * n);

        //wall? floor? other?
        if (cell[i][j] == WALL) pg.fill(0);
        else pg.noFill();
        
        //draw rect (wall,floor)
        pg.rect(posx,posy,tmpw,tmph);
        
        //draw mats
        
        if (cell[i][j] == BLACK){ 
          pgisi.beginDraw();
          pgisi.fill(0);
          pgisi.stroke(0);
          pgisi.ellipse(posx + wallwidth * n/2,posy + wallwidth * n/2, stoneSize * n,stoneSize * n);
          pgisi.noStroke();
          pgisi.endDraw();
        }
       
        if (cell[i][j] == WHITE){
          pgisi.beginDraw();
          pgisi.fill(255);
          pgisi.stroke(0);
          pgisi.strokeWeight(stoneStroke * 6);
          pgisi.ellipse(posx + wallwidth * n/2,posy + wallwidth * n/2, stoneSize * n,stoneSize * n);
          pgisi.noStroke();
          pgisi.endDraw();
        }
        
        
        
        posx += tmpw;
        
      }
      posx = offsetx;
      posy += tmph;
    }
      
      pg.image(pgisi,0,0);
      
  }


  void editMaze(int mousestate,float mouseX,float mouseY){
    //save cell num
    int numx,numy;
    //get mousePos and return cellnum
    numx = cellNumberx(mouseX);
    numy = cellNumbery(mouseY);
    
    if (numx < 0 || numx > 2 * x + 1) return;
    if (numy < 0 || numy > 2 * y + 1) return;
    
    //floor space cannnot be WALL
   // if (mousestate == WALL && numx % 2 == 1 && numy % 2 == 1) return;
    
    //WALL space cannot be goal etc.
    //if (mousestate > 9 && ( numx % 2 == 0 || numy % 2 ==0 ))return;
    
    if(cell[numx][numy] == WALL) mousestate = BLACK;
    else if (cell[numx][numy] == BLACK) mousestate = WHITE;
    else if (cell[numx][numy] == WHITE) mousestate = WALL;
    else  return;
    
    cell[numx][numy] = mousestate;
    
    refresh();
   // println("mouse is now "+ numx + "," + numy + "cell ,it becomes" + mousestate);

        

  }
  
  int cellNumberx(float pos){
    pos -= float(this.offsetx);
    return cellNumber(pos);
   

  }
  
  int cellNumbery(float pos){
    pos -= float(this.offsety);
    return cellNumber(pos);
  }

  //get position return cellnumber
  int cellNumber(float pos){ 
    int num;
    int t;
    int w = this.wallwidth;
    int f = this.floorwidth;
    
    pos += f/2;
    t =floor( pos  / int(w + f));
    
    
    return 2 * t ;
    
    
  }

// UI options
  void xCallback(int value){
    this.x = value ;
  }
  void yCallback(int value){
    this.y = value ;
  }
  void wwCallback(int value){
    this.wallwidth = int(value) ;
  }
  void fwCallback(int value){
    this.floorwidth = int(value) ;
  }
  
  void ssCallback(int value){
    this.stoneSize= int(value) ;
  }
  void ststCallback(int value){
    this. stoneStroke = value / 10 ;
  }
  
 
  
  
  void export(){ // same size
  maze.refresh();
  save("file.png");
  }
  
  void exportx3(){ //for print
  pg.beginDraw(); 
  maze.refreshpg(6,pg);
  pg.endDraw(); 
  pg.save("file.png");
  pgisi.save("file2.png");
  }
   
   /*
  void changeMazeType(int mazeType){
    switch (mazeType){
    case 0: //tedukuri 
        startMark = loadShape("/svg/tedu/start.svg");
        goalMark = loadShape("/svg/tedu/goal.svg");
        obj1 = loadShape("/svg/biribiri.svg");
        break;
        
    case 1: //biribiri
        startMark = loadShape("/svg/biri/start.svg");
        goalMark = loadShape("/svg/biri/goal.svg");
        obj1 = loadShape("/svg/biri/biribiri.svg");
        break;
    default:
        startMark = loadShape("/svg/start.svg");
        goalMark = loadShape("/svg/goal.svg");
        obj1 = loadShape("/svg/biribiri.svg");
    }
    refresh();
  
  
  }
  
  */
  
  
}

void uiSetup() {

}

/* interface related things */

void setController ( Controller ctlr )
{
  // labels are supposed to be existing function names

/*
  InterfaceElement element = ctlr.addSelection( "theMenu", menuItems);
  ctlr.setElementLabel( element, "Choose maze type" );
*/

  InterfaceElement element = ctlr.addNumber( "mazexCallback", Dmazex);
  ctlr.setElementLabel( element, "mazeXnumber");

  InterfaceElement element = ctlr.addNumber( "mazeyCallback", Dmazey);
  ctlr.setElementLabel( element, "mazeYnumber" );

  InterfaceElement element = ctlr.addNumber( "mazewwCallback", DwallWidth);
  ctlr.setElementLabel( element, "wall width px" );

  InterfaceElement element = ctlr.addNumber( "mazefwCallback", DfloorWidth);
  ctlr.setElementLabel( element, "floor width px" );
  
  InterfaceElement element = ctlr.addNumber( "mazessCallback", DstoneSize);
  ctlr.setElementLabel( element, "stone size" );
  
    InterfaceElement element = ctlr.addNumber( "mazeststCallback", DstoneStroke);
  ctlr.setElementLabel( element, "white stone stroke" );


  InterfaceElement element = ctlr.addCheckbox("exportButton");
  ctlr.setElementLabel( element, "export button" );
}


/* callbacks */
void mazexCallback ( int value )
{
  maze.xCallback(value);
  Dmazex = value;
}
void mazeyCallback ( int value )
{
  maze.yCallback(value);
  Dmazey = value;
}
void mazewwCallback ( int value )
{
  maze.wwCallback(value);
  DwallWidth = value;
}
void mazefwCallback ( int value )
{
  maze.fwCallback(value);
  DfloorWidth = value;
}
void mazessCallback ( int value )
{
  maze.ssCallback(value);
  DstoneSize = value;
}
void mazeststCallback ( int value )
{
  maze.ststCallback(value);
  DstoneStroke = value;
}



void exportButton ()
{
  maze.exportx3();
}

/*
void theMenu ( String value )
{
  currentMaze = int(value);
  maze.changeMazeType(currentMaze);
}
*/

/* ... and the interfaces */

/* explain InputElement to Processing */
interface InputElement
{
  String type;
  String id;
  Object value;
}

/* explain Controller to Processing */
interface Controller
{
  InputElement addRange ( String label, float initialValue, float minValue, float maxValue );
  void setLabel ( InputElement element, String label );
}


