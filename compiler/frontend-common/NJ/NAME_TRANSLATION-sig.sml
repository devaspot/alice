val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-08-16 14:05:37 $ by $Author: rossberg $
 *   $Revision: 1.1 $
 *)



signature NAME_TRANSLATION =
sig
    val trValName :	Name.t -> Name.t
    val trTypName :	Name.t -> Name.t
    val trModName :	Name.t -> Name.t
    val trInfName :	Name.t -> Name.t

    val isValName :	Name.t -> bool		(* Domain *)
    val isTypName :	Name.t -> bool		(* Domain *)
    val isModName :	Name.t -> bool		(* Domain *)
    val isInfName :	Name.t -> bool		(* Domain *)
end
