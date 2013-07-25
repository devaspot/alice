//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2000-2002
//
// Last Change:
//   $Date: 2004-12-13 16:06:06 $ by $Author: tack $
//   $Revision: 1.10 $
//

#if defined(INTERFACE)
#pragma implementation "generic/RootSet.hh"
#endif

#include "adt/Queue.hh"
#include "generic/RootSet.hh"

class Element: private Block {
private:
  enum { POINTER_POS, VALUE_POS, SIZE };
public:
  using Block::ToWord;

  static Element *New(word *pointer) {
    Block *b = Store::AllocMutableBlock(ROOTSETELEMENT_LABEL, SIZE);
    b->InitArg(POINTER_POS, Store::UnmanagedPointerToWord(pointer));
    return STATIC_CAST(Element *, b);
  }
  static Element *FromWordDirect(word x) {
    Block *b = Store::DirectWordToBlock(x);
    Assert(b->GetLabel() == ROOTSETELEMENT_LABEL);
    return STATIC_CAST(Element *, b);
  }

  word *GetPointer() {
    return STATIC_CAST(word *, Store::DirectWordToUnmanagedPointer(GetArg(POINTER_POS)));
  }
  void PreGC() {
    ReplaceArg(VALUE_POS, *GetPointer());
  }
  void PostGC() {
    *GetPointer() = GetArg(VALUE_POS);
  }
};

//--** This should probably implement a real set instead of using Queue.
class Set: private Queue {
private:
  static const u_int initialSize = 8; //--** to be checked
public:
  using Queue::ToWord;

  static Set *New() {
    return STATIC_CAST(Set *, Queue::New(initialSize));
  }
  static Set *FromWordDirect(word x) {
    return STATIC_CAST(Set *, Queue::FromWordDirect(x));
  }

  void Add(word &root) {
    Enqueue(Element::New(&root)->ToWord());
  }
  void Remove(word &root) {
    for (u_int i = GetNumberOfElements(); i--; ) {
      Element *element = Element::FromWordDirect(GetNthElement(i));
      if (element->GetPointer() == &root) {
	Queue::RemoveNthElement(i);
  	break;
      }
    }
  }
  void PreGC() {
    Blank();
    for (u_int i = GetNumberOfElements(); i--; )
      Element::FromWordDirect(GetNthElement(i))->PreGC();
  }
  void PostGC() {
    for (u_int i = GetNumberOfElements(); i--; )
      Element::FromWordDirect(GetNthElement(i))->PostGC();
  }
};

static Set *set;

void RootSet::Init() {
  set = Set::New();
}

void RootSet::Add(word &root) {
  set->Add(root);
}

void RootSet::Remove(word &root) {
  set->Remove(root);
}

// Finalization needs access to root set variables (e.g. Gtk destroy events)
// Therefore, we need to delay finalization upon root set update.
void RootSet::DoGarbageCollection() {
  set->PreGC();
  word w = set->ToWord();
  Store::DoGCWithoutFinalize(w);
  set = Set::FromWordDirect(w);
  set->PostGC();
  Store::DoFinalize();
}
