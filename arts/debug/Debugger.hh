//
// Author:
//   Jens Regenberg <jens@ps.uni-sb.de>
//
// Copyright:
//   Jens Regenberg, 2002-2003
//
// Last Change:
//   $Date: 2003-07-23 10:43:44 $ by $Author: jens $
//   $Revision: 1.5 $
//

#if DEBUGGER
#ifndef __ALICE__DEBUGGER_HH__
#define __ALICE__DEBUGGER_HH__

#if defined(INTERFACE)
#pragma interface "generic/Debugger.hh"
#endif
#include "generic/RootSet.hh"

class Thread;
class SeamDll Debugger {
private:
  static word eventStream;
  static word breakPointList;

  static void GenerateMissingEvents();
public:
  static word GetEventStream();
  static bool IsBreakpoint(Thread *thread);

  static void Init();
  static void Detach(Thread *thread);
  static void SendEvent(word event);
  static void SingleStep(Thread *thread);
  static void Breakpoint(Thread *thread);
};

#endif
#endif
