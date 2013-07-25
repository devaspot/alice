val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2002
 *
 * Last change:
 *   $Date: 2005-03-21 15:14:15 $ by $Author: rossberg $
 *   $Revision: 1.36 $
 *)












signature INTERMEDIATE_AUX =
    sig
	structure I: INTERMEDIATE_GRAMMAR = IntermediateGrammar
	structure O: FLAT_GRAMMAR = FlatGrammar

	val freshIntermediateId: I.id_info -> I.id

	val litEq: I.lit * I.lit -> bool
	val translateLit: O.lit_info * I.lit -> O.lit

	type subst = (Stamp.t * Stamp.t) list

	val substDec: I.dec * subst -> I.dec
	val substExp: I.exp * subst -> I.exp

	val separateAlt: I.pat -> I.pat

	val idEq: O.id * O.id -> bool

	structure IdKey: HASHABLE where type t = O.id
	structure IdSet: IMP_SET where type item = O.id

	val getUsedVars: O.exp * IdSet.t -> IdSet.t

	val typToArity: Type.t -> Arity.t
	val labelToIndex: Type.t * Label.t -> O.prod * int
	val prodToLabels: O.prod -> Label.t vector

	val reset: unit -> unit
    end
