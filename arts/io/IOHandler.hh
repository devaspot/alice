//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2002
//
// Last Change:
//   $Date: 2005-04-04 17:09:28 $ by $Author: rossberg $
//   $Revision: 1.11 $
//

#ifndef __GENERIC__IO_HANDLER_HH__
#define __GENERIC__IO_HANDLER_HH__

#if defined(INTERFACE)
#pragma interface "generic/IOHandler.hh"
#endif

#include "Base.hh"

class Future;

class SeamDll IOHandler {
protected:
  static int defaultFD;
public:
  static void Init();
  static void Poll();
  static void Block();
  static void Purge();

  static bool IsReadable(int fd);
  static bool IsWritable(int fd);
  // These return INVALID_POINTER if the fd is already readable/writable:
  static Future *WaitReadable(int fd);
  static Future *WaitWritable(int fd);

  static void Close(int fd);

  static int SocketPair(int type, int *sv);
};

#endif
