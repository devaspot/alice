val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-02-18 12:55:59 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)























(*DEBUG



*)

structure IntermediateCons : INTERMEDIATE_CONS =
struct
    open PervasiveType
    open InfLib
    open TypeLib
    open PervasiveTypeLib
    open PathLib
    open LabelLib
    open FixityLib
    open TypeTranslation

    open IntermediateGrammar
    open IntermediateInfo
    open TypedInfo
    nonfix mod

  (* Accessors *)

    fun regionOfId id         = #region(infoId id)
    fun regionOfLongid longid = #region(infoLongid longid)
    fun regionOfExp exp       = #region(infoExp exp)
    fun regionOfPat pat       = #region(infoPat pat)

    fun typOfId id            = #typ(infoId id)
    fun typOfLongid longid    = #typ(infoLongid longid)
    fun typOfExp exp          = #typ(infoExp exp)
    fun typOfPat pat          = #typ(infoPat pat)

  (* General expressions *)

    fun auxId i    = Id(i, Stamp.stamp(), Name.InId)
    fun shortId id = ShortId(infoId id, id)

    fun lazyExp exp        = LazyExp(infoExp exp, exp)
    fun seqExp(exp1, exp2) = SeqExp(infoExp exp2, exp1, exp2)
    fun letExp(decs, exp)  = LetExp(infoExp exp, decs, exp)
    fun strictExp exp =
	StrictExp(typInfo(regionOfExp exp, Type.apply(typ_strict, typOfExp exp)),
		  exp)
    fun strictPat pat =
	StrictPat(typInfo(regionOfPat pat, Type.apply(typ_strict, typOfPat pat)),
		  pat)

    fun stringExp(r, s) =
	LitExp(typInfo(r, typ_string), StringLit(String.toWide s))
    fun intExp(r, n) =
	LitExp(typInfo(r, typ_int), IntLit(Int.toLarge n))
    fun unitExp r =
	TupExp(typInfo(r, typ_unit), #[])
    fun tupExp(r, exps) =
	TupExp(typInfo(r, Type.tuple(Vector.map typOfExp exps)), exps)
    fun vecExp(r, t, exps) =
	VecExp(typInfo(r, Type.apply(typ_vec, t)), exps)
    fun unitPat r =
	TupPat(typInfo(r, typ_unit), #[])
    fun tupPat(r, pats) =
	TupPat(typInfo(r, Type.tuple(Vector.map typOfPat pats)), pats)

    fun fld(r, l, xxx) = Fld(nonInfo r, Lab(nonInfo r, l), xxx)
    fun selExp(r, n, exp) =
	SelExp(typInfo(r, Vector.sub(Type.asTuple(typOfExp exp), n-1)),
	       Lab(nonInfo r, Label.fromInt n), exp)

    fun idLab(Id(i, _, n)) =
	Lab(nonInfo(#region i), Label.fromName n)
    fun idFld idXxx id =
	Fld(nonInfo(regionOfId id), idLab id, idXxx id)
    fun idExp id =
	let
	    val i = infoId id
	in
	    VarExp(i, ShortId(i, id))
	end
    fun idPat id = VarPat(infoId id, id)
    fun longidExp longid = VarExp(infoLongid longid, longid)

    fun auxDec(id, exp) =
	ValDec(origInfo(regionOfId id, Aux), idPat id, exp)
    fun expDec exp =
	ValDec(origInfo(regionOfExp exp, Aux), JokPat(infoExp exp), exp)
    fun idDec(longid, id) =
	auxDec(id, VarExp(infoId id, LongId(infoId id, longid, idLab id)))

    fun idUnsealDec(longid, id) =
	let
	    val i = infoLongid longid
	    val t = Type.lookupRow(Type.asProd(#typ i), lab(idLab id))
(*DEBUG
handle Type.Row =>
(print("idUnsealDec: did not find field " ^ Label.toString(lab(idLab id)) ^ "\nt = ");
 PrettyPrint.output(TextIO.stdOut, PPType.ppTyp(#typ i), 76);
 print "\n";
 raise Type.Row)
*)
	    val i' = typInfo(#region i, t)
	in
	    auxDec(id, UnsealExp(infoId id,
				 VarExp(i', LongId(i', longid, idLab id))))
	end
	handle (Type.Type | Type.Row) => idDec(longid, id)
	    (* Type for import of __pervasive, Row for interactive toplevel *)


  (* RTT expressions *)

    val modlab_rtt' = LabelTranslation.trModLabel modlab_rtt

    fun pathId(env, r) = Id(typInfo(r, typ_path env), Stamp.stamp(), Name.InId)
    fun typId(env, r)  = Id(typInfo(r, typ_typ env), Stamp.stamp(), Name.InId)
    fun infId(env, r)  = Id(typInfo(r, typ_inf env), Stamp.stamp(), Name.InId)

    (* __pervasive.RTT.modlab.lab *)
    fun rttExp(env, r, modlab, lab) =
	let
	    val modlab' = LabelTranslation.trModLabel modlab
	    val lab'    = LabelTranslation.trValLabel lab
	    val longid0 = TranslationEnv.lookupPervasive' env
	    val t0      = typOfLongid longid0
	    val t1      = Type.lookupRow(Type.asProd t0, modlab_rtt')
	    val t2      = Type.lookupRow(Type.asProd t1, modlab')
	    val t3      = Type.lookupRow(Type.asProd t2, lab')
	    val longid1 = LongId(typInfo(r,t1), longid0, Lab(nonInfo r,modlab_rtt'))
	    val longid2 = LongId(typInfo(r,t2), longid1, Lab(nonInfo r,modlab'))
	    val longid3 = LongId(typInfo(r,t3), longid2, Lab(nonInfo r,lab'))
	in
	    VarExp(typInfo(r,t3), longid3)
	end

    (* __pervasive.RTT.modlab.lab exp *)
    fun rttAppExp(env, r, modlab, lab, exp) =
	let
	    val exp1    = rttExp(env, r, modlab, lab)
	    val t1      = typOfExp exp1
	    val (t2,t3) = Type.asArrow t1
	in
	    (*assert (Type.equal(t2, typOfExp exp));*)
	    (* violated in Pervasive.aml, hence we need a seal cast *)
	    AppExp(typInfo(r,t3), exp1, SealExp(typInfo(r,t2), exp))
	end

    fun assocExp(env, r, Fixity.LEFT) =
	rttExp(env, r, modlab_fixity, lab_left)
      | assocExp(env, r, Fixity.RIGHT) =
	rttExp(env, r, modlab_fixity, lab_right)
      | assocExp(env, r, Fixity.NEITHER) =
	rttExp(env, r, modlab_fixity, lab_neither)

    fun fixExp(env, r, Fixity.NONFIX) =
	rttExp(env, r, modlab_fixity, lab_nonfix)
      | fixExp(env, r, Fixity.PREFIX n) =
	rttAppExp(env, r, modlab_fixity, lab_prefix, intExp(r, n))
      | fixExp(env, r, Fixity.POSTFIX n) =
	rttAppExp(env, r, modlab_fixity, lab_postfix, intExp(r, n))
      | fixExp(env, r, Fixity.INFIX(n,a)) =
	rttAppExp(env, r, modlab_fixity, lab_infix,
		  tupExp(r, #[intExp(r, n), assocExp(env, r, a)]))

    fun unconstrainedExp(env, r) =
	rttExp(env, r, modlab_type, lab_unconstrained)

    fun labExp(env, r, l) =
	rttAppExp(env, r, modlab_label, lab_fromString,
		  stringExp(r, Label.toString l))
    fun pathExp(env, r, n) =
	rttAppExp(env, r, modlab_path, lab_fromString,
		  stringExp(r, Name.toString n))
    fun pathInventExp(env, r) =
	rttAppExp(env, r, modlab_path, lab_invent, unitExp r)

    fun kindExp(env, r, k) =
	case Type.inspectKind k
	 of Type.StarKind =>
	    rttAppExp(env, r, modlab_type, lab_starKind, unitExp r)
	  | Type.ExtKind =>
	    rttAppExp(env, r, modlab_type, lab_extKind, unitExp r)
	  | Type.EqKind k1 =>
	    let
		val exp = kindExp(env, r, k1)
	    in
		rttAppExp(env, r, modlab_type, lab_eqKind, exp)
	    end
	  | Type.ArrowKind(k1, k2) =>
	    let
		val exp1 = kindExp(env, r, k1)
		val exp2 = kindExp(env, r, k2)
	    in
		rttAppExp(env, r, modlab_type, lab_arrowKind,
			  tupExp(r, #[exp1,exp2]))
	    end
	  | Type.SingKind _ => raise Domain		(*TODO*)

    fun pervTypExp(env, r, s) =
	rttAppExp(env, r, modlab_pervasiveType, lab_lookup, stringExp(r, s))
    fun pervInfExp(env, r, s) =
	raise Fail "TranslationPhase.pervInfExp: primitive interface"

    fun typExp(env, lab, exp) =
	rttAppExp(env, regionOfExp exp, modlab_type, lab, exp)
    fun infExp(env, lab, exp) =
	rttAppExp(env, regionOfExp exp, modlab_inf, lab, exp)
end
