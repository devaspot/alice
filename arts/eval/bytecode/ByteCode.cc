//
// Author:
//   Christian Mueller <cmueller@ps.uni-sb.de>
//
// Copyright:
//   Christian Mueller, 2005
//
// Last Change:
//   $Date: 2006-03-15 13:58:09 $ by $Author: tack $
//   $Revision: 1.15 $
//

#if defined(INTERFACE)
#pragma implementation "alice/ByteCode.hh"
#endif

#include <cstdio>
#include "alice/ByteCode.hh"
using namespace ByteCodeInstr;

#ifdef THREADED
void **ByteCode::instrTable = NULL;
word ByteCode::threadedTable = INVALID_POINTER;
#endif // THREADED

ProgramCounter ByteCode::DisassembleOne(std::FILE *f, ProgramCounter PC, 
					Chunk *code, Tuple *imEnv) {
  ReadBuffer *codeBuffer = ReadBuffer::New(code);

  fprintf(f,"PC %d: ",PC);
  u_int instr;
  GET_INSTR(codeBuffer,PC,instr);

#ifdef THREADED			
  instr = ThreadedToNumber((void*)instr);
#endif

  switch(instr) {
    // use automatically generated code
    // It is constructed from the comments in ByteCodeInstrs.hh
#include "bytecode_disassembler_body.hh"
  }
}

void ByteCode::Disassemble(std::FILE *f, ProgramCounter pc, 
			   Chunk *code, Tuple *imEnv) {
#ifdef THREADED
  ProgramCounter end = (ProgramCounter) (code->GetBase() + code->GetSize());
  while(pc < end) {
#else
  u_int max = code->GetSize();
  while(4 * pc < max) {
#endif
    pc = ByteCode::DisassembleOne(f,pc,code,imEnv);
  }
}
