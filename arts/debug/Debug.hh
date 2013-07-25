//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//   Leif Kornstaedt, 2002
//
// Last Change:
//   $Date: 2003-06-26 21:04:00 $ by $Author: bruni $
//   $Revision: 1.6 $
//

#ifndef __GENERIC__DEBUG_HH__
#define __GENERIC__DEBUG_HH__

#if defined(INTERFACE)
#pragma interface "generic/Debug.hh"
#endif

#include <cstdio>
#include "store/Store.hh"

class SeamDll Debug {
public:
  static u_int maxWidth;
  static u_int maxDepth;
  static void Dump(word x);
  static void DumpTo(FILE *file, word x);
};

#endif
