val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 15:40:11 $ by $Author: rossberg $
 *   $Revision: 1.2 $
 *)



signature CHECK_INTERMEDIATE =
sig
    val check : IntermediateGrammar.t -> unit
end
