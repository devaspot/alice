val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:37 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)







signature CODE_GEN_PHASE =
    sig
	structure C: CONTEXT
	structure I: FLAT_GRAMMAR = FlatGrammar
	structure O: ABSTRACT_CODE_GRAMMAR

	val translate: Source.desc * C.t * I.component -> C.t * O.t
    end
