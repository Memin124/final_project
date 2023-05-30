import java.util.*;

class terminal{
  private ArrayList<String> typeLog;
  private String User;
  private int arrowKey = 0;
  
  void setup() {
    size(1080, 720);
  }
  
  
  public void terminalSetup( String User){
    this.User = User;
    typeLog.add( User + " > ");
  }
  
  void draw() {
    background(255);
  }
  
  void terminalDraw( String User){
    if (typeLog.size() == 0) {
      terminalSetup(User);
    }
  }
  
  void keyPressed() {
    if (key == ENTER) {
      // execute(typeLog.get(typeLog.size()-1));
      typeLog.add( User + " > ");
    }  
    else if (key == UP) {
      arrowKey--;
    }
    else if (key == DOWN) {
      arrowKey++;
    }
    else if (key == RIGHT) {}
    else if (key == LEFT) {}
    else {
      typeLog.set(typeLog.size()-1, typeLog.get(typeLog.size()-1) + key);
    }
  }
  
  float mouseWheel(MouseEvent event) {
   float e = event.getCount();
   return e;
  }
  
}
