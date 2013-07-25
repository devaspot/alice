val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2004
 *
 * Last change:
 *   $Date: 2004-09-14 11:37:27 $ by $Author: rossberg $
 *   $Revision: 1.1 $
 *)






signature REWRITE_IMPORTS =
sig
    val rewriteAnns : Source.desc * Env.t * TypedGrammar.ann vector * Inf.sign
		      -> TypedGrammar.ann vector * Inf.sign
end
