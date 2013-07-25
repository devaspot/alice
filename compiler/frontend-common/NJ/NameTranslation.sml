val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2001-08-16 14:05:37 $ by $Author: rossberg $
 *   $Revision: 1.1 $
 *)




structure NameTranslation : NAME_TRANSLATION =
struct
    open Name

    fun trName f (ExId s)	= ExId(f s)
      | trName f  n		= n

    fun trValName  n		= n
    val trTypName		= trName(fn s => "$" ^ s)
    val trVarName		= trName(fn s => "$" ^ s)
    val trModName		= trName(fn s => s ^ "$")
    val trInfName		= trName(fn s => "$" ^ s ^ "$")

    fun isValName(ExId s)	= String.sub(s,0) <> #"$" andalso
				  String.sub(s, String.size s - 1) <> #"$"
      | isValName InId		= raise Domain
    fun isTypName(ExId s)	= String.sub(s,0) = #"$" andalso
				  String.sub(s, String.size s - 1) <> #"$"
      | isTypName InId		= raise Domain
    fun isModName(ExId s)	= String.sub(s,0) <> #"$" andalso
				  String.sub(s, String.size s - 1) = #"$"
      | isModName InId		= raise Domain
    fun isInfName(ExId s)	= String.sub(s,0) = #"$" andalso
				  String.sub(s, String.size s - 1) = #"$"
      | isInfName InId		= raise Domain
end
