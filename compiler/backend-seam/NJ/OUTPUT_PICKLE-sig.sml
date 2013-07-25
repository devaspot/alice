val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2002-02-10 10:54:29 $ by $Author: kornstae $
 *   $Revision: 1.4 $
 *)




signature OUTPUT_PICKLE =
    sig
	val output: PrimPickle.outstream * AbstractCodeGrammar.value -> unit
    end
