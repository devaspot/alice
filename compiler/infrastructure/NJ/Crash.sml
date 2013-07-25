val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 17:51:21 $ by $Author: kornstae $
 *   $Revision: 1.9 $
 *)

(* Handling of internal inconsistencies. *)




structure Crash :> CRASH =
struct
    exception Crash of string
end
