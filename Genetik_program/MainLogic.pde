class MainLogic { //<>//
  Keyboard kb;
  Specimen[] population;
  ArrayList<Specimen> matingPool;
  int[] graph;
  int graphNext = 0;
  boolean done = true, base = false;
  int iteration = 0, maxIteration = 100, blinkT = 0, menu = 0, pop = 100, mutationRate = 20, best = 0, wait = 0;
  int safeMax = 0;
  boolean[] bestGenes;

  MainLogic() {
    //I coded the keyboard and key classes myself, as my old solution to add controls is ineffecient and tedious.
    kb = new Keyboard(); //gotta have controls
    bestGenes = new boolean[24];
    for (int i = 0; i < 24; i++) {
      bestGenes[i] = false;
    }
  }

  void Update() {
    HandleControls();
    if (!done) ContinueSimulation();
    DrawUI();
  }

  //Does every step of an iteration
  void RunIteration() {
    delay(wait);
    //delay(100);
    //Calculate fitness
    for (int i = 0; i < population.length; i++) {
      population[i].Fitness();
    }

    //Build mating pool
    matingPool = new ArrayList<Specimen>();
    best = 1;

    for (int i = 0; i < population.length; i++) {
      if (population[i].getFitness() > best) { 
        best = population[i].getFitness();
        bestGenes = population[i].getGenes();
      }
    }

    for (int i = 0; i < population.length; i++) {
      int n = int((population[i].getFitness() / best) * 100);
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
      child.Mutate(mutationRate/1000f);
      population[i] = child;
    }

    graph[graphNext] = best;
    graphNext++;
  }

  //Preps the simulation and initializes arrays of the correct size and such
  void StartSimulation() {
    done = false;
    iteration = 0;
    graphNext = 0;
    safeMax = maxIteration;
    graph = new int[maxIteration];
    population = new Specimen[pop];
    for (int i = 0; i < population.length; i++) {
      population[i] = new Specimen(base);
    }
  }

  //pretty self explanatory
  void ContinueSimulation() {
    if (iteration == safeMax) {
      done = true;
      return;
    }
    iteration++;
    RunIteration();
  }

  //stops the simulation
  void Stop() {
    done = true;
  }

  //Resets to default values
  void reset() {
    done = true;
    iteration = 0;
    maxIteration = 100;
    pop = 100;
    mutationRate = 10;
  }

  //Draws every part of the screen image
  void DrawUI() {
    fill(0, 0, 0);
    textSize(50);
    text("Iteration: "+iteration, 28, 50);
    text("Best fitness: "+best, 28, 94);
    text("Controls", 1450, 50);
    textSize(30);
    boolean test = false;
    if (Blink(3, test, false, 0.3f) && menu == 1) text("Max iterations: "+maxIteration, 30, 130);
    else if (menu != 1) text("Max iterations: "+maxIteration, 30, 130);

    if (Blink(3, test, false, 0.3f) && menu == 2) text("Population: "+pop, 30, 170);
    else if (menu != 2) text("Population: "+pop, 30, 170);

    if (Blink(3, test, false, 0.3f) && menu == 3) text("Mutation Rate: "+mutationRate/1000f, 30, 210);
    else if (menu != 3) text("Mutation Rate: "+mutationRate/1000f, 30, 210);

    if (Blink(3, test, false, 0.3f) && menu == 4) text("Delay after iteration (ms): "+wait, 30, 250);
    else if (menu != 4) text("Delay after iteration (ms): "+wait, 30, 250);

    text("Population's dna starts as 0's: "+base, 30, 290);

    if (Blink(4, !test, false, 0)) DrawSelection(menu);
    if (!done) text("Simulation running", 500, 50);

    for (int i = 0; i < 24; i++) {
      if (bestGenes[i])text(1, 500 + 30*i, 800);
      else text(0, 500 + 30*i, 800);
    }

    line(99, 801, 500, 801);
    line(99, 801, 99, 400);
    
    //Draws the graph
    for (int i = 0; i < graphNext; i++) {
      pushMatrix();
      translate(100+(i*2), 800-int(graph[i]/3f));
      circle(0, 0, 2);
      if (i == graphNext-1) {
        text(best, 10, -10);
        textSize(20);
        text(iteration, 13, 13);
      }
      popMatrix();
    }
    
    //Draws the controls
    pushMatrix();
    translate(1350, 100);
    textSize(20);
    text("Left/right arrowkeys control the menu selection", 0, 0);
    text("Up/down arrow keys add/subtract from the shown value", 0, 35);
    text("Hold shift to add/subtract less", 0, 70);
    text("Enter, starts the simulation", 0, 105);
    text("Space stops the simulation", 0, 140);
    text("R resets to default values", 0, 175);
    popMatrix();
  }

  //checking all relevant keys
  void HandleControls() {
    if (kb.Shift(39) && menu != 5) menu++;
    if (kb.Shift(37) && menu != 0) menu--;
    if (kb.Shift(38)) add(1);
    if (kb.Shift(40)) add(-1);
    if (kb.Shift(82)) reset(); //r
    if (kb.Shift(10) && done) StartSimulation();
    if (kb.Shift(32)) Stop();

    kb.Update();
  }

  //doing stuff in menus
  void add(int x) {
    switch (menu) {
    case 1:
      if (kb.getKey(16)) maxIteration+=(x*1);
      else maxIteration+=(x*10);
      if (maxIteration < 1) maxIteration = 1;
      break;
    case 2:
      if (kb.getKey(16)) pop+=(x*1);
      else pop+=(x*10);
      if (pop < 4) pop = 4;
      break;
    case 3:
      if (kb.getKey(16)) mutationRate+=(x);
      else mutationRate+=(x*10);
      if (mutationRate > 1000) mutationRate = 1000;
      else if (mutationRate < 1) mutationRate = 1;
      break;
    case 4:
      if (kb.getKey(16)) wait+=(x);
      else wait+=(x*5);
      if (wait < 0) wait = 0;
      break;
    case 5:
      if (x > 0) base = true;
      else base = false;
      break;
    }
  }

  //The selection marker is drawn
  void DrawSelection(int offset) {
    if (menu != 0)rect(7, offset * 40 + 76, 15, 4);
  }

  //Function called whenever a keypress happens
  void HandleInput(int x, boolean y) {
    kb.setKey(x, y);
  }

  //A function i wrote to allow me full control of a blinking object.
  // Frequency of course, b is to disable the blinking, shift is so that whenever it would be true, its false, and more extends the time that its on per cycle by a percentage passed to it.
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
