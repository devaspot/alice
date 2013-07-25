val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-04-11 19:33:54 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)



signature LABEL_TRANSLATION =
sig
    val trValLabel : Label.t -> Label.t
    val trTypLabel : Label.t -> Label.t
    val trModLabel : Label.t -> Label.t
    val trInfLabel : Label.t -> Label.t
end
