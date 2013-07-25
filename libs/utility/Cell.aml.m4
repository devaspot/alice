(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-09-23 11:09:13 $ by $Author: rossberg $
 *   $Revision: 1.1 $
 *)

changequote([[,]])

import signature CELL from "CELL-sig"

ifdef([[SEAM]],[[

import structure RefMap from "../data/RefMap"

structure Cell : CELL =
struct
    type 'a cell		= 'a ref
    type 'a t			= 'a cell

    val cell			= ref
    val content			= op!
    val replace			= op:=
    val equal			= op=

    functor MkMap(type t)	=
    struct
	type t'			= t
	open RefMap
	type key		= t' ref
	type 'a map		= (t','a) map
	type 'a t		= 'a map

	exception Unknown of key
	exception Collision of key

	fun insertDisjoint(m,r,x) = RefMap.insertDisjoint(m,r,x)
	    handle RefMap.Collision => raise Collision r
	fun removeExistent(m,r) = RefMap.removeExistent(m,r)
	    handle RefMap.Unknown => raise Unknown r
	fun lookupExistent(m,r) = RefMap.lookupExistent(m,r)
	    handle RefMap.Unknown => raise Unknown r
	fun unionDisjoint(m1,m2) = appi (fn(r,x) => insertDisjoint(m1,r,x)) m2

	fun fromVector v = RefMap.fromVector v
	    handle RefMap.Collision => (* lame way to get precise exn *)
	    let
		val m = map()
	    in
		Vector.app (fn(r,x) => insertDisjoint(m,r,x)) v; m
	    end

	fun fromList l = RefMap.fromList l
	    handle RefMap.Collision => (* lame way to get precise exn *)
	    let
		val m = map()
	    in
		List.app (fn(r,x) => insertDisjoint(m,r,x)) l; m
	    end
    end
end

]],[[

import structure UnsafeCell from "UnsafeCell"

structure Cell :> CELL =
struct
    type 'a cell
    type 'a t			= 'a cell

    val cell			= UnsafeCell.cell
    val content			= UnsafeCell.content
    val replace			= UnsafeCell.replace
    val equal			= op=

    functor MkMap(type t)	=
    struct
	type key		= t cell
	type 'a map
	type 'a t		= 'a map

	exception Unknown   of key
	exception Collision of key

	val map			= UnsafeCell.Map.map
	val clone		= UnsafeCell.Map.clone
	val size		= UnsafeCell.Map.size
	val isEmpty		= UnsafeCell.Map.isEmpty
	val lookup		= UnsafeCell.Map.lookup
	val removeAll		= UnsafeCell.Map.removeAll

	fun removeWith f (m,c)	= UnsafeCell.Map.removeWith(f,m,c)
	fun insertWithi	f (m,c,x) = UnsafeCell.Map.insertWithi(f,m,c,x)
	fun app f m		= UnsafeCell.Map.app(f,m)
	fun appi f m		= UnsafeCell.Map.appi(f,m)
(*--** TODO: should be primitive
	fun modify f m		= UnsafeCell.Map.modify(f,m)
	fun modifyi f m		= UnsafeCell.Map.modifyi(f,m)
*)
	fun fold f x m		= UnsafeCell.Map.fold(f,x,m)
	fun foldi f x m		= UnsafeCell.Map.foldi(f,x,m)
(*--** TODO: should be primitive
	fun filter f m		= UnsafeCell.Map.filter(f,m)
	fun filteri f m		= UnsafeCell.Map.filteri(f,m)
*)
	fun find f m		= UnsafeCell.Map.find(f,m)
	fun findi f m		= UnsafeCell.Map.findi(f,m)
	fun choose m		= find (fn _ => true) m
	fun choosei m		= findi (fn _ => true) m

	fun exists f m		= Option.isSome(find f m)
	fun existsi f m		= Option.isSome(findi f m)
	fun all f m		= not(Option.isSome(find (fn x => not(f x)) m))
	fun alli f m		= not(Option.isSome
					(findi (fn(x,y) => not(f(x,y))) m))

	fun lookupExistent(m,c)	= case lookup(m,c) of SOME x => x
						    | NONE   => raise Unknown c

	fun member(m,c)		= Option.isSome(lookup(m,c))
	fun remove(m,c)		= removeWith ignore (m,c)
	fun removeExistent(m,c)	= removeWith(fn c => raise Unknown c) (m,c)
	fun insertWith f	= insertWithi(fn(c,x1,x2) => f(x1,x2))
	fun insert(m,c,x)	= insertWithi #3 (m,c,x)
	fun insertDisjoint ar	= insertWithi(fn(c,_,_) => raise Collision c) ar

	fun union' insert (m,n)	= appi (fn(c,x) => insert(m,c,x)) n
	fun union(m1,m2)	= union' insert (m1,m2)
	fun unionDisjoint(m1,m2) = union' insertDisjoint (m1,m2)
	fun unionWith f		= union'(insertWith f)
	fun unionWithi f	= union'(insertWithi f)

	fun difference (m1,m2)	= appi (fn(k,_) => remove(m1,k)) m2

	fun intersect' insert (m1,m2)
				= let
				      val (rs,is) =
					  foldi (fn(k,_,(rs,is)) =>
						 case lookup(m2,k)
						  of NONE   => (k::rs, is)
						   | SOME a => (rs, (k,a)::is)
						) ([],[]) m1
				  in
				      List.app (fn k => remove(m1,k)) rs;
				      List.app (fn(k,a) => insert(m1,k,a)) is
				  end
	fun intersect x		= intersect' insert x
	fun intersectWith f	= intersect'(insertWith f)
	fun intersectWithi f	= intersect'(insertWithi f)

	fun disjoint (m1,m2)	= alli (fn(k,_) => not(member(m2,k))) m1
 	fun submap eq (m1,m2)	= alli (fn(k,a) => case lookup(m2,k)
						     of NONE => false
						      | SOME a' => eq(a,a')) m1
	fun equal eq (m1,m2)	= submap eq (m1,m2) andalso submap eq (m2,m1)

	fun fromList kas	= let val m = map() in
				      List.app (fn (c,x) =>
						insertDisjoint(m,c,x)) kas;
				      m
				  end
	fun toList m		= foldi (fn(c,x,cxs) => (c,x)::cxs) nil m

	fun fromVector kas	= let val m = map() in
				      Vector.app (fn (c,x) =>
						  insertDisjoint(m,c,x)) kas;
				      m
				  end
	fun toVector m		= Vector.fromList(toList m)

(*--** TODO: should be primitive *)
	fun modify f m		= List.app (fn(k,a) =>
					    insert(m,k,f a)) (toList m)
	fun modifyi f m		= List.app (fn(k,a) =>
					    insert(m,k,f(k,a))) (toList m)
	fun filter f m		= List.app (fn(k,a) => if f a then () else
					    removeExistent(m,k)) (toList m)
	fun filteri f m		= List.app (fn(k,a) => if f(k,a) then () else
					    removeExistent(m,k)) (toList m)
    end
end

(* DEBUG version
import functor   MkStamp      from "MkStamp"
import functor   MkHashImpMap from "MkHashImpMap"
import structure Addr         from "Addr"
import signature IMP_MAP      from "IMP_MAP-sig"
import val print              from "../system/TextIO"

structure Cell :> CELL =
struct
    exception Crunk of string

    structure Stamp		= MkStamp()

    type 'a cell'
    type 'a cell		= 'a cell' * Stamp.t * 'a ref
    type 'a t			= 'a cell

    fun printStamp z		= print(Int.toString(Stamp.hash z))
    fun printAddr x		= print(Int.toString(Addr.addr x))
    fun printUnsafeCell c	= printAddr c
    fun printCell(c,z,r)	= (print "("; printUnsafeCell c; print ",";
				   printStamp z; print ","; printAddr r;
				   print ")")

    fun cell x			= (UnsafeCell.new x, Stamp.stamp())
    fun content (c, _, r)	= let val x1 = UnsafeCell.content c
				      and x2 = !r
				  in
				      if Addr.addr x1 <> Addr.addr x2
				      then raise Crunk "content"
				      else x1
				  end
    fun replace((c,_,r), x)	= (UnsafeCell.replace(c,x); r:=x)
    fun equal((c1,_,r1), (c2,_,r2))
				= if (c1 = c2) <> (r1 = r2)
				  then raise Crunk "equal"
    				  else c1 = c2

    functor MkMap(type t) :> IMP_MAP where type key = t cell =
    struct
	type key		= t cell

	structure Map		= MkHashImpMap(type t    = t cell
					       fun equal((_,_,r1),(_,_,r2)) = r1=r2
					       fun hash(_,z,_)  = Stamp.hash z)

	type 'a map'
	type 'a ran = t cell * 'a

	structure UnsafeCell = UnsafeCell : 
	sig
	    val new :		t -> t cell'
	    val content :	t cell' -> t
	    val replace :	t cell' * t -> unit

	    structure Map :
	    sig
		val new :	unit -> 'b ran map'
		val clone :	'b ran map' -> 'b ran map'

		val insertWithi:(t * 'b ran * 'b ran -> 'b ran) * 'b ran map' * t cell' * 'b ran -> unit
		val removeWith:	(t -> unit) * 'b ran map' * t cell' -> unit
		val removeAll :	'b ran map' -> unit

		val lookup :	'b ran map' * t cell' -> 'b ran option
		val isEmpty :	'b ran map' -> bool
		val size :	'b ran map' -> int

		val app :	('b ran -> unit) * 'b ran map' -> unit
		val appi :	(t cell' * 'b ran -> unit) * 'b ran map' -> unit
		val fold :	('b ran * 'c -> 'c) * 'c * 'b ran map' -> 'c
		val foldi :	(t cell' * 'b ran * 'c -> 'c) * 'c * 'b ran map' -> 'c
		val find :	('b ran -> bool) * 'b ran map' -> 'b ran option
		val findi :	(t cell' * 'b ran -> bool) * 'b ran map' -> (t cell' * 'b ran) option
	    end
	end

	type 'a map = (t cell * 'a) map' * 'a Map.t
	type 'a t   = 'a map

	exception Unknown   of key
	exception Collision of key

	fun compareMapEntry(((c1,_,_),_,_), ((c2,_,_),_,_)) =
	    Int.compare(Addr.addr c1, Addr.addr c2)
	fun compareUnsafeMapEntry((c1,_,_), (c2,_,_)) =
	    Int.compare(Addr.addr c1, Addr.addr c2)

	fun printMap m =
	    let
		val entries = List.sort compareMapEntry
				(Map.foldi (fn(q,x,l) =>
					(q, x, Map.lookup(m,q))::l) [] m)
	    in
		List.app (fn (q,x1,x2) =>
			  (print "  "; printCell q; print " -> "; printAddr x1;
			   if Option.isNone x2 then print " | -"
			   else if Addr.addr x1 <> Addr.addr(valOf x2) then
				   (print " | "; printAddr(valOf x2))
			   else ();
			   print "\n")) entries
	    end

	fun printUnsafeMap m' =
	    let
		val entries = List.sort compareUnsafeMapEntry
				(UnsafeCell.Map.foldi (fn(c,qx,l) =>
					(c, qx, UnsafeCell.Map.lookup(m',c))::l,
					[], m'))
	    in
		List.app (fn (c,(q1,x1),qxo) =>
			  (print "  "; printUnsafeCell c; print " -> ";
			   printCell q1; print ", "; printAddr x1;
			   case qxo
			    of NONE => print " | -"
			     | SOME(q2,x2) =>
			       if Addr.addr q1 <> Addr.addr q2 orelse
			          Addr.addr x1 <> Addr.addr x2
			       then (print " | "; printCell q2
			             print ", "; printAddr x2)
			       else ();
			   print "\n")) entries
	    end

 	fun check s (m',m)		=
	    (if Map.size m <> UnsafeCell.Map.size m'
	     then raise Crunk s
	     else ();
	     Map.appi (fn(q as (c,_,_), x) =>
			case Map.lookup(m,q)
			 of NONE => raise Crunk s
			  | SOME x'' =>
			if Addr.addr x <> Addr.addr x'' then raise Crunk s else
			case UnsafeCell.Map.lookup(m',c)
			 of NONE => raise Crunk s
			  | SOME(q',x') => 
			if Addr.addr q <> Addr.addr q' then raise Crunk s else
			if Addr.addr x<>Addr.addr x' then raise Crunk s else
			()) m;
	     UnsafeCell.Map.appi (fn(c, (q as (c',_,_), x')) =>
			if Addr.addr c <> Addr.addr c' then raise Crunk s else
			case UnsafeCell.Map.lookup(m',c)
			 of NONE => raise Crunk s
			  | SOME(q' as (c'',_,_), x'') =>
			if Addr.addr c'' <> Addr.addr c then raise Crunk s else
			if Addr.addr q' <> Addr.addr q then raise Crunk s else
			if Addr.addr x'' <> Addr.addr x' then raise Crunk s else
			case Map.lookup(m,q)
			 of NONE => raise Crunk s
			  | SOME x =>
			if Addr.addr x <> Addr.addr x' then raise Crunk s else
			(), m')
	    ) handle e =>
	    (print "m = {\n"; printMap m; print "}\n";
	     print "m' = {\n"; printUnsafeMap m'; print "}\n";
	     raise e)

	fun checked s p = (check s p; p)

	fun cell() = checked "cell" (UnsafeCell.Map.new(), Map.map())

	fun clone(m',m) =
	    (check "clone 1" (m',m);
	     checked "clone 2" (UnsafeCell.Map.clone m',Map.clone m))

	fun size(m',m) =
	    if UnsafeCell.Map.size m' <> Map.size m then raise Crunk "size" else
	    UnsafeCell.Map.size m'

	fun isEmpty(m',m) =
	    if UnsafeCell.Map.isEmpty m' <> Map.isEmpty m
	    then raise Crunk "isEmpty" else
	    UnsafeCell.Map.isEmpty m'

	fun lookup((m',m), q as (c,_,_)) =
	    (check "lookup" (m',m); 
	     case (UnsafeCell.Map.lookup(m',c), Map.lookup(m,q))
	     of (NONE, NONE) => NONE
	      | (SOME(q' as (c',_,_), x1),SOME x2) =>
		if Addr.addr c' <> Addr.addr c then raise Crunk "lookup" else
		if Addr.addr q' <> Addr.addr q then raise Crunk "lookup" else
		if Addr.addr x1 <> Addr.addr x2 then raise Crunk "lookup" else 
		SOME x1
	      | (SOME(q' as (c',_,_), x), NONE) =>
		if Addr.addr c' <> Addr.addr c then raise Crunk "lookup" else
		if Addr.addr q' <> Addr.addr q then raise Crunk "lookup" else
		raise Crunk "lookup"
	      | (NONE, SOME _) => raise Crunk "lookup"
	    ) handle e =>
	    (print "lookup "; printCell q; print "\n";
	     print "m = {\n"; printMap m; print "}\n";
	     print "m' = {\n"; printUnsafeMap m'; print "}\n";
	     raise e)

	fun removeAll(m',m) =
	    (check "removeAll 1" (m',m);
	     UnsafeCell.Map.removeAll m';
	     Map.removeAll m;
	     check "removeAll 2" (m',m))

	fun removeWith f ((m',m), q as (c,_,_)) =
	    (check "removeWith 1" (m',m);
	     UnsafeCell.Map.removeWith(fn _ => f q,m',c);
	     Map.removeWith f (m,q);
	     check "removeWith 2" (m',m)
	     handle e => (print "removeWith "; printCell q; print"\n"; raise e);
	     ignore(lookup((m',m),q))
	     handle e => (print "removeWith 3\n"; raise e))

	fun insertWithi	f _ = raise Crunk "insertWithi (unsupported)"

	fun app f (m',m) = UnsafeCell.Map.app(fn(q,x) => f x, m')

	fun appi f (m',m) =
	    UnsafeCell.Map.appi(fn(c,(q,x)) =>
				if Addr.addr(#1 q) <> Addr.addr c
				then raise Crunk "appi"
				else f(q,x), m')

	fun fold f x (m',m) =
	    UnsafeCell.Map.fold(fn((q,x),y) => f(x,y), x, m')

	fun foldi f x (m',m) =
	    UnsafeCell.Map.foldi(fn(c,(q,x),y) =>
				 if Addr.addr(#1 q) <> Addr.addr c
				 then raise Crunk "foldi"
				 else f(q,x,y), x, m')

	fun find f (m',m) =
	    let
		val x1 = Option.map #2 (UnsafeCell.Map.find(fn(q,x) => f x,m'))
		val x2 = Map.find f m
	    in
		case (x1, x2)
		 of (NONE, NONE) => NONE
		  | (SOME x1', SOME x2') =>
		    if Addr.addr x1' <> Addr.addr x2'
		    then raise Crunk "find"
		    else x1
		  | (SOME _, NONE) => raise Crunk "find"
		  | (NONE, SOME _) => raise Crunk "find"
	    end

	fun findi f (m',m) =
	    let
		val x1 = Option.map #2 (UnsafeCell.Map.findi(fn(c,(q,x)) =>
					     if Addr.addr(#1 q) <> Addr.addr c
					     then raise Crunk "findi"
					     else f(q,x), m'))
		val x2 = Map.findi f m
	    in
		case (x1, x2)
		 of (NONE, NONE) => NONE
		  | (SOME (q1,x1'), SOME (q2,x2')) =>
		    if Addr.addr q1 <> Addr.addr q2
		    then raise Crunk "findi" else
		    if Addr.addr x1' <> Addr.addr x2'
		    then raise Crunk "findi" else
		    x1
		  | (SOME _, NONE) => raise Crunk "findi"
		  | (NONE, SOME _) => raise Crunk "findi"
	    end

	fun lookupExistent(m,q)	= case lookup(m,q) of SOME x => x
						    | NONE   => raise Unknown q

	fun member(m,q)		= Option.isSome(lookup(m,q))
	fun remove(m,q)		= removeWith ignore (m,q)
	fun removeExistent(m,q)	= removeWith(fn q' => if Addr.addr q<>Addr.addr q' then assert false else raise Unknown q) (m,q)
	fun insertWith f	= raise Crunk "insertWith (unsupported)"

	fun insert((m',m), q as (c,_,_), x) =
	    (check "insert 1" (m',m);
	     UnsafeCell.Map.insertWithi
		 (fn(c', (q1 as (c1,_,_), _), qx2 as (q2 as (c2,_,_), _)) => 
		  if Addr.addr c' <> Addr.addr c then raise Crunk "insert" else
		  if Addr.addr c1 <> Addr.addr c then raise Crunk "insert" else
		  if Addr.addr c2 <> Addr.addr c then raise Crunk "insert" else
		  if Addr.addr q1 <> Addr.addr q then raise Crunk "insert" else
		  if Addr.addr q2 <> Addr.addr q then raise Crunk "insert" else
		  qx2, m',c,(q,x));
	     Map.insert(m,q,x);
	     check "insert 2" (m',m) handle e =>
	     		(print "insert "; printCell q;
			 print " "; printAddr x; print "\n";
			 raise e);
	     ignore(lookup((m',m),q)) handle e => (print "insert 3\n"; raise e)
	    )

	fun insertDisjoint((m',m), q as (c,_,_), x) =
	    (check "insertDisjoint 1" (m',m);
	     UnsafeCell.Map.insertWithi
		 (fn(c', (q1 as (c1,_,_), _), qx2 as (q2 as (c2,_,_), _)) => 
		  if Addr.addr c' <> Addr.addr c then raise Crunk "insert" else
		  if Addr.addr c1 <> Addr.addr c then raise Crunk "insert" else
		  if Addr.addr c2 <> Addr.addr c then raise Crunk "insert" else
		  if Addr.addr q1 <> Addr.addr q then raise Crunk "insert" else
		  if Addr.addr q2 <> Addr.addr q then raise Crunk "insert" else
		  raise Collision q, m',c,(q,x));
	     Map.insertDisjoint(m,q,x);
	     check "insertDisjoint 2" (m',m) handle e =>
			(print "insertDisjoint "; printCell q;
			 print " "; printAddr x; print "\n";
			 raise e);
	     ignore(lookup((m',m),q)) handle e =>
			(print "insertDisjoint 3\n"; raise e)
	    )

	fun union' insert (m,n)	= appi (fn(q,x) => insert(m,q,x)) n
	fun union(m1,m2)	= union' insert (m1,m2)
	fun unionDisjoint(m1,m2) = union' insertDisjoint (m1,m2)
	fun unionWith f		= union'(insertWith f)
	fun unionWithi f	= union'(insertWithi f)

	fun difference (m1,m2)	= appi (fn(k,_) => remove(m1,k)) m2

	fun intersect' insert (m1,m2)
				= let
				      val (rs,is) =
					  foldi (fn(k,_,(rs,is)) =>
						 case lookup(m2,k)
						  of NONE   => (k::rs, is)
						   | SOME a => (rs, (k,a)::is)
						) ([],[]) m1
				  in
				      List.app (fn k => remove(m1,k)) rs;
				      List.app (fn(k,a) => insert(m1,k,a)) is
				  end
	fun intersect x		= intersect' insert x
	fun intersectWith f	= intersect'(insertWith f)
	fun intersectWithi f	= intersect'(insertWithi f)
    end
end
*)

]])
