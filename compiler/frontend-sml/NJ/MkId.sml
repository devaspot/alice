val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-07 12:20:44 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)

(*
 * Standard ML identifiers
 *
 * Definition, section 2.4
 *
 * Note:
 *   This is a generic functor to represent all kinds of identifiers (except
 *   labels and tyvars).
 *)





functor MkId(Stamp: STAMP) :> ID =
struct
    type Id = string
    type t  = Id

    fun invent()     = "_id" ^ Stamp.toString(Stamp.stamp())
    fun inventAs id  = "_" ^ id ^ Stamp.toString(Stamp.stamp())

    fun fromString s = s
    fun toString s   = s

    val compare      = String.compare
end
