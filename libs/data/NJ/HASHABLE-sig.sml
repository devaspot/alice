val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-07 12:01:31 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)

signature HASHABLE =
sig
    type t
    val equal :  t * t -> bool
    val hash :   t -> int
end

signature EQ_HASHABLE =
sig
    eqtype t
    val hash :    t -> int
end

functor FromEqHashable(EqHashable : EQ_HASHABLE) : HASHABLE =
struct
    type t	= EqHashable.t
    val equal	= op=
    val hash	= EqHashable.hash
end
