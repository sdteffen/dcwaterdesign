#ifndef GENETIC_H
#define GENETIC_H

/* libxml stuff */
#include <gnome-xml/tree.h>
#include <gnome-xml/parser.h>

#include <math.h>

/*#include "gene.h"
#include "allele.h"*/

#define MAX_GENES 100
#define MAX_ALLELES 50

typedef struct {
  float max;
  float min;
  char *name;
  float value;
} Allele;

struct Gene{
  Allele alleles[MAX_ALLELES];
  float  fitness;
  float  likelihood;
  int    numAlleles;
  
  bool operator==(Gene gn) {
    if(numAlleles != gn.numAlleles) {
      return false;
    }  
    for(int i=0; i<numAlleles; i++) {
      bool bFoundAllele = false;
      for(int j=0; j < numAlleles; j++) {
        if(strcmp(gn.alleles[j].name, alleles[i].name) ==0) {
	  bFoundAllele = true;
	  if(gn.alleles[j].value != alleles[i].value) {
	    return false;
	  }
	}
      }
      if(!bFoundAllele) {
        return false;
      } 
    }
    return true;
  }
};


class Genetic {
 public:
  Genetic(xmlDocPtr xdpGenetic);
  ~Genetic();
  void reproduce();
  void calculateLikelihoods();
  int findParentByLikelihood(float flikelihood);
  void savePopulation();
  Gene calculateBreed(Gene father, Gene mother);
  
 private:
  int numGenes;
  int numAlleles;
  Gene genes[MAX_GENES];
  xmlDocPtr xdpXml;
};

#endif

