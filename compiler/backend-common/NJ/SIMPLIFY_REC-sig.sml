val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2001
 *
 * Last change:
 *   $Date: 2001-11-06 11:17:52 $ by $Author: kornstae $
 *   $Revision: 1.10 $
 *)




signature SIMPLIFY_REC =
    sig
	structure I: INTERMEDIATE_GRAMMAR = IntermediateGrammar

	type constraint = I.longid * I.longid
	type binding = I.id * I.exp
	type alias = I.id * I.id * I.exp_info

	val derec: I.dec list -> constraint list * binding list * alias list
    end
