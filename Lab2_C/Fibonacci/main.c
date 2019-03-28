#include "mfp_io.h"

void delay();

//------------------
// main()
//------------------
int main() {
  unsigned int f1, f2, temp, i;

  while (1) {
    f1 = 1; // F(-1)
    f2 = 0; // F(0)
    for (i = 0; i < 11; i++) {
      temp = f1 + f2; // F(n+2) = F(n) + F(n+1)
      f1 = f2;
      f2 = temp;
      MFP_LEDS = f2;
      delay();
    }
  }
  return 0;
}

void delay() {
  volatile unsigned int j;

  for (j = 0; j < (1000000); j++) ;	// delay 
}
