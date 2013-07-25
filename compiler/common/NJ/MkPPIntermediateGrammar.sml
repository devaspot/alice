val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:17:20 $ by $Author: rossberg $
 *   $Revision: 1.19 $
 *)











functor MkPPIntermediateGrammar(
	structure IntermediateGrammar : INTERMEDIATE_GRAMMAR
	val ppLabInfo :    IntermediateGrammar.lab_info -> PrettyPrint.doc
	val ppIdInfo :     IntermediateGrammar.id_info -> PrettyPrint.doc
	val ppLongidInfo : IntermediateGrammar.longid_info -> PrettyPrint.doc
	val ppExpInfo :    IntermediateGrammar.exp_info -> PrettyPrint.doc
	val ppPatInfo :    IntermediateGrammar.pat_info -> PrettyPrint.doc
	val ppFldInfo :    ('a -> PrettyPrint.doc) ->
			   'a IntermediateGrammar.fld_info -> PrettyPrint.doc
	val ppMatInfo :    IntermediateGrammar.mat_info -> PrettyPrint.doc
	val ppDecInfo :    IntermediateGrammar.dec_info -> PrettyPrint.doc
	val ppSig :        IntermediateGrammar.sign -> PrettyPrint.doc
    ) : PP_INTERMEDIATE_GRAMMAR =
struct

  (* Import *)

    open IntermediateGrammar
    open PrettyPrint
    open PPMisc

    infixr ^^ ^/^


  (* Semantic Objects *)

    fun ppLabel l	= text("\"" ^ Label.toString l ^ "\"")
    fun ppName n	= text("\"" ^ Name.toString n ^ "\"")
    fun ppStamp z	= text(Stamp.toString z)
    fun ppString s	= text("\"" ^ s ^ "\"")
    fun ppBool b	= text(Bool.toString b)


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


  (* Identifiers *)

    fun ppLab(Lab(i, l))		= softtree "Lab" (ppLabInfo i) (
					    ppLabel l
					  )

    fun ppId(Id(i, z, n))		= softtree "Id" (ppIdInfo i) (
					    ppName n ^^
					    text "[" ^^ ppStamp z ^^ text "]"
					  )

    fun ppLongid(ShortId(i, id))	= softtree "ShortId" (ppLongidInfo i) (
					    ppId id
					  )
      | ppLongid(LongId(i, longid,lab))	= softtree "LongId" (ppLongidInfo i) (
					    ppLongid longid ^/^
					    ppLab lab
					  )

  (* Fields *)

    fun ppFlds ppX flds			= vec(Vector.map (ppFld ppX) flds)
    and ppFld ppX (Fld(i, lab, x))	= tree "Fld" (ppFldInfo ppX i) (
					    ppLab lab ^/^
					    ppX x
					  )

  (* Expressions *)

    fun exptree head i body		= tree (head ^ "Exp") (ppExpInfo i) body

    fun ppExps exps			= vec(Vector.map ppExp exps)
    and ppExp(LitExp(i, lit))		= exptree "Lit" i (
					    ppLit lit
					  )
      | ppExp(VarExp(i, longid))	= exptree "Var" i (
					    ppLongid longid
					  )
      | ppExp(PrimExp(i, s))		= exptree "Prim" i (
					    ppString s
					  )
      | ppExp(ImmExp(i, v))		= exptree "Imm" i (
					    text "_"
					  )
      | ppExp(NewExp(i))		= exptree "New" i empty
      | ppExp(TagExp(i, lab, exp))	= exptree "Tag" i (
					    ppLab lab ^/^
					    ppExp exp
					  )
      | ppExp(ConExp(i, longid, exp))	= exptree "Con" i (
					    ppLongid longid ^/^
					    ppExp exp
					  )
      | ppExp(RefExp(i, exp))		= exptree "Ref" i (
					    ppExp exp
					  )
      | ppExp(RollExp(i, exp))		= exptree "Roll" i (
					    ppExp exp
					  )
      | ppExp(StrictExp(i, exp))	= exptree "Strict" i (
					    ppExp exp
					  )
      | ppExp(TupExp(i, exps))		= exptree "Tup" i (
					    ppExps exps
					  )
      | ppExp(ProdExp(i, flds))		= exptree "Prod" i (
					    ppFlds ppExp flds
					  )
      | ppExp(SelExp(i, lab, exp))	= exptree "Sel" i (
					    ppLab lab ^/^
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
      | ppExp(RaiseExp(i, exp))		= exptree "Raise" i (
					    ppExp exp
					  )
      | ppExp(HandleExp(i, exp, mats))	= exptree "Handle" i (
					    ppExp exp ^/^
					    ppMats mats
					  )
      | ppExp(FailExp(i))		= exptree "Fail" i empty
      | ppExp(LazyExp(i, exp))		= exptree "Lazy" i (
					    ppExp exp
					  )
      | ppExp(SpawnExp(i, exp))		= exptree "Spawn" i (
					    ppExp exp
					  )
      | ppExp(LetExp(i, decs, exp))	= exptree "Let" i (
					    ppDecs decs ^/^
					    ppExp exp
					  )
      | ppExp(SealExp(i, exp))		= exptree "Seal" i (
					    ppExp exp
					  )
      | ppExp(UnsealExp(i, exp))	= exptree "Unseal" i (
					    ppExp exp
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
      | ppPat(VarPat(i, id))		= pattree "Var" i (
					    ppId id
					  )
      | ppPat(TagPat(i, lab, pat))	= pattree "Tag" i (
					    ppLab lab ^/^
					    ppPat pat
					  )
      | ppPat(ConPat(i, longid, pat))	= pattree "Con" i (
					    ppLongid longid ^/^
					    ppPat pat
					  )
      | ppPat(RefPat(i, pat))		= pattree "Ref" i (
					    ppPat pat
					  )
      | ppPat(RollPat(i, pat))		= pattree "Roll" i (
					    ppPat pat
					  )
      | ppPat(StrictPat(i, pat))	= pattree "Strict" i (
					    ppPat pat
					  )
      | ppPat(TupPat(i, pats))		= pattree "Tup" i (
					    ppPats pats
					  )
      | ppPat(ProdPat(i, flds))		= pattree "Prod" i (
					    ppFlds ppPat flds
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
      | ppPat(WithPat(i, pat, decs))	= pattree "With" i (
					    ppPat pat ^/^
					    ppDecs decs
					  )

  (* Declarations *)

    and dectree head i body		= tree (head ^ "Dec") (ppDecInfo i) body

    and ppDecs decs			= vec(Vector.map ppDec decs)
    and ppDec(ValDec(i, pat, exp))	= dectree "Val" i (
					    ppPat pat ^/^
					    ppExp exp
					  )
      | ppDec(RecDec(i, decs))		= dectree "Rec" i (
					    ppDecs decs
					  )

  (* Components *)

    fun ppCom (_, decs, flds, _)	= ppDecs decs ^/^ ppFlds ppId flds
					  ^^ break

end
