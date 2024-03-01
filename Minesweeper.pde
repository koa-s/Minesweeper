import de.bezier.guido.*;
public static final int NUM_ROWS=10;
public static final int NUM_COLS=10;
public static final int NUM_MINES=15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i<NUM_ROWS; i++)
  {
    for (int j = 0; j<NUM_COLS; j++)
    {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  setMines();
}
public void setMines()
{
  for (int i = 0; i<NUM_MINES; i++)
  {
    int randoRow, randoCol;
    randoRow = (int)(Math.random()*NUM_ROWS);
    randoCol = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[randoRow][randoCol]))
    {
      mines.add(buttons[randoRow][randoCol]);
    } else
    {
      i--;
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int sum = 0;
  for (int i = 0; i<NUM_ROWS; i++)
  {
    for (int j=0; j<NUM_COLS; j++)
    {
      if (buttons[i][j].getClicked()==true)
      {
        sum++;
      }
      if (buttons[i][j].isFlagged()==true)
      {
        sum--;
      }
    }
  }
  if (sum+mines.size()==NUM_ROWS*NUM_COLS)
  {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  for (int i = 0; i<NUM_ROWS; i++)
  {
    for (int j=0; j<NUM_COLS; j++)
    {
      buttons[i][j].setLabel("L");
      if (mines.contains(buttons[i][j]))
      {
        buttons[i][j].unFlag();
        buttons[i][j].clicker();
      }
    }
  }
}
public void displayWinningMessage()
{
  for (int i = 0; i<NUM_ROWS; i++)
  {
    for (int j=0; j<NUM_COLS; j++)
    {
      buttons[i][j].setLabel("W");
      if (mines.contains(buttons[i][j]))
      {
        buttons[i][j].unFlag();
        buttons[i][j].clicker();
      }
    }
  }
  delay(10);
}
public boolean isValid(int r, int c)
{
  if (r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS)
  {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row-1; i<row+2; i++)
  {
    for (int j = col-1; j<col+2; j++)
    {
      if (isValid(i, j)==true)
      {
        if (mines.contains(buttons[i][j]))
        {
          numMines++;
        }
      }
    }
  }
  if (mines.contains(buttons[row][col]))
  {
    numMines--;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  public boolean getClicked()
  {
    return clicked;
  }
  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton==RIGHT)
    {
      flagged = !flagged;
      if (!flagged)
      {
        clicked=false;
      }
    } else if (mines.contains(this))
    {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0)
    {
      int i = countMines(myRow, myCol);
      setLabel(i);
    } else
    {
      for (int i = myRow-1; i<myRow+2; i++)
      {
        for (int j = myCol-1; j<myCol+2; j++)
        {
          if (isValid(i, j) && !buttons[i][j].clicked)
          {
            buttons[i][j].mousePressed();
          }
        }
      }
    }
  }

  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public void unFlag()
  {
    flagged=false;
  }
  public void clicker()
  {
    clicked = true;
  }
}
