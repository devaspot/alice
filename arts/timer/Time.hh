//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2004
//
// Last Change:
//   $Date: 2004-01-14 08:08:23 $ by $Author: bruni $
//   $Revision: 1.1 $
//

#ifndef __GENERIC__TIME_HH_
#define __GENERIC__TIME_HH_

#if defined(INTERFACE)
#pragma interface "generic/Time.hh"
#endif

class SeamDll Time {
public:
  // Time Static Constructor
  static void Init();
  static double GetElapsedMicroseconds();
};

#endif
