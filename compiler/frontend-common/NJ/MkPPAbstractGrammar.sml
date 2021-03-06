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
 *   $Revision: 1.28 $
 *)














functor MkPPAbstractGrammar(
	structure AbstractGrammar : ABSTRACT_GRAMMAR
	val ppFixInfo :       AbstractGrammar.fix_info -> PrettyPrint.doc
	val ppVallabInfo :    AbstractGrammar.vallab_info -> PrettyPrint.doc
	val ppTyplabInfo :    AbstractGrammar.typlab_info -> PrettyPrint.doc
	val ppModlabInfo :    AbstractGrammar.modlab_info -> PrettyPrint.doc
	val ppInflabInfo :    AbstractGrammar.inflab_info -> PrettyPrint.doc
	val ppValidInfo :     AbstractGrammar.valid_info  -> PrettyPrint.doc
	val ppTypidInfo :     AbstractGrammar.typid_info  -> PrettyPrint.doc
	val ppVaridInfo :     AbstractGrammar.varid_info  -> PrettyPrint.doc
	val ppModidInfo :     AbstractGrammar.modid_info  -> PrettyPrint.doc
	val ppInfidInfo :     AbstractGrammar.infid_info  -> PrettyPrint.doc
	val ppVallongidInfo : AbstractGrammar.vallongid_info -> PrettyPrint.doc
	val ppTyplongidInfo : AbstractGrammar.typlongid_info -> PrettyPrint.doc
	val ppModlongidInfo : AbstractGrammar.modlongid_info -> PrettyPrint.doc
	val ppInflongidInfo : AbstractGrammar.inflongid_info -> PrettyPrint.doc
	val ppExpInfo :       AbstractGrammar.exp_info -> PrettyPrint.doc
	val ppPatInfo :       AbstractGrammar.pat_info -> PrettyPrint.doc
	val ppRowInfo :       ('a -> PrettyPrint.doc) ->
			      'a AbstractGrammar.row_info -> PrettyPrint.doc
	val ppFldInfo :       ('a -> PrettyPrint.doc) ->
			      'a AbstractGrammar.fld_info -> PrettyPrint.doc
	val ppMatInfo :       AbstractGrammar.mat_info  -> PrettyPrint.doc
	val ppTypInfo :       AbstractGrammar.typ_info  -> PrettyPrint.doc
	val ppModInfo :       AbstractGrammar.mod_info  -> PrettyPrint.doc
	val ppInfInfo :       AbstractGrammar.inf_info  -> PrettyPrint.doc
	val ppDecInfo :       AbstractGrammar.dec_info  -> PrettyPrint.doc
	val ppSpecInfo :      AbstractGrammar.spec_info -> PrettyPrint.doc
	val ppImpInfo :       AbstractGrammar.imp_info  -> PrettyPrint.doc
	val ppAnnInfo :       AbstractGrammar.ann_info  -> PrettyPrint.doc
	val ppComInfo :       AbstractGrammar.com_info  -> PrettyPrint.doc
    ) : PP_ABSTRACT_GRAMMAR =
struct
  (* Import *)

    open AbstractGrammar
    open PrettyPrint
    open PPMisc

    infixr ^^ ^/^
    nonfix mod


  (* Semantic Objects *)

    fun ppLabel l		= text("\"" ^ Label.toString l ^ "\"")
    fun ppName n		= text("\"" ^ Name.toString n ^ "\"")
    fun ppStamp z		= text(Stamp.toString z)
    fun ppBool b		= text(Bool.toString b)
    fun ppString s		= text("\"" ^ s ^ "\"")
    fun ppUrl u			= text("\"" ^ Url.toStringRaw u ^ "\"")

    fun ppOption ppX (NONE)	= text "[]"
      | ppOption ppX (SOME x)	= ppX x

    fun ppFix(Fixity.NONFIX)	= text "NonFix"
      | ppFix(Fixity.PREFIX n)	= text("PreFix(" ^ Int.toString n ^ ")")
      | ppFix(Fixity.POSTFIX n)	= text("PostFix(" ^ Int.toString n ^ ")")
      | ppFix(Fixity.INFIX(n,a))= text("InFix(" ^ ppAssoc a ^ " "
				       ^ Int.toString n ^ ")")
    and ppAssoc(Fixity.LEFT)	= "Left"
      | ppAssoc(Fixity.RIGHT)	= "Right"
      | ppAssoc(Fixity.NEITHER)	= "Noassoc"


  (* Literals *)

    fun ppLit(IntLit n)		= text(LargeInt.toString n)
      | ppLit(WordLit w)	= text(LargeWord.toString w)
      | ppLit(CharLit c)	= text("#\"" ^ WideChar.toString c ^ "\"")
      | ppLit(StringLit s)	= text("\"" ^ WideString.toString s ^ "\"")
      | ppLit(RealLit r)	= text(LargeReal.toString r)


  (* Structured *)

    fun tree head info body =
	vbox(
	    abox(text head ^^ nest(break ^^ info)) ^^
	    nest(break ^^ body)
	)

    fun softtree head info body =
	abox(
	    abox(text head ^^ nest(break ^^ info)) ^^
	    nest(break ^^ body)
	)

    fun vec docs =
	let
	    val length = Vector.length docs - 1
	in
	    if length < 0
	    then text "[]"
	    else vec'(docs, length, Vector.sub(docs, length))
	end

    and vec'(docs, 0, doc) = doc
      | vec'(docs, i, doc) = vec'(docs, i-1, Vector.sub(docs, i-1) ^/^ doc)


  (* Fixity *)

    fun ppFix'(Fix(i, f))		= softtree "Fix" (ppFixInfo i) (
					    ppFix f
					  )
    val ppFix = ppFix'


  (* Identifiers *)

    fun ppLab ppInfo (Lab(i, l))	= softtree "Lab" (ppInfo i) (
					    ppLabel l
					  )

    fun ppId ppInfo (Id(i, z, n))	= softtree "Id" (ppInfo i) (
					    ppName n ^^
					    text "[" ^^ ppStamp z ^^ text "]"
					  )

    fun ppModlongid(ShortId(i, modid))	= softtree "ShortId" (ppModlongidInfo i)
					  (
					    ppId ppModidInfo modid
					  )
      | ppModlongid(LongId(i, modlongid, modlab))
					= softtree "LongId" (ppModlongidInfo i)
					  (
					    ppModlongid modlongid ^/^
					    ppLab ppModlabInfo modlab
					  )
    fun ppLongid (ppInfo,ppIdInfo,ppLabInfo)
    		 (ShortId(i, id))	= softtree "ShortId" (ppInfo i) (
					    ppId ppIdInfo id
					  )
      | ppLongid (ppInfos as (ppInfo,ppIdInfo,ppLabInfo))
		 (LongId(i, modlongid, lab))
					= softtree "LongId" (ppInfo i) (
					    ppModlongid modlongid ^/^
					    ppLab ppLabInfo lab
					  )

    val ppVallab	= ppLab ppVallabInfo
    val ppTyplab	= ppLab ppTyplabInfo
    val ppModlab	= ppLab ppModlabInfo
    val ppInflab	= ppLab ppInflabInfo
    val ppValid		= ppId ppValidInfo
    val ppTypid		= ppId ppTypidInfo
    fun ppVarid(id,_)	= ppId ppVaridInfo id
    val ppModid		= ppId ppModidInfo
    val ppInfid		= ppId ppInfidInfo
    val ppVallongid	= ppLongid(ppVallongidInfo, ppValidInfo, ppVallabInfo)
    val ppTyplongid	= ppLongid(ppTyplongidInfo, ppTypidInfo, ppTyplabInfo)
    val ppModlongid	= ppLongid(ppModlongidInfo, ppModidInfo, ppModlabInfo)
    val ppInflongid	= ppLongid(ppInflongidInfo, ppInfidInfo, ppInflabInfo)

    fun ppTyplongids xs	= vec(Vector.map ppTyplongid xs)


  (* Rows and Fields *)

    fun ppRow ppX (Row(i, flds, xo))	= tree "Row" (ppRowInfo ppX i) (
					    ppFlds ppX flds ^/^
					    ppOption ppX xo
					  )

    and ppFlds ppX flds			= vec(Vector.map (ppFld ppX) flds)
    and ppFld ppX (Fld(i,vallab,x))	= tree "Fld" (ppFldInfo ppX i) (
					    ppVallab vallab ^/^
					    ppX x
					  )

  (* Descriptions *)

    fun ppDesc (ppXInfo,ppX) (NoDesc(i))
					= softtree "NoDesc" (ppXInfo i) empty
      | ppDesc (ppXInfo,ppX) (SomeDesc(i, x))
					= softtree "SomeDesc"(ppXInfo i) (
					    ppX x
					  )

  (* Expressions *)

    fun exptree head i body		= tree (head ^ "Exp") (ppExpInfo i) body

    fun ppExps exps			= vec(Vector.map ppExp exps)
    and ppExp(LitExp(i, lit))		= exptree "Lit" i (
					    ppLit lit
					  )
      | ppExp(VarExp(i, vallongid))	= exptree "Var" i (
					    ppVallongid vallongid
					  )
      | ppExp(PrimExp(i, s, typ))	= exptree "Prim" i (
					    ppString s ^/^
					    ppTyp typ
					  )
      | ppExp(NewExp(i, typ))		= exptree "New" i (
					    ppTyp typ
					  )
      | ppExp(TagExp(i, vallab, exp))	= exptree "Tag" i (
					    ppVallab vallab ^/^
					    ppExp exp
					  )
      | ppExp(ConExp(i, vallongid,exp))	= exptree "Con" i (
					    ppVallongid vallongid ^/^
					    ppExp exp
					  )
      | ppExp(RefExp(i, exp))		= exptree "Ref" i (
					    ppExp exp
					  )
      | ppExp(RollExp(i, exp, typ))	= exptree "Roll" i (
					    ppExp exp ^/^
					    ppTyp typ
					  )
      | ppExp(StrictExp(i, exp))	= exptree "Strict" i (
					    ppExp exp
					  )
      | ppExp(TupExp(i, exps))		= exptree "Tup" i (
					    ppExps exps
					  )
      | ppExp(ProdExp(i, exprow))	= exptree "Prod" i (
					    ppRow ppExp exprow
					  )
      | ppExp(SelExp(i, vallab, exp))	= exptree "Sel" i (
					    ppVallab vallab ^/^
					    ppExp exp
					  )
      | ppExp(VecExp(i, exps))		= exptree "Vec" i (
					    ppExps exps
					  )
      | ppExp(FunExp(i, mats))		= exptree "Fun" i (
					    ppMats mats
					  )
      | ppExp(AppExp(i, exp1, exp2))	= exptree "App" i (
					    ppExp exp1 ^/^
					    ppExp exp2
					  )
      | ppExp(AndExp(i, exp1, exp2))	= exptree "And" i (
					    ppExp exp1 ^/^
					    ppExp exp2
					  )
      | ppExp(OrExp(i, exp1, exp2))	= exptree "Or" i (
					    ppExp exp1 ^/^
					    ppExp exp2
					  )
      | ppExp(IfExp(i, exp1,exp2,exp3))	= exptree "If" i (
					    ppExp exp1 ^/^
					    ppExp exp2 ^/^
					    ppExp exp3
					  )
      | ppExp(SeqExp(i, exp1, exp2))	= exptree "Seq" i (
					    ppExp exp1 ^/^
					    ppExp exp2
					  )
      | ppExp(CaseExp(i, exp, mats))	= exptree "Case" i (
					    ppExp exp ^/^
					    ppMats mats
					  )
      | ppExp(HandleExp(i, exp, mats))	= exptree "Handle" i (
					    ppExp exp ^/^
					    ppMats mats
					  )
      | ppExp(RaiseExp(i, exp))		= exptree "Raise" i (
					    ppExp exp
					  )
      | ppExp(LazyExp(i, exp))		= exptree "Lazy" i (
					    ppExp exp
					  )
      | ppExp(SpawnExp(i, exp))		= exptree "Spawn" i (
					    ppExp exp
					  )
      | ppExp(FailExp(i))		= exptree "Fail" i empty
      | ppExp(AnnExp(i, exp, typ))	= exptree "Ann" i (
					    ppExp exp ^/^
					    ppTyp typ
					  )
      | ppExp(LetExp(i, decs, exp))	= exptree "Let" i (
					    ppDecs decs ^/^
					    ppExp exp
					  )
      | ppExp(PackExp(i, mod, inf))	= exptree "Pack" i (
					    ppMod mod ^/^
					    ppInf inf
					  )
      | ppExp(OverExp(i, exps, varid, typlongids, typ))
 					= exptree "Over" i (
					    ppExps exps ^/^
					    ppVarid varid ^/^
					    ppTyplongids typlongids ^/^
					    ppTyp typ
					  )
      | ppExp(OverallExp(i, exp, varid, typ))
 					= exptree "Overall" i (
					    ppExp exp ^/^
					    ppVarid varid ^/^
					    ppTyp typ
					  )

    and ppMats mats			= vec(Vector.map ppMat mats)
    and ppMat(Mat(i, pat, exp))		= tree "Mat" (ppMatInfo i) (
					    ppPat pat ^/^
					    ppExp exp
					  )

  (* Patterns *)

    and pattree head i body		= tree (head ^ "Pat") (ppPatInfo i) body

    and ppPats pats			= vec(Vector.map ppPat pats)
    and ppPat(JokPat(i))		= pattree "Jok" i empty
      | ppPat(LitPat(i, lit))		= pattree "Lit" i (
					    ppLit lit
					  )
      | ppPat(VarPat(i, valid))		= pattree "Var" i (
					    ppValid valid
					  )
      | ppPat(TagPat(i, vallab, pat))	= pattree "Tag" i (
					    ppVallab vallab ^/^
					    ppPat pat
					  )
      | ppPat(ConPat(i, vallongid,pat))	= pattree "Con" i (
					    ppVallongid vallongid ^/^
					    ppPat pat
					  )
      | ppPat(RefPat(i, pat))		= pattree "Ref" i (
					    ppPat pat
					  )
      | ppPat(RollPat(i, pat, typ))	= pattree "Roll" i (
					    ppPat pat ^/^
					    ppTyp typ
					  )
      | ppPat(StrictPat(i, pat))	= pattree "Strict" i (
					    ppPat pat
					  )
      | ppPat(TupPat(i, pats))		= pattree "Tup" i (
					    ppPats pats
					  )
      | ppPat(ProdPat(i, patrow))	= pattree "Prod" i (
					    ppRow ppPat patrow
					  )
      | ppPat(VecPat(i, pats))		= pattree "Vec" i (
					    ppPats pats
					  )
      | ppPat(AsPat(i, pat1, pat2))	= pattree "As" i (
					    ppPat pat1 ^/^
					    ppPat pat2
					  )
      | ppPat(AltPat(i, pat1, pat2))	= pattree "Alt" i (
					    ppPat pat1 ^/^
					    ppPat pat2
					  )
      | ppPat(NegPat(i, pat))		= pattree "Neg" i (
					    ppPat pat
					  )
      | ppPat(GuardPat(i, pat, exp))	= pattree "Guard" i (
					    ppPat pat ^/^
					    ppExp exp
					  )
      | ppPat(AnnPat(i, pat, typ))	= pattree "Ann" i (
					    ppPat pat ^/^
					    ppTyp typ
					  )
      | ppPat(WithPat(i, pat, decs))	= pattree "With" i (
					    ppPat pat ^/^
					    ppDecs decs
					  )

  (* Types *)

    and typtree head i body		= tree (head ^ "Typ") (ppTypInfo i) body

    and ppTyps typs			= vec(Vector.map ppTyp typs)
    and ppTyp(JokTyp(i))		= typtree "Jok" i empty
      | ppTyp(VarTyp(i, varid))		= typtree "Var" i (
					    ppVarid varid
					  )
      | ppTyp(PrimTyp(i, s))		= typtree "Prim" i (
					    ppString s
					  )
      | ppTyp(ConTyp(i, typlongid))	= typtree "Con" i (
					    ppTyplongid typlongid
					  )
      | ppTyp(FunTyp(i, varid, typ))	= typtree "Fun" i (
					    ppVarid varid ^/^
					    ppTyp typ
					  )
      | ppTyp(AppTyp(i, typ1, typ2))	= typtree "App" i (
					    ppTyp typ1 ^/^
					    ppTyp typ2
					  )
      | ppTyp(TupTyp(i, typs))		= typtree "Tup" i (
					    ppTyps typs
					  )
      | ppTyp(ProdTyp(i, typrow))	= typtree "Prod" i (
					    ppRow ppTyp typrow
					  )
      | ppTyp(SumTyp(i, typrow))	= typtree "Sum" i (
					    ppRow ppTyp typrow
					  )
      | ppTyp(ArrTyp(i, typ1, typ2))	= typtree "Arr" i (
					    ppTyp typ1 ^/^
					    ppTyp typ2
					  )
      | ppTyp(AllTyp(i, varid, typ))	= typtree "All" i (
					    ppVarid varid ^/^
					    ppTyp typ
					  )
      | ppTyp(ExTyp(i, varid, typ))	= typtree "Ex" i (
					    ppVarid varid ^/^
					    ppTyp typ
					  )
      | ppTyp(SingTyp(i, vallongid))	= typtree "Sing" i (
					    ppVallongid vallongid
					  )
      | ppTyp(AbsTyp(i, eq, b))		= typtree "Abs" i (
					    ppOption ppBool eq ^/^
					    ppBool b
					  )

  (* Modules *)

    and modtree head i body		= tree (head ^ "Mod") (ppModInfo i) body

    and ppMods mods			= vec(Vector.map ppMod mods)
    and ppMod(VarMod(i, modlongid))	= modtree "Var" i (
					    ppModlongid modlongid
					  )
      | ppMod(PrimMod(i, s, inf))	= modtree "Prim" i (
					    ppString s ^/^
					    ppInf inf
					  )
      | ppMod(StrMod(i, decs))		= modtree "Str" i (
					    ppDecs decs
					  )
      | ppMod(SelMod(i, modlab, mod))	= modtree "Sel" i (
					    ppModlab modlab ^/^
					    ppMod mod
					  )
      | ppMod(FunMod(i, modid,inf,mod))	= modtree "Fun" i (
					    ppModid modid ^/^
					    ppInf inf ^/^
					    ppMod mod
					  )
      | ppMod(AppMod(i, mod1, mod2))	= modtree "App" i (
					    ppMod mod1 ^/^
					    ppMod mod2
					  )
      | ppMod(AnnMod(i, mod, inf))	= modtree "Ann" i (
					    ppMod mod ^/^
					    ppInf inf
					  )
      | ppMod(SealMod(i, mod, inf))	= modtree "Seal" i (
					    ppMod mod ^/^
					    ppInf inf
					  )
      | ppMod(LazyMod(i, mod))		= modtree "Lazy" i (
					    ppMod mod
					  )
      | ppMod(SpawnMod(i, mod))		= modtree "Spawn" i (
					    ppMod mod
					  )
      | ppMod(LetMod(i, decs, mod))	= modtree "Let" i (
					    ppDecs decs ^/^
					    ppMod mod
					  )
      | ppMod(UnpackMod(i, exp, inf))	= modtree "Unpack" i (
					    ppExp exp ^/^
					    ppInf inf
					  )

  (* Interfaces *)

    and inftree head i body		= tree (head ^ "Inf") (ppInfInfo i) body

    and ppInfs infs			= vec(Vector.map ppInf infs)
    and ppInf(TopInf(i))		= inftree "Top" i empty
      | ppInf(PrimInf(i, s))		= inftree "Prim" i (
					    ppString s
					  )
      | ppInf(ConInf(i, inflongid))	= inftree "Con" i (
					    ppInflongid inflongid
					  )
      | ppInf(SigInf(i, specs))		= inftree "Sig" i (
					    ppSpecs specs
					  )
      | ppInf(FunInf(i, modid, inf1, inf2))
					= inftree "Fun" i (
					    ppModid modid ^/^
					    ppInf inf1 ^/^
					    ppInf inf2
					  )
      | ppInf(AppInf(i, inf, mod))	= inftree "Fun" i (
					    ppInf inf ^/^
					    ppMod mod
					  )
      | ppInf(InterInf(i, inf1, inf2))	= inftree "Inter" i (
					    ppInf inf1 ^/^
					    ppInf inf2
					  )
      | ppInf(ArrInf(i, modid, inf1, inf2))
					= inftree "Arr" i (
					    ppModid modid ^/^
					    ppInf inf1 ^/^
					    ppInf inf2
					  )
      | ppInf(LetInf(i, decs, inf))	= inftree "Let" i (
					    ppDecs decs ^/^
					    ppInf inf
					  )
      | ppInf(SingInf(i, mod))		= inftree "Sing" i (
					    ppMod mod
					  )
      | ppInf(AbsInf(i))		= inftree "Abs" i empty


  (* Declarations *)

    and dectree head i body		= tree (head ^ "Dec") (ppDecInfo i) body

    and ppDecs decs			= vec(Vector.map ppDec decs)
    and ppDec(FixDec(i, vallab, fix))	= dectree "Fix" i (
					    ppVallab vallab ^/^
					    ppFix fix
					  )
      | ppDec(ValDec(i, pat, exp))	= dectree "Val" i (
					    ppPat pat ^/^
					    ppExp exp
					  )
      | ppDec(TypDec(i, typid, typ))	= dectree "Typ" i (
					    ppTypid typid ^/^
					    ppTyp typ
					  )
      | ppDec(ModDec(i, modid, mod))	= dectree "Mod" i (
					    ppModid modid ^/^
					    ppMod mod
					  )
      | ppDec(InfDec(i, infid, inf))	= dectree "Inf" i (
					    ppInfid infid ^/^
					    ppInf inf
					  )
      | ppDec(VarDec(i, varid, dec))	= dectree "Var" i (
					    ppVarid varid ^/^
					    ppDec dec
					  )
      | ppDec(RecDec(i, decs))		= dectree "Rec" i (
					    ppDecs decs
					  )
      | ppDec(LocalDec(i, decs))	= dectree "Local" i (
					    ppDecs decs
					  )

  (* Specifications *)

    and spectree head i body		= tree (head ^ "Spec") (ppSpecInfo i)
						body
    and ppSpecs specs			= vec(Vector.map ppSpec specs)
    and ppSpec(FixSpec(i, vallab, fix))	= spectree "Fix" i (
					    ppVallab vallab ^/^
					    ppFix fix
					  )
      | ppSpec(ValSpec(i, valid, typ))	= spectree "Val" i (
					    ppValid valid ^/^
					    ppTyp typ
					  )
      | ppSpec(TypSpec(i, typid, typ))	= spectree "Typ" i (
					    ppTypid typid ^/^
					    ppTyp typ
					  )
      | ppSpec(ModSpec(i, modid, inf))	= spectree "Mod" i (
					    ppModid modid ^/^
					    ppInf inf
					  )
      | ppSpec(InfSpec(i, infid, inf))	= spectree "Inf" i (
					    ppInfid infid ^/^
					    ppInf inf
					  )
      | ppSpec(RecSpec(i, specs))	= spectree "Rec" i (
					    ppSpecs specs
					  )
      | ppSpec(ExtSpec(i, inf))		= spectree "Ext" i (
					    ppInf inf
					  )

  (* Imports *)

    and imptree head i body		= tree (head ^ "Imp") (ppImpInfo i) body

    and ppImps imps			= vec(Vector.map ppImp imps)
    and ppImp(FixImp(i,vallab,fixdesc))	= imptree "Fix" i (
					    ppVallab vallab ^/^
					    ppDesc (ppFixInfo,ppFix) fixdesc
					  )
      | ppImp(ValImp(i, valid,typdesc))	= imptree "Val" i (
					    ppValid valid ^/^
					    ppDesc (ppTypInfo,ppTyp) typdesc
					  )
      | ppImp(TypImp(i, typid,typdesc))	= imptree "Typ" i (
					    ppTypid typid ^/^
					    ppDesc (ppTypInfo,ppTyp) typdesc
					  )
      | ppImp(ModImp(i, modid,infdesc))	= imptree "Mod" i (
					    ppModid modid ^/^
					    ppDesc (ppInfInfo,ppInf) infdesc
					  )
      | ppImp(InfImp(i, infid,infdesc))	= imptree "Inf" i (
					    ppInfid infid ^/^
					    ppDesc (ppInfInfo,ppInf) infdesc
					  )
      | ppImp(RecImp(i, imps))		= imptree "Rec" i (
					    ppImps imps
					  )

  (* Components *)

    fun anntree head i body		= tree (head ^ "Ann") (ppAnnInfo i) body

    fun ppAnns anns			= vec(Vector.map ppAnn anns)
    and ppAnn(ImpAnn(i, imps, url, b))	= anntree "Imp" i (
					    ppBool b ^/^
					    ppUrl url ^/^
					    ppImps imps
					  )

    fun ppCom(Com(i, anns, decs))	= tree "Com" (ppComInfo i) (
					    ppAnns anns ^/^
					    ppDecs decs
					  ) ^^ break
end
