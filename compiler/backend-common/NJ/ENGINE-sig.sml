val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2001
 *
 * Last change:
 *   $Date: 2001-06-13 08:45:33 $ by $Author: kornstae $
 *   $Revision: 1.6 $
 *)













signature ENGINE =
    sig
	structure C: CONTEXT

	type code
	type component

	type exportDesc = (Label.t * FlatGrammar.id) vector

	exception Format of string

	val link: C.t -> code * string option -> component   (* Format *)
	val save: C.t -> component * string -> unit          (* Format *)
    end
