//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2002-2003
//
// Last Change:
//   $Date: 2003-06-19 14:09:07 $ by $Author: kornstae $
//   $Revision: 1.13 $
//

#ifndef __ALICE_HH__
#define __ALICE_HH__

#define ALICE_FOREIGN

#include "Seam.hh"
#include "alice/Base.hh"
#include "alice/Guid.hh"
#include "alice/Data.hh"
#include "alice/Types.hh"
#include "alice/AbstractCode.hh"
#include "alice/AbstractCodeInterpreter.hh"
#include "alice/AliceConcreteCode.hh"
#include "alice/NativeCodeInterpreter.hh"
#include "alice/NativeConcreteCode.hh"
#include "alice/NativeCodeJitter.hh"
#include "alice/PrimitiveTable.hh"
#include "alice/AliceLanguageLayer.hh"
#include "alice/Authoring.hh"
#include "alice/BootLinker.hh"

// These must be extern "C" because the symbols are accessed
// via GetProcAddress/dlsym.  We cannot use the AliceDll macro
// because it would expand to __declspec(dllexport) here.
#if HAVE_DLLS
extern "C" __declspec(dllexport) word InitComponent();
#else
extern "C" word InitComponent();
#endif

#endif
