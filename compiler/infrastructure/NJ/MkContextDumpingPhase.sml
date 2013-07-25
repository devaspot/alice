val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2000-2005
 *   Leif Kornstaedt, 2001
 *
 * Last change:
 *   $Date: 2005-03-01 15:58:18 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)






functor MkContextDumpingPhase (
    structure Phase :    PHASE
    structure Switches : SWITCHES
    val header : string
    val pp :     Phase.C.t -> PrettyPrint.doc
    val switch : bool ref
) : PHASE =
struct
    open Phase

    fun translate (desc, context, rep) =
	let
	    val result as (context', _) = Phase.translate (desc, context, rep)
	in
	    if not (!switch) then () else
	    (
		TextIO.output (Switches.Debug.dumpOut, "-- " ^ header ^ ":\n");
		PrettyPrint.output (Switches.Debug.dumpOut, pp context',
				   !Switches.Debug.dumpWidth);
		TextIO.output (Switches.Debug.dumpOut, "\n");
		TextIO.flushOut Switches.Debug.dumpOut
	    );
	    result
	end
end
