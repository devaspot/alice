val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-03-24 13:05:59 $ by $Author: rossberg $
 *   $Revision: 1.6 $
 *)

(*
 * Miscellaneous pretty printing helpers
 *)





structure PPMisc :> PP_MISC =
struct
    (* Import *)

    open PrettyPrint

    infixr ^^ ^/^


    (* Some PP combinators *)

    val nest = nest 3

    fun contain (l,r) doc = text l ^^ fbox(below doc) ^^ text r
    val quote = contain("`","'")
    val paren = contain("(",")")
    val brace = contain("{","}")
    val brack = contain("[","]")

    fun apply(doc, docs) = fbox(nest(doc ^/^ List.foldr op^/^ empty docs))
    fun indent doc = nest(break ^^ doc)
    fun par docs   = fbox(List.foldr op^/^ empty docs)
    fun textpar ss = fbox(List.foldr (fn(s,doc) => text s ^/^ doc) empty ss)

    fun ppCommaList ppX   []    = empty
      | ppCommaList ppX   [x]   = ppX x
      | ppCommaList ppX (x::xs) = ppX x ^^ text "," ^/^ ppCommaList ppX xs

    fun ppStarList ppX   []     = empty
      | ppStarList ppX   [x]    = ppX x
      | ppStarList ppX (x::xs)  = ppX x ^^ text " *" ^/^ ppStarList ppX xs

    fun ppSeqPrec ppXPrec n []  = empty
      | ppSeqPrec ppXPrec n [x] = ppXPrec n x
      | ppSeqPrec ppXPrec n  xs = paren(below(ppCommaList (ppXPrec 0) xs))

    fun ppSeq ppX = ppSeqPrec (fn _ => ppX) 0
end
