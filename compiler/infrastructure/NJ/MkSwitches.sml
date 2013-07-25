val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2000-2005
 *   Leif Kornstaedt, 2001-2002
 *
 * Last change:
 *   $Date: 2005-07-29 18:06:37 $ by $Author: rossberg $
 *   $Revision: 1.37 $
 *)




functor MkSwitches() :> SWITCHES =
struct
    val dupOut = TextIO.mkOutstream o TextIO.getOutstream

    structure Global =
    struct
	val errOut				= dupOut TextIO.stdErr
	val errWidth				= ref 80
	val logOut				= dupOut TextIO.stdOut
	val logWidth				= ref 80
	val annotOut				= dupOut TextIO.stdOut

	val dumpAnnotations			= ref false
	val minimizeComponent			= ref false
	val recursiveCompilation		= ref false
	val traceComponentAccess		= ref false
    end

    structure Warn =
    struct
	val conventions				= ref true
	val shadowing				= ref false
	val unusedImport			= ref true
	val insertedImport			= ref false
	val inaccessibleExport			= ref true
    end

    structure Language =
    struct
	val assertionLevel			= ref 0
	val allowUnclosedComponents		= ref false
	val supportRtt				= ref true
	val silentFailExp			= ref true
	val unsafeImport			= ref false
	val reexportImport			= ref false
	val retainFullImport			= ref false
	val implicitImportFile			= ref(NONE : string option)
	val dependencyFiles			= ref(nil : string list)
    end

    structure Debug =
    struct
	val dumpOut				= dupOut TextIO.stdOut
	val dumpWidth				= ref 80

	val dumpPhases				= ref false
        val dumpPhaseTimings                    = ref false
	val dumpAbstractionResult		= ref false
	val dumpElaborationResult		= ref false
	val dumpElaborationSig			= ref false
	val dumpIntermediate			= ref false
	val checkIntermediate			= ref false
	val dumpFlatteningResult		= ref false
	val dumpValuePropagationContext		= ref false
	val dumpValuePropagationResult		= ref false
	val dumpLivenessAnalysisResult		= ref false
	val dumpTarget				= ref false
    end

    structure CodeGen =
    struct
	val debugMode				= ref false
    end
end
