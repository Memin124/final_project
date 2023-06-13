import java.util.*;

class terminal{
  private ArrayList<String> typeLog;
  private String User;
  private int arrowKey = 0;
  private int editPlace = 0;
  private int history = 0;
  private String frame;
  private PFont font;
  readAndEdit files; 
  
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
    background(0);
    fill(255);
    terminalDraw(arrowKey);
  }
  
  void terminalDraw(int index) {
    int value = typeLog.size() - 1 + index;
    if (value - 29 >= 0) {
        int lineCount = 1;  // Increase the line count by 1

        // Handling the bottom line separately 
        String bottomLine = typeLog.get(value);
        List<String> bottomParts = new ArrayList<>();
        int start = 0;
        while (start < bottomLine.length()) {
            int end = Math.min(start + 80, bottomLine.length());
            bottomParts.add(bottomLine.substring(start, end));
            start = end;
        }
        Collections.reverse(bottomParts);
        int currentLength = bottomLine.length();
        for (String part : bottomParts) {
            int relativeEditPlace = editPlace - (currentLength - part.length());
            if (relativeEditPlace >= 0 && relativeEditPlace < part.length()) {
                String beforeEdit = part.substring(0, relativeEditPlace);
                String editChar = part.substring(relativeEditPlace, relativeEditPlace + 1);
                String afterEdit = relativeEditPlace + 1 < part.length() ? part.substring(relativeEditPlace + 1) : "";
                
                fill(255); // Set color to white for normal text
                text(beforeEdit, 10, height - 20 * lineCount);

                fill(0, 0, 255); // Set color to blue for editPlace
                text(editChar, 10 + textWidth(beforeEdit), height - 20 * lineCount);

                fill(255); // Reset color to white for the rest of the line
                text(afterEdit, 10 + textWidth(beforeEdit + editChar), height - 20 * lineCount);
            } else {
                fill(255); // Set color to white
                text(part, 10, height - 20 * lineCount);
            }
            currentLength -= part.length();
            lineCount++;
        }

        // Handling the rest of the lines
        for (int i = value - 1; i >= Math.max(0, value - 30); i--) {
            if (lineCount <= 30) {
                String line = typeLog.get(i);
                List<String> parts = new ArrayList<>();
                start = 0;
                while (start < line.length()) {
                    int end = Math.min(start + 80, line.length());
                    parts.add(line.substring(start, end));
                    start = end;
                }
                Collections.reverse(parts);
                for (String part : parts) {
                    fill(255); // Set color to white
                    text(part, 10, height - 20 * lineCount);
                    lineCount++;
                }
            }
            if (lineCount > 30) {
                break;
            }
        }
    }
  }
  
  void keyPressed() {
    if (key == ENTER) {
      if( arrowKey != 0) {arrowKey = 0;}
      else if( typeLog.get(typeLog.size()-1).indexOf( "cat") = User.length() +3){
        typeLog.addAll( Arrays.asList( ))
        Arrays.asList( files.readFiles( typeLog.get(typeLog.size()-1).substring( User.length() +7, typeLog.get(typeLog.size()-1).indexOf( ' ', User.length() +7))));
      } else{
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
