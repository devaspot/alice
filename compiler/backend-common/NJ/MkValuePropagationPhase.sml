val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2005-05-03 14:25:58 $ by $Author: rossberg $
 *   $Revision: 1.77 $
 *)

(*
 * This file implements value propagation (a variant on constant propagation
 * and constant folding).  For each program point, an approximation of the
 * environment that it will see at run-time is computed, and if possible,
 * the computations are simplified to take advantage of these minimal
 * assumptions.
 *
 * This analysis is - for now - not interprocedural.
 *)
























structure UnsafeValue :
    sig
	val cast: 'a -> 'b
	val same: 'a * 'b -> bool
	val prim: string -> Reflect.value
	val proj: Reflect.value * Label.t vector * int -> Reflect.value
	val projTuple: Reflect.value * int * int -> Reflect.value
	val tag: Reflect.value * Label.t vector -> int
	val projTagged: Reflect.value * Label.t vector * int -> Reflect.value
	val projTaggedTuple: Reflect.value * int * int -> Reflect.value
	val con: Reflect.value -> Reflect.value
	val projConstructed: Reflect.value *
			     Label.t vector * int -> Reflect.value
	val projConstructedTuple: Reflect.value * int * int -> Reflect.value
	val projPoly: Reflect.value * Label.t -> Reflect.value
	val prod: (Label.t * Reflect.value) vector -> Reflect.value
	val tuple: Reflect.value vector -> Reflect.value
	val tagged: Label.t vector * int *
		    (Label.t * Reflect.value) vector -> Reflect.value
	val taggedTuple: Label.t vector * int *
			 Reflect.value vector -> Reflect.value
	val inArity: Reflect.value -> int
	val outArity : Reflect.value -> int
    end = UnsafeValue

(*
 * We need to implement our own maps because the ones provided by
 * the library are not fit for our purposes:  The iterators yield
 * all elements of the map, regardless of their scope and whether
 * they are shadowed; this would introduce a severe performance bug.
 *)

signature SCOPED_IMP_MAP =
    sig
	type key
	type 'a map
	type 'a t = 'a map

	exception Unknown of key

	val map: unit -> 'a map
	val clone: 'a map -> 'a map
	val cloneTop: 'a map -> 'a map
	val insertScope: 'a map -> unit
	val removeScope: 'a map -> unit
	val insert: 'a map * key * 'a -> unit
	val insertDeep: 'a map * key * 'a -> unit   (* Unknown *)
	val lookup: 'a map * key -> 'a option
	val lookupExistent: 'a map * key -> 'a      (* Unknown *)
	val appiScope: (key * 'a -> unit) -> 'a map -> unit
	val foldi: (key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b
    end

functor MkScopedImpMap(ImpMap: IMP_MAP) :>
    SCOPED_IMP_MAP where type key = ImpMap.key =
    struct
	type key = ImpMap.key
	type 'a map = 'a ImpMap.t list ref
	type 'a t = 'a map

	exception Unknown = ImpMap.Unknown

	fun map () = ref [ImpMap.map ()]

	fun clone (ref maps) = ref (List.map ImpMap.clone maps)

	fun cloneTop (ref maps) =
	    ref (ImpMap.clone (List.hd maps)::List.tl maps)

	fun insertScope r = r := ImpMap.map ()::(!r)
	fun removeScope r = r := List.tl (!r)

	fun insert (ref maps, key, entry) =
	    ImpMap.insert (List.hd maps, key, entry)

	fun insertDeep (ref maps, key, entry) =
	    insertDeep' (maps, key, entry)
	and insertDeep' ([map], key, entry) =
	    ImpMap.insert (map, key, entry)
	  | insertDeep' (_::maps, key, entry) = insertDeep' (maps, key, entry)
	  | insertDeep' (nil, _, _) = raise Empty

	fun lookup (ref maps, key) = lookup' (maps, key)
	and lookup' (nil, _) = NONE
	  | lookup' ([map], key) = ImpMap.lookup (map, key)
	  | lookup' (map::rest, key) =
	    case ImpMap.lookup (map, key) of
		NONE => lookup' (rest, key)
	      | res as SOME _ => res

	fun lookupExistent (mapsRef, key) =
	    case lookup (mapsRef, key) of
		SOME entry => entry
	      | NONE => raise Unknown key

	fun appiScope f (ref maps) = ImpMap.appi f (List.hd maps)

	fun foldi f z (ref maps) = foldi' (maps, f, z)
	and foldi' (map::maps, f, z) =
	    foldi' (maps, f, ImpMap.foldi f z map)
	  | foldi' (nil, _, z) = z
    end

functor MkValuePropagationPhase(val isCross: bool
				val loadMod:
				    Source.desc * Url.t -> Reflect.module) :>
    VALUE_PROPAGATION_PHASE =
    struct
	structure I = FlatGrammar
	structure O = FlatGrammar

	open I

	val idEq = IntermediateAux.idEq

	structure IdMap' = MkHashImpMap(IntermediateAux.IdKey)
	structure IdMap = MkScopedImpMap(IdMap')
	structure LabelMap = MkHashImpMap(Label)

	(*
	 * The `value' data type represents the approximation of the value
	 * a given identifier will have at a given program point.  Only the
	 * values which can actually be used to simplify computations are
	 * stored.
	 *)

	datatype value =
	    LitVal of lit
	  | PrimVal of string
	  | VarVal of id
	  | TagVal of label vector * int * value args
	  | ConVal of id * value args
	  | ProdVal of value vector
	  | PolyProdVal of value LabelMap.t * Stamp.t
	  | VecVal of value vector
	  | FunVal of stamp * idDef args * body
	  | CaughtExnVal of id
	  | ReflectVal of Reflect.value * bool
	  | UnknownVal
	  | FailedVal

	fun mapArgs f (OneArg x) = OneArg (f x)
	  | mapArgs f (TupArgs xs) = TupArgs (Vector.map f xs)
	  | mapArgs f (ProdArgs labelXVec) =
	    ProdArgs (Vector.map (fn (label, x) => (label, f x)) labelXVec)

	fun allArgs f (OneArg x) = f x
	  | allArgs f (TupArgs xs) = Vector.all f xs
	  | allArgs f (ProdArgs labelXVec) =
	    Vector.all (fn (_, x) => f x) labelXVec

	fun idRefIdOpt (IdRef id) = SOME id
	  | idRefIdOpt (LastIdRef id) = SOME id
	  | idRefIdOpt (Lit _ | Prim _ | Value (_, _)) = NONE

	fun valueToIdRefOpt (LitVal lit) = SOME (Lit lit)
	  | valueToIdRefOpt (PrimVal name) = SOME (Prim name)
	  | valueToIdRefOpt (VarVal id) = SOME (IdRef id)
	  | valueToIdRefOpt (ReflectVal (rvalue, eager)) =
	    SOME (Value (rvalue, eager))
	  | valueToIdRefOpt _ = NONE

	fun idRefToValue (IdRef id | LastIdRef id) = VarVal id
	  | idRefToValue (Lit lit) = LitVal lit
	  | idRefToValue (Prim name) = PrimVal name
	  | idRefToValue (Value (rvalue, eager)) = ReflectVal (rvalue, eager)

	fun expToValue (NewExp (_, _)) = UnknownVal   (*--** ConVal? *)
	  | expToValue (VarExp (_, Lit lit)) = LitVal lit
	  | expToValue (VarExp (_, Prim name)) = PrimVal name
	  | expToValue (VarExp (_, Value (rvalue, eager))) =
	    ReflectVal (rvalue, eager)
	  | expToValue (VarExp (_, (IdRef id | LastIdRef id))) = VarVal id
	  | expToValue (TagExp (_, labels, n, args)) =
	    TagVal (labels, n, mapArgs idRefToValue args)
	  | expToValue (ConExp (_, (IdRef id | LastIdRef id), args)) =
	    ConVal (id, mapArgs idRefToValue args)
	  | expToValue (ConExp (_, Lit _, _)) =
	    raise Crash.Crash "MkValuePropagationPhase.expToValue: ConExp Lit"
	  | expToValue (ConExp (_, (Prim _ | Value (_, _)), _)) =
	    UnknownVal   (*--** represent constructed value *)
	  | expToValue (RefExp (_, _)) = UnknownVal
	  | expToValue (TupExp (_, idRefs)) =
	    ProdVal (Vector.map idRefToValue idRefs)
	  | expToValue (ProdExp (_, labelIdRefVec)) =
	    ProdVal (Vector.map (fn (_, idRef) => idRefToValue idRef)
				labelIdRefVec)
	  | expToValue (PolyProdExp (_, labelIdRefVec)) =
	    let
		val map = LabelMap.map ()
	    in
		Vector.app (fn (label, idRef) =>
			       LabelMap.insertDisjoint
				   (map, label, idRefToValue idRef))
			   labelIdRefVec;
		PolyProdVal (map, Stamp.stamp ())
	    end
	  | expToValue (VecExp (_, idRefs)) =
	    VecVal (Vector.map idRefToValue idRefs)
	  | expToValue (FunExp (_, stamp, _, _, args, _, body)) =
	    FunVal (stamp, args, body)
	  | expToValue (PrimAppExp (_, _, _)) = UnknownVal
	  | expToValue (VarAppExp (_, _, _)) = UnknownVal
	  | expToValue (DirectAppExp (_, _, _)) = UnknownVal
	  | expToValue (SelExp (_, _, _, _, _)) = UnknownVal
	  | expToValue (LazyPolySelExp (_, _, _)) = UnknownVal
	  | expToValue (FunAppExp (_, _, _, _)) = UnknownVal
	  | expToValue (FailExp _) = FailedVal

	fun idDefToValue (IdDef id) = VarVal id
	  | idDefToValue Wildcard = UnknownVal

	(*
	 * For each identifier, we store in the environment whether it is
	 * declared on the top level of the current component (i.e., outside
	 * any function) and what approximation we can give about its value.
	 *)

	type isToplevel = bool
	type env = (value * isToplevel) IdMap.t

	structure C: CONTEXT =
	    struct
		type t = env
		val empty = IdMap.map () : env
	    end

	(*
	 * Value propagation performed on a given sequence of statements
	 * is only correct if we give it a value environment that we can
	 * minimally assume to hold at run-time at this program point.
	 * For control-flow junctions, this means we have to merge all
	 * incoming environments in order to build an environment of
	 * correct assumptions for the remainder of the control path.
	 *
	 * The control-flow junctions in our language are the SharedStm
	 * nodes.  In order to have the correct environment when performing
	 * value propagation on a SharedStm, therefore, we need to have
	 * analyzed all paths leading to this SharedStm.  In general this
	 * means that we have to build an abstract control-flow graph
	 * containing only the SharedStms as nodes and having edges from
	 * a node n to a node m iff there is a control-flow branch leading
	 * from n to m.  If then we analyze SharedStms in an order conforming
	 * to the topological ordering of the graph's nodes, the minimal
	 * environments (as defined above) are correctly computed.
	 *
	 * sortShared computes an appropriate ordering on the SharedStms.
	 *)

	datatype 'a sharedEntry =
	    UNIQUE
	  | SHARED
	  | VISITED of 'a

	local
	    fun node (edgeMap, stamp) =
		StampMap.insertDisjoint (edgeMap, stamp, nil)

	    fun edge (edgeMap, pred, succ) =
		let
		    val stamps = StampMap.lookupExistent (edgeMap, pred)
		in
		    StampMap.insert (edgeMap, pred, succ::stamps)
		end

	    fun sortStm (Entry (_, _), _, _, _, _) = ()
	      | sortStm (Exit (_, _, _), _, _, _, _) = ()
	      | sortStm (LastUse (_, _), _, _, _, _) = ()
	      | sortStm (ValDec (_, _, _), _, _, _, _) = ()
	      | sortStm (RecDec (_, _), _, _, _, _) = ()
	      | sortStm (RefDec (_, _, _), _, _, _, _) = ()
	      | sortStm (TupDec (_, _, _), _, _, _, _) = ()
	      | sortStm (ProdDec (_, _, _), _, _, _, _) = ()
	      | sortStm (RaiseStm (_, _), _, _, _, _) = ()
	      | sortStm (ReraiseStm (_, _), _, _, _, _) = ()
	      | sortStm (TryStm (_, tryBody, _, _, handleBody),
			 pred, edgeMap, shared, path) =
		(sortBody (tryBody, pred, edgeMap, shared, path);
		 sortBody (handleBody, pred, edgeMap, shared, path))
	      | sortStm (EndTryStm (_, body), pred, edgeMap, shared, path) =
		sortBody (body, pred, edgeMap, shared, path)
	      | sortStm (EndHandleStm (_, body), pred, edgeMap, shared, path) =
		sortBody (body, pred, edgeMap, shared, path)
	      | sortStm (TestStm (_, _, tests, body),
			 pred, edgeMap, shared, path) =
		(sortTests (tests, pred, edgeMap, shared, path);
		 sortBody (body, pred, edgeMap, shared, path))
	      | sortStm (SharedStm (_, body, stamp),
			 pred, edgeMap, shared, path) =
		(StampMap.insert (shared, stamp,
				  if StampMap.member (shared, stamp)
				  then SHARED else UNIQUE);
		 edge (edgeMap, pred, stamp);
		 sortSharedBody (body, stamp, edgeMap, shared, path))
	      | sortStm (ReturnStm (_, _), _, _, _, _) = ()
	      | sortStm (IndirectStm (_, ref bodyOpt),
			 pred, edgeMap, shared, path) =
		sortBody (valOf bodyOpt, pred, edgeMap, shared, path)
	      | sortStm (ExportStm (_, _), _, _, _, _) = ()
	    and sortTests (LitTests litBodyVec, pred, edgeMap, shared, path) =
		Vector.app (fn (_, body) =>
			    sortBody (body, pred, edgeMap, shared, path))
		litBodyVec
	      | sortTests (TagTests (_, tagBodyVec),
			   pred, edgeMap, shared, path) =
		Vector.app (fn (_, _, body) =>
			    sortBody (body, pred, edgeMap, shared, path))
		tagBodyVec
	      | sortTests (ConTests conBodyVec, pred, edgeMap, shared, path) =
		Vector.app (fn (_, _, body) =>
			    sortBody (body, pred, edgeMap, shared, path))
		conBodyVec
	      | sortTests (VecTests vecBodyVec, pred, edgeMap, shared, path) =
		Vector.app (fn (_, body) =>
			    sortBody (body, pred, edgeMap, shared, path))
		vecBodyVec
	    and sortBody (stm::stms, pred, edgeMap, shared, path) =
		(sortStm (stm, pred, edgeMap, shared, path);
		 sortBody (stms, pred, edgeMap, shared, path))
	      | sortBody (nil, _, _, _, _) = ()
	    and sortSharedBody (body, stamp, edgeMap, shared, path) =
		if StampMap.member (edgeMap, stamp) then ()
		else
		    (node (edgeMap, stamp);
		     StampSet.insertDisjoint (path, stamp);
		     sortBody (body, stamp, edgeMap, shared, path);
		     StampSet.removeExistent (path, stamp))

	    structure DepthFirstSearch =
		MkDepthFirstSearch(structure Key = Stamp
				   structure Map = StampMap)
	in
	    fun sortShared (body, stamp) =
		let
		    val edgeMap = StampMap.map ()
		    val shared = StampMap.map ()
		    val path = StampSet.set ()
		in
		    sortSharedBody (body, stamp, edgeMap, shared, path);
		    (DepthFirstSearch.search edgeMap, shared)
		end
	end

	(*
	 * All lazy selections are hoisted to just after the declaration
	 * of the variable being selected.  This is performed by a
	 * post-processing patching step.
	 *)

	fun patchIdDef (Wildcard, _) = nil
	  | patchIdDef (IdDef id, lazySels) =
	    case IdMap.lookup (lazySels, id) of
		SOME map =>
		    LabelMap.foldi
			(fn (label, id', rest) =>
			    ValDec (Source.nowhere, IdDef id',
				    LazyPolySelExp (Source.nowhere,
						    label, IdRef id))::
			    patchIdDef (IdDef id', lazySels) @ rest) nil map
	      | NONE => nil

	fun patchIdDefs (idDefs, lazySels) =
	    Vector.foldr (fn (idDef, rest) =>
			     patchIdDef (idDef, lazySels) @ rest) nil idDefs

	fun patchArgs (OneArg idDef, lazySels) =
	    patchIdDef (idDef, lazySels)
	  | patchArgs (TupArgs idDefs, lazySels) =
	    patchIdDefs (idDefs, lazySels)
	  | patchArgs (ProdArgs labelIdDefVec, lazySels) =
	    Vector.foldr (fn ((_, idDef), rest) =>
			     patchIdDef (idDef, lazySels) @ rest) nil
			 labelIdDefVec

	fun patchBody ((stm as (Entry (_, _) | Exit (_, _, _) |
				LastUse (_, _)))::stms, lazySels, shared) =
	    stm::patchBody (stms, lazySels, shared)
	  | patchBody ((stm as ValDec (_, idDef, _))::stms, lazySels, shared) =
	    stm::patchIdDef (idDef, lazySels) @
	    patchBody (stms, lazySels, shared)
	  | patchBody ((stm as RecDec (_, idDefExpVec))::stms,
		       lazySels, shared) =
	    stm::Vector.foldr (fn ((idDef, _), stms) =>
				  patchIdDef (idDef, lazySels) @ stms)
			      (patchBody (stms, lazySels, shared)) idDefExpVec
	  | patchBody ((stm as RefDec (_, idDef, _))::stms, lazySels, shared) =
	    stm::patchIdDef (idDef, lazySels) @
	    patchBody (stms, lazySels, shared)
	  | patchBody ((stm as TupDec (_, idDefs, _))::stms,
		       lazySels, shared) =
	    stm::patchIdDefs (idDefs, lazySels) @
	    patchBody (stms, lazySels, shared)
	  | patchBody ((stm as ProdDec (_, labelIdDefVec, _))::stms,
		       lazySels, shared) =
	    stm::patchIdDefs (Vector.map #2 labelIdDefVec, lazySels) @
	    patchBody (stms, lazySels, shared)
	  | patchBody ([TryStm (info, tryBody, idDef1, idDef2, handleBody)],
		       lazySels, shared) =
	    [TryStm (info, patchBody (tryBody, lazySels, shared),
		     idDef1, idDef2,
		     patchIdDef (idDef1, lazySels) @
		     patchIdDef (idDef2, lazySels) @
		     patchBody (handleBody, lazySels, shared))]
	  | patchBody ([EndTryStm (info, body)], lazySels, shared) =
	    [EndTryStm (info, patchBody (body, lazySels, shared))]
	  | patchBody ([EndHandleStm (info, body)], lazySels, shared) =
	    [EndHandleStm (info, patchBody (body, lazySels, shared))]
	  | patchBody ([TestStm (info, id, tests, body)], lazySels, shared) =
	    [TestStm (info, id, patchTests (tests, lazySels, shared),
		      patchBody (body, lazySels, shared))]
	  | patchBody ([SharedStm (info, body, stamp)], lazySels, shared) =
	    (case StampMap.lookup (shared, stamp) of
		 SOME body => body
	       | NONE =>
		     let
			 val body = patchBody (body, lazySels, shared)
			 val body' = [SharedStm (info, body, stamp)]
		     in
			 StampMap.insert (shared, stamp, body');
			 body'
		     end)
	  | patchBody ([IndirectStm (_, ref (SOME body))], lazySels, shared) =
	    patchBody (body, lazySels, shared)
	  | patchBody (body as [(RaiseStm (_, _) | ReraiseStm (_, _) |
				 ReturnStm (_, _) | ExportStm (_, _))], _, _) =
	    body
	  | patchBody (_, _, _) =
	    raise Crash.Crash "MkValuePropagationPhase.patchBody"
	and patchTests (LitTests tests, lazySels, shared) =
	    LitTests (Vector.map (fn (lit, body) =>
				  (lit, patchBody (body, lazySels, shared)))
		      tests)
	  | patchTests (TagTests (labels, tests), lazySels, shared) =
	    TagTests (labels,
		      Vector.map (fn (n, args, body) =>
				  (n, args,
				   patchArgs (args, lazySels) @
				   patchBody (body, lazySels, shared))) tests)
	  | patchTests (ConTests tests, lazySels, shared) =
	    ConTests (Vector.map (fn (id, args, body) =>
				  (id, args,
				   patchArgs (args, lazySels) @
				   patchBody (body, lazySels, shared))) tests)
	  | patchTests (VecTests tests, lazySels, shared) =
	    VecTests (Vector.map (fn (idDefs, body) =>
				  (idDefs,
				   patchIdDefs (idDefs, lazySels) @
				   patchBody (body, lazySels, shared))) tests)

	(*
	 * As outlined above, we need to compute the value environments we
	 * can minimally assume to hold at every given program point.  For
	 * control-flow junctions, this means that we have to combine the
	 * environments from all branches.
	 *
	 * `intersectEnv' takes two environments and returns the combined
	 * environment.  It is reflexive and associative, so an arbitrary
	 * number of environments can be combined using `intersectEnv.'
	 *)

	fun valueMin (value as LitVal lit, LitVal lit') =
	    if litEq (lit, lit') then value else UnknownVal
	  | valueMin (value as PrimVal name, PrimVal name') =
	    if name = name' then value else UnknownVal
	  | valueMin (value as VarVal (Id (_, stamp, _)),
		      VarVal (Id (_, stamp', _))) =
	    if stamp = stamp' then value else UnknownVal
	  | valueMin (TagVal (labels, n, args), TagVal (_, n', args')) =
	    if n = n' then TagVal (labels, n, argsMin (args, args'))
	    else UnknownVal
	  | valueMin (ConVal (id, args), ConVal (id', args')) =
	    if idEq (id, id') then ConVal (id, argsMin (args, args'))
	    else UnknownVal
	  | valueMin (ProdVal values, ProdVal values') =
	    ProdVal (VectorPair.map (fn (value, value') =>
					valueMin (value, value'))
				    (values, values'))
	  | valueMin (value as PolyProdVal (_, stamp),
		      PolyProdVal (_, stamp')) =
	    if stamp = stamp' then value else UnknownVal
	  | valueMin (VecVal values, VecVal values') =
	    if Vector.length values = Vector.length values' then
		VecVal (VectorPair.map (fn (values, values') =>
					   valueMin (values, values'))
				       (values, values'))
	    else UnknownVal
	  | valueMin (value as FunVal (stamp, _, _), FunVal (stamp', _, _)) =
	    if stamp = stamp' then value else UnknownVal
	  | valueMin (value as CaughtExnVal id, CaughtExnVal id') =
	    if idEq (id, id') then value else UnknownVal
	  | valueMin (ReflectVal (rvalue, eager),
		      ReflectVal (rvalue', eager')) =
	    if UnsafeValue.same (rvalue, rvalue') then
		ReflectVal (rvalue, eager orelse eager')
	    else UnknownVal
	  | valueMin (FailedVal, FailedVal) = FailedVal
	  | valueMin (_, _) = UnknownVal
	and argsMin (args as OneArg value, OneArg value') =
	    OneArg (valueMin (value, value'))
	  | argsMin (TupArgs values, TupArgs values') =
	    TupArgs (VectorPair.map valueMin (values, values'))
	  | argsMin (ProdArgs labelValueVec, ProdArgs labelValueVec') =
	    ProdArgs (VectorPair.map (fn ((label, value), (_, value')) =>
					 (label, valueMin (value, value')))
				     (labelValueVec, labelValueVec'))
	  | argsMin (_, _) =
	    raise Crash.Crash "MkValuePropagationPhase.argsMin"

	fun intersectEnv (env', env) =
	    IdMap.appiScope
	    (fn (id, entry as (value, isToplevel)) =>
	     case IdMap.lookup (env', id) of
		 SOME (value', isToplevel') =>
		     let
			 val entry' = (valueMin (value, value'), isToplevel)
		     in
			 assert (isToplevel = isToplevel');
			 IdMap.insert (env', id, entry')
		     end
	       | NONE => IdMap.insert (env', id, entry)) env

	(* Various Helper Functions *)

	fun acquirePrim name =
	    if isCross then PrimVal name
	    else ReflectVal (UnsafeValue.prim name, true)

	fun idRefEq ((IdRef id | LastIdRef id),
		     (IdRef id' | LastIdRef id')) = idEq (id, id')
	  | idRefEq (Lit lit, Lit lit') = litEq (lit, lit')
	  | idRefEq (Prim name, Prim name') = name = name'
	  | idRefEq (Value (rvalue, _), Value (rvalue', _)) =
	    UnsafeValue.same (rvalue, rvalue')
	  | idRefEq (_, _) = false

	fun isDetermined (rvalue, eager) =
	    if eager then
		(Future.await rvalue; true)
		handle _ =>
		    (TextIO.output (TextIO.stdErr,
				    "warning: found failed future\n");
		     false)
	    else Future.isDetermined rvalue

	fun litRValueEq (lit, rvalue, eager) =
	    (isDetermined (rvalue, eager);
	     case lit of
		 IntLit (_, i) => UnsafeValue.same (i, rvalue)
	       | WordLit (_, w) => UnsafeValue.same (w, rvalue)
	       | CharLit (_, c) => UnsafeValue.same (c, rvalue)
	       | StringLit (_, s) => UnsafeValue.same (s, rvalue)
	       | RealLit (_, r) => UnsafeValue.same (r, rvalue))

	fun lookupEnv (env, (IdRef id | LastIdRef id)) =
	    IdMap.lookupExistent (env, id)
	  | lookupEnv (_, Lit lit) = (LitVal lit, true)
	  | lookupEnv (_, Prim name) = (PrimVal name, true)
	  | lookupEnv (_, Value (rvalue, eager)) =
	    (ReflectVal (rvalue, eager), true)

	fun valueToRValue value =
	    if isCross then NONE
	    else
		case value of
		    LitVal (IntLit (region, i)) =>
		    (SOME (UnsafeValue.cast (FixedInt.fromLarge i), true)
		     handle Overflow =>
			    Error.error' (region, "integer literal out of range"))
		  | LitVal (WordLit (region, w)) =>
		    (SOME (UnsafeValue.cast (Word.fromLarge w), true)
		     handle Overflow =>
			    Error.error' (region, "word literal out of range"))
		  | LitVal (CharLit (_, c)) => SOME (UnsafeValue.cast c, true)
		  | LitVal (StringLit (_, s)) => SOME (UnsafeValue.cast s, true)
		  | LitVal (RealLit (_, r)) => SOME (UnsafeValue.cast r, true)
		  | PrimVal name => SOME (UnsafeValue.prim name, true)
		  | ReflectVal (rvalue, eager) => SOME (rvalue, eager)
		  | _ => NONE

	fun idRefsToRValues (idRefs, env) =
	    case Vector.foldr
		     (fn (_, NONE) => NONE
		       | (idRef, SOME (rvalues, eager)) =>
			 case valueToRValue (#1 (lookupEnv (env, idRef))) of
			     SOME (rvalue, eager') =>
				 SOME (rvalue::rvalues, eager andalso eager')
			   | NONE => NONE) (SOME ([], true)) idRefs of
		SOME (rvalues, eager) => SOME (Vector.fromList rvalues, eager)
	      | NONE => NONE

	fun labelIdRefVecToRValues (labelIdRefVec, env) =
	    case Vector.foldr
		     (fn (_, NONE) => NONE
		       | ((label, idRef), SOME (labelRValueList, eager)) =>
			 case valueToRValue (#1 (lookupEnv (env, idRef))) of
			     SOME (rvalue, eager') =>
				 SOME ((label, rvalue)::labelRValueList,
				       eager andalso eager')
			   | NONE => NONE) (SOME ([], true)) labelIdRefVec of
		SOME (labelRValueList, eager) =>
		    SOME (Vector.fromList labelRValueList, eager)
	      | NONE => NONE

	fun argsToRValue (OneArg idRef, env) =
	    (case valueToRValue (#1 (lookupEnv (env, idRef))) of
		 SOME (rvalue, eager) => SOME (OneArg rvalue, eager)
	       | NONE => NONE)
	  | argsToRValue (TupArgs idRefs, env) =
	    (case idRefsToRValues (idRefs, env) of
		 SOME (rvalues, eager) => SOME (TupArgs rvalues, eager)
	       | NONE => NONE)
	  | argsToRValue (ProdArgs labelIdRefVec, env) =
	    (case labelIdRefVecToRValues (labelIdRefVec, env) of
		 SOME (labelRValueVec, eager) =>
		     SOME (ProdArgs labelRValueVec, eager)
	       | NONE => NONE)

	fun taggedToRValue (labels, n, args, env) =
	    if isCross then NONE
	    else
		case argsToRValue (args, env) of
		    SOME (OneArg rvalue, eager) =>
			SOME (UnsafeValue.taggedTuple (labels, n, #[rvalue]),
			      eager)
		  | SOME (TupArgs rvalues, eager) =>
			SOME (UnsafeValue.taggedTuple (labels, n, rvalues),
			      eager)
		  | SOME (ProdArgs labelRValueVec, eager) =>
			SOME (UnsafeValue.tagged (labels, n, labelRValueVec),
			      eager)
		  | NONE => NONE

	fun tupleToRValue (idRefs, env) =
	    if isCross then NONE
	    else
		case idRefsToRValues (idRefs, env) of
		    SOME (rvalues, eager) =>
			SOME (UnsafeValue.tuple rvalues, eager)
		  | NONE => NONE

	fun prodToRValue (labelIdRefVec, env) =
	    if isCross then NONE
	    else
		case labelIdRefVecToRValues (labelIdRefVec, env) of
		    SOME (labelRValueVec, eager) =>
			SOME (UnsafeValue.prod labelRValueVec, eager)
		  | NONE => NONE

	fun vectorToRValue (idRefs, env) =
	    if isCross then NONE
	    else
		case idRefsToRValues (idRefs, env) of
		    SOME (rvalues, eager) =>
			SOME (UnsafeValue.cast rvalues, eager)
		  | NONE => NONE

	fun varExp (info, idRef, env) =
	    case lookupEnv (env, idRef) of
		(LitVal lit, _) => VarExp (info, Lit lit)
	      | (PrimVal name, _) => VarExp (info, Prim name)
	      | (ReflectVal (rvalue, eager), _) =>
		    VarExp (info, Value (rvalue, eager))
	      | (VarVal id', _) => varExp (info, IdRef id', env)
	      | (TagVal (labels, n, TupArgs #[]), _) =>
		    TagExp (info, labels, n, TupArgs #[])
	      | (ConVal (id', TupArgs #[]), _) =>
		    ConExp (info, IdRef id', TupArgs #[])
	      | (_, _) => VarExp (info, idRef)

	fun deref (idRef, env) =
	    case lookupEnv (env, idRef) of
		(LitVal lit, _) => Lit lit
	      | (PrimVal name, _) => Prim name
	      | (VarVal id', _) => IdRef id'
	      | (ReflectVal (rvalue, eager), _) => Value (rvalue, eager)
	      | (_, _) => idRef

	fun derefArgs (OneArg idRef, env) = OneArg (deref (idRef, env))
	  | derefArgs (TupArgs idRefs, env) =
	    TupArgs (Vector.map (fn idRef => deref (idRef, env)) idRefs)
	  | derefArgs (ProdArgs labelIdRefVec, env) =
	    ProdArgs (Vector.map (fn (label, idRef) =>
				     (label, deref (idRef, env)))
				 labelIdRefVec)

	fun argsToIdRefs (OneArg idRef) = #[idRef]
	  | argsToIdRefs (TupArgs idRefs) = idRefs
	  | argsToIdRefs (ProdArgs labelIdRefVec) = Vector.map #2 labelIdRefVec

	fun doSel (prod, i, idRef, env) =
	    case lookupEnv (env, idRef) of
		(ProdVal values, _) => valueToIdRefOpt (Vector.sub (values, i))
	      | (ReflectVal (rvalue, eager), _) =>
		    if isDetermined (rvalue, eager) then
			case prod of
			    Tuple n =>
				SOME (Value (UnsafeValue.projTuple
						 (rvalue, n, i), eager))
			  | Product labels =>
				SOME (Value (UnsafeValue.proj
						 (rvalue, labels, i), eager))
		    else NONE
	      | (_, _) => NONE

	fun doLazySel (label, map, env, isToplevel) =
	    case LabelMap.lookup (map, label) of
		SOME id => IdRef id
	      | NONE =>
		    let
			val newId = freshId Source.nowhere
		    in
			IdMap.insertDeep (env, newId,
					  (UnknownVal, isToplevel));
			LabelMap.insert (map, label, newId);
			IdRef newId
		    end

	(* Calling Convention Conversion *)

	fun getInArity (rvalue, eager) =
	    if isDetermined (rvalue, eager) then
		case UnsafeValue.inArity rvalue of
		    ~2 => NONE
		  | ~1 => SOME Arity.Unary
		  | n => SOME (Arity.Tuple n)
	    else NONE

	fun getOutArity (rvalue, eager) =
	    if isDetermined (rvalue, eager) then
		case UnsafeValue.outArity rvalue of
		    ~2 => NONE
		  | ~1 => SOME Arity.Unary
		  | n => SOME (Arity.Tuple n)
	    else NONE

	fun getIdRefs (idRef, prod, env) =
	    case lookupEnv (env, idRef) of
		(ProdVal values, _) =>
		    (SOME (Vector.map (fn value =>
					  Option.valOf (valueToIdRefOpt value))
				      values)
		     handle Option.Option => NONE)
	      | (ReflectVal (rvalue, eager), _) =>
		    if isDetermined (rvalue, eager) then
			let
			    val (n, f) =
				case prod of
				    Tuple n =>
					(n, fn i => UnsafeValue.projTuple
							(rvalue, n, i))
				  | Product labels => 
					(Vector.length labels,
					 fn i => UnsafeValue.proj
						     (rvalue, labels, i))
			in
			    SOME (Vector.tabulate
				      (n, fn i => Value (f i, eager)))
			end
		    else NONE
	      | (_, _) => NONE

	fun argsToArity (OneArg _) = Arity.Unary
	  | argsToArity (TupArgs ids) = Arity.Tuple (Vector.length ids)
	  | argsToArity (ProdArgs labelIdVec) =
	    Arity.Product (Vector.map #1 labelIdVec)

	fun adaptArity (_, Arity.Unary, args as OneArg _, _, f) = (nil, f args)
	  | adaptArity (region, Arity.Unary, TupArgs idRefs, _, f) =
	    (* construct tuple *)
	    let
		val id = freshId region
	    in
		([ValDec (region, IdDef id, TupExp (region, idRefs))],
		 f (OneArg (IdRef id)))
	    end
	  | adaptArity (region, Arity.Unary, ProdArgs labelIdRefVec, _, f) =
	    (* construct product *)
	    let
		val id = freshId region
	    in
		([ValDec (region, IdDef id,
			  ProdExp (region, labelIdRefVec))],
		 f (OneArg (IdRef id)))
	    end
	  | adaptArity (region, Arity.Tuple n, OneArg idRef, env, f) =
	    (* deconstruct tuple (try statically) *)
	    (case getIdRefs (idRef, Tuple n, env) of
		 SOME idRefs => (nil, f (TupArgs idRefs))
	       | NONE =>
		     let
			 val ids = Vector.tabulate (n, fn _ => freshId region)
		     in
			 ([TupDec (region, Vector.map IdDef ids, idRef)],
			  f (TupArgs (Vector.map IdRef ids)))
		     end)
	  | adaptArity (_, Arity.Tuple _, args as TupArgs _, _, f) =
	    (nil, f args)
	  | adaptArity (region, Arity.Product labels, OneArg idRef, env, f) =
	    (* deconstruct product (try statically) *)
	    (case getIdRefs (idRef, Product labels, env) of
		 SOME idRefs =>
		     (nil, f (ProdArgs (VectorPair.zip (labels, idRefs))))
	       | NONE =>
		     let
			 val labelIdVec =
			     Vector.map (fn label => (label, freshId region))
					labels
			 val labelIdDefVec =
			     Vector.map (fn (label, id) => (label, IdDef id))
					labelIdVec
			 val labelIdRefVec =
			     Vector.map (fn (label, id) => (label, IdRef id))
					labelIdVec
		     in
			 ([ProdDec (region, labelIdDefVec, idRef)],
			  f (ProdArgs labelIdRefVec))
		     end)
	  | adaptArity (_, Arity.Product _, args as ProdArgs _, _, f) =
	    (nil, f args)
	  | adaptArity (_, _, _, _, _) =
	    raise Crash.Crash "MkValuePropagationPhase.adaptArity"

	(* Relaxed version - allows product arguments to tupled functions *)
	fun adaptArity' (info, Arity.Tuple n, ProdArgs labelIdRefVec, env, f) =
	    adaptArity (info, Arity.Tuple n,
			TupArgs (Vector.map #2 labelIdRefVec), env, f)
	  | adaptArity' (info, arity, args, env, f) =
	    adaptArity (info, arity, args, env, f)

	(* Applications of Primitives *)

	fun isNonlocal ((IdRef id | LastIdRef id), env) =
	    isSome (IdMap.lookup (env, id))
	  | isNonlocal ((Lit _ | Prim _ | Value (_, _)), _) = true

	fun isSimple (NewExp (_, _), _) = true
	  | isSimple (VarExp (_, idRef), env) = isNonlocal (idRef, env)
	  | isSimple (TagExp (_, _, _, args), env) =
	    allArgs (fn idRef => isNonlocal (idRef, env)) args
	  | isSimple (ConExp (_, _, TupArgs #[]), _) = true
	  | isSimple (RefExp (_, idRef), env) = isNonlocal (idRef, env)
	  | isSimple (TupExp (_, idRefs), env) =
	    Vector.all (fn idRef => isNonlocal (idRef, env)) idRefs
	  | isSimple (ProdExp (_, labelIdRefVec), env) =
	    Vector.all (fn (_, idRef) => isNonlocal (idRef, env)) labelIdRefVec
	  | isSimple (PolyProdExp (_, labelIdRefVec), env) =
	    Vector.all (fn (_, idRef) => isNonlocal (idRef, env)) labelIdRefVec
	  | isSimple (VecExp (_, idRefs), env) =
	    Vector.all (fn idRef => isNonlocal (idRef, env)) idRefs
	  | isSimple (_, _) = false

	fun vpPrimApp (info, "Future.concur", idRefs as #[idRef], env) =
	    (case lookupEnv (env, idRef) of
		 (FunVal (_, (OneArg Wildcard | TupArgs #[]),
			  [ReturnStm (_, exp)]), _) =>
		     if isSimple (exp, env) then exp
		     else PrimAppExp (info, "Future.concur", idRefs)
	       | (_, _) => PrimAppExp (info, "Future.concur", idRefs))
	  | vpPrimApp (info, name, idRefs, _) =
	    (*--** assertion about arity; evaluate application partially? *)
	    PrimAppExp (info, name, idRefs)

	(* Environment Handling *)

	fun aliasRValueRowT proj (idDefs, rvalue, env, isToplevel, eager) =
	    let
		val n = Vector.length idDefs
	    in
		Vector.mapi
		    (fn (i, IdDef id) =>
			let
			    val rvalue = proj (rvalue, n, i)
			    val value = ReflectVal (rvalue, eager)
			in
			    IdMap.insert (env, id, (value, isToplevel));
			    Wildcard
			end
		      | (_, Wildcard) => Wildcard) idDefs
	    end

	fun aliasRValueTuple (idDefs, rvalue, env, isToplevel, eager) =
	    aliasRValueRowT UnsafeValue.projTuple
			    (idDefs, rvalue, env, isToplevel, eager)

	fun aliasRValueRowP proj (labelIdDefVec, rvalue,
				  env, isToplevel, eager) =
	    let
		val labels = Vector.map #1 labelIdDefVec
	    in
		Vector.mapi
		    (fn (i, (label, IdDef id)) =>
			let
			    val rvalue = proj (rvalue, labels, i)
			    val value = ReflectVal (rvalue, eager)
			in
			    IdMap.insert (env, id, (value, isToplevel));
			    (label, Wildcard)
			end
		      | (_, (label, Wildcard)) =>
			(label, Wildcard)) labelIdDefVec
	    end

	fun aliasRValueProd (labelIdDefVec, rvalue, env, isToplevel, eager) =
	    aliasRValueRowP UnsafeValue.proj
			    (labelIdDefVec, rvalue, env, isToplevel, eager)

	fun aliasRValueTagged (OneArg (IdDef id), rvalue,
			       env, isToplevel, eager) =
	    let
		val rvalue = UnsafeValue.projTaggedTuple (rvalue, 1, 0)
		val value = ReflectVal (rvalue, eager)
	    in
		IdMap.insert (env, id, (value, isToplevel))
	    end
	  | aliasRValueTagged (OneArg Wildcard, _, _, _, _) = ()
	  | aliasRValueTagged (TupArgs idDefs, rvalue,
			       env, isToplevel, eager) = 
	    ignore (aliasRValueRowT UnsafeValue.projTaggedTuple
				    (idDefs, rvalue, env, isToplevel, eager))
	  | aliasRValueTagged (ProdArgs labelIdDefVec, rvalue,
			       env, isToplevel, eager) =
	    ignore (aliasRValueRowP UnsafeValue.projTagged
				    (labelIdDefVec, rvalue,
				     env, isToplevel, eager))

	fun aliasRValueConstructed (OneArg (IdDef id), rvalue,
				    env, isToplevel, eager) =
	    let
		val rvalue = UnsafeValue.projConstructedTuple (rvalue, 1, 0)
		val value = ReflectVal (rvalue, eager)
	    in
		IdMap.insert (env, id, (value, isToplevel))
	    end
	  | aliasRValueConstructed (OneArg Wildcard, _, _, _, _) = ()
	  | aliasRValueConstructed (TupArgs idDefs, rvalue,
				    env, isToplevel, eager) = 
	    ignore (aliasRValueRowT UnsafeValue.projConstructedTuple
				    (idDefs, rvalue, env, isToplevel, eager))
	  | aliasRValueConstructed (ProdArgs labelIdDefVec, rvalue,
				    env, isToplevel, eager) =
	    ignore (aliasRValueRowP UnsafeValue.projConstructed
				    (labelIdDefVec, rvalue,
				     env, isToplevel, eager))

	fun aliasRValueVec (idDefs, rvalues, env, isToplevel, eager) =
	    VectorPair.app
		(fn (IdDef id, rvalue) =>
		    IdMap.insert (env, id,
				  (ReflectVal (rvalue, eager), isToplevel))
		  | (Wildcard, _) => ()) (idDefs, rvalues)

	fun alias (IdDef id, value as VarVal id', env, isToplevel) =
	    (* id and id' can be equal due to pattern matching compilation,
	     * for example in:
	     *    datatype t = A | B | C
	     *    fun f (a,b) (A, x) = x
	     *      | f (a,b) (B, x) = x
	     *      | f a_b (_, x) = x          <- here
	     *)
	    if idEq (id, id') then Wildcard
	    else (IdMap.insert (env, id, (value, isToplevel)); Wildcard)
	  | alias (IdDef id,
		   value as (LitVal _ | PrimVal _ | ReflectVal (_, _)),
		   env, isToplevel) =
	    (IdMap.insert (env, id, (value, isToplevel)); Wildcard)
	  | alias (idDef, _, _, _) = idDef

	fun aliasVec (idDefs, values, env, isToplevel) =
	    VectorPair.map (fn (idDef, value) =>
			       alias (idDef, value, env, isToplevel))
			   (idDefs, values)

	fun aliasArgs (OneArg idDef, OneArg value, env, isToplevel) =
	    OneArg (alias (idDef, value, env, isToplevel))
	  | aliasArgs (TupArgs idDefs, TupArgs values, env, isToplevel) =
	    TupArgs (aliasVec (idDefs, values, env, isToplevel))
	  | aliasArgs (ProdArgs labelIdDefVec, ProdArgs labelValueVec,
		       env, isToplevel) =
	    ProdArgs (VectorPair.map (fn ((label, idDef), (_, value)) =>
					 (label, alias (idDef, value,
							env, isToplevel)))
				     (labelIdDefVec, labelValueVec))
	  | aliasArgs (_, _, _, _) =
	    raise Crash.Crash "MkValuePropagationPhase.aliasArgs"

	fun declare (env, IdDef id, entry) = IdMap.insert (env, id, entry)
	  | declare (_, Wildcard, _) = ()

	fun declareUnknown (env, idDef, isToplevel) =
	    declare (env, idDef, (UnknownVal, isToplevel))

	fun declareArgs (env, OneArg idDef, isToplevel) =
	    declareUnknown (env, idDef, isToplevel)
	  | declareArgs (env, TupArgs idDefs, isToplevel) =
	    Vector.app (fn idDef =>
			declareUnknown (env, idDef, isToplevel)) idDefs
	  | declareArgs (env, ProdArgs labelIdDefVec, isToplevel) =
	    Vector.app (fn (_, idDef) =>
			declareUnknown (env, idDef, isToplevel)) labelIdDefVec

	(* The Main Recursion over the Syntax Tree *)

	fun testsAppend (NONE, testsOpt) = testsOpt
	  | testsAppend (testsOpt, NONE) = testsOpt
	  | testsAppend (SOME (LitTests xs), SOME (LitTests ys)) =
	    SOME (LitTests (Vector.concat [xs, ys]))
	  | testsAppend (SOME (TagTests (labels, xs)),
			 SOME (TagTests (labels', ys))) =
	    (assert (labels = labels');
	     SOME (TagTests (labels, Vector.concat [xs, ys])))
	  | testsAppend (SOME (ConTests xs), SOME (ConTests ys)) =
	    SOME (ConTests (Vector.concat [xs, ys]))
	  | testsAppend (SOME (VecTests xs), SOME (VecTests ys)) =
	    SOME (VecTests (Vector.concat [xs, ys]))
	  | testsAppend (SOME _, SOME _) =
	    raise Crash.Crash "MkValuePropagationPhase.testsAppend"

	fun testsNull (SOME (LitTests xs)) = Vector.length xs = 0
	  | testsNull (SOME (TagTests (_, xs))) = Vector.length xs = 0
	  | testsNull (SOME (ConTests xs)) = Vector.length xs = 0
	  | testsNull (SOME (VecTests xs)) = Vector.length xs = 0
	  | testsNull NONE = true

	structure DepthFirstSearch =
	    MkDepthFirstSearch(structure Key = IntermediateAux.IdKey
			       structure Map = IdMap')
	structure IdSet = IntermediateAux.IdSet

	fun optimizeRec (info, idDefExpList, stms) =
	    let
		val edgeMap = IdMap'.map ()
		val set = IdSet.set ()
		val (idDefExpList, idDefExpRest) =
		    List.partition
			(fn (IdDef _, ConExp (_, (IdRef _ |
						  LastIdRef _), _)) => false
			  | (IdDef id, _) => (IdSet.insert (set, id); true)
			  | (_, _) => false) idDefExpList
		val map = IdMap'.map ()
		val _ =
		    List.app
			(fn (IdDef id, exp) =>
			    let
				val freeVarsSet =
				    IntermediateAux.getUsedVars (exp, set)
			    in
				IdMap'.insert (map, id, (exp, freeVarsSet));
				IdMap'.insert (edgeMap, id, nil)
			    end
			  | (Wildcard, _) =>
			    raise Crash.Crash
				      "MkValuePropagationPhase.optimizeRec")
			idDefExpList
		val _ =
		    IdMap'.appi
		    (fn (id, (_, freeVarsSet)) =>
			IdSet.app
			(fn id' =>
			    IdMap'.insert
				(edgeMap, id',
				 id::IdMap'.lookupExistent (edgeMap, id')))
			freeVarsSet) map
		val idss = DepthFirstSearch.search edgeMap
		val toIdDefExpList =
		    List.foldr
			(fn (id, idDefExpList) =>
			    let
				val (exp, _) = IdMap'.lookupExistent (map, id)
			    in
				(IdDef id, exp)::idDefExpList
			    end)
	    in
		if List.null idDefExpRest then
		    List.foldr
			(fn ([id], stms) =>
			    let
				val (exp, freeVarsSet) =
				    IdMap'.lookupExistent (map, id)
			    in
				if IdSet.member (freeVarsSet, id)
				then RecDec (info, #[(IdDef id, exp)])::stms
				else ValDec (info, IdDef id, exp)::stms
			    end
			  | (ids, stms) =>
			    let
				val idDefExpVec =
				    Vector.fromList (toIdDefExpList nil ids)
			    in
				RecDec (info, idDefExpVec)::stms
			    end) stms idss
		else   (* don't try to be smart *)
		    let
			val idDefExpList =
			    List.foldr
				(fn (ids, idDefExpList) =>
				    toIdDefExpList idDefExpList ids)
				idDefExpRest idss
		    in
			RecDec (info, Vector.fromList idDefExpList)::stms
		    end
	    end

	fun vpEntryPoint (ConEntry (typ, idRef, args), env) =
	    ConEntry (typ, deref (idRef, env), derefArgs (args, env))
	  | vpEntryPoint (SelEntry (prod, label, n, typ, idRef), env) =
	    SelEntry (prod, label, n, typ, deref (idRef, env))
	  | vpEntryPoint (StrictEntry (typ, idRef), env) =
	    StrictEntry (typ, deref (idRef, env))
	  | vpEntryPoint (AppEntry (typ, idRef, args), env) =
	    AppEntry (typ, deref (idRef, env), derefArgs (args, env))
	  | vpEntryPoint (CondEntry (typ, idRef), env) =
	    CondEntry (typ, deref (idRef, env))
	  | vpEntryPoint (RaiseEntry idRef, env) =
	    RaiseEntry (deref (idRef, env))
	  | vpEntryPoint (HandleEntry idRef, env) =
	    HandleEntry (deref (idRef, env))
	  | vpEntryPoint (SpawnEntry, _) = SpawnEntry
 	datatype outArityInfo =
 	    UNKNOWN
 	  | KNOWN of Arity.t
 	  | AMBIGUOUS
 
 	fun vpOutArity (TupExp (_, idRefs), _, outArityInfo) =
 	    vpOutArity' (outArityInfo,
 			 SOME (Arity.Tuple (Vector.length idRefs)))
 	  | vpOutArity (ProdExp (_, labelIdRefs), _, outArityInfo) =
 	    vpOutArity' (outArityInfo,
 			 SOME (Arity.Product (Vector.map #1 labelIdRefs)))
 	  | vpOutArity (VarExp (_, idRef), env, outArityInfo) =
 	    vpOutArity' (outArityInfo, SOME Arity.Unary)
 	  | vpOutArity ((VarAppExp (_, idRef, _) | DirectAppExp (_, idRef, _)),
 			env, outArityInfo) =
 	    let
 		val outArityOpt =
 		    case lookupEnv (env, idRef) of
 			(ReflectVal (rvalue, eager), _) =>
 			    getOutArity (rvalue, eager)
 		      | (_, _) => NONE
 	    in
 		vpOutArity' (outArityInfo, outArityOpt)
 	    end
 	  | vpOutArity (PrimAppExp (_, name, _), env, outArityInfo) =
 	    let
 		val outArity =
 		    if isCross then ~2
 		    else UnsafeValue.outArity (UnsafeValue.prim name)
 	    in
 		vpOutArity' (outArityInfo,
 			     case outArity of
 				 ~2 => NONE
 			       | ~1 => SOME Arity.Unary
 			       | n => SOME (Arity.Tuple n))
 	    end
 	  | vpOutArity (FunAppExp (_, idRef, stamp, _), env,
 			outArityInfo as (_, stamp', funMap)) =
 	    (* self recursion does not invalidate computed arity data *)
 	    if stamp = stamp' then ()
 	    else vpOutArity' (outArityInfo,
 			      case StampMap.lookup (funMap, stamp) of
 				  SOME arityOpt => arityOpt
 				| NONE => NONE)
 	  | vpOutArity (_, _, outArityInfo) =
 	    vpOutArity' (outArityInfo, SOME Arity.Unary)
 	and vpOutArity' ((SOME (r as ref _), _, _), NONE) = r := AMBIGUOUS
 	  | vpOutArity' ((SOME (r as ref UNKNOWN), stamp, _), SOME arity) =
 	    r := KNOWN arity
 	  | vpOutArity' ((SOME (r as ref (KNOWN arity)), stamp, _),
 			 SOME arity') =
 	    if arity <> arity' then r := AMBIGUOUS else ()
 	  | vpOutArity' ((SOME (ref AMBIGUOUS), _, _), _) = ()
 	  | vpOutArity' ((NONE, _, _), _) = ()

	fun declareExport (SOME (env, exportset), 
			   idDef as IdDef (Id (_, stamp, _))) =
	    if StampSet.member (exportset, stamp) then
		declareUnknown (env, idDef, true)
	    else ()
	  | declareExport (_, _) = ()

	fun vpBody (Entry (info, entryPoint)::stms, state as {env, ...}) =
	    Entry (info, vpEntryPoint (entryPoint, env))::vpBody (stms, state)
	  | vpBody (Exit (info, exitPoint, idRef)::stms, state as {env, ...}) =
	    Exit (info, exitPoint, deref (idRef, env))::vpBody (stms, state)
	  | vpBody ((stm as LastUse (_, _))::stms, state) =
	    stm::vpBody (stms, state)
	  | vpBody (ValDec (info, idDef, exp)::stms,
		    state as {env, isToplevel, lazySels, export,
			      outArityInfo = (_, _, funMap), ...}) =
	    let
		val (stms', exp) =
		    vpExp (exp, env, isToplevel, lazySels, funMap)
	    in
		declare (env, idDef, (expToValue exp, isToplevel));
		declareExport (export, idDef);
		stms' @ ValDec (info, idDef, exp)::vpBody (stms, state)
	    end
	  | vpBody (RecDec (info, idDefExpVec)::stms,
 		    state as {env, isToplevel, lazySels, export,
 			      outArityInfo = (_, _, funMap), ...}) =
	    let
		val _ =
		    Vector.app
			(fn (idDef, exp) =>
			    (declare (env, idDef, (expToValue exp, isToplevel));
			     declareExport (export, idDef)))
			idDefExpVec
		val (stms', idDefExpList) =
		    Vector.foldr
			(fn ((idDef, exp), (stms, idDefExpList)) =>
			    let
				val (stms', exp) =
				    vpExp (exp, env, isToplevel, lazySels,
					   funMap)
			    in
				(stms' @ stms, (idDef, exp)::idDefExpList)
			    end) (nil, nil) idDefExpVec
	    in
		List.app
		    (fn (idDef, exp) =>
			declare (env, idDef, (expToValue exp, isToplevel)))
		    idDefExpList;
		stms' @ optimizeRec (info, idDefExpList, vpBody (stms, state))
	    end
	  | vpBody (RefDec (info, idDef, idRef)::stms,
		    state as {env, isToplevel, ...}) =
	    (declareUnknown (env, idDef, isToplevel);
	     RefDec (info, idDef, deref (idRef, env))::vpBody (stms, state))
	  | vpBody (TupDec (info, idDefs, idRef)::stms,
		    state as {env, isToplevel, export, ...}) =
	    let
		val idRef = deref (idRef, env)
		val (idDefs, isDet) =
		    case lookupEnv (env, idRef) of
			(ProdVal values, isToplevel') =>
			    (aliasVec (idDefs, values, env, isToplevel'), true)
		      | (ReflectVal (rvalue, eager), isToplevel') =>
			    if isDetermined (rvalue, eager) then
				(aliasRValueTuple
				     (idDefs, rvalue, env, isToplevel', eager),
				 true)
			    else (idDefs, false)
		      | (_, _) => (idDefs, false)
		val isSome = ref false
		val values =
		    Vector.map (fn idDef =>
				   (declareUnknown (env, idDef, isToplevel);
				    declareExport (export, idDef);
				    case idDef of
					IdDef id => (isSome := true; VarVal id)
				      | Wildcard => UnknownVal)) idDefs
	    in
		case idRefIdOpt idRef of
		    SOME id =>
			IdMap.insert (env, id, (ProdVal values, isToplevel))
		  | NONE => ();
		if !isSome orelse not isDet then
		    TupDec (info, idDefs, idRef)::vpBody (stms, state)
		else vpBody (stms, state)
	    end
	  | vpBody (ProdDec (info, labelIdDefVec, idRef)::stms,
		    state as {env, isToplevel, export, ...}) =
	    let
		val idRef = deref (idRef, env)
		val (labelIdDefVec, isDet) =
		    case lookupEnv (env, idRef) of
			(ProdVal values, isToplevel') =>
			    (VectorPair.map
				 (fn ((label, idDef), value) =>
				     (label, alias (idDef, value,
						    env, isToplevel)))
				 (labelIdDefVec, values), true)
		      | (ReflectVal (rvalue, eager), isToplevel') =>
			    if isDetermined (rvalue, eager) then
				(aliasRValueProd
				     (labelIdDefVec, rvalue,
				      env, isToplevel', eager), true)
			    else (labelIdDefVec, false)
		      | (_, _) => (labelIdDefVec, false)
		val isSome = ref false
		val values =
		    Vector.map (fn (_, idDef) =>
				   (declareUnknown (env, idDef, isToplevel);
				    declareExport (export, idDef);
				    case idDef of
					IdDef id => (isSome := true; VarVal id)
				      | Wildcard => UnknownVal)) labelIdDefVec
	    in
		case idRefIdOpt idRef of
		    SOME id =>
			IdMap.insert (env, id, (ProdVal values, isToplevel))
		  | NONE => ();
		if !isSome orelse not isDet then
		    ProdDec (info, labelIdDefVec, idRef)::vpBody (stms, state)
		else vpBody (stms, state)
	    end
	  | vpBody ([stm as RaiseStm (info, idRef)], {env, ...}) =
	    let
		val idRef = deref (idRef, env)
	    in
		[case lookupEnv (env, idRef) of
		     (CaughtExnVal id', _) => ReraiseStm (info, IdRef id')
		   | _ => RaiseStm (info, idRef)]
	    end
	  | vpBody ([stm as ReraiseStm (info, idRef)], {env, ...}) =
	    [ReraiseStm (info, deref (idRef, env))]
	  | vpBody ([TryStm (info, tryBody, idDef1, idDef2, handleBody)],
		    state as {env, isToplevel, ...}) =
	    let
		val tryBody = vpBodyScope (tryBody, state)
		val _ =
		    declare (env, idDef2,
			     (case idDef1 of
				  IdDef id => CaughtExnVal id
				| _ => UnknownVal, isToplevel))
		val handleBody = vpBodyScope (handleBody, state)
	    in
		[TryStm (info, tryBody, idDef1, idDef2, handleBody)]
	    end
	  | vpBody ([EndTryStm (info, body)], state) =
	    [EndTryStm (info, vpBodyScope (body, state))]
	  | vpBody ([EndHandleStm (info, body)], state) =
	    [EndHandleStm (info, vpBodyScope (body, state))]
	  | vpBody (stms as [TestStm (info, idRef, _, _)],
		    state as {env, ...}) =
	    let
		val idRef = deref (idRef, env)
		val (testsOpt, elseBody) = vpTestStm (stms, idRef, state)
	    in
		if testsNull testsOpt then elseBody
		else [TestStm (info, idRef, valOf testsOpt, elseBody)]
	    end
	  | vpBody ([SharedStm (info, body, stamp)],
		    state as {env, shared, ...}) =
	    (* We need to return a SharedStm with an IndirectStm in it;
	     * the IndirectStm's reference will be updated destructively
	     * later when analysis proceeds (topological ordering). *)
	    (case StampMap.lookupExistent (shared, stamp) of
		 UNIQUE => vpBody (body, state)
	       | SHARED =>
		     let
			 val bodyOptRef = ref (SOME body)
			 val entry =
			     VISITED (bodyOptRef, IdMap.cloneTop env)
		     in
			 StampMap.insert (shared, stamp, entry);
			 [SharedStm (info, [IndirectStm (info, bodyOptRef)],
				     stamp)]
		     end
	       | VISITED (bodyOptRef, env') =>
		     (intersectEnv (env', env);
		      [SharedStm (info, [IndirectStm (info, bodyOptRef)],
				  stamp)]))
	  | vpBody ([ReturnStm (info, exp)],
		    {env, isToplevel, lazySels,
		     outArityInfo = outArityInfo as (_, _, funMap), ...}) =
	    let
		val (stms, exp) = vpExp (exp, env, isToplevel, lazySels, funMap)
		val _ = vpOutArity (exp, env, outArityInfo)
	    in
		stms @ [ReturnStm (info, exp)]
	    end
	  | vpBody ([IndirectStm (info, ref bodyOpt)], state) =
	    vpBody (valOf bodyOpt, state)
	  | vpBody ([ExportStm (info, exp)],
		    {env, isToplevel = true,
		     export = SOME (env', exportDesc), lazySels,
		     outArityInfo = (_, _, funMap), ...}) =
	    (*--** do multiple occurrences of ExportStm work by accident? *)
	    let
	    (*--** now done at declaration points, to avoid problems with
		   flattening phase dropping unreachable export statements
		val _ =
		    Vector.app (fn (_, id) =>
				declareUnknown (env', IdDef id, true))
		    exportDesc
	    *)
		val (stms, exp) = vpExp (exp, env, true, lazySels, funMap)
	    in
		stms @ [ExportStm (info, exp)]
	    end
	  | vpBody (_, _) =
	    raise Crash.Crash "MkValuePropagationPhase.vpBody"
	and vpTestStm (topBody as [TestStm (_, idRef, tests, elseBody)],
		       idRef', state as {env, ...}) =
	    let
		val idRef = deref (idRef, env)
	    in
		if idRefEq (idRef, idRef') then
		    let
			val (testsOpt, elseBody) =
			    vpTestStm (elseBody, idRef', state)
			val (testsOpt', elseBody) =
			    vpTests (idRef, tests, elseBody, state)
		    in
			(testsAppend (testsOpt', testsOpt), elseBody)
		    end
		else (NONE, vpBodyScope (topBody, state))
	    end
	  | vpTestStm (body as [SharedStm (_, body', stamp)],
		       idRef, state as {shared, ...}) =
	    (case StampMap.lookupExistent (shared, stamp) of
		 UNIQUE => vpTestStm (body', idRef, state)
	       | _ => (NONE, vpBodyScope (body, state)))
	  | vpTestStm ([IndirectStm (_, ref bodyOpt)], idRef, state) =
	    vpTestStm (valOf bodyOpt, idRef, state)
	  | vpTestStm (body, _, state) = (NONE, vpBodyScope (body, state))
	and vpTests (idRef, LitTests litBodyVec, elseBody,
		     {env, isToplevel, shared, export, lazySels,
		      outArityInfo}) =
	    let
		fun insertId (env, value) =
		    case idRef of
			(IdRef id | LastIdRef id) =>
			    #1 (IdMap.lookupExistent (env, id))
			    before IdMap.insert (env, id, (value, isToplevel))
		      | Lit lit => LitVal lit
		      | Prim name => acquirePrim name
		      | Value (rvalue, eager) => ReflectVal (rvalue, eager)
		val (litBodyList, elseBody) =
		    Vector.foldr
		    (fn ((lit, body), (litBodyList, elseBody)) =>
		     let
			 val env = IdMap.cloneTop env
			 val state = {env = env, isToplevel = isToplevel,
				      shared = shared, export = export,
				      lazySels = lazySels,
				      outArityInfo = outArityInfo}
			 val knownVal = insertId (env, LitVal lit)
			 val body = vpBody (body, state)
		     in
			 case knownVal of
			     LitVal lit' =>
				 if litEq (lit, lit') then (nil, body)
				 else (nil, elseBody)
			   | ReflectVal (rvalue, eager) => 
				 if litRValueEq (lit, rvalue, eager) then
				     (nil, body)
				 else ((lit, body)::litBodyList, elseBody)
			   | _ => ((lit, body)::litBodyList, elseBody)
		     end) (nil, elseBody) litBodyVec
	    in
		(case litBodyList of
		     nil => NONE
		   | _::_ => SOME (LitTests (Vector.fromList litBodyList)),
		 elseBody)
	    end
	  | vpTests (idRef, TagTests (labels, tagBodyVec), elseBody,
		     {env, isToplevel, shared, export, lazySels,
		      outArityInfo}) =
	    let
		fun insertId (env, value) =
		    case idRef of
			(IdRef id | LastIdRef id) =>
			    #1 (IdMap.lookupExistent (env, id))
			    before IdMap.insert (env, id, (value, isToplevel))
		      | Lit _ =>
			    raise Crash.Crash
				"MkValuePropagationPhase.vpTests TagTests Lit"
		      | Prim name => acquirePrim name
		      | Value (rvalue, eager) => ReflectVal (rvalue, eager)
		val (tagBodyList, elseBody) =
		    Vector.foldr
		    (fn ((n, args, body), (tagBodyList, elseBody')) =>
		     let
			 val env = IdMap.cloneTop env
			 val state = {env = env, isToplevel = isToplevel,
				      shared = shared, export = export,
				      lazySels = lazySels,
				      outArityInfo = outArityInfo}
			 val value =
			     TagVal (labels, n, mapArgs idDefToValue args)
			 val knownVal = insertId (env, value)
			 val _ = declareArgs (env, args, isToplevel)
		     in
			 case knownVal of
			     TagVal (_, n', args') =>
				 if n = n' then
				     let
					 val args = aliasArgs (args, args',
							       env, isToplevel)
				     in
					 if allArgs (fn IdDef _ => false
						      | Wildcard => true) args
					 then (nil, vpBody (body, state))
					 else ((n, args,
						vpBody (body, state))::
					       tagBodyList, elseBody)
				     end
				 else (nil, elseBody')
			   | ReflectVal (rvalue, eager) =>
				 if isDetermined (rvalue, eager) then
				     if UnsafeValue.tag (rvalue, labels) = n
				     then (aliasRValueTagged
					       (args, rvalue,
						env, isToplevel, eager);
					   (nil, vpBody (body, state)))
				     else (nil, elseBody')
				 else
				     ((n, args, vpBody (body, state))::
				      tagBodyList, elseBody')
			   | _ =>
				 ((n, args, vpBody (body, state))::
				  tagBodyList, elseBody')
		     end) (nil, elseBody) tagBodyVec
	    in
		(case tagBodyList of
		     nil => NONE
		   | _::_ =>
			 SOME (TagTests (labels, Vector.fromList tagBodyList)),
		 elseBody)
	    end
	  | vpTests (idRef, ConTests conBodyVec, elseBody,
		     {env, isToplevel, shared, export, lazySels,
		      outArityInfo}) =
	    let
		fun insertId (env, value) =
		    case idRef of
			(IdRef id | LastIdRef id) =>
			    #1 (IdMap.lookupExistent (env, id))
			    before IdMap.insert (env, id, (value, isToplevel))
		      | Lit _ =>
			    raise Crash.Crash
				"MkValuePropagationPhase.vpTests ConTests Lit"
		      | Prim name => acquirePrim name
		      | Value (rvalue, eager) => ReflectVal (rvalue, eager)
		val (conBodyList, elseBody) =
		    Vector.foldr
		    (fn ((con, args, body), (conBodyList, elseBody')) =>
		     let
			 val con = deref (con, env)
			 val env = IdMap.cloneTop env
			 val state = {env = env, isToplevel = isToplevel,
				      shared = shared, export = export,
				      lazySels = lazySels,
				      outArityInfo = outArityInfo}
			 val value =
			     case con of
				 (IdRef id | LastIdRef id) =>
				     ConVal (id, mapArgs idDefToValue args)
			       | Lit _ =>
				     raise Crash.Crash
					 "MkValuePropagationPhase.vpTests"
			       | Prim name => PrimVal name
			       | Value (rvalue, eager) =>
				     ReflectVal (rvalue, eager)
			 val knownVal = insertId (env, value)
			 val _ = declareArgs (env, args, isToplevel)
		     in
			 case knownVal of
			     ConVal (con', args') =>
				 if idRefEq (con, IdRef con') then
				     let
					 val args = aliasArgs (args, args',
							       env, isToplevel)
				     in
					 if allArgs (fn IdDef _ => false
						      | Wildcard => true) args
					 then (nil, vpBody (body, state))
					 else ((con, args,
						vpBody (body, state))::
					       conBodyList, elseBody)
				     end
				 else ((con, args, vpBody (body, state))::
				       conBodyList, elseBody')
			   | ReflectVal (rvalue, eager) =>
				 if isDetermined (rvalue, eager) andalso
				    idRefEq (con,
					     Value (UnsafeValue.con rvalue,
						    eager))
				 then (aliasRValueConstructed
					   (args, rvalue,
					    env, isToplevel, eager);
				       (nil, vpBody (body, state)))
				 else ((con, args, vpBody (body, state))::
				       conBodyList, elseBody')
			   | _ =>
				 ((con, args, vpBody (body, state))::
				  conBodyList, elseBody')
		     end) (nil, elseBody) conBodyVec
	    in
		(case conBodyList of
		     nil => NONE
		   | _::_ => SOME (ConTests (Vector.fromList conBodyList)),
		 elseBody)
	    end
	  | vpTests (idRef, VecTests vecBodyVec, elseBody,
		     {env, isToplevel, shared, export, lazySels,
		      outArityInfo}) =
	    let
		fun insertId (env, value) =
		    case idRef of
			(IdRef id | LastIdRef id) =>
			    #1 (IdMap.lookupExistent (env, id))
			    before IdMap.insert (env, id, (value, isToplevel))
		      | Lit _ =>
			    raise Crash.Crash
				"MkValuePropagationPhase.vpTests VecTests Lit"
		      | Prim name => acquirePrim name
		      | Value (rvalue, eager) => ReflectVal (rvalue, eager)
		val (vecBodyList, elseBody) =
		    Vector.foldr
		    (fn ((idDefs, body), (vecBodyList, elseBody')) =>
		     let
			 val env = IdMap.cloneTop env
			 val state = {env = env, isToplevel = isToplevel,
				      shared = shared, export = export,
				      lazySels = lazySels,
				      outArityInfo = outArityInfo}
			 val value = VecVal (Vector.map idDefToValue idDefs)
			 val knownValue = insertId (env, value)
			 val _ = declareArgs (env, TupArgs idDefs, isToplevel)
		     in
			 case knownValue of
			     VecVal values =>
				 if Vector.length idDefs =
				    Vector.length values
				 then
				     let
					 val idDefs = aliasVec (idDefs, values,
							      env, isToplevel)
				     in
					 if Vector.all (fn IdDef _ => false
							 | Wildcard => true)
						       idDefs
					 then (nil, vpBody (body, state))
					 else ((idDefs, vpBody (body, state))::
					       vecBodyList, elseBody)
				     end
				 else (nil, elseBody')
			   | ReflectVal (rvalue, eager) =>
				 let
				     val rvalues = UnsafeValue.cast rvalue:
						   Reflect.value vector
				 in
				     if Vector.length idDefs =
					Vector.length rvalues
				     then (aliasRValueVec (idDefs, rvalues,
							   env, isToplevel,
							   eager);
					   (nil, vpBody (body, state)))
				     else (nil, elseBody')
				 end
			   | _ =>
				 ((idDefs, vpBody (body, state))::vecBodyList,
				  elseBody')
		     end) (nil, elseBody) vecBodyVec
	    in
		(case vecBodyList of
		     nil => NONE
		   | _::_ => SOME (VecTests (Vector.fromList vecBodyList)),
		 elseBody)
	    end
	and vpExp (exp as NewExp (_, _), _, _, _, _) = (nil, exp)
	  | vpExp (exp as VarExp (info, Prim name), _, _, _, _) =
	    (PrimOps.getArity name
	     handle PrimOps.UnknownPrim =>
		 Error.error' (info, "unknown primitive " ^ name);
	     (nil, exp))
	  | vpExp (VarExp (info, idRef), env, _, _, _) =
	    (nil, varExp (info, idRef, env))
	  | vpExp (TagExp (info, labels, n, args), env, _, _, _) =
	    let
		val args = derefArgs (args, env)
	    in
		case taggedToRValue (labels, n, args, env) of
		    SOME (rvalue, eager) =>
			(nil, VarExp (info, Value (rvalue, eager)))
		  | NONE =>
			(nil, TagExp (info, labels, n, args))
	    end
	  | vpExp (ConExp (info, idRef, args), env, _, _, _) =
(*--** construct statically if possible *)
	    (nil, ConExp (info, deref (idRef, env), derefArgs (args, env)))
	  | vpExp (RefExp (info, idRef), env, _, _, _) =
	    (nil, RefExp (info, deref (idRef, env)))
	  | vpExp (TupExp (info, idRefs), env, _, _, _) =
	    let
		val idRefs = Vector.map (fn idRef => deref (idRef, env)) idRefs
	    in
		case tupleToRValue (idRefs, env) of
		    SOME (rvalue, eager) =>
			(nil, VarExp (info, Value (rvalue, eager)))
		  | NONE => (nil, TupExp (info, idRefs))
	    end
	  | vpExp (ProdExp (info, labelIdRefVec), env, _, _, _) =
	    let
		val labelIdRefVec =
		    Vector.map (fn (label, idRef) =>
				   (label, deref (idRef, env))) labelIdRefVec
	    in
		case prodToRValue (labelIdRefVec, env) of
		    SOME (rvalue, eager) =>
			(nil, VarExp (info, Value (rvalue, eager)))
		  | NONE => (nil, ProdExp (info, labelIdRefVec))
	    end
	  | vpExp (PolyProdExp (info, labelIdRefVec), env, _, _, _) =
(*--** construct statically if possible *)
	    (nil, PolyProdExp (info,
			       Vector.map (fn (label, idRef) =>
					      (label, deref (idRef, env)))
					  labelIdRefVec))
	  | vpExp (VecExp (info, idRefs), env, _, _, _) =
	    let
		val idRefs = Vector.map (fn idRef => deref (idRef, env)) idRefs
	    in
		case vectorToRValue (idRefs, env) of
		    SOME (rvalue, eager) =>
			(nil, VarExp (info, Value (rvalue, eager)))
		  | NONE => (nil, VecExp (info, idRefs))
	    end
	  | vpExp (FunExp (info, stamp, flags, typ, args, outArityOpt, body),
		   env, isToplevel, lazySels, funMap) =
	    let
		val _ = IdMap.insertScope env
		val _ = declareArgs (env, args, false)
		(* trust annotation, if exists *)
		val outArityInfo =
		    (case outArityOpt of
			 SOME _ => NONE
		       | NONE => SOME (ref UNKNOWN), stamp, funMap)
		val body =
		    vpBodyShared (body, stamp,
				  {env = env, isToplevel = false,
				   export = NONE, lazySels = lazySels,
				   outArityInfo = outArityInfo})
		val flags =
		    if isToplevel then
			if List.exists (fn IsToplevel => true | _ => false)
				       flags then flags
			else IsToplevel::flags
		    else List.filter (fn IsToplevel => false | _ => true) flags
 		val outArityOpt =
 		    case outArityInfo of
 			(SOME (ref (UNKNOWN | AMBIGUOUS)), _, _) => NONE
 		      | (SOME (ref (KNOWN arity)), _, _) => SOME arity
 		      | (NONE, _, _) => outArityOpt
 	    in
 		StampMap.insertDisjoint (funMap, stamp, outArityOpt);
 		IdMap.removeScope env;
		(nil, FunExp (info, stamp, flags, typ, args, outArityOpt,
			      patchArgs (args, lazySels) @
			      patchBody (body, lazySels, StampMap.map ())))
	    end
	  | vpExp (PrimAppExp (info, name, idRefs), env, _, _, _) =
	    (nil, vpPrimApp (info, name,
			     Vector.map (fn idRef => deref (idRef, env))
					idRefs, env))
	  | vpExp (VarAppExp (info, idRef, args), env, _, _, _) =
	    let
		val idRef = deref (idRef, env)
		val args = derefArgs (args, env)
	    in
		case lookupEnv (env, idRef) of
		    (PrimVal name, _) =>
			adaptArity (info, valOf (PrimOps.getArity name),
				    args, env,
				    fn args =>
				       vpPrimApp (info, name,
						  argsToIdRefs args, env))
		  | (FunVal (stamp, args', _), true) =>
			(*--** inlining *)
			adaptArity (info, argsToArity args', args, env,
				    fn args => FunAppExp (info, idRef,
							  stamp, args))
		  | (ReflectVal (rvalue, eager), _) =>
			(case getInArity (rvalue, eager) of
			     SOME arity =>
				 adaptArity' (info, arity, args, env,
					      fn args =>
						 DirectAppExp
						     (info, idRef, args))
			   | NONE => (nil, VarAppExp (info, idRef, args)))
		  | (_, _) => (nil, VarAppExp (info, idRef, args))
	    end
	  | vpExp (DirectAppExp (info, idRef, args), env, _, _, _) =
	    let
		val idRef = deref (idRef, env)
		val args = derefArgs (args, env)
	    in
		(nil, DirectAppExp (info, idRef, args))
	    end
	  | vpExp (SelExp (info, prod, label, n, idRef), env, _, _, _) =
	    let
		val idRef = deref (idRef, env)
	    in
		case doSel (prod, n, idRef, env) of
		    SOME idRef => (nil, VarExp (info, idRef))
		  | NONE => (nil, SelExp (info, prod, label, n, idRef))
	    end
	  | vpExp (LazyPolySelExp (info, label, idRef),
		   env, isToplevel, lazySels, _) =
	    let
		val idRef = deref (idRef, env)
		val idRefOpt =
		    case lookupEnv (env, idRef) of
			(PolyProdVal (map, _), _) =>
			    (case LabelMap.lookup (map, label) of
				 SOME value => valueToIdRefOpt value
			       | NONE => NONE)
		      | (ReflectVal (rvalue, eager), _) =>
			    if isDetermined (rvalue, eager) then
				let
				    val rvalue' =
					UnsafeValue.projPoly (rvalue, label)
				in
				    SOME (Value (rvalue', eager))
				end
			    else NONE
		      | (_, _) => NONE
	    in
		case idRefOpt of
		    SOME idRef => (nil, VarExp (info, idRef))
		  | NONE =>
		    let
			val id = Option.valOf (idRefIdOpt idRef)
			val map =
			    case IdMap.lookup (lazySels, id) of
				SOME map => map
			      | NONE => 
				    let
					val map = LabelMap.map ()
				    in
					IdMap.insert (lazySels, id, map);
					map
				    end
		    in
			(nil, VarExp (info, doLazySel (label, map,
						       env, isToplevel)))
		    end
	    end
	  | vpExp (FunAppExp (info, idRef, stamp, args), env, _, _, _) =
	    (nil, FunAppExp (info, idRef, stamp, derefArgs (args, env)))
	  | vpExp (FailExp info, _, _, _, _) = (nil, FailExp info)
	and vpBodyScope (body, {env, isToplevel, shared, export,
				lazySels, outArityInfo}) =
	    vpBody (body, {env = IdMap.cloneTop env, isToplevel = isToplevel,
			   shared = shared, export = export,
			   lazySels = lazySels,
			   outArityInfo = outArityInfo})
	and vpBodyShared (body, stamp,
			  {env, isToplevel, export, lazySels, outArityInfo}) =
	    case sortShared (body, stamp) of
		([stamp']::sorted, shared) =>
		    (assert (stamp = stamp');
		     vpBody (body, {env = env, isToplevel = isToplevel,
				    shared = shared, export = export,
				    lazySels = lazySels,
				    outArityInfo = outArityInfo}) before
		     List.app
		     (fn stamps =>
		      let
			  val _ = assert (List.null (List.tl stamps))
			  val stamp = List.hd stamps
		      in
			  case StampMap.lookupExistent (shared, stamp) of
			      UNIQUE => ()
			    | SHARED => ()   (* dead code *)
			    | VISITED (bodyOptRef, env) =>
			          let
				      val body = valOf (!bodyOptRef)
				  in
				      bodyOptRef :=
				      SOME (vpBody (body,
						    {env = env,
						     isToplevel = isToplevel,
						     shared = shared,
						     export = export,
						     lazySels = lazySels,
						     outArityInfo =
							 outArityInfo}))
				  end;
			  StampMap.removeExistent (shared, stamp)
		      end) sorted)
	      | (_, _) =>
		    raise Crash.Crash "MkValuePropagationPhase.vpBodyShared"

	fun debug component =
	    let
		val q = TextIO.openOut "vpdebug.txt"
	    in
		TextIO.output (q,
			       "\n" ^
			       OutputFlatGrammar.componentToString component ^
			       "\n");
		TextIO.closeOut q
	    end

	fun declareImport (desc, env) (id, _, url, true) =
	    let
		val value =
		    if isCross then UnknownVal
		    else
			ReflectVal (UnsafeValue.cast (loadMod (desc, url)),
				    true)
			handle _ =>
			    (TextIO.output (TextIO.stdErr,
					    "warning: could not load \
					    \compile-time import " ^
					    Url.toStringRaw url ^ "\n");
			     UnknownVal)
	    in
		declare (env, IdDef id, (value, true))
	    end
	  | declareImport (_, env) (id, _, _, false) = 
	    declareUnknown (env, IdDef id, true)

	fun translate (desc, env, component as {imports, body, exports, sign}) =
	    let
		val env' = IdMap.clone env
(*--** enter values from context into env' *)
		val _ = Vector.app (declareImport (desc, env')) imports
		val _ = IdMap.insertScope env'
		val lazySels = IdMap.map ()
		val stamp = Stamp.stamp ()
		val outArityInfo = (NONE, stamp, StampMap.map ())
		val exportset = StampSet.set ()
		val _ = Vector.app (fn (_, Id (_, stamp, _)) =>
				       StampSet.insertDisjoint
				       (exportset, stamp)) exports
		val body =
		    vpBodyShared (body, stamp,
				  {env = env', isToplevel = true,
				   export = SOME (env, exportset),
				   lazySels = lazySels,
				   outArityInfo = outArityInfo})
		val body =
		    IdMap.foldi (fn (id, _, rest) =>
				    patchIdDef (IdDef id, lazySels) @ rest)
				nil env @
		    patchIdDefs (Vector.map
				     (fn (id, _, _, _) => IdDef id) imports,
				 lazySels) @
		    patchBody (body, lazySels, StampMap.map ())
	    in
		(env, {imports = imports, body = body,
		       exports = exports, sign = sign})
	    end
	    (*--**DEBUG*)
	    handle exn as Error.Error (_, _) => raise exn
		 | exn =>
		       (TextIO.print
			"\nValuePropagationPhase crashed: \
			\dumping debug information to vpdebug.txt\n";
			debug component;
			case exn of
			    IdMap.Unknown id =>
				TextIO.print ("Unknown " ^
					      OutputFlatGrammar.idToString id ^
					      "\n")
			  | Crash.Crash s => TextIO.print ("Crash " ^ s ^ "\n")
			  | _ => TextIO.print (General.exnName exn ^ "\n");
			raise exn)

	open PrettyPrint
	infix ^/^

	fun dumpContext env =
	    hbox (text "{" ^/^
		  fbox (below (IdMap.foldi
			       (fn (id, _, rest) =>
				text (OutputFlatGrammar.idToString id) ^/^
				rest) (text "}") env)))
    end
