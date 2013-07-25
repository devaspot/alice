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
 *   $Revision: 1.7 $
 *)





signature VALUE =
    sig
	type 'a t

	val prim: string -> 'a t
	val int: FixedInt.int -> 'a t
	val string: string -> 'a t
	val real: Real.real -> 'a t
	val taggedValue: Label.t vector * int * (Label.t * 'a t) vector -> 'a t
	val tuple: 'a t vector -> 'a t
	val vector: 'a t vector -> 'a t
	val closure: 'a * 'a t vector -> 'a t
	val sign: FlatGrammar.sign option -> 'a t
	val reflected: Reflect.value -> 'a t
    end
