

InstructionDecoder:
	verilator --cc --exe --build --trace-fst  --Mdir ./TestBenches/InstructionDecoder/obj_dir --top-module Instruction_decoder ./CPU/Decode_stage/Instruction_decoder.v InstructionDecoder_tb.cpp
ProgramCounter:
	verilator --cc --exe --build --trace-fst  --Mdir ./TestBenches/ProgramCounter/obj_dir --top-module ProgramCounter ./CPU/Fetch_stage/ProgramCounter.v ProgramCounter_tb.cpp
clean:
	rm -rf ./TestBenches/*/*.vcd