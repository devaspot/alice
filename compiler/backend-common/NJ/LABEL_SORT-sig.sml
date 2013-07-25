val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2000
 *
 * Last change:
 *   $Date: 2002-08-01 13:50:45 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)





signature LABEL_SORT =
    sig
	datatype arity =
	    Tup of int
	  | Prod

	val sort: ('a -> Label.t) -> 'a list -> 'a vector * arity
    end
