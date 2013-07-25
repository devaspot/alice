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
 *   $Revision: 1.10 $
 *)





functor MkScopedImpMap(ImpMap: IMP_MAP) :>
  SCOPED_IMP_MAP where type key = ImpMap.key =
struct

    type key    = ImpMap.key
    type 'a map = 'a ImpMap.t list ref
    type 'a t   = 'a map

    exception Unknown   = ImpMap.Unknown
    exception Collision = ImpMap.Collision


    fun map()			= ref[ImpMap.map()]
    fun clone(ref ms)		= ref(List.map ImpMap.clone ms)
    fun cloneScope(ref ms)	= ref[ImpMap.clone(List.hd ms)]
    fun insertScope r		= r := ImpMap.map() :: !r
    fun removeScope r		= r := List.tl(!r)
    fun removeAll r		= r := [ImpMap.map()]
    fun splitScope(r as ref ms)	= ( removeScope r ; ref[List.hd ms] )
    fun inheritScope(r,r')	= r := List.hd(!(splitScope r')) :: !r

    fun mergeScope' unionMap (r as ref ms)
				= let val ms' = List.tl ms in
				      unionMap(List.hd ms', List.hd ms) ;
				      r := ms'
				  end

    fun mergeScope r		= mergeScope' ImpMap.union r
    fun mergeDisjointScope r	= mergeScope' ImpMap.unionDisjoint r
    fun mergeScopeWith f	= mergeScope'(ImpMap.unionWith f)
    fun mergeScopeWithi f	= mergeScope'(ImpMap.unionWithi f)


    fun lookup'( [],   k)	= raise Unknown k
      | lookup'([m],   k)	= ImpMap.lookupExistent(m,k)
      | lookup'(m::ms, k)	= case ImpMap.lookup(m,k)
				    of NONE   => lookup'(ms,k)
				     | SOME a => a

    fun lookup(ref ms, k)		= SOME(lookup'(ms,k))
					  handle Unknown _ => NONE
    fun lookupExistent(ref ms, k)	= lookup'(ms,k)
    fun lookupScope(ref ms, k)		= ImpMap.lookup(List.hd ms, k)
    fun lookupExistentScope(ref ms, k)	= ImpMap.lookupExistent(List.hd ms, k)

    fun member(ref ms, k)	= ( lookup'(ms, k) ; true )
				  handle Unknown _ => false
    fun memberScope(ref ms, k)	= ImpMap.member(List.hd ms, k)

    fun isEmptyScope(ref ms)	= ImpMap.isEmpty(List.hd ms)
    fun isEmpty(ref ms)		= List.all ImpMap.isEmpty ms

    fun sizeScope(ref ms)	= ImpMap.size(List.hd ms)
    fun size(ref ms)		= List.foldl (fn(m,n) => n + ImpMap.size m) 0 ms

    fun appScope f (ref ms)	= ImpMap.app f (List.hd ms)
    fun app f (ref ms)		= List.app (ImpMap.app f) (List.rev ms)
    fun modifyScope f (ref ms)	= ImpMap.modify f (List.hd ms)
    fun modify f (ref ms)	= List.app (ImpMap.modify f) (List.rev ms)
    fun foldScope f b (ref ms)	= ImpMap.fold f b (List.hd ms)
    fun fold f b (ref ms)	= List.foldr (fn(m,b') => ImpMap.fold f b' m)
					     b ms
    fun findScope p (ref ms)	= ImpMap.find p (List.hd ms)
    fun find p (ref ms)		= let fun iter  []     = NONE
					| iter(m::ms') = case ImpMap.find p m
							   of NONE => iter ms'
							    | some => some
				  in iter ms end

    fun appiScope f (ref ms)	= ImpMap.appi f (List.hd ms)
    fun appi f (ref ms)		= List.app (ImpMap.appi f) (List.rev ms)
    fun modifyiScope f (ref ms)	= ImpMap.modifyi f (List.hd ms)
    fun modifyi f (ref ms)	= List.app (ImpMap.modifyi f) (List.rev ms)
    fun foldiScope f b (ref ms)	= ImpMap.foldi f b (List.hd ms)
    fun foldi f b (ref ms)	= List.foldr (fn(m,b') => ImpMap.foldi f b' m)
					     b ms
    fun findiScope p (ref ms)	= ImpMap.findi p (List.hd ms)
    fun findi p (ref ms)	= let fun iter  []     = NONE
					| iter(m::ms') = case ImpMap.findi p m
							   of NONE => iter ms'
							    | some => some
				  in iter ms end

    fun remove(ref ms, k)		= ImpMap.remove(List.hd ms, k)
    fun removeExistent(ref ms, k)	= ImpMap.removeExistent(List.hd ms, k)
    fun removeWith f (ref ms, k)	= ImpMap.removeWith f (List.hd ms, k)

    fun insert(ref ms, k, a)		= ImpMap.insert(List.hd ms, k, a)
    fun insertDisjoint(ref ms, k, a)	= ImpMap.insertDisjoint(List.hd ms, k,a)
    fun insertWith f (ref ms, k, a)	= ImpMap.insertWith f (List.hd ms, k, a)
    fun insertWithi f (ref ms, k, a)	= ImpMap.insertWithi f (List.hd ms, k,a)

    fun union' mapUnion (ref ms1, ref ms2)
				= let val m = List.hd ms1 in
				      List.app (fn m' => mapUnion(m,m')) ms2
				  end

    fun union x			= union' ImpMap.union x
    fun unionDisjoint x		= union' ImpMap.unionDisjoint x
    fun unionWith f		= union'(ImpMap.unionWith f)
    fun unionWithi f		= union'(ImpMap.unionWithi f)

end
