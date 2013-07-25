val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2005
 *
 * Last change:
 *   $Date: 2005-02-15 10:35:04 $ by $Author: rossberg $
 *   $Revision: 1.11 $
 *)

(* A source file. *)



signature SOURCE =
sig
    type source
    type t	= source

    type pos	= int * int
    type region	= pos * pos

    type desc

    val fromString:		string -> source
    val toString:		source -> string

    val nowhere:		region
    val at:			region -> region
    val span:			region * region -> region
    val between:		region * region -> region

    val regionToString:		region -> string

    val stringDesc:		desc
    val urlDesc:		{source: Url.t, target: Url.t option} -> desc

    val sourceUrl:		desc -> Url.t option
    val targetUrl:		desc -> Url.t option
    val anyUrl:			desc -> Url.t option
end
