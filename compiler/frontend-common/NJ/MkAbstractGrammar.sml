val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:17:29 $ by $Author: rossberg $
 *   $Revision: 1.55 $
 *)








functor MkAbstractGrammar(type fix_info
			  type vallab_info
			  type typlab_info
			  type modlab_info
			  type inflab_info
			  type valid_info
			  type typid_info
			  type varid_info
			  type modid_info
			  type infid_info
			  type vallongid_info
			  type typlongid_info
			  type modlongid_info
			  type inflongid_info
			  type exp_info
			  type pat_info
			  type 'a row_info
			  type 'a fld_info
			  type mat_info
			  type typ_info
			  type mod_info
			  type inf_info
			  type dec_info
			  type spec_info
			  type imp_info
			  type ann_info
			  type com_info
			 ) : ABSTRACT_GRAMMAR =
struct
  (* Generic info *)

    type fix_info	= fix_info
    type vallab_info	= vallab_info
    type typlab_info	= typlab_info
    type modlab_info	= modlab_info
    type inflab_info	= inflab_info
    type valid_info	= valid_info
    type typid_info	= typid_info
    type varid_info	= varid_info
    type modid_info	= modid_info
    type infid_info	= infid_info
    type vallongid_info	= vallongid_info
    type typlongid_info	= typlongid_info
    type modlongid_info	= modlongid_info
    type inflongid_info	= inflongid_info
    type exp_info	= exp_info
    type pat_info	= pat_info
    type 'a row_info	= 'a row_info
    type 'a fld_info	= 'a fld_info
    type mat_info	= mat_info
    type typ_info	= typ_info
    type mod_info	= mod_info
    type inf_info	= inf_info
    type dec_info	= dec_info
    type spec_info	= spec_info
    type imp_info	= imp_info
    type ann_info	= ann_info
    type com_info	= com_info

  (* Literals *)

    datatype lit =
	  IntLit    of LargeInt.int		(* integer *)
	| WordLit   of LargeWord.word		(* word *)
	| CharLit   of WideChar.char		(* character *)
	| StringLit of WideString.string	(* string *)
	| RealLit   of LargeReal.real		(* floating point *)

  (* Fixity *)

    datatype fix = Fix of fix_info * Fixity.t

  (* Identifiers *)

    datatype 'a lab		= Lab     of 'a * Label.t
    datatype 'a id		= Id      of 'a * Stamp.t * Name.t
    datatype ('a,'b,'c) longid	= ShortId of 'a * 'b id
				| LongId  of 'a * modlongid * 'c lab
    withtype vallab		= vallab_info lab
    and      typlab		= typlab_info lab
    and      modlab		= modlab_info lab
    and      inflab		= inflab_info lab
    and      valid		= valid_info id
    and      typid		= typid_info id
    and      varid		= varid_info id * bool  (* equality? *)
    and      modid		= modid_info id
    and      infid		= infid_info id
    and      vallongid		= (vallongid_info,valid_info,vallab_info) longid
    and      typlongid		= (typlongid_info,typid_info,typlab_info) longid
    and      modlongid		= (modlongid_info,modid_info,modlab_info) longid
    and      inflongid		= (inflongid_info,infid_info,inflab_info) longid

  (* Expressions *)

    datatype exp =
	  LitExp    of exp_info * lit		(* literal *)
	| VarExp    of exp_info * vallongid	(* variable *)
	| PrimExp   of exp_info * string * typ	(* builtin values *)
	| NewExp    of exp_info * typ		(* first-class constructor *)
	| TagExp    of exp_info * vallab * exp	(* tagged *)
	| ConExp    of exp_info * vallongid * exp (* constructed value *)
	| RefExp    of exp_info * exp		(* reference *)
	| RollExp   of exp_info * exp * typ	(* recursive typing *)
	| StrictExp of exp_info * exp		(* strict evaluation *)
	| TupExp    of exp_info * exp vector	(* tuple *)
	| ProdExp   of exp_info * exp row	(* product (record) *)
	| SelExp    of exp_info * vallab * exp	(* selection *)
	| VecExp    of exp_info * exp vector	(* vector *)
	| FunExp    of exp_info * mat vector	(* function *)
	| AppExp    of exp_info * exp * exp	(* application *)
	| AndExp    of exp_info * exp * exp	(* short-circuit conjunction *)
	| OrExp     of exp_info * exp * exp	(* short-circuit disjunction *)
	| IfExp     of exp_info * exp * exp * exp (* conditional *)
	| SeqExp    of exp_info * exp * exp	(* sequential expressions *)
	| CaseExp   of exp_info * exp * mat vector (* case *)
	| LazyExp   of exp_info * exp		(* lazy evaluation *)
	| SpawnExp  of exp_info * exp		(* concurrent evaulation *)
	| FailExp   of exp_info			(* failure *)
	| RaiseExp  of exp_info * exp		(* exception raising *)
	| HandleExp of exp_info * exp * mat vector (* exception handling *)
	| AnnExp    of exp_info * exp * typ	(* type annotation *)
	| LetExp    of exp_info * dec vector * exp (* let *)
	| PackExp   of exp_info * mod * inf	(* package introduction *)
	| OverExp   of exp_info * exp vector
				* varid * typlongid vector * typ (* overload *)
	| OverallExp of exp_info * exp * varid * typ (* intensional overload *)

    and 'a row = Row of 'a row_info * 'a fld vector * 'a option
    and 'a fld = Fld of 'a fld_info * vallab * 'a

  (* Patterns *)

    and mat = Mat of mat_info * pat * exp

    and pat =
	  JokPat    of pat_info			(* joker (wildcard) *)
	| LitPat    of pat_info * lit		(* literal *)
	| VarPat    of pat_info * valid		(* variable *)
	| TagPat    of pat_info * vallab * pat	(* tagged *)
	| ConPat    of pat_info * vallongid * pat (* constructed value *)
	| RefPat    of pat_info * pat		(* reference *)
	| RollPat   of pat_info * pat * typ	(* recursive typing *)
	| StrictPat of pat_info * pat		(* non-future *)
	| TupPat    of pat_info * pat vector	(* tuple *)
	| ProdPat   of pat_info * pat row	(* row (record) *)
	| VecPat    of pat_info * pat vector	(* vector *)
	| AsPat     of pat_info * pat * pat	(* as (layered) pattern *)
	| AltPat    of pat_info * pat * pat	(* alternative pattern *)
	| NegPat    of pat_info * pat		(* negated pattern *)
	| GuardPat  of pat_info * pat * exp	(* guarded pattern *)
	| AnnPat    of pat_info * pat * typ	(* type annotation *)
	| WithPat   of pat_info * pat * dec vector (* local declarations *)

  (* Types *)

    and typ =
	  JokTyp    of typ_info			(* unspecified *)
	| VarTyp    of typ_info * varid		(* variable *)
	| PrimTyp   of typ_info * string	(* builtin type *)
	| ConTyp    of typ_info * typlongid	(* constructor *)
	| FunTyp    of typ_info * varid * typ	(* type function *)
	| AppTyp    of typ_info * typ * typ	(* constructor application *)
	| TupTyp    of typ_info * typ vector	(* tuple (cartesian) type *)
	| ProdTyp   of typ_info * typ row	(* product (record) type *)
	| SumTyp    of typ_info * typ row	(* sum type (datatype) *)
	| ArrTyp    of typ_info * typ * typ	(* arrow (function) type *)
	| AllTyp    of typ_info * varid * typ	(* universal quantification *)
	| ExTyp     of typ_info * varid * typ	(* existential quantification *)
	| SingTyp   of typ_info * vallongid	(* singleton type *)
	| AbsTyp    of typ_info * bool option * bool (* abstract type (eq?, ext?)*)

  (* Modules *)

    and mod =
	  VarMod    of mod_info * modlongid	(* module id *)
	| PrimMod   of mod_info * string * inf	(* builtin modules *)
	| StrMod    of mod_info * dec vector	(* structure *)
	| SelMod    of mod_info * modlab * mod	(* selection *)
	| FunMod    of mod_info * modid * inf * mod (* functor *)
	| AppMod    of mod_info * mod * mod	(* application *)
	| AnnMod    of mod_info * mod * inf	(* annotation *)
	| SealMod   of mod_info * mod * inf	(* sealing *)
	| LazyMod   of mod_info * mod		(* byneed evaluation *)
	| SpawnMod  of mod_info * mod		(* concurrent evaluation *)
	| LetMod    of mod_info * dec vector * mod (* let *)
	| UnpackMod of mod_info * exp * inf	(* package elimination *)

  (* Interfaces *)

    and inf =
	  TopInf    of inf_info			(* top interface *)
	| PrimInf   of inf_info * string	(* builtin interfaces *)
	| ConInf    of inf_info * inflongid	(* interface constructor *)
	| SigInf    of inf_info * spec vector	(* signature *)
	| FunInf    of inf_info * modid * inf * inf (* interface function *)
	| AppInf    of inf_info * inf * mod	(* interface application *)
	| InterInf  of inf_info * inf * inf	(* intersection *)
	| ArrInf    of inf_info * modid * inf * inf (* functor interface *)
	| LetInf    of inf_info * dec vector * inf (* let *)
	| SingInf   of inf_info * mod		(* singleton interface *)
	| AbsInf    of inf_info			(* abstract interface *)

  (* Declarations *)

    and dec =
	  FixDec    of dec_info * vallab * fix	(* fixity *)
	| ValDec    of dec_info * pat * exp	(* value *)
	| TypDec    of dec_info * typid * typ	(* type *)
	| ModDec    of dec_info * modid * mod	(* module *)
	| InfDec    of dec_info * infid * inf	(* interface *)
	| VarDec    of dec_info * varid * dec	(* scoped type variable *)
	| RecDec    of dec_info * dec vector	(* recursive declarations *)
	| LocalDec  of dec_info * dec vector	(* local declarations *)

  (* Specifications *)

    and spec =
	  FixSpec   of spec_info * vallab * fix	(* fixity *)
	| ValSpec   of spec_info * valid * typ	(* value *)
	| TypSpec   of spec_info * typid * typ	(* type *)
	| ModSpec   of spec_info * modid * inf	(* module *)
	| InfSpec   of spec_info * infid * inf	(* interface *)
	| RecSpec   of spec_info * spec vector	(* recursive specifications *)
	| ExtSpec   of spec_info * inf		(* extension (include) *)

  (* Import *)

    and imp =
	  FixImp    of imp_info * vallab * (fix_info,fix) desc	(* fixity *)
	| ValImp    of imp_info * valid * (typ_info,typ) desc	(* value *)
	| TypImp    of imp_info * typid * (typ_info,typ) desc	(* type *)
	| ModImp    of imp_info * modid * (inf_info,inf) desc	(* module *)
	| InfImp    of imp_info * infid * (inf_info,inf) desc	(* interface *)
	| RecImp    of imp_info * imp vector			(* recursive *)

    and ('info,'a) desc =
	  NoDesc   of 'info
	| SomeDesc of 'info * 'a

  (* Components *)

    and ann = ImpAnn of ann_info * imp vector * Url.t * bool

    and com = Com of com_info * ann vector * dec vector

    type t = com


  (* Projections *)

    fun stamp(Id(_,x,_))		= x
    fun name(Id(_,_,n))			= n
    fun lab(Lab(_,a))			= a

    fun longname(ShortId(_,id))		= name id
      | longname(LongId(_,_,l))		= Label.toName(lab l)

    fun infoLab(Lab(i,_))		= i
    fun infoId(Id(i,_,_))		= i
    fun infoLongid(ShortId(i,_))	= i
      | infoLongid(LongId(i,_,_))	= i

    fun infoExp(LitExp(i,_))		= i
      | infoExp(VarExp(i,_))		= i
      | infoExp(PrimExp(i,_,_))		= i
      | infoExp(NewExp(i,_))		= i
      | infoExp(TagExp(i,_,_))		= i
      | infoExp(ConExp(i,_,_))		= i
      | infoExp(RefExp(i,_))		= i
      | infoExp(RollExp(i,_,_))		= i
      | infoExp(StrictExp(i,_))		= i
      | infoExp(TupExp(i,_))		= i
      | infoExp(ProdExp(i,_))		= i
      | infoExp(SelExp(i,_,_))		= i
      | infoExp(VecExp(i,_))		= i
      | infoExp(FunExp(i,_))		= i
      | infoExp(AppExp(i,_,_))		= i
      | infoExp(AndExp(i,_,_))		= i
      | infoExp(OrExp(i,_,_))		= i
      | infoExp(IfExp(i,_,_,_))		= i
      | infoExp(SeqExp(i,_,_))		= i
      | infoExp(CaseExp(i,_,_))		= i
      | infoExp(LazyExp(i,_))		= i
      | infoExp(SpawnExp(i,_))		= i
      | infoExp(RaiseExp(i,_))		= i
      | infoExp(HandleExp(i,_,_))	= i
      | infoExp(FailExp(i))		= i
      | infoExp(AnnExp(i,_,_))		= i
      | infoExp(LetExp(i,_,_))		= i
      | infoExp(PackExp(i,_,_))		= i
      | infoExp(OverExp(i,_,_,_,_))	= i
      | infoExp(OverallExp(i,_,_,_))	= i

    fun infoRow(Row(i,_,_))		= i
    fun infoFld(Fld(i,_,_))		= i
    fun infoMat(Mat(i,_,_))		= i

    fun infoPat(JokPat(i))		= i
      | infoPat(LitPat(i,_))		= i
      | infoPat(VarPat(i,_))		= i
      | infoPat(TagPat(i,_,_))		= i
      | infoPat(ConPat(i,_,_))		= i
      | infoPat(RefPat(i,_))		= i
      | infoPat(RollPat(i,_,_))		= i
      | infoPat(StrictPat(i,_))		= i
      | infoPat(TupPat(i,_))		= i
      | infoPat(ProdPat(i,_))		= i
      | infoPat(VecPat(i,_))		= i
      | infoPat(AsPat(i,_,_))		= i
      | infoPat(AltPat(i,_,_))		= i
      | infoPat(NegPat(i,_))		= i
      | infoPat(GuardPat(i,_,_))	= i
      | infoPat(AnnPat(i,_,_))		= i
      | infoPat(WithPat(i,_,_))		= i

    fun infoTyp(JokTyp(i))		= i
      | infoTyp(VarTyp(i,_))		= i
      | infoTyp(PrimTyp(i,_))		= i
      | infoTyp(ConTyp(i,_))		= i
      | infoTyp(FunTyp(i,_,_))		= i
      | infoTyp(AppTyp(i,_,_))		= i
      | infoTyp(TupTyp(i,_))		= i
      | infoTyp(ProdTyp(i,_))		= i
      | infoTyp(SumTyp(i,_))		= i
      | infoTyp(ArrTyp(i,_,_))		= i
      | infoTyp(AllTyp(i,_,_))		= i
      | infoTyp(ExTyp(i,_,_))		= i
      | infoTyp(SingTyp(i,_))		= i
      | infoTyp(AbsTyp(i,_,_))		= i

    fun infoMod(VarMod(i,_))		= i
      | infoMod(PrimMod(i,_,_))		= i
      | infoMod(StrMod(i,_))		= i
      | infoMod(SelMod(i,_,_))		= i
      | infoMod(FunMod(i,_,_,_))	= i
      | infoMod(AppMod(i,_,_))		= i
      | infoMod(AnnMod(i,_,_))		= i
      | infoMod(SealMod(i,_,_))		= i
      | infoMod(LazyMod(i,_))		= i
      | infoMod(SpawnMod(i,_))		= i
      | infoMod(LetMod(i,_,_))		= i
      | infoMod(UnpackMod(i,_,_))	= i

    fun infoInf(TopInf(i))		= i
      | infoInf(PrimInf(i,_))		= i
      | infoInf(ConInf(i,_))		= i
      | infoInf(SigInf(i,_))		= i
      | infoInf(FunInf(i,_,_,_))	= i
      | infoInf(AppInf(i,_,_))		= i
      | infoInf(InterInf(i,_,_))	= i
      | infoInf(ArrInf(i,_,_,_))	= i
      | infoInf(LetInf(i,_,_))		= i
      | infoInf(SingInf(i,_))		= i
      | infoInf(AbsInf(i))		= i

    fun infoDec(FixDec(i,_,_))		= i
      | infoDec(ValDec(i,_,_))		= i
      | infoDec(TypDec(i,_,_))		= i
      | infoDec(ModDec(i,_,_))		= i
      | infoDec(InfDec(i,_,_))		= i
      | infoDec(VarDec(i,_,_))		= i
      | infoDec(RecDec(i,_))		= i
      | infoDec(LocalDec(i,_))		= i

    fun infoSpec(FixSpec(i,_,_))	= i
      | infoSpec(ValSpec(i,_,_))	= i
      | infoSpec(TypSpec(i,_,_))	= i
      | infoSpec(ModSpec(i,_,_))	= i
      | infoSpec(InfSpec(i,_,_))	= i
      | infoSpec(RecSpec(i,_))		= i
      | infoSpec(ExtSpec(i,_))		= i

    fun infoImp(FixImp(i,_,_))		= i
      | infoImp(ValImp(i,_,_))		= i
      | infoImp(TypImp(i,_,_))		= i
      | infoImp(ModImp(i,_,_))		= i
      | infoImp(InfImp(i,_,_))		= i
      | infoImp(RecImp(i,_))		= i

    fun infoAnn(ImpAnn(i,_,_,_))	= i

    fun infoDesc(NoDesc(i))		= i
      | infoDesc(SomeDesc(i,_))		= i

    fun infoCom(Com(i,_,_))		= i


  (* Valuability *)

    fun isValueRow isValueX ( Row(_, flds, xo)) =
	Vector.all (isValueFld isValueX) flds andalso
	(case xo of NONE => true | SOME x => isValueX x)
    and isValueFld isValueX ( Fld(_, _, x) )	= isValueX x

    fun isValue( LitExp _
	       | VarExp _
	       | PrimExp _
	       | NewExp _
	       | FunExp _
	       | FailExp _ )			= true
      | isValue( TagExp(_, _, exp)
	       | ConExp(_, _, exp)
	       | RollExp(_, exp, _)
	       | StrictExp(_, exp)
	       | SelExp(_, _, exp)
	       | RaiseExp(_, exp)
	       | LazyExp(_, exp)
	       | SpawnExp(_, exp)
	       | AnnExp(_, exp, _)
	       | OverallExp(_, exp, _, _) )	= isValue exp
      | isValue( TupExp(_, exps)
	       | VecExp(_, exps)
	       | OverExp(_, exps, _, _, _) )	= Vector.all isValue exps
      | isValue( ProdExp(_, exprow) )		= isValueRow isValue exprow
      | isValue( AndExp(_, exp1, exp2)
	       | OrExp(_, exp1, exp2)
	       | SeqExp(_, exp1, exp2) )	= isValue exp1 andalso
						  isValue exp2
      | isValue( IfExp(_, exp1, exp2, exp3) )	= isValue exp1 andalso
						  isValue exp2 andalso
						  isValue exp3
      | isValue( CaseExp(_, exp, mats)
	       | HandleExp(_, exp, mats) )	= isValue exp andalso
						  Vector.all isValueMat mats
      | isValue( RefExp _
	       | AppExp _
	       | LetExp _
	       | PackExp _ )			= false

    and isValueMat( Mat(_, pat, exp) )		= isValuePat pat andalso
						  isValue exp

    and isValuePat( JokPat _
		  | LitPat _
		  | VarPat _ )			= true
      | isValuePat( TagPat(_, _, pat)
		  | ConPat(_, _, pat)
		  | RefPat(_, pat)
		  | RollPat(_, pat, _)
		  | StrictPat(_, pat)
		  | NegPat(_, pat)
		  | AnnPat(_, pat, _) )		= isValuePat pat
      | isValuePat( TupPat(_, pats)
		  | VecPat(_, pats) )		= Vector.all isValuePat pats
      | isValuePat( ProdPat(_, patrow) )	= isValueRow isValuePat patrow
      | isValuePat( AsPat(_, pat1, pat2)
		  | AltPat(_, pat1, pat2) )	= isValuePat pat1 andalso
						  isValuePat pat2
      | isValuePat( GuardPat(_, pat, exp) )	= isValuePat pat andalso
						  isValue exp
      | isValuePat( WithPat _ )			= false


  (* Descriptive closedness *)

    fun hasDesc(FixImp(i,_,SomeDesc _))		= true
      | hasDesc(ValImp(i,_,SomeDesc _))		= true
      | hasDesc(TypImp(i,_,SomeDesc _))		= true
      | hasDesc(ModImp(i,_,SomeDesc _))		= true
      | hasDesc(InfImp(i,_,SomeDesc _))		= true
      | hasDesc(RecImp(i,imps))			= Vector.all hasDesc imps
      | hasDesc _				= false
end
