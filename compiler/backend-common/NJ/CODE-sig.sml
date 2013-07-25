val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2001
 *
 * Last change:
 *   $Date: 2001-01-05 14:01:07 $ by $Author: kornstae $
 *   $Revision: 1.3 $
 *)

signature CODE =
    sig
	type t

	val toString: t -> string
	val cleanup: t -> unit
    end
