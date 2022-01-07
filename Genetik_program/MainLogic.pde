class MainLogic {
  Keyboard kb;
  Specimen[] specimen;
  IntList graph;
  boolean done = false;
  int iteration = 0, maxIteration = 100, blinkT = 0, menu = 0;

  MainLogic() {
    graph = new IntList();
    kb = new Keyboard();
  }

  void Update() {
    HandleControls();
    println(menu);
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

    text("Iteration: "+iteration, 30, 30);

    if (Blink(4, true, false) && menu == 1) text("Max iterations: "+maxIteration, 30, 70);
    else if (menu != 1) text("Max iterations: "+maxIteration, 30, 70);

    DrawSelection(menu);
  }

  void HandleControls() {
    if (kb.Shift(39)) menu++;
    if (kb.Shift(37)) menu--;
    if (kb.Shift(38)) add(true);
    if (kb.Shift(40)) add(false);

    kb.Update();
  }

  void add(boolean x) {
  }

  void DrawSelection(int offset) {
    if (menu != 0)rect(7, offset * 40 + 16, 15, 4);
  }

  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
  }

  boolean Blink(float frekvens, boolean b, boolean shift)
  {
    if (!b) //Support for at blink kan slås fra ved at pass et variabel til metoden
      return true;

    blinkT = millis()-1000*floor(millis()/1000f);
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
