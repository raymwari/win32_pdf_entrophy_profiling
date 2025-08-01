#include <stdio.h>
#include <math.h>

int count = 0;
int count_s = 0;
double ent = 0;

__declspec(dllexport)
int shannon(int occ, 
int ttl)
{ 
  float f = (float) occ / (float) ttl;
  double e = log2(f);
  ent = ent + e;  
  if (count >= ttl) {
    count_s++;
    count = 0;
    printf("# Stream %d | %f\n",
    count_s,
    (ent / ttl) * -1); 
    ent = 0;
  }
  count++;
  return 0;
}

