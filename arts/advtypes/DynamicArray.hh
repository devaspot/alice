//
// Author:
//   Guido Tack <tack@ps.uni-sb.de>
// 
// Copyright:
//   Guido Tack, 2002
// 
// Last change:
//   $Date: 2005-02-15 10:08:04 $ by $Author: tack $
//   $Revision: 1.2 $
// 

#ifndef __ADT__DYNAMICARRAY_HH
#define __ADT__DYNAMICARRAY_HH

#if defined(INTERFACE)
#pragma interface "adt/DynamicArray.hh"
#endif

#include "store/Store.hh"
#include "generic/RootSet.hh"

// Provides an unbounded array with dynamic resizing

class DynamicArray : private Block {
protected:
  static const BlockLabel DYNARRAY_LABEL = MIN_DATA_LABEL;
  enum { SIZE_POS, INIT_ELEM_POS, ARRAY_POS, SIZE };


  void EnlargeArray(int upTo=0);
  
public:
  using Block::ToWord;

  static word INVALID_ARRAY_ELEM;

  static void Init();

  static DynamicArray *New(int initialSize);
  static DynamicArray *NewInit(int initialSize, word initialElement);
  static DynamicArray *FromWord(word x);
  static DynamicArray *FromWordDirect(word x);
  u_int GetLength();
  void Init(u_int index, word value);
  void Update(u_int index, word value);
  word Sub(u_int index);
  void Clear();
};

#endif
