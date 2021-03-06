val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-03-30 15:12:16 $ by $Author: rossberg $
 *   $Revision: 1.33 $
 *)


(*
 * Standard ML derived forms
 *
 * Definition, Appendix A
 *
 * Extensions and modifications:
 *   - extensible records:
 *	  exprow ::= ... = exp <, exprow>
 *	  patrow ::= ... <= pat> <, patrow>
 *	  tyrow  ::= ... = ty <, tyrow>
 *   - functional record update:
 *        {atexp where exprow}
 *        ==>
 *        let val {patrow, ...=vid} in {exprow, ...=vid} end
 *   - recursive expressions:
 *	rec pat => exp     ==>     let val rec x as pat = exp in x end
 *     where x is a fresh identifier.
 *   - optional else branch:
 *	if exp_1 then exp_2     ==>     if exp_1 then exp_2 else ()
 *   - file and line expansion:
 *      _file_  ==>  "myfile.aml"
 *      _line_  ==>  42
 *   - finalization:
 *	  exp ::= exp_1 finally exp_1
 *   - assertions:
 *      assert<d> exp1 do exp2         ==>  if exp1 then exp2 else raise Assert(_file_,_line_)
 *	assert<d> exp1 of pat do exp2  ==>  assert (case exp1 of pat => true | _ => false) do exp2
 *	assert<d> exp                  ==>  assert exp do lazy raise Assert(_file_,_line_)
 *	assert<d> exp of pat           ==>  assert exp of pat do ()
 *	assert<d> exp raise pat        ==>  assert ((exp; false) handle vid as pat => true | _ => false) do ()
 *   - exception declarations have been made a derived form:
 *	exception exbind          ==>  con exbind'
 *	vid <of ty> <and exbind>  ==>  vid <of ty> : exn <and exbind'>
 *   - do declarations:
 *      do exp  ==>  val _ : {} = exp
 *   - generalised open declarations:
 *      open strexp  ==>  local structure strid = strexp in open strid end
 *   - derived form for function declarations extended with lazy keyword:
 *      <lazy> <op> vid atpat11 ... atpat1n <: ty1> = exp1 | ...
 *        ==>
 *      <op> vid = <lazy> (fn vid1 => ... fn vidn => case (vid1,...,vidn) of ...
 *   - abstype has been made a derived form:
 *	abstype datbind <withtype tybind> with dec end
 *	  ==>
 *	<type typbind> local datatype datbind in type typbind' dec end
 *     where typbind' contains a binding t = t for each tycon t bound in
 *     datbind. Note that this results in a different treatment of equality.
 *   - packages:
 *	pack atstrexp :> atsigexp
 *	==>
 *	let signature sigid = atsigexp in pack (atstrexp :> sigid) : sigid end
 *   - include takes longsigids:
 *	include longsigid_1 ... longsigid_n
 *	==>
 *	include longsigid_1 ; ... ; include longsigid_n
 *   - derived forms for primitive declarations similar to specifications:
 *   - where constraints have been made a derived form of intersection:
 *	sigexp where type tyvarseq strid_1....strid_n.tycon = ty
 *	==>
 *      sigexp where sig structure strid_1 :
 *			...
 *			   sig structure strid_n :
 *			      sig type tyvarseq tycon = ty end
 *			   end
 *			...
 *		     end
 *
 *	sigexp where strid_1....strid_n.strid = longstrid
 *	==>
 *      sigexp where sig structure strid_1 :
 *			...
 *			   sig structure strid_n :
 *			      sig structure strid = longstrid end
 *			   end
 *			...
 *		     end
 *
 * We did NOT introduce a sharing signature ... and signature ... derived form
 * similar to types, because we consider that completely broken anyway.
 *
 * Notes:
 * - Two phrases named Fmatch and Fmrule have been added to factorize FvalBind.
 * - A phrase named TyReaDesc has been added to factorize type
 *   realisation signature expressions.
 *)




local
    open InputGrammar
in

signature DERIVED_FORMS =
sig

    type AppExp    = Exp
    type InfExp    = Exp
    type ExBind    = EconBind
    type Fmatch    = Match
    type Fmrule    = Mrule
    type Fpat      = Pat
    type AppStrExp = StrExp
    type AppSigExp = SigExp
    type AtStrPat  = StrPat
    type ExDesc    = EconDesc
    type ExItem    = EconItem
    type FunBind
    type FunDesc
    type FunItem
    type Rea

    (* Expressions *)

    val UNITAtExp:    Info                                      -> AtExp
    val TUPLEAtExp:   Info * Exp list                           -> AtExp
    val HASHAtExp:    Info * Lab                                -> AtExp
    val CASEExp:      Info * Exp * Match                        -> Exp
    val IFExp:        Info * Exp * Exp * Exp option             -> Exp
    val ANDALSOExp:   Info * Exp * Exp                          -> Exp
    val ORELSEExp:    Info * Exp * Exp                          -> Exp
    val SEQAtExp:     Info * Exp list                           -> AtExp
    val LETAtExp:     Info * Dec * Exp list                     -> AtExp
    val WHILEExp:     Info * Exp * Exp                          -> Exp
    val FINALLYExp:   Info * Exp * Exp                          -> Exp
    val LISTAtExp:    Info * Exp list                           -> AtExp
    val RECExp:       Info * Pat * Exp                          -> Exp
    val TRANSPACKExp: Info * AtStrExp * AtSigExp                -> Exp
    val OPAQPACKExp:  Info * AtStrExp * AtSigExp                -> Exp
    val COMPAtExp:    Info * LocalAnn option * Spec * Dec       -> AtExp

    val FILEAtExp:      Info * Source.desc                          -> AtExp
    val LINEAtExp:      Info * Source.desc                          -> AtExp
    val ASSERTDOExp:    Info * Source.desc * int option * Exp * Exp -> Exp
    val ASSERTOFDOExp:  Info * Source.desc * int option * Exp * Pat * Exp -> Exp
    val ASSERTExp:      Info * Source.desc * int option * Exp       -> Exp
    val ASSERTOFExp:    Info * Source.desc * int option * Exp * Pat -> Exp
    val ASSERTRAISEExp: Info * Source.desc * int option * Exp * Pat -> Exp

    val UPDATEAtExp:    Info * AtExp * ExpRow                  -> AtExp

    val DOTSExpRow:  Info * Exp * ExpRow option                -> ExpRow
    val VIDExpRow:   Info * VId * Ty option * ExpRow option    -> ExpRow

    (* Patterns *)

    val UNITAtPat:   Info                                      -> AtPat
    val TUPLEAtPat:  Info * Pat list                           -> AtPat
    val LISTAtPat:   Info * Pat list                           -> AtPat

    val DOTSPatRow:  Info * Pat option * PatRow option         -> PatRow
    val VIDPatRow:   Info * VId * Ty option * Pat option * PatRow option
                                                               -> PatRow
    val WITHFUNPat:  Info * Pat * FvalBind                     -> Pat

    (* Types *)

    val TUPLETy:     Info * Ty list                            -> Ty

    val DOTSTyRow:   Info * Ty * TyRow option                  -> TyRow

    (* Bindings *)

    val FvalBind:    Info * Lazy * Fmatch * FvalBind option    -> FvalBind
    val Fmatch:      Info * Fmrule * Fmatch option             -> Fmatch
    val Fmrule:      Info * Fpat * Exp                         -> Fmrule

    (* Declarations *)

    val DODec:		Info * Exp					-> Dec
    val FUNDec:		Info * TyVarSeq * FvalBind			-> Dec
    val DATATYPEDec:	Info * DatBind * TypBind option			-> Dec
    val ABSTYPEDec:	Info * DatBind * TypBind option * Dec		-> Dec
    val EXCEPTIONDec:	Info * ExBind					-> Dec
    val FUNCTORDec:     Info * FunBind					-> Dec
    val OPENDec:	Info * StrExp					-> Dec
    val INFIXMULTIDec:	Info * int option * VId list			-> Dec
    val INFIXRMULTIDec:	Info * int option * VId list			-> Dec
    val NONFIXMULTIDec:	Info * VId list					-> Dec
    val PRIMITIVEFUNDec: Info * Op * VId * Ty * string			-> Dec
    val PRIMITIVEEQTYPEDec:	Info * TyVarSeq * TyCon * string	-> Dec
    val PRIMITIVEEQEQTYPEDec:	Info * TyVarSeq * TyCon * string	-> Dec
    val PRIMITIVEEXCEPTIONDec:	Info * Op * VId * Ty option * string	-> Dec
    val PRIMITIVEFUNCTORDec:	Info * StrId * StrPat list * SigExp * string
								-> Dec
    val NEWExBind:    Info * Op * VId * Ty option * ExBind option    -> ExBind
    val EQUALExBind:  Info * Op * VId * Op * LongVId * ExBind option -> ExBind

    (* Structure bindings *)

    val TRANSStrBind:     Info * StrId * SigExp option * StrExp
			       * StrBind option                    -> StrBind
    val OPAQStrBind:      Info * StrId * SigExp * StrExp
			       * StrBind option                    -> StrBind
    val WILDCARDStrBind:  Info * SigExp option * StrExp
			       * StrBind option                    -> StrBind

    (* Structure expressions *)

    val DECAtStrExp:      Info * Dec -> AtStrExp
    val FCTStrExp:        Info * StrPat * StrExp -> StrExp

    (* Structure patterns *)

    val STRIDAtStrPat:    Info * StrId * SigExp -> AtStrPat
    val WILDCARDAtStrPat: Info * SigExp         -> AtStrPat
    val SPECAtStrPat:     Info * Spec           -> AtStrPat

    val ATSTRPATStrPat:   Info * AtStrPat       -> StrPat
    val STRIDStrPat:      Info * StrId * SigExp -> StrPat
    val WILDCARDStrPat:   Info * SigExp         -> StrPat

    (* Functor bindings *)

    val TRANSFunBind:     Info * Lazy * StrId * StrPat list * SigExp option
			       * StrExp * FunBind option           -> FunBind
    val OPAQFunBind:      Info * Lazy * StrId * StrPat list * SigExp
			       * StrExp * FunBind option           -> FunBind

    (* Specifications *)

    val FUNSpec:          Info * ValDesc                           -> Spec
    val DATATYPESpec:     Info * DatDesc * TypDesc option          -> Spec
    val EXCEPTIONSpec:    Info * ExDesc                            -> Spec
    val FUNCTORSpec:      Info * FunDesc                           -> Spec
    val SHARINGSpec:      Info * Spec * LongStrId list             -> Spec
    val INCLUDEMULTISpec: Info * LongSigId list                    -> Spec
    val INFIXMULTISpec:   Info * int option * VId list             -> Spec
    val INFIXRMULTISpec:  Info * int option * VId list             -> Spec
    val NONFIXMULTISpec:  Info * VId list                          -> Spec

    val NEWExDesc:        Info * Op * VId * Ty option * ExDesc option -> ExDesc
    val EQUALExDesc:      Info * Op * VId * Op * LongVId
						      * ExDesc option -> ExDesc

    val FunDesc:          Info * StrId * StrPat list * SigExp * FunDesc option
								   -> FunDesc

    (* Signature expressions *)

    val SPECAtSigExp:     Info * Spec                              -> AtSigExp
    val FCTSigExp:        Info * StrPat * SigExp                   -> SigExp
    val ARROWSigExp:      Info * AtSigExp * SigExp                 -> SigExp
    val WHEREREASigExp:   Info * SigExp * Rea                      -> SigExp
    val WHERELONGSTRIDSigExp:
			  Info * SigExp * LongStrId * LongStrId    -> SigExp

    val SIGRea:           Info * Spec * Rea option                        -> Rea
    val VALRea:           Info * Op * LongVId * Op * LongVId * Rea option -> Rea
    val FUNRea:           Info * Op * LongVId * Op * LongVId * Rea option -> Rea
    val CONSTRUCTORRea:   Info * Op * LongVId * Op * LongVId * Rea option -> Rea
    val EXCEPTIONRea:     Info * Op * LongVId * Op * LongVId * Rea option -> Rea
    val TYPERea:          Info * TyVarSeq * LongTyCon * Ty * Rea option   -> Rea
    val EQTYPERea:        Info * TyVarSeq * LongTyCon * Rea option        -> Rea
    val EQEQTYPERea:      Info * TyVarSeq * LongTyCon * Rea option        -> Rea
    val STRUCTURERea:     Info * LongStrId * SigExp option * LongStrId
							   * Rea option   -> Rea
    val FUNCTORRea:       Info * LongStrId * SigExp option * LongStrId
							   * Rea option   -> Rea
    val SIGNATURERea:     Info * LongSigId * StrPat list * AppSigExp
							 * Rea option     -> Rea


    (* Imports *)

    val FUNImp:           Info * ValItem                           -> Imp
    val EXCEPTIONImp:     Info * ExItem                            -> Imp
    val FUNCTORImp:       Info * FunItem                           -> Imp
    val INFIXMULTIImp:    Info * int option * VId list             -> Imp
    val INFIXRMULTIImp:   Info * int option * VId list             -> Imp
    val NONFIXMULTIImp:   Info * VId list                          -> Imp

    val PLAINExItem:      Info * Op * VId * ExItem option          -> ExItem
    val DESCExItem:       Info * Op * VId * Ty * ExItem option     -> ExItem

    val PLAINFunItem:     Info * StrId * FunItem option            -> FunItem
    val DESCFunItem:      Info * StrId * StrPat list * SigExp * FunItem option
								   -> FunItem

    (* Programs *)

    val DECProgram:       Info * Dec * Program option -> Program
    val EXPProgram:       Info * Exp * Program option -> Program
end

end (* local *)
