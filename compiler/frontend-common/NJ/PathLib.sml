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





structure PathLib : PATH_LIB =
struct
    fun vallab s	= Label.fromString s
    fun typlab s	= Label.fromString s
    fun modlab s	= Label.fromString s

  (* Module and types *)

    val modlab_path	= modlab "Path"
    structure Path	= Path					(* verify *)

    val typlab_path	= typlab "path"
    type path		= Path.path				(* verify *)

  (* Operations *)

    val lab_invent	= vallab "invent"
    val _		= Path.invent : unit -> path		(* verify *)
    val lab_pervasive	= vallab "pervasive"
    val _		= Path.pervasive : string -> path	(* verify *)
    val lab_fromLab	= vallab "fromLab"
    val _		= Path.fromLab : Label.t -> path	(* verify *)
    val lab_fromString	= vallab "fromString"
    val _		= Path.fromString : string -> path	(* verify *)
end
