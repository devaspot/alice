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
 *   $Revision: 1.53 $
 *)








signature ABSTRACT_GRAMMAR =
sig
  (* Generic info *)

    type fix_info
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
	| LazyExp   of exp_info * exp		(* byneed evaluation *)
	| SpawnExp  of exp_info * exp		(* concurrent evaulation *)
	| HandleExp of exp_info * exp * mat vector (* exception handling *)
	| RaiseExp  of exp_info * exp		(* exception raising *)
	| FailExp   of exp_info			(* failure *)
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


  (* Operations *)

    val isValue :	exp			-> bool
    val hasDesc :	imp			-> bool

    val stamp :		'a id			-> Stamp.t
    val name :		'a id			-> Name.t
    val longname :	('a,'b,'c) longid	-> Name.t
    val lab :		'a lab			-> Label.t

    val infoLab :	'a lab			-> 'a
    val infoId :	'a id			-> 'a
    val infoLongid :	('a,'b,'c) longid	-> 'a
    val infoExp :	exp			-> exp_info
    val infoRow :	'a row			-> 'a row_info
    val infoFld :	'a fld			-> 'a fld_info
    val infoMat :	mat			-> mat_info
    val infoPat :	pat			-> pat_info
    val infoTyp :	typ			-> typ_info
    val infoMod :	mod			-> mod_info
    val infoInf :	inf			-> inf_info
    val infoDec :	dec			-> dec_info
    val infoSpec :	spec			-> spec_info
    val infoImp :	imp			-> imp_info
    val infoAnn :	ann			-> ann_info
    val infoDesc :	('a,'b) desc		-> 'a
    val infoCom :	com			-> com_info
end
