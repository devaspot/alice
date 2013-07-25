//
// Author:
//   Jens Regenberg <jens@ps.uni-sb.de>
//
// Copyright:
//   Jens Regenberg, 2000-2002
//
// Last Change:
//   $Date: 2004-02-12 12:07:52 $ by $Author: jens $
//   $Revision: 1.4 $
//

#if DEBUGGER
#if defined(INTERFACE)
#pragma implementation "alice/AliceDebuggerEvent.hh"
#endif

#include "alice/AliceDebuggerEvent.hh"

AliceEventAccessor *AliceEventAccessor::self;
AliceEventAccessor::AliceEventAccessor() {
  return;
}
#endif
