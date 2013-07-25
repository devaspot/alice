val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2000-2005
 *
 * Last change:
 *   $Date: 2005-03-01 15:58:18 $ by $Author: rossberg $
 *   $Revision: 1.8 $
 *)






functor MkResultDumpingPhase (
    structure Phase :    PHASE
    structure Switches : SWITCHES
    val header : string
    val pp :     Phase.O.t -> PrettyPrint.doc
    val switch : bool ref
) : PHASE =
struct
    open Phase

    fun translate (desc, context, rep) =
	let
	    val result as (_, rep') = Phase.translate (desc, context, rep)
	in
	    if not (!switch) then () else
	    (
		TextIO.output (Switches.Debug.dumpOut, "-- " ^ header ^ ":\n");
		PrettyPrint.output (Switches.Debug.dumpOut, pp rep',
				   !Switches.Debug.dumpWidth);
		TextIO.output (Switches.Debug.dumpOut, "\n");
		TextIO.flushOut Switches.Debug.dumpOut
	    );
	    result
	end
end
