import java.util.*;

class terminal{
  private ArrayList<String> typeLog;
  private String User;
  private int arrowKey = 0;
  private int editPlace = 0;
  private int history = 0;
  private String frame;
  private PFont font;
  
  void setup() {
    size(1080, 720);
    font = loadFont("Menlo-Regular-11.vlw");
    textFont(font);
  }
  
  
  public void terminalSetup( String User){
    this.User = User;
    typeLog.add( User + " > ");
    this.frame = User + " > ";
    setup();
  }
  
  void draw() {
    background(255);
    fill(0);
    terminalDraw(arrowKey);
  }
  
  void terminalDraw(int index) {
    int value = typeLog.size() - 1 + index;
    if (value - 29 >= 0) {
        int lineCount = 0;
        for (int i = value; i >= Math.max(0, value - 30); i--) {
            if (lineCount < 30) {
                String line = typeLog.get(i);
                int start = 0;
                while (start < line.length()) {
                    int end = Math.min(start + 80, line.length());
                    String substring = line.substring(start, end);
                    // Only color a character in the first printed line
                    if (i == value && lineCount == 0 && line.length() - editPlace >= start && line.length() - editPlace < end) {
                        String beforeEdit = substring.substring(0, line.length() - editPlace - start);
                        String editChar = substring.substring(line.length() - editPlace - start, line.length() - editPlace - start + 1);
                        String afterEdit = line.length() - editPlace - start + 1 < substring.length() ? substring.substring(line.length() - editPlace - start + 1) : "";
                        fill(255); // Set color to black for normal text
                        text(beforeEdit, 10, height - 20 * (lineCount + 1));
                        fill(0, 0, 255); // Set color to blue for editPlace
                        text(editChar, 10 + textWidth(beforeEdit), height - 20 * (lineCount + 1));
                        fill(255); // Reset color to black for the rest of the line
                        text(afterEdit, 10 + textWidth(beforeEdit + editChar), height - 20 * (lineCount + 1));
                    } else {
                        text(substring, 10, height - 20 * (lineCount + 1));
                    }
                    start = end;
                    lineCount++;
                    if (lineCount >= 30) {
                        break;
                    }
                }
            }
            if (lineCount >= 30) {
                break;
            }
        }
    }
  }
  
  void keyPressed() {
    if (key == ENTER) {
      if( arrowKey != 0) {arrowKey = 0;}
      else{
        // execute(typeLog.get(typeLog.size()-1));
        typeLog.add( User + " > ");
      }
    }  
    else if (key == UP) {
      history = constrain( editPlace +1, 0, typeLog.size());
    }
    else if (key == DOWN) {
      history = constrain( editPlace -1, 0, typeLog.size());
    }
    else if (key == RIGHT) {
      if( arrowKey != 0) {arrowKey = 0;}
      else{
         editPlace = constrain( editPlace +1, 0, 80); // check window width for 80
      }
    }
    else if (key == LEFT) {
      if( arrowKey != 0) {arrowKey = 0;}
      else{
        editPlace = constrain( editPlace -1, 0, 80); // check window width for 80
      }
    }
    else if (key == BACKSPACE) {
      if( arrowKey != 0) {arrowKey = 0;}
      else{
      }
    }
    else if (key == DELETE) {
      if( arrowKey != 0) {arrowKey = 0;}
      else{
      }
    }
    else {
      if( arrowKey != 0) {arrowKey = 0;}
      else{ typeLog.set(typeLog.size()-1, typeLog.get(typeLog.size()-1) + key);}
    }
  }
  
  void mouseWheel(MouseEvent event) {
   arrowKey = constrain( arrowKey - (int) event.getCount(), -1*typeLog.size(), 0);
  }
  
}
