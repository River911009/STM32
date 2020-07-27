void ResetISR(void);
extern int main(void);

unsigned long (* const VectorTable[]) __attribute__ ((section(".isr_vector")))={
  (unsigned long *)(0x20005000),
  (unsigned long *)ResetISR
};

void ResetISR(void){
  extern unsigned long _etext;
  extern unsigned long _sdata;
  extern unsigned long _edata;
  extern unsigned long _sbss;
  extern unsigned long _ebss;
  unsigned long *src,*dst;

  src=&_etext;
  dst=&_sdata;
  while(dst<&_edata) *dst++=*src++;

  for(dst=&_sbss;dst<&_ebss;dst++){
    *dst=0;
  }

  main();
}
