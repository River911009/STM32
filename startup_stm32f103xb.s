.cpu cortex-m3
.thumb

.word 0x20005000
.word _reset
.thumb_func

_reset:
  bl main
  b  .
