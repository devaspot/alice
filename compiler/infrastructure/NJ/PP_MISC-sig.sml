val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-01-16 23:25:38 $ by $Author: kornstae $
 *   $Revision: 1.5 $
 *)

(*
 * Miscellaneous pretty printing helpers
 *)



signature PP_MISC =
sig
    type doc = PrettyPrint.doc

    val nest:		doc -> doc

    val quote:		doc -> doc
    val paren:		doc -> doc
    val brace:		doc -> doc
    val brack:		doc -> doc

    val ppCommaList:	('a -> doc) -> 'a list -> doc
    val ppStarList:	('a -> doc) -> 'a list -> doc
    val ppSeq:		('a -> doc) -> 'a list -> doc
    val ppSeqPrec:	(int -> 'a -> doc) -> int -> 'a list -> doc

    val par:		doc list -> doc
    val textpar:	string list -> doc
    val indent:		doc -> doc
end
