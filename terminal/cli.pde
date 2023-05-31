import java.util.*;

class terminal{
  private ArrayList<String> typeLog;
  private String User;
  private int arrowKey = 0;
  private int editPlace = 0;
  private int history = 0;
  private String frame;
  
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
  
  void terminalDraw( int index){
    
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
         editPlace = constrain( editPlace -1, 0, 80); // check window width for 80
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
   arrowKey = constrain( arrowkey - event.getCount, 0, typeLog.size());
  }
  
}
