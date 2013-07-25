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
 *   $Revision: 1.3 $
 *)

(*
 * Standard ML identifiers
 *
 * Definition, section 2.4
 *
 * Note:
 *   This is a generic signature to represent all kinds of identifiers (except
 *   for labels and tyvars).
 *)

signature ID =
sig
    eqtype Id
    type t = Id

    val invent:		unit -> Id
    val inventAs:	Id   -> Id

    val fromString:	string -> Id
    val toString:	Id -> string

    val compare:	Id * Id -> order
end
