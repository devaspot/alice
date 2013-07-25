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
 *   $Revision: 1.4 $
 *)

signature LEXER_ERROR =
sig
    type token
    type error

    exception Error of (int * int) * error
    exception EOF   of (int * int) -> token

    val error :	(int * int) * error -> 'a
end
