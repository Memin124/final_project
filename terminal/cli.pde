import java.util.*;

class terminal{
  private ArrayList<String> typeLog;
  private String User;
  
  public void terminalSetup( String User){
    this.User = User;
    typeLog.add( User + " > ");
  }
  
  terminalDraw( String User){
    if (typelog.size() == 0) {
      terminalSetup(User);
    }
  
  void keyPressed() {
    if (key == ENTER) {
      execute(typeLog.get(typeLog.size()-1));
      typeLog.add( User + " > ");
    }
    else {
      typeLog.set(typeLog.size()-1, typeLog.get(typeLog.size()-1 + key);
    }
    
  }
}
