val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2002
 *
 * Last change:
 *   $Date: 2002-09-09 18:05:09 $ by $Author: rossberg $
 *   $Revision: 1.8 $
 *)

(*
 * A generic pretty printer.
 *
 * Based on:
 *    Philip Wadler. "A prettier printer"
 *    http://cm.bell-labs.com/cm/cs/who/wadler/
 * and Christian Lindig's port to OCaml.
 *
 * The semantics has been extended to allow 4 different kinds of
 * groups (`boxes'), 2 modes of nesting, and varying break representations.
 * This is no more easily described by an algebra though, and the `below'
 * combinator looses optimality.
 *)





structure PrettyPrint :> PRETTY_PRINT =
struct

    (* Types *)

    datatype mode = H | V | F | A

    datatype doc =
	  EMPTY
	| BREAK of string
	| TEXT  of string
	| CONS  of doc * doc
	| BOX   of mode * doc
	| NEST  of int * doc
	| BELOW of doc

    datatype prim =
	  PTEXT of string
	| PLINE of int


    (* Interface operators *)

    infixr ^^ ^/^

    val empty	= EMPTY
    val break	= BREAK " "
    val ebreak	= BREAK ""
    val text	= TEXT

    fun x ^^ EMPTY	= x
      | EMPTY ^^ y	= y
      | x ^^ y		= CONS(x, y)

    fun x ^/^ EMPTY	= x
      | EMPTY ^/^ y	= y
      | x ^/^ y		= CONS(x, CONS(break, y))

    fun below EMPTY	= EMPTY
      | below x		= BELOW x

    fun hbox EMPTY	= EMPTY
      | hbox x		= BOX(H, x)

    fun vbox EMPTY	= EMPTY
      | vbox x		= BOX(V, x)

    fun fbox EMPTY	= EMPTY
      | fbox x		= BOX(F, x)

    fun abox EMPTY	= EMPTY
      | abox x		= BOX(A, x)

    fun nest k EMPTY	= EMPTY
      | nest k x	= NEST(k, x)


    fun isEmpty EMPTY	= true
      | isEmpty _	= false


    (* Check whether the first line of a document fits into remaining characters *)

    (* We abuse the mode A (which can never occur in the lists passed to
     * fits) to flag breaks which occur inside swallowed vboxes.
     *)

    fun fits(w, z) =
	w >= 0 andalso
	case z
	  of []			=> true
	   | (i,m,EMPTY)::z	=> fits(w, z)
	   | (i,m,CONS(x,y))::z	=> fits(w, (i,m,x)::(i,m,y)::z)
	   | (i,m,TEXT s)::z	=> fits(w - String.size s, z)
	   | (i,H,BREAK s)::z	=> fits(w - String.size s, z)
	   | (i,A,BREAK s)::z	=> false	(* A abused as inner V *)
	   | (i,m,BREAK s)::z	=> true
	   (* Adjacent boxes are assumed "as vertical as possible": *)
	   | (i,V,BOX(H,x))::z	=> fits(w, (i,H,x)::z)
	   | (i,V,BOX(n,x))::z	=> fits(w, (i,V,x)::z)
	   (* Inner boxes may never be vertical: *)
	   | (i,m,BOX(V,x))::z	=> fits(w, (i,A,x)::z)
	   | (i,m,BOX(n,x))::z	=> fits(w, (i,H,x)::z)
	   | (i,m,NEST(j,x))::z	=> fits(w, (i,m,x)::z)
	   | (i,m,BELOW x)::z	=> fits(w, (i,m,x)::z)


    (* Layout *)

    fun best(w, k, z, a) =
	case z
	  of []			=> List.rev a
	   | (i,m,EMPTY)::z	=> best(w, k, z, a)
	   | (i,m,CONS(x,y))::z	=> best(w, k, (i,m,x)::(i,m,y)::z, a)
	   | (i,m,TEXT s)::z	=> best(w, k + String.size s, z, PTEXT(s)::a)
	   | (i,H,BREAK s)::z	=> horizontal(w, k, s, z, a)
	   | (i,V,BREAK s)::z	=> vertical(w, i, z, a)
	   | (i,F,BREAK s)::z	=> if fits(w - k - String.size s, z)
				   then horizontal(w, k, s, z, a)
				   else vertical(w, i, z, a)
	   | (i,A,BREAK s)::z	=> raise Fail "PrettyPrint.best"
	   | (i,m,BOX(A,x))::z	=> if fits(w - k, (i,H,x)::z)
				   then best(w, k, (i,H,x)::z, a)
				   else best(w, k, (i,V,x)::z, a)
	   | (i,m,BOX(n,x))::z	=> best(w, k, (i,n,x)::z, a)
	   | (i,m,NEST(j,x))::z	=> best(w, k, (i+j,m,x)::z, a)
	   | (i,m,BELOW x)::z	=> best(w, k, (k,m,x)::z, a)

    and horizontal(w, k, s, z, a) =
	    best(w, k + String.size s, z, PTEXT(s)::a)

    and vertical(w, i, z, a) =
	    best(w, i, z, PLINE(i)::a)


    fun layout(doc, w) = best(w, 0, [(0,V,doc)], [])



    (* Convert a document *)

    fun primToString(PTEXT s) = s
      | primToString(PLINE i) = 
	    String.implode(#"\n" :: List.tabulate(i, fn _ => #" "))

    val toString = String.concat o List.map primToString o layout



    (* Output a document directly (is MUCH faster!) *)

    fun loop 0 f = ()
      | loop n f = ( f() ; loop (n-1) f )

    fun outputPrim os (PTEXT s) = TextIO.output(os, s)
      | outputPrim os (PLINE i) =
	    ( TextIO.output1(os, #"\n")
	    ; loop i (fn() => TextIO.output1(os, #" "))
	    )

    fun output(os, doc, w) = List.app (outputPrim os) (layout(doc, w))

end
