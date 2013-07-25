val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2004-06-30 13:13:47 $ by $Author: tack $
 *   $Revision: 1.26 $
 *)








signature ABSTRACT_CODE_GRAMMAR =
    sig
	structure Value: VALUE

	type sign = FlatGrammar.sign

	type id = int

	datatype idDef =
	    IdDef of id
	  | Wildcard

	datatype annotation =
	    Debug of (string * Type.t) option vector * Type.t
	  | Simple of int

	type coord = string * int * int

	type liveness = int vector

	type label = Atom.t

	type outArity = int

	datatype instr =
	    Entry of coord * entry_point * instr
	  | Exit of coord * exit_point * idRef * instr
	  | Kill of id vector * instr
	  | PutVar of id * idRef * instr
	  | PutNew of id * string * instr
	  | PutTag of id * int * int * idRef vector * instr
	  | PutCon of id * idRef * idRef vector * instr
	  | PutRef of id * idRef * instr
	  | PutTup of id * idRef vector * instr
	  | PutPolyRec of id * label vector * idRef vector * instr
	  | PutVec of id * idRef vector * instr
	  | Close of id * idRef vector * template * instr
	  | Specialize of id * idRef vector * template * instr
	  | AppPrim of value * idRef vector * (idDef * instr) option
	  | AppVar of idRef * idRef vector * bool *
		      (idDef vector * instr) option
	  | GetRef of id * idRef * instr
	  | GetTup of idDef vector * idRef * instr
	  | Sel of id * idRef * int * instr
	  | LazyPolySel of id vector * idRef * label vector * instr
	  | Raise of idRef
	  | Reraise of idRef
	  | Try of instr * idDef * idDef * instr
	  | EndTry of instr
	  | EndHandle of instr
	  | IntTest of idRef * (FixedInt.t * instr) vector * instr
	  | CompactIntTest of idRef * FixedInt.t * instr vector * instr
	  | RealTest of idRef * (LargeReal.t * instr) vector * instr
	  | StringTest of idRef * (string * instr) vector * instr
	  | TagTest of idRef * int * (int * instr) vector *
		       (int * idDef vector * instr) vector * instr
	  | CompactTagTest of idRef * int *
		       (idDef vector option * instr) vector * instr option
	  | ConTest of idRef * (idRef * instr) vector *
		       (idRef * idDef vector * instr) vector * instr
	  | VecTest of idRef * (idDef vector * instr) vector * instr
	  | Shared of Stamp.t * instr
	  | Return of idRef vector
	and idRef =
	    Immediate of value
	  | Local of id
	  | LastUseLocal of id
	  | Global of int
	and template =
	    Template of coord * int * 
	                annotation *
			idDef vector * outArity option * instr * liveness
	and abstractCode =
	    Function of coord * value option vector *
			annotation *
			idDef vector * outArity option * instr * liveness
	and entry_point =
	    ConEntry of Type.t * idRef * idRef vector
	  | SelEntry of int * Type.t * idRef
	  | StrictEntry of Type.t * idRef
	  | AppEntry of Type.t * idRef * idRef vector
	  | CondEntry of Type.t * idRef
	  | RaiseEntry of idRef
	  | HandleEntry of idRef
	  | SpawnEntry
	and exit_point =
	    ConExit
	  | SelExit of Type.t
	  | StrictExit
	  | AppExit
	  | CondExit of Type.t
	  | RaiseExit of Type.t
	  | HandleExit of Type.t
	  | SpawnExit of Type.t
	withtype value = abstractCode Value.t

	type t = value * (Stamp.t * Label.t) vector
    end
