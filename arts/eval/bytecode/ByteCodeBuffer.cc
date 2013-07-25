//
// Author:
//   Christian Mueller <cmueller@ps.uni-sb.de>
//
// Copyright:
//   Christian Mueller, 2005
//
// Last Change:
//   $Date: 2005-08-31 12:13:55 $ by $Author: cmueller $
//   $Revision: 1.2 $
//

#if defined(INTERFACE)
#pragma implementation "alice/ByteCodeBuffer.hh"
#endif

#include "alice/ByteCodeBuffer.hh"

CodeSlot *WriteBuffer::codeBuf = NULL;
u_int WriteBuffer::size = 0;
u_int WriteBuffer::top = 0;
