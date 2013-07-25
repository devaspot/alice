val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:38 $ by $Author: rossberg $
 *   $Revision: 1.9 $
 *)








signature PARSING_PHASE =
sig
    structure C : CONTEXT       = EmptyContext
    structure I : SOURCE        = Source
    structure O : INPUT_GRAMMAR = InputGrammar

    val translate : Source.desc * C.t * I.source -> C.t * InputGrammar.Component
end
