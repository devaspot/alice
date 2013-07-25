val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg and Leif Kornstaedt, 2000-2007
 *
 * Last change:
 *   $Date: 2007-02-06 14:15:32 $ by $Author: rossberg $
 *   $Revision: 1.11 $
 *)




functor ComposePhases' (
    structure Phase1 :	PHASE
    structure Phase2 :	PHASE where I = Phase1.O
    structure Context :	CONTEXT
    val context :	Phase1.C.t * Phase2.C.t -> Context.t
    val context1 :	Context.t -> Phase1.C.t
    val context2 :	Context.t -> Phase2.C.t
) : PHASE =
struct
    structure C = Context
     structure I = Phase1.I
     structure O = Phase2.O
 
    fun translate (desc, c, rep) =
	let
	    val (c1,rep1) = Phase1.translate (desc, context1 c, rep)
	    val (c2,rep2) = Phase2.translate (desc, context2 c, rep1)
	in
	    (context (c1,c2), rep2)
	end
end
 
functor ComposePhases (
    structure Phase1 : PHASE
    structure Phase2 : PHASE where I = Phase1.O
) : PHASE =
let
    structure Context =
    struct
	type t    = Phase1.C.t * Phase2.C.t
	val empty = (Phase1.C.empty, Phase2.C.empty)
    end
in
    ComposePhases' (
	structure Phase1  = Phase1
	structure Phase2  = Phase2
	structure Context = Context
	val context       = Fn.id
	val context1      = Pair.fst
	val context2      = Pair.snd
    )
end
