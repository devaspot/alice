val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-05-07 15:14:36 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)





signature PHASE =
sig
    structure C : CONTEXT
    structure I : REPRESENTATION
    structure O : REPRESENTATION

    val translate : Source.desc * C.t * I.t -> C.t * O.t   (* [Error.Error] *)
end
