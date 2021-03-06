val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 15:40:23 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)

(*
 * Standard ML label identifiers
 *
 * Definition, section 2.4
 *)

signature LAB =
sig
    eqtype Lab
    type t = Lab

    val fromString:	string       -> Lab
    val fromInt:	int          -> Lab
    val fromLargeInt:	LargeInt.int -> Lab
    val toString:	Lab          -> string
end
