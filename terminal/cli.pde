import java.util.*;

class terminal{
  private ArrayList<String> typeLog;
  private String User;
  
  void setup() {
    size(720, 480);
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
    else {
      typeLog.set(typeLog.size()-1, typeLog.get(typeLog.size()-1) + key);
    }
  }
  
}
