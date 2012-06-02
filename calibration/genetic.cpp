/* 24 Jan 2001 */
/* Genetic Algorithm, genes with alleles stored in XML file calibration.xml. */
/* used to calibrate intermittent supply model */

//libxml stuff
#include <gnome-xml/parser.h>
#include <gnome-xml/tree.h>

#include <stdlib.h>
#include <math.h>

#include "genetic.h"

void print_allele_value(xmlNodePtr xnpCalibration, int gene_nr, char *allele_name);
void set_gene_fitness(xmlNodePtr xnpCalibration, int gene_nr, char *fitness);

int main(int argc, char **argv) {
  
        xmlDocPtr xdpCalibration = xmlParseFile("calibration.xml");
	if(xdpCalibration == NULL) {
		printf("XML Error");
	}
	
	xmlNodePtr xnpCalibration = xdpCalibration->root->childs;
	if(argc == 3) {
		print_allele_value(xnpCalibration, atoi((const char *)argv[1]), argv[2]);
	}
	else if((argc == 2)&&(strcmp(argv[1],"reproduce")==0)){
		Genetic *genetic = new Genetic(xdpCalibration);
		genetic->reproduce();
		genetic->savePopulation();
	}
	else if(argc == 4) {
		set_gene_fitness(xnpCalibration, atoi((const char *)argv[1]), argv[3]);
		/* save calibration xml file */
		xmlSetDocCompressMode(xdpCalibration, 0);
		xmlSaveFile("calibration.xml", xdpCalibration);
	}
	else {
		printf("USAGE: genetic gene_nr allelename\n       genetic reproduce\n       genetic gene_nr set fitnessvalue\n");
	}
	xmlFreeDoc(xdpCalibration);
}

/* writes the fitness value to the gene gene_nr in the xml file*/
void set_gene_fitness(xmlNodePtr xnpCalibration, int gene_nr, char *fitness) {
	xmlNodePtr xnpGene;
	xmlNodePtr xnpWalk = xnpCalibration;
	char *property;
	
	while(xnpWalk != NULL) {
		if(strcmp((char *)xnpWalk->name, "population")==0) {
			xnpGene = xnpWalk->childs;
			for(int i=1; i<gene_nr; i++) {
				if(xnpGene != NULL)
					xnpGene = xnpGene->next;
				else
					return;
			}
			if(xnpGene != NULL) {
				 property = (char *)xmlGetProp(xnpGene, (xmlChar *)"fitness");
				if(property != NULL){
					xmlSetProp(xnpGene, (xmlChar *)"fitness", (xmlChar *)fitness);
				}
				else {
					xmlNewProp(xnpGene, (xmlChar *)"fitness", (xmlChar *)fitness);
				}
			}
		}
		xnpWalk = xnpWalk->next;
	}
}

/* fetches the allele with the name allele_name from gene gene_nr and prints it */
void print_allele_value(xmlNodePtr xnpCalibration, int gene_nr, char *allele_name){
	xmlNodePtr xnpGene;
	xmlNodePtr xnpWalk = xnpCalibration;
	xmlNodePtr xnpAllele;
	char *allele;
	char *content;
	
	while(xnpWalk != NULL) {
		if(strcmp((char *)xnpWalk->name, "population")==0) {
			xnpGene = xnpWalk->childs;
			for(int i=1; i<gene_nr; i++) {
				if(xnpGene != NULL)
					xnpGene = xnpGene->next;
				else
					return;
			}
			if(xnpGene != NULL) {
				xnpAllele = xnpGene->childs;
				while(xnpAllele != NULL) {
				        content = (char *)xnpAllele->childs->content;
					if(content == NULL)
						return;					
					if(strcmp((char *)content, allele_name)==0) {
						allele = (char *)xmlGetProp(xnpAllele, (xmlChar *)"value");
						if(allele != NULL){
							printf("%s\n", allele);
						}
					}
					xnpAllele = xnpAllele->next;
				}
			}
		}
		xnpWalk = xnpWalk->next;
	}
}

Genetic::Genetic(xmlDocPtr xdpGenetic) {
  xdpXml = xdpGenetic;
  numGenes = 0;
  numAlleles = 0;


  xmlNodePtr xnpAlleles = NULL;
  xmlNodePtr xnpWalk;
  xmlNodePtr xnpGenes;

  // random seed
  srand((unsigned)time(NULL));

  // load model from XML
  xnpWalk = xdpXml->root->childs;
  //find Limits node
  while(xnpWalk != NULL) {
    if(strcmp((char *)xnpWalk->name, "limits")==0) {
      xnpAlleles = xnpWalk->childs;
      xmlNodePtr xnpAllele = xnpAlleles;
      while(xnpAllele != NULL) {
      	if(strcmp((char *)xnpAllele->name, "allele")==0) {
	  numAlleles++;
        }
        xnpAllele = xnpAllele->next;
      }
    }
    xnpWalk = xnpWalk->next;
  }
  if(xnpAlleles == NULL){
    printf("Can't find limits.\n");
    exit(0);
  }
  xnpWalk = xdpXml->root->childs;
  // find Genes
  while(xnpWalk != NULL) {
    if(strcmp((char *)xnpWalk->name, "population")==0) {
      xmlNodePtr xnpGene = xnpWalk->childs;
      xnpGenes = xnpGene;
      while(xnpGene != NULL){
	if(strcmp((char *)xnpGene->name, "gene")==0) {
	  numGenes++;
	}
	xnpGene = xnpGene->next;
      }

      break;
    }
    xnpWalk = xnpWalk->next;
  }
  if(numGenes == 0) {	
    printf("FATAL Error: No genes found.\n");
    exit(0);
  }
  //load genes
  xnpWalk = xnpGenes;
  for(int i=0; i<numGenes; i++) {
    genes[i].likelihood = 0;
    while((xnpWalk != NULL)&&(strcmp((char *)xnpWalk->name, "gene")!=0)) {
      xnpWalk = xnpWalk->next;
    }
    char *cfitness = (char *)xmlGetProp(xnpWalk, (xmlChar *)"fitness");
    if(cfitness != NULL){
      double dfitness = atof(cfitness);
      genes[i].fitness = dfitness;
    }
    else {
    	genes[i].fitness = 0;
    }
    //load alleles of the gene
    xmlNodePtr xnpAllele = xnpWalk->childs;
    for(int j=0; j<numAlleles; j++) {  
      if(xnpAllele != NULL) {
      	  char *cname =(char *)xnpAllele->childs->content;   
	  if(cname != NULL) {
	    genes[i].alleles[j].name = cname;
	  }
	  char *cvalue = (char *)xmlGetProp(xnpAllele, (xmlChar *)"value");
	  if(cvalue != NULL) {
	    double dvalue = atof(cvalue);
	    genes[i].alleles[j].value = dvalue;
	  }
	  //allele limits
	  xmlNodePtr xnpAlleleLimits = xnpAlleles;
	  float min = 0;
	  float max = 0;   
	  while(xnpAlleleLimits != NULL) {
	    cname = (char *)xnpAlleleLimits->childs->content;
	    if((cname != NULL)&&(strcmp(cname, genes[i].alleles[j].name)==0)) {
	      cvalue = (char *)xmlGetProp(xnpAlleleLimits, (xmlChar *)"min");
	      if(cvalue != NULL) {
	        min = atof(cvalue);
              }
	      cvalue = (char *)xmlGetProp(xnpAlleleLimits, (xmlChar *)"max");
	      if(cvalue != NULL) {
	        max = atof(cvalue);
              }
	      break;
	    }
	    xnpAlleleLimits = xnpAlleleLimits->next;
	  }
	  genes[i].alleles[j].min = min;
	  genes[i].alleles[j].max = max;
	  xnpAllele = xnpAllele->next;
      }
    }
    if(xnpWalk != NULL)
    	xnpWalk = xnpWalk->next;
  }  
}

void Genetic::reproduce(){
  // the real thing
  Gene newpopulation[MAX_GENES];
  
  calculateLikelihoods();
  for(int i=0; i<numGenes; i++) {
    int father = 0;
    int mother = 0;
    int iterations = 0;
    while(father == mother || genes[father] == genes[mother]) {
      father = findParentByLikelihood((float)(rand()%101));
      mother = findParentByLikelihood((float)(rand()%101));
      if(++iterations > 25) break;
    }
    newpopulation[i] = calculateBreed(genes[father], genes[mother]);
  }
  for(int i=0; i<numGenes; i++) {
    genes[i] = newpopulation[i];
  }  
}

int Genetic::findParentByLikelihood(float flikelihood) {
// return the gene nr if it's likelihood is smaller
// than the provided one
// otherwise return numGenes+1
  float last = 0;
  
  for(int i=0; i<numGenes; i++) {
    if(last <= flikelihood && flikelihood <=  genes[i].likelihood) {
      return i;
    }
    else {
      last = genes[i].likelihood;
    }
  }
  return 4;
}

void Genetic::calculateLikelihoods() {
  // calculate the likelihood for breeding
  
  float fSumInverse = 0;
  for(int i; i<numGenes; i++) {
    fSumInverse += 1/((float)genes[i].fitness); 
  }
  float last = 0;
  for(int i=0; i<numGenes; i++) {
    genes[i].likelihood = last = last+((1/((float)genes[i].fitness)/fSumInverse)*100);
  }    
}

Gene Genetic::calculateBreed(Gene father, Gene mother) {
  // creates a new child from the provided parents
  int crossover = rand()%(numAlleles-1)+1;
  int iFirstParent = rand()%100;
  
  Gene child = father;
  
  int initial = 0;
  int final = crossover;
  int r;
  
  for(int i=initial; i<final; i++) {
    child.alleles[i] = mother.alleles[i];
    r = rand()%101;
    if(r < 5) {
       float mutatedValue = ((float)(rand()%100000001))/100000000;
       mutatedValue = mutatedValue * (child.alleles[i].max - child.alleles[i].min);
       mutatedValue = mutatedValue + child.alleles[i].min;
       child.alleles[i].value = mutatedValue; 
    }
    else if(r <15) {
      child.alleles[i].value = child.alleles[i].value*0.9;
      if(child.alleles[i].value < child.alleles[i].min) {
	child.alleles[i].value = child.alleles[i].min;
      }
    }
    else if(r < 25) {
       child.alleles[i].value = child.alleles[i].value*1.1; 
       if(child.alleles[i].value > child.alleles[i].max) {
	 child.alleles[i].value = child.alleles[i].max;
       }
    }
  }
  return child;
}

void Genetic::savePopulation() {
  char cvalue[32];
  xmlNodePtr xnpOldPopulation = NULL;
  
  xmlNodePtr xnpPopulation = xmlNewNode(NULL, (xmlChar *)"population");
  for(int i=0; i<numGenes; i++) {
    xmlNodePtr xnpGene = xmlNewChild(xnpPopulation, NULL, (xmlChar *)"gene", NULL);
    for(int j=0; j<numAlleles; j++) {
    	xmlNodePtr xnpAllele = xmlNewChild(xnpGene, NULL, (xmlChar *)"allele", (xmlChar *)genes[i].alleles[j].name);
	sprintf(cvalue, "%f",genes[i].alleles[j].value); 
    	xmlSetProp(xnpAllele, (xmlChar *)"value", (xmlChar *)cvalue);
    }
  }
  xnpOldPopulation = xdpXml->root->childs;
  while((xnpOldPopulation != NULL)&&(strcmp((char *)xnpOldPopulation->name, "population") != 0)) {
    xnpOldPopulation = xnpOldPopulation->next;
  }
  if(xnpOldPopulation == NULL) {
    printf("FATAL ERROR: can't find population node.\n");
    exit(0);
  }
  xmlReplaceNode(xnpOldPopulation, xnpPopulation);
  
  // save to XML
  xmlSetDocCompressMode(xdpXml, 0);
  xmlSaveFile("calibration.xml", xdpXml);
  xmlFreeNode(xnpOldPopulation);
}

Genetic::~Genetic() {
  //not needed yet
  
}

