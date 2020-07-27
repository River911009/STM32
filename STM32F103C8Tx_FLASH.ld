MEMORY{
  FLASH(RX):ORIGIN = 0x08000000,LENGTH = 64K
  SRAM(XRW):ORIGIN = 0x20000000,LENGTH = 20K
}

SECTIONS{
  .text :{
    KEEP(*(.isr_vector))
    *(.text)
    *(.rodata)
    . = ALIGN(4);
    _etext = .;
  }>FLASH

  .sdata :AT(_etext){
    _sdata = .;
    *(.sdata)
    . = ALIGN(4);
    _edata = .;
  }>SRAM

  .sbss(NOLOAD) :{
    _sbss = .;
    *(.sbss)
    . = ALIGN(4);
    _ebss = .;
  }>SRAM

  _end = .;
}