import java.util.*;

/* input: the file name or URL 
   returns a String array with each line of the file as an element
*/
public String[] readFile(File fileName) {
  String[] input = loadStrings(fileName);
  return input;
}

public void editFile( String[] editedFile, String fileName){
  saveStrings(fileName, editedFile);
}

public void newFile( String[] editedFile, String fileName){
  saveStrings(fileName, editedFile);
}
