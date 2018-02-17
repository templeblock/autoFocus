//static final String filename = "northern-lights.png";
//static final String filename = "clipboard.jpg";
//static final String filename = "test.jpg";
static final String filename = "trees-01.jpg";
//static final String filename = "trees-02.jpg";

Camera demoCamera;

PFont displayFont;

void setup() {
  size(1280, 720);

  PImage source = loadImage(filename);
  demoCamera = new Camera(source);

  displayFont = createFont("Helvetica", 24);
  textFont(displayFont);
  stroke(color(255, 0, 0));
}

void draw() {
  image(demoCamera.getImage(), 0, 0);
  if (demoCamera.getSpotImage() != null) {
    noFill();
    rect(demoCamera.spotX, demoCamera.spotY, SPOT_SIZE, SPOT_SIZE);
    fill(color(255, 0, 0));
    text(demoCamera.currentContrast, demoCamera.spotX + SPOT_SIZE, demoCamera.spotY);
  }
}


void mousePressed() {
  demoCamera.setFocusLocation();
  demoCamera.estimateInitialFocus();
}

void keyPressed() {
  if (key == 'f') {
    demoCamera.autoFocusStep();
  }
}