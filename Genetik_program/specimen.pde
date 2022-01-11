class Specimen {

  int fitness = 0; //between 1 and 0
  boolean[] genes;
  int ialt = 24;
  boolean base;
  int[][] objects = {{90, 150}, 
    {130, 35}, 
    {1530, 200}, 
    {500, 160}, 
    {150, 60}, 
    {680, 45}, 
    {270, 60}, 
    {390, 40}, 
    {230, 30}, 
    {520, 10}, 
    {110, 70}, 
    {320, 30}, 
    {240, 15}, 
    {480, 10}, 
    {730, 40}, 
    {420, 70}, 
    {430, 75}, 
    {220, 80}, 
    {70, 20}, 
    {180, 12}, 
    {40, 50}, 
    {300, 10}, 
    {900, 1}, 
    {2000, 150}};

  Random rd;

  Specimen(boolean b) {
    base = b;
    rd = new Random();
    genes = new boolean[ialt];
    for (int i = 0; i < ialt; i++) {
      genes[i] = rd.nextBoolean();
      if (base) genes[i] = false;
    }
  }

  void Fitness() {
    int money = 0;
    int weight = 0;
    for (int i = 0; i <ialt; i++) {
      if (genes[i]) {
        money += objects[i][1];
        weight += objects[i][0];
      }
    }
    if (weight > 5000) { 
      fitness = money - (weight-5000);
      return;
    }
    fitness = money;
    if (fitness == 0) fitness = 1;
  }

  Specimen Crossover(Specimen partner) {
    Specimen child = new Specimen(base);
    int midpoint = int(random(ialt));
    for (int i = 0; i < ialt; i++) {
      if (i > midpoint) child.genes[i] = genes[i];
      else child.genes[i] = partner.genes[i];
    }
    return child;
  }

  void Mutate(float mutationRate) {
    for (int i = 0; i < ialt; i++) {
      if (random(1) < mutationRate) {
        genes[i] = rd.nextBoolean();
      }
    }
  }

  int getFitness() {
    return fitness;
  }

  boolean[] getGenes() {
    return genes;
  }
}
