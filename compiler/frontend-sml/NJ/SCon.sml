val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-10-05 11:50:25 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)

(*
 * Standard ML special constants
 *
 * Definition, section 2.2
 *)




structure SCon :> SCON =
struct
    datatype SCon =
	  INT    of LargeInt.int
	| WORD   of LargeWord.word
	| STRING of WideString.string
	| CHAR   of WideChar.char
	| REAL   of LargeReal.real

    type t = SCon

    fun toString(INT i)    = LargeInt.toString i
      | toString(WORD w)   = "0wx" ^ LargeWord.toString w
      | toString(STRING s) = "\""  ^ WideString.toString s ^ "\""
      | toString(CHAR c)   = "\"#" ^ WideChar.toString c   ^ "\""
      | toString(REAL r)   = LargeReal.toString r
end
