val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 15:40:27 $ by $Author: rossberg $
 *   $Revision: 1.2 $
 *)



signature PHASE_ERROR =
sig
    type error		(* a datatype of possible errors *)
    type warning	(* a datatype of possible warnings *)

    val error:	Error.region * error -> 'a	(* format and print error *)
    val warn:	Error.region * warning -> unit	(* format and print warning *)
end
