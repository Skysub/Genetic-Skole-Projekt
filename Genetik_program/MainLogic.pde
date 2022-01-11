class MainLogic {
  Keyboard kb;
  Specimen[] population;
  ArrayList<Specimen> matingPool;
  IntList graph;
  boolean done = true;
  int iteration = 0, maxIteration = 100, blinkT = 0, menu = 0, pop = 100, mutationRate = 10;

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
    //Calculate fitness
    for (int i = 0; i < population.length; i++) {
      population[i].Fitness();
    }

    //Build mating pool
    matingPool = new ArrayList<Specimen>();

    for (int i = 0; i < population.length; i++) {
      int n = int(population[i].getFitness() * 100);
      for (int j = 0; j < n; j++) {
        matingPool.add(population[i]);
      }
    }

    //Reproduce
    for (int i = 0; i < population.length; i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));
      Specimen partnerA = matingPool.get(a);
      Specimen partnerB = matingPool.get(b);
      Specimen child = partnerA.Crossover(partnerB);
      child.Mutate(mutationRate);
      population[i] = child;
    }
  }

  void StartSimulation() {
    done = false;
    iteration = 0;

    population = new Specimen[pop];
    for (int i = 0; i < population.length; i++) {
      population[i] = new Specimen();
    }
  }

  void ContinueSimulation() {
    if (iteration == maxIteration) {
      done = true;
      return;
    }
    iteration++;
    RunIteration();
  }

  void Stop() {
    done = true;
  }

  void reset() {
    done = true;
    iteration = 0;
    maxIteration = 100;
    pop = 100;
    mutationRate = 10;
  }

  void DrawUI() {

    fill(0, 0, 0);
    textSize(50);
    text("Iteration: "+iteration, 30, 50);
    textSize(30);
    boolean test = false;
    if (Blink(3, test, false, 0.3f) && menu == 1) text("Max iterations: "+maxIteration, 30, 90);
    else if (menu != 1) text("Max iterations: "+maxIteration, 30, 90);

    if (Blink(3, test, false, 0.3f) && menu == 2) text("Population: "+pop, 30, 130);
    else if (menu != 2) text("Population: "+pop, 30, 130);

    if (Blink(3, test, false, 0.3f) && menu == 3) text("Mutation Rate: "+mutationRate/1000f, 30, 170);
    else if (menu != 3) text("Mutation Rate: "+mutationRate/1000f, 30, 170);

    if (Blink(4, !test, false, 0)) DrawSelection(menu);

    if (!done) text("Simulation running", 400, 50);
  }

  void HandleControls() {
    if (kb.Shift(39) && menu != 3) menu++;
    if (kb.Shift(37) && menu != 0) menu--;
    if (kb.Shift(38)) add(1);
    if (kb.Shift(40)) add(-1);
    if (kb.Shift(82)) reset(); //r
    if (kb.Shift(10) && done) StartSimulation();
    if (kb.Shift(32)) Stop();

    kb.Update();
  }

  void add(int x) {
    switch (menu) {
    case 1:
      if (kb.getKey(16)) maxIteration+=x;
      else maxIteration+=(x*10);
      if (maxIteration < 1) maxIteration = 1;
      break;
    case 2:
      if (kb.getKey(16)) pop+=(x);
      else pop+=(x*25);
      if (pop < 4) pop = 4;

      break;
    case 3:
      if (kb.getKey(16)) mutationRate+=(x);
      else mutationRate+=(x*10);
      if (mutationRate > 1000) mutationRate = 1000;
      else if (mutationRate < 1) mutationRate = 1;
      break;
    }
  }

  void DrawSelection(int offset) {
    if (menu != 0)rect(7, offset * 40 + 36, 15, 4);
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
