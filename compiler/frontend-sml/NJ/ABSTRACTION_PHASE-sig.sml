val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:17:36 $ by $Author: rossberg $
 *   $Revision: 1.8 $
 *)









signature ABSTRACTION_PHASE =
sig
    structure C : CONTEXT          = BindEnv
    structure I : INPUT_GRAMMAR    = InputGrammar
    structure O : ABSTRACT_GRAMMAR = AbstractGrammar

    val translate : Source.desc * BindEnv.t * I.Component -> BindEnv.t * O.com
end
