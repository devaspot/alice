val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:43:48 $ by $Author: rossberg $
 *   $Revision: 1.24 $
 *)


























functor MkFrontendCommon (
    val loadSig: Source.desc * Url.t -> Inf.sign
    val loadMod: Source.desc * Url.t -> Reflect.module
    val loadImports: Source.desc * Url.t -> (Url.t * Inf.sign) vector
    structure Switches: SWITCHES
) : PHASE =
let
    fun ppCom(TypedGrammar.Com(i, anns, _)) =
	let
	    open PrettyPrint
	    infixr ^^ ^/^
	in
	    Vector.foldr (fn(TypedGrammar.ImpAnn(i, _, url, b), doc) =>
			     abox(
				  nest 3 (
				      text(if not b then "import"
					   else "import __primitive") ^/^
				      PPInf.ppSig(#sign i)
				  ) ^/^
				  text ("from \"" ^ Url.toString url ^ "\"")
			      ) ^/^ doc
			  ) (PPInf.ppSig(#sign i)) anns
	end

    structure Phase1 =
	      MkTracingPhase(
		    structure Phase =
			MkElaborationPhase(val       loadSig     = loadSig
					   val       loadMod     = loadMod
					   val       loadImports = loadImports
					   structure Switches    = Switches)
		    structure Switches = Switches
		    val name = "Elaboration"
	      )
    structure Phase2 =
	      MkTracingPhase(
		    structure Phase    = MkTranslationPhase(Switches)
		    structure Switches = Switches
		    val name = "Translation"
	      )
    structure Phase1' =
	      MkResultDumpingPhase(
		    structure Phase    = Phase1
		    structure Switches = Switches
		    val header = "Component Signature"
		    val pp     = ppCom
		    val switch = Switches.Debug.dumpElaborationSig
	      )
    structure Phase2' =
	      MkResultDumpingPhase(
		    structure Phase    = Phase2
		    structure Switches = Switches
		    val header = "Intermediate Syntax"
		    val pp     = PPIntermediateGrammar.ppCom
		    val switch = Switches.Debug.dumpIntermediate
	      )
    structure Phase3 =
	      MkTracingPhase(
		    structure Phase =
		    struct
			structure C = EmptyContext
			structure I = Phase2'.O
			structure O = I

			fun translate(_, _, com) =
			    (if !Switches.Debug.checkIntermediate
			     then CheckIntermediate.check com else ();
			     ((), com))
		    end
		    structure Switches = Switches
		    val name = "Verification (optional)"
	      )
in
    ComposePhases' (
	structure Phase1  = ComposePhases(structure Phase1 = Phase1'
					  structure Phase2 = Phase2')
	structure Phase2  = Phase3
	structure Context = Phase1.C
	val context       = Pair.fst
	val context1      = Fn.id
	val context2      = ignore
    )
end
