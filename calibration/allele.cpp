/* allele.cpp */
/* Created Thu Jan 25 2001 */

#include "allele.h"
#include "stdio.h"

Allele::Allele(char *allele_name, double min_value, double max_value, double initial_value) {
  name = allele_name;
  min = min_value;
  max = max_value;
  value = initial_value;
}

Allele::Allele() {
  name = "";
  min = 0;
  max = 0;
  value = 0;
}



