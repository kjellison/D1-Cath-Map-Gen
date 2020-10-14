//Code by Kelly Jellison 2020 //<>//

//Thank you to Boris the Brave for his amazing write-up on Diablo 1 map generation
//https://www.boristhebrave.com/2019/07/14/dungeon-generation-in-diablo-1/
ArrayList<piece> pieces = new ArrayList<piece>();
ArrayList<tile> tiles = new ArrayList<tile>();
ArrayList<room> rooms = new ArrayList<room>();

int gridsize;
int tilessize;

int startingrooms;
boolean xaxis;
int roomcounter;

color wallcolor;
color doorcolor;
color bkgndcolor;
color txtcolor;

color diablowall = color(150, 142, 106);
color diablodoor = color(255, 253, 183);
color diablobkgnd = color(0, 0, 0);
color diablotxt = color(255, 253, 183);

color printwall = color(0, 0, 0);
color printdoor = color(80, 80, 80);
color printbkgnd = color(255, 255, 255);
color printtxt = color(80, 80, 80);

boolean colorscheme;
boolean roomnumbers;

int walkablespace = 572;

float zrot;
float xrot;
float yrot;
float scl;
float tx;
float ty;
float cameraspeed;

void setup()
{
  size(1000, 1000);
  gridsize = 80;

  tilessize = floor(gridsize/2);
  
  colorscheme = true;
  roomnumbers = false;


  tileSetup();
  cathPreGen();
  postGen();
  
  while (buildFailed())
  {
    newMap();
  }
  scl = 0.5;
  zrot = 1.5;
  xrot = 0.8;
  yrot = -1.4;
  tx = 502;
  ty = 576;
  cameraspeed = TWO_PI / width;
}


void draw()
{
  colorSet();
  background(bkgndcolor);
  for (int i = 0; i < tiles.size(); i++)
  {
    tiles.get(i).show();
    tiles.get(i).updatePieces();
  }
  for (int i = 0; i < pieces.size(); i++)
  {
    pieces.get(i).show();
  }
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    getTileData(floor(mouseX/(height/40)), floor(mouseY/(width/40)));
  }
  if (mouseButton == RIGHT)
  {
    newMap();
    while (buildFailed())
    {
      newMap();
    }
  }
}

void keyPressed()
{
  if (key == 's')
  {
    save("map.png");
  }
  if (key == 'c')
  {
    colorscheme = !colorscheme;
  }
  if (key == 'r')
  {
    roomnumbers = !roomnumbers;
  }
}

void colorSet()
{
  if (colorscheme)
  {
    wallcolor = diablowall;
    doorcolor = diablodoor;
    bkgndcolor = diablobkgnd;
    txtcolor = diablotxt;
  }
  else
  {
    wallcolor = printwall;
    doorcolor = printdoor;
    bkgndcolor = printbkgnd;
    txtcolor = printtxt;
  }
}
void postGen()
{
  for (int i = 0; i < startingrooms; i++)
  {
    mainRoomCols(rooms.get(i));
  }
  
  if (xaxis)
  {
    
  }
}

void mainRoomCols(room _room)
{
  _room.roomtiles.get(44).hascolumn = true;
  _room.roomtiles.get(47).hascolumn = true;
  _room.roomtiles.get(74).hascolumn = true;
  _room.roomtiles.get(77).hascolumn = true;
}

void newMap()
{
  resetAll();
  cathPreGen();
  postGen();
}

boolean buildFailed()
{
  int walkcounter = 0;
  for (int i = 0; i < tiles.size(); i++)
  {

    if (tiles.get(i).room > 0)
    {
      tiles.get(i).deadTileAdjacent();
      walkcounter++;
    }
  }
  if (walkcounter >= walkablespace)
  {
    return false;
  } else
  {
    return true;
  }
}

void resetAll()
{
  pieces.clear();
  tiles.clear();
  rooms.clear();
  tileSetup();
}
void tileSetup()
{
  //Make piece grid
  for (int y = 0; y < gridsize; y++)
  {
    for (int x = 0; x < gridsize; x++)
    {
      pieces.add(new piece(x, y, floor(width/gridsize), getId(x, y, gridsize)));
    }
  }

  //Make tile grid
  for (int y = 0; y < tilessize; y++)
  {
    for (int x = 0; x < tilessize; x++)
    {
      tiles.add(new tile(x, y, tilessize, getId(x, y, tilessize)));
    }
  }

  //Mate Tiles and Pieces
  for (int i = 0; i < tiles.size(); i++)
  {
    tile T = tiles.get(i);
    //print(T.id);
    for (int Py = 0; Py < 2; Py++)
    {
      for (int Px = 0; Px < 2; Px++)
      {
        T.addPiece(T.x*2+Px+((T.y*2+Py)*gridsize));
        //print(" ");
        //print(pieces.get(T.x*2+Px+((T.y*2+Py)*gridsize)).id);
      }
    }
    //println(" ");
  }
}

void cathPreGen()
{
  roomcounter = 1;
  startingrooms = (int)random(1, 4); //1-3
  //startingrooms = 1;
  xaxis = randBool();
  //xaxis = false;



  if (xaxis)
  {
    if (startingrooms == 1)
    {
      room troom = new room(floor(tilessize/2)-5, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom.takeTiles();
      rooms.add(troom);
      roomcounter++;

      room hall = new room(1, floor(tilessize/2)-3, 38, 6, roomcounter);
      hall.placeTiles();
      rooms.add(hall);
      roomcounter++;

      L5roomGen(troom, !xaxis);
    } else if (startingrooms == 2)
    {
      room troom2 = new room(1, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom2.takeTiles();
      rooms.add(troom2);
      roomcounter++;

      room troom3 = new room(tilessize-11, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom3.takeTiles();
      rooms.add(troom3);
      roomcounter++;

      room hall = new room(1, floor(tilessize/2)-3, 38, 6, roomcounter);
      hall.placeTiles();
      rooms.add(hall);
      roomcounter++;

      L5roomGen(troom2, !xaxis);
      L5roomGen(troom3, !xaxis);
    } else if (startingrooms == 3)
    {
      room troom = new room(floor(tilessize/2)-5, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom.takeTiles();
      rooms.add(troom);
      roomcounter++;

      room troom2 = new room(1, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom2.takeTiles();
      rooms.add(troom2);
      roomcounter++;

      room troom3 = new room(tilessize-11, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom3.takeTiles();
      rooms.add(troom3);
      roomcounter++;

      room hall = new room(1, floor(tilessize/2)-3, 38, 6, roomcounter);
      hall.placeTiles();
      rooms.add(hall);
      roomcounter++;

      L5roomGen(troom, !xaxis);
      L5roomGen(troom2, !xaxis);
      L5roomGen(troom3, !xaxis);
    }
  } else
  {
    if (startingrooms == 1)
    {
      room troom = new room(floor(tilessize/2)-5, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom.takeTiles();
      rooms.add(troom);
      roomcounter++;

      room hall = new room(floor(tilessize/2)-3, 1, 6, 38, roomcounter);
      hall.placeTiles();
      rooms.add(hall);
      roomcounter++;

      L5roomGen(troom, !xaxis);
    } else if (startingrooms == 2)
    {
      room troom2 = new room(floor(tilessize/2)-5, 1, 10, 10, roomcounter);
      troom2.takeTiles();
      rooms.add(troom2);
      roomcounter++;

      room troom3 = new room(floor(tilessize/2)-5, tilessize-11, 10, 10, roomcounter);
      troom3.takeTiles();
      rooms.add(troom3);
      roomcounter++;

      room hall = new room(floor(tilessize/2)-3, 1, 6, 38, roomcounter);
      hall.placeTiles();
      rooms.add(hall);
      roomcounter++;

      L5roomGen(troom2, !xaxis);
      L5roomGen(troom3, !xaxis);
    } else if (startingrooms == 3)
    {
      room troom = new room(floor(tilessize/2)-5, floor(tilessize/2)-5, 10, 10, roomcounter);
      troom.takeTiles();
      rooms.add(troom);
      roomcounter++;

      room troom2 = new room(floor(tilessize/2)-5, 1, 10, 10, roomcounter);
      troom2.takeTiles();
      rooms.add(troom2);
      roomcounter++;

      room troom3 = new room(floor(tilessize/2)-5, tilessize-11, 10, 10, roomcounter);
      troom3.takeTiles();
      rooms.add(troom3);
      roomcounter++;

      room hall = new room(floor(tilessize/2)-3, 1, 6, 38, roomcounter);
      hall.placeTiles();
      rooms.add(hall);
      roomcounter++;

      L5roomGen(troom, !xaxis);
      L5roomGen(troom2, !xaxis);
      L5roomGen(troom3, !xaxis);
    }
  }
}

void L5roomGen(room _room, boolean axisisx)
{
  int roomsizex;
  int roomsizey;
  //1 in 4 chance of switching the preferred axis between X and Y.
  if ((int)random(0, 4) == 0)
  {
    axisisx = !axisisx;
  }

  //Pick a random size for the new room, either 2, 4 or 6 tiles on each side.
  roomsizex = ((int)random(1, 4))*2;
  roomsizey = ((int)random(1, 4))*2;

  //For each side of the initial room along the selected axis:
  if (axisisx)
  {
    //Align the new room rectangle to the center of that edge of the initial room
    room newroom1 = new room(_room.x-roomsizex, _room.yCenter()-floor(roomsizey/2), roomsizex, roomsizey, roomcounter);
    //Check nothing has been drawn there yet and we haven’t reached the edge of the map. 
    //A one tile border is required for walls.
    if (newroom1.roomFits())
    {
      //If the check passes, draw the room in.
      newroom1.placeTiles();
      rooms.add(newroom1);
      roomcounter++;
      //For each room that was drawn, invoke L5roomGen recursively, passing in the new room, 
      //and the opposing axis to the one just used.
      L5roomGen(newroom1, axisisx);
    }

    //Pick a random size for the new room, either 2, 4 or 6 tiles on each side.
    roomsizex = ((int)random(1, 4))*2;
    roomsizey = ((int)random(1, 4))*2;
    //Align the new room rectangle to the center of that edge of the initial room
    room newroom2 = new room(_room.x+_room.xsize, _room.yCenter()-floor(roomsizey/2), roomsizex, roomsizey, roomcounter);
    //Check nothing has been drawn there yet and we haven’t reached the edge of the map. 
    //A one tile border is required for walls.
    if (newroom2.roomFits())
    {
      //If the check passes, draw the room in.
      newroom2.placeTiles();
      rooms.add(newroom2);
      roomcounter++;
      //For each room that was drawn, invoke L5roomGen recursively, passing in the new room, 
      //and the opposing axis to the one just used.
      L5roomGen(newroom2, axisisx);
    }
  } else
  {
    //Align the new room rectangle to the center of that edge of the initial room
    room newroom1 = new room(_room.xCenter()-floor(roomsizex/2), _room.y-roomsizey, roomsizex, roomsizey, roomcounter);
    //Check nothing has been drawn there yet and we haven’t reached the edge of the map. 
    //A one tile border is required for walls.
    if (newroom1.roomFits())
    {
      //If the check passes, draw the room in.
      newroom1.placeTiles();
      rooms.add(newroom1);
      roomcounter++;
      //For each room that was drawn, invoke L5roomGen recursively, passing in the new room, 
      //and the opposing axis to the one just used.
      L5roomGen(newroom1, axisisx);
    }
    //Pick a random size for the new room, either 2, 4 or 6 tiles on each side.
    roomsizex = ((int)random(1, 4))*2;
    roomsizey = ((int)random(1, 4))*2;


    //Align the new room rectangle to the center of that edge of the initial room
    room newroom2 = new room(_room.xCenter()-floor(roomsizex/2), _room.y+_room.ysize, roomsizex, roomsizey, roomcounter);
    //Check nothing has been drawn there yet and we haven’t reached the edge of the map. 
    //A one tile border is required for walls.
    if (newroom2.roomFits())
    {
      //If the check passes, draw the room in.
      newroom2.placeTiles();
      rooms.add(newroom2);
      roomcounter++;
      //For each room that was drawn, invoke L5roomGen recursively, passing in the new room, 
      //and the opposing axis to the one just used.
      L5roomGen(newroom2, axisisx);
    }
  }
}

boolean randBool()
{
  if ((int)random(2) == 0)
  {
    return false;
  } else
  {
    return true;
  }
}

//Different methods of returning tiles/pieces/ids----------------
int getId(int _x, int  _y, int  _xlen)
{
  return (_x+(_y*_xlen));
}

tile getTile(int _x, int _y)
{
  int id = (_x+(_y*floor(gridsize/2)));
  return tiles.get(id);
}

piece getPiece(int _x, int _y)
{
  int pid = (_x+(_y*gridsize));
  return pieces.get(pid);
}

piece getTilePiece(int _x, int _y, int _px, int _py)
{
  int pid = (_x*2+_px+((_y*2+_py)*gridsize));
  return pieces.get(pid);
}

void getTileData(int _x, int _y)
{
  tile data = getTile(_x, _y);
  println("Xpos: " + data.x);
  println("Ypos: " + data.y);
  println("Boundary Tile: " + data.isbound);
  
}
