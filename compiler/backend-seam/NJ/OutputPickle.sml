val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Contributor:
 *   Guido Tack <tack@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *   Guido Tack, 2003
 *
 * Last change:
 *   $Date: 2006-07-26 09:21:25 $ by $Author: rossberg $
 *   $Revision: 1.56 $
 *)










structure OutputPickle :> OUTPUT_PICKLE =
    struct
	structure V = Value
	open AbstractCodeGrammar

	structure Label =
	    struct
		datatype t =
		    ARRAY
		  | PROMISE
		  | CELL
		  | CON_VAL
		  | RECORD
		  | VECTOR
		  | BIG_TAG
		  | TAG of int
		  | TUPLE
		  | CLOSURE
		  | TRANSFORM

		val false_ = 0
		val true_  = 1

		val none = 0
		val some = TAG 1

		val debug  = TAG 0
		val simple = TAG 1
		    
		val idDef    = TAG 0
		val wildcard = 1

		val oneArg  = TAG 0
		val tupArgs = TAG 1

		val appPrim        = TAG 0
		val appVar         = TAG 1
		val close          = TAG 2
		val compactIntTest = TAG 3
		val compactTagTest = TAG 4
		val conTest        = TAG 5
		val endHandle      = TAG 6
		val endTry         = TAG 7
		val entry          = TAG 8
		val exit           = TAG 9 
		val getRef         = TAG 10
		val getTup         = TAG 11
		val intTest        = TAG 12
		val kill           = TAG 13
		val lazyPolySel    = TAG 14
		val putCon         = TAG 15
		val putNew         = TAG 16
		val putPolyRec     = TAG 17
		val putRef         = TAG 18
		val putTag         = TAG 19
		val putTup         = TAG 20
		val putVar         = TAG 21
		val putVec         = TAG 22
		val raise_         = TAG 23
		val realTest       = TAG 24
		val reraise        = TAG 25
		val return         = TAG 26
		val sel            = TAG 27
		val shared         = TAG 28
		val specialize     = TAG 29
		val stringTest     = TAG 30
		val tagTest        = TAG 31
		val try            = TAG 32
		val vecTest        = TAG 33

		val global       = TAG 0
		val immediate    = TAG 1
		val lastUseLocal = TAG 2
		val local_       = TAG 3
		val toplevel     = TAG 4

		val template = TAG 0

		val function    = TAG 0

		val appEntry    = TAG 0
		val conEntry    = TAG 1
		val condEntry   = TAG 2
		val handleEntry = TAG 3
		val raiseEntry  = TAG 4
		val selEntry    = TAG 5
		val spawnEntry  = 6
		val strictEntry = TAG 7

		val appExit    = 0
		val conExit    = 1
		val condExit   = TAG 2
		val handleExit = TAG 3
		val raiseExit  = TAG 4
		val selExit    = TAG 5
		val spawnExit  = TAG 6
		val strictExit = 7

		fun toInt ARRAY   = 0
		  | toInt PROMISE = 1
		  | toInt CELL    = 2
		  | toInt CON_VAL = 3
		  | toInt RECORD  = 4
		  | toInt VECTOR  = 5
		  | toInt BIG_TAG = 6
		  | toInt (TAG i) = 7 + i
		  | toInt TUPLE   = 243
		  | toInt CLOSURE = 242
		  | toInt TRANSFORM = 245

		(* alice/Data.hh: Alice::MAX_TAG - Alice::MIN_TAG *)
		val maxSmallTag = 93

		fun isBigTagValue nLabels = nLabels > maxSmallTag
	    end

	type context = {outstream: PrimPickle.outstream,
			shared: PrimPickle.register StampMap.t}

	fun nextRegister ({outstream, ...}: context) =
	    PrimPickle.nextRegister outstream
	fun outputFixedInt ({outstream, ...}: context, i) =
	    PrimPickle.outputFixedInt (outstream, i)
	fun outputInt ({outstream, ...}: context, i) =
	    PrimPickle.outputInt (outstream, i)
	fun outputChunk ({outstream, ...}: context, words) =
	    PrimPickle.outputChunk (outstream, words)
	fun outputBlock ({outstream, ...}: context, 
			 label as (Label.ARRAY|Label.CELL), size) =
	    PrimPickle.outputMBlock (outstream, Label.toInt label, size)
	  | outputBlock ({outstream, ...}: context, label, size) =
	    PrimPickle.outputBlock (outstream, Label.toInt label, size)
	fun outputTuple ({outstream, ...}: context, size) =
	    PrimPickle.outputTuple (outstream, size)
	fun outputClosure ({outstream, ...}: context, size) =
	    PrimPickle.outputClosure (outstream, size)
	fun outputString ({outstream, ...}: context, s) =
	    PrimPickle.outputString (outstream, s)
 	fun outputAtom ({outstream, ...}: context, s) =
 	    PrimPickle.outputAtom (outstream, s)
 	fun outputTransform ({outstream, ...}: context) =
 	    PrimPickle.outputTransform outstream
 	fun outputLoad ({outstream, ...}: context, i) =
 	    PrimPickle.outputLoad (outstream, i)
 	fun outputStore ({outstream, ...}: context, i) =
 	    PrimPickle.outputStore (outstream, i)
	fun outputOption _ (context, NONE) =
	    outputInt (context, Label.none)
	  | outputOption output (context, SOME x) =
 	    (output (context, x);
 	     outputBlock (context, Label.some, 1))
 
 	fun outputBool (context, b) =
 	    outputInt (context, if b then Label.true_ else Label.false_)

	fun outputVector output (context, xs) =
 	    (Vector.app (fn x => output (context, x)) (Vector.rev xs);
	     outputInt (context, Vector.length xs);
	     outputBlock (context, Label.VECTOR, Vector.length xs + 1))
	     
	fun outputStamp (context, stamp) =
	    outputInt (context, Stamp.hash stamp)

	fun outputArity (context, arity) =
	    outputInt (context, arity)

	fun outputId (context, id) = outputInt (context, id)

	fun outputIdDef (context, IdDef id) =
	    (outputId (context, id);
	     outputBlock (context, Label.idDef, 1))
	  | outputIdDef (context, Wildcard) =
	    outputInt (context, Label.wildcard)

	fun outputCoord (context, (string, line, column)) =
	    (outputInt (context, column);
	     outputInt (context, line);
	     outputString (context, string);
	     outputTuple (context, 3))

	fun outputLiveness (context, is) =
	    outputVector (fn (context, i) => outputInt (context, i))
			 (context, is)

	fun outputTyp (context, typ) = outputInt (context, 0) (*--** wrong *)

	fun outputName (context, string) =
	    ignore (outputString (context, string))

	fun outputPair (outputX, outputY) (context, (x,y)) =
	    (outputY(context, y);
	     outputX(context, x);
	     outputTuple(context, 2))

	fun outputLocalName x =
            outputOption (outputPair (outputName, outputTyp)) x	

	fun outputAnnotation (context, Simple nLocals) =
	    (outputInt (context, nLocals);
	     outputBlock (context, Label.simple, 1))
	  | outputAnnotation (context, Debug (localNames, typ)) =
	    (outputTyp (context, typ);
	     outputVector outputLocalName (context, localNames);
	     outputBlock (context, Label.debug, 2))

	fun outputReal (context, r) =
	    let
		val vec = UnsafeValue.realToVector r
	    in
		outputChunk (context, vec)
  	    end
  
  	fun outputLabel (context, label) =
 	    outputAtom (context, label)
 	    
  	fun outputName (context, string) =
 	    outputString (context, string)
  
  	fun outputValue (context, V.Prim name) =
 	    (outputString (context, name);
 	     outputString (context, "Alice.primitive.value");
 	     outputTransform context)
 	  | outputValue (context, V.Int i) = 
 	    outputInt (context, i)
  	  | outputValue (context, V.String s) =
 	    outputString (context, s)
 	  | outputValue (context, V.Real r) =
 	    outputReal (context, r)
  	  | outputValue (context, V.TaggedValue (nLabels, i, values)) =
 	    (Vector.app (fn value => outputValue (context, value))
 	     (Vector.rev values);
	     if Label.isBigTagValue(nLabels) then
		 (outputInt (context, i);
 		  outputBlock (context, Label.BIG_TAG,
			       Vector.length values + 1))
	     else
 		 outputBlock (context, Label.TAG i, Vector.length values))
  	  | outputValue (context, V.Tuple values) =
 	    (Vector.app (fn value => outputValue (context, value))
 	     (Vector.rev values);
 	     outputTuple (context, Vector.length values))
  	  | outputValue (context, V.Vector values) =
 	    (Vector.app (fn value => outputValue (context, value))
 	     (Vector.rev values);
  	     outputInt (context, FixedInt.fromInt (Vector.length values));
 	     outputBlock (context, Label.VECTOR, Vector.length values + 1))
  	  | outputValue (context, V.Closure (abstractCode, values)) = 
 	    (Vector.app (fn value => outputValue (context, value))
 	     (Vector.rev values);
  	     outputAbstractCode (context, abstractCode);
 	     outputString (context, "Alice.function");
 	     outputTransform context;
 	     outputClosure (context, 1 + Vector.length values))
  	  | outputValue (context, V.Sign _) =
  	    outputInt (context, 0) (*--** i.e., `NONE' *)


	and outputInstr (context, Entry (coord, entryPoint, instr)) =
	    (outputInstr (context, instr);
	     outputEntryPoint (context, entryPoint);
	     outputCoord (context, coord);
	     outputBlock (context, Label.entry, 3))
	  | outputInstr (context, Exit (coord, exitPoint, idRef, instr)) =
	    (outputIdRef (context, idRef); outputInstr (context, instr);
	     outputExitPoint (context, exitPoint);
	     outputCoord (context, coord);
	     outputBlock (context, Label.exit, 4))
	  | outputInstr (context, Kill (ids, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputId (context, ids);
 	     outputBlock (context, Label.kill, 2))
  	  | outputInstr (context, PutVar (id, idRef, instr)) =
 	    (outputInstr (context, instr);
 	     outputIdRef (context, idRef);
 	     outputId (context, id);
 	     outputBlock (context, Label.putVar, 3))
  	  | outputInstr (context, PutNew (id, s, instr)) =
 	    (outputInstr (context, instr);
 	     outputString (context, s);
 	     outputId (context, id);
 	     outputBlock (context, Label.putNew, 3))
  	  | outputInstr (context, PutTag (id, nLabels, tag, idRefs, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputIdRef (context, idRefs);
 	     outputInt (context, FixedInt.fromInt tag);
	     outputInt (context, FixedInt.fromInt nLabels);
 	     outputId (context, id);
 	     outputBlock (context, Label.putTag, 5))
  	  | outputInstr (context, PutCon (id, idRef, idRefs, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputIdRef (context, idRefs);
 	     outputIdRef (context, idRef);
 	     outputId (context, id);
 	     outputBlock (context, Label.putCon, 4))
  	  | outputInstr (context, PutRef (id, idRef, instr)) =
 	    (outputInstr (context, instr);
 	     outputIdRef (context, idRef);
 	     outputId (context, id);
 	     outputBlock (context, Label.putRef, 3))
  	  | outputInstr (context, PutTup (id, idRefs, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputIdRef (context, idRefs);
  	     outputId (context, id);
 	     outputBlock (context, Label.putTup, 3))
 	  | outputInstr (context, PutPolyRec (id, labels, idRefs, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputIdRef (context, idRefs);
 	     outputVector outputLabel (context, labels);
 	     outputId (context, id);
 	     outputBlock (context, Label.putPolyRec, 4))
  	  | outputInstr (context, PutVec (id, idRefs, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputIdRef (context, idRefs);
 	     outputId (context, id);
 	     outputBlock (context, Label.putVec, 3))
  	  | outputInstr (context, Close (id, idRefs, template, instr)) =
 	    (outputInstr (context, instr);
 	     outputTemplate (context, template);
  	     outputVector outputIdRef (context, idRefs);
  	     outputId (context, id);
 	     outputBlock (context, Label.close, 4))
 	  | outputInstr (context, Specialize (id, idRefs, template, instr)) =
 	    (outputInstr (context, instr);
 	     outputTemplate (context, template);
  	     outputVector outputIdRef (context, idRefs);
 	     outputId (context, id);
 	     outputBlock (context, Label.specialize, 4))
  	  | outputInstr (context, AppPrim (value, idRefs, idDefInstrOpt)) =
 	    (outputOption (fn (context, (idDef, instr)) =>
 			   (outputInstr (context, instr);
  			    outputIdDef (context, idDef);
 			    outputTuple (context, 2)))
 	     (context, idDefInstrOpt);
 	     outputVector outputIdRef (context, idRefs);
 	     outputValue (context, value);
 	     outputBlock (context, Label.appPrim, 3))
  	  | outputInstr (context,
 			 AppVar (idRef, inArgs, isDirectIn, outArgsInstrOpt)) =
 	    (outputOption (fn (context, (outArgs, instr)) =>
 			   (outputInstr (context, instr);
 			    outputVector outputIdDef (context, outArgs);
 			    outputTuple (context, 2)))
 	     (context, outArgsInstrOpt);
 	     outputBool (context, isDirectIn);
 	     outputVector outputIdRef (context, inArgs);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.appVar, 4))
  	  | outputInstr (context, GetRef (id, idRef, instr)) =
 	    (outputInstr (context, instr);
 	     outputIdRef (context, idRef);
 	     outputId (context, id);
 	     outputBlock (context, Label.getRef, 3))
  	  | outputInstr (context, GetTup  (idDefs, idRef, instr)) =
 	    (outputInstr (context, instr);
 	     outputIdRef (context, idRef);
  	     outputVector outputIdDef (context, idDefs);
 	     outputBlock (context, Label.getTup, 3))
  	  | outputInstr (context, Sel (id, idRef, i, instr)) =
 	    (outputInstr (context, instr);
  	     outputInt (context, FixedInt.fromInt i);
  	     outputIdRef (context, idRef);
 	     outputId (context, id); 
 	     outputBlock (context, Label.sel, 4))
 	  | outputInstr (context, LazyPolySel (ids, idRef, labels, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputLabel (context, labels);
 	     outputIdRef (context, idRef);
 	     outputVector outputId (context, ids);
 	     outputBlock (context, Label.lazyPolySel, 4))
  	  | outputInstr (context, Raise idRef) =
 	    (outputIdRef (context, idRef);
 	     outputBlock (context, Label.raise_, 1))
  	  | outputInstr (context, Reraise idRef) =
 	    (outputIdRef (context, idRef);
 	     outputBlock (context, Label.reraise, 1))
  	  | outputInstr (context,
  			 Try (tryInstr, idDef1, idDef2, handleInstr)) =
 	    (outputInstr (context, handleInstr);
 	     outputIdDef (context, idDef2);
 	     outputIdDef (context, idDef1);
 	     outputInstr (context, tryInstr);
 	     outputBlock (context, Label.try, 4))
  	  | outputInstr (context, EndTry instr) =
 	    (outputInstr (context, instr);
 	     outputBlock (context, Label.endTry, 1))
  	  | outputInstr (context, EndHandle instr) =
 	    (outputInstr (context, instr);
 	     outputBlock (context, Label.endHandle, 1))
  	  | outputInstr (context, IntTest (idRef, tests, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector (fn (context, (int, instr)) =>
 			   (outputInstr (context, instr);
 			    outputInt (context, int);
 			    outputTuple (context, 2))) (context, tests);
 	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.intTest, 3))
  	  | outputInstr (context, CompactIntTest (idRef, i, instrs, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector outputInstr (context, instrs);
 	     outputInt (context, i);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.compactIntTest, 4))
 	  | outputInstr (context, RealTest (idRef, tests, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector (fn (context, (real, instr)) =>
 			   (outputInstr (context, instr);
  			    outputReal (context, real);
 			    outputTuple (context, 2))) (context, tests);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.realTest, 3))
 	  | outputInstr (context, StringTest (idRef, tests, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector (fn (context, (string, instr)) =>
 			   (outputInstr (context, instr);
  			    outputString (context, string);
 			    outputTuple (context, 2))) (context, tests);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.stringTest, 3))
 	  | outputInstr (context,
			 TagTest (idRef, nLabels, tests1, tests2, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector (fn (context, (tag, idDefs, instr)) =>
 			   (outputInstr (context, instr);
 			    outputVector outputIdDef (context, idDefs);
 			    outputInt (context, FixedInt.fromInt tag);
 			    outputTuple (context, 3)))
 	     (context, tests2);
 	     outputVector (fn (context, (tag, instr)) =>
 			   (outputInstr (context, instr);
 			    outputInt (context, FixedInt.fromInt tag);
 			    outputTuple (context, 2)))
 	     (context, tests1);
	     outputInt (context, FixedInt.fromInt nLabels);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.tagTest, 5))
 	  | outputInstr (context,
			 CompactTagTest (idRef, nLabels, tests, instrOpt)) =
 	    (outputOption outputInstr (context, instrOpt);
  	     outputVector (fn (context, (idDefsOpt, instr)) =>
 			   (outputInstr (context, instr);
 			    outputOption
 			    (fn (context, idDefs) =>
 			     outputVector
 			     outputIdDef (context, idDefs))
 			    (context, idDefsOpt);
 			    outputTuple (context, 2))) (context, tests);
	     outputInt (context, FixedInt.fromInt nLabels);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.compactTagTest, 4))
 	  | outputInstr (context, ConTest (idRef, tests1, tests2, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector (fn (context, (idRef, idDefs, instr)) =>
 			   (outputInstr (context, instr);
  			    outputVector outputIdDef (context, idDefs);
 			    outputIdRef (context, idRef);
 			    outputTuple (context, 3))) (context, tests2);
 	     outputVector (fn (context, (idRef, instr)) =>
 			   (outputInstr (context, instr);
 			    outputIdRef (context, idRef);
 			    outputTuple (context, 2))) (context, tests1);
  	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.conTest, 4))
 	  | outputInstr (context, VecTest (idRef, tests, instr)) =
 	    (outputInstr (context, instr);
  	     outputVector (fn (context, (idDefs, instr)) =>
 			   (outputInstr (context, instr);
  			    outputVector outputIdDef (context, idDefs);
 			    outputTuple (context, 2))) (context, tests);
 	     outputIdRef (context, idRef);
 	     outputBlock (context, Label.vecTest, 3))
  	  | outputInstr (context as {shared, ...}, Shared (stamp, instr)) =
  	    (case StampMap.lookup (shared, stamp) of
 		 SOME id => outputLoad (context, id)
  	       | NONE =>
  		     let
 			 val id = nextRegister context
  		     in
  			 outputInstr (context, instr);
 			 outputStamp (context, stamp);
 			 outputBlock (context, Label.shared, 2);
 			 outputStore (context, id);
  			 StampMap.insert (shared, stamp, id)
  		     end)
 	  | outputInstr (context, Return idrefs) =
 	    (outputVector outputIdRef (context, idrefs);
 	     outputBlock (context, Label.return, 1))
  	and outputIdRef (context, Immediate value) =
 	    (outputValue (context, value);
 	     outputBlock (context, Label.immediate, 1))
  	  | outputIdRef (context, Local id) =
 	    (outputId (context, id);
 	     outputBlock (context, Label.local_, 1))
  	  | outputIdRef (context, LastUseLocal id) =
 	    (outputId (context, id);
 	     outputBlock (context, Label.lastUseLocal, 1))
  	  | outputIdRef (context, Global i) =
 	    (outputId (context, i);
 	     outputBlock (context, Label.global, 1))
  	and outputTemplate (context, Template (coord, ntoplevels, 
					       localNamesTypOpt,
 					       args, outArityOpt, body,
 					       liveness)) =
 	    (outputLiveness (context, liveness);
 	     outputInstr (context, body);
 	     outputOption outputArity (context, outArityOpt);
 	     outputVector outputIdDef (context, args);
	     outputAnnotation(context, localNamesTypOpt);
 	     outputInt (context, FixedInt.fromInt ntoplevels);
  	     outputCoord (context, coord);
 	     outputBlock (context, Label.template, 7))	     
 	and outputAbstractCode (context, Function (coord, globals, 
						   localNamesTypOpt,
 						   args, outArityOpt, body,
 						   liveness)) =
 	    (outputLiveness (context, liveness);
 	     outputInstr (context, body);
 	     outputOption outputArity (context, outArityOpt);
 	     outputVector outputIdDef (context, args);
	     outputAnnotation(context, localNamesTypOpt);
 	     outputVector (outputOption outputValue) (context, globals);
 	     outputCoord (context, coord);
 	     outputBlock (context, Label.function, 7))
  
	and outputEntryPoint (context, ConEntry (typ, idRef, args)) =
	    (outputVector outputIdRef (context, args);
	     outputIdRef (context, idRef);
	     outputTyp (context, typ); 
	     outputBlock (context, Label.conEntry, 3))
	  | outputEntryPoint (context, SelEntry (i, typ, idRef)) =
	    (outputIdRef (context, idRef);
	     outputTyp (context, typ); 
	     outputInt (context, FixedInt.fromInt i);
	     outputBlock (context, Label.selEntry, 3))
	  | outputEntryPoint (context, StrictEntry (typ, idRef)) =
	    (outputIdRef (context, idRef);
	     outputTyp (context, typ); 
	     outputBlock (context, Label.strictEntry, 2))
	  | outputEntryPoint (context, AppEntry (typ, idRef, args)) =
	    (outputVector outputIdRef (context, args);
	     outputIdRef (context, idRef);
	     outputTyp (context, typ); 
	     outputBlock (context, Label.appEntry, 3))
	  | outputEntryPoint (context, CondEntry (typ, idRef)) =
	    (outputIdRef (context, idRef);
	     outputTyp (context, typ); 
	     outputBlock (context, Label.condEntry, 2))
	  | outputEntryPoint (context, RaiseEntry idRef) =
	    (outputIdRef (context, idRef);
	     outputBlock (context, Label.raiseEntry, 1))
	  | outputEntryPoint (context, HandleEntry idRef) =
	    (outputIdRef (context, idRef);
	     outputBlock (context, Label.handleEntry, 1))
	  | outputEntryPoint (context, SpawnEntry) =
	    outputInt (context, Label.spawnEntry)
	and outputExitPoint (context, ConExit) =
	    outputInt (context, Label.conExit)
	  | outputExitPoint (context, SelExit typ) =
	    (outputTyp (context, typ);
	     outputBlock (context, Label.selExit, 1))
	  | outputExitPoint (context, StrictExit) =
	    outputInt (context, Label.strictExit)
	  | outputExitPoint (context, AppExit) =
	    outputInt (context, Label.appExit)
	  | outputExitPoint (context, CondExit typ) =
	    (outputTyp (context, typ);
	     outputBlock (context, Label.condExit, 1))
	  | outputExitPoint (context, RaiseExit typ) =
	    (outputTyp (context, typ);
	     outputBlock (context, Label.raiseExit, 1))
	  | outputExitPoint (context, HandleExit typ) =
	    (outputTyp (context, typ);
	     outputBlock (context, Label.handleExit, 1))
	  | outputExitPoint (context, SpawnExit typ) =
	    (outputTyp (context, typ);
	     outputBlock (context, Label.spawnExit, 1))

	fun output (outstream, value) =
	    outputValue ({outstream = outstream, shared = StampMap.map ()},
			 value)
    end
