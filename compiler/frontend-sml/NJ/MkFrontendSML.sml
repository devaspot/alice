val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:43:51 $ by $Author: rossberg $
 *   $Revision: 1.16 $
 *)














functor MkFrontendSML (
    val loadSig :        SigLoader.t
    structure Switches : SWITCHES
) : PHASE =
let
    structure Phase1 =
	      MkTracingPhase (
		    structure Phase    = MkParsingPhase(Switches)
		    structure Switches = Switches
		    val name = "Parsing"
	      )
    structure Phase2 =
	      MkTracingPhase (
		    structure Phase    =
			MkAbstractionPhase(val loadSig = loadSig
					   structure Switches = Switches)
		    structure Switches = Switches
		    val name = "Abstraction"
	      )
    structure Phase2' =
	      MkResultDumpingPhase (
		    structure Phase    = Phase2
		    structure Switches = Switches
		    val header = "Abstract Syntax"
		    val pp     = PPAbstractGrammar.ppCom
		    val switch = Switches.Debug.dumpAbstractionResult
	      )
in
    ComposePhases' (
	structure Phase1  = Phase1
	structure Phase2  = Phase2'
	structure Context = Phase2'.C
	val context       = Pair.snd
	val context1      = ignore
	val context2      = Fn.id
    )
end
