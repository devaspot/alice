val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2007-02-13 14:56:34 $ by $Author: rossberg $
 *   $Revision: 1.20 $
 *)










signature ABSTRACTION_ERROR =
sig
    datatype error =
	(* Infix *)
	  InfixMisplaced	of VId.t
	| AssocConflict		of VId.t * VId.t
	(* Identifiers *)
	| VIdUnbound		of VId.t
	| TyConUnbound		of TyCon.t
	| TyVarUnbound		of TyVar.t
	| StrIdUnbound		of StrId.t
	| SigIdUnbound		of SigId.t
	| LongStrIdNonStruct
	| ConTyConShadowed	of TyCon.t * VId.t
	(* Expressions *)
	| ExpConArgSuperfluous
	| ExpRowLabDuplicate	of Lab.t
	(* Patterns *)
	| PatConArgMissing
	| PatConArgSuperfluous
	| PatVIdDuplicate	of VId.t
	| WithPatVIdDuplicate	of VId.t
	| PatLongVIdVar
	| PatRowLabDuplicate	of Lab.t
	| AppPatNonCon
	| AltPatInconsistent
	(* Types *)
	| TyRowLabDuplicate	of Lab.t
	| TyVarSeqDuplicate	of TyVar.t
	| ValTyVarSeqDuplicate	of TyVar.t
	(* Declarations and bindings *)
	| OpenDecNonStruct
	| ReplicationDecConShadowed of VId.t
	| FvalBindDuplicate	of VId.t
	| FvalBindArityInconsistent
	| FvalBindArityZero
	| FvalBindNameInconsistent of VId.t
	| FvalBindNameMissing
	| FvalBindNameCon	of VId.t
	| FvalBindPatInvalid
	| TypBindDuplicate	of TyCon.t
	| DatBindDuplicate	of TyCon.t
	| DatBindConDuplicate	of VId.t
	| ConBindDuplicate	of VId.t
	| ExtBindDuplicate	of TyCon.t
	| EconBindDuplicate	of VId.t
	| EconBindNonCon
	| StrBindDuplicate	of StrId.t
	| SigBindDuplicate	of SigId.t
	(* Structure expressions *)
	| AppStrExpNonFun
	(* Specifications and descriptions *)
	| IncludeSpecNonStruct
	| ReplicationSpecConShadowed of VId.t
	| SpecFixDuplicate	of VId.t
	| SpecVIdDuplicate	of VId.t
	| SpecTyConDuplicate	of TyCon.t
	| SpecStrIdDuplicate	of StrId.t
	| SpecSigIdDuplicate	of SigId.t
	| ConDescDuplicate	of VId.t
	| EconDescNonCon
	(* Imports and items *)
	| ImpFixDuplicate	of VId.t
	| ImpVIdDuplicate	of VId.t
	| ImpTyConDuplicate	of TyCon.t
	| ImpStrIdDuplicate	of StrId.t
	| ImpSigIdDuplicate	of SigId.t
	| ConItemDuplicate	of VId.t
	| ValItemUnbound	of VId.t
	| TypItemUnbound	of TyCon.t
	| DatItemUnbound	of TyCon.t
	| ConItemUnbound	of VId.t
	| ExtItemUnbound	of TyCon.t
	| EconItemUnbound	of VId.t
	| StrItemUnbound	of StrId.t
	| SigItemUnbound	of SigId.t
	| ConItemNonCon		of VId.t
	| EconItemNonCon	of VId.t
	(* Sharing translation *)
	| SharingExternalTy	of AbstractGrammar.typid
	| SharingExternalSig	of AbstractGrammar.infid
	| SharingExternalStr	of AbstractGrammar.modid

    datatype warning =
	(* Shadowing *)
	  VIdShadowed		of VId.t
	| TyConShadowed		of TyCon.t
	| TyVarShadowed		of TyVar.t
	| StrIdShadowed		of StrId.t
	| SigIdShadowed		of SigId.t
	(* Conventions *)
	| LabConvention		of Lab.t
	| VIdConvention		of VId.t
	| ValVIdConvention	of VId.t
	| ConVIdConvention	of VId.t
	| TyConConvention	of TyCon.t
	| TyVarConvention	of TyVar.t
	| StrIdConvention	of StrId.t
	| SigIdConvention	of SigId.t

    val error :	Source.region * error -> 'a
    val warn :	bool * Source.region * warning -> unit
end
