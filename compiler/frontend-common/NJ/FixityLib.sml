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





structure FixityLib : FIXITY_LIB =
struct
    fun vallab s	= Label.fromString s
    fun typlab s	= Label.fromString s
    fun modlab s	= Label.fromString s

  (* Module and types *)

    val modlab_fixity	= modlab "Fixity"
    structure Fixity	= Fixity				(* verify *)

    val typlab_fix	= typlab "fix"
    datatype fix	= datatype Fixity.fix			(* verify *)
    val typlab_assoc	= typlab "assoc"
    datatype assoc	= datatype Fixity.assoc			(* verify *)

    val lab_nonfix	= vallab "NONFIX"
    val _		= NONFIX : fix				(* verify *)
    val lab_prefix	= vallab "PREFIX"
    val _		= PREFIX : int -> fix			(* verify *)
    val lab_postfix	= vallab "POSTFIX"
    val _		= POSTFIX : int -> fix			(* verify *)
    val lab_infix	= vallab "INFIX"
    val _		= INFIX : int * assoc -> fix		(* verify *)

    val lab_left	= vallab "LEFT"
    val _		= LEFT : assoc				(* verify *)
    val lab_right	= vallab "RIGHT"
    val _		= RIGHT : assoc				(* verify *)
    val lab_neither	= vallab "NEITHER"
    val _		= NEITHER : assoc			(* verify *)
end
