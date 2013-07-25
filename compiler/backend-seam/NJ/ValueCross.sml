val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002
 *
 * Last change:
 *   $Date: 2004-06-30 13:13:47 $ by $Author: tack $
 *   $Revision: 1.8 $
 *)





structure Value (* : VALUE - must be transparent *) =
    struct
	datatype 'a t =
	    Prim of string
	  | Int of FixedInt.int
	  | String of string
	  | Real of Real.real
	  | TaggedValue of int * int * 'a t vector
	  | Tuple of 'a t vector
	  | Vector of 'a t vector
	  | Closure of 'a * 'a t vector
	  | Sign of FlatGrammar.sign option

	val prim = Prim
	val int = Int
	val string = String
	val real = Real
	fun taggedValue (labels, i, labelValueVec) =
	    TaggedValue (Vector.length labels, i,
			 Vector.map (fn (_, value) => value) labelValueVec)
	val tuple = Tuple
	val vector = Vector
	val closure = Closure
	val sign = Sign
	fun reflected _ = raise Crash.Crash "ValueCross.reflected"
    end
