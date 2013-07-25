//
// Authors:
//   Jens Regenberg <jens@ps.uni-sb.de>
//
// Copyright:
//   Jens Regenberg, 2002-2003
//
// Last Change:
//   $Date: 2003-11-12 08:55:05 $ by $Author: jens $
//   $Revision: 1.7 $
//

#if DEBUGGER
#if defined(INTERFACE)
#pragma implementation "generic/DebugWorker.hh"
#endif

#include <cstdio>
#include "generic/Backtrace.hh"
#include "generic/Scheduler.hh"
#include "generic/RootSet.hh"
#include "generic/DebugWorker.hh"
#include "generic/DebugFrame.hh"
#include "generic/StackFrame.hh"

//
// Debug Interpreter Functions
//

DebugWorker *DebugWorker::self;

void DebugWorker::PushFrame(word event) {
  DebugFrame::New(self, event);
}

u_int DebugWorker::GetFrameSize(StackFrame *sFrame) {
  DebugFrame *debugFrame = STATIC_CAST(DebugFrame *, sFrame);
  Assert(sFrame->GetWorker() == this);
  return debugFrame->GetSize();
}

Worker::Result DebugWorker::Run(StackFrame *) {
  Error("DebugWorker::Run: tried to run debug frame");
}

Worker::Result DebugWorker::Handle(word) {
  return Worker::RAISE;
}

const char *DebugWorker::Identify() {
  return "DebugWorker";
}

void DebugWorker::DumpFrame(StackFrame *) {
  std::fprintf(stderr, "Debuggger\n");
}

word DebugWorker::GetEvent(StackFrame *sFrame) {
  DebugFrame *debugFrame = STATIC_CAST(DebugFrame *, sFrame);
  Assert(debugFrame->GetWorker() == self);
  return debugFrame->GetEvent();
}
#endif
