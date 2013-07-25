val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2003
 *
 * Last change:
 *   $Date: 2003-05-07 12:01:56 $ by $Author: rossberg $
 *   $Revision: 1.1 $
 *)

signature ORDERED =
sig
    type t
    val compare : t * t -> order
end
