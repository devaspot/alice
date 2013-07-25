val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2003
 *
 * Last change:
 *   $Date: 2007-03-20 17:06:14 $ by $Author: rossberg $
 *   $Revision: 1.26 $
 *)

(*******************************************************************************

The binding environment just contains the information necessary to do
binding analysis for identifiers:

	Env	= InfEnv U FldEnv U VarEnv U ValEnv U TyEnv U StrEnv U SigEnv
	EnvFn	= Env U (StrId^n * SigId) U (StrId * EnvFn)
	InfEnv	= VId   -> InfStatus		(infix env)
	FldEnv	= Lab   -> 0			(field env)
	VarEnv	= TyVar -> Stamp * bool		(type variable env)
	ValEnv	= VId   -> Stamp * IdStatus	(value env)
	TyEnv	= TyCon -> Stamp * Env * int	(type env)
	StrEnv	= StrId -> Stamp * EnvFn	(module env)
	SigEnv	= SigId -> Stamp * EnvFn	(signature env)

Field envs are just used to detect duplicate labels. Type envs map to
constructor environments. Module envs map to environments representing the
module's signature. Similarly, signature envs map to the result
environment. We cannot ignore functor or signature parameters because we
have first class signatures.

UNFINISHED: avoid higher-order implementation of EnvFn, because it is
expensive - we recalculate everything on every application.

*******************************************************************************)













signature BIND_ENV =
sig
    type Lab   = Lab.t
    type VId   = VId.t
    type TyVar = TyVar.t
    type TyCon = TyCon.t
    type StrId = StrId.t
    type SigId = SigId.t

    type Info  = Source.region
    type stamp = Stamp.t

    type     InfAssoc  = Infix.Assoc
    type     InfStatus = Infix.InfStatus
    datatype Arity     = NULLARY | UNARY | NARY
    datatype IdStatus  = V | T of Arity * TyCon * int | C of Arity | R

    type Env
    datatype EnvFn = EMPTY
		   | PLAIN of Env
		   | PARAM of stamp * EnvFn
		   | ABSTR of stamp * StrId list * SigId * EnvFn list
    type TyStr = {CE : Env, arity : int, def : (InputGrammar.TyVarSeq * InputGrammar.Ty) option, eq : bool option, ext : bool}

    type Inf = Info * InfStatus
    type Fld = Info
    type Var = Info * stamp * bool
    type Val = Info * stamp * IdStatus
    type Ty  = Info * stamp * TyStr
    type Str = Info * stamp * EnvFn
    type Sig = Info * stamp * EnvFn

    type t = Env


    exception CollisionInf of VId
    exception CollisionFld of Lab
    exception CollisionVal of VId
    exception CollisionTy  of TyCon
    exception CollisionVar of TyVar
    exception CollisionStr of StrId
    exception CollisionSig of SigId

    exception Strengthen

    val empty :			Env
    val env :			unit -> Env
    val instance :		EnvFn -> EnvFn
    val strengthen :		stamp * EnvFn -> EnvFn
    val apply :			EnvFn * EnvFn -> EnvFn
    val match :			EnvFn * EnvFn -> EnvFn

    val size :			Env -> int
    val sizeScope :		Env -> int

    val clone :			Env -> Env
    val cloneScope :		Env -> Env

    val insertScope :		Env -> unit
    val removeScope :		Env -> unit
    val removeAll :		Env -> unit
    val mergeScope :		Env -> unit
    val mergeDisjointScope :	Env -> unit		(* Collision* *)
    val inheritScope :		Env * Env -> unit
    val splitScope :		Env -> Env

    val union :			Env * Env -> unit
    val unionDisjoint :		Env * Env -> unit	(* Collision* *)
    val unionCompose :		Env * Env -> unit
    val unionInf :		Env * Env -> unit
    val composeEnvFn :		EnvFn * EnvFn -> unit

    val insertSelf :		Env -> unit
    val insertInf :		Env *  VId  * Inf -> unit
    val insertFld :		Env *  Lab  * Fld -> unit
    val insertVal :		Env *  VId  * Val -> unit
    val insertTy :		Env * TyCon * Ty  -> unit
    val insertVar :		Env * TyVar * Var -> unit
    val insertStr :		Env * StrId * Str -> unit
    val insertSig :		Env * SigId * Sig -> unit
    val insertDisjointInf :	Env *  VId  * Inf -> unit   (* CollisionInf *)
    val insertDisjointFld :	Env *  Lab  * Fld -> unit   (* CollisionFld *)
    val insertDisjointVal :	Env *  VId  * Val -> unit   (* CollisionVal *)
    val insertDisjointTy :	Env * TyCon * Ty  -> unit   (* CollisionTy *)
    val insertDisjointVar :	Env * TyVar * Var -> unit   (* CollisionVar *)
    val insertDisjointStr :	Env * StrId * Str -> unit   (* CollisionStr *)
    val insertDisjointSig :	Env * SigId * Sig -> unit   (* CollisionSig *)

    val lookupSelf :		Env -> stamp option
    val lookupInf :		Env *  VId  -> Inf option
    val lookupFld :		Env *  Lab  -> Fld option
    val lookupVar :		Env * TyVar -> Var option
    val lookupVal :		Env *  VId  -> Val option
    val lookupTy :		Env * TyCon -> Ty  option
    val lookupStr :		Env * StrId -> Str option
    val lookupSig :		Env * SigId -> Sig option
    val lookupScopeInf :	Env *  VId  -> Inf option
    val lookupScopeFld :	Env *  Lab  -> Fld option
    val lookupScopeVar :	Env * TyVar -> Var option
    val lookupScopeVal :	Env *  VId  -> Val option
    val lookupScopeTy :		Env * TyCon -> Ty  option
    val lookupScopeStr :	Env * StrId -> Str option
    val lookupScopeSig :	Env * SigId -> Sig option

    val appiInfs :		( VId  * Inf -> unit) -> Env -> unit
    val appiFlds :		( Lab  * Fld -> unit) -> Env -> unit
    val appiVars :		(TyVar * Var -> unit) -> Env -> unit
    val appiVals :		( VId  * Val -> unit) -> Env -> unit
    val appiTys :		(TyCon * Ty  -> unit) -> Env -> unit
    val appiStrs :		(StrId * Str -> unit) -> Env -> unit
    val appiSigs :		(SigId * Sig -> unit) -> Env -> unit
    val appiScopeVals :		( VId  * Val -> unit) -> Env -> unit

    val foldiInfs :		( VId  * Inf * 'a -> 'a) -> 'a -> Env -> 'a
    val foldiFlds :		( Lab  * Fld * 'a -> 'a) -> 'a -> Env -> 'a
    val foldiVars :		(TyVar * Var * 'a -> 'a) -> 'a -> Env -> 'a
    val foldiVals :		( VId  * Val * 'a -> 'a) -> 'a -> Env -> 'a
    val foldiTys :		(TyCon * Ty  * 'a -> 'a) -> 'a -> Env -> 'a
    val foldiStrs :		(StrId * Str * 'a -> 'a) -> 'a -> Env -> 'a
    val foldiSigs :		(SigId * Sig * 'a -> 'a) -> 'a -> Env -> 'a

    val foldli :		( VId  * Inf * 'a -> 'a) *
				( Lab  * Fld * 'a -> 'a) *
				(TyVar * Var * 'a -> 'a) *
				( VId  * Val * 'a -> 'a) *
				(TyCon * Ty  * 'a -> 'a) *
				(StrId * Str * 'a -> 'a) *
				(SigId * Sig * 'a -> 'a) -> 'a -> Env -> 'a
    val foldri :		( VId  * Inf * 'a -> 'a) *
				( Lab  * Fld * 'a -> 'a) *
				(TyVar * Var * 'a -> 'a) *
				( VId  * Val * 'a -> 'a) *
				(TyCon * Ty  * 'a -> 'a) *
				(StrId * Str * 'a -> 'a) *
				(SigId * Sig * 'a -> 'a) -> 'a -> Env -> 'a

    val infEnv :		Env -> VId -> InfStatus
end
