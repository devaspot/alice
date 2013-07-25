val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-04-11 19:33:54 $ by $Author: rossberg $
 *   $Revision: 1.2 $
 *)



signature LABEL_LIB =
sig
    val modlab_label :	Label.t
    val typlab_lab :	Label.t

    val lab_fromString:	Label.t
end
