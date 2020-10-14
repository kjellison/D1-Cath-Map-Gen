class room //<>//
{

  int x;
  int y;
  int xsize;
  int ysize;
  int id;

  ArrayList<tile> roomtiles = new ArrayList<tile>();

  room(int _x, int _y, int _xsize, int _ysize, int _id)
  {
    x = _x;
    y = _y;
    xsize = _xsize;
    ysize = _ysize;
    id = _id;
  }

  void takeTiles()
  {
    for (int ty = 0; ty < ysize; ty++)
    {
      for (int tx = 0; tx < xsize; tx++)
      {
        tile t = getTile(tx+x, ty+y);
        t.room = id;
        t.roomparent = this;
        t.placeRoom(id);
        roomtiles.add(t);
      }
    }
  }

  void placeTiles()
  {
    for (int ty = 0; ty < ysize; ty++)
    {
      for (int tx = 0; tx < xsize; tx++)
      {

        tile t = getTile(tx+x, ty+y);
        if (t.room < 1)
        {
          t.room = id;
          t.roomparent = this;
          t.placeRoom(id);
          roomtiles.add(t);
        }
      }
    }
  }

  boolean roomFits()
  {
    if (roomTouchesEdge())
    {
      return false;
    }
    else
    {
      for (int ty = y; ty < y+ysize; ty++)
      {
        for (int tx = x; tx < x+xsize; tx++)
        {
          tile temptile = getTile(tx, ty);
          if (temptile.room > 0)
          {
            return false;
          }
        }
      }
    }
    return true;
  }
  
  boolean roomTouchesEdge()
  {
    if ((x <= 0) | (x+xsize >= tilessize) | (y <= 0) | (y+ysize >= tilessize))
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  int xCenter()
  {
    return (x+(floor(xsize/2)));
  }

  int yCenter()
  {
    return (y+(floor(ysize/2)));
  }
}
