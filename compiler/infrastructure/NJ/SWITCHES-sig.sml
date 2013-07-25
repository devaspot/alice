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
 *   $Revision: 1.34 $
 *)



signature SWITCHES =
sig
    structure Global :
    sig
	val errOut :				TextIO.outstream
	val errWidth :				int ref
	val logOut :				TextIO.outstream
	val logWidth :				int ref
	val annotOut :				TextIO.outstream

	val dumpAnnotations :			bool ref
	val minimizeComponent :			bool ref
	val recursiveCompilation :		bool ref
	val traceComponentAccess :		bool ref
    end

    structure Warn :
    sig
	val conventions :			bool ref
	val shadowing :				bool ref
	val unusedImport :			bool ref
	val insertedImport :			bool ref
	val inaccessibleExport :		bool ref
    end

    structure Language :
    sig
	val assertionLevel :			int ref
	val allowUnclosedComponents :		bool ref
	val supportRtt :			bool ref
	val silentFailExp :			bool ref
	val unsafeImport :			bool ref
	val reexportImport :			bool ref
	val retainFullImport :			bool ref
	val implicitImportFile :		string option ref
	val dependencyFiles :			string list ref
    end

    structure Debug :
    sig
	val dumpOut :				TextIO.outstream
	val dumpWidth :				int ref

	val dumpPhases :			bool ref
        val dumpPhaseTimings :                  bool ref
	val dumpAbstractionResult :		bool ref
	val dumpElaborationResult :		bool ref
	val dumpElaborationSig :		bool ref
	val dumpIntermediate :			bool ref
	val checkIntermediate :			bool ref
	val dumpFlatteningResult :		bool ref
	val dumpValuePropagationContext :	bool ref
	val dumpValuePropagationResult :	bool ref
	val dumpLivenessAnalysisResult :	bool ref
	val dumpTarget :			bool ref
    end

    structure CodeGen :
    sig
	val debugMode :				bool ref
    end
end
