class MainLogic {

  Specimen[] specimen;
  IntList graph;
  boolean done = false;
  int iteration = 0, maxIteration = 100, blinkT = 0, menu = 0;

  MainLogic() {
    graph = new IntList();
  }

  void Update() {
    if (!done) done = RunIteration();
    DrawUI();
  }

  //Returnerer true hvis der ikke skal køres flere iterationer.
  boolean RunIteration() {
    return false;
  }

  void DrawUI() {
    textSize(30);
    fill(0, 0, 0);

    if (Blink(2, true, false) && menu == 1) text("Iteration: "+iteration, 20, 30);
    else if (menu != 1) text("Iteration: "+iteration, 20, 30);
  }

  void HandleInput(int k, boolean b) {
  }

  boolean Blink(float frekvens, boolean b, boolean shift)
  {
    if (!b) //Support for at blink kan slås fra ved at pass et variabel til metoden
      return true;

    blinkT = millis();
    float periode = 1000f / frekvens;

    for (int i = 0; i < frekvens; i = i + 2)
    {
      if ((blinkT < periode * (i + 1) && blinkT > periode * i))
      {
        return !shift;
      }
    }
    return shift;
  }
}
