//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//   Leif Kornstaedt, 2002-2003
//
// Last Change:
//   $Date: 2003-06-11 16:26:05 $ by $Author: kornstae $
//   $Revision: 1.9 $
//

#include "alice/Authoring.hh"

DEFINE0(UnsafeCommandLine_name) {
  RETURN(AliceLanguageLayer::rootUrl);
} END

DEFINE0(UnsafeCommandLine_arguments) {
  RETURN(AliceLanguageLayer::commandLineArguments);
} END

AliceDll word UnsafeCommandLine() {
  Record *record = Record::New(2);
  INIT_STRUCTURE(record, "UnsafeCommandLine", "name",
		 UnsafeCommandLine_name, 0);
  INIT_STRUCTURE(record, "UnsafeCommandLine", "arguments",
		 UnsafeCommandLine_arguments, 0);
  RETURN_STRUCTURE("UnsafeCommandLine$", record);
}
