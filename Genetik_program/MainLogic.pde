class MainLogic {

  IntList graph;
  boolean done = false;

  MainLogic() {
    graph = new IntList();
  }

  void Update() {
    done = RunIteration();
  }

  //Returnerer true hvis der ikke skal køres flere iterationer.
  boolean RunIteration() {
    return false; 
  }
}
