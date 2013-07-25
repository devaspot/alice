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
//   $Date: 2004-11-15 13:26:12 $ by $Author: tack $
//   $Revision: 1.4 $
//

#if defined(INTERFACE)
#pragma implementation "alice/AbstractCodeFrame.hh"
#endif

#ifdef LIVENESS_DEBUG
#include "alice/AliceConcreteCode.hh"
#endif

#include "alice/AbstractCodeFrame.hh"


#ifdef DEBUG_CHECK
static word dead;
#endif

#ifdef LIVENESS_DEBUG
static const BlockLabel DEAD_LABEL = HASHNODE_LABEL;

static void DisassembleAlice(Closure *closure) {
  AliceConcreteCode *concreteCode =
    AliceConcreteCode::FromWord(closure->GetConcreteCode());
  concreteCode->Disassemble(stderr);
}
#endif

// Environment Accessors
void AbstractCodeFrame::Environment::Add(word id, word value) {
  Update(Store::WordToInt(id), value);
}

#if DEBUGGER
word AbstractCodeFrame::Environment::LookupUnchecked(word id) {
  return Sub(Store::WordToInt(id));
}
#endif

word AbstractCodeFrame::Environment::Lookup(word id) {
  word value = Sub(Store::WordToInt(id));
#ifdef LIVENESS_DEBUG
  ::Block *p = Store::WordToBlock(value);
  if (p != INVALID_POINTER) {
    if (p->GetLabel() == DEAD_LABEL) {
      std::fprintf(stderr, "### USING KILLED VALUE ###\n");
      std::fprintf(stderr, "### killed as Local(%d)\n",
		   Store::DirectWordToInt(p->GetArg(0)));
      std::fprintf(stderr, "### value before kill:\n");
      Debug::Dump(p->GetArg(1));
      std::fprintf(stderr, "### killed at pc=%p in function:\n",
		   TagVal::FromWordDirect(p->GetArg(2)));
      DisassembleAlice(Closure::FromWordDirect(p->GetArg(3)));
      return p->GetArg(1);
    }
  }
#else
  Assert(value != dead);
#endif
  return value;
}
#ifdef LIVENESS_DEBUG
void AbstractCodeFrame::Environment::Kill(word id, TagVal *pc, 
					  Closure *globalEnv) {
  ::Block *dead = Store::AllocBlock(DEAD_LABEL, 4);
  dead->InitArg(0, id);
  dead->InitArg(1, Sub(Store::WordToInt(id)));
  dead->InitArg(2, pc->ToWord());
  dead->InitArg(3, globalEnv->ToWord());
  Update(Store::WordToInt(id), dead->ToWord());
}
#else
void AbstractCodeFrame::Environment::Kill(word id, TagVal *, Closure *) {
#ifdef DEBUG_CHECK
  Update(Store::WordToInt(id), dead);
#else
  Update(Store::WordToInt(id), Store::IntToWord(0));
#endif
}
#endif
// Environment Constructor
AbstractCodeFrame::Environment *
AbstractCodeFrame::Environment::New(u_int size) {
  Array *array = Array::New(size);
  for(int index = size; index--; ) {
    array->Init(index, AliceLanguageLayer::undefinedValue);
  }
  return STATIC_CAST(Environment *, array);
}
// Environment Untagging
AbstractCodeFrame::Environment *
AbstractCodeFrame::Environment::FromWordDirect(word x) {
  return STATIC_CAST(Environment *, Array::FromWordDirect(x));
}

#ifdef DEBUG_CHECK
void AbstractCodeFrame::Init() {
  dead = String::New("UNINITIALIZED OR DEAD")->ToWord();
  RootSet::Add(dead);
}
#endif
