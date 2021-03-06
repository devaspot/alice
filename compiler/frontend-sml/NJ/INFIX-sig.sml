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
 *   $Revision: 1.6 $
 *)

(*
 * Standard ML infix resolution
 *
 * Definition, section 2.6
 *)






signature INFIX =
sig
    (* Import *)

    structure Grammar: INPUT_GRAMMAR = InputGrammar

    (* Infix environment *)

    datatype Assoc = LEFT | RIGHT
    type InfStatus = (Assoc * int) option

    type InfEnv    = VId.t -> InfStatus

    (* Resolving phrases containing infixed identifiers *)

    val exp :	InfEnv -> Grammar.Exp -> Grammar.Exp
    val pat :	InfEnv -> Grammar.Pat -> Grammar.Pat
end
