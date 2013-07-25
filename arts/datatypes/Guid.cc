//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2002
//
// Last Change:
//   $Date: 2003-09-26 09:23:56 $ by $Author: bruni $
//   $Revision: 1.12 $
//

#if defined(INTERFACE)
#pragma implementation "alice/Guid.hh"
#endif

#include <cstring>
#include <cstdlib>
#if defined(__MINGW32__) || defined(_MSC_VER)
#include <windows.h>
#include <process.h>
#else
#include <sys/times.h>
#include <unistd.h>
#endif
#include <time.h>

#include "alice/Guid.hh"

word Guid::vmGuid;

void Guid::Init() {
  srand(0);
  vmGuid = Guid::New()->ToWord();
  RootSet::Add(vmGuid);
}

#if defined(__MINGW32__) || defined(_MSC_VER)
# ifdef __GNUC__
typedef long long verylong;
# else
typedef long verylong;
# endif

static int GetProcessId() {
  return GetCurrentProcessId();
}

static verylong GetTimeStamp() {
  SYSTEMTIME st;
  GetSystemTime(&st);
  FILETIME ft;
  SystemTimeToFileTime(&st, &ft);
  verylong x1 = ((verylong) (u_int) ft.dwHighDateTime) << 32;
  verylong x2 = x1 + (u_int) ft.dwLowDateTime;
  return x2 / 10000;
}
#else
static int GetProcessId() {
  return getpid();
}

static int GetTimeStamp() {
  struct tms buffer;
  int t = times(&buffer);
  double t2 = t * 1000.0 / STATIC_CAST(double, sysconf(_SC_CLK_TCK));
  return STATIC_CAST(int, t2);
}
#endif

struct GuidComponents {
  int pid, time, stamp, rand;
};

Guid *Guid::New() {
  GuidComponents gcs;
  gcs.pid = STATIC_CAST(int, GetProcessId());
  gcs.time = STATIC_CAST(int, time(0));
  gcs.stamp = GetTimeStamp();
  gcs.rand = rand();
  return STATIC_CAST(Guid *, String::New((char *) &gcs, sizeof(gcs)));
}

int Guid::Compare(Guid *guid1, Guid *guid2) {
  u_int size1 = guid1->GetSize();
  u_int size2 = guid2->GetSize();
  if (size1 != size2)
    return size1 < size2? -1: 1;
  return std::memcmp(guid1->GetValue(), guid2->GetValue(), size1);
}
