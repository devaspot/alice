//
// Author:
//   Guido Tack <tack@ps.uni-sb.de>
//
// Copyright:
//   Guido Tack, 2003
//
// Last Change:
//   $Date: 2006-05-30 08:33:09 $ by $Author: tack $
//   $Revision: 1.7 $
//

#ifndef __GENERIC__DLLLOADER_HH__
#define __GENERIC__DLLLOADER_HH__

#if defined(INTERFACE)
#pragma interface "generic/DllLoader.hh"
#endif

#if HAVE_LOADLIBRARY
#include <windows.h>
#elif HAVE_LIBLTDL
#include "libltdl/ltdl.h"
#else
#error "No DLL support"
#endif

#include "generic/String.hh"

class SeamDll DllLoader {
public:
#if HAVE_LOADLIBRARY
typedef HMODULE libhandle;
#elif HAVE_LIBLTDL
typedef lt_dlhandle libhandle;
#endif

  static void Init();
  static libhandle OpenLibrary(String *filename);
  static void CloseLibrary(libhandle handle);
  static void *GetSymbol(libhandle libraryHandle,
			 String *symbolName);
  static String *GetLastError();

};

#endif
