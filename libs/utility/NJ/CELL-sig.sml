val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-07 12:08:22 $ by $Author: rossberg $
 *   $Revision: 1.4 $
 *)



signature CELL =
sig
    eqtype 'a cell
    type 'a t = 'a cell

    val cell :		'a -> 'a cell
    val content :	'a cell -> 'a
    val replace :	'a cell * 'a -> unit
    val equal :		'a cell * 'a cell -> bool

    functor MkMap(type t) : IMP_MAP where type key = t cell
end
