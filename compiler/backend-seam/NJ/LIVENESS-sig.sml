val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002
 *
 * Last change:
 *   $Date: 2003-10-02 12:45:03 $ by $Author: bruni $
 *   $Revision: 1.2 $
 *)



signature LIVENESS =
    sig
	structure AbstractCodeGrammar: ABSTRACT_CODE_GRAMMAR

	val analyze: AbstractCodeGrammar.idDef vector *
		     AbstractCodeGrammar.instr -> int vector
    end
