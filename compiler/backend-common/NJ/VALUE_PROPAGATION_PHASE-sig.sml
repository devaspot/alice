val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:36 $ by $Author: rossberg $
 *   $Revision: 1.8 $
 *)







signature VALUE_PROPAGATION_PHASE =
    sig
	structure C: CONTEXT
	structure I: FLAT_GRAMMAR = FlatGrammar
	structure O: FLAT_GRAMMAR = FlatGrammar

	val translate: Source.desc * C.t * I.t -> C.t * O.t
	val dumpContext: C.t -> PrettyPrint.doc
    end
