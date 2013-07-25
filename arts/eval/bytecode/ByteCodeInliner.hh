//
// Author:
//   Christian Mueller <cmueller@ps.uni-sb.de>
//
// Copyright:
//   Christian Mueller, 2005
//
// Last Change:
//   $Date: 2005-11-22 16:46:58 $ by $Author: cmueller $
//   $Revision: 1.7 $
//

#ifndef __ALICE_BYTECODE_INLINER_HH__
#define __ALICE_BYTECODE_INLINER_HH__

#if defined(INTERFACE)
#pragma interface "alice/ByteCodeInliner.hh"
#endif

#include "alice/Authoring.hh"
#include "alice/AbstractCode.hh"

class LazyCompileClosure;
class InlineAnalyser;

//#define INLINE_LIMIT 5 moved to ByteCodeInliner.cc

class InlineInfo : private Tuple {
private:
  enum { 
    INLINE_MAP_POS, LIVENESS_POS, ALIASES_POS, NLOCALS_POS, NNODES_POS, 
    SIZE 
  };
public:
  using Tuple::ToWord;

  static InlineInfo *New(Map *inlineMap, Vector *liveness, Array *aliases,
			 u_int nLocals, u_int nNodes) {
    Tuple *tup = Tuple::New(SIZE); 
    tup->Init(INLINE_MAP_POS,inlineMap->ToWord());
    tup->Init(LIVENESS_POS,liveness->ToWord());
    tup->Init(ALIASES_POS,aliases->ToWord());
    tup->Init(NLOCALS_POS,Store::IntToWord(nLocals));
    tup->Init(NNODES_POS,Store::IntToWord(nNodes));
    return (InlineInfo *) tup;
  }
  Map *GetInlineMap() { 
    return Map::FromWordDirect(Tuple::Sel(INLINE_MAP_POS)); 
  }
  Vector *GetLiveness() { 
    return Vector::FromWordDirect(Tuple::Sel(LIVENESS_POS)); 
  }
  Array *GetAliases() {
    return Array::FromWordDirect(Tuple::Sel(ALIASES_POS));
  }
  u_int GetNLocals() { 
    return Store::DirectWordToInt(Tuple::Sel(NLOCALS_POS)); 
  }
  u_int GetNNodes() { 
    return Store::DirectWordToInt(Tuple::Sel(NNODES_POS)); 
  }

  static InlineInfo *FromWord(word info) {
    return STATIC_CAST(InlineInfo *, Tuple::FromWord(info));
  }
  static InlineInfo *FromWordDirect(word info) {
    return STATIC_CAST(InlineInfo *, Tuple::FromWordDirect(info));
  }
};

class ByteCodeInliner {
private:
  // The driver implements a depth-first search from the root and applies 
  // the analysers to every node exactly ones
  static void Driver(TagVal *root, InlineAnalyser *analyser); 
  static Map *inlineCandidates;
public:

  // Checks if a function is inlinable
  // At the moment we use a very simple heuristic to decide whether we 
  // inline a function or not:
  // We impose a very ad-hoc size level, which is based on the number
  // of nodes inside an abstract code function. More profiling should
  // make this size barrier less ad-hoc.
  static InlineInfo *AnalyseInlining(TagVal *abstractCode);

  // This function must be called in the ByteCodeJitter to indicate the start
  // of the analysis. A new map is created which records the processed 
  // functions.
  static void ResetRoot() { inlineCandidates = Map::New(20); }
};

#endif // __ALICE_BYTECODE_INLINER_HH__
