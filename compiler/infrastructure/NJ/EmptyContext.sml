val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:38 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)



structure EmptyContext : CONTEXT =
struct
    type t    = unit
    val empty = ()
end
