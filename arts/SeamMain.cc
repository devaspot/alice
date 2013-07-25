//
// Author:
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Leif Kornstaedt, 2003
//
// Last Change:
//   $Date: 2003-06-13 18:01:54 $ by $Author: kornstae $
//   $Revision: 1.2 $
//

#include <cstdio>
#include "Seam.hh"

int main(int argc, char *argv[]) {
  if (argc < 2) {
    std::fprintf(stderr, "usage: %s <languagelayer> <args...>\n", argv[0]);
    return 2;
  }
  InitSeam();

  String *languageId = String::New(argv[1]);
  argc--; argv++;
  Broker::Start(languageId, argc, argv);
  return Scheduler::Run();
}
