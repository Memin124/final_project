import java.util.*;

/* input: the file name or URL 
   returns a String array with each line of the file as an element
*/
class file {
  private PFont font;
  void setup() {
      size(1080, 720);
      font = loadFont("Menlo-Regular-11.vlw");
      textFont(font);
    }
  
  public String[] readFile(String fileName) {
    String filePath = dataPath(fileName);
    File reference = new File(fileName);
    String[] input = loadStrings(reference);
    return input;
  }
  
  public void editFile( String[] toBeEdit, String oldLine, String newLine){
    for (int i = 0; i < toBeEdit.length; i++) {
      if (toBeEdit[i] == oldLine) {
        toBeEdit[i] = newLine;
      }
    }
  }
  
  public void readPrint(String fileName) {
    int numOfLines = 0;
    int startIndex = 0;
    int endIndex = 81;
    String[] input = readFile(fileName);
    for (int i = 0; i < input.length; i++) {
      if (input[i].length() < 80) {
        println(input[i]);
      }
      else {
        numOfLines = input[i].length()/80 + 1;
        for (int j = 0; j < numOfLines - 1; j++) {
          println(input[i].substring(startIndex, endIndex));
          startIndex = endIndex;
          endIndex+=80;
        }
        println(input[i].substring(endIndex));
      }
    }
  }
}
