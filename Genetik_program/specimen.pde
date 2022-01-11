class Specimen {

  float fitness = 0;
  int[] genes;

  Specimen() {
    genes = new int[25];
    for (int i = 0; i < 25; i++) {
      genes[i] = int(random(0, 1));
    }
  }

  void Fitness() {
  }

  Specimen Crossover(Specimen partner) {
    return new Specimen();
  }

  void Mutate(int mutationRate) {
  }

  float getFitness() {
    return fitness;
  }

  int[] getGenes() {
    return genes;
  }
}
