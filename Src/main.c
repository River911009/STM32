#include "main.h"

int main(){
  unsigned int c=0;

  RCC_APB2ENR|=(1<<4);
  GPIOC_CRH=0x44144444;

  while(1){
    GPIOC_BSRR=(1<<29);
    for(c=0;c<500000;c++);
    GPIOC_BSRR=(1<<13);
    for(c=0;c<500000;c++);
  }
}
