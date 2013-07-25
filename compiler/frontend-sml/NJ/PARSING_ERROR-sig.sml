val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2006
 *
 * Last change:
 *   $Date: 2006-07-06 15:11:00 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)



signature PARSING_ERROR =
sig
    datatype error =
	(* Lexer *)
	  UnclosedComment
	| InvalidChar		of char
	| InvalidString
	| IntTooLarge
	| WordTooLarge
	| RealTooLarge
	| CharLengthInvalid	of string
	| EscapeCharTooLarge	of bool
	(* Parser *)
	| SyntaxError		of string
	(* Derived forms *)
	| UpdExpInvalid
	| ExpRowEllipses
	| PatRowEllipses
	| TyRowEllipses
	| WithtypeInvalid
	| WithtypeArityMismatch

    type warning	(* yet empty *)

    val error :	 Source.region * error -> 'a
    val warn :	 bool * Source.region * warning -> unit
end
