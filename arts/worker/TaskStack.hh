//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//   Leif Kornstaedt, 2000-2003
//
// Last Change:
//   $Date: 2007-03-16 17:25:27 $ by $Author: rossberg $
//   $Revision: 1.23 $
//

#ifndef __GENERIC__TASK_STACK_HH__
#define __GENERIC__TASK_STACK_HH__

#if defined(INTERFACE)
#pragma interface "generic/TaskStack.hh"
#endif

#include <csetjmp>


class StackFrame;

class SeamDll TaskStack: private DynamicBlock {
private:
  static const u_int INITIAL_SIZE = 20;
  static word emptyTask;
  static word emptyStack;
  static jmp_buf *overflowJmp;
public:

  static const u_int initialNumberOfFrames = 1;

  using DynamicBlock::ToWord;
  using DynamicBlock::GetSize;
  using DynamicBlock::GetArg;
  using DynamicBlock::ReplaceArg;

  static word uncaughtExceptionClosures;
  static void AddExnClosure(word closure);

  static void Init();
  static void SetOverflowJump(jmp_buf *jmpbuf) { overflowJmp = jmpbuf; }

  u_int GetTop() {
    return GetActiveSize();
  }
  void SetTop(u_int top);

  StackFrame *GetFrame(u_int index) {
    return (StackFrame *) (GetBase() + (index + 1));
  }
  StackFrame *GetFrameBase() {
    return (StackFrame *) GetBase();
  }

  static TaskStack *New(u_int size);
  static TaskStack *New() {
    return New(INITIAL_SIZE);
  }
  static TaskStack *FromWordDirect(word x) {
    DynamicBlock *b = DynamicBlock::FromWordDirect(x);
    return STATIC_CAST(TaskStack *, b);
  }

  TaskStack *Enlarge();
  void Purge();
  void Dump(u_int top);
};

#endif
