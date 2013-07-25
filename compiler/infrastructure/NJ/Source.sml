val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2005
 *
 * Last change:
 *   $Date: 2005-02-15 14:01:56 $ by $Author: rossberg $
 *   $Revision: 1.12 $
 *)

(* A source file *)




structure Source :> SOURCE =
struct
    type source	= string
    type t	= source

    type pos	= int * int
    type region	= pos * pos

    type desc	= {source : Url.t, target : Url.t option} option

    val nowhere = ((0,0),(0,0))

    fun fromString s	= s
    fun toString s	= s

    fun at(reg : region)			= (#1 reg, #1 reg)
    fun span(reg1: region, reg2: region)	= (#1 reg1, #2 reg2)
    fun between(reg1: region, reg2: region)	= (#2 reg1, #1 reg2)

    fun posToString(lin,col) =
	Int.toString lin ^ "." ^ Int.toString col

    fun regionToString(region as (pos1,pos2)) =
	if region = nowhere then
	    "(unknown position)"
	else
	    posToString pos1 ^ "-" ^ posToString pos2

    val stringDesc = NONE
    val urlDesc    = SOME

    fun sourceUrl NONE = NONE
      | sourceUrl(SOME{source, target}) = SOME source
    fun targetUrl NONE = NONE
      | targetUrl(SOME{source, target}) = target
    fun anyUrl NONE = NONE
      | anyUrl(SOME{source, target}) = SOME(Option.getOpt(target, source))
end
