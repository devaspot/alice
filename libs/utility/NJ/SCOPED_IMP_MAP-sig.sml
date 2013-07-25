val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2007-02-07 16:56:45 $ by $Author: rossberg $
 *   $Revision: 1.22 $
 *)

 (*
 * A stateful scoped map (a stateful stack of stateful maps).
 *)

signature SCOPED_IMP_MAP =
sig
    type key
    type 'a map
    type 'a t = 'a map

    exception Unknown   of key
    exception Collision of key

    val map :			unit -> 'a map

    val clone :			'a map -> 'a map
    val cloneScope :		'a map -> 'a map

    val insertScope :		'a map -> unit
    val removeScope :		'a map -> unit
    val removeAll :		'a map -> unit
    val inheritScope :		'a map * 'a map -> unit
    val splitScope :		'a map -> 'a map

    val mergeScope :		'a map -> unit
    val mergeDisjointScope :	'a map -> unit			(* Collision *)
    val mergeScopeWith :	('a * 'a -> 'a) -> 'a map -> unit
    val mergeScopeWithi :	(key * 'a * 'a -> 'a) -> 'a map -> unit

    val remove :		'a map * key -> unit
    val removeExistent :	'a map * key -> unit		(* Unknown *)
    val removeWith :		(key -> unit) -> 'a map * key -> unit

    val insert :		'a map * key * 'a -> unit
    val insertDisjoint :	'a map * key * 'a -> unit	(* Collision *)
    val insertWith :		('a * 'a -> 'a) -> 'a map * key * 'a -> unit
    val insertWithi :		(key * 'a * 'a -> 'a) -> 'a map * key * 'a
									 -> unit
    val union :			'a map * 'a map -> unit
    val unionDisjoint :		'a map * 'a map -> unit		(* Collision *)
    val unionWith :		('a * 'a -> 'a) -> 'a map * 'a map -> unit
    val unionWithi :		(key * 'a * 'a -> 'a) -> 'a map * 'a map -> unit

    val lookup :		'a map * key -> 'a option
    val lookupScope :		'a map * key -> 'a option
    val lookupExistent :	'a map * key -> 'a		(* Unknown *)
    val lookupExistentScope :	'a map * key -> 'a		(* Unknown *)

    val member :		'a map * key -> bool
    val memberScope :		'a map * key -> bool

    val size :			'a map -> int
    val sizeScope :		'a map -> int

    val isEmpty :		'a map -> bool
    val isEmptyScope :		'a map -> bool

    val app :			('a -> unit) -> 'a map -> unit
    val appScope :		('a -> unit) -> 'a map -> unit
    val appi :			(key * 'a -> unit) -> 'a map -> unit
    val appiScope :		(key * 'a -> unit) -> 'a map -> unit

    val modify :		('a -> 'a) -> 'a map -> unit
    val modifyScope :		('a -> 'a) -> 'a map -> unit
    val modifyi :		(key * 'a -> 'a) -> 'a map -> unit
    val modifyiScope :		(key * 'a -> 'a) -> 'a map -> unit

    val fold :			('a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val foldScope :		('a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val foldi :			(key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b
    val foldiScope :		(key * 'a * 'b -> 'b) -> 'b -> 'a map -> 'b

    val find :			('a -> bool) -> 'a map -> 'a option
    val findScope :		('a -> bool) -> 'a map -> 'a option
    val findi :			(key * 'a -> bool) -> 'a map -> (key *'a) option
    val findiScope :		(key * 'a -> bool) -> 'a map -> (key *'a) option
end
