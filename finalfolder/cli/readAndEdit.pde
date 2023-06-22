import java.io.*;


class FileManagement {
  String[] listFiles() {
    String dirPath = sketchPath() + "/data/";
    File dir = new File(dirPath);
    return dir.list();
  }


  String[] readFile(String filename) {
    String filePath = sketchPath() + "/data/" + filename;
    File file = new File(filePath);
    if(file.exists()) {
      return loadStrings(filePath);
    }
    else {
      return null;
    }
  }

  void createFile(String filename) {
    String filePath = sketchPath() + "/data/" + filename;
    File file = new File(filePath);
    PrintWriter writer;
    try {
      writer = new PrintWriter(file);
      writer.print("");  
      writer.close();

    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
  }



  void writeFile(String filename, String content) {
    String filePath = sketchPath() + "/data/" + filename;
    File file = new File(filePath);
    try {
      PrintWriter writer = new PrintWriter(file);
      writer.print(content);
      writer.close();
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
}
