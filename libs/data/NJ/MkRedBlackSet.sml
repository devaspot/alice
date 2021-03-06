val assert=General.assert;
(*
 * Adapted from smlnj-lib/redblack-set-fn.sml
 *
 * Extensions and interface modifications
 *   Andreas Rossberg, 2003-2007
 *
 * Last change:
 *   $Date: 2007-02-06 14:16:11 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)

(* redblack-set-fn.sml
 *
 * COPYRIGHT (c) 1999 Bell Labs, Lucent Technologies.
 *
 * This code is based on Chris Okasaki's implementation of
 * red-black trees.  The linear-time tree construction code is
 * based on the paper "Constructing red-black trees" by Hinze,
 * and the delete function is based on the description in Cormen,
 * Leiserson, and Rivest.
 *
 * A red-black tree should satisfy the following two invariants:
 *
 *   Red Invariant: each red node has a black parent.
 *
 *   Black Condition: each path from the root to an empty node has the
 *     same number of black nodes (the tree's black height).
 *
 * The Red condition implies that the root is always black and the Black
 * condition implies that any node with only one child will be black and
 * its child will be a red leaf.
 *)




functor MkRedBlackSet (Item : ORDERED) :> SET where type item = Item.t =
  struct

    type item = Item.t

    datatype color = R | B

    datatype tree
      = E
      | T of (color * tree * item * tree)

    datatype set = SET of (int * tree)
    type t = set

    exception Unknown of item
    exception Collision of item

    fun isEmpty (SET(_, E)) = true
      | isEmpty _ = false

    val empty = SET(0, E)

    fun singleton x = SET(1, T(R, E, x, E))

    fun insertWith clash (SET(nItems, m), x) = let
	  val nItems' = ref nItems
	  fun ins E = (nItems' := nItems+1; T(R, E, x, E))
            | ins (s as T(color, a, y, b)) = (case Item.compare(x, y)
		 of LESS => (case a
		       of T(R, c, z, d) => (case Item.compare(x, z)
			     of LESS => (case ins c
				   of T(R, e, w, f) =>
					T(R, T(B,e,w,f), z, T(B,d,y,b))
                		    | c => T(B, T(R,c,z,d), y, b)
				  (* end case *))
			      | EQUAL => (clash z; T(color, T(R, c, x, d), y, b))
			      | GREATER => (case ins d
				   of T(R, e, w, f) =>
					T(R, T(B,c,z,e), w, T(B,f,y,b))
                		    | d => T(B, T(R,c,z,d), y, b)
				  (* end case *))
			    (* end case *))
			| _ => T(B, ins a, y, b)
		      (* end case *))
		  | EQUAL => (clash y; T(color, a, x, b))
		  | GREATER => (case b
		       of T(R, c, z, d) => (case Item.compare(x, z)
			     of LESS => (case ins c
				   of T(R, e, w, f) =>
					T(R, T(B,a,y,e), w, T(B,f,z,d))
				    | c => T(B, a, y, T(R,c,z,d))
				  (* end case *))
			      | EQUAL => (clash z; T(color, a, y, T(R, c, x, d)))
			      | GREATER => (case ins d
				   of T(R, e, w, f) =>
					T(R, T(B,a,y,c), z, T(B,e,w,f))
				    | d => T(B, a, y, T(R,c,z,d))
				  (* end case *))
			    (* end case *))
			| _ => T(B, a, y, ins b)
		      (* end case *))
		(* end case *))
	  val m = ins m
	  in
	    SET(!nItems', m)
	  end
    val insert = insertWith ignore
    val insertDisjoint = insertWith (fn x => raise Collision x)

  (* Remove an item.  Raises Unknown if not found. *)
    local
      datatype zipper
	= TOP
	| LEFT of (color * item * tree * zipper)
	| RIGHT of (color * tree * item * zipper)
    in
    fun removeExistent (SET(nItems, t), k) = let
	  fun zip (TOP, t) = t
	    | zip (LEFT(color, x, b, z), a) = zip(z, T(color, a, x, b))
	    | zip (RIGHT(color, a, x, z), b) = zip(z, T(color, a, x, b))
	(* bbZip propagates a black deficit up the tree until either the top
	 * is reached, or the deficit can be covered.  It returns a boolean
	 * that is true if there is still a deficit and the zipped tree.
	 *)
	  fun bbZip (TOP, t) = (true, t)
	    | bbZip (LEFT(B, x, T(R, c, y, d), z), a) = (* case 1L *)
		bbZip (LEFT(R, x, c, LEFT(B, y, d, z)), a)
	    | bbZip (LEFT(color, x, T(B, T(R, c, y, d), w, e), z), a) = (* case 3L *)
		bbZip (LEFT(color, x, T(B, c, y, T(R, d, w, e)), z), a)
	    | bbZip (LEFT(color, x, T(B, c, y, T(R, d, w, e)), z), a) = (* case 4L *)
		(false, zip (z, T(color, T(B, a, x, c), y, T(B, d, w, e))))
	    | bbZip (LEFT(R, x, T(B, c, y, d), z), a) = (* case 2L *)
		(false, zip (z, T(B, a, x, T(R, c, y, d))))
	    | bbZip (LEFT(B, x, T(B, c, y, d), z), a) = (* case 2L *)
		bbZip (z, T(B, a, x, T(R, c, y, d)))
	    | bbZip (RIGHT(color, T(R, c, y, d), x, z), b) = (* case 1R *)
		bbZip (RIGHT(R, d, x, RIGHT(B, c, y, z)), b)
	    | bbZip (RIGHT(color, T(B, T(R, c, w, d), y, e), x, z), b) = (* case 3R *)
		bbZip (RIGHT(color, T(B, c, w, T(R, d, y, e)), x, z), b)
	    | bbZip (RIGHT(color, T(B, c, y, T(R, d, w, e)), x, z), b) = (* case 4R *)
		(false, zip (z, T(color, c, y, T(B, T(R, d, w, e), x, b))))
	    | bbZip (RIGHT(R, T(B, c, y, d), x, z), b) = (* case 2R *)
		(false, zip (z, T(B, T(R, c, y, d), x, b)))
	    | bbZip (RIGHT(B, T(B, c, y, d), x, z), b) = (* case 2R *)
		bbZip (z, T(B, T(R, c, y, d), x, b))
	    | bbZip (z, t) = (false, zip(z, t))
	  fun delMin (T(R, E, y, b), z) = (y, (false, zip(z, b)))
	    | delMin (T(B, E, y, b), z) = (y, bbZip(z, b))
	    | delMin (T(color, a, y, b), z) = delMin(a, LEFT(color, y, b, z))
	    | delMin (E, _) = raise Match
	  fun join (R, E, E, z) = zip(z, E)
	    | join (_, a, E, z) = #2(bbZip(z, a))	(* color = black *)
	    | join (_, E, b, z) = #2(bbZip(z, b))	(* color = black *)
	    | join (color, a, b, z) = let
		val (x, (needB, b')) = delMin(b, TOP)
		in
		  if needB
		    then #2(bbZip(z, T(color, a, x, b')))
		    else zip(z, T(color, a, x, b'))
		end
	  fun del (E, z) = raise Unknown k
	    | del (T(color, a, y, b), z) = (case Item.compare(k, y)
		 of LESS => del (a, LEFT(color, y, b, z))
		  | EQUAL => join (color, a, b, z)
		  | GREATER => del (b, RIGHT(color, a, y, z))
		(* end case *))
	  in
	    SET(nItems-1, del(t, TOP))
	  end
    end (* local *)
    fun remove (s, x) = removeExistent (s, x) handle Unknown _ => s
    fun removeWith f (s, x) = removeExistent (s, x) handle Unknown z => (f z; s)

  (* Return true if and only if item is an element in the set *)
    fun member (SET(_, t), k) = let
	  fun find' E = false
	    | find' (T(_, a, y, b)) = (case Item.compare(k, y)
		 of LESS => find' a
		  | EQUAL => true
		  | GREATER => find' b
		(* end case *))
	  in
	    find' t
	  end

  (* return the first item in the set (or NONE if it is empty) *)
    fun choose (SET(_, t)) = let
	  fun f E = NONE
	    | f (T(_, E, x, _)) = SOME x
	    | f (T(_, a, _, _)) = f a
	  in
	    f t
	  end

  (* Return the number of items in the map *)
    fun size (SET(n, _)) = n

    fun foldl f = let
	  fun foldf (E, accum) = accum
	    | foldf (T(_, a, x, b), accum) =
		foldf(b, f(x, foldf(a, accum)))
	  in
	    fn init => fn (SET(_, m)) => foldf(m, init)
	  end

    fun foldr f = let
	  fun foldf (E, accum) = accum
	    | foldf (T(_, a, x, b), accum) =
		foldf(a, f(x, foldf(b, accum)))
	  in
	    fn init => fn (SET(_, m)) => foldf(m, init)
	  end

    val fold = foldl

(*
  (* return an ordered list of the items in the set. *)
    fun listItems s = foldr (fn (x, l) => x::l) [] s
*)

  (* functions for walking the tree while keeping a stack of parents
   * to be visited.
   *)
    fun next ((t as T(_, _, _, b))::rest) = (t, left(b, rest))
      | next _ = (E, [])
    and left (E, rest) = rest
      | left (t as T(_, a, _, _), rest) = left(a, t::rest)
    fun start m = left(m, [])

  (* Return true if and only if the two sets are equal *)
    fun equal (SET(_, s1), SET(_, s2)) = let
	  fun cmp (t1, t2) = (case (next t1, next t2)
		 of ((E, _), (E, _)) => true
		  | ((E, _), _) => false
		  | (_, (E, _)) => false
		  | ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of EQUAL => cmp (r1, r2)
			| _ => false
		      (* end case *))
		(* end case *))
	  in
	    cmp (start s1, start s2)
	  end

  (* Return the lexical order of two sets *)
    fun compare (SET(_, s1), SET(_, s2)) = let
	  fun cmp (t1, t2) = (case (next t1, next t2)
		 of ((E, _), (E, _)) => EQUAL
		  | ((E, _), _) => LESS
		  | (_, (E, _)) => GREATER
		  | ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of EQUAL => cmp (r1, r2)
			| order => order
		      (* end case *))
		(* end case *))
	  in
	    cmp (start s1, start s2)
	  end

  (* Return true if and only if the first set is a subset of the second *)
    fun subset (SET(_, s1), SET(_, s2)) = let
	  fun cmp (t1, t2) = (case (next t1, next t2)
		 of ((E, _), (E, _)) => true
		  | ((E, _), _) => true
		  | (_, (E, _)) => false
		  | ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of LESS => false
			| EQUAL => cmp (r1, r2)
			| GREATER => cmp (t1, r2)
		      (* end case *))
		(* end case *))
	  in
	    cmp (start s1, start s2)
	  end

  (* Return true if and only if the two sets are disjoint *)
    fun disjoint (SET(_, s1), SET(_, s2)) = let
	  fun disjoint (t1, t2) = (case (next t1, next t2)
		 of ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of LESS => disjoint (r1, t2)
			| EQUAL => false
			| GREATER => disjoint (t1, r2)
		      (* end case *))
		  | _ => true
		(* end case *))
	  in
	    disjoint (start s1, start s2)
	  end

  (* support for constructing red-black trees in linear time from increasing
   * ordered sequences (based on a description by R. Hinze).  Note that the
   * elements in the digits are ordered with the largest on the left, whereas
   * the elements of the trees are ordered with the largest on the right.
   *)
    datatype digit
      = ZERO
      | ONE of (item * tree * digit)
      | TWO of (item * tree * item * tree * digit)
  (* add an item that is guaranteed to be larger than any in l *)
    fun addItem (a, l) = let
	  fun incr (a, t, ZERO) = ONE(a, t, ZERO)
	    | incr (a1, t1, ONE(a2, t2, r)) = TWO(a1, t1, a2, t2, r)
	    | incr (a1, t1, TWO(a2, t2, a3, t3, r)) =
		ONE(a1, t1, incr(a2, T(B, t3, a3, t2), r))
	  in
	    incr(a, E, l)
	  end
  (* link the digits into a tree *)
    fun linkAll t = let
	  fun link (t, ZERO) = t
	    | link (t1, ONE(a, t2, r)) = link(T(B, t2, a, t1), r)
	    | link (t, TWO(a1, t1, a2, t2, r)) =
		link(T(B, T(R, t2, a2, t1), a1, t), r)
	  in
	    link (E, t)
	  end

  (* return the union of the two sets *)
    fun unionWith clashFn (SET(_, s1), SET(_, s2)) = let
	  fun ins ((E, _), n, result) = (n, result)
	    | ins ((T(_, _, x, _), r), n, result) =
		ins(next r, n+1, addItem(x, result))
	  fun union' (t1, t2, n, result) = (case (next t1, next t2)
		 of ((E, _), (E, _)) => (n, result)
		  | ((E, _), t2) => ins(t2, n, result)
		  | (t1, (E, _)) => ins(t1, n, result)
		  | ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of LESS => union' (r1, t2, n+1, addItem(x, result))
			| EQUAL => (clashFn y; union' (r1, r2, n+1, addItem(y, result)))
			| GREATER => union' (t1, r2, n+1, addItem(y, result))
		      (* end case *))
		(* end case *))
	  val (n, result) = union' (start s1, start s2, 0, ZERO)
	  in
	    SET(n, linkAll result)
	  end
    val union = unionWith ignore
    val unionDisjoint = unionWith (fn x => raise Collision x)

  (* return the intersection of the two sets *)
    fun intersect (SET(_, s1), SET(_, s2)) = let
	  fun intersect (t1, t2, n, result) = (case (next t1, next t2)
		 of ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of LESS => intersect (r1, t2, n, result)
			| EQUAL => intersect (r1, r2, n+1, addItem(x, result))
			| GREATER => intersect (t1, r2, n, result)
		      (* end case *))
		  | _ => (n, result)
		(* end case *))
	  val (n, result) = intersect (start s1, start s2, 0, ZERO)
	  in
	    SET(n, linkAll result)
	  end

  (* return the set difference *)
    fun difference (SET(_, s1), SET(_, s2)) = let
	  fun ins ((E, _), n, result) = (n, result)
	    | ins ((T(_, _, x, _), r), n, result) =
		ins(next r, n+1, addItem(x, result))
	  fun diff (t1, t2, n, result) = (case (next t1, next t2)
		 of ((E, _), _) => (n, result)
		  | (t1, (E, _)) => ins(t1, n, result)
		  | ((T(_, _, x, _), r1), (T(_, _, y, _), r2)) => (
		      case Item.compare(x, y)
		       of LESS => diff (r1, t2, n+1, addItem(x, result))
			| EQUAL => diff (r1, r2, n, result)
			| GREATER => diff (t1, r2, n, result)
		      (* end case *))
		(* end case *))
	  val (n, result) = diff (start s1, start s2, 0, ZERO)
	  in
	    SET(n, linkAll result)
	  end

    fun app f = let
	  fun appf E = ()
	    | appf (T(_, a, x, b)) = (appf a; f x; appf b)
	  in
	    fn (SET(_, m)) => appf m
	  end

    fun map f = let
	  fun addf (x, m) = insert(m, f x)
	  in
	    foldl addf empty
	  end

    fun mapPartial f = let
	  fun addf (x, m) = (case f x
	         of NONE => m
		  | SOME y => insert(m, y)
		 (* end case *))
	  in
	    foldl addf empty
	  end

  (* Filter out those elements of the set that do not satisfy the
   * predicate.  The filtering is done in increasing map order.
   *)
    fun filter pred (SET(_, t)) = let
	  fun walk (E, n, result) = (n, result)
	    | walk (T(_, a, x, b), n, result) = let
		val (n, result) = walk(a, n, result)
		in
		  if (pred x)
		    then walk(b, n+1, addItem(x, result))
		    else walk(b, n, result)
		end
	  val (n, result) = walk (t, 0, ZERO)
	  in
	    SET(n, linkAll result)
	  end

    fun partition pred (SET(_, t)) = let
	  fun walk (E, n1, result1, n2, result2) = (n1, result1, n2, result2)
	    | walk (T(_, a, x, b), n1, result1, n2, result2) = let
		val (n1, result1, n2, result2) = walk(a, n1, result1, n2, result2)
		in
		  if (pred x)
		    then walk(b, n1+1, addItem(x, result1), n2, result2)
		    else walk(b, n1, result1, n2+1, addItem(x, result2))
		end
	  val (n1, result1, n2, result2) = walk (t, 0, ZERO, 0, ZERO)
	  in
	    (SET(n1, linkAll result1), SET(n2, linkAll result2))
	  end

    fun exists pred = let
	  fun test E = false
	    | test (T(_, a, x, b)) = test a orelse pred x orelse test b
	  in
	    fn (SET(_, t)) => test t
	  end

    fun all pred = let
	  fun test E = true
	    | test (T(_, a, x, b)) = test a andalso pred x andalso test b
	  in
	    fn (SET(_, t)) => test t
	  end

    fun find pred = let
	  fun test E = NONE
	    | test (T(_, a, x, b)) = (case test a
		 of NONE => if pred x then SOME x else test b
		  | someItem => someItem
		(* end case *))
	  in
	    fn (SET(_, t)) => test t
	  end

    fun fromList l = List.foldl (Fn.flip insertDisjoint) empty l
    fun toList s = foldr op:: nil s

    fun fromVector v = Vector.foldl (Fn.flip insertDisjoint) empty v
    fun toVector s = Vector.fromList (toList s)

  end
