val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2001-2003
 *
 * Last change:
 *   $Date: 2005-07-29 18:06:40 $ by $Author: rossberg $
 *   $Revision: 1.22 $
 *)








functor MkOptionParser(Switches: SWITCHES) :> OPTION_PARSER =
    struct
	val major = Int.toString (#major Config.version)
	val minor = Int.toString (#minor Config.version)
	val revision = Int.toString (#revision Config.version)
	val version = major ^ "." ^ minor ^
	              (if revision = "0" then "" else "." ^ revision)
	val banner = "Alice " ^ version ^ " (\"" ^ Config.codename ^
		     "\"), mastered " ^
		     Date.fmt "%Y/%m/%d" Config.buildDate ^ "\n"
	val copyright = "Copyright (c) 1999-" ^ Date.fmt "%Y" Config.buildDate
			^ " Programming Systems Lab, Saarland University,\n"
			^ "and the individual authors"

	val helpText =
	    "Options:\n\
	    \Gobal options:\n\
	    \\t -z, --minimize\n\
	    \\t\tMinimize output components.\n\
	    \\t--recursive-compilation\n\
	    \\t\tCompile imported components recursively if necessary.\n\
	    \\t--trace-component-access\n\
	    \\t\tTrace component loads and saves by the compiler.\n\
	    \\t--annotations-file <output file>\n\
	    \\t\tWrite type annotations to <output file>.\n\
	    \Warning options:\n\
	    \\t--warn-conventions\n\
	    \\t\tWarn about naming convention violations (default).\n\
	    \\t--warn-shadowing\n\
	    \\t\tWarn about shadowing of identifiers.\n\
	    \\t--warn-unused-imports\n\
	    \\t\tWarn about unused imports (default).\n\
	    \\t--warn-added-imports\n\
	    \\t\tWarn about imports inserted by the compiler.\n\
	    \\t--warn-inaccessible-exports\n\
	    \\t\tWarn about inaccessible types occuring in export signature (default).\n\
	    \Language options:\n\
	    \\t--assert <int>\n\
	    \\t\tSpecify assertion level for compiled code.\n\
	    \\t--retain-full-import\n\
	    \\t\tWhether to reduce import signatures to the entities used.\n\
	    \\t--reexport-import\n\
	    \\t\tMake imported entities part of the component.\n\
	    \\t--dependency-file <dependency file>|-\n\
	    \\t\tSpecify file containing dependencies for missing imports.\n\
	    \\t--implicit-import-file <import file>|-\n\
	    \\t\tSpecify file containing implicit import announcements.\n\
	    \\t--rtt\n\
	    \\t\tWhether to generate code for runtime types.\n\
	    \\t--silent-fail\n\
	    \\t\tWhether FailExp's should be translated to failed futures.\n\
	    \Debug options:\n\
	    \\t--version\n\
	    \\t\tPrint compiler version.\n\
	    \\t--dryrun\n\
	    \\t\tCompile standard input, not writing any output.\n\
	    \\t--dump-phases\n\
            \\t\tTrace the running phases.\n\
	    \\t--dump-phase-timings\n\
            \\t\tShow timings for phase execution.\n\
            \\t--dump-abstraction-result\n\
	    \\t\tDump abstract representation.\n\
	    \\t--dump-elaboration-result\n\
	    \\t\tDump abstract representation after elaboration.\n\
	    \\t--dump-elaboration-sig\n\
	    \\t\tDump component signatures after elaboration.\n\
	    \\t--dump-intermediate\n\
	    \\t\tDump intermediate representation.\n\
	    \\t--check-intermediate\n\
	    \\t\tType-check intermediate representation.\n\
	    \\t--dump-flattening-result\n\
	    \\t\tDump flat representation after flattening.\n\
	    \\t--dump-value-propagation-context\n\
	    \\t\tDump environment after value propagation.\n\
	    \\t--dump-value-propagation-result\n\
	    \\t\tDump flat representation after value propagation.\n\
	    \\t--dump-liveness-analysis-result\n\
	    \\t\tDump flat representation after liveness analysis.\n\
	    \\t--dump-target\n\
	    \\t\tDump target code representation.\n\
            \Inverting options:\n\
            \\tEvery option can be prefixed with no-, e.g.\n\
            \\t--no-dump-target\n\
            \\n\
            \Report bugs using our online bug-tracking system:\n\
            \http://www.ps.uni-sb.de/alice/bugzilla/\n"

	open Switches

	val booleanSwitches =
	    [("z", Global.minimizeComponent),
	     ("minimize", Global.minimizeComponent),
	     ("recursive-compilation", Global.recursiveCompilation),
	     ("trace-component-access", Global.traceComponentAccess),
	     ("warn-conventions", Warn.conventions),
	     ("warn-shadowing", Warn.shadowing),
	     ("warn-unused-imports", Warn.unusedImport),
	     ("warn-added-imports", Warn.insertedImport),
	     ("warn-inaccessible-exports", Warn.inaccessibleExport),
	     ("rtt", Language.supportRtt),
	     ("reexport-import", Language.reexportImport),
	     ("retain-full-import", Language.retainFullImport),
	     ("silent-fail", Language.silentFailExp),
	     ("dump-phases", Debug.dumpPhases),
             ("dump-phase-timings", Debug.dumpPhaseTimings),
	     ("dump-abstraction-result", Debug.dumpAbstractionResult),
	     ("dump-elaboration-result", Debug.dumpElaborationResult),
	     ("dump-elaboration-sig", Debug.dumpElaborationSig),
	     ("dump-intermediate", Debug.dumpIntermediate),
	     ("check-intermediate", Debug.checkIntermediate),
	     ("dump-flattening-result", Debug.dumpFlatteningResult),
	     ("dump-value-propagation-context",
	      Debug.dumpValuePropagationContext),
	     ("dump-value-propagation-result",
	      Debug.dumpValuePropagationResult),
	     ("dump-liveness-analysis-result",
	      Debug.dumpLivenessAnalysisResult),
	     ("dump-target", Debug.dumpTarget),
	     ("generate-debug-code", CodeGen.debugMode)]

	fun checkBooleanSwitches (s, (name, switch)::rest) =
	    if size name = 1 andalso "-" ^ name = s orelse "--" ^ name = s
	    then (switch := true; true)
	    else if "--no-" ^ name = s then (switch := false; true)
	    else checkBooleanSwitches (s, rest)
	  | checkBooleanSwitches (_, nil) = false

	fun parse ("--dependency-file"::file::rest) =
	    (Language.dependencyFiles := file::(!Language.dependencyFiles);
	     parse rest)
	  | parse ("--implicit-import-file"::file::rest) =
	    (Language.implicitImportFile :=
		(if file = "-" then NONE else SOME file);
	     parse rest)
	  | parse ("--annotations-file"::file::rest) =
	    (if file = "-" then Global.dumpAnnotations := false else
	     TextIO.setOutstream(Global.annotOut,
				 TextIO.getOutstream(TextIO.openOut file))
	     before Global.dumpAnnotations := true
	     handle IO.Io _ => Global.dumpAnnotations := false;
	     parse rest)
	  | parse (all as "--assert"::num::rest) =
	    (case Int.fromString num of
		  SOME n => (Language.assertionLevel := n; parse rest)
		| NONE => all)
	  | parse (s::rest) =
	    if checkBooleanSwitches (s, booleanSwitches) then parse rest
	    else s::rest
	  | parse nil = nil

	fun isOption "" = false
	  | isOption s  = String.sub (s, 0) = #"-"
    end
