val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2004-04-08 09:00:17 $ by $Author: bruni $
 *   $Revision: 1.9 $
 *)
















functor MkBackendSeam(structure ComponentManager: COMPONENT_MANAGER
		      structure Switches: SWITCHES): BACKEND_SPECIFIC =
    let
	structure CodeGenPhase = 
	    MkCodeGenPhase(structure AbstractCodeGrammar = AbstractCodeGrammar
			   structure Switches = Switches)

	fun inf (Value.TaggedValue
		     (_, _, #[_, _, Value.Sign (SOME exportInf)])) = exportInf
	  | inf _ = raise Crash.Crash "MkBackendSeam.inf"

	fun save value filename =
	    let
		val outstream = PrimPickle.openOut filename
	    in
		OutputPickle.output (outstream, value);
		PrimPickle.closeOut outstream
	    end
	structure TracingPhase =
	    MkTracingPhase(structure Phase =
			       struct
				   structure C = CodeGenPhase.C
				   structure I = CodeGenPhase.I
				   structure O = Target

				   fun translate x =
				       let
					   val (context, (value, _)) =
					       CodeGenPhase.translate x
				       in
					   (context,
					    Target.FOREIGN {save = save value,
							    inf = inf value})
				       end
			       end
			   structure Switches = Switches
			   val name = "Emitting Pickle")
    in
	struct
	    open TracingPhase
	    structure O = Target
	    val isCross = true
	end
    end
