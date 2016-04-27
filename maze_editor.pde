/**
 *    drag to erase Wall <br />
 *    press SPACE and drag to draw wall again <br />
 *    works by standard Processing. <br />
 *
 *    <form id="form-form"><!-- empty --></form>
 *    <!-- the following css adds a tiny bit of layout -->
 *    <style>textarea,input,label,select{display:block;width:95%}select{width:97.5%}
 *    input[type=checkbox],input[type=radio]{width: auto}textarea{height:5em}</style>
 */


//迷路の用意
Maze maze;

String[][] menuItems;

// dafault input values
int currentMaze = 0;
int Dmazex = 6;
int Dmazey = 6;
int mazeCellsDefault = 80;

int DwallWidth = 5;
int DfloorWidth = 30;

int drawMode = 1;

String mazeName = "alpha";
int madeDate = 160000;



//public int mazex = 6;
//public int mazey = 6;

//迷路位置
public int mazeoffset = 30;



void setup(){
  size(600, 600);
  frameRate(20);
  maze = new Maze(Dmazex,Dmazey,DwallWidth,DfloorWidth);
  uiSetup();
  maze.refresh();
}

void draw(){
  maze.refresh();
  
  if (keyPressed == true)  fill(0,80);
  else fill(200,80);
  ellipse(mouseX,mouseY,30,30);

      
}

boolean RectOver( int x, int y, int w,int h){
  //あるボタンの上にマウスが乗っているか返す
  if (mouseX >= x && mouseX <= x+w &&
    mouseY >= y && mouseY <= y+h) {
      return true;
      } else {
        return false;
      }
    }



void mouseDragged(){
  
 //edit maze 
  if (keyPressed == true) maze.editMaze(0, mouseX, mouseY);
  else maze.editMaze(1, mouseX, mouseY); 
}



void MazeSetup(int n,int m){
  //目的　迷路の大きさnをもらって、2n+1サイズの壁配列と、nサイズの床配列を作成する
  maze = new Maze(n,m);
  maze.refresh();
}


class Maze{
  //迷路クラス

  //格子サイズ
  int x;
  int y;

  //各パーツの幅
  int wallwidth;
  int floorwidth;

  //壁の様子
  static final int WALL = 0;
  static final int FLOOR = 1;

  int cell[][];


  Maze(int x,int y, int ww, int fw){
    //セルの初期化
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

  //パーツの幅を変更
  this.wallwidth = ww;
  this.floorwidth = fw;
  
  }

  //迷路を描画する
  void refresh(){
    
    //refresh All
    noStroke();
    fill(255);
    rect(0,0,width,height);
    
    //draw maze
    int tmpw,tmph,posx,posy;
    tmpw = 0;
    tmph = 0;
    posx = mazeoffset;
    posy = mazeoffset;
    for(int j = 0; j < 2 * y + 1 ; j++){
      for (int i = 0; i < 2 * x + 1 ; i++){
        
        if (i == 1 && j == 2){println("beforerect"+ posx +"," + posy +","+ tmpw +","+ tmph);}
        
        //横壁判定
        if(j % 2 == 0) tmph = int(this.wallwidth);
        else tmph = int(this.floorwidth);
        
        //縦壁判定
        if (i % 2 == 0) tmpw = int(this.wallwidth);
        else tmpw = int(this.floorwidth);
        
        //壁か床かその他か？
        if (cell[i][j] == WALL) fill(0);
        else noFill();
        if (i == 1 && j == 2){println("rect"+ posx +"," + posy +","+ tmpw +","+ tmph);}
        rect(posx,posy,tmpw,tmph);
        posx += tmpw;
      }
      posx = mazeoffset;
      posy += tmph;
    }
  }

  //迷路を編集する
  void editMaze(int mousestate,float mouseX,float mouseY){
    //セル番号を格納
    int numx,numy;
    //マウスの座標を所得し、対応する位置の壁を書いたり消したりする
    numx = cellNumber(mouseX);
    numy = cellNumber(mouseY);

    if (numx < 0 || numx > 2 * x + 1) return;
    if (numy < 0 || numy > 2 * y + 1) return;
    if ( ( numx + numy )% 2 == 1) {
      cell[numx][numy] = mousestate;
      refresh();
      println("mouse is now "+ numx + "," + numy + "cell ,it becomes" + mousestate);

        }

  }

  //ある座標値が、どのセル番号に位置するか返す関数
  int cellNumber(float pos){
    pos -= int(mazeoffset);
    int num;
    int t;
    
    int w = int(this.wallwidth);
    int f = int(this.floorwidth);
    
    t =floor( pos  / (w + f));

      if (pos > t * (w + f) + w)
        num = t * 2 + 1;
      else num = 2 * t ;

    return num;
  }
  
  void xCallback(int value){
    this.x = value ;
  }
  void yCallback(int value){
    this.y = value ;
  }
  void wwCallback(int value){
    this.wallwidth = value ;
  }
  void fwCallback(int value){
    this.floorwidth = value ;
  }  
  
  
}


void uiSetup(){

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
  println("push!");
  maze.refresh();
  save("file.png");

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


