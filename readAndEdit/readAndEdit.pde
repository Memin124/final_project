import java.util.*;
import java.io.FileWriter;

/* input: the file name or URL 
   returns a String array with each line of the file as an element
*/
class file {
  private List<String> lines;
  private int scroll;
  private int editLine;
  private int editIndex;
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
  
  void readFileForEdit(File fileName) {
    lines = new ArrayList<>();
    try (Scanner scanner = new Scanner(fileName)) {
        while (scanner.hasNextLine()) {
            lines.add(scanner.nextLine());
        }
    } catch (IOException e) {
        lines.add("An error occurred while reading the file.");
        System.out.println("An error occurred while reading the file.");
        e.printStackTrace();
    }
  }

  
  public void editFile( String[] toBeEdit, String oldLine, String newLine){
    //figure out how to call it
    //implement in keyPressed
    for (int i = 0; i < toBeEdit.length; i++) {
      if (toBeEdit[i] == oldLine) {
        toBeEdit[i] = newLine;
      }
    }
  }
  
  void editPrint(String fileName, int index) {
    readFileForEdit(new File(fileName));
    if (index - 29 >= 0) {
        int lineCount = 1;
        for (int i = index; i >= Math.max(0, index - 30); i--) {
            if (lineCount <= 30) {
                String line = lines.get(i);
                List<String> parts = new ArrayList<>();
                int start = 0;
                while (start < line.length()) {
                    int end = Math.min(start + 80, line.length());
                    parts.add(line.substring(start, end));
                    start = end;
                }
                Collections.reverse(parts);
                int totalLength = line.length();
                for (String part : parts) {
                    start = totalLength - part.length();
                    if (i == editLine && totalLength - part.length() <= editIndex && editIndex < totalLength) {
                        String beforeEdit = part.substring(0, editIndex - start);
                        String editChar = part.substring(editIndex - start, editIndex - start + 1);
                        String afterEdit = editIndex - start + 1 < part.length() ? part.substring(editIndex - start + 1) : "";
                        
                        fill(0); // Set color to black for normal text
                        text(beforeEdit, 10, height - 20 * (lineCount + 1));
                        
                        fill(0, 0, 255); // Set color to blue for editPlace
                        text(editChar, 10 + textWidth(beforeEdit), height - 20 * (lineCount + 1));
                        
                        fill(0); // Reset color to black for the rest of the line
                        text(afterEdit, 10 + textWidth(beforeEdit + editChar), height - 20 * (lineCount + 1));
                    } else {
                        fill(0); // Set color to black
                        text(part, 10, height - 20 * (lineCount + 1));
                    }
                    totalLength -= part.length();
                    lineCount++;
                }
            }
            if (lineCount > 30) {
                break;
            }
        }
    }
  }
  
  void saveFile(String fileName, ArrayList<String> lines) {
    try (PrintWriter writer = new PrintWriter(new FileWriter(fileName, false))) { //false overwrites existing files
        for (String line : lines) {
            writer.println(line);
        }
    } catch (IOException e) {
        System.out.println("An error occurred while writing to the file.");
        e.printStackTrace();
    }
}

<<<<<<< HEAD
public void editFile( String[] editedFile, String fileName){
  saveStrings(fileName, editedFile);
}

public void newFile( String[] editedFile, String fileName){
  saveStrings(fileName, editedFile);
=======
  
  void keyPressed() {
    if (keyCode == UP) {
        editLine = constrain(editLine - 1, 0, lines.size() - 1);
    } else if (keyCode == DOWN) {
        editLine = constrain(editLine + 1, 0, lines.size() - 1);
    } else if (keyCode == LEFT) {
        editIndex = constrain(editIndex - 1, 0, lines.get(editLine).length() - 1);
    } else if (keyCode == RIGHT) {
        editIndex = constrain(editIndex + 1, 0, lines.get(editLine).length() - 1);
    }
    //need to edit for editing the file
    //figure out how to make a call when o save the file
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    scroll = constrain(scroll - (int)e, 0, lines.size() - 1);
  }
>>>>>>> Yaolei_branch
}
