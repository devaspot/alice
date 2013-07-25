//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//   Leif Kornstaedt, 2002
//
// Last Change:
//   $Date: 2003-06-25 15:08:33 $ by $Author: bruni $
//   $Revision: 1.9 $
//
#ifndef __GENERIC__PROFILER_HH__
#define __GENERIC__PROFILER_HH__

#if defined(INTERFACE)
#pragma interface "generic/Profiler.hh"
#endif

#include "store/Store.hh"

#if PROFILE

class ProfileEntry;
class StackFrame;
class ConcreteCode;
class String;

class SeamDll Profiler {
protected:
  static word table;
  static u_int heapUsage;
  static word sampleEntry;
  static double sampleTime;

  static ProfileEntry *GetEntry(StackFrame *frame);
  static ProfileEntry *GetEntry(ConcreteCode *concreteCode);
  static u_int GetHeapTotal();
public:
  // Profiler Static Constructor
  static void Init();

  static double SampleTime();
  static void SampleHeap(StackFrame *frame); // Scheduler::Run
  static void AddHeap(); // Scheduler::Run
  static void IncCalls(StackFrame *frame); // Scheduler::PushCall
  static void IncClosures(word cCode);  // Interpreter::Close
  static void DumpInfo();
};

#endif

#endif
