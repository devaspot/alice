val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-05-07 12:20:44 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)







structure UseEnv :> USE_ENV =
struct
    type lab = Label.t

    datatype  dom = VAL | TYP | MOD | INF
    structure Map = MkHashImpMap(type t = dom * lab
				 val equal = op =
				 fun hash(dom,l) = Label.hash l)

    datatype use = FULL | PARTIAL of env
    withtype env = use Map.t
    type t = env

    fun isPartial FULL		= false
      | isPartial(PARTIAL _)	= true

    fun inner(PARTIAL E)	= E
      | inner FULL		= raise Crash.Crash "UseEnv.inner"

    val env			= Map.map
    val isEmpty			= Map.isEmpty

    fun insertVal(E,l)		= Map.insert(E, (VAL,l), FULL)
    fun insertTyp(E,l)		= Map.insert(E, (TYP,l), FULL)
    fun insertInf(E,l)		= Map.insert(E, (INF,l), FULL)
    fun insertMod(E,l,u)	= Map.insert(E, (MOD,l), u)

    fun lookupVal(E,l)		= Option.isSome(Map.lookup(E, (VAL,l)))
    fun lookupTyp(E,l)		= Option.isSome(Map.lookup(E, (TYP,l)))
    fun lookupInf(E,l)		= Option.isSome(Map.lookup(E, (INF,l)))
    fun lookupMod(E,l)		= Map.lookup(E, (MOD,l))

    fun appVal f ((VAL,l), _)	= f l    | appVal f _ = ()
    fun appTyp f ((TYP,l), _)	= f l    | appTyp f _ = ()
    fun appInf f ((INF,l), _)	= f l    | appInf f _ = ()
    fun appMod f ((MOD,l), u)	= f(l,u) | appMod f _ = ()
    fun appVals f		= Map.appi (appVal f)
    fun appTyps f		= Map.appi (appTyp f)
    fun appInfs f		= Map.appi (appInf f)
    fun appMods f		= Map.appi (appMod f)
end
