PFont font;

void setup() {
  size(1080,720);
  background(0);
  font = loadFont("Menlo-Regular-11.vlw");
  textFont(font);
}

void draw() {
  text("hi", width/2, height/2);
}
