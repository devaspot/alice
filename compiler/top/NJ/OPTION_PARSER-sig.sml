val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2001
 *
 * Last change:
 *   $Date: 2005-02-15 10:35:07 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)

signature OPTION_PARSER =
    sig
	val helpText: string
        val version: string
	val banner: string
        val copyright: string

	val parse: string list -> string list
	val isOption: string -> bool
    end
