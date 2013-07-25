val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:17:29 $ by $Author: rossberg $
 *   $Revision: 1.10 $
 *)










signature TRANSLATION_PHASE =
sig
    structure C : CONTEXT              = TranslationEnv
    structure I : ABSTRACT_GRAMMAR     = TypedGrammar
    structure O : INTERMEDIATE_GRAMMAR = IntermediateGrammar

    val translate : Source.desc * C.t * I.com -> C.t * O.com
end
