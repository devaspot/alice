//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2003
//
// Last Change:
//   $Date: 2003-06-15 13:54:28 $ by $Author: kornstae $
//   $Revision: 1.2 $
//

#ifndef __GENERIC__BROKER_HH__
#define __GENERIC__BROKER_HH__

#if defined(INTERFACE)
#pragma interface "generic/Broker.hh"
#endif

#include "adt/ChunkMap.hh"
#include "generic/UniqueString.hh"
#include "generic/Worker.hh"

class SeamDll Broker {
public:
  // Exceptions:
  static word BrokerError;

  static void Init();

  static void Start(String *languageId, int argc, char *argv[]);
  static Worker::Result Load(String *languageId, String *key = NULL);

  static void Register(String *name, word value);
  static word Lookup(String *name);
};

#endif
