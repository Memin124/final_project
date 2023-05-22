import processing.video.*;

Capture cam;

void setup() {
  size(1080, 720);

  String[] cameras = Capture.list();
  int FPS = 30;
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    // Create a Capture object with the first available camera
    FPS =30;
    cam = new Capture(this, width, height, Capture.list()[0],FPS);
    cam.start();
  }     
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
}
