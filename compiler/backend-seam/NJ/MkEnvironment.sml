val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2003-11-12 14:29:26 $ by $Author: jens $
 *   $Revision: 1.12 $
 *)










functor MkEnvironment(AbstractCodeGrammar: ABSTRACT_CODE_GRAMMAR):
    ENVIRONMENT =
    struct
	structure AbstractCodeGrammar = AbstractCodeGrammar

	type scope = AbstractCodeGrammar.idRef StampMap.t
	type ids = FlatGrammar.id list
	type index = int

	type entry = {scope: scope,
		      localIndex: index,
		      localNames: (string * Type.t) option list,
		      globalIndex: index,
		      globalIds: ids}

	type t = {filename: string,
		  context: AbstractCodeGrammar.value StampMap.t,
		  stack: entry list ref,
		  scope: scope ref,
		  localIndex: index ref,
		  localNames: (string * Type.t) option list ref,
		  globalIndex: index ref,
		  globalIds: ids ref,
		  shared: AbstractCodeGrammar.instr StampMap.t}

	fun idToString (FlatGrammar.Id (_, stamp, Name.InId)) =
	    "$" ^ Stamp.toString stamp
	  | idToString (FlatGrammar.Id (_, stamp, Name.ExId s)) =
	    "$" ^ Stamp.toString stamp ^ "[" ^ s ^ "]"

	fun startTop (filename, context) =
	    {filename = filename, context = context,
	     stack = ref nil, scope = ref (StampMap.map ()),
	     localIndex = ref 0, localNames = ref nil,
	     globalIndex = ref 0, globalIds = ref nil,
	     shared = StampMap.map ()}

	fun endTop ({stack = ref nil, localNames = ref localNames,
		     globalIds = ref nil, ...}: t) =
	    Vector.fromList (List.rev localNames)
	  | endTop {stack, globalIds, ...} =
	    if List.null (!stack) then
		let
		    val s =
			String.concatWith ", "
					  (List.map idToString (!globalIds))
		in
		    raise Crash.Crash ("MkEnvironment.endTop: globalIds " ^ s)
		end
	    else raise Crash.Crash "MkEnvironment.endTop: stack"

	fun startFn ({stack, scope, localIndex, localNames,
		      globalIndex, globalIds, ...}: t) =
	    let
		val entry = {scope = !scope,
			     localIndex = !localIndex,
			     localNames = !localNames,
			     globalIndex = !globalIndex,
			     globalIds = !globalIds}
	    in
		stack := entry::(!stack);
		scope := StampMap.map ();
		localIndex := 0; localNames := nil;
		globalIndex := 0; globalIds := nil
	    end

	fun endFn ({stack, scope, localIndex, localNames,
		    globalIndex, globalIds, ...}: t) =
	    let
		val result =
		    (Vector.fromList (List.rev (!globalIds)),
		     Vector.fromList (List.rev (!localNames)))
		val {scope = scope',
		     localIndex = localIndex',
		     localNames = localNames',
		     globalIndex = globalIndex',
		     globalIds = globalIds'} = List.hd (!stack)
	    in
		stack := List.tl (!stack); scope := scope';
		localIndex := localIndex'; localNames := localNames';
		globalIndex := globalIndex'; globalIds := globalIds';
		result
	    end

	fun filename ({filename, ...}: t) = filename

	fun nameToString (Name.ExId s) = s
	  | nameToString Name.InId = ""

	fun declare ({scope, localIndex, localNames, ...}: t,
		     FlatGrammar.Id ({typ, ...}, stamp, name)) =
	    case StampMap.lookup (!scope, stamp) of
		SOME (AbstractCodeGrammar.Local id) => id
	      | SOME (AbstractCodeGrammar.Immediate _ |
		      AbstractCodeGrammar.LastUseLocal _ |
		      AbstractCodeGrammar.Global _) =>
		    raise Crash.Crash "MkEnvironment.declare"
	      | NONE =>
		    let
			val id = !localIndex
		    in
			localIndex := id + 1;
			localNames :=
			    SOME (nameToString name, typ)::(!localNames);
			StampMap.insertDisjoint
			    (!scope, stamp, AbstractCodeGrammar.Local id);
			id
		    end

	fun fresh ({localIndex, localNames, ...}: t) =
	    let
		val id = !localIndex
	    in
		localIndex := id + 1; localNames := NONE::(!localNames); id
	    end

	fun idRefId (FlatGrammar.IdRef id) = id
	  | idRefId (FlatGrammar.LastIdRef id) = id
	  | idRefId (FlatGrammar.Lit _ | FlatGrammar.Prim _ |
		     FlatGrammar.Value _) =
	    raise Crash.Crash "MkEnvironment.idRefId"

	fun idStamp (FlatGrammar.Id (_, stamp, _)) = stamp

	fun isLast (FlatGrammar.IdRef _) = false
	  | isLast (FlatGrammar.LastIdRef _) = true
	  | isLast (FlatGrammar.Lit _ | FlatGrammar.Prim _ |
		    FlatGrammar.Value _) =
	    raise Crash.Crash "MkEnvironment.isLast"

	fun lookup ({context, scope, globalIndex, globalIds, ...}: t, idRef) =
	    let
		val id = idRefId idRef
		val stamp = idStamp id
	    in
		case StampMap.lookup (context, stamp) of
		    SOME value => AbstractCodeGrammar.Immediate value
		  | NONE =>
		case StampMap.lookup (!scope, stamp) of
		    SOME (AbstractCodeGrammar.Local id) =>
			if isLast idRef then
			    AbstractCodeGrammar.LastUseLocal id
			else AbstractCodeGrammar.Local id
		  | SOME idRef => idRef
		  | NONE =>
			let
			    val i = !globalIndex
			    val idRef = AbstractCodeGrammar.Global i
			in
			    globalIds := id::(!globalIds);
			    globalIndex := i + 1;
			    StampMap.insertDisjoint (!scope, stamp, idRef);
			    idRef
			end
	    end

	fun weakLookup ({scope, ...}: t, idRef) =
	    let
		val id = idRefId idRef
		val stamp = idStamp id
	    in
		case StampMap.lookup (!scope, stamp) of
		    SOME (AbstractCodeGrammar.Local id) => SOME id
		  | _ => NONE
	    end

	fun lookupStamp ({scope, shared, ...}: t, stamp) =
	    StampMap.lookup (!scope, stamp)

	fun lookupShared ({shared, ...}: t, stamp) =
	    StampMap.lookup (shared, stamp)

	fun declareShared ({shared, ...}: t, stamp, instr) =
	    StampMap.insertDisjoint (shared, stamp, instr)
    end
