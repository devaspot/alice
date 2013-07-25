val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2001
 *
 * Last change:
 *   $Date: 2001-11-05 22:01:18 $ by $Author: kornstae $
 *   $Revision: 1.4 $
 *)




structure Arity :> ARITY =
    struct
	datatype t =
	    Unary
	  | Tuple of int
	    (* must be >= 0 *)
	  | Product of Label.t vector
	    (* sorted, all labels distinct, no tuple *)
    end
