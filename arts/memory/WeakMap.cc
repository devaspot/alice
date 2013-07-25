//
// Author:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//
// Last Change:
//   $Date: 2005-07-08 14:24:44 $ by $Author: tack $
//   $Revision: 1.4 $
//

#if defined(INTERFACE)
#pragma implementation "store/WeakMap.hh"
#endif

#include "store/WeakMap.hh"
#include "store/BaseMap.cc"

template class BaseMap<TokenKey>;

void Finalization::Finalize(word value) {}
