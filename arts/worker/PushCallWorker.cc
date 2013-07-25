//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//
// Last Change:
//   $Date: 2003-09-26 09:20:54 $ by $Author: bruni $
//   $Revision: 1.12 $
//

#if defined(INTERFACE)
#pragma implementation "generic/PushCallWorker.hh"
#endif

#include <cstdio>
#include "generic/Scheduler.hh"
#include "generic/StackFrame.hh"
#include "generic/PushCallWorker.hh"

// PushCall Frame
class PushCallFrame: private StackFrame {
private:
  enum { CLOSURE_POS, SIZE };
public:
  // PushCallFrame Constructor
  static PushCallFrame *New(Worker *worker, word closure) {
    NEW_STACK_FRAME(frame, worker, SIZE);
    frame->InitArg(CLOSURE_POS, closure);
    return STATIC_CAST(PushCallFrame *, frame);
  }
  static PushCallFrame *New(Thread *thread, Worker *worker, word closure) {
    NEW_THREAD_STACK_FRAME(frame, thread, worker, SIZE);
    frame->InitArg(CLOSURE_POS, closure);
    return STATIC_CAST(PushCallFrame *, frame);
  }
  // PushCallFrame Accessors
  u_int GetSize() {
    return StackFrame::GetSize() + SIZE;
  }
  word GetClosure() {
    return StackFrame::GetArg(CLOSURE_POS);
  }
};

//
// PushCallWorker Functions
//
PushCallWorker *PushCallWorker::self;

void PushCallWorker::PushFrame(word closure) {
  PushCallFrame::New(self, closure);
}

void PushCallWorker::PushFrame(Thread *thread, word closure) {
  PushCallFrame::New(thread, self, closure);
}

u_int PushCallWorker::GetFrameSize(StackFrame *sFrame) {
  PushCallFrame *frame = STATIC_CAST(PushCallFrame *, sFrame);
  Assert(sFrame->GetWorker() == this);
  return frame->GetSize();
}

Worker::Result PushCallWorker::Run(StackFrame *sFrame) {
  PushCallFrame *frame = STATIC_CAST(PushCallFrame *, sFrame);
  Assert(sFrame->GetWorker() == this);
  word wClosure = frame->GetClosure();
  Scheduler::PopFrame(frame->GetSize());
  return Scheduler::PushCall(wClosure);
}

const char *PushCallWorker::Identify() {
  return "PushCallWorker";
}

void PushCallWorker::DumpFrame(StackFrame *) {
  std::fprintf(stderr, "Push Call\n");
}
