val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 15:40:24 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)



signature SHARING =
sig
    type spec      = AbstractGrammar.spec
    type typlongid = AbstractGrammar.typlongid
    type inflongid = AbstractGrammar.inflongid
    type modlongid = AbstractGrammar.modlongid

    val shareTyp :	spec list * typlongid list -> spec list  (* reversed *)
    val shareSig :	spec list * inflongid list -> spec list  (* reversed *)
    val shareStr :	spec list * modlongid list -> spec list  (* reversed *)
end
