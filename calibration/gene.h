#ifndef GENE_H
#define GENE_H

#include "allele.h"

class Gene
{
 public:
  Gene(char *gene_name, double inital_fitness, int num_alleles, Allele **gene_alleles);
  Gene();
  
  // private:
  double fitness;
  char *name;
  int numAlleles;
  Allele **alleles;
};

#endif





