

VFLAGS =  --cc --exe --build --trace-fst

TESTMOD = $(firstword $(MAKECMDGOALS))
INCLUDE = -I$(CURDIR)/Code/Include
TBDIR = $(CURDIR)/TestBenches
COMPDIR = $(CURDIR)/CompilationLists
OBJDIR =  $(TBDIR)/$(TESTMOD)/obj_dir 
TOPMOD = $(TESTMOD)
CPP = $(COMPDIR)/$(TESTMOD)/cpp.f
RTL = $(COMPDIR)/$(TESTMOD)/rtl.f

NAME = $(word 2,$(MAKECMDGOALS))

tb:
	mkdir $(COMPDIR)/$(NAME)
	touch $(COMPDIR)/$(NAME)/cpp.f
	touch $(COMPDIR)/$(NAME)/rtl.f

	mkdir $(TBDIR)/$(NAME)
	touch $(TBDIR)/$(NAME)/$(NAME).cpp

build:
	verilator $(VFLAGS) --Mdir $(OBJDIR) --top-module $(TOPMOD) -f $(RTL) -f $(CPP) -CFLAGS $(INCLUDE)
clean:
	rm -rf ./TestBenches/*/*.vcd

ProgramCounter: build
InstructionDecoder: build
DecodeTop : build
