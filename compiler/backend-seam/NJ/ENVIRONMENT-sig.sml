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
 *   $Revision: 1.18 $
 *)







signature ENVIRONMENT =
    sig
	structure AbstractCodeGrammar: ABSTRACT_CODE_GRAMMAR

	type t

	val startTop: string * AbstractCodeGrammar.value StampMap.t -> t
	val endTop: t -> (string * Type.t) option vector
	val startFn: t -> unit
	val endFn: t -> FlatGrammar.id vector * (string * Type.t) option vector
	val filename: t -> string
	val declare: t * FlatGrammar.id -> AbstractCodeGrammar.id
	val fresh: t -> AbstractCodeGrammar.id
	val lookup: t * FlatGrammar.idRef -> AbstractCodeGrammar.idRef
	val weakLookup: t * FlatGrammar.idRef -> AbstractCodeGrammar.id option
	val lookupStamp: t * Stamp.t -> AbstractCodeGrammar.idRef option
	val lookupShared: t * Stamp.t -> AbstractCodeGrammar.instr option
	val declareShared: t * Stamp.t * AbstractCodeGrammar.instr -> unit
    end
