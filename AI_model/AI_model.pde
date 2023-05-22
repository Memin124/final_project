import org.bytedeco.opencv.opencv_core.*;
import org.bytedeco.opencv.opencv_objdetect.*;
import processing.video.*;


class FacialRecognition {
  private CascadeClassifier faceCascade;
  private Mat videoMat;
  private Capture cam;
  
  // we need to figure out how to fuckin train this :((
  private Model myFaceModel;

  public FacialRecognition(int width, int height) {
    faceCascade = new CascadeClassifier("haarcascade_frontalface_default.xml");
    
    cam = new Capture(this, width, height);
    cam.start();
  }

  public void draw() {
    if (cam.available()) {
      cam.read();
      
      videoMat = new Mat((int) cam.height, (int) cam.width, CvType.CV_8UC3);
      videoMat.put(0, 0, (int[]) cam.pixels);
      
      // Detect faces
      RectVector faces = new RectVector();
      faceCascade.detectMultiScale(videoMat, faces);
      
      // Check each detected face
      for (int i = 0; i < faces.size(); i++) {
        Rect face = faces.get(i);
        
        // Extract the face from the frame
        Mat faceMat = new Mat(videoMat, face);
        
        // Check if it's me
//      if (isItMe(faceMat)) {
          // Call the CLI file
//      }
      }
    }
  }

  private boolean isItMe(Mat face) {
    // Assuming our model can differciate between you and me (or other people)
    String predictedLabel = myFaceModel.predict(face);
    
    return predictedLabel.equals("Mehmet");
  }
}
