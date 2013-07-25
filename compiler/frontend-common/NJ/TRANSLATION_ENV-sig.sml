val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-04-11 19:33:54 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)






signature TRANSLATION_ENV =
sig
    type stamp   = Stamp.t
    type modid   = TypedGrammar.modid
    type longid' = IntermediateGrammar.longid

    type env
    type t = env

    exception Unknown   of stamp
    exception Collision of stamp
    exception Pervasive

    val empty :			env
    val env :			unit -> env
    val clone :			env -> env

    val insertMod :		env * stamp -> unit	(* Collision *)
    val removeMod :		env * stamp -> unit	(* Unknown *)
    val memberMod :		env * stamp -> bool

    val insertPervasive :	env * modid   -> unit
    val insertPervasive' :	env * longid' -> unit
    val lookupPervasive :	env -> modid		(* Pervasive *)
    val lookupPervasive' :	env -> longid'		(* Pervasive *)
    val lookupPervasiveInf :	env -> Inf.t		(* Pervasive *)

    val rtt :			env -> bool
    val setRtt :		env * bool -> unit
end
