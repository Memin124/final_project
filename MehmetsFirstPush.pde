import processing.video.*;

Capture cam;

void setup() {
  size(1080, 720);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    // Create a Capture object with the first available camera
    cam = new Capture(this, cameras[0]);
    cam.start();
  }     
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
}
