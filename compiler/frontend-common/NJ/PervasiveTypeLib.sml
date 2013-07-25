val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-05-07 15:12:48 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)






structure PervasiveTypeLib : PERVASIVE_TYPE_LIB =
struct
    fun vallab s	= Label.fromString s
    fun modlab s	= Label.fromString s

  (* Module *)

    val modlab_pervasiveType	= modlab "PervasiveType"
    structure PervasiveType	= PervasiveType			(* verify *)

  (* Operations *)

    type typ = Type.t

    val lab_lookup	= vallab "lookup"
    val _		= PervasiveType.lookup : string -> typ	(* verify *)
end
