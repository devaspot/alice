val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-07 12:20:44 $ by $Author: rossberg $
 *   $Revision: 1.12 $
 *)





functor MkHashScopedImpSet(Item: HASHABLE) = MkScopedImpSet(MkHashImpSet(Item))
