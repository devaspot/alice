val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 15:40:23 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)




structure InputGrammar = MkInputGrammar(type Info = Source.region)
