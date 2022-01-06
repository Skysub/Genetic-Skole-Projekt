MainLogic mainLogic;

void setup() {
  mainLogic = new MainLogic();
  frameRate(144);
  size(1920, 1080);
}

void draw() {
  mainLogic.Update();
}
