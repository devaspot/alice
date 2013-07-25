val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2005-05-03 14:26:02 $ by $Author: rossberg $
 *   $Revision: 1.55 $
 *)

























functor MkCodeGenPhase(structure AbstractCodeGrammar: ABSTRACT_CODE_GRAMMAR
		       structure Switches: SWITCHES):
    CODE_GEN_PHASE =
    struct
	structure C = MkCodeGenContext(type value = AbstractCodeGrammar.value)
	structure I = FlatGrammar
	structure O = AbstractCodeGrammar

	structure Environment = MkEnvironment(AbstractCodeGrammar)
	structure Liveness = MkLiveness(AbstractCodeGrammar)

	structure IdSet = MkHashImpSet(Int)

	open I
	open Environment
	structure V = O.Value

	fun isNAry (TupArgs #[]) = false
	  | isNAry _ = true

        val maxFixedInt = Int.toLarge (valOf FixedInt.maxInt)
        val fixedIntRange =
            LargeInt.abs (Int.toLarge (valOf FixedInt.minInt)) +
            maxFixedInt + Int.toLarge 1
	    handle Overflow => Int.toLarge 0 (* if LargeInt = FixedInt *)

	fun translateLit (IntLit (region, i)) =
            (V.int (FixedInt.fromLarge i) (*--** IntInf? *)
             handle Overflow =>
                    Error.error' (region, "integer literal out of range"))
	  | translateLit (WordLit (region, w)) =
            (let
                 val li = LargeWord.toLargeIntX w
             in
                 if li > maxFixedInt then
                     V.int (FixedInt.fromLarge (li - fixedIntRange))
                 else
                     V.int (FixedInt.fromLarge li)
             end
             handle Overflow =>
                    Error.error' (region, "word literal out of range"))
	  | translateLit (CharLit (region, c)) =
	    V.int (FixedInt.fromInt (Char.ord c))
	  | translateLit (StringLit (region, s)) = V.string s
	  | translateLit (RealLit (region, r)) = V.real r

	fun litToInt (IntLit (region, i)) =
            (Int.fromLarge i (*-** IntInf? *)
             handle Overflow =>
                    Error.error' (region, "integer literal out of range"))
	  | litToInt (WordLit (region, w)) =
            (LargeWord.toInt w
             handle Overflow =>
                    Error.error' (region, "word literal out of range"))
	  | litToInt (CharLit (region, c)) = Char.ord c
	  | litToInt (StringLit _ | RealLit _) =
	    raise Crash.Crash "CodeGenPhase.litToInt string | real"

	fun translateIdRef (idRef as (IdRef _ | LastIdRef _), env) =
	    lookup (env, idRef)
	  | translateIdRef (Lit lit, _) = O.Immediate (translateLit lit)
	  | translateIdRef (Prim name, _) = O.Immediate (V.prim name)
	  | translateIdRef (Value (value, _), _) =
	    O.Immediate (V.reflected value)

	fun translateIdRefs (idRefs, env) =
	    Vector.map (fn idRef => translateIdRef (idRef, env)) idRefs

	fun translateIdDef (IdDef id, env) = O.IdDef (declare (env, id))
	  | translateIdDef (Wildcard, _) = O.Wildcard

	fun translateArgs f (OneArg x, env) = #[(f (x, env))]
	  | translateArgs f (TupArgs xs, env) =
	    Vector.map (fn x => f (x, env)) xs
	  | translateArgs f (ProdArgs labelXVec, env) =
	    Vector.map (fn (_, x) => f (x, env)) labelXVec

	fun translateEmptyTupArgs env =
	    let
		val id = fresh env
	    in
		O.PutTup (id, #[], O.Return (#[(O.LastUseLocal id)]))
	    end

	fun translateSingletonTupArgs (idRef, env) =
	    let
		val id = fresh env
	    in
		O.PutTup (id, #[translateIdRef(idRef, env)],
			  O.Return (#[(O.LastUseLocal id)]))
	    end

	fun argsToVector (OneArg x) = #[x]
	  | argsToVector (TupArgs xs) = xs
	  | argsToVector (ProdArgs labelXVec) = Vector.map #2 labelXVec

	fun translateConArgs (args, env) =
	    Vector.map (fn idDef => translateIdDef (idDef, env))
	    (argsToVector args)

	fun isId (O.Immediate _, _) = false
	  | isId (O.Local id', id) = id' = id
	  | isId (O.LastUseLocal id', id) = id' = id
	  | isId (O.Global _, _) = false

	fun isIdInVec (idRefs, id) =
	    Vector.exists (fn idRef => isId (idRef, id)) idRefs

	fun getLocal (O.Immediate _) = NONE
	  | getLocal (O.Local id) = SOME id
	  | getLocal (O.LastUseLocal id) = SOME id
	  | getLocal (O.Global _) = NONE

	(*
	 * Function `detup' tries to find out whether the value referenced
	 * by a given identifier can actually be represented `flat', i.e.,
	 * by storing tuples in deconstructed form (component-wise).
	 *
	 * This is allowed if, in the instruction stream, we can see
	 * a deconstruction (GetTup) that will definitely be performed,
	 * and this before any side-effect - else we might corrupt the
	 * order of side-effects.  Furthermore, it is checked that the
	 * (constructed) value is not used again after this point.
	 *
	 * The implementation computes an approximation.
	 *)

	datatype detup_result =
	    USED
	  | SIDE_EFFECTING
	  | UNKNOWN
	  | KILLED
	  | DECONSTRUCTED of O.idDef vector * O.instr

	fun detup' (DECONSTRUCTED (idDefs, instr), f) =
	    DECONSTRUCTED (idDefs, f instr)
	  | detup' (result, _) = result

	fun detup (O.Entry (_, _, _), _) = UNKNOWN
	  | detup (O.Exit (_, _, _, _), _) = UNKNOWN
	  | detup (O.Kill (ids, instr), id) =
	    if Vector.exists (fn id' => id = id') ids then KILLED
	    else detup' (detup (instr, id), fn instr => O.Kill (ids, instr))
	  | detup (O.PutVar (id, idRef, instr), id') =
	    if isId (idRef, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.PutVar (id, idRef, instr))
	  | detup (O.PutNew (id, s, instr), id') =
	    detup' (detup (instr, id'), fn instr => O.PutNew (id, s, instr))
	  | detup (O.PutTag (id, nLabels, tag, idRefs, instr), id') =
	    if isIdInVec (idRefs, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.PutTag (id, nLabels, tag, idRefs, instr))
	  | detup (O.PutCon (_, _, _, _), _) = SIDE_EFFECTING
	  | detup (O.PutRef (id, idRef, instr), id') =
	    if isId (idRef, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.PutRef (id, idRef, instr))
	  | detup (O.PutTup (id, idRefs, instr), id') =
	    if isIdInVec (idRefs, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.PutTup (id, idRefs, instr))
	  | detup (O.PutPolyRec (id, labels, idRefs, instr), id') =
	    if isIdInVec (idRefs, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.PutPolyRec (id, labels, idRefs, instr))
	  | detup (O.PutVec (id, idRefs, instr), id') =
	    if isIdInVec (idRefs, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.PutVec (id, idRefs, instr))
	  | detup (O.Close (id, idRefs, value, instr), id') =
	    if isIdInVec (idRefs, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.Close (id, idRefs, value, instr))
	  | detup (O.Specialize (id, idRefs, template, instr), id') =
	    if isIdInVec (idRefs, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr =>
			    O.Specialize (id, idRefs, template, instr))
	  | detup (O.AppPrim (_, _, _), _) = SIDE_EFFECTING
	  | detup (O.AppVar (_, _, _, _), _) = SIDE_EFFECTING
	  | detup (O.GetRef (_, _, _), _) = SIDE_EFFECTING
	  | detup (O.GetTup (idDefs, idRef, instr), id) =
	    if isId (idRef, id) then
		case detup (instr, id) of
		    DECONSTRUCTED (_, _) => USED
		  | KILLED => DECONSTRUCTED (idDefs, instr)
		  | res as (USED | SIDE_EFFECTING | UNKNOWN) => res
	    else detup' (detup (instr, id),
			 fn instr => O.GetTup (idDefs, idRef, instr))
	  | detup (O.Sel (id, idRef, i, instr), id') =
	    (*--** unless we annotate the width, we can only return USED *)
	    if isId (idRef, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.Sel (id, idRef, i, instr))
	  | detup (O.LazyPolySel (ids, idRef, labels, instr), id') =
	    if isId (idRef, id') then USED
	    else detup' (detup (instr, id'),
			 fn instr => O.LazyPolySel (ids, idRef, labels, instr))
	  | detup (O.Raise idRef, id) =
	    if isId (idRef, id) then USED else KILLED
	  | detup (O.Reraise idRef, id) =
	    if isId (idRef, id) then USED else KILLED
	  | detup (O.Try (_, _, _, _), _) = UNKNOWN
	  | detup (O.EndTry _, _) = UNKNOWN
	  | detup (O.EndHandle _, _) = UNKNOWN
	  | detup (O.IntTest (_, _, _), _) = UNKNOWN
	  | detup (O.CompactIntTest (_, _, _, _), _) = UNKNOWN
	  | detup (O.RealTest (_, _, _), _) = UNKNOWN
	  | detup (O.StringTest (_, _, _), _) = UNKNOWN
	  | detup (O.TagTest (_, _, _, _, _), _) = UNKNOWN
	  | detup (O.CompactTagTest (_, _, _, _), _) = UNKNOWN
	  | detup (O.ConTest (_, _, _, _), _) = UNKNOWN
	  | detup (O.VecTest (_, _, _), _) = UNKNOWN
	  | detup (O.Shared (_, _), _) = UNKNOWN
	  | detup (O.Return idRefs, id) =
	    if isIdInVec (idRefs, id) then USED else KILLED

	fun translateLabel label = Atom.atom (Label.toString label)

	fun translatePolyProd (labelIdRefVec, env) =
	    let
		val n = Vector.length labelIdRefVec
		val layout = Array.array (n, NONE)

		fun insertPolyProd (label, idRef) =
		    insertPolyProd' (Atom.hash label mod n, (label, idRef))
		and insertPolyProd' (i, entry) =
		    case Array.sub (layout, i) of
			SOME _ => insertPolyProd' ((i + 1) mod n, entry)
		      | NONE => Array.update (layout, i, SOME entry)
	    in
		Vector.app (fn (label, idRef) =>
			       insertPolyProd (translateLabel label,
					       translateIdRef (idRef, env)))
			   labelIdRefVec;
		(Vector.tabulate
		     (n, fn i => #1 (Option.valOf (Array.sub (layout, i)))),
		 Vector.tabulate
		     (n, fn i => #2 (Option.valOf (Array.sub (layout, i)))))
	    end

	fun mergeIdRefs (idRef as O.Local id, O.Local id') =
	    if id = id' then SOME idRef else NONE
	  | mergeIdRefs (idRef as O.LastUseLocal id,
			 (O.Local id' | O.LastUseLocal id')) =
	    if id = id' then SOME idRef else NONE
	  | mergeIdRefs (O.Local id, idRef as O.LastUseLocal id') =
	    if id = id' then SOME idRef else NONE
	  | mergeIdRefs (idRef as O.Global id, O.Global id') =
	    if id = id' then SOME idRef else NONE
	  | mergeIdRefs (_, _) = NONE

	fun vecCons (x, xs) =
	    Vector.tabulate (Vector.length xs + 1,
			     fn 0 => x | i => Vector.sub (xs, i - 1))

	fun lazyPolySel (id, idRef, label, instr as
			 O.LazyPolySel (ids, idRef', labels, instr')) =
	    (case mergeIdRefs (idRef, idRef') of
		 SOME idRef =>
		     O.LazyPolySel (vecCons (id, ids), idRef,
				    vecCons (label, labels), instr')
	       | NONE => O.LazyPolySel (#[id], idRef, #[label], instr))
	  | lazyPolySel (id, idRef, label, instr) =
	    O.LazyPolySel (#[id], idRef, #[label], instr)

	structure IdSet' = IntermediateAux.IdSet

	fun translateEntryPoint (ConEntry (typ, idRef, args), env) =
	    O.ConEntry (typ, translateIdRef (idRef, env),
			translateArgs translateIdRef (args, env))
	  | translateEntryPoint (SelEntry (_, _, i, typ, idRef), env) =
	    O.SelEntry (i, typ, translateIdRef (idRef, env))
	  | translateEntryPoint (StrictEntry (typ, idRef), env) =
	    O.StrictEntry (typ, translateIdRef (idRef, env))
	  | translateEntryPoint (AppEntry (typ, idRef, args), env) =
	    O.AppEntry (typ, translateIdRef (idRef, env),
			translateArgs translateIdRef (args, env))
	  | translateEntryPoint (CondEntry (typ, idRef), env) =
	    O.CondEntry (typ, translateIdRef (idRef, env))
	  | translateEntryPoint (RaiseEntry idRef, env) =
	    O.RaiseEntry (translateIdRef (idRef, env))
	  | translateEntryPoint (HandleEntry idRef, env) =
	    O.HandleEntry (translateIdRef (idRef, env))
	  | translateEntryPoint (SpawnEntry, _) = O.SpawnEntry

	fun translateExitPoint ConExit = O.ConExit
	  | translateExitPoint (SelExit typ) = O.SelExit typ
	  | translateExitPoint StrictExit = O.StrictExit
	  | translateExitPoint AppExit = O.AppExit
	  | translateExitPoint (CondExit typ) = O.CondExit typ
	  | translateExitPoint (RaiseExit typ) = O.RaiseExit typ
	  | translateExitPoint (HandleExit typ) = O.HandleExit typ
	  | translateExitPoint (SpawnExit typ) = O.SpawnExit typ

	fun idEq (Id (_, stamp, _), Id (_, stamp', _)) = stamp = stamp'

	fun translateBody ([stm], env) = translateStm (stm, env)
	  | translateBody ((stm as ValDec (_, IdDef id, exp))::
			   (stms as [RaiseStm (_, LastIdRef id')]), env) =
	    if idEq (id, id') then
		case exp of
		    VarExp (_, idRef) => O.Raise (translateIdRef (idRef, env))
		  | ConExp (_, idRef, TupArgs #[]) =>
			O.Raise (translateIdRef (idRef, env))
		  | _ => translateBody' (stm, stms, env)
	    else translateBody' (stm, stms, env)
	  | translateBody (stm::stms, env) = translateBody' (stm, stms, env)
	  | translateBody (nil, _) =
	    raise Crash.Crash "CodeGenPhase.translateBody"
	and translateBody' (stm, stms, env) =
	    (doDec (stm, env);
	     translateDec (stm, translateBody (stms, env), env))
	and doDec (Entry (_, _), _) = ()
	  | doDec (Exit (_, _, _), _) = ()
	  | doDec (LastUse (_, _), _) = ()
	  | doDec (ValDec (_, IdDef id, _), env) = ignore (declare (env, id))
	  | doDec (ValDec (_, Wildcard, _), _) = ()
	  | doDec (RecDec (_, idDefExpVec), env) =
	    Vector.app (fn (IdDef id, _) => ignore (declare (env, id))
			 | (Wildcard, _) => ()) idDefExpVec
	  | doDec (RefDec (_, IdDef id, _), env) = ignore (declare (env, id))
	  | doDec (RefDec (_, Wildcard, _), _) = ()
	  | doDec (TupDec (_, idDefs, _), env) =
	    Vector.app (fn idDef =>
			case idDef of
			    IdDef id => ignore (declare (env, id))
			  | Wildcard => ()) idDefs
	  | doDec (ProdDec (info, labelIdDefVec, idRef), env) =
	    doDec (TupDec (info, Vector.map #2 labelIdDefVec, idRef), env)
	  | doDec ((RaiseStm (_, _) | ReraiseStm (_, _) |
		    TryStm (_, _, _, _, _) | EndTryStm (_, _) |
		    EndHandleStm (_, _) | TestStm (_, _, _, _) |
		    SharedStm (_, _, _) | ReturnStm (_, _) |
		    IndirectStm (_, _) | ExportStm (_, _)), _) =
	    raise Crash.Crash "CodeGenPhase.doDec"
	and translateDec (Entry (((i, j), _), entryPoint), instr, env) =
	    O.Entry ((filename env, i, j),
		     translateEntryPoint (entryPoint, env), instr)
	  | translateDec (Exit ((_, (i, j)), exitPoint, idRef), instr, env) =
	    O.Exit ((filename env, i, j), translateExitPoint exitPoint,
		    translateIdRef (idRef, env), instr)
	  | translateDec (LastUse (_, ids), instr, env) =
	    (*--** sort them? represent as ranges? *)
	    let
		val ids =
		    Vector.foldr (fn (id, rest) =>
				     case weakLookup (env, LastIdRef id) of
					 SOME id => id::rest
				       | NONE => rest) nil ids
	    in
		case Vector.fromList ids of
		    #[] => instr
		  | ids => O.Kill (ids, instr)
	    end
	  | translateDec (ValDec (_, IdDef id, exp), instr, env) =
	    translateExp (exp, declare (env, id), instr, env)
	  | translateDec (ValDec (_, Wildcard, exp), instr, env) =
	    translateIgnore (exp, instr, env)
	  | translateDec (RecDec (_, #[]), instr, _) = instr
	  | translateDec (RecDec (_, idDefExpVec), instr, env) =
	    let
		val unallocated = IdSet'.set ()
	    in
		Vector.app (fn (IdDef id, _) =>
			       IdSet'.insertDisjoint (unallocated, id)
			     | (Wildcard, _) => ()) idDefExpVec;
		recToHoles (Vector.toList idDefExpVec, env, unallocated,
			    IdSet'.set (), instr)
	    end
	  | translateDec (RefDec (_, IdDef id, idRef), instr, env) =
	    O.GetRef (declare (env, id), translateIdRef (idRef, env), instr)
	  | translateDec (RefDec (_, Wildcard, idRef), instr, env) =
	    O.AppPrim (V.prim "Future.await", #[translateIdRef (idRef, env)],
		       SOME (O.Wildcard, instr))
	  | translateDec (TupDec (_, idDefs, idRef), instr, env) =
	    let
		fun f id = translateIdDef (id, env)
	    in
		O.GetTup (Vector.map f idDefs, translateIdRef (idRef, env),
			  instr)
	    end
	  | translateDec (ProdDec (info, labelIdDefVec, idRef), instr, env) =
	    translateDec (TupDec (info, Vector.map #2 labelIdDefVec, idRef),
			  instr, env)
	  | translateDec ((RaiseStm (_, _) | ReraiseStm (_, _) |
			   TryStm (_, _, _, _, _) | EndTryStm (_, _) |
			   EndHandleStm (_, _) | TestStm (_, _, _, _) |
			   SharedStm (_, _, _) | ReturnStm (_, _) |
			   IndirectStm (_, _) | ExportStm (_, _)), _, _) =
	    raise Crash.Crash "CodeGenPhase.translateDec"
	and recToHoles ((idDef, exp)::rest, env, unallocated, forward, instr) =
	    let
		val toAllocate = IntermediateAux.getUsedVars (exp, unallocated)
		val _ =
		    IdSet'.app (fn id =>
				   (IdSet'.removeExistent (unallocated, id);
				    IdSet'.insertDisjoint (forward, id)))
			       toAllocate
		val _ = case idDef of
			    IdDef id => IdSet'.remove (unallocated, id)
			  | Wildcard => ()
		val instr = recToHoles (rest, env, unallocated, forward, instr)
		val instr =
		    case idDef of
			IdDef id =>
			    if IdSet'.member (forward, id) then
				let
				    val id' = fresh env
				    val instr =
					O.AppPrim (V.prim "Hole.fill",
						   #[O.Local
							 (declare (env, id)),
						     O.LastUseLocal id'],
						   SOME (O.Wildcard, instr))
				in
				    translateExp (exp, id', instr, env)
				end
			    else translateExp (exp, declare (env, id),
					       instr, env)
		      | Wildcard => translateIgnore (exp, instr, env)
	    in
		IdSet'.fold
		    (fn (id, instr) =>
			O.AppPrim (V.prim "Hole.hole", #[],
				   SOME (O.IdDef (declare (env, id)), instr)))
		    instr toAllocate
	    end
	  | recToHoles (nil, _, unallocated, _, instr) =
	    (assert (IdSet'.isEmpty unallocated); instr)
	and translateStm ((Entry (_, _) | Exit (_, _, _) |
			   LastUse (_, _) | ValDec (_, _, _) |
			   RecDec (_, _) | RefDec (_, _, _) |
			   TupDec (_, _, _) | ProdDec (_, _, _)), _) =
	    raise Crash.Crash "CodeGenPhase.translateStm"
	  | translateStm (RaiseStm (_, idRef), env) =
	    O.Raise (translateIdRef (idRef, env))
	  | translateStm (ReraiseStm (_, idRef), env) =
	    O.Reraise (translateIdRef (idRef, env))
	  | translateStm (TryStm (_, tryBody, idDef1, idDef2, handleBody),
			  env) =
	    O.Try (translateBody (tryBody, env),
		   translateIdDef (idDef1, env),
		   translateIdDef (idDef2, env),
		   translateBody (handleBody, env))
	  | translateStm (EndTryStm (_, body), env) =
	    O.EndTry (translateBody (body, env))
	  | translateStm (EndHandleStm (_, body), env) =
	    O.EndHandle (translateBody (body, env))
	  | translateStm (TestStm (_, _, LitTests #[], elseBody), env) =
	    translateBody (elseBody, env)
	  | translateStm (TestStm (_, idRef, LitTests litTests, elseBody),
			  env) =
	    (case Vector.sub (litTests, 0) of
		 ((IntLit _ | WordLit _ | CharLit _), _) =>
		     translateIntTest (idRef, litTests, elseBody, env)
	       | (StringLit _, _) =>
		     O.StringTest
		     (translateIdRef (idRef, env),
		      Vector.map (fn (lit, body) =>
				  case lit of StringLit (_, s) =>
				      (s, translateBody (body, env))
				    | _ => raise Match) litTests,
		      translateBody (elseBody, env))
	       | (RealLit _, _) =>
		     O.RealTest
		     (translateIdRef (idRef, env),
		      Vector.map (fn (lit, body) =>
				  case lit of RealLit (_, r) =>
				      (r, translateBody (body, env))
				    | _ => raise Match) litTests,
		      translateBody (elseBody, env)))
	  | translateStm (TestStm (_, idRef,
				   TagTests (labels, tagTests), elseBody),
			  env) =
	    translateTagTest (idRef, labels, tagTests, elseBody, env)
	  | translateStm (TestStm (_, idRef, ConTests conTests, elseBody),
			  env) =
	    let
		val (naryTests, nullaryTests) =
		    List.partition (fn (_, args, _) => isNAry args)
				   (Vector.toList conTests)
	    in
		O.ConTest (translateIdRef (idRef, env),
			   Vector.map (fn (idRef', _, body) =>
				       (translateIdRef (idRef', env),
					translateBody (body, env)))
				      (Vector.fromList nullaryTests),
			   Vector.map (fn (idRef', args, body) =>
				       (translateIdRef (idRef', env),
					translateConArgs (args, env),
					translateBody (body, env)))
				      (Vector.fromList naryTests),
			   translateBody (elseBody, env))
	    end
	  | translateStm (TestStm (_, idRef, VecTests vecTests, elseBody),
			  env) =
	    O.VecTest (translateIdRef (idRef, env),
		       Vector.map
			   (fn (idDefs, body) =>
			       (Vector.map (fn idDef =>
					       translateIdDef (idDef, env))
					   idDefs,
					   translateBody (body, env)))
			   vecTests,
		       translateBody (elseBody, env))
	  | translateStm (SharedStm (_, body, stamp), env) =
	    (case lookupShared (env, stamp) of
		 SOME instr => instr
	       | NONE =>
		     let
			 val instr =
			     O.Shared (stamp, translateBody (body, env))
		     in
			 declareShared (env, stamp, instr); instr
		     end)
	  | translateStm (ReturnStm (_, VarExp (_, idRef)), env) =
	    O.Return (#[(translateIdRef (idRef, env))])
	  | translateStm (ReturnStm (_, TagExp (_, _, tag, TupArgs #[])), _) =
	    O.Return (#[(O.Immediate (V.int (FixedInt.fromInt tag)))])
	  | translateStm (ReturnStm (_, ConExp (_, idRef, TupArgs #[])), env) =
	    O.Return (#[(translateIdRef (idRef, env))])
	  | translateStm (ReturnStm (_, TupExp (_, #[])), env) =
	    translateEmptyTupArgs env
	  | translateStm (ReturnStm (_, TupExp (_, #[idRef])), env) =
	    translateSingletonTupArgs (idRef, env)
	  | translateStm (ReturnStm (_, TupExp (_, idRefs)), env) =
	    O.Return (translateIdRefs (idRefs, env))
	  | translateStm (ReturnStm (_, ProdExp (_, #[labelIdRef])), env) =
	    translateSingletonTupArgs (#2 labelIdRef, env)
	  | translateStm (ReturnStm (_, ProdExp (_, labelIdRefVec)), env) =
	    O.Return (Vector.map (fn (_, idRef) =>
				     translateIdRef (idRef, env))
				 labelIdRefVec)
	  | translateStm (ReturnStm (_, PrimAppExp (_, name, idRefs)), env) =
	    O.AppPrim (V.prim name, translateIdRefs (idRefs, env), NONE)
	  | translateStm (ReturnStm (_, VarAppExp (_, idRef, args)), env) =
	    O.AppVar (translateIdRef (idRef, env),
		      translateArgs translateIdRef (args, env),
		      false, NONE)
	  | translateStm (ReturnStm (_, DirectAppExp (_, idRef, args)), env) =
	    O.AppVar (translateIdRef (idRef, env),
		      translateArgs translateIdRef (args, env),
		      true, NONE)
	  | translateStm (ReturnStm (_, FunAppExp (_, idRef, _, args)), env) =
	    O.AppVar (translateIdRef (idRef, env),
		      translateArgs translateIdRef (args, env),
		      true, NONE)
	  | translateStm (ReturnStm (_, exp), env) =
	    let
		val id = fresh env
	    in
		translateExp (exp, id, O.Return (#[(O.LastUseLocal id)]), env)
	    end
	  | translateStm (IndirectStm (_, ref bodyOpt), env) =
	    translateBody (valOf bodyOpt, env)
	  | translateStm (ExportStm (info, exp), env) =
	    translateStm (ReturnStm (info, exp), env)
	and translateExp (NewExp (_, name), id, instr, _) =
	    let
		val s = Name.toString name
		val s = if String.size s > 0 andalso String.sub (s, 0) = #"'"
			then String.extract (s, 1, NONE) else s
	    in
		O.PutNew (id, s, instr)
	    end
	  | translateExp (VarExp (_, idRef), id, instr, env) =
	    O.PutVar (id, translateIdRef (idRef, env), instr)
	  | translateExp (TagExp (_, _, tag, TupArgs #[]), id, instr, _) =
	    O.PutVar (id, O.Immediate (V.int (FixedInt.fromInt tag)), instr)
	  | translateExp (TagExp (_, labels, tag, args), id, instr, env) =
	    O.PutTag (id, Vector.length labels, 
		      tag, translateIdRefs (argsToVector args, env), instr)
	  | translateExp (ConExp (_, idRef, TupArgs #[]), id, instr, env) =
	    O.PutVar (id, translateIdRef (idRef, env), instr)
	  | translateExp (ConExp (_, idRef, args), id, instr, env) =
	    O.PutCon (id, translateIdRef (idRef, env),
		      translateIdRefs (argsToVector args, env), instr)
	  | translateExp (TupExp (_, idRefs), id, instr, env) =
	    O.PutTup (id, translateIdRefs (idRefs, env), instr)
	  | translateExp (ProdExp (info, labelIdRefVec), id, instr, env) =
	    translateExp (TupExp (info, Vector.map #2 labelIdRefVec),
			  id, instr, env)
	  | translateExp (PolyProdExp (info, labelIdRefVec), id, instr, env) =
	    let
		val (labels, idRefs) = translatePolyProd (labelIdRefVec, env)
	    in
		O.PutPolyRec (id, labels, idRefs, instr)
	    end
	  | translateExp (VecExp (_, idRefs), id, instr, env) =
	    O.PutVec (id, translateIdRefs (idRefs, env), instr)
	  | translateExp (FunExp (region, _, flags, typ, args, 
				  outArityOpt, body),
			  id, instr, env) =
	    let
		val isSpecialize =
		    List.exists (fn IsToplevel => true | _ => false) flags
		val _ = startFn env
		val (args, body) =
		    case args of
		        (* if we still had enough type information here,
			 * we could also transform
			 *   (OneArg Wildcard) => (TupArgs #[], body)
			 * whenever arg has type unit.
			 *)
			(TupArgs #[] | ProdArgs #[]) =>
			let
			    val idInfo = {region = region, typ = Type.tuple #[]}
			    val id = Id (idInfo, Stamp.stamp (), Name.InId)
			    val args' = OneArg (IdDef id)
			    val body' = TupDec (region, #[], IdRef id)::
			    		LastUse (region, #[id])::body
			in
			    (args', body')
			end
		      | _ => (args, body)
			
		val args' = translateArgs translateIdDef (args, env)
		val bodyInstr = translateBody (body, env)
		val liveness = Liveness.analyze (args', bodyInstr)
		val (globalIds, localNames) = endFn env
		val kills = IdSet.set ()
		val instr =
		    case instr of
			O.Kill (ids, instr) =>
			    (Vector.app
				 (fn id => IdSet.insert (kills, id)) ids;
			     instr)
		      | _ => instr
		val globalIdRefs =
		    Vector.map
			(fn idRef as O.Local id =>
			    if IdSet.member (kills, id) then
				(IdSet.remove (kills, id); O.LastUseLocal id)
			    else idRef
			  | idRef => idRef)
			(translateIdRefs (Vector.map IdRef globalIds, env))
		val ((i, j), _) = region
		val coord = (filename env, i, j)
		val instr =
		    case Vector.fromList (IdSet.fold op:: nil kills) of
			#[] => instr
		      | ids => O.Kill (ids, instr)
		val outArityOpt' =
		    case outArityOpt of
			NONE => NONE
		      | SOME (Arity.Unary) => SOME 1
		      | SOME (Arity.Tuple n) => SOME n
		      | SOME (Arity.Product labels) =>
			    SOME (Vector.length labels)
		val template =
		    O.Template (coord, Vector.length globalIdRefs,
				if (!Switches.CodeGen.debugMode)
				    then O.Debug(localNames, typ)
				else O.Simple(Vector.length localNames), 
				args', outArityOpt', bodyInstr, liveness)
	    in
		if isSpecialize then
		    O.Specialize (id, globalIdRefs, template, instr)
		else
		    O.Close (id, globalIdRefs, template, instr)
	    end
	  | translateExp (PrimAppExp (_, name, idRefs), id, instr, env) =
	    O.AppPrim (V.prim name, translateIdRefs (idRefs, env),
		       SOME (O.IdDef id, instr))
	  | translateExp (VarAppExp (_, idRef, args), id, instr, env) =
	    translateVarAppExp (idRef, args, false, id, instr, env)
	  | translateExp (DirectAppExp (_, idRef, args), id, instr, env) =
	    translateVarAppExp (idRef, args, true, id, instr, env)
	  | translateExp (RefExp (_, idRef), id, instr, env) =
	    O.PutRef (id, translateIdRef (idRef, env), instr)
	  | translateExp (SelExp (_, _, _, i, idRef), id, instr, env) =
	    O.Sel (id, translateIdRef (idRef, env), i, instr)
	  | translateExp (LazyPolySelExp (_, label, idRef), id, instr, env) =
	    lazyPolySel (id, translateIdRef (idRef, env),
			 translateLabel label, instr)
	  | translateExp (FunAppExp (info, idRef, _, args), id, instr, env) =
	    translateVarAppExp (idRef, args, true, id, instr, env)
	  | translateExp (FailExp info, id, instr, env) = (*--** implement *)
	    raise Crash.Crash "CodeGenPhase.translateExp: FailExp"
	and translateVarAppExp (idRef, args, isDirectIn, id, instr, env) =
	    let
		val (returnArgs, instr) =
		    case detup (instr, id) of
			DECONSTRUCTED (idDefs, instr) =>
			     (assert (Vector.length idDefs <> 1);
			      (idDefs, instr))
		      | (USED | SIDE_EFFECTING | UNKNOWN) =>
			    (#[(O.IdDef id)], instr)
		      | KILLED => (#[O.Wildcard], instr)
	    in
		O.AppVar (translateIdRef (idRef, env),
			  translateArgs translateIdRef (args, env),
			  isDirectIn,
			  SOME (returnArgs, instr))
	    end
	and translateIgnore (NewExp (_, _), instr, _) = instr
	  | translateIgnore (VarExp (_, _), instr, _) = instr
	  | translateIgnore (TagExp (_, _, _, _), instr, _) = instr
	  | translateIgnore (ConExp (_, _, TupArgs #[]), instr, _) = instr
	  | translateIgnore (ConExp (_, idRef, _), instr, env) =
	    O.AppPrim (V.prim "Future.await", #[translateIdRef (idRef, env)],
		       SOME (O.Wildcard, instr))
	  | translateIgnore (RefExp (_, _), instr, _) = instr
	  | translateIgnore (TupExp (_, _), instr, _) = instr
	  | translateIgnore (ProdExp (_, _), instr, _) = instr
	  | translateIgnore (PolyProdExp (_, _), instr, _) = instr
	  | translateIgnore (VecExp (_, _), instr, _) = instr
	  | translateIgnore (FunExp (_, _, _, _, _, _, _), instr, _) = instr
	  | translateIgnore (PrimAppExp (_, name, idRefs), instr, env) =
	    O.AppPrim (V.prim name, translateIdRefs (idRefs, env),
		       SOME (O.Wildcard, instr))
	  | translateIgnore (VarAppExp (_, idRef, args), instr, env) =
	    O.AppVar (translateIdRef (idRef, env),
		      translateArgs translateIdRef (args, env),
 		      false,
 		      SOME (#[O.Wildcard], instr))
	  | translateIgnore (DirectAppExp (_, idRef, args), instr, env) =
 	    O.AppVar (translateIdRef (idRef, env),
 		      translateArgs translateIdRef (args, env),
 		      true,
 		      SOME (#[O.Wildcard], instr))
	  | translateIgnore (SelExp (_, _, _, _, idRef), instr, env) =
	    O.AppPrim (V.prim "Future.await", #[translateIdRef (idRef, env)],
		       SOME (O.Wildcard, instr))
	  | translateIgnore (LazyPolySelExp (_, _, _), instr, _) = instr
	  | translateIgnore (FunAppExp (info, idRef, _, args), instr, env) =
	    O.AppVar (translateIdRef (idRef, env),
		      translateArgs translateIdRef (args, env),
		      true,
		      SOME (#[O.Wildcard], instr))
	  | translateIgnore (FailExp _, instr, _) = instr
	and translateIntTest (idRef, litTests, elseBody, env) =
	    let
		val idRef = translateIdRef (idRef, env)
		val map = IntMap.map ()
		val tests =
		    Vector.map (fn (lit, body) =>
				   (litToInt lit, translateBody (body, env)))
			       litTests
		val (i, _) = Vector.sub (tests, 0)
		val (min, max) =
		    Vector.foldl (fn ((i, instr), (min, max)) =>
				     (IntMap.insert (map, i, instr);
				      (Int.min (i, min),
				       Int.max (i, max))))
				 (i, i) tests
		val span = max - min + 1
		val elseInstr = translateBody (elseBody, env)
	    in
		if span = Vector.length tests then
		    let
			fun lookup i =
			    IntMap.lookupExistent
				(map, i + min)
		    in
			O.CompactIntTest (idRef, min,
					  Vector.tabulate (span, lookup),
					  elseInstr)
		    end
		else O.IntTest (idRef, tests, elseInstr)
	    end
	and translateTagTest (idRef, labels, tagTests, elseBody, env) =
	    let
		val idRef = translateIdRef (idRef, env)
		val (naryTests, nullaryTests) =
		    List.partition (fn (_, args, _) => isNAry args)
				   (Vector.toList tagTests)
		val nullaryTests =
		    Vector.map (fn (tag, _, body) =>
				   (tag, translateBody (body, env)))
			       (Vector.fromList nullaryTests)
		val naryTests =
		    Vector.map (fn (tag, args, body) =>
				   (tag, translateConArgs (args, env),
				    translateBody (body, env)))
			       (Vector.fromList naryTests)
		val map = IntMap.map ()
		val (i, _, _) = Vector.sub (tagTests, 0)
		val (min, max) =
		    Vector.foldl (fn ((i, instr), (min, max)) =>
				     (IntMap.insert (map, i, (NONE, instr));
				      (Int.min (i, min),
				       Int.max (i, max))))
				 (i, i) nullaryTests
		val (min, max) =
		    Vector.foldl (fn ((i, idDefs, instr), (min, max)) =>
				     (IntMap.insert
					  (map, i, (SOME idDefs, instr));
				      (Int.min (i, min),
				       Int.max (i, max))))
				 (min, max) naryTests
		val elseInstr = translateBody (elseBody, env)
		val nLabels = Vector.length labels
	    in
		if min = 0 andalso max + 1 = Vector.length tagTests then
		    let
			fun lookup i = IntMap.lookupExistent (map, i)
		    in
			O.CompactTagTest (idRef,
					  nLabels,
					  Vector.tabulate (max + 1, lookup),
					  if nLabels = max + 1
					  then NONE
					  else SOME elseInstr)
		    end
		else O.TagTest (idRef, nLabels, nullaryTests, naryTests,
				elseInstr)
	    end

	fun urlToString url =
	    case (Url.getScheme url, Url.getAuthority url) of
		((NONE | SOME "file"), NONE) =>
		OS.Path.mkRelative{path = Url.toLocalFile url,
				   relativeTo = OS.FileSys.getDir()}
	      | _ => Url.toString url

	fun translate (desc, context, {imports, body, exports, sign}) =
	    let
		val context' = StampMap.clone context
		val filename =
		    case Source.sourceUrl desc of
			SOME url => urlToString url
		      | NONE => ""
		val imports' =
		    Vector.map (fn (_, sign, url, _) =>
				   V.tuple #[V.string (Url.toStringRaw url),
					     V.sign (SOME sign)]) imports
		val env = startTop (filename, context')
		val formalId = fresh env
		val idDefs =
		    Vector.map (fn (id, _, _, _) =>
				   O.IdDef (declare (env, id))) imports
		val instr = translateBody (body, env)
		val localNames = endTop env
		val elseInstr =
		    O.Raise (O.Immediate (V.prim "General.Match"))
		val args = #[(O.IdDef formalId)]
		val bodyInstr =
		    O.VecTest (O.LastUseLocal formalId,
			       #[(idDefs, instr)], elseInstr)
		val liveness = Liveness.analyze (args, bodyInstr)
 		val outArityOpt = SOME 1
		val typ_mod = Type.unknown (Type.starKind ()) (*--** wrong *)
		val typ_arg = Type.apply (PervasiveType.typ_vec, typ_mod)
		val typ = Type.arrow (typ_arg, typ_mod)
		val abstractCode =
		    O.Function ((filename, 0, 0), #[], 
				if (!Switches.CodeGen.debugMode) 
				    then O.Debug(localNames, typ)
				else O.Simple (Vector.length localNames),
				args, outArityOpt, bodyInstr, liveness)
		val exports =
		    Vector.map (fn (label, Id (_, stamp, _)) => (stamp, label))
			       exports
	    in
 		(context',
 		 (* This is an instance of the component type
 		  * defined in lib/system/Component.aml:
 		  *)
 		 (V.taggedValue (#[Label.fromString "EVALUATED",
 				   Label.fromString "UNEVALUATED"], 1,
 				 #[(Label.fromString "body",
 				    V.closure (abstractCode, #[])),
 				   (Label.fromString "imports",
 				    V.vector imports'),
 				   (Label.fromString "sign",
 				    V.sign (SOME sign))]),
 		  exports))
	    end
    end
