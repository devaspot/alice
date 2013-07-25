//
// Author:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//
// Last Change:
//   $Date: 2004-10-15 13:04:55 $ by $Author: bruni $
//   $Revision: 1.5 $
//
#ifndef __ADT__INT_MAP_HH__
#define __ADT__INT_MAP_HH__

#if defined(INTERFACE)
#pragma interface "adt/IntMap.hh"
#endif

#include "store/BaseMap.hh"

class SeamDll IntKey {
public:
  static u_int Hash(word key, u_int size) {
    Assert(size > 0);
    s_int i = Store::DirectWordToInt(key);
    return (i % size);
  }
  static bool Equals(word a, word b) {
    return a == b;
  }
};

class SeamDll IntMap: public BaseMap<IntKey> {
public:
  static IntMap *New(u_int size) {
    BaseMap<IntKey> *map = BaseMap<IntKey>::New(INT_MAP_LABEL, size);
    return STATIC_CAST(IntMap *, map);
  }
  static IntMap *FromWord(word x) {
    Block *map = Store::WordToBlock(x);
    Assert(map == INVALID_POINTER || map->GetLabel() == INT_MAP_LABEL);
    return STATIC_CAST(IntMap *, map);
  }
  static IntMap *FromWordDirect(word x) {
    Block *map = Store::DirectWordToBlock(x);
    Assert(map->GetLabel() == INT_MAP_LABEL);
    return STATIC_CAST(IntMap *, map);
  }
};

#endif
