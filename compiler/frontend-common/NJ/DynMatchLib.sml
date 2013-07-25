val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2004-2005
 *
 * Last change:
 *   $Date: 2005-08-02 14:07:17 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)







structure DynMatchLib : DYN_MATCH_LIB =
struct
    fun vallab s	= Label.fromString s
    fun typlab s	= Label.fromString s
    fun modlab s	= Label.fromString s

  (* Module and type field name *)

    val modlab_dynmatch	= modlab "DynMatch"
    structure DynMatch	= DynMatch				(* verify *)

    val typlab_module	= typlab "module"
    type module		= DynMatch.module			(* verify *)

  (* Operations *)

    type module		= DynMatch.module
    type inf		= Inf.t
    type rea		= Inf.rea

    val lab_match	= vallab "match"
    val _		= DynMatch.match : module * inf -> rea	(* verify *)
    val lab_strengthen	= vallab "strengthen"
    val _		= DynMatch.strengthen : module * inf -> inf (* verify *)
    val lab_thin	= vallab "thin"
    val _		= DynMatch.thin : module * inf -> module (* verify *)
    val lab_seal	= vallab "seal"
    val _		= DynMatch.seal : module * inf -> module (* verify *)
    val lab_unpackMatch	= vallab "unpackMatch"
    val _		= DynMatch.unpackMatch : module * inf * inf -> module (* verify *)
end
