import java.util.*;

class Terminal {
  ArrayList<String> commandHistory = new ArrayList<String>();
  String currentUserInput = "";
  int scrollOffset = 0;
  int maxLinesOnScreen = 0;
  int totalTextHeight = 0;
  int maxScrollOffset = 0;
  int lineHeight = 30;
  String currentUser = "User";
  String currentFile = null; 
  boolean editMode = false;  
  int cursorIndex = 0;
  int currentCommandIndex = -1;
  FileManagement fileManagement = new FileManagement();

  void terminalSetup() {
    PFont font = createFont("Monospaced.bold", 18);
    textFont(font);
    background(0);
    commandHistory.add("WELCOME TO THE CLI");
  }

  ArrayList<String> splitIntoLines(String text, int maxLineLength) {
    ArrayList<String> lines = new ArrayList<>();
    int index = 0;
    while (index < text.length()) {
      lines.add(text.substring(index, Math.min(index + maxLineLength, text.length())));
      index += maxLineLength;
    }
    return lines;
  }

  int printText(String text, int x, int y, boolean isInputLine) {
    ArrayList<String> lines = splitIntoLines(text, 80);
    int totalChars = 0;
    for (int i = lines.size() - 1; i >= 0; i--) {
      String line = lines.get(i);
      int lineLength = line.length();

      if (isInputLine) {
      // calculate the range of cursor positions for which this line should show the cursor
      int minCursorPos = totalChars;
      int maxCursorPos = totalChars + lineLength;
      totalChars += lineLength;

      int userLength = currentUser.length() + 3;
      if (cursorIndex + userLength >= minCursorPos && cursorIndex + userLength <= maxCursorPos) { // if cursor is on this line
        // adjust cursorIndex relative to the beginning of the line
        int adjustedCursorIndex = cursorIndex + userLength - minCursorPos;

        String beforeCursor = line.substring(0, Math.min(adjustedCursorIndex, line.length()));
        text(beforeCursor, x, y);
          
        float beforeCursorWidth = textWidth(beforeCursor);

        fill(255);  // white color
        text("|", x + beforeCursorWidth, y);
        
        float cursorWidth = textWidth("|");
        
        fill(0, 0, 255);
        String afterCursor = line.substring(Math.min(adjustedCursorIndex, line.length()));
        text(afterCursor, x + beforeCursorWidth + cursorWidth, y);
      } else {
        text(line, x, y);
      }
    } else {
        text(line, x, y - scrollOffset);
      }

      y -= lineHeight;
    }
    return y;
  }

void terminalDraw() {
  background(0);
  fill(255);
  int y = height - 50;

  // Preprocessing text height and lines count
  lineHeight = (int) textAscent() + (int) textDescent();
  int numOfLines = commandHistory.size() + currentUserInput.split("\n").length + (currentFile == null ? 0 : currentFile.split("\n").length);
  totalTextHeight = numOfLines * lineHeight;
  maxLinesOnScreen = (height - 50) / lineHeight;
  
  // Scroll Offset adjustment
  adjustScrollOffset();

  if(editMode) {
    fill(0, 0, 255);  // making the text blue
    String text = "Editing " + currentFile + ":\n" + currentUserInput;
    y = printText(text, 10, y, false);
    fill(255);  // change color back to white
  }
  else {
    fill(0, 0, 255);  // making the text blue
    String text = currentUser + " > " + currentUserInput;
    y = printText(text, 10, y, true);
    fill(255);  // change color back to white
  }

  for (int i = commandHistory.size() - 1; i >= 0 && y >= lineHeight; i--) {
    y = printText(commandHistory.get(i), 10, y, false);
  }
}

void terminalMouseWheel(MouseEvent event) {
  float e = event.getCount();
  lineHeight = (int) textAscent() + (int) textDescent();

  if (e < 0) {
    // Scroll up
    scrollOffset += lineHeight;
  } else {
    // Scroll down
    scrollOffset -= lineHeight;
  }

  // Adjust scroll offset to ensure it's within valid range
  adjustScrollOffset();
}

void adjustScrollOffset() {
  if (totalTextHeight > height) {
    // If total text height exceeds screen height, allow scrolling
    scrollOffset = constrain(scrollOffset, 0, totalTextHeight - height + 50);
  } else {
    // Else, set scrolling offset to 0
    scrollOffset = 0;
  }
}
 

  
  void terminalKeyPressed() {
    scrollOffset = 0;
    if(editMode) { 
      // Handle editing mode
      if(keyCode == ESC) {
        fileManagement.writeFile(currentFile, currentUserInput);
        currentUserInput = "";
        currentFile = null;
        editMode = false;
      }
      else if(keyCode == BACKSPACE) {
        if(currentUserInput.length() > 0) {
          currentUserInput = currentUserInput.substring(0, currentUserInput.length() - 1);
        }
      }
      else {
        currentUserInput += key;
      }
    }
    else {
      // Handle terminal mode
      if(keyCode == ENTER) {
        commandHistory.add(currentUser + " > " + currentUserInput);
        executeCommand(currentUserInput);
        currentUserInput = "";
        currentCommandIndex = -1;
        cursorIndex = 0;
      }
      else if(keyCode == UP) {
        if(currentCommandIndex < commandHistory.size() - 1) {
          currentCommandIndex++;
          currentUserInput = commandHistory.get(commandHistory.size() - currentCommandIndex - 1).replaceFirst(currentUser + " > ", "");
        }
      }
      else if(keyCode == DOWN) {
        if(currentCommandIndex > 0) {
          currentCommandIndex--;
          currentUserInput = commandHistory.get(commandHistory.size() - currentCommandIndex - 1).replaceFirst(currentUser + " > ", "");
        }
      }
      else if(keyCode == LEFT) {
        if(cursorIndex > 0) {
          cursorIndex--;
        }
      }
      else if(keyCode == RIGHT) {
        if(cursorIndex < currentUserInput.length()) {
          cursorIndex++;
        }
      }
      else if(keyCode == BACKSPACE) {
        if(currentUserInput.length() > 0) {
          if(cursorIndex > 0) {
            currentUserInput = currentUserInput.substring(0, cursorIndex - 1) +
                               currentUserInput.substring(cursorIndex);
            cursorIndex--;
          }
          else{
            currentUserInput = currentUserInput.substring(0, currentUserInput.length() - 1);
          }
        }
      }
      else {
        if(cursorIndex>currentUserInput.length()) cursorIndex = currentUserInput.length();
        currentUserInput = currentUserInput.substring(0, cursorIndex) +
                           key +
                           currentUserInput.substring(cursorIndex);
        cursorIndex++;
      }
    }
  }

  void executeCommand(String command) {
    String[] parts = command.split(" ");
    if(parts.length > 0) {
      if(parts[0].equals("ll")) {
        String[] files = fileManagement.listFiles();
        if(files != null) {
          for(String file : files) {
            commandHistory.add(file);
          }
          String[] fileCheck = commandHistory.get( commandHistory.size()-1).split(" ");
          if( fileCheck[0].equals("User")){
            commandHistory.add("NO FILES IN DIRECTORY");
          }
        }
      }
      else if(parts[0].equals("cat") && parts.length > 1) {
        String[] lines = fileManagement.readFile(parts[1]);
        if(lines != null) {
          for(String line : lines) {
            commandHistory.add(line);
          }
        }
      }
      else if(parts[0].equals("touch") && parts.length > 1) {
        fileManagement.createFile(parts[1]);
      }
      else if(parts[0].equals("vi") && parts.length > 1) {
        currentFile = parts[1];
        String[] lines = fileManagement.readFile(currentFile);
        if(lines != null) {
          for(String line : lines) {
            currentUserInput += line + "\n";
          }
        }
        editMode = true;
      }
    }
  }
}

Terminal terminal;

void setup() {
  size(1080, 720);
  terminal = new Terminal();
  terminal.terminalSetup();
}

void draw() {
  terminal.terminalDraw();
}

void keyPressed() {
  terminal.terminalKeyPressed();
}

void mouseWheel(MouseEvent event) {
  terminal.terminalMouseWheel(event);
}
