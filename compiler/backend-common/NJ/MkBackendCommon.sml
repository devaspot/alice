val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2004-05-07 15:09:16 $ by $Author: rossberg $
 *   $Revision: 1.28 $
 *)



















functor MkBackendCommon(val isCross: bool
			val loadMod: Source.desc * Url.t -> Reflect.module
			structure Switches: SWITCHES) =
    let
	structure Phase1 =
	    MkFlatteningPhase(structure Switches = Switches)
	structure Phase1 =
	    MkTracingPhase(structure Phase = Phase1
			   structure Switches = Switches
			   val name = "Flattening")
	structure Phase1 =
	    MkResultDumpingPhase(
		structure Phase = Phase1
		structure Switches = Switches
		val header = "Flat Syntax"
		val pp = PrettyPrint.text o OutputFlatGrammar.componentToString
		val switch = Switches.Debug.dumpFlatteningResult)
	structure BackendCommon = Phase1

	structure ValuePropagationPhase =
	    MkValuePropagationPhase(val isCross = isCross
				    val loadMod = loadMod)
	structure Phase2 =
	    MkTracingPhase(structure Phase = ValuePropagationPhase
			   structure Switches = Switches
			   val name = "Value Propagation")
	structure Phase2 =
	    MkContextDumpingPhase(
		structure Phase = Phase2
		structure Switches = Switches
		val header = "Environment after value propagation"
		val pp = ValuePropagationPhase.dumpContext
		val switch = Switches.Debug.dumpValuePropagationContext)
	structure Phase2 =
	    MkResultDumpingPhase(
		structure Phase = Phase2
		structure Switches = Switches
		val header = "Propagated Syntax"
		val pp = PrettyPrint.text o OutputFlatGrammar.componentToString
		val switch = Switches.Debug.dumpValuePropagationResult)
	structure BackendCommon =
	    ComposePhases(structure Phase1 = BackendCommon
			  structure Phase2 = Phase2)

	structure Phase3 =
	    MkTracingPhase(structure Phase = MkLivenessAnalysisPhase(Switches)
			   structure Switches = Switches
			   val name = "Liveness Analysis")
	structure Phase3 =
	    MkResultDumpingPhase(
		structure Phase = Phase3
		structure Switches = Switches
		val header = "Live Syntax"
		val pp = PrettyPrint.text o OutputFlatGrammar.componentToString
		val switch = Switches.Debug.dumpLivenessAnalysisResult)

	structure BackendCommon =
	    ComposePhases(structure Phase1 = BackendCommon
			  structure Phase2 = Phase3)
    in
	BackendCommon
    end
