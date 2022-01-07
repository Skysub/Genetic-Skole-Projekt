MainLogic mainLogic;

void setup() {
  mainLogic = new MainLogic();
  frameRate(144);
  size(1920, 1080);
}

void draw() {
  background(150);
  mainLogic.Update();
}

void keyPressed() {
  mainLogic.HandleInput(keyCode, true);
}

void keyReleased() {
  mainLogic.HandleInput(keyCode, false);
} 
