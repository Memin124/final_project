import java.util.*;

/* input: the file name or URL 
   returns a String array with each line of the file as an element
*/
public String[] readFile(File fileName) {
  String[] input = loadStrings(fileName);
  return input;
}

public void editFile( String[] toBeEdit, String oldLine, String newLine){
  for (int i = 0; i < toBeEdit.length; i++) {
    if (toBeEdit[i] == oldLine) {
      toBeEdit[i] = newLine;
    }
  }
}
