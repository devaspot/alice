val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2007-02-18 12:56:15 $ by $Author: rossberg $
 *   $Revision: 1.22 $
 *)

signature IMP_MAP =
sig
    type key
    (*__eqeqtype*)eqtype 'a map
    type 'a t = 'a map

    exception Unknown of key
    exception Collision of key

    val map :		unit -> 'a map
    val clone :		'a map -> 'a map
    val fromList :	(key * 'a) list -> 'a map	(* Collision *)
    val fromVector :	(key * 'a) vector -> 'a map	(* Collision *)
    val toList :	'a map -> (key * 'a) list
    val toVector :	'a map -> (key * 'a) vector

    val insert :	'a map * key * 'a -> unit
    val insertDisjoint:	'a map * key * 'a -> unit	(* Collision *)
    val insertWith :	('a * 'a -> 'a) -> 'a map * key * 'a -> unit
    val insertWithi :	(key * 'a * 'a -> 'a) -> 'a map * key * 'a -> unit

    val remove :	'a map * key -> unit
    val removeExistent:	'a map * key -> unit		(* Unknown *)
    val removeWith :	(key -> unit) -> 'a map * key -> unit
    val removeAll :	'a map -> unit

    val union :		'a map * 'a map -> unit
    val unionDisjoint :	'a map * 'a map -> unit		(* Collision *)
    val unionWith :	('a * 'a -> 'a) -> 'a map * 'a map -> unit
    val unionWithi :	(key * 'a * 'a -> 'a) -> 'a map * 'a map -> unit

    val intersect :	'a map * 'a map -> unit
    val intersectWith :	('a * 'a -> 'a) -> 'a map * 'a map -> unit
    val intersectWithi:	(key * 'a * 'a -> 'a) -> 'a map * 'a map -> unit

    val difference :	'a map * 'a map -> unit

    val size :		'a map -> int
    val isEmpty :	'a map -> bool

    val member :	'a map * key -> bool
    val lookup :	'a map * key -> 'a option
    val lookupExistent:	'a map * key -> 'a		(* Unknown *)
    val choose :	'a map -> 'a option
    val choosei :	'a map -> (key * 'a) option

    val equal :		('a * 'a -> bool) -> 'a map * 'a map -> bool
    val submap :	('a * 'a -> bool) -> 'a map * 'a map -> bool
    val disjoint :	'a map * 'a map -> bool

    val app :		('a -> unit) -> 'a map -> unit
    val modify :	('a -> 'a) -> 'a map -> unit
    val fold :		('a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val all :		('a -> bool) -> 'a map -> bool
    val exists :	('a -> bool) -> 'a map -> bool
    val find :		('a -> bool) -> 'a map -> 'a option
    val filter :	('a -> bool) -> 'a map -> unit

    val appi :		(key * 'a -> unit) -> 'a map -> unit
    val modifyi :	(key * 'a -> 'a) -> 'a map -> unit
    val foldi :		(key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val alli :		(key * 'a -> bool) -> 'a map -> bool
    val existsi :	(key * 'a -> bool) -> 'a map -> bool
    val findi :		(key * 'a -> bool) -> 'a map -> (key * 'a) option
    val filteri :	(key * 'a -> bool) -> 'a map -> unit
end
