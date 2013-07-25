val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-03 11:33:04 $ by $Author: rossberg $
 *   $Revision: 1.39 $
 *)

(*
 * Stockhausen input grammar
 *
 * Extensions and modifications to core language:
 *   - unified dec and topdec (i.e. top declarations can appear in let)
 *   - lazy expressions
 *   - spawn expressions
 *   - row capture
 *   - record update expressions
 *   - vector expressions and patterns
 *   - generalized layered patterns
 *   - alternative patterns
 *   - guarded patterns
 *   - negated patterns
 *   - withval patterns
 *   - type wildcards
 *   - abstract type declarations
 *   - extensible datatypes and free construct declarations
 *   - package expressions
 *   - removed exception declarations (made into a derived form)
 *   - removed abstype (made into a derived form with local)
 *   - simplified open and fixity declarations to single id (multi ids made DF)
 *   - some hacks to build libraries: primitive declarations, overload
 *     declarations, special eqtype declarations and specifications
 *
 * Extensions and modifications to module language:
 *   - components
 *   - unified strdec and topdec
 *   - unified strid and funid
 *   - functor expressions
 *   - removed functor declarations (made into a derived form)
 *   - package elimination
 *   - parameterized signatures
 *   - open datatypes and free constructor specifications
 *   - straightified type specifications (synonyms are kept)
 *   - signature specifications
 *   - definitional value, constructor, and structure specifications
 *   - functor signatures
 *   - top signature
 *   - generalized where
 *   - sharing for signatures
 *   - let for signature expressions
 *   - functor parameters as a separate syntactic class StrPat
 *   - parenthesized structure and signature expressions
 *   - fixity directives in signatures
 *   - op keyword in signatures
 *
 * Notes:
 *   For easier interfacing with the back end we keep several derived forms:
 *   - tuple expressions, patterns, and types
 *   - selector functions
 *   - case, if, orelse, andalso expressions
 *   - sequential expressions
 *   - while expressions
 *   Optional semicolons are omitted.
 *   Because of delayed infix resolution we have to keep fvalbind forms and
 *   need a special app pattern form.
 *   Constructor patterns with arguments are represented as APPPats.
 *   We must also keep parentheses and stuff because of delayed infix resolving.
 *   The structure where and sharing derived forms [Definition, Appendix A]
 *   have been kept because they cannot be derived purely syntactically.
 *)











functor MkInputGrammar(type Info) : INPUT_GRAMMAR =
struct

    (* Import *)

    type Info = Info


    (* Identifiers and constants *)

    datatype SCon  = SCon  of Info * SCon.t
    datatype Lab   = Lab   of Info * Lab.t
    datatype VId   = VId   of Info * VId.t
    datatype TyCon = TyCon of Info * TyCon.t
    datatype TyVar = TyVar of Info * TyVar.t
    datatype StrId = StrId of Info * StrId.t
    datatype SigId = SigId of Info * SigId.t

    datatype 'a Long =
	  SHORTLong of Info * 'a
	| DOTLong   of Info * LongStrId * 'a

    withtype LongVId   = VId Long
    and      LongTyCon = TyCon Long
    and      LongStrId = StrId Long
    and      LongSigId = SigId Long


    (* Optional keywords `op' and `lazy' *)

    datatype Op   = SANSOp | WITHOp
    datatype Lazy = SANSLazy | WITHLazy | WITHSpawn


    (* Expressions *)

    datatype AtExp =
	  SCONAtExp      of Info * SCon
	| LONGVIDAtExp   of Info * Op * LongVId
	| RECORDAtExp    of Info * ExpRow option
	| HASHAtExp      of Info * Lab
	| TUPLEAtExp     of Info * Exp list
	| VECTORAtExp    of Info * Exp list
	| SEQAtExp       of Info * Exp list
	| LETAtExp       of Info * Dec * Exp
	| COMPAtExp      of Info * LocalAnn * Spec * Dec
	| PARAtExp       of Info * Exp

    and ExpRow =
	  DOTSExpRow     of Info * Exp
	| ROWExpRow      of Info * Lab * Exp * ExpRow option

    and Exp =
	  ATEXPExp       of Info * AtExp
	| APPExp         of Info * Exp * AtExp
	| TYPEDExp       of Info * Exp * Ty
	| ANDALSOExp     of Info * Exp * Exp
	| ORELSEExp      of Info * Exp * Exp
	| HANDLEExp      of Info * Exp * Match
	| RAISEExp       of Info * Exp
	| LAZYExp        of Info * Exp
	| SPAWNExp       of Info * Exp
	| IFExp          of Info * Exp * Exp * Exp
	| CASEExp        of Info * Exp * Match
	| FNExp          of Info * Match
	| PACKExp        of Info * AtStrExp * AtSigExp

    (* Matches *)      

    and Match =
	  Match          of Info * Mrule * Match option

    and Mrule =
	  Mrule          of Info * Pat * Exp

    (* Declarations *)

    and Dec =
	  VALDec          of Info * TyVarSeq * ValBind
	| FUNDec          of Info * TyVarSeq * FvalBind
	| TYPEDec         of Info * TypBind
	| EQTYPEDec       of Info * TypBind
	| EQEQTYPEDec     of Info * TypBind
	| DATATYPEDec     of Info * DatBind
	| REPLICATIONDec  of Info * TyCon * LongTyCon
	| EXTTYPEDec      of Info * ExtBind
	| CONSTRUCTORDec  of Info * EconBind
	| STRUCTUREDec    of Info * StrBind
	| SIGNATUREDec    of Info * SigBind
	| LOCALDec        of Info * Dec * Dec
	| OPENDec         of Info * LongStrId
	| EMPTYDec        of Info
	| SEQDec          of Info * Dec * Dec
	| INFIXDec        of Info * int * VId
	| INFIXRDec       of Info * int * VId
	| NONFIXDec       of Info * VId
	| OVERLOADDec     of Info * TyVar * LongTyConSeq
				  * Op * VId * Ty * LongVIdSeq
	| OVERLOADALLDec  of Info * TyVar * Op * VId * Ty * LongVId
	| PRIMITIVEVALDec         of Info * Op * VId * Ty * string
	| PRIMITIVETYPEDec        of Info * TyVarSeq * TyCon * string
	| PRIMITIVEEXTTYPEDec     of Info * TyVarSeq * TyCon * string
	| PRIMITIVEREFTYPEDec     of Info * TyVar * TyCon * Op * VId * TyVar
	| PRIMITIVECONSTRUCTORDec of Info * Op * VId * Ty option
					       * TyVarSeq * LongTyCon * string
	| PRIMITIVESTRUCTUREDec   of Info * StrId * SigExp * string
	| PRIMITIVESIGNATUREDec   of Info * SigId * StrPat list * string

    (* Bindings *)

    and ValBind =
	  PLAINValBind   of Info * Pat * Exp * ValBind option
	| RECValBind     of Info * ValBind

    and FvalBind =
	  FvalBind       of Info * Lazy * Match * FvalBind option

    and TypBind =
	  NEWTypBind     of Info * TyVarSeq * TyCon * TypBind option
	| EQUALTypBind   of Info * TyVarSeq * TyCon * Ty * TypBind option

    and DatBind =
	  DatBind        of Info * TyVarSeq * TyCon * ConBind * DatBind option

    and ConBind =
	  ConBind        of Info * Op * VId * Ty option * ConBind option

    and ExtBind =
	  ExtBind        of Info * TyVarSeq * TyCon * ExtBind option

    and EconBind =
	  NEWEconBind    of Info * Op * VId * Ty option * TyVarSeq * LongTyCon
							* EconBind option
	| EQUALEconBind  of Info * Op * VId * Op * LongVId * EconBind option

    and StrBind =
          StrBind        of Info * StrId * StrExp * StrBind option

    and SigBind =
          SigBind        of Info * SigId * StrPat list * SigExp * SigBind option

    (* Patterns *)

    and AtPat =
	  WILDCARDAtPat  of Info
	| SCONAtPat      of Info * SCon
	| LONGVIDAtPat   of Info * Op * LongVId
	| RECORDAtPat    of Info * PatRow option
	| TUPLEAtPat     of Info * Pat list
	| VECTORAtPat    of Info * Pat list
	| ALTAtPat       of Info * Pat list
	| PARAtPat       of Info * Pat

    and PatRow =
	  DOTSPatRow     of Info * Pat
	| ROWPatRow      of Info * Lab * Pat * PatRow option

    and Pat =
	  ATPATPat       of Info * AtPat
	| APPPat         of Info * Pat * AtPat
	| TYPEDPat       of Info * Pat * Ty
	| NONPat         of Info * Pat
	| ASPat          of Info * Pat * Pat
	| IFPat          of Info * Pat * AtExp
	| WITHVALPat     of Info * Pat * ValBind
	| WITHFUNPat     of Info * Pat * FvalBind

    (* Type expressions *)

    and Ty =
	  WILDCARDTy     of Info
	| TYVARTy        of Info * TyVar
	| RECORDTy       of Info * TyRow option
	| TUPLETy        of Info * Ty list
	| TYCONTy        of Info * TySeq * LongTyCon
	| ARROWTy        of Info * Ty * Ty
	| PARTy          of Info * Ty

    and TyRow =
	  DOTSTyRow      of Info * Ty
	| ROWTyRow       of Info * Lab * Ty * TyRow option

    (* Structures *)

    and AtStrExp =
	  STRUCTAtStrExp    of Info * Dec
	| LONGSTRIDAtStrExp of Info * LongStrId
	| LETAtStrExp       of Info * Dec * StrExp
	| PARAtStrExp       of Info * StrExp

    and StrExp =
	  ATSTREXPStrExp    of Info * AtStrExp
	| APPStrExp         of Info * StrExp * AtStrExp
	| TRANSStrExp       of Info * StrExp * SigExp
	| OPAQStrExp        of Info * StrExp * SigExp
	| FCTStrExp         of Info * StrPat * StrExp
	| UNPACKStrExp      of Info * Exp * SigExp
	| LAZYStrExp        of Info * StrExp
	| SPAWNStrExp       of Info * StrExp

    and StrPat =
	  StrPat            of Info * StrId * SigExp

    (* Signatures *)

    and AtSigExp =
	  ANYAtSigExp       of Info
	| SIGAtSigExp       of Info * Spec
	| LONGSIGIDAtSigExp of Info * LongSigId
	| LETAtSigExp       of Info * Dec * SigExp
	| PARAtSigExp       of Info * SigExp

    and SigExp =
	  ATSIGEXPSigExp    of Info * AtSigExp
	| APPSigExp         of Info * SigExp * AtStrExp
	| FCTSigExp         of Info * StrPat * SigExp
	| WHERESigExp       of Info * SigExp * SigExp

    (* Specifications *)

    and Spec =
	  VALSpec           of Info * ValDesc
	| TYPESpec          of Info * TypDesc
	| EQTYPESpec        of Info * TypDesc
	| EQEQTYPESpec      of Info * TypDesc
	| DATATYPESpec      of Info * DatDesc
	| REPLICATIONSpec   of Info * TyCon * LongTyCon
	| EXTTYPESpec       of Info * ExtDesc
	| CONSTRUCTORSpec   of Info * EconDesc
	| STRUCTURESpec     of Info * StrDesc
	| SIGNATURESpec     of Info * SigDesc
	| INCLUDESpec       of Info * SigExp
	| EMPTYSpec         of Info
	| SEQSpec           of Info * Spec * Spec
	| SHARINGTYPESpec   of Info * Spec * LongTyCon list
	| SHARINGSIGNATURESpec of Info * Spec * LongSigId list
	| SHARINGSpec       of Info * Spec * LongStrId list
	| INFIXSpec         of Info * int * VId
	| INFIXRSpec        of Info * int * VId
	| NONFIXSpec        of Info * VId

    and ValDesc =
	  NEWValDesc      of Info * Op * VId * Ty * ValDesc option
	| EQUALValDesc    of Info * Op * VId * Op * LongVId * ValDesc option

    and TypDesc =
	  NEWTypDesc      of Info * TyVarSeq * TyCon * TypDesc option
	| EQUALTypDesc    of Info * TyVarSeq * TyCon * Ty * TypDesc option

    and DatDesc =
	  DatDesc         of Info * TyVarSeq * TyCon * ConDesc * DatDesc option

    and ConDesc =
	  ConDesc         of Info * Op * VId * Ty option * ConDesc option

    and ExtDesc =
	  ExtDesc         of Info * TyVarSeq * TyCon * ExtDesc option

    and EconDesc =
	  NEWEconDesc     of Info * Op * VId * Ty option * TyVarSeq * LongTyCon
			 				      * EconDesc option
	| EQUALEconDesc   of Info * Op * VId * Op * LongVId * EconDesc option

    and StrDesc =
          NEWStrDesc      of Info * StrId * SigExp * StrDesc option
	| EQUALStrDesc    of Info * StrId * SigExp option * LongStrId
							    * StrDesc option
    and SigDesc =
          NEWSigDesc      of Info * SigId * StrPat list * SigDesc option
	| EQUALSigDesc    of Info * SigId * StrPat list * SigExp
							* SigDesc option

    (* Imports *)

    and Imp =
	  VALImp          of Info * ValItem
	| TYPEImp         of Info * TypItem
	| EQTYPEImp       of Info * TypItem
	| EQEQTYPEImp     of Info * TypItem
	| DATATYPEImp     of Info * DatItem
	| EXTTYPEImp      of Info * ExtItem
	| CONSTRUCTORImp  of Info * EconItem
	| STRUCTUREImp    of Info * StrItem
	| SIGNATUREImp    of Info * SigItem
	| EMPTYImp        of Info
	| SEQImp          of Info * Imp * Imp
	| INFIXImp        of Info * int * VId
	| INFIXRImp       of Info * int * VId
	| NONFIXImp       of Info * VId

    and ValItem =
	  PLAINValItem    of Info * Op * VId * ValItem option
	| DESCValItem     of Info * Op * VId * Ty * ValItem option

    and TypItem =
	  PLAINTypItem    of Info * TyCon * TypItem option
	| DESCTypItem     of Info * TyVarSeq * TyCon * TypItem option

    and DatItem =
	  PLAINDatItem    of Info * TyCon * DatItem option
	| DESCDatItem     of Info * TyVarSeq * TyCon * ConItem * DatItem option

    and ConItem =
	  ConItem         of Info * Op * VId * Ty option * ConItem option

    and ExtItem =
	  PLAINExtItem    of Info * TyCon * ExtItem option
	| DESCExtItem     of Info * TyVarSeq * TyCon * ExtItem option

    and EconItem =
	  PLAINEconItem   of Info * Op * VId * EconItem option
	| DESCEconItem    of Info * Op * VId * Ty option * TyVarSeq * LongTyCon
			 				      * EconItem option
    and StrItem =
	  PLAINStrItem    of Info * StrId * StrItem option
        | DESCStrItem     of Info * StrId * SigExp * StrItem option

    and SigItem =
	  PLAINSigItem    of Info * SigId * SigItem option
        | DESCSigItem     of Info * SigId * StrPat list * SigItem option

    (* Announcements *)

    and Ann =
	  IMPORTAnn             of Info * Imp * string
	| IMPORTALLAnn          of Info * string
	| PRIMITIVEIMPORTAnn    of Info * Imp * string
	| PRIMITIVEIMPORTALLAnn of Info * string
	| EMPTYAnn              of Info
	| SEQAnn                of Info * Ann * Ann

    and LocalAnn =
	  IMPORTLocalAnn        of Info * Spec * string
	| EMPTYLocalAnn         of Info
	| SEQLocalAnn           of Info * LocalAnn * LocalAnn

    (* Programs and components *)

    and Program   = Program   of Info * Dec * Program option
    and Component = Component of Info * Ann * Program option

    (* Sequences *)

    and 'a Seq    = Seq of Info * 'a list

    withtype TySeq        = Ty Seq
    and      TyVarSeq     = TyVar Seq
    and      LongTyConSeq = LongTyCon Seq
    and      LongVIdSeq   = LongVId Seq

    (* The Type(tm) *)

    type t = Component


    (* Extracting info fields *)

    fun infoSCon(SCon(I,_))				= I
    fun infoLab(Lab(I,_))				= I
    fun infoVId(VId(I,_))				= I
    fun infoTyCon(TyCon(I,_))				= I
    fun infoTyVar(TyVar(I,_))				= I
    fun infoStrId(StrId(I,_))				= I
    fun infoSigId(SigId(I,_))				= I

    fun infoLong(SHORTLong(I,_))			= I
      | infoLong(DOTLong(I,_,_))			= I

    fun infoAtExp(SCONAtExp(I,_))			= I
      | infoAtExp(LONGVIDAtExp(I,_,_))			= I
      | infoAtExp(RECORDAtExp(I,_))			= I
      | infoAtExp(HASHAtExp(I,_))			= I
      | infoAtExp(TUPLEAtExp(I,_))			= I
      | infoAtExp(VECTORAtExp(I,_))			= I
      | infoAtExp(SEQAtExp(I,_))			= I
      | infoAtExp(LETAtExp(I,_,_))			= I
      | infoAtExp(COMPAtExp(I,_,_,_))			= I
      | infoAtExp(PARAtExp(I,_))			= I

    fun infoExpRow(DOTSExpRow(I,_))			= I
      | infoExpRow(ROWExpRow(I,_,_,_))			= I

    fun infoExp(ATEXPExp(I,_))				= I
      | infoExp(APPExp(I,_,_))				= I
      | infoExp(TYPEDExp(I,_,_))			= I
      | infoExp(ANDALSOExp(I,_,_))			= I
      | infoExp(ORELSEExp(I,_,_))			= I
      | infoExp(HANDLEExp(I,_,_))			= I
      | infoExp(RAISEExp(I,_))				= I
      | infoExp(LAZYExp(I,_))				= I
      | infoExp(SPAWNExp(I,_))				= I
      | infoExp(IFExp(I,_,_,_))				= I
      | infoExp(CASEExp(I,_,_))				= I
      | infoExp(FNExp(I,_))				= I
      | infoExp(PACKExp(I,_,_))				= I

    fun infoMatch(Match(I,_,_))				= I

    fun infoMrule(Mrule(I,_,_))				= I

    fun infoDec(VALDec(I,_,_))				= I
      | infoDec(FUNDec(I,_,_))				= I
      | infoDec(TYPEDec(I,_))				= I
      | infoDec(EQTYPEDec(I,_))				= I
      | infoDec(EQEQTYPEDec(I,_))			= I
      | infoDec(DATATYPEDec(I,_))			= I
      | infoDec(REPLICATIONDec(I,_,_))			= I
      | infoDec(EXTTYPEDec(I,_))			= I
      | infoDec(CONSTRUCTORDec(I,_))			= I
      | infoDec(STRUCTUREDec(I,_))			= I
      | infoDec(SIGNATUREDec(I,_))			= I
      | infoDec(LOCALDec(I,_,_))			= I
      | infoDec(OPENDec(I,_))				= I
      | infoDec(EMPTYDec(I))				= I
      | infoDec(SEQDec(I,_,_))				= I
      | infoDec(INFIXDec(I,_,_))			= I
      | infoDec(INFIXRDec(I,_,_))			= I
      | infoDec(NONFIXDec(I,_))				= I
      | infoDec(OVERLOADDec(I,_,_,_,_,_,_))		= I
      | infoDec(OVERLOADALLDec(I,_,_,_,_,_))		= I
      | infoDec(PRIMITIVEVALDec(I,_,_,_,_))		= I
      | infoDec(PRIMITIVETYPEDec(I,_,_,_))		= I
      | infoDec(PRIMITIVEEXTTYPEDec(I,_,_,_))		= I
      | infoDec(PRIMITIVEREFTYPEDec(I,_,_,_,_,_))	= I
      | infoDec(PRIMITIVECONSTRUCTORDec(I,_,_,_,_,_,_))	= I
      | infoDec(PRIMITIVESTRUCTUREDec(I,_,_,_))		= I
      | infoDec(PRIMITIVESIGNATUREDec(I,_,_,_))		= I

    fun infoValBind(PLAINValBind(I,_,_,_))		= I
      | infoValBind(RECValBind(I,_))			= I

    fun infoFvalBind(FvalBind(I,_,_,_))			= I

    fun infoTypBind(NEWTypBind(I,_,_,_))		= I
      | infoTypBind(EQUALTypBind(I,_,_,_,_))		= I

    fun infoDatBind(DatBind(I,_,_,_,_))			= I

    fun infoConBind(ConBind(I,_,_,_,_))			= I

    fun infoExtBind(ExtBind(I,_,_,_))			= I

    fun infoEconBind(NEWEconBind(I,_,_,_,_,_,_))	= I
      | infoEconBind(EQUALEconBind(I,_,_,_,_,_))	= I

    fun infoStrBind(StrBind(I,_,_,_))			= I

    fun infoSigBind(SigBind(I,_,_,_,_))			= I

    fun infoAtPat(WILDCARDAtPat(I))			= I
      | infoAtPat(SCONAtPat(I,_))			= I
      | infoAtPat(LONGVIDAtPat(I,_,_))			= I
      | infoAtPat(RECORDAtPat(I,_))			= I
      | infoAtPat(TUPLEAtPat(I,_))			= I
      | infoAtPat(VECTORAtPat(I,_))			= I
      | infoAtPat(ALTAtPat(I,_))			= I
      | infoAtPat(PARAtPat(I,_))			= I

    fun infoPatRow(DOTSPatRow(I,_))			= I
      | infoPatRow(ROWPatRow(I,_,_,_))			= I

    fun infoPat(ATPATPat(I,_))				= I
      | infoPat(APPPat(I,_,_))				= I
      | infoPat(TYPEDPat(I,_,_))			= I
      | infoPat(NONPat(I,_))				= I
      | infoPat(ASPat(I,_,_))				= I
      | infoPat(IFPat(I,_,_))				= I
      | infoPat(WITHVALPat(I,_,_))			= I
      | infoPat(WITHFUNPat(I,_,_))			= I

    fun infoTy(WILDCARDTy(I))				= I
      | infoTy(TYVARTy(I,_))				= I
      | infoTy(RECORDTy(I,_))				= I
      | infoTy(TUPLETy(I,_))				= I
      | infoTy(TYCONTy(I,_,_))				= I
      | infoTy(ARROWTy(I,_,_))				= I
      | infoTy(PARTy(I,_))				= I

    fun infoTyRow(DOTSTyRow(I,_))			= I
      | infoTyRow(ROWTyRow(I,_,_,_))			= I

    fun infoAtStrExp(STRUCTAtStrExp(I,_))		= I
      | infoAtStrExp(LONGSTRIDAtStrExp(I,_))		= I
      | infoAtStrExp(LETAtStrExp(I,_,_))		= I
      | infoAtStrExp(PARAtStrExp(I,_))			= I

    fun infoStrExp(ATSTREXPStrExp(I,_))			= I
      | infoStrExp(APPStrExp(I,_,_))			= I
      | infoStrExp(TRANSStrExp(I,_,_))			= I
      | infoStrExp(OPAQStrExp(I,_,_))			= I
      | infoStrExp(FCTStrExp(I,_,_))			= I
      | infoStrExp(UNPACKStrExp(I,_,_))			= I
      | infoStrExp(LAZYStrExp(I,_))			= I
      | infoStrExp(SPAWNStrExp(I,_))			= I

    fun infoStrPat(StrPat(I,_,_))			= I

    fun infoAtSigExp(ANYAtSigExp(I))			= I
      | infoAtSigExp(SIGAtSigExp(I,_))			= I
      | infoAtSigExp(LONGSIGIDAtSigExp(I,_))		= I
      | infoAtSigExp(LETAtSigExp(I,_,_))		= I
      | infoAtSigExp(PARAtSigExp(I,_))			= I

    fun infoSigExp(ATSIGEXPSigExp(I,_))			= I
      | infoSigExp(APPSigExp(I,_,_))			= I
      | infoSigExp(FCTSigExp(I,_,_))			= I
      | infoSigExp(WHERESigExp(I,_,_))			= I

    fun infoSpec(VALSpec(I,_))				= I
      | infoSpec(TYPESpec(I,_))				= I
      | infoSpec(EQTYPESpec(I,_))			= I
      | infoSpec(EQEQTYPESpec(I,_))			= I
      | infoSpec(DATATYPESpec(I,_))			= I
      | infoSpec(REPLICATIONSpec(I,_,_))		= I
      | infoSpec(EXTTYPESpec(I,_))			= I
      | infoSpec(CONSTRUCTORSpec(I,_))			= I
      | infoSpec(STRUCTURESpec(I,_))			= I
      | infoSpec(SIGNATURESpec(I,_))			= I
      | infoSpec(INCLUDESpec(I,_))			= I
      | infoSpec(EMPTYSpec(I))				= I
      | infoSpec(SEQSpec(I,_,_))			= I
      | infoSpec(SHARINGTYPESpec(I,_,_))		= I
      | infoSpec(SHARINGSIGNATURESpec(I,_,_))		= I
      | infoSpec(SHARINGSpec(I,_,_))			= I
      | infoSpec(INFIXSpec(I,_,_))			= I
      | infoSpec(INFIXRSpec(I,_,_))			= I
      | infoSpec(NONFIXSpec(I,_))			= I

    fun infoValDesc(NEWValDesc(I,_,_,_,_))		= I
      | infoValDesc(EQUALValDesc(I,_,_,_,_,_))		= I

    fun infoTypDesc(NEWTypDesc(I,_,_,_))		= I
      | infoTypDesc(EQUALTypDesc(I,_,_,_,_))		= I

    fun infoDatDesc(DatDesc(I,_,_,_,_))			= I

    fun infoConDesc(ConDesc(I,_,_,_,_))			= I

    fun infoExtDesc(ExtDesc(I,_,_,_))			= I

    fun infoEconDesc(NEWEconDesc(I,_,_,_,_,_,_))	= I
      | infoEconDesc(EQUALEconDesc(I,_,_,_,_,_))	= I

    fun infoStrDesc(NEWStrDesc(I,_,_,_))		= I
      | infoStrDesc(EQUALStrDesc(I,_,_,_,_))		= I

    fun infoSigDesc(NEWSigDesc(I,_,_,_))		= I
      | infoSigDesc(EQUALSigDesc(I,_,_,_,_))		= I

    fun infoImp(VALImp(I,_))				= I
      | infoImp(TYPEImp(I,_))				= I
      | infoImp(EQTYPEImp(I,_))				= I
      | infoImp(EQEQTYPEImp(I,_))			= I
      | infoImp(DATATYPEImp(I,_))			= I
      | infoImp(EXTTYPEImp(I,_))			= I
      | infoImp(CONSTRUCTORImp(I,_))			= I
      | infoImp(STRUCTUREImp(I,_))			= I
      | infoImp(SIGNATUREImp(I,_))			= I
      | infoImp(EMPTYImp(I))				= I
      | infoImp(SEQImp(I,_,_))				= I
      | infoImp(INFIXImp(I,_,_))			= I
      | infoImp(INFIXRImp(I,_,_))			= I
      | infoImp(NONFIXImp(I,_))				= I

    fun infoValItem(PLAINValItem(I,_,_,_))		= I
      | infoValItem(DESCValItem(I,_,_,_,_))		= I

    fun infoTypItem(PLAINTypItem(I,_,_))		= I
      | infoTypItem(DESCTypItem(I,_,_,_))		= I

    fun infoDatItem(PLAINDatItem(I,_,_))		= I
      | infoDatItem(DESCDatItem(I,_,_,_,_))		= I

    fun infoConItem(ConItem(I,_,_,_,_))			= I

    fun infoExtItem(PLAINExtItem(I,_,_))		= I
      | infoExtItem(DESCExtItem(I,_,_,_))		= I

    fun infoEconItem(PLAINEconItem(I,_,_,_))		= I
      | infoEconItem(DESCEconItem(I,_,_,_,_,_,_))	= I

    fun infoStrItem(PLAINStrItem(I,_,_))		= I
      | infoStrItem(DESCStrItem(I,_,_,_))		= I

    fun infoSigItem(PLAINSigItem(I,_,_))		= I
      | infoSigItem(DESCSigItem(I,_,_,_))		= I

    fun infoAnn(IMPORTAnn(I,_,_))			= I
      | infoAnn(IMPORTALLAnn(I,_))			= I
      | infoAnn(PRIMITIVEIMPORTAnn(I,_,_))		= I
      | infoAnn(PRIMITIVEIMPORTALLAnn(I,_))		= I
      | infoAnn(EMPTYAnn(I))				= I
      | infoAnn(SEQAnn(I,_,_))				= I

    fun infoLocalAnn(IMPORTLocalAnn(I,_,_))		= I
      | infoLocalAnn(EMPTYLocalAnn(I))			= I
      | infoLocalAnn(SEQLocalAnn(I,_,_))		= I

    fun infoProgram(Program(I,_,_))			= I
    fun infoComponent(Component(I,_,_))			= I

    fun infoSeq(Seq(I,_))				= I


    fun idLab(Lab(_,id))				= id
    fun idVId(VId(_,id))				= id
    fun idTyCon(TyCon(_,id))				= id
    fun idTyVar(TyVar(_,id))				= id
    fun idStrId(StrId(_,id))				= id
    fun idSigId(SigId(_,id))				= id


    fun explodeLong(SHORTLong(_,id))		= ([], id)
      | explodeLong(DOTLong(_,longid,id))	= (explodeLong'(longid,[]), id)

    and explodeLong'(SHORTLong(_,id),      ids)	= id::ids
      | explodeLong'(DOTLong(_,longid,id), ids)	= explodeLong'(longid, id::ids)


    fun hasAllValDescs(PLAINValItem _)		= false
      | hasAllValDescs(DESCValItem _)		= true
    fun hasAllTypDescs(PLAINTypItem _)		= false
      | hasAllTypDescs(DESCTypItem _)		= true
    fun hasAllDatDescs(PLAINDatItem _)		= false
      | hasAllDatDescs(DESCDatItem _)		= true
    fun hasAllExtDescs(PLAINExtItem _)		= false
      | hasAllExtDescs(DESCExtItem _)		= true
    fun hasAllEconDescs(PLAINEconItem _)	= false
      | hasAllEconDescs(DESCEconItem _)		= true
    fun hasAllStrDescs(PLAINStrItem _)		= false
      | hasAllStrDescs(DESCStrItem _)		= true
    fun hasAllSigDescs(PLAINSigItem _)		= false
      | hasAllSigDescs(DESCSigItem _)		= true

    fun hasAllDescs(VALImp(I,valitem))		= hasAllValDescs valitem
      | hasAllDescs(TYPEImp(I,typitem))		= hasAllTypDescs typitem
      | hasAllDescs(EQTYPEImp(I,typitem))	= hasAllTypDescs typitem
      | hasAllDescs(EQEQTYPEImp(I,typitem))	= hasAllTypDescs typitem
      | hasAllDescs(DATATYPEImp(I,datitem))	= hasAllDatDescs datitem
      | hasAllDescs(EXTTYPEImp(I,extitem))	= hasAllExtDescs extitem
      | hasAllDescs(CONSTRUCTORImp(I,econitem))	= hasAllEconDescs econitem
      | hasAllDescs(STRUCTUREImp(I,stritem))	= hasAllStrDescs stritem
      | hasAllDescs(SIGNATUREImp(I,sigitem))	= hasAllSigDescs sigitem
      | hasAllDescs(EMPTYImp(I))		= true
      | hasAllDescs(SEQImp(I,item1,item2))	= hasAllDescs item1 andalso
						  hasAllDescs item2
      | hasAllDescs(INFIXImp(I,_,_))		= true
      | hasAllDescs(INFIXRImp(I,_,_))		= true
      | hasAllDescs(NONFIXImp(I,_))		= true
end
