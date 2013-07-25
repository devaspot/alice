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
//   $Date: 2004-01-14 08:08:23 $ by $Author: bruni $
//   $Revision: 1.15 $
//

#if defined(INTERFACE)
#pragma implementation "generic/Profiler.hh"
#endif

#if PROFILE
#include "store/Map.hh"
#include "generic/Profiler.hh"
#include "generic/RootSet.hh"
#include "generic/Worker.hh"
#include "generic/StackFrame.hh"
#include "generic/String.hh"
#include "generic/ConcreteCode.hh"
#include "generic/Tuple.hh"
#include "generic/Scheduler.hh"
#include "generic/Time.hh"

class ProfileEntry : private Tuple {
protected:
  enum {
    NAME_POS, NB_CALLS_POS, NB_HEAP_POS, NB_CLOSURES_POS,
    NB_RUNS_POS, TIME_POS, SIZE
  };

  void Modify(u_int index, u_int value) {
    u_int v = Store::DirectWordToInt(Sel(index));
    Init(index, Store::IntToWord(v + value));
  }
public:
  using Tuple::ToWord;
  // ProfileEntry Accessors
  void AddHeap(u_int value) {
    Modify(NB_HEAP_POS, value);
  }
  void IncCalls() {
    Modify(NB_CALLS_POS, 1);
  }
  void IncClosures() {
    Modify(NB_CLOSURES_POS, 1);
  }
  void IncRuns() {
    Modify(NB_RUNS_POS, 1);
  }
  void IncTime(u_int t) {
    Modify(TIME_POS, t);
  }
  // ProfileEntry Concstructor
  static ProfileEntry *New(String *name) {
    Tuple *entry = Tuple::New(SIZE);
    entry->Init(NAME_POS, name->ToWord());
    entry->Init(NB_CALLS_POS, Store::IntToWord(0));
    entry->Init(NB_HEAP_POS, Store::IntToWord(0));
    entry->Init(NB_CLOSURES_POS, Store::IntToWord(0));
    entry->Init(NB_RUNS_POS, Store::IntToWord(0));
    entry->Init(TIME_POS, Store::IntToWord(0));
    return STATIC_CAST(ProfileEntry *, entry);
  }
  // ProfileEntry untagging
  static ProfileEntry *FromWordDirect(word x) {
    Tuple *entry = Tuple::FromWordDirect(x);
    entry->AssertWidth(SIZE);
    return STATIC_CAST(ProfileEntry *, entry);
  }
};

//
// Profiler Methods
//
word Profiler::table;
u_int Profiler::heapUsage;
word Profiler::sampleEntry;
double Profiler::sampleTime;

static double startTime;

double Profiler::SampleTime() {
  return Time::GetElapsedMicroseconds();
}

void Profiler::Init() {
  table = Map::New(256)->ToWord(); // to be done
  RootSet::Add(table);
  sampleEntry = Store::IntToWord(0);
  RootSet::Add(sampleEntry);
  InitTime();
  startTime = SampleTime();
}

ProfileEntry *Profiler::GetEntry(StackFrame *frame) {
  Worker *worker = frame->GetWorker();
  word key = worker->GetProfileKey(frame);
  Map *t = Map::FromWordDirect(table);
  if (t->IsMember(key))
    return ProfileEntry::FromWordDirect(t->Get(key));
  else {
    String *name = worker->GetProfileName(frame);
    ProfileEntry *entry = ProfileEntry::New(name);
    t->Put(key, entry->ToWord());
    return entry;
  }
}

ProfileEntry *Profiler::GetEntry(ConcreteCode *concreteCode) {
  Interpreter *interpreter = concreteCode->GetInterpreter();
  word key = interpreter->GetProfileKey(concreteCode);
  Map *t = Map::FromWordDirect(table);
  if (t->IsMember(key))
    return ProfileEntry::FromWordDirect(t->Get(key));
  else {
    String *name = interpreter->GetProfileName(concreteCode);
    ProfileEntry *entry = ProfileEntry::New(name);
    t->Put(key, entry->ToWord());
    return entry;
  }
}

u_int Profiler::GetHeapTotal() {
  u_int heapTotal = 0;
  for (u_int i = STORE_GENERATION_NUM - 1; i--;)
    heapTotal += Store::roots[i].GetExactSize();
  return heapTotal;
}

void Profiler::SampleHeap(StackFrame *frame) {
  sampleTime = SampleTime();
  Worker *worker = frame->GetWorker();
  word key       = worker->GetProfileKey(frame);
  Map *t         = Map::FromWordDirect(table);
  if (t->IsMember(key))
    sampleEntry = t->Get(key);
  else {
    ProfileEntry *entry = ProfileEntry::New(worker->GetProfileName(frame));
    t->Put(key, entry->ToWord());
    sampleEntry = entry->ToWord();
  }
  heapUsage = GetHeapTotal();
}

void Profiler::AddHeap() {
  double curTime = SampleTime();
  u_int heapTotal = GetHeapTotal();
  ProfileEntry *entry = ProfileEntry::FromWordDirect(sampleEntry);
  entry->AddHeap(heapTotal - heapUsage);
  entry->IncRuns();
  entry->IncTime(STATIC_CAST(u_int, curTime - sampleTime));
}

void Profiler::IncCalls(StackFrame *frame) {
  ProfileEntry *entry = GetEntry(frame);
  entry->IncCalls();
}

void Profiler::IncClosures(word cCode) {
  ConcreteCode *concreteCode = ConcreteCode::FromWord(cCode);
  if (concreteCode != INVALID_POINTER)
    GetEntry(concreteCode)->IncClosures();
}

static FILE *logFile;
static u_int totalLogTime = 0;

static void PrintInfo(word /*key*/, word value) {
  Tuple *entry   = Tuple::FromWordDirect(value);
  String *name   = String::FromWordDirect(entry->Sel(0));
  u_int calls    = Store::DirectWordToInt(entry->Sel(1));
  u_int heap     = Store::DirectWordToInt(entry->Sel(2));
  u_int closures = Store::DirectWordToInt(entry->Sel(3));
  u_int runs     = Store::DirectWordToInt(entry->Sel(4));
  u_int runTime  = Store::DirectWordToInt(entry->Sel(5));
  totalLogTime += runTime;
  char *s = name->ExportC();
  for (char *t = s; *t; t++)
    if (*t == ',') *t = ';';
  std::fprintf(logFile, "%d, %d, %d, %d, %d, %.2f, %s\n",
	       runs, calls, runTime, closures, heap,
	       runs? STATIC_CAST(float, heap) / runs: 0.0,
	       s);
}

void Profiler::DumpInfo() {
  double endTime = SampleTime();
  Map *t = Map::FromWordDirect(table);
  if ((logFile = std::fopen("profile_log.txt", "w")) == NULL)
    Error("Profiler:DumpInfo: unable to open log file");
  t->Apply((item_apply) PrintInfo);
  std::fprintf(logFile, "0, 0, 0, 0, 0, 0.00, total %d, acc %d, gc %d\n",
	       STATIC_CAST(u_int, endTime - startTime),
	       totalLogTime,
	       STATIC_CAST(u_int, Scheduler::gcTime));
  std::fclose(logFile);
}

#endif
