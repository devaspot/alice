val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2007-02-07 16:56:30 $ by $Author: rossberg $
 *   $Revision: 1.4 $
 *)





signature BIND_ENV_FROM_SIG =
sig
    type sign = Inf.sign
    val envFromSig :	Source.region * sign -> BindEnv.t
end
