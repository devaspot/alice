//
// Author:
//   Jens Regenberg <jens@ps.uni-sb.de>
//
// Copyright:
//   Jens Regenberg, 2002-2003
//
// Last Change:
//   $Date: 2003-11-12 08:55:05 $ by $Author: jens $
//   $Revision: 1.9 $
//

#if DEBUGGER
#ifndef __GENERIC__DEBUGGER_EVENT_HH__
#define __GENERIC__DEBUGGER_EVENT_HH__

#if defined(INTERFACE)
#pragma interface "generic/DebuggerEvent.hh"
#endif

#include "store/Store.hh"

// Known Event Types
typedef enum {
  MIN_EVENT_LABEL,
  ALICE_EVENT_LABEL,
  GENERIC_EVENT_LABEL,
  MAX_EVENT_LABEL
} EventLabel;


class SeamDll EventAccessor {
public:
  virtual ~EventAccessor();
  virtual EventLabel GetLabel() = 0;
  virtual word GetEvent(word event) = 0;
};

class SeamDll DebuggerEvent : public Block {
protected:
  enum { ACCESSOR_POS, EVENT_POS, BASE_SIZE };
public:
  using Block::ToWord;

  // DebuggerEvent Constructor
  static DebuggerEvent *New(EventLabel l, EventAccessor *accessor, word event) {
    Block *b = Store::AllocBlock((BlockLabel) l, BASE_SIZE);
    b->InitArg(ACCESSOR_POS, Store::UnmanagedPointerToWord(accessor));
    b->InitArg(EVENT_POS,    event);
    return STATIC_CAST(DebuggerEvent *, b);
  }

  EventAccessor *GetAccessor() {
    return STATIC_CAST(EventAccessor *, 
      (Store::WordToUnmanagedPointer(Block::GetArg(ACCESSOR_POS))));
  }

  word GetEvent() {
    return GetAccessor()->GetEvent(Block::GetArg(EVENT_POS));
  }

  static DebuggerEvent *FromWord(word x) {
    Block *b = Store::WordToBlock(x);
    Assert(b == INVALID_POINTER || 
	   (b->GetLabel() > (BlockLabel) MIN_EVENT_LABEL 
	    && b->GetLabel() < (BlockLabel) MAX_EVENT_LABEL));
  return STATIC_CAST(DebuggerEvent *, b);
  }

  static DebuggerEvent *FromWordDirect(word x) {
    Block *b = Store::DirectWordToBlock(x);
    Assert(b->GetLabel() > (BlockLabel) MIN_EVENT_LABEL 
	   && b->GetLabel() < (BlockLabel)MAX_EVENT_LABEL);
    return STATIC_CAST(DebuggerEvent *, b);
  }
};
#endif
#endif
