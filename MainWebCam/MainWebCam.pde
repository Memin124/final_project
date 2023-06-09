import processing.video.*;

Capture cam;
FaceRecognizer faceRecognizer;

void setup() {
  size(1080, 720);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    cam = new Capture(this, width, height, cameras[0]);
    cam.start();
  }

  faceRecognizer = new FaceRecognizer("{YourFaceNetModelFilePath}", "{YourFaceDatabaseFilePath}");
  faceRecognizer.loadModelAndDb();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);

  // Convert Processing PImage to OpenCV Mat
  PImage img = cam.get();
  Mat frame = new Mat(img.height, img.width, CvType.CV_8UC3);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    frame.put(i/img.width, i%img.width, 
      (img.pixels[i] >> 16) & 0xFF,  // R
      (img.pixels[i] >> 8) & 0xFF,   // G
      img.pixels[i] & 0xFF);         // B
  }

  String name = faceRecognizer.recognizeFaces(frame);
  if (name != null) {
    println(name);
  }
}
