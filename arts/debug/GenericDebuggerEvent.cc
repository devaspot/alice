//
// Author:
//   Jens Regenberg <jens@ps.uni-sb.de>
//
// Copyright:
//   Jens Regenberg, 2002-2003
//
// Last Change:
//   $Date: 2004-02-12 12:08:33 $ by $Author: jens $
//   $Revision: 1.5 $
//

#if DEBUGGER
#if defined(INTERFACE)
#pragma implementation "generic/GenericDebuggerEvent.hh"
#endif

#include "generic/GenericDebuggerEvent.hh"

GenericEventAccessor *GenericEventAccessor::self;

GenericEventAccessor::GenericEventAccessor() {
  return;
}

GenericDebuggerEvent *GenericDebuggerEvent::FromWord(word w) {
  Block *b = Store::WordToBlock(w);
  Assert(b == INVALID_POINTER || b->GetLabel() == (BlockLabel) GENERIC_EVENT_LABEL);
  return STATIC_CAST(GenericDebuggerEvent *, b);
}

GenericDebuggerEvent *GenericDebuggerEvent::FromWordDirect(word w) {
  Block *b = Store::DirectWordToBlock(w);
  Assert(b->GetLabel() == (BlockLabel) GENERIC_EVENT_LABEL);
  return STATIC_CAST(GenericDebuggerEvent *, b);
}
#endif
