class MainLogic {
  Keyboard kb;
  Specimen[] specimen;
  IntList graph;
  boolean done = true;
  int iteration = 0, maxIteration = 100, blinkT = 0, menu = 0;

  MainLogic() {
    graph = new IntList();
    kb = new Keyboard();
  }

  void Update() {
    HandleControls();
    //println(menu);
    if (!done) ContinueSimulation();
    DrawUI();
  }

  //Returnerer true hvis der ikke skal køres flere iterationer.
  void RunIteration() {
  }

  void StartSimulation() {
    done = false;
  }

  void ContinueSimulation() {
    if (iteration == maxIteration) {
      done = true;
      return;
    }
    iteration++;
    RunIteration();
  }

  void reset() {
    done = true;
    iteration = 0;
  }

  void DrawUI() {
    textSize(30);
    fill(0, 0, 0);

    text("Iteration: "+iteration, 30, 30);

    if (Blink(3, true, false, 0.3f) && menu == 1) text("Max iterations: "+maxIteration, 30, 70);
    else if (menu != 1) text("Max iterations: "+maxIteration, 30, 70);

    DrawSelection(menu);
  }

  void HandleControls() {
    if (kb.Shift(39) && menu != 1) menu++;
    if (kb.Shift(37) && menu != 0) menu--;
    if (kb.Shift(38)) add(1);
    if (kb.Shift(40)) add(-1);
    if (kb.Shift(82)) reset(); //r

    kb.Update();
  }

  void add(int x) {
    switch (menu) {
    case 1:
      if (kb.getKey(16)) maxIteration+=x;
      else maxIteration+=(x*10);
      break;
    case 2:
      break;
    }
  }

  void DrawSelection(int offset) {
    if (menu != 0)rect(7, offset * 40 + 16, 15, 4);
  }

  void HandleInput(int x, boolean y) {
    //println(x);
    //32[ ] 10[enter] 82[r] 16[shift]
    kb.setKey(x, y);
  }

  boolean Blink(float frekvens, boolean b, boolean shift, float more)
  {
    if (!b) //Support for at blink kan slås fra ved at pass et variabel til metoden
      return true;

    blinkT = millis()-1000*floor(millis()/1000f);
    float periode = 1000f / frekvens;

    for (int i = 0; i < frekvens; i = i + 2)
    {
      if ((blinkT < (periode * (i + 1))* (more/frekvens+1) && blinkT > periode * i))
      {
        return !shift;
      }
    }
    return shift;
  }
}
