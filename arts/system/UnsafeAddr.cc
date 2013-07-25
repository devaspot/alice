//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2002-2003
//
// Last Change:
//   $Date: 2003-06-11 16:26:05 $ by $Author: kornstae $
//   $Revision: 1.6 $
//

#include "alice/Authoring.hh"

DEFINE1(UnsafeAddr_addr) {
  Block *b = Store::WordToBlock(x0);
  if (b != INVALID_POINTER)
    RETURN(Store::UnmanagedPointerToWord(b));
  Transient *t = Store::WordToTransient(x0);
  if (t != INVALID_POINTER)
    RETURN(Store::UnmanagedPointerToWord(t));
  RETURN_INT(Store::WordToInt(x0));
} END

AliceDll word UnsafeAddr() {
  Record *record = Record::New(1);
  INIT_STRUCTURE(record, "UnsafeAddr", "addr",
		 UnsafeAddr_addr, 1);
  return record->ToWord();
}
