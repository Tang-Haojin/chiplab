include ../../../sims/verilator/run_func/config-software.mak

GCC_BIN=../../../toolchains/loongarch32_gnu/install/bin

libinst.a: obj/start.o
	$(MAKE) -C inst $@
	
obj/start.o: raw
	${GCC_BIN}/loongarch32-linux-gnu-as -mabi=ilp32 obj/start.s -o obj/start.o

raw:
	$(MAKE) -C obj $@ -f ../inst/Makefile

script:
	./script.sh

start:
	@mkdir -p obj
ifeq ('${TRACE_COMP}', 'y')
	${GCC_BIN}/loongarch32-linux-gnu-gcc \
		-Iinclude -nostdinc -nostdlib -D_KERNEL  -fno-builtin -D__loongarch32\
		-DMEMSTART=0x10000000 -DMEMSIZE=0x04000 -DCPU_COUNT_PER_US=1000     \
		-DENABLE_TRACE -S start.S > obj/start.s 
else
	${GCC_BIN}/loongarch32-linux-gnu-gcc \
		-Iinclude -nostdinc -nostdlib -D_KERNEL -fno-builtin -D__loongarch32\
		-DMEMSTART=0x10000000 -DMEMSIZE=0x04000 -DCPU_COUNT_PER_US=1000     \
		-S start.S > obj/start.s 
endif

clean:
	rm -f *.o *.a 
	rm start.s
	rm -rf obj
	$(MAKE) -C inst clean 

clean_no_obj:
	rm -f *.o *.a 
	rm obj/start.s
	$(MAKE) -C inst clean 

reset:
	$(MAKE) clean
	rm -f bin.lds convert

help:
	@echo "################################################################"
	@echo "### help for compiling func"
	@echo "################################################################"
	@echo "### options:"
	@echo "###     make      : get compiled result, which is saved in ./obj"
	@echo "###     make clean: remove *.o, *.a, and ./obj"
	@echo "###     make reset: "make clean" and remove convert, bin.lds"
	@echo "###     make help : show help information"
	@echo "###############################################################"

