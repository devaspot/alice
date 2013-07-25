//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//
// Last Change:
//   $Date: 2005-05-11 15:01:16 $ by $Author: cmueller $
//   $Revision: 1.29 $
//

#ifndef __ALICE__NATIVE_CODE_INTERPRETER_HH__
#define __ALICE__NATIVE_CODE_INTERPRETER_HH__

#if defined(INTERFACE)
#pragma interface "alice/NativeCodeInterpreter.hh"
#endif

#include "alice/Base.hh"

#if HAVE_LIGHTNING

typedef Worker::Result (*native_fun)();

class AliceDll NativeCodeInterpreter : public Interpreter {
private:
  // NativeCodeInterpreter Constructor
  NativeCodeInterpreter() : Interpreter() {}
public:
  // Exported NativeCodeInterpreter Instance
  static NativeCodeInterpreter *self;
  // NativeCodeInterpreter Static Constructor
  static void Init();
  static u_int GetInArity(TagVal *abstractCode);
  static u_int GetOutArity(TagVal *abstractCode);
  // Handler Methods
  virtual Transform *GetAbstractRepresentation(ConcreteRepresentation *);
  // Frame Handling
  virtual void PushCall(Closure *closure);
  virtual u_int GetFrameSize(StackFrame *sFrame);
  // Execution
  virtual Result Run(StackFrame *sFrame);
  virtual Result Handle(word data);
  virtual u_int GetInArity(ConcreteCode *concreteCode);
  virtual u_int GetOutArity(ConcreteCode *concreteCode);
  // Debugging
  virtual const char *Identify();
  virtual void DumpFrame(StackFrame *sFrame);
#if PROFILE
  // Profiling
  virtual word GetProfileKey(StackFrame *frame);
  virtual word GetProfileKey(ConcreteCode *concreteCode);
  virtual String *GetProfileName(StackFrame *frame);
  virtual String *GetProfileName(ConcreteCode *concreteCode);
#endif
};

#endif

#endif
