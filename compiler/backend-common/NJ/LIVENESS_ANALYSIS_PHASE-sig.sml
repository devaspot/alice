val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2002
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:36 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)







signature LIVENESS_ANALYSIS_PHASE =
    sig
	structure C: CONTEXT = EmptyContext
	structure I: FLAT_GRAMMAR = FlatGrammar
	structure O: FLAT_GRAMMAR = FlatGrammar

	val translate: Source.desc * C.t * I.t -> C.t * O.t
    end

