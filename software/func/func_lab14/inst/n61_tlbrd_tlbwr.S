#include "asm.h"
#include "regdef.h"

LEAF(n61_tlbrd_tlbwr_test)

    addi.w s0, s0 ,1
    li     s2, 0x0

###read an invalid TLB item
    li    t0, 0x8c000000            #index
	li    t1, 8<<13
	li    t2, 1<<13
    add.w t1, t1, t2	            #VPN
    li    t2, 0x0034ab00            #PPN1
    li    t3, 0x00ffab00            #PPN2
    csrwr t0, csr_tlbidx
    csrwr t1, csr_tlbehi
    csrwr t2, csr_tlbelo0
    csrwr t3, csr_tlbelo1
    tlbwr

    li    t0, 0x0c000000            #index
    csrwr t0, csr_tlbidx
    tlbrd
    csrrd t1, csr_tlbehi
    li    t2, 0x12000
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbelo0
    li    t2, 0x34ab00
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbelo1
    li    t2, 0xffab00
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbidx
    li    t2, 0x8c000000
    bne   t1, t2, inst_error

###recover the TLB item
    li    t0, 0x0c000000            #index
	li    t1, 8<<13
	li    t2, 1<<13
    add.w t1, t1, t2	            #VPN
    li    t2, 0x0034ab00            #PPN1
    li    t3, 0x00ffab00            #PPN2
    csrwr t0, csr_tlbidx
    csrwr t1, csr_tlbehi
    csrwr t2, csr_tlbelo0
    csrwr t3, csr_tlbelo1
    tlbwr

###read a valid TLB item
    li    t0, 0x0c000000
    csrwr t0, csr_tlbidx
    tlbrd
    csrrd t1, csr_tlbehi
    li    t2, 0x00012000
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbelo0
    li    t2, 0x0034ab00
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbelo1
    li    t2, 0x00ffab00
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbidx
    li    t2, 0x0c000000
    bne   t1, t2, inst_error

###read a valid TLB item
    li    t0, 0x0c000001
    csrwr t0, csr_tlbidx
    tlbrd
    csrrd t1, csr_tlbehi
    li    t2, 0x00014000
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbelo0
    li    t2, 0x0035ab00
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbelo1
    li    t2, 0x0100ab00
    bne   t1, t2, inst_error
    csrrd t1, csr_tlbidx
    li    t2, 0x0c000001
    bne   t1, t2, inst_error

###detect exception
    bne s2, zero, inst_error
###score ++
    addi.w s3, s3, 1
###output (s0<<24)|s3
inst_error:  
    slli.w t1, s0, 24
    or t0, t1, s3 
    st.w t0, s1, 0x0
    jirl zero, ra, 0x0

END(n61_tlbrd_tlbwr_test)
