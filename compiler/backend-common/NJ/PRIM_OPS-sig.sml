val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000
 *
 * Last change:
 *   $Date: 2001-01-15 15:38:03 $ by $Author: rossberg $
 *   $Revision: 1.4 $
 *)





signature PRIM_OPS =
    sig
	exception UnknownPrim

	val getArity: string -> Arity.t option   (* UnknownPrim *)
    end
