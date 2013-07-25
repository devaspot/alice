val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2004-04-15 16:34:39 $ by $Author: rossberg $
 *   $Revision: 1.19 $
 *)




functor MkHashImpSet(Item: HASHABLE) :> IMP_SET where type item = Item.t =
struct

    type item = Item.t
    type set  = item list array ref * int ref
    type t    = set

    exception Unknown   of item
    exception Collision of item


    val initialSize		= 19

    fun set()			= (ref(Array.array(initialSize,[])), ref 0)
    fun removeAll (s,k)		= if !k = 0 then () else
				  ( s := Array.array(initialSize,[]) ; k := 0 )

    fun size(_, ref n)		= n
    fun isEmpty(_, ref n)	= n = 0

    fun app f (ref t, _)	= Array.app (List.app f) t
    fun fold f a (ref t, _)	= Array.foldl(fn(ks,a) => List.foldl f a ks) a t
    fun all f (ref t, _)	= Array.all (List.all f) t
    fun exists f (ref t, _)	= Array.exists (List.exists f) t
    fun filter p (ref t, n)	= Array.modify (List.filter
				    (fn k => p k orelse (n := !n-1; false))) t
    fun find p (ref t, _)	= let val size   = Array.length t
				      fun iter i =
					  if i = size then NONE else
					  case List.find p (Array.sub(t,i))
					    of NONE => iter(i+1)
					     | some => some
				  in iter 0 end
    fun choose m		= find (fn _ => true) m


    fun clone(ref t, ref n)	= let val t' = Array.array(Array.length t, [])
				  in
				      Array.copy{src=t, dst=t', di=0};
				      (ref t', ref n)
				  end


    fun hash(t,k)		= Item.hash k mod Array.length t

    fun member((ref t,_), k)	= let val ks = Array.sub(t, hash(t,k)) in
				      List.exists (fn k' => Item.equal(k,k')) ks
				  end


    exception Remove

    fun remove'( [],   k')	= raise Remove
      | remove'(k::ks, k')	= if Item.equal(k,k') then ks
						      else k :: remove'(ks,k')

    fun removeWith f (s,k)	= let val (ref t,n) = s
				      val i   = hash(t,k)
				      val ks  = Array.sub(t,i)
				      val ks' = remove'(ks,k) before n := !n-1
						handle Remove =>
						       (f k ; ks)
				  in
				      Array.update(t,i,ks')
				  end

    val remove			= removeWith ignore
    val removeExistent		= removeWith(fn k => raise Unknown k)


    fun reinsert t k		= let val i = hash(t,k) in
				      Array.update(t, i, k::Array.sub(t,i))
				  end

    fun resize(r as ref t,ref n)= if 3 * n < 2 * Array.length t then () else
				  let
				      val t'= Array.array(2*Array.length t-1,[])
				  in
				      Array.app(List.app (reinsert t')) t ;
				      r := t'
				  end

    fun insertWith f (s,k)	= let val _  = resize s
				      val (ref t,n) = s
				      val i  = hash(t,k)
				      val ks = Array.sub(t,i)
				  in
				      if List.exists
						(fn k' => Item.equal(k,k')) ks
				      then f k
				      else ( Array.update(t, i, k::ks)
					   ; n := !n+1 )
				  end

    val insert			= insertWith ignore
    val insertDisjoint		= insertWith(fn k => raise Collision k)

    fun union(s1,s2)		= app (fn k => insert(s1,k)) s2
    fun unionDisjoint(s1,s2)	= app (fn k => insertDisjoint(s1,k)) s2
    fun unionWith f (s1,s2)	= app (fn k => insertWith f (s1,k)) s2

    fun difference(s1,s2)	= app (fn k => remove(s1,k)) s2
    fun intersect(s1,s2)	= filter (fn k => member(s2,k)) s1

    fun disjoint(s1,s2)		= all (fn k => not(member(s2,k))) s1
    fun subset(s1,s2)		= all (fn k => member(s2,k)) s1
    fun equal(s1,s2)		= size s1 = size s2  andalso subset(s1,s2)
    fun compare(s1,s2)		= case (subset(s1,s2), subset(s2,s1))
				   of (true,  true ) => EQUAL
				    | (true,  false) => LESS
				    | (false, true ) => GREATER
				    | (false, false) => raise General.Unordered

    fun fromList ks		= let val s = set() in
				      List.app (fn k => insertDisjoint(s,k)) ks;
				      s
				  end
    fun toList s		= fold op:: nil s

    fun fromVector ks		= let val s = set() in
				      Vector.app(fn k => insertDisjoint(s,k)) ks;
				      s
				  end
    fun toVector s		= Vector.fromList(toList s)
end
