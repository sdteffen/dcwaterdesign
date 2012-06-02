#ifndef ALLELE_H
#define ALLELE_H

class Allele
{
 public:
  Allele(char *name, double min_value, double max_value, double intial_value);
  Allele();

  // private:
  double min;
  double max;
  double value;
  char *name;
};

#endif
