//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//   Leif Konrstaedt, 2002-2003
//
// Last Change:
//   $Date: 2003-06-11 16:26:05 $ by $Author: kornstae $
//   $Revision: 1.12 $
//

#include "alice/Authoring.hh"

static inline s_int GetPlatform() {
#if defined(__CYGWIN32__) || defined(__MINGW32__) || defined(_MSC_VER)
  return Types::Config_WIN32;
#else
  return Types::Config_UNIX;
#endif
}

AliceDll word UnsafeConfig() {
  Record *record = Record::New(2);
  record->Init("platform", Store::IntToWord(GetPlatform()));
  record->Init("vm", String::New("seam")->ToWord());
  RETURN_STRUCTURE("UnsafeConfig$", record);
}
