#include "asm.h"
#include "regdef.h"
#include "inst_test.h"

LEAF(n58_ti_ex_idle_test)
   
  addi.w  s0, s0, 1 
  li      t0, 0x800d0000 
  li      s2, 0x4 
  st.w    s2, t0, 0 
  //clear ti
  li      t0, 0x1 
  csrwr   t0, csr_ticlr 
  //init usr mode
  li      t0, 0x3
  li      t1, 0x7 
  csrxchg t0, t1, csr_crmd 
  lu12i.w s7, 0x40 
  li      t5, 0x7 //used for verify prmd  
  csrwr   zero, csr_tcfg

##inst test
###1  
  la.local  s4, 1f 
  TEST_TI_EX_WAIT(0x120) 
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7 
  bne     t1, t0, inst_error 

###2
  li      t7, 0xd0000
  li      s2, 0x04
  la.local  s4, 1f
  st.w    t7, t7, 4
  st.w    s4, t7, 4 
  TEST_TI_EX_WAIT(0x74) 
  st.w    s4, t7, 0 
  ld.w    t1, t7, 4 
  bne     t1, s4, inst_error  
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7 
  bne     t1, t0, inst_error 
  li      s2, 0x4 
  st.w    s2, t7, 0

###3
  li      s2, 0x04
  la.local  s4, 1f
  li      t7, 0xf 
  li      t8, 0xf
  div.w   t7, t1, s0 
  TEST_TI_EX_WAIT(0x10) 
  beq     t8, t7, inst_error 
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7 
  bne     t1, t0, inst_error 

###4
  li      s2, 0x04
  la.local  s4, 1f
  TEST_TI_EX_WAIT(0x0) 
  div.w   t0, t0, s0 
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7
  bne     t1, t0, inst_error 

###5
  li      s2, 0x04
  la.local  s4, 1f
  li      t7, 0xf 
  li      t8, 0xf
  mul.w   t7, s0, t7
  TEST_TI_EX_WAIT(0x4) 
  beq     t8, t7, inst_error 
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7
  bne     t1, t0, inst_error 
   
###6
  li      s2, 0x04
  la.local  s4, 1f
  TEST_TI_EX_WAIT(0x8) 
  mul.w   t0, t0, s0 
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7
  bne     t1, t0, inst_error  

###7
  li      s2, 0x04
  la.local  s4, 1f
  csrwr   s2, csr_era
  TEST_TI_EX_WAIT(0x34) 
  csrwr   t0, csr_era
  bne     s2, s7, inst_error 
  csrrd   t0, csr_crmd 
  li      t1, 0x7 
  and     t0, t0, t1 
  li      t1, 0x7
  bne     t1, t0, inst_error 

  li      t0, 0x0 
  li      t1, 0x3 
  csrxchg t0, t1, csr_crmd 
###score +++
  addi.w  s3, s3, 1
###output (s0<<24)|s3 
inst_error:
  slli.w  t1, s0, 24 
  or      t0, t1, s3 
  st.w    t0, s1, 0 
  jirl    zero, ra, 0 
END(n58_ti_ex_idle_test)
