static final int SPOT_SIZE = 30;
static final float INITIAL_FOCUS = 10.0;

class Camera {
  int spotFocusSize = SPOT_SIZE;
  int spotX, spotY;

  float blurScale = 0;
  float blurQuantum = 1.0;

  float currentFocus = INITIAL_FOCUS;
  float focusDirection = -1;

  float oldContrast, currentContrast;
  PImage source, originalImage = null;
  PImage spotImage = null;

  Camera(PImage s) {
    source = s;
    originalImage = createImage(source.width, source.height, RGB);
    originalImage.set(0, 0, source);

    source.filter(BLUR, currentFocus);
  }

  PImage getImage() {
    return source;
  }

  PImage getSpotImage() {
    return spotImage;
  }

  void setFocusLocation() {
    spotX = mouseX - SPOT_SIZE / 2;
    spotY = mouseY - SPOT_SIZE / 2;
  }
  
  void estimateInitialFocus() {
    currentFocus = INITIAL_FOCUS;
    source.set(0, 0, originalImage);
    source.filter(BLUR, currentFocus);
    spotImage = source.get(spotX, spotY, SPOT_SIZE, SPOT_SIZE);
    currentContrast = contrast(spotImage);
    focusDirection = 1;
  }

  void focus() {
    currentFocus += focusDirection * blurQuantum;
  }

  private float contrast(PImage spot) {
    spot.loadPixels();
    float iMean = 0.0;
    
    for(int i = 0; i < spot.pixels.length; i += 1) {
      iMean += brightness(spot.pixels[i]);
    }
    iMean /= spot.pixels.length;
    
    float c = 0;
    
    for(int i = 0; i < spot.pixels.length; i += 1) {
      c += abs(brightness(spot.pixels[i]) - iMean);
    }
    
    c /= spot.pixels.length;
    
    return c;
  }

  void autoFocusStep() {
    oldContrast = currentContrast;  // so the contrasts can be compared
    focus();                        // change the current focus 

    source.set(0, 0, originalImage);
    source.filter(BLUR, currentFocus); // adjust the image to the current focus

    spotImage = source.get(spotX, spotY, SPOT_SIZE, SPOT_SIZE);
    currentContrast = contrast(spotImage);  // calculate the contrast after adjusting the focus

    // decide what to do next
    if (currentContrast < oldContrast) {
      focusDirection *= -1;
    }
    else if (currentContrast == oldContrast) {
      focusDirection = 0;
    }
  }
}