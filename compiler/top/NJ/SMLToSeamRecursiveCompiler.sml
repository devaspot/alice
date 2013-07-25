val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt and Andreas Rossberg, 1999-2005
 *
 * Last change:
 *   $Date: 2005-05-24 11:34:07 $ by $Author: rossberg $
 *   $Revision: 1.31 $
 *)















structure RecursiveCompiler =
    let
	structure Switches = MkSwitches()

	val _ = General.Assert	(* dummy to force CM importing ExtendedBasis *)

	val acquireSigRef: InfLoader.t ref = ref (fn _ => assert false)
	val acquireModRef: ModLoader.t ref = ref (fn _ => assert false)
	val acquireImportsRef: ImportLoader.t ref = ref (fn _ => assert false)

	fun loadSig (desc, url) = !acquireSigRef (desc, url)
	fun loadMod (desc, url) = !acquireModRef (desc, url)
	fun loadImports (desc, url) = !acquireImportsRef (desc, url)

	structure ComponentManager' =
	    Component.MkManager(val resolver = Component.defaultResolver)

	structure FrontendSML =
	    MkFrontendSML(val loadSig = loadSig
			  structure Switches = Switches)

	structure FrontendCommon =
	    MkFrontendCommon(val loadSig = loadSig
			     val loadMod = loadMod
			     val loadImports = loadImports
			     structure Switches = Switches)

	structure BackendSeam =
	    MkBackendSeam(structure ComponentManager = ComponentManager
			  structure Switches = Switches)

	structure BackendCommon =
	    MkBackendCommon(val isCross = BackendSeam.isCross
			    val loadMod = loadMod
			    structure Switches = Switches)

	structure Compiler =
	    MkCompiler(structure Switches         = Switches
		       structure FrontendSpecific = FrontendSML
		       structure FrontendCommon   = FrontendCommon
		       structure BackendCommon    = BackendCommon
		       structure BackendSpecific  = BackendSeam)

	structure RecursiveCompiler =
	    MkRecursiveCompiler(structure ComponentManager = ComponentManager'
				structure Compiler = Compiler
				val extension = "alc")

	val _ = acquireSigRef := RecursiveCompiler.acquireSig
	val _ = acquireModRef := RecursiveCompiler.acquireMod
	val _ = acquireImportsRef := RecursiveCompiler.acquireImports
    in
	RecursiveCompiler : RECURSIVE_COMPILER'
    end
