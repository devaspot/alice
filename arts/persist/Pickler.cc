//
// Authors:
//   Thorsten Brunklaus <brunklaus@ps.uni-sb.de>
//   Leif Kornstaedt <kornstae@ps.uni-sb.de>
//   Guido Tack <tack@ps.uni-sb.de>
//
// Copyright:
//   Thorsten Brunklaus, 2002
//   Leif Kornstaedt, 2002
//   Guido Tack, 2003
//
// Last Change:
//   $Date: 2006-06-22 09:02:37 $ by $Author: tack $
//   $Revision: 1.57 $
//

#if defined(INTERFACE)
#pragma implementation "generic/Pickler.hh"
#endif

#include <cstdio>
#include <cstdlib>
#include "generic/ZLib.hh"
#include "store/Map.hh"
#include "adt/Stack.hh"
#include "generic/RootSet.hh"
#include "generic/FinalizationSet.hh"
#include "generic/ConcreteCode.hh"
#include "generic/Backtrace.hh"
#include "generic/Transients.hh"
#include "generic/Worker.hh"
#include "generic/Scheduler.hh"
#include "generic/Transform.hh"
#include "generic/Pickler.hh"
#include "generic/Pickle.hh"
#include "generic/UniqueString.hh"

//
// Stream Classes
//
enum OUT_STREAM_TYPE {
  FILE_OUTPUT_STREAM   = MIN_DATA_LABEL,
  STRING_OUTPUT_STREAM = (FILE_OUTPUT_STREAM + 1)
};

class OutputStream: private Block {
public:
  static OutputStream *New(OUT_STREAM_TYPE type, u_int size) {
    Block *p = Store::AllocMutableBlock((BlockLabel) type, size);
    return STATIC_CAST(OutputStream *, p);
  }
  static OutputStream *FromWordDirect(word stream) {
    Block *p = Store::DirectWordToBlock(stream);
    Assert(p->GetLabel() == (BlockLabel) FILE_OUTPUT_STREAM ||
	   p->GetLabel() == (BlockLabel) STRING_OUTPUT_STREAM);
    return STATIC_CAST(OutputStream *, p);
  }

  using Block::InitArg;
  using Block::GetArg;
  using Block::ReplaceArg;
  using Block::ToWord;

  OUT_STREAM_TYPE GetType() {
    return STATIC_CAST(OUT_STREAM_TYPE, STATIC_CAST(u_int, this->GetLabel()));
  }
  void PutByte(u_char byte);
  void PutBytes(Chunk *c);
  void PutBytes(u_char *buf, u_int size);
  void PutUInt(u_int i);
  word Close();
};

class FileOutputStreamFinalizationSet: public FinalizationSet {
public:
  virtual void Finalize(word value);
};

class FileOutputStream: public OutputStream {
private:
  enum { FILE_POS, FINALIZATION_KEY_POS, SIZE };

  static FileOutputStreamFinalizationSet *finalizationSet;
public:
  static void Init() {
    finalizationSet = new FileOutputStreamFinalizationSet();
  }

  static FileOutputStream *New(char *filename) {
    OutputStream *outputStream = OutputStream::New(FILE_OUTPUT_STREAM, SIZE);
    gzFile file = gzopen(filename, "wb" COMPRESSIONLEVEL);
    outputStream->InitArg(FILE_POS, Store::UnmanagedPointerToWord(file));
    outputStream->InitArg(FINALIZATION_KEY_POS,
			  finalizationSet->Register(outputStream->ToWord()));
    return STATIC_CAST(FileOutputStream *, outputStream);
  }
  static FileOutputStream *FromWordDirect(word stream) {
    ::Block *p = Store::DirectWordToBlock(stream);
    Assert(p->GetLabel() == (BlockLabel) FILE_OUTPUT_STREAM);
    return STATIC_CAST(FileOutputStream *, p);
  }

  gzFile GetFile() {
    return STATIC_CAST(gzFile, Store::DirectWordToUnmanagedPointer(GetArg(FILE_POS)));
  }

  void PutByte(u_char byte);
  void PutBytes(Chunk *c);
  void PutBytes(u_char *buf, u_int size);
  word Close();
};

class StringOutputStream: public OutputStream {
private:
  enum { POS_POS, SIZE_POS, STRING_POS, SIZE };

  static const u_int INITIAL_SIZE = 256; //--** to be determined

  void SetPos(u_int pos) {
    InitArg(POS_POS, pos);
  }
  u_int GetPos() {
    return Store::DirectWordToInt(GetArg(POS_POS));
  }
  void SetSize(u_int size) {
    InitArg(SIZE_POS, size);
  }
  u_int GetSize() {
    return Store::DirectWordToInt(GetArg(SIZE_POS));
  }
  void SetString(String *string) {
    ReplaceArg(STRING_POS, string->ToWord());
  }
  String *GetString() {
    return String::FromWordDirect(GetArg(STRING_POS));
  }
  void Enlarge();
public:
  static StringOutputStream *New() {
    StringOutputStream *stream = STATIC_CAST(StringOutputStream *, OutputStream::New(STRING_OUTPUT_STREAM, SIZE));
    stream->SetPos(0);
    stream->SetSize(INITIAL_SIZE);
    stream->SetString(String::New(INITIAL_SIZE));
    return stream;
  }

  void PutByte(u_char byte);
  void PutBytes(Chunk *c);
  void PutBytes(u_char *c, u_int size);
  word Close();
};

// OutputStream Methods
void OutputStream::PutUInt(u_int i) {
  while (i >= 0x80) {
    OutputStream::PutByte(i & 0x7F | 0x80);
    i >>= 7;
  }
  OutputStream::PutByte(i);
}

void OutputStream::PutByte(u_char byte) {
  switch (GetType()) {
  case FILE_OUTPUT_STREAM:
    STATIC_CAST(FileOutputStream *, this)->PutByte(byte); break;
  case STRING_OUTPUT_STREAM:
    STATIC_CAST(StringOutputStream *, this)->PutByte(byte); break;
  }
}

void OutputStream::PutBytes(Chunk *c) {
  switch (GetType()) {
  case FILE_OUTPUT_STREAM:
    STATIC_CAST(FileOutputStream *, this)->PutBytes(c); break;
  case STRING_OUTPUT_STREAM:
    STATIC_CAST(StringOutputStream *, this)->PutBytes(c); break;
  }
}

void OutputStream::PutBytes(u_char *buf, u_int size) {
  switch (GetType()) {
  case FILE_OUTPUT_STREAM:
    STATIC_CAST(FileOutputStream *, this)->PutBytes(buf, size); break;
  case STRING_OUTPUT_STREAM:
    STATIC_CAST(StringOutputStream *, this)->PutBytes(buf, size); break;
  }
}

// FileOutputStream Methods
void FileOutputStreamFinalizationSet::Finalize(word value) {
  gzclose(FileOutputStream::FromWordDirect(value)->GetFile());
}

FileOutputStreamFinalizationSet *FileOutputStream::finalizationSet;

void FileOutputStream::PutByte(u_char byte) {
  gzputc(GetFile(), byte);
}

void FileOutputStream::PutBytes(Chunk *c) {
  gzwrite(GetFile(), c->GetBase(), c->GetSize());
}

void FileOutputStream::PutBytes(u_char *buf, u_int size) {
  gzwrite(GetFile(), buf, size);
}

word FileOutputStream::Close() {
  gzclose(GetFile());
  u_int key = Store::DirectWordToInt(GetArg(FINALIZATION_KEY_POS));
  finalizationSet->Unregister(key);
  return Store::IntToWord(0);
}

// StringOutputStream Methods
void StringOutputStream::Enlarge() {
  u_int newSize     = (GetSize() * 3) >> 1;
  String *newString = String::New(newSize);
  String *oldString = GetString();
  std::memcpy(newString->GetValue(), oldString->GetValue(), GetPos());
  SetSize(newSize);
  SetString(newString);
}

void StringOutputStream::PutByte(u_char byte) {
  u_char *c  = GetString()->GetValue();
  u_int pos  = GetPos();
  u_int size = GetSize();
  c[pos++] = byte;
  SetPos(pos);
  if (pos == size)
    Enlarge();
}

void StringOutputStream::PutBytes(Chunk *c) {
  u_int cSize = c->GetSize();
  u_int pos   = GetPos();
  while (pos + cSize >= GetSize())
    Enlarge();
  std::memcpy(GetString()->GetValue() + pos, c->GetBase(), cSize);
  SetPos(pos + cSize);
}

void StringOutputStream::PutBytes(u_char *buf, u_int size) {
  //  u_int cSize = c->GetSize();
  u_int pos   = GetPos();
  while (pos + size >= GetSize())
    Enlarge();
  std::memcpy(GetString()->GetValue() + pos, buf, size);
  SetPos(pos + size);
}

word StringOutputStream::Close() {
  ::Block *str = Store::DirectWordToBlock(GetString()->ToWord());
  HeaderOp::EncodeSize(str, GetPos()); //--** wrong size
  return str->ToWord();
}

// The OutputBuffer is used to buffer the byte code as well as
// keep track of local variables

class OutputBuffer : private Block {
  static const BlockLabel OBUF_LABEL = MIN_DATA_LABEL;
  enum { BUFFER_POS, LOCALS_POS, POS_POS, SIZE_POS, 
	 LOC_COUNT_POS, LOC_SIZE_POS, SIZE };
  static const u_int initialSize = 8192; //--** to be checked
  static const u_int locInitialSize = 64; //--** to be checked

  void ResizeBuffer();
  void ResizeLocals();

  // Quicksort implementation needed for
  // local variable tracking
  static void Swap(Block *b, int i, int j);
  static int Partition(Block *b, int l, int r);
  static void Sort(Block *b, int l, int r);
  
public:
  using Block::ToWord;

  static OutputBuffer *New() {
    Block *b = Store::AllocMutableBlock(OBUF_LABEL, SIZE);
    b->InitArg(BUFFER_POS, Store::AllocChunk(initialSize)->ToWord());

    Block *locBuf = Store::AllocMutableBlock(MIN_DATA_LABEL, locInitialSize*2);
    locBuf->InitArg(0,Store::IntToWord(0));
    locBuf->InitArg(1,Store::IntToWord(0));

    b->InitArg(LOCALS_POS, locBuf->ToWord());
    b->InitArg(POS_POS, Store::IntToWord(0));
    b->InitArg(SIZE_POS, Store::IntToWord(initialSize));
    b->InitArg(LOC_COUNT_POS, Store::IntToWord(0));
    b->InitArg(LOC_SIZE_POS, Store::IntToWord(locInitialSize*2));
    return STATIC_CAST(OutputBuffer *, b);
  }

  static OutputBuffer *FromWordDirect(word w) {
    Block *b = Store::DirectWordToBlock(w);
    Assert(b->GetLabel() == OBUF_LABEL);
    return STATIC_CAST(OutputBuffer *, b);
  }

  void Reset();

  u_int GetSize();

  void PutByte(u_char byte);
  void PutBytes(Chunk *c);
  void PutUInt(u_int i);
  u_int PutLocal(u_int ref);

  u_int GetPos();
  Chunk *GetBuffer();
  Block *GetLocals();
  u_int GetNoOfLocals();

};


void OutputBuffer::Reset() {
  Block *locBuf = Store::DirectWordToBlock(GetArg(LOCALS_POS));
  locBuf->ReplaceArg(0,Store::IntToWord(0));
  locBuf->ReplaceArg(1,Store::IntToWord(0));
  
  ReplaceArg(POS_POS, Store::IntToWord(0));
  ReplaceArg(LOC_COUNT_POS, Store::IntToWord(0));
}

void OutputBuffer::Swap(Block *b, int i, int j) {
  word v = b->GetArg(i*2);
  word l = b->GetArg(i*2+1);
  b->ReplaceArg(i*2, b->GetArg(j*2));
  b->ReplaceArg(i*2+1, b->GetArg(j*2+1));
  b->ReplaceArg(j*2, v);
  b->ReplaceArg(j*2+1, l);
}
  
int OutputBuffer::Partition(Block *b, int l, int r) {
  int i = l-1, j = r;
  
  int v = Store::DirectWordToInt(b->GetArg(r*2));
  
  for(;;) {
    while (Store::DirectWordToInt(b->GetArg((++i)*2)) < v);
    while (v < Store::DirectWordToInt(b->GetArg((--j)*2)))
      if (j==l) break;
    if (i >= j) break;
    Swap(b, i, j);
  }
  Swap(b, i, r);
  return i;
  
}

void OutputBuffer::Sort(Block *b, int l, int r) {
  if (r <= l) return;
  int i = Partition(b, l, r);
  Sort(b, l, i-1);
  Sort(b, i+1, r);
}

void OutputBuffer::ResizeBuffer() {
  // Adjusts the output buffer's size if it has become too small
  u_int size = Store::DirectWordToInt(GetArg(SIZE_POS));
  u_int newSize = (size * 3) >> 1; // Why that?

  Chunk *buf = Store::DirectWordToChunk(GetArg(BUFFER_POS));
  Chunk *newBuf = Store::AllocChunk(newSize);
  std::memcpy(newBuf->GetBase(), buf->GetBase(), GetPos());
  
  ReplaceArg(SIZE_POS, Store::IntToWord(newSize));
  ReplaceArg(BUFFER_POS, newBuf->ToWord());
}

void OutputBuffer::ResizeLocals() {
  // Adjusts the size of the local variable buffer if it has
  // become too small
  u_int size = Store::DirectWordToInt(GetArg(LOC_SIZE_POS));
  u_int newSize = (size * 3 * 2) >> 1;

  u_int pos  = Store::DirectWordToInt(GetArg(LOC_COUNT_POS));
  Block *buf = Store::DirectWordToBlock(GetArg(LOCALS_POS));
  Block *newBuf = Store::AllocMutableBlock(MIN_DATA_LABEL, newSize);
  for (int i=pos+1; i--;) {
    newBuf->InitArg(i*2, buf->GetArg(i*2));
    newBuf->InitArg(i*2+1, buf->GetArg(i*2+1));
  }
  ReplaceArg(LOC_SIZE_POS, Store::IntToWord(newSize));
  ReplaceArg(LOCALS_POS, newBuf->ToWord());
}

u_int OutputBuffer::GetSize() {
  return Store::DirectWordToInt(GetArg(SIZE_POS));
}

Block *OutputBuffer::GetLocals() {
  // Returns the local variable vector, sorted
  // by the index into the output buffer
  
  Block *b = Store::DirectWordToBlock(GetArg(LOCALS_POS));
  u_int n = GetNoOfLocals();

  if (n>0) {
    Sort(b, 0, GetNoOfLocals());
  }
  return b;
}

void OutputBuffer::PutByte(u_char byte) {
  u_int pos = Store::DirectWordToInt(GetArg(POS_POS));
  u_int size = Store::DirectWordToInt(GetArg(SIZE_POS));
  if (pos >= size) ResizeBuffer();
  Chunk *buf = Store::DirectWordToChunk(GetArg(BUFFER_POS));

  u_char *c = (u_char *)buf->GetBase();
  c[pos] = byte;
  ReplaceArg(POS_POS, Store::IntToWord(pos+1));
}

void OutputBuffer::PutBytes(Chunk *c) {
  u_int pos = Store::DirectWordToInt(GetArg(POS_POS));
  u_int size = c->GetSize();

  while (pos + size >= GetSize())
    ResizeBuffer();

  Chunk *buf = Store::DirectWordToChunk(GetArg(BUFFER_POS));
  std::memcpy(buf->GetBase() + pos, c->GetBase(), size);

  ReplaceArg(POS_POS, Store::IntToWord(pos+size));
}

void OutputBuffer::PutUInt(u_int i) {
  u_int pos = Store::DirectWordToInt(GetArg(POS_POS));
  u_int size = Store::DirectWordToInt(GetArg(SIZE_POS));

  // HACK: u_int of 32 bit can be 5 bytes at most!
  if (pos + 5 >= size) ResizeBuffer();

  Chunk *buf = Store::DirectWordToChunk(GetArg(BUFFER_POS));
  u_char *c = (u_char *)buf->GetBase();

  while (i >= 0x80) {
    c[pos] = (i & 0x7F | 0x80);
    pos++;
    i >>= 7;
  }
  c[pos] = i;
  ReplaceArg(POS_POS, Store::IntToWord(pos+1));

}

u_int OutputBuffer::PutLocal(u_int ref) {
  // creates a new local variable and returns its number
  // the reference into the output buffer is stored

  u_int lpos = Store::DirectWordToInt(GetArg(LOC_COUNT_POS));
  u_int lsize = Store::DirectWordToInt(GetArg(LOC_SIZE_POS));
  lpos++;
  if (lpos*2+1 >= lsize) ResizeLocals();

  Block *buf = Store::DirectWordToBlock(GetArg(LOCALS_POS));
  buf->ReplaceArg(lpos*2, Store::IntToWord(ref));
  buf->ReplaceArg(lpos*2+1, Store::IntToWord(lpos));
  PutUInt(lpos);
  ReplaceArg(LOC_COUNT_POS, Store::IntToWord(lpos));
  return lpos;
}

u_int OutputBuffer::GetPos() {
  return Store::DirectWordToInt(GetArg(POS_POS));
}

Chunk *OutputBuffer::GetBuffer() {
  return Store::DirectWordToChunk(GetArg(BUFFER_POS));
}

u_int OutputBuffer::GetNoOfLocals() {
  return Store::DirectWordToInt(GetArg(LOC_COUNT_POS));
}



// Sharing Detector
class Seen: private Block {
private:
  static const BlockLabel SEEN_LABEL = MIN_DATA_LABEL;
  enum { TABLE_POS, SIZE };
  static const u_int initialSize = 256; //--** to be checked
public:
  static const u_int NOT_WRITTEN = STATIC_CAST(u_int, -1);
  static const u_int NOT_FOUND = STATIC_CAST(u_int, -2);

  using Block::ToWord;

  static Seen *New() {
    Block *p = Store::AllocBlock(SEEN_LABEL, SIZE);
    p->InitArg(TABLE_POS, Map::New(initialSize)->ToWord());
    return STATIC_CAST(Seen *, p);
  }
  static Seen *FromWordDirect(word w) {
    Block *b = Store::DirectWordToBlock(w);
    Assert(b->GetLabel() == SEEN_LABEL);
    return STATIC_CAST(Seen *, b);
  }

  void Reset() {
    Map *map     = Map::FromWordDirect(GetArg(TABLE_POS));
    map->Clear();
  }

  void Add(Block *v, int index) {
    Map *map     = Map::FromWordDirect(GetArg(TABLE_POS));
    Block *b = Store::AllocMutableBlock(MIN_DATA_LABEL, 2);
    b->InitArg(0, Store::IntToWord(index));
    b->InitArg(1, Store::IntToWord(0));
    map->Put(v->ToWord(), b->ToWord());
  }

  void SetIndex(Block *v, int index) {
    Map *map     = Map::FromWordDirect(GetArg(TABLE_POS));
    Block *b = Store::DirectWordToBlock(map->Get(v->ToWord()));
    b->ReplaceArg(0, Store::IntToWord(index));
  }

  u_int Find(Block *v) {
    word vw  = v->ToWord();
    Map *map = Map::FromWordDirect(GetArg(TABLE_POS));
    if (map->IsMember(vw)) {
      Block *b = Store::DirectWordToBlock(map->Get(vw));
      return Store::DirectWordToInt(b->GetArg(0));
    } else {
      return NOT_FOUND;
    }
  }

  void SetVarNo(Block *v, int varNo) {
    Assert(Find(v) != NOT_FOUND);
    Map *map = Map::FromWordDirect(GetArg(TABLE_POS));
    word vw  = v->ToWord();
    Block *b = Store::DirectWordToBlock(map->Get(vw));
    b->ReplaceArg(1, Store::IntToWord(varNo));
  }
  int GetVarNo(Block *v) {
    Assert(Find(v) != NOT_FOUND);
    word vw  = v->ToWord();
    Map *map = Map::FromWordDirect(GetArg(TABLE_POS));
    Block *b = Store::DirectWordToBlock(map->Get(vw));
    return Store::DirectWordToInt(b->GetArg(1));
  }

};

// PickleStack
// used for depth first search
class PickleStack : private Stack {
private:
  enum { DATA_POS, BACK_POS, FRAME_SIZE };

  static const u_int initialSize = 128*FRAME_SIZE;

public:
  using Stack::ToWord;
  using Stack::IsEmpty;

  static PickleStack *New() {
    Stack *s = Stack::New(initialSize);
    return STATIC_CAST(PickleStack *, s);
  }

  static PickleStack *FromWordDirect(word w) {
    Stack *s = Stack::FromWordDirect(w);
    return STATIC_CAST(PickleStack *, s);
  }

  void Push(word data);
  word GetData();
  void SetBack();
  bool GetBack();
  void PopTopFrame();
  void Reset(word data);
};

void PickleStack::Push(word data) {
  Stack::AllocArgFrame(FRAME_SIZE);
  Stack::PutFrameArg(DATA_POS, data);
  Stack::PutFrameArg(BACK_POS, 0);
}

word PickleStack::GetData() {
  return Stack::GetFrameArg(DATA_POS);
}

void PickleStack::SetBack() {
  Stack::PutFrameArg(BACK_POS, 1);
}

bool PickleStack::GetBack() {
  return (Store::DirectWordToInt(Stack::GetFrameArg(BACK_POS)) == 1);
}

void PickleStack::PopTopFrame() {
  Stack::ClearArgFrameZero(FRAME_SIZE);
}

void PickleStack::Reset(word data) {
  SetTop(0);
  PickleStack::Push(data);
}

// PickleArgs
class PickleArgs {
private:
  enum { STREAM_POS, BUFFER_POS, SEEN_POS,
	 STACK_POS, ROOT_POS,
	 CUR_STACK_POS, MAX_STACK_POS, 
	 TRANSIENT_FOUND_POS, SIZE };
public:
  static void New(OutputStream *stream, word root) {
    Scheduler::SetNArgs(SIZE);
    Scheduler::SetCurrentArg(STREAM_POS, stream->ToWord());
    Scheduler::SetCurrentArg(BUFFER_POS, OutputBuffer::New()->ToWord());
    Scheduler::SetCurrentArg(SEEN_POS, Seen::New()->ToWord());

    PickleStack *ps = PickleStack::New();
    ps->Push(root);

    Scheduler::SetCurrentArg(STACK_POS, ps->ToWord());
    Scheduler::SetCurrentArg(ROOT_POS, root);
    Scheduler::SetCurrentArg(CUR_STACK_POS, Store::IntToWord(0));
    Scheduler::SetCurrentArg(MAX_STACK_POS, Store::IntToWord(0));
    Scheduler::SetCurrentArg(TRANSIENT_FOUND_POS, Store::IntToWord(0));
  }
  static OutputStream *GetOutputStream() {
    Assert(Scheduler::GetNArgs() == SIZE);
    return OutputStream::FromWordDirect(Scheduler::GetCurrentArg(STREAM_POS));
  }
  static OutputBuffer *GetOutputBuffer() {
    Assert(Scheduler::GetNArgs() == SIZE);
    return OutputBuffer::FromWordDirect(Scheduler::GetCurrentArg(BUFFER_POS));
  }
  static Seen *GetSeen() {
    Assert(Scheduler::GetNArgs() == SIZE);
    return Seen::FromWordDirect(Scheduler::GetCurrentArg(SEEN_POS));
  }
  static PickleStack *GetPickleStack() {
    Assert(Scheduler::GetNArgs() == SIZE);
    return PickleStack::FromWordDirect(Scheduler::GetCurrentArg(STACK_POS));
  }
  static u_int GetMaxStackHeight() {
    return Store::DirectWordToInt(Scheduler::GetCurrentArg(MAX_STACK_POS));
  }
  static u_int GetCurStackHeight() {
    return Store::DirectWordToInt(Scheduler::GetCurrentArg(CUR_STACK_POS));
  }
  static void SimulatePush() {
    // Unpickler stack height simulation - push operation
    u_int cur = GetCurStackHeight() + 1;
    Scheduler::SetCurrentArg(CUR_STACK_POS, Store::IntToWord(cur));
    if (cur > GetMaxStackHeight()) {
      Scheduler::SetCurrentArg(MAX_STACK_POS, Store::IntToWord(cur));
    }
  }
  static void SimulatePop(u_int i) {
    // Unpickler stack height simulation - pop operation
    u_int cur = GetCurStackHeight();
    Assert(cur>0);
    cur -= i;
    Scheduler::SetCurrentArg(CUR_STACK_POS, Store::IntToWord(cur));
  }
  static bool GetTransientFound() {
    return
      Store::DirectWordToInt(Scheduler::GetCurrentArg(TRANSIENT_FOUND_POS));
  }
  static void SetTransientFound() {
    Scheduler::SetCurrentArg(TRANSIENT_FOUND_POS, Store::IntToWord(1));
  }
  static void Reset() {
    GetOutputBuffer()->Reset();
    GetSeen()->Reset();
    GetPickleStack()->Reset(Scheduler::GetCurrentArg(ROOT_POS));
    Scheduler::SetCurrentArg(CUR_STACK_POS, Store::IntToWord(0));
    Scheduler::SetCurrentArg(MAX_STACK_POS, Store::IntToWord(0));
    Scheduler::SetCurrentArg(TRANSIENT_FOUND_POS, Store::IntToWord(0));
  }

};


// PickleWorker
class PickleWorker: public Worker {
private:
  static PickleWorker *self;
  // PickleWorker Constructor
  PickleWorker(): Worker() {}
public:
  // PickleWorker Static Constructor
  static void Init() {
    self = new PickleWorker();
  }
  // Frame Handling
  static void PushFrame();
  virtual u_int GetFrameSize(StackFrame *sFrame);
  // Execution
  virtual Result Run(StackFrame *sFrame);
  // Debugging
  virtual const char *Identify();
  virtual void DumpFrame(StackFrame *sFrame);
};


//
// PickleWorker Functions
//
PickleWorker *PickleWorker::self;

void PickleWorker::PushFrame() {
  NEW_STACK_FRAME(frame, self, 0);
}

u_int PickleWorker::GetFrameSize(StackFrame *sFrame) {
  Assert(sFrame->GetWorker() == this);
  return sFrame->GetSize();
}

Worker::Result PickleWorker::Run(StackFrame *sFrame) {
  Assert(sFrame != INVALID_POINTER);
  Assert(sFrame->GetWorker() == this);

  PickleStack *nps = PickleArgs::GetPickleStack();
  OutputBuffer *outputBuffer = PickleArgs::GetOutputBuffer();
  Seen *seen = PickleArgs::GetSeen();
    
  for(;;) {
    if (nps->IsEmpty()) {
      Scheduler::PopFrame(sFrame->GetSize());
      if (StatusWord::GetStatus() != 0)
	return Worker::PREEMPT;
      else
	return Worker::CONTINUE;
    }
  
    word x0 = nps->GetData();
    bool back = nps->GetBack();


    if (back) { // We're back from recursion
      // Stack height computation

      Block *v = Store::WordToBlock(x0);
      u_int var = seen->GetVarNo(v);

      if (var!=0) { // This is a cycle
	// The block has already been announced, so this
	// announcement only has to be fulfilled
	u_int arity = v->GetSize();
	outputBuffer->PutByte(Pickle::FULFILL);
	outputBuffer->PutUInt(var);
	PickleArgs::SimulatePop(arity-1);
	nps->PopTopFrame();
	continue;
      }

      BlockLabel l = v->GetLabel();
      u_int size = v->GetSize();

      switch(l) {
      case UNIQUESTRING_LABEL:
	{
	  outputBuffer->PutByte(Pickle::UNIQUE);
	  seen->SetIndex(v, outputBuffer->GetPos());
	}
	break;
      case CONCRETE_LABEL:
	{
	  outputBuffer->PutByte(Pickle::TRANSFORM);
	  //	  outputBuffer->PutByte(Pickle::BLOCK);
	  //	  outputBuffer->PutUInt((u_int) TRANSFORM_LABEL);
	  //	  outputBuffer->PutUInt(2);
	  PickleArgs::SimulatePop(1);
	  seen->SetIndex(v, outputBuffer->GetPos());
	}
	break;
      case CLOSURE_LABEL:
	{
	  outputBuffer->PutByte(Pickle::CLOSURE);
	  outputBuffer->PutUInt(size);
	  PickleArgs::SimulatePop(size-1);
	  seen->SetIndex(v, outputBuffer->GetPos());
	}
	break;
      case TUPLE_LABEL:
	{
	  outputBuffer->PutByte(Pickle::TUPLE);
	  outputBuffer->PutUInt(size);
	  PickleArgs::SimulatePop(size-1);
	  seen->SetIndex(v, outputBuffer->GetPos());
	}
	break;
      default:
	{
	  if (v->IsMutable())
	    outputBuffer->PutByte(Pickle::MBLOCK);
	  else
	    outputBuffer->PutByte(Pickle::BLOCK);
	  outputBuffer->PutUInt((u_int) l);
	  outputBuffer->PutUInt(size);
	  PickleArgs::SimulatePop(size-1);
	  seen->SetIndex(v, outputBuffer->GetPos());
	}
	break;
      }

      nps->PopTopFrame();
      continue;
    }

    if (Store::WordToTransient(x0) != INVALID_POINTER) {
      // Signal that we have found a transient
      // -> we have to pickle again to enforce a
      //    consistent state
      PickleArgs::SetTransientFound();

      Scheduler::SetCurrentData(x0);
      return Worker::REQUEST;
    }


    // Check for integer
    s_int i;
    if ((i = Store::WordToInt(x0)) != INVALID_INT) {
      if (i >= 0) {
	outputBuffer->PutByte(Pickle::POSINT);
	outputBuffer->PutUInt(i);
      } else {
	outputBuffer->PutByte(Pickle::NEGINT);
	outputBuffer->PutUInt(-(i + 1));
      }
      // integers occupy 1 stack cell
      PickleArgs::SimulatePush();

      nps->PopTopFrame();
      continue;
    }

    // Search for already known value

    Block *v   = Store::WordToBlock(x0);
    u_int ref  = seen->Find(v);

    if (ref != Seen::NOT_FOUND) {
      if (ref==Seen::NOT_WRITTEN) {
	u_int vn = seen->GetVarNo(v);
	if (vn>0) {
	  // this node has already been announced -> just load it
	  outputBuffer->PutByte(Pickle::LOAD);
	  outputBuffer->PutUInt(vn);
	  PickleArgs::SimulatePush();
	} else {
	  // this is a cycle, we have to announce
	  switch(v->GetLabel()) {
	  case CONCRETE_LABEL:
	    {
	      outputBuffer->PutByte(Pickle::aTRANSFORM);
	      u_int ann = outputBuffer->PutLocal(0);
	      // reference doesn't matter
	      // but ref=0 keeps SaveWorker from placing a STORE instruction
	      // which is not necessary for announces
	      seen->SetVarNo(v, ann);
	      PickleArgs::SimulatePush();
	    }
	    break;
	  case CLOSURE_LABEL:
	    {
	      outputBuffer->PutByte(Pickle::aCLOSURE);
	      outputBuffer->PutUInt(v->GetSize());
	      u_int ann = outputBuffer->PutLocal(0);
	      // reference doesn't matter
	      // same as for CONCRETE_LABEL
	      seen->SetVarNo(v, ann);
	      PickleArgs::SimulatePush();
	    }
	    break;
	  case TUPLE_LABEL:
	    {
	      outputBuffer->PutByte(Pickle::aTUPLE);
	      outputBuffer->PutUInt(v->GetSize());
	      u_int ann = outputBuffer->PutLocal(0);
	      // reference doesn't matter
	      // same as for CONCRETE_LABEL
	      seen->SetVarNo(v, ann);
	      PickleArgs::SimulatePush();
	    }
	    break;
	  default:
	    {
	      if (v->IsMutable())
		outputBuffer->PutByte(Pickle::aMBLOCK);
	      else
		outputBuffer->PutByte(Pickle::aBLOCK);
	      outputBuffer->PutUInt((u_int) v->GetLabel());
	      u_int size = v->GetSize();
	      outputBuffer->PutUInt(size);	
	      u_int ann = outputBuffer->PutLocal(0);
	      // reference doesn't matter
	      // same as for CONCRETE_LABEL
	      seen->SetVarNo(v, ann);
	      PickleArgs::SimulatePush();
	    }
	    break;
	  }
	}
      } else {
	// this is sharing, we can load the reference
	outputBuffer->PutByte(Pickle::LOAD);
	u_int vn = seen->GetVarNo(v);
	PickleArgs::SimulatePush();
	if (vn>0) {
	  // the variable is already known, just load it
	  outputBuffer->PutUInt(vn);
	} else {
	  // a new local variable for v has to be created
	  u_int ann = outputBuffer->PutLocal(ref);
	
	  // We have to remember its number so that we can
	  // simply load it next time
	  seen->SetVarNo(v, ann);
	}
      }

      nps->PopTopFrame();
      continue;
    }

    // Handle new Block Value (non-abstract use)
    BlockLabel l = v->GetLabel();
    switch (l) {
    case WEAK_MAP_LABEL:
    case MAP_LABEL:
    case INT_MAP_LABEL:
    case CHUNK_MAP_LABEL:
    case THREAD_LABEL:
    case TASKSTACK_LABEL:
    case IODESC_LABEL:
      // Not 100% correct:
      // If a transient gets bound and replaces the
      // sited value by something we can pickle,
      // we shouldn't reject that!
      Scheduler::SetCurrentData(Pickler::Sited);
      Scheduler::SetCurrentBacktrace(Backtrace::New(sFrame->Clone()));
      return Worker::RAISE;
    case CHUNK_LABEL:
      {
	Chunk *c = STATIC_CAST(Chunk *, v);
	if (c->IsMutable())
	  outputBuffer->PutByte(Pickle::MCHUNK);
	else
	  outputBuffer->PutByte(Pickle::CHUNK);
	outputBuffer->PutUInt(c->GetSize());
	outputBuffer->PutBytes(c);
	u_int idx = outputBuffer->GetPos();

	seen->Add(v, idx);
	
	PickleArgs::SimulatePush();
	nps->PopTopFrame();
	continue;
      }
      break;
    case UNIQUESTRING_LABEL:
      {
	nps->SetBack();

	seen->Add(v, Seen::NOT_WRITTEN);
	UniqueString *s = STATIC_CAST(UniqueString *, v);

	nps->Push(s->ToString()->ToWord());
	continue;
      }
      break;
    case CONCRETE_LABEL:
      {
	nps->SetBack();

	seen->Add(v, Seen::NOT_WRITTEN);
	ConcreteRepresentation *concrete =
	  STATIC_CAST(ConcreteRepresentation *, v);
	Transform *abstract =
	  concrete->GetHandler()->GetAbstractRepresentation(concrete);
	Block *ablock = Store::DirectWordToBlock(abstract->ToWord());
	if (abstract == INVALID_POINTER) {
	  Scheduler::SetCurrentData(Pickler::Sited);
	  Scheduler::SetCurrentBacktrace(Backtrace::New(sFrame->Clone()));
	  return Worker::RAISE;
	} else {
	  seen->Add(ablock, Seen::NOT_WRITTEN);

	  nps->Push(abstract->GetName()->ToWord());
	  nps->Push(abstract->GetArgument());
	  continue;
	}
      }
      break;
    case TRANSFORM_LABEL:
      {
	// must not occur anywhere but under a CONCRETE which is handled above
	Scheduler::SetCurrentData(Pickler::Sited);
	Scheduler::SetCurrentBacktrace(Backtrace::New(sFrame->Clone()));
	return Worker::RAISE;
      
      }
      break;
    default:
      {
	nps->SetBack();

	seen->Add(v, Seen::NOT_WRITTEN);
	u_int size = v->GetSize(); // to be done
	for (u_int i = 0; i<size; i++ )
	  nps->Push(v->GetArg(i));
	continue;
      }
    }
  }
}

const char *PickleWorker::Identify() {
  return "PickleWorker";
}

void PickleWorker::DumpFrame(StackFrame *) {
  std::fprintf(stderr, "Pickle Task\n");
}

// PickleSaveWorker
class PickleSaveWorker: public Worker {
private:
  static PickleSaveWorker *self;
  // PickleSaveWorker Constructor
  PickleSaveWorker(): Worker() {}
public:
  // PickleSaveWorker Static Constructor

  static void WriteToStream(OutputBuffer *obf,
			    OutputStream *outputStream);

  static void Init() {
    self = new PickleSaveWorker();
  }
  // Frame Handling
  static void PushFrame();
  virtual u_int GetFrameSize(StackFrame *sFrame);
  // Execution
  virtual Result Run(StackFrame *sFrame);
  // Debugging
  virtual const char *Identify();
  virtual void DumpFrame(StackFrame *sFrame);
};

//
// PickleSaveWorker Functions
//
PickleSaveWorker *PickleSaveWorker::self;

void PickleSaveWorker::PushFrame() {
  NEW_STACK_FRAME(frame, self, 0);
}

void PickleSaveWorker::WriteToStream(OutputBuffer *obf,
				     OutputStream *outputStream) {

  Chunk *c = obf->GetBuffer();
  Block *vars = obf->GetLocals();
  u_int pos = obf->GetPos();
  u_int noOfLoc = obf->GetNoOfLocals();
  u_int stackHeight = PickleArgs::GetMaxStackHeight();

  // Write the magic header = stack info
  static u_char magic[] = "seam";
  outputStream->PutBytes(magic, 4);
  outputStream->PutUInt(Pickle::majorVersion);
  outputStream->PutUInt(Pickle::minorVersion);
  outputStream->PutByte(Pickle::INIT);
  outputStream->PutUInt(stackHeight);
  outputStream->PutUInt(noOfLoc+1);

  u_int curPos = 0;
  u_char *ibf = (u_char *)c->GetBase();

  // write the output buffer to file, filling in the missing
  // STOREs where indicated by the locals array
  for(u_int i=1;i<=noOfLoc;i++) {
    u_int nextLoc = Store::DirectWordToInt(vars->GetArg(i*2));
    u_int nextVar = Store::DirectWordToInt(vars->GetArg(i*2+1));

    if (nextLoc>0) {
      Assert ( nextLoc > curPos );
      outputStream->PutBytes(ibf+curPos, nextLoc-curPos);
      curPos = nextLoc;
      outputStream->PutByte(Pickle::STORE);
      outputStream->PutUInt(nextVar);
    }
  }

  outputStream->PutBytes(ibf+curPos, pos-curPos);

  // store topmost node to variable 0
  // this becomes the root node on unpickling
  outputStream->PutByte(Pickle::STORE);
  outputStream->PutUInt(0);
  outputStream->PutByte(Pickle::ENDOFSTREAM);
}

u_int PickleSaveWorker::GetFrameSize(StackFrame *sFrame) {
  Assert(sFrame->GetWorker() == this);
  return sFrame->GetSize();
}

Worker::Result PickleSaveWorker::Run(StackFrame *sFrame) {
  Assert(sFrame->GetWorker() == this);

  if (PickleArgs::GetTransientFound()) {
    // If a transient was found during pickling,
    // we have to restart because binding the transient
    // may have modified parts of the graph that had
    // already been pickled, thus leaving the pickle in an
    // inconsistent state

    PickleArgs::Reset();
    PickleWorker::PushFrame();
    return Worker::CONTINUE;
  } else {
    OutputBuffer *obf = PickleArgs::GetOutputBuffer();
    
    OutputStream *os = PickleArgs::GetOutputStream();
    PickleSaveWorker::WriteToStream(obf, os);
    
    FileOutputStream *outputStream =
      STATIC_CAST(FileOutputStream *, os);
    
    outputStream->Close();
    Scheduler::SetNArgs(0);
    Scheduler::PopFrame(sFrame->GetSize());
    return Worker::CONTINUE;
  }

}

const char *PickleSaveWorker::Identify() {
  return "PickleSaveWorker";
}

void PickleSaveWorker::DumpFrame(StackFrame *) {
  std::fprintf(stderr, "Pickle Save\n");
}

// PicklePackWorker
class PicklePackWorker: public Worker {
private:
  static PicklePackWorker *self;
  // PicklePackWorker Constructor
  PicklePackWorker(): Worker() {}
public:
  // PicklePackWorker Static Constructor
  static void Init() {
    self = new PicklePackWorker();
  }
  // Frame Handling
  static void PushFrame();
  virtual u_int GetFrameSize(StackFrame *sFrame);
  // Execution
  virtual Result Run(StackFrame *sFrame);
  // Debugging
  virtual const char *Identify();
  virtual void DumpFrame(StackFrame *sFrame);
};

//
// PicklePackWorker Functions
//
PicklePackWorker *PicklePackWorker::self;

void PicklePackWorker::PushFrame() {
  NEW_STACK_FRAME(frame, self, 0);
}

u_int PicklePackWorker::GetFrameSize(StackFrame *sFrame) {
  Assert(sFrame->GetWorker() == this);
  return sFrame->GetSize();
}

Worker::Result PicklePackWorker::Run(StackFrame *sFrame) {
  Assert(sFrame->GetWorker() == this);

  if (PickleArgs::GetTransientFound()) {
    // If a transient was found during pickling,
    // we have to restart because binding the transient
    // may have modified parts of the graph that had
    // already been pickled, thus leaving the pickle in an
    // inconsistent state

    PickleArgs::Reset();
    PickleWorker::PushFrame();
    return Worker::CONTINUE;
  } else {

    OutputBuffer *obf = PickleArgs::GetOutputBuffer();
    
    OutputStream *os = PickleArgs::GetOutputStream();
    PickleSaveWorker::WriteToStream(obf, os);

    StringOutputStream *outputStream =
      STATIC_CAST(StringOutputStream *, os);
  
    Scheduler::SetNArgs(1);
    Scheduler::SetCurrentArg(0, outputStream->Close());
    Scheduler::PopFrame(sFrame->GetSize());
    return Worker::CONTINUE;
  }
}

const char *PicklePackWorker::Identify() {
  return "PicklePackWorker";
}

void PicklePackWorker::DumpFrame(StackFrame *) {
  std::fprintf(stderr, "Pickle Pack\n");
}

//
// Pickler Functions
//
word Pickler::Sited;
word Pickler::IOError;

Worker::Result Pickler::Pack(word x) {
  StringOutputStream *os = StringOutputStream::New();
  Scheduler::PopFrame();
  PicklePackWorker::PushFrame();
  PickleWorker::PushFrame();
  PickleArgs::New(os, x);
  return Worker::CONTINUE;
}

Worker::Result Pickler::Save(String *filename, word x) {
  char *szFileName     = filename->ExportC();
  FileOutputStream *os = FileOutputStream::New(szFileName);
  if (os->GetFile() == NULL) {
    Scheduler::SetCurrentData(Pickler::IOError);
    StackFrame *frame = Scheduler::GetFrame();
    Scheduler::SetCurrentBacktrace(Backtrace::New(frame->Clone()));
    Scheduler::PopFrame();
    return Worker::RAISE;
  } else {
    Scheduler::PopFrame();
    PickleSaveWorker::PushFrame();
    PickleWorker::PushFrame();
    PickleArgs::New(os, x);
    return Worker::CONTINUE;
  }
}

void Pickler::Init() {
  FileOutputStream::Init();
  PickleWorker::Init();
  PickleSaveWorker::Init();
  PicklePackWorker::Init();
  Sited = UniqueString::New(String::New("@Pickle.Sited"))->ToWord();
  RootSet::Add(Sited);
  IOError = UniqueString::New(String::New("@Pickle.IOError"))->ToWord();
  RootSet::Add(IOError);
}
