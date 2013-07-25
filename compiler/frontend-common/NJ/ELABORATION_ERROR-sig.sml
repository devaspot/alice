val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2006
 *
 * Last change:
 *   $Date: 2006-07-06 15:10:56 $ by $Author: rossberg $
 *   $Revision: 1.34 $
 *)











signature ELABORATION_ERROR =
sig
    type url       = Url.t
    type lab       = Label.t
    type path      = Path.t
    type typ       = Type.t
    type var       = Type.var
    type kind      = Type.kind
    type inf	   = Inf.t
    type fix       = Fixity.t
    type valid     = AbstractGrammar.valid
    type modlongid = AbstractGrammar.modlongid

    type typ_mismatch = typ * typ * typ * typ
    type inf_mismatch = Inf.mismatch

    datatype error =
	(* Expressions *)
	  NewExpTyp		of typ
	| NewExpResTyp		of typ
	| VecExpMismatch	of typ_mismatch
	| TagExpLab		of lab
	| TagExpArgMismatch	of typ_mismatch
	| ConExpConMismatch	of typ_mismatch
	| ConExpArgMismatch	of typ_mismatch
	| RollExpMismatch	of typ_mismatch
	| UpdExpMismatch	of typ_mismatch
	| SelExpMismatch	of typ_mismatch
	| AppExpFunMismatch	of typ_mismatch
	| AppExpArgMismatch	of typ_mismatch
	| AndExpMismatch	of typ_mismatch
	| OrExpMismatch		of typ_mismatch
	| IfExpCondMismatch	of typ_mismatch
	| IfExpBranchMismatch	of typ_mismatch
	| RaiseExpMismatch	of typ_mismatch
	| HandleExpMismatch	of typ_mismatch
	| AnnExpMismatch	of typ_mismatch
	| MatPatMismatch	of typ_mismatch
	| MatExpMismatch	of typ_mismatch
	| LetExpGenerative	of inf
	| OverExpEmpty
	| OverExpArity
	| OverExpNonPrimTyp	of typ
	| OverExpOverlap	of typ * typ
	| OverExpKind		of typ
	| OverExpMismatch	of typ_mismatch
	| OverallExpMismatch	of typ_mismatch
	(* Patterns *)
	| TagPatLab		of lab
	| TagPatArgMismatch	of typ_mismatch
	| ConPatConMismatch	of typ_mismatch
	| ConPatArgMismatch	of typ_mismatch
	| RollPatMismatch	of typ_mismatch
	| VecPatMismatch	of typ_mismatch
	| AsPatMismatch		of typ_mismatch
	| AltPatMismatch	of typ_mismatch
	| GuardPatMismatch	of typ_mismatch
	| AnnPatMismatch	of typ_mismatch
	(* Types *)
	| JokTyp
	| StarTypKind		of kind
	| AppTypFunKind		of kind
	| AppTypArgKind		of kind * kind
	| RefTypKind		of kind
	| PervasiveTypUnknown	of string
	(* Rows *)
	| FldRowDuplicate	of lab
	| EllRowType		of typ
	(* Declarations *)
	| ValDecMismatch	of typ_mismatch
	| ValDecUnclosed	of typ
	| ValDecLift		of valid * var
	| RecValDecNonValue
	(* Long ids *)
	| ModlongidInf		of modlongid * inf
	(* Modules *)
	| StrModUnclosed	of lab * typ
	| SelModInf		of inf
	| AppModFunMismatch	of inf
	| AppModArgMismatch	of inf_mismatch
	| AnnModMismatch	of inf_mismatch
	| UnpackModMismatch	of typ_mismatch
	(* Interfaces *)
	| GroundInfKind		of Inf.kind
	| AppInfFunMismatch	of inf
	| AppInfArgMismatch	of inf_mismatch
	| InterInfMismatch	of inf_mismatch
	| LetInfGenerative	of inf
	| SingInfNonSing	of inf
	| PervasiveInfUnknown	of string
	(* Imports *)
	| ImpMismatch		of inf_mismatch
	| ImplicitImpHiddenTyp	of url * path
	| ImplicitImpHiddenMod	of url * path
	| ImplicitImpHiddenInf	of url * path
	| ImplicitImpInconsistent of url * path * url
	| ImplicitImpHiddenTransTyp of url * path * url
	| ImplicitImpHiddenTransMod of url * path * url
	| ImplicitImpHiddenTransInf of url * path * url
	(* Exports *)
	| ExportUnclosed	of lab * typ

    datatype warning =
	(* Imports *)
	  ValImpUnused		of lab
	| TypImpUnused		of lab
	| ModImpUnused		of lab
	| InfImpUnused		of lab
	| TypImpInserted	of url * path * url
	| InfImpInserted	of url * path * url
	(* Exports *)
	| ExportNotGeneralized	of valid * typ
	| ExportHiddenTyp	of path
	| ExportHiddenMod	of path
	| ExportHiddenInf	of path

    val error :	Source.region * error -> 'a
    val warn :	bool * Source.region * warning -> unit
    val unfinished : Source.region * string * string -> unit
end
