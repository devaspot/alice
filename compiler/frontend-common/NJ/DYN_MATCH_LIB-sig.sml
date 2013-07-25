val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2004-2005
 *
 * Last change:
 *   $Date: 2005-08-02 14:07:17 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)



signature DYN_MATCH_LIB =
sig
    val modlab_dynmatch :	Label.t
    val typlab_module :		Label.t

    val lab_match :		Label.t
    val lab_strengthen :	Label.t
    val lab_thin :		Label.t
    val lab_seal :		Label.t
    val lab_unpackMatch :	Label.t
end
