val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2003-07-18 14:23:24 $ by $Author: rossberg $
 *   $Revision: 1.21 $
 *)









signature ENV =
sig
    type valid = AbstractGrammar.valid
    type typid = AbstractGrammar.typid
    type modid = AbstractGrammar.modid
    type infid = AbstractGrammar.infid
    type stamp = Stamp.t
    type path  = Path.t
    type typ   = Type.t
    type var   = Type.var
    type inf   = Inf.t
    type use   = UseEnv.use

    type env
    type t = env

    type val_entry = {id: valid, use: bool ref, typ: typ, qtyp: typ}
    type typ_entry = {id: typid, use: bool ref, typ: typ, path: path}
    type var_entry = {id: typid, use: bool ref, var: var}
    type mod_entry = {id: modid, use: use  ref, inf: inf, path: path}
    type inf_entry = {id: infid, use: bool ref, inf: inf, path: path}

    exception Collision of stamp
    exception Lookup    of stamp

    val empty :		env
    val env :		unit -> env
    val clone :		env -> env
    val cloneScope :	env -> env
    val splitScope :	env -> env
    val insertScope :	env -> unit
    val removeScope :	env -> unit
    val mergeScope :	env -> unit

    val union :		env * env -> unit		(* Collision *)

    val insertVal :	env * stamp * val_entry -> unit	(* Collision *)
    val insertTyp :	env * stamp * typ_entry -> unit	(* Collision *)
    val insertVar :	env * stamp * var_entry -> unit	(* Collision *)
    val insertMod :	env * stamp * mod_entry -> unit	(* Collision *)
    val insertInf :	env * stamp * inf_entry -> unit	(* Collision *)

    val lookupVal :	env * stamp -> val_entry	(* Lookup *)
    val lookupTyp :	env * stamp -> typ_entry	(* Lookup *)
    val lookupVar :	env * stamp -> var_entry	(* Lookup *)
    val lookupMod :	env * stamp -> mod_entry	(* Lookup *)
    val lookupInf :	env * stamp -> inf_entry	(* Lookup *)

    val appVals :	(stamp * val_entry -> unit) -> env -> unit
    val appTyps :	(stamp * typ_entry -> unit) -> env -> unit
    val appVars :	(stamp * var_entry -> unit) -> env -> unit
    val appMods :	(stamp * mod_entry -> unit) -> env -> unit
    val appInfs :	(stamp * inf_entry -> unit) -> env -> unit

    val foldVals :	(stamp * val_entry * 'a -> 'a) -> 'a -> env -> 'a
    val foldTyps :	(stamp * typ_entry * 'a -> 'a) -> 'a -> env -> 'a
    val foldVars :	(stamp * var_entry * 'a -> 'a) -> 'a -> env -> 'a
    val foldMods :	(stamp * mod_entry * 'a -> 'a) -> 'a -> env -> 'a
    val foldInfs :	(stamp * inf_entry * 'a -> 'a) -> 'a -> env -> 'a
end
