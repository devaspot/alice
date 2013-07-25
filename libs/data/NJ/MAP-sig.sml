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
 *   $Revision: 1.4 $
 *)

signature MAP =
sig
    type key
    type 'a map
    type 'a t = 'a map

    exception Unknown   of key
    exception Collision of key

    val empty :		'a map
    val singleton :	key * 'a -> 'a map
    val fromList :	(key * 'a) list -> 'a map	(* Collision *)
    val fromVector :	(key * 'a) vector -> 'a map	(* Collision *)
    val toList :	'a map -> (key * 'a) list
    val toVector :	'a map -> (key * 'a) vector

    val insert :	'a map * key * 'a -> 'a map
    val insertDisjoint:	'a map * key * 'a -> 'a map	(* Collision *)
    val insertWith :	('a * 'a -> 'a) -> 'a map * key * 'a -> 'a map
    val insertWithi :	(key * 'a * 'a -> 'a) -> 'a map * key * 'a -> 'a map

    val remove :	'a map * key -> 'a map
    val removeExistent:	'a map * key -> 'a map		(* Unknown *)
    val removeWith :	(key -> unit) -> 'a map * key -> 'a map

    val union :		'a map * 'a map -> 'a map
    val unionDisjoint :	'a map * 'a map -> 'a map	(* Collision *)
    val unionWith :	('a * 'a -> 'a) -> 'a map * 'a map -> 'a map
    val unionWithi :	(key * 'a * 'a -> 'a) -> 'a map * 'a map -> 'a map

    val intersect :	'a map * 'a map -> 'a map
    val intersectWith :	('a * 'a -> 'a) -> 'a map * 'a map -> 'a map
    val intersectWithi:	(key * 'a * 'a -> 'a) -> 'a map * 'a map -> 'a map

    val difference :	'a map * 'a map -> 'a map

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
    val map :		('a -> 'b) -> 'a map -> 'b map
    val mapPartial :	('a -> 'b option) -> 'a map -> 'b map
    val fold :		('a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val all :		('a -> bool) -> 'a map -> bool
    val exists :	('a -> bool) -> 'a map -> bool
    val find :		('a -> bool) -> 'a map -> 'a option
    val filter :	('a -> bool) -> 'a map -> 'a map
    val partition :	('a -> bool) -> 'a map -> 'a map * 'a map

    val appi :		(key * 'a -> unit) -> 'a map -> unit
    val mapi :		(key * 'a -> 'b) -> 'a map -> 'b map
    val mapPartiali :	(key * 'a -> 'b option) -> 'a map -> 'b map
    val foldi :		(key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val alli :		(key * 'a -> bool) -> 'a map -> bool
    val existsi :	(key * 'a -> bool) -> 'a map -> bool
    val findi :		(key * 'a -> bool) -> 'a map -> (key * 'a) option
    val filteri :	(key * 'a -> bool) -> 'a map -> 'a map
    val partitioni :	(key * 'a -> bool) -> 'a map -> 'a map * 'a map
end
