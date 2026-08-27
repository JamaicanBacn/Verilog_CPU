#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

/* Unpacks the 32-bit machine code instruction given into the correct
 * type within the instruction struct */
Instruction parse_instruction(uint32_t instruction_bits) {
  /* YOUR CODE HERE */
  Instruction instruction;
  // add x9, x20, x21   hex: 01 5A 04 B3, binary = 0000 0001 0101 1010 0000 0100 1011 0011
  // Opcode: 0110011 (0x33) Get the Opcode by &ing 0x1111111, bottom 7 bits
  instruction.opcode = instruction_bits & ((1U << 7) - 1);

  // Shift right to move to pointer to interpret next fields in instruction.
  instruction_bits >>= 7;

  switch (instruction.opcode) {
  // R-Type
  case 0x33:
    // instruction: 0000 0001 0101 1010 0000 0100 1, destination : 01001
    instruction.rtype.rd = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    // instruction: 0000 0001 0101 1010 0000, func3 : 000
    instruction.rtype.funct3 = instruction_bits & ((1U << 3) - 1);
    instruction_bits >>= 3;

    // instruction: 0000 0001 0101 1010 0, src1: 10100
    instruction.rtype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    // instruction: 0000 0001 0101, src2: 10101
    instruction.rtype.rs2 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    // funct7: 0000 000
    instruction.rtype.funct7 = instruction_bits & ((1U << 7) - 1);
    break;
  case 0x03:
  case 0x13:
  case 0x73:
    // load , Imm , Ecall: i_type 
    instruction.itype.rd = instruction_bits & ((1U << 5) -1);
    instruction_bits >>= 5;

    instruction.itype.funct3 = instruction_bits & ((1U << 3) -1);
    instruction_bits >>=3;

    instruction.itype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>=5;

    instruction.itype.imm = instruction_bits & ( (1U << 12) -1);
    break;

  case 0x23:
    // store : s_type
    instruction.stype.imm5 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    instruction.stype.funct3 = instruction_bits & ((1U << 3) - 1);
    instruction_bits >>= 3;

    instruction.stype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    instruction.stype.rs2 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    instruction.stype.imm7 = instruction_bits & ((1U << 7) - 1);

    break;

  case 0x63:
    // branch : sb_type
    instruction.sbtype.imm5 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    instruction.sbtype.funct3 = instruction_bits & ((1U << 3) - 1);
    instruction_bits >>= 3;

    instruction.sbtype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    instruction.sbtype.rs2 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    instruction.sbtype.imm7 = instruction_bits & ((1U << 7) - 1);
    break;
    
  case 0x37:
    // LUI : u_type
    instruction.utype.rd = instruction_bits & ((1U << 5 ) -1);
    instruction_bits >>= 5;

    instruction.utype.imm = instruction_bits & (-1);

    break;
  
  case 0x6f:
    // JAL : uj_type
    instruction.ujtype.rd = instruction_bits & ((1U << 5) -1);
    instruction_bits >>= 5;

    instruction.ujtype.imm = instruction_bits & (-1);

    break;

  /* YOUR CODE HERE */

  #ifndef TESTING
  default:
    exit(EXIT_FAILURE);
  #endif
  }
  return instruction;
}

/************************Helper functions************************/
/* Here, you will need to implement a few common helper functions, 
 * which you will call in other functions when parsing, printing, 
 * or executing the instructions. */

/* Sign extends the given field to a 32-bit integer where field is
 * interpreted an n-bit integer. */
int sign_extend_number(unsigned int field, unsigned int n) {
  /* YOUR CODE HERE */
  //shifts unsigned 1 to check fields n-1 bit's sign if its 1 sign = 1, else 0
  unsigned int sign = !!(field & (1U << (n-1)));
  //overloads sign eg 0 becomes 0x00000000 and 1 = 0xFFFFFFFF
  unsigned int overload = (~sign) +1;
  unsigned int shiftedOverload = overload << n;
  return (int) (shiftedOverload | field);

  return 0;
}

/* Return the number of bytes (from the current PC) to the branch label using
 * the given branch instruction */
int get_branch_offset(Instruction instruction) {
  /* YOUR CODE HERE */
  unsigned int bit_11;
  unsigned int bit_12;
  unsigned int bits_10_to_5;
  unsigned int bits_4_to_1;

  bit_12 = (instruction.sbtype.imm7 << 5) & ( 1U << 11);
  bit_11 = (instruction.sbtype.imm5 & 1) << 10;
  bits_10_to_5 = (instruction.sbtype.imm7 & 0x3F) << 4;
  bits_4_to_1 = (instruction.sbtype.imm5) >> 1;

  unsigned int offset = bit_12 | bit_11 | bits_10_to_5 | bits_4_to_1;

  return sign_extend_number(offset , 12) << 1;
 
  return 0;
}

/* Returns the number of bytes (from the current PC) to the jump label using the
 * given jump instruction */
int get_jump_offset(Instruction instruction) {
  /* YOUR CODE HERE */
  
  unsigned int bits_1_to_10;
  unsigned int bit_11;
  unsigned int bits_12_to_19;
  unsigned int bit_20;

  // extract each section of the immmidiate value
  bits_1_to_10  = (instruction.ujtype.imm >> 9) & (0X3FF);
  bits_12_to_19 = (instruction.ujtype.imm & 0xFF ) << 11;
  bit_11 = (instruction.ujtype.imm  & (1U << 8) ) << 2;
  bit_20 = (instruction.ujtype.imm) & ((1U << 19)); 

  //form into one 20 bit number and extend to 32 bits for the PC
  int offset = bits_1_to_10 | bits_12_to_19 | bit_11 | bit_20;
  offset = sign_extend_number(offset , 20) ;

  // JAL -> PC + imm * 2 . 
  return offset << 1;

  return 0;
}

/* Returns the number of bytes (from the current PC) to the base address using the
 * given store instruction */
int get_store_offset(Instruction instruction) {
  /* YOUR CODE HERE */
 //imm7 = 0000011, imm5 = 11000
  //offset = 0000011 11000
  unsigned int offset = (instruction.stype.imm7 << 5) | instruction.stype.imm5;
  return sign_extend_number(offset, 12);
}
/************************Helper functions************************/

void handle_invalid_instruction(Instruction instruction) {
  printf("Invalid Instruction: 0x%08x\n", instruction.bits);
}

void handle_invalid_read(Address address) {
  printf("Bad Read. Address: 0x%08x\n", address);
  exit(-1);
}

void handle_invalid_write(Address address) {
  printf("Bad Write. Address: 0x%08x\n", address);
  exit(-1);
}
