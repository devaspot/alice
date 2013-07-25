val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2000
 *
 * Last change:
 *   $Date: 2002-10-18 13:46:11 $ by $Author: kornstae $
 *   $Revision: 1.8 $
 *)




signature OUTPUT_FLAT_GRAMMAR =
    sig
	structure I: FLAT_GRAMMAR = FlatGrammar

	val idToString: I.id -> string
	val bodyToString: I.body -> string
	val componentToString: I.component -> string
    end
