val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:17:20 $ by $Author: rossberg $
 *   $Revision: 1.4 $
 *)



signature PP_INTERMEDIATE_GRAMMAR =
sig
    type doc = PrettyPrint.doc
    type com

    val ppCom : com -> doc
end
