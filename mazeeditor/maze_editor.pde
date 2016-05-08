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
// *** auto centering maze
// *** enable maze diffeernces
// * generate mazes
// 


//maze setup
Maze maze;
String[][] menuItems;

// dafault input values
int currentMaze = 0;
int Dmazex = 6;
int Dmazey = 6;
int mazeCellsDefault = 80;

int DwallWidth = 5;
int DfloorWidth = 30;


//shape options
public PShape startMark, goalMark,obj1,obj2;

//WALL var
static final int WALL = 0;
static final int FLOOR = 1;
static final int START = 10;
static final int GOAL = 11;
static final int OBJ1 = 21;

// export options
String mazeName = "alpha";
int madeDate = 160000;
public PGraphics pg = createGraphics(1200, 1580);




void setup(){
  size(400, 526);
  frameRate(20);
  
  startMark = loadShape("/svg/start.svg");
  goalMark = loadShape("/svg/goal.svg");
  obj1 = loadShape("/svg/biribiri.svg");
  
  maze = new Maze(Dmazex,Dmazey,DwallWidth,DfloorWidth);
  uiSetup();
  maze.refresh();
}

void draw(){
  maze.refresh();

  // show edit mode
  if (keyPressed == true &&( key == 'W' || key == 'w'))  fill(0,80);
  else fill(200,80);
  ellipse(mouseX,mouseY,30,30);
  
  if (keyPressed == true &&( key == 'S' || key == 's')) shape(startMark,mouseX,mouseY,30,30);
  if (keyPressed == true &&( key == 'G' || key == 'g')) shape(goalMark,mouseX,mouseY,30,30);
  if (keyPressed == true && key == '1' ) shape(obj1,mouseX,mouseY,30,30);
 
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



void mouseDragged(){
 //edit maze
  if (keyPressed == true &&( key == 'S' || key == 's'))maze.editMaze(START, mouseX, mouseY);
  if (keyPressed == true &&( key == 'G' || key == 'g'))maze.editMaze(GOAL, mouseX, mouseY);
  if (keyPressed == true &&( key == 'W' || key == 'w'))maze.editMaze(WALL, mouseX, mouseY);
  if (keyPressed == true && key == '1' )maze.editMaze(OBJ1, mouseX, mouseY);

  
  if (keyPressed == false) maze.editMaze(FLOOR, mouseX, mouseY);
}



void MazeSetup(int n,int m){
  //aim get maze size n, make 2n + 1 wall Array and n floor Arr.
  maze = new Maze(n,m);
  maze.refresh();
}


class Maze{

  //grid size
  int x;
  int y;

  //widths
  int wallwidth;
  int floorwidth;

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
  
  //init offsets
  this.makeoffsets();
  

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
        if (cell[i][j] == START) shape(startMark,posx,posy,tmpw,tmph);
        if (cell[i][j] == GOAL) shape(goalMark,posx,posy,tmpw,tmph);
        if (cell[i][j] == OBJ1) shape(obj1,posx,posy,tmpw,tmph);
        
        
        posx += tmpw;
        
      }
      posx = offsetx;
      posy += tmph;
    }
  }

  
   //this function is to export pg ... noubrain ...
  void refreshpg(int n, PGraphics pg){ // n means xn resolution
    //refresh All
    pg.noStroke();
    pg.fill(255);
    pg.rect(0,0,width,height);
    this.makeoffsets();
    
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
        if (cell[i][j] == START) pg.shape(startMark,posx,posy,tmpw,tmph);
        if (cell[i][j] == GOAL) pg.shape(goalMark,posx,posy,tmpw,tmph);
        if (cell[i][j] == OBJ1) pg.shape(obj1,posx,posy,tmpw,tmph);
        
        
        posx += tmpw;
        
      }
      posx = offsetx;
      posy += tmph;
    }
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
    if (mousestate == WALL && numx % 2 == 1 && numy % 2 == 1) return;
    
    //WALL space cannot be goal etc.
    if (mousestate > 9 && ( numx % 2 == 0 || numy % 2 ==0 ))return;
  
    cell[numx][numy] = mousestate;
    refresh();
    println("mouse is now "+ numx + "," + numy + "cell ,it becomes" + mousestate);

        

  }
  
  int cellNumberx(float pos){
    pos -= float(this.offsetx);
    return cellNumber(float(pos));
   

  }
  
  int cellNumbery(float pos){
    pos -= float(this.offsety);
    return cellNumber(float(pos));
  }

  //get position return cellnumber
  int cellNumber(float pos){ // **** koregahen
    int num;
    int t;
    int k; // atari hantei supporter

    int w = this.wallwidth;
    int f = this.floorwidth;
    if ( w < 5 ) k = int(5 - w);

    t =floor( pos  / int(w + f));

      if (pos > t * (w + f) + w + k)
        num = int(t * 2) + int(1);
      else num = 2 * t ;
    return num;
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
  
  void export(){ // same size
  maze.refresh();
  save("file.png");
  }
  
  void exportx3(){ //for print
  pg.beginDraw(); 
  maze.refreshpg(3,pg);
  pg.endDraw(); 
  pg.save("file.png");
  }

}


void uiSetup() {

  // set up UI items 
  menuItems = new String[] {
    new String[] {
      "ww001cebuMaze"
    }
    , new String[] {
      "ww000breakwallMaze"
    }
    , 
    new String[] {
      "ww000icetunnel"
    }
    , new String[] {
      "ww000icecave"
    }
  };
}

/* interface related things */

void setController ( Controller ctlr )
{
  // labels are supposed to be existing function names

  InterfaceElement element = ctlr.addSelection( "theMenu", menuItems);
  ctlr.setElementLabel( element, "Choose maze type" );


  InterfaceElement element = ctlr.addNumber( "mazexCallback", Dmazex);
  ctlr.setElementLabel( element, "mazeXnumber");

  InterfaceElement element = ctlr.addNumber( "mazeyCallback", Dmazey);
  ctlr.setElementLabel( element, "mazeYnumber" );

  InterfaceElement element = ctlr.addNumber( "mazewwCallback", DwallWidth);
  ctlr.setElementLabel( element, "wall width px" );

  InterfaceElement element = ctlr.addNumber( "mazefwCallback", DfloorWidth);
  ctlr.setElementLabel( element, "floor width px" );

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



void exportButton ()
{
  maze.exportx3();
}


void theMenu ( String value )
{
  currentMaze = int(value);
}

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


