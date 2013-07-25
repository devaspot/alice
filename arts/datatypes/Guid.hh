//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2002
//
// Last Change:
//   $Date: 2006-06-22 09:02:11 $ by $Author: tack $
//   $Revision: 1.9 $
//

#ifndef __ALICE__GUID__
#define __ALICE__GUID__

#if defined(INTERFACE)
#pragma interface "alice/Guid.hh"
#endif

#include "alice/Authoring.hh"

class AliceDll Guid: private String {
public:
  using String::ToWord;
  using String::Hash;

  static word vmGuid;
  static void Init();

  static Guid *New();
  static Guid *FromWord(word x) {
    return STATIC_CAST(Guid *, String::FromWord(x));
  }
  static Guid *FromWordDirect(word x) {
    return STATIC_CAST(Guid *, String::FromWordDirect(x));
  }

  static int Compare(Guid *guid1, Guid *guid2);
};

#endif
