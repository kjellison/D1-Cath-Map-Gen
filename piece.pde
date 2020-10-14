class piece
{
  int x;
  int y;
  int size;
  int id;
  int room;
  int tile;
  tile tileParent;

  float dx;
  float dy;
  float dsize;

  boolean iscolumn;

  piece(int _x, int _y, int _size, int _id)
  {
    x = _x;
    y = _y;
    size = _size;
    id = _id;
    room = 0;
    dx = x*(width/80);
    dy = y*(width/80);
    dsize = floor(width/80);
  }


  void show()
  {

    if (room > 0)
    {
      stroke(wallcolor);
      fill(0);
      if (iscolumn)
      {
        square(dx, dy, dsize);
      }
    }
  }
}
