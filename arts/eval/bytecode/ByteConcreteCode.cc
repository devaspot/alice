//
// Author:
//   Christian Mueller <cmueller@ps.uni-sb.de>
//
// Copyright:
//   Christian Mueller, 2005
//
// Last Change:
//   $Date: 2005-12-04 15:44:28 $ by $Author: cmueller $
//   $Revision: 1.4 $
//

#if defined(INTERFACE)
#pragma implementation "alice/ByteConcreteCode.hh"
#endif

#include "alice/ByteConcreteCode.hh"
#include "alice/ByteCode.hh"
#include "alice/ByteCodeJitter.hh"
#include "alice/AbstractCode.hh"
#include "alice/AliceLanguageLayer.hh"
#include "alice/HotSpotConcreteCode.hh"
#include "alice/AliceConcreteCode.hh"

//
// ByteConcreteCode
//

// we use this for the byte code assembler
ByteConcreteCode *ByteConcreteCode::NewInternal(TagVal *abstractCode,
						Chunk *code,
						word immediateEnv,
						word nbLocals,
						word inlineInfo) {
  ConcreteCode *concreteCode =
    ConcreteCode::New(ByteCodeInterpreter::self, SIZE);
  Chunk *name =
    Store::DirectWordToChunk(AliceLanguageLayer::TransformNames::function);
  Transform *transform = Transform::New(name, abstractCode->ToWord());
  concreteCode->Init(TRANSFORM_POS, transform->ToWord());
  concreteCode->Init(BYTE_CODE_POS, code->ToWord());
  concreteCode->Init(IMMEDIATE_ENV_POS, immediateEnv);
  concreteCode->Init(NLOCALS_POS, nbLocals);
  Vector *args = Vector::FromWordDirect(abstractCode->Sel(3));
  concreteCode->Init(IN_ARITY_POS, Store::IntToWord(args->GetLength()));
  TagVal *outArityOpt = TagVal::FromWord(abstractCode->Sel(4));
  word outArity = ((outArityOpt == INVALID_POINTER) 
		   ? Store::IntToWord(-1) : outArityOpt->Sel(0));
  concreteCode->Init(OUT_ARITY_POS, outArity);
  concreteCode->Init(INLINE_INFO_POS, inlineInfo);

  return STATIC_CAST(ByteConcreteCode *, concreteCode);
}

// and this is used in the byte code jitter
void ByteConcreteCode::Convert(HotSpotCode *hsc,
			       Chunk *code,
			       word immediateEnv,
			       word nbLocals,
			       word inlineInfo) {
  Transform *transform =
    STATIC_CAST(Transform *, hsc->GetAbstractRepresentation());
  TagVal *abstractCode = TagVal::FromWordDirect(transform->GetArgument());
  ConcreteCode *concreteCode = (ConcreteCode *) hsc;
  concreteCode->ReplaceInterpreter(ByteCodeInterpreter::self);
  concreteCode->Replace(BYTE_CODE_POS, code->ToWord());
  concreteCode->Replace(IMMEDIATE_ENV_POS, immediateEnv);
  concreteCode->Replace(NLOCALS_POS, nbLocals);
  Vector *args = Vector::FromWordDirect(abstractCode->Sel(3));
  concreteCode->Replace(IN_ARITY_POS, Store::IntToWord(args->GetLength()));
  TagVal *outArityOpt = TagVal::FromWord(abstractCode->Sel(4));
  word outArity = ((outArityOpt == INVALID_POINTER) 
		   ? Store::IntToWord(-1) : outArityOpt->Sel(0));
  concreteCode->Replace(OUT_ARITY_POS, outArity);
  concreteCode->Replace(INLINE_INFO_POS, inlineInfo);
}
				 

word ByteConcreteCode::New(TagVal *abstractCode) {
  return HotSpot_StartState::New(HotSpotInterpreter::self, 
				 abstractCode,
				 SIZE,
				 AliceConcreteCode::New,
				 0); // direct transition
};

void ByteConcreteCode::Disassemble(std::FILE *file) {
  Transform *transform = Transform::FromWordDirect(Get(TRANSFORM_POS));
  TagVal *abstractCode = TagVal::FromWordDirect(transform->GetArgument());
  Tuple *coord = Tuple::FromWordDirect(abstractCode->Sel(0));
  fprintf(file, "Disassembling byte code function at %s:%d.%d\n\n",
	  String::FromWordDirect(coord->Sel(0))->ExportC(),
	  Store::DirectWordToInt(coord->Sel(1)),
	  Store::DirectWordToInt(coord->Sel(2)));
  Chunk *code = GetByteCode();
  Tuple *imEnv = GetImmediateArgs();
#ifdef THREADED
  ByteCode::Disassemble(file,(u_int *)code->GetBase(),code,imEnv);
#else
  ByteCode::Disassemble(file,0,code,imEnv);
#endif
}
