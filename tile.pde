class tile
{
  int x;
  int y;
  int size;
  int id;
  int room;
  room roomparent;
  float dx;
  float dy;
  float dsize;
  boolean sbound;
  boolean ebound;
  boolean nbound;
  boolean wbound;
  boolean isbound;
  boolean hascolumn;

  ArrayList<piece> tilepieces = new ArrayList<piece>();

  tile(int _x, int _y, int _size, int _id)
  {
    x = _x;
    y = _y;
    size = _size;
    id = _id;
    room = 0;

    dx = x*(width/40);
    dy = y*(height/40);
    dsize = floor(width/40);
    isbound = false;
  }

  void show()
  {
    if (room > 0)
    {
      if (roomnumbers)
      {
        textSize(10);
        fill(txtcolor);
        text(room, dx+5, dy+12);
      }
      stroke(wallcolor);


      if (nbound)
      {
        line(dx, dy, dx+dsize, dy);
      }
      if (ebound)
      {
        line(dx+dsize, dy, dx+dsize, dy+dsize);
      }
      if (sbound)
      {
        line(dx+dsize, dy+dsize, dx, dy+dsize);
      }
      if (wbound)
      {
        line(dx, dy, dx, dy+dsize);
      }
    } else
    {
      fill(0);
    }
    if (isbound)
    {
      float ds = dsize/4;
      for (int i = 0; i < 5; i++)
      {
        for (int j = 0; j < 5; j++)
        {
          point(dx+ds*j, dy+ds*i);
        }
      }
    }
  }

  void updatePieces()
  {
    if (hascolumn)
    {
      getTilePiece(x, y, 0, 0).iscolumn = true;
    }
  }

  void placeRoom(int roomid)
  {
    room = roomid;
    for (int i = 0; i < tilepieces.size(); i++)
    {

      tilepieces.get(i).room = roomid;
    }
  }

  void addPiece(int pieceId)
  {
    pieces.get(pieceId).tileParent = this;
    tilepieces.add(pieces.get(pieceId));
  }

  boolean isOnEdge()
  {
    if ((x == 0) | (x == tilessize-1) | (y == 0) | (y == tilessize-1))
    {
      return true;
    } else
    {
      return false;
    }
  }

  void deadTileAdjacent()
  {
    if ((getTile(x+1, y).room == 0))
    {
      getTile(x+1, y).isbound = true;
      ebound = true;
    }
    if ((getTile(x-1, y).room == 0))
    {
      wbound = true;
      getTile(x-1, y).isbound = true;
    }
    if ((getTile(x, y+1).room == 0))
    {
      getTile(x, y+1).isbound = true;
      sbound = true;
    }
    if ((getTile(x, y-1).room == 0))
    {
      getTile(x, y-1).isbound = true;
      nbound = true;
    }
  }
}
