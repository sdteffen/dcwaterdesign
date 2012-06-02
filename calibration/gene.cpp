/* gene.cpp */
/* Thu Jam 25 2001 */

#include "gene.h"
#include "allele.h"
#include "genetic.h"

//libxml stuff
#include <gnome-xml/parser.h>
#include <gnome-xml/tree.h>

#include <math.h>

Gene::Gene(char *gene_name, double initial_fitness, int num_alleles, Allele **gene_alleles) {
  name = gene_name;
  fitness = initial_fitness;
  numAlleles = num_alleles;
  alleles = gene_alleles;
}

Gene::Gene() {
  name = "";
  fitness = 0;
  numAlleles = 0;
  alleles = NULL;
}

