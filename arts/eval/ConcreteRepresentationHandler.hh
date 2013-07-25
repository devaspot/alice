//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2000
//   Leif Kornstaedt, 2000
//
// Last Change:
//   $Date: 2003-06-11 16:25:03 $ by $Author: kornstae $
//   $Revision: 1.7 $
//

#ifndef __GENERIC__CONCRETE_REPRESENTATION_HANDLER_HH__
#define __GENERIC__CONCRETE_REPRESENTATION_HANDLER_HH__

#include "Base.hh"

class Block;
class Transform;
class ConcreteRepresentation;

class SeamDll ConcreteRepresentationHandler {
public:
  // returns INVALID_POINTER if there is none
  virtual Transform *GetAbstractRepresentation(ConcreteRepresentation *) = 0;
};

#endif
