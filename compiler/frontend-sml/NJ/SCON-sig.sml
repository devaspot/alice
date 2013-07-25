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
 *   $Revision: 1.5 $
 *)

(*
 * Standard ML special constants
 *
 * Definition, section 2.2
 *
 * Note:
 *   I would like to use WideChar and WideString, but SML/NJ does not
 *   support it.
 *)


signature SCON =    
sig 
    datatype SCon =
	  INT    of LargeInt.int
	| WORD   of LargeWord.word
	| STRING of WideString.string
	| CHAR   of WideChar.char
	| REAL   of LargeReal.real

    type t = SCon

    val toString: SCon -> string
end
