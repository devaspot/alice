val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-10-02 13:18:04 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)

signature SET =
sig
    type item
    type set
    type t = set

    exception Unknown of item
    exception Collision of item

    val empty :		set
    val singleton :	item -> set
    val fromList :	item list -> set		(* Collision *)
    val fromVector :	item vector -> set		(* Collision *)
    val toList :	set -> item list
    val toVector :	set -> item vector

    val insert :	set * item -> set
    val insertDisjoint:	set * item -> set		(* Collision *)
    val insertWith :	(item -> unit) -> set * item -> set

    val remove :	set * item -> set
    val removeExistent:	set * item -> set		(* Unknown *)
    val removeWith :	(item -> unit) -> set * item -> set

    val union :		set * set  -> set
    val unionDisjoint :	set * set  -> set		(* Collision *)
    val unionWith :	(item -> unit) -> set * set -> set

    val intersect :	set * set -> set
    val difference :	set * set -> set

    val size :		set -> int
    val isEmpty :	set -> bool

    val member :	set * item -> bool
    val choose :	set -> item option

    val equal :		set * set -> bool
    val subset :	set * set -> bool
    val disjoint :	set * set -> bool
    val compare :	set * set -> order		(* Unordered *)

    val app :		(item -> unit) -> set -> unit
    val map :		(item -> item) -> set -> set
    val mapPartial :	(item -> item option) -> set -> set
    val fold :		(item * 'a -> 'a) -> 'a -> set -> 'a
    val all :		(item -> bool) -> set -> bool
    val exists :	(item -> bool) -> set -> bool
    val find :		(item -> bool) -> set -> item option
    val filter :	(item -> bool) -> set -> set
    val partition :	(item -> bool) -> set -> set * set
end
