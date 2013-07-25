val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-15 15:40:24 $ by $Author: rossberg $
 *   $Revision: 1.4 $
 *)





functor MkLexerError(structure Tokens: Parser_TOKENS
		     type error) : LEXER_ERROR =
struct
    type token = (Tokens.svalue, int) Tokens.token
    type error = error

    exception Error of (int * int) * error
    exception EOF   of (int * int) -> token

    fun error pos_e = raise Error pos_e
end