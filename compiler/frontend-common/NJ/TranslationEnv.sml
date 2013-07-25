val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2004-04-11 19:33:54 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)







structure TranslationEnv :> TRANSLATION_ENV =
struct
    type stamp			= Stamp.t
    type modid			= TypedGrammar.modid
    type longid'		= IntermediateGrammar.longid

    type env			= StampSet.t * modid option ref
					     * longid' option ref
					     * bool ref
    type t			= env

    exception Unknown		= StampSet.Unknown
    exception Collision		= StampSet.Collision
    exception Pervasive

    fun env()			= (StampSet.set(), ref NONE, ref NONE, ref false) : env
    val empty			= env()
    fun clone(s,xr,yr,br)	= (StampSet.clone s, ref(!xr),ref(!yr),ref(!br))

    fun insertMod((E,_,_,_), x)	= StampSet.insertDisjoint(E,x)
    fun removeMod((E,_,_,_), x)	= StampSet.removeExistent(E,x)
    fun memberMod((E,_,_,_), x)	= StampSet.member(E,x)

    fun insertPervasive((_,xr,_,_), x)		= xr := SOME x
    fun lookupPervasive(_, ref(SOME x), _, _)	= x
      | lookupPervasive(_, _, _, _)		= raise Pervasive

    fun insertPervasive'((_,_,yr,_), y')	= yr := SOME y'
    fun lookupPervasive'(_, _, ref(SOME y'), _)	= y'
      | lookupPervasive'(_, _, _, _)		= raise Pervasive

    fun lookupPervasiveInf env =
	#inf(TypedGrammar.infoId(lookupPervasive env) : TypedGrammar.modid_info)

    fun rtt(_, _, _, rb)         = !rb
    fun setRtt((_, _, _, rb), b) = rb := b
end
