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
 *   $Revision: 1.4 $
 *)




structure LabelLib : LABEL_LIB =
struct
    fun vallab s	= Label.fromString s
    fun typlab s	= Label.fromString s
    fun modlab s	= Label.fromString s

  (* Module and types *)

    val modlab_label	= modlab "Label"
    structure Label	= Label					(* verify *)

    val typlab_lab	= typlab "lab"
    type lab		= Label.lab				(* verify *)

  (* Operations *)

    val lab_fromString	= vallab "fromString"
    val _		= Label.fromString : string -> lab	(* verify *)
end
