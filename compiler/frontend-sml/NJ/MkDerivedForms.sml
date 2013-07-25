val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-07 18:11:43 $ by $Author: rossberg $
 *   $Revision: 1.20 $
 *)

(*
 * Standard ML derived forms
 *
 * Definition, Appendix A
 *
 * Extensions and modifications:
 *   - predefined ids are taken out of a pseudo structure __pervasive
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
 *	assert<d> exp raise pat        ==>  assert ((exp; false) handle pat => true | _ => false) do ()
 *   - exception declarations have been made a derived form:
 *	exception exbind          ==>  constructor exbind'
 *	vid <of ty> <and exbind>  ==>  vid <of ty> : exn <and exbind'>
 *   - do declarations:
 *      do exp  ==>  val _ : {} = exp
 *   - generalised open declarations:
 *      open strexp  ==>  local structure strid = strexp in open strid end
 *   - derived form for function declarations extended with lazy/spawn keyword:
 *      lazy <op> vid atpat11 ... atpat1n <: ty1> = exp1 | ...
 *        ==>
 *      <op> vid = lazy (fn vid1 => ... fn vidn => case (vid1,...,vidn) of ...)
 *
 *      spawn <op> vid atpat11 ... atpat1n <: ty1> = exp1 | ...
 *        ==>
 *      <op> vid = spawn (fn vid1 => ... fn vidn => case (vid1,...,vidn) of ...)
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
 * - In Fvalbinds we do not enforce that all optional type annotations are
 *   syntactically identical (as the Definition enforces, although this seems
 *   to be a mistake).
 * - The Definition is somewhat inaccurate about the derived forms of Exp
 *   [Definition, Appendix A, Figure 15] in that most forms are actually AtExp
 *   derived forms, as can be seen from the full grammar [Definition,
 *   Appendix B, Figure 20]. To achieve consistency, the equivalent forms must
 *   be put in parentheses in some case.
 * - The same goes for pattern derived forms [Definition, Appendix A, Figure 16;
 *   Appendix B, Figure 22].
 *)

(* Add post conditions?
do exp1 assert pat => exp2   ==>   case exp1 of x as pat where exp2 => x | _ => raise Assert(_file_,_line_)
*)















functor MkDerivedForms(Switches: SWITCHES) :> DERIVED_FORMS =
struct

    (* Import *)

    structure G = InputGrammar
    structure E = ParsingError

    type Info      = G.Info

    type LongVId   = G.LongVId
    type LongTyCon = G.LongTyCon
    type LongStrId = G.LongStrId
    type LongSigId = G.LongSigId

    type Op        = G.Op
    type AtExp     = G.AtExp
    type AppExp    = G.Exp
    type InfExp    = G.Exp
    type Exp       = G.Exp
    type Match     = G.Match
    type Mrule     = G.Mrule
    type Pat       = G.Pat
    type ExBind    = G.EconBind
    type Fmatch    = G.Match
    type Fmrule    = G.Mrule
    type Fpat      = G.Pat
    type Ty        = G.Ty
    type TyVarSeq  = G.TyVarSeq
    type AtStrPat  = G.StrPat
    type StrPat    = G.StrPat
    type AppStrExp = G.StrExp
    type FunBind   = G.StrBind
    type AppSigExp = G.SigExp
    type SigExp    = G.SigExp
    type Spec      = G.Spec
    type ExDesc    = G.EconDesc
    type FunDesc   = G.StrDesc
    type ExItem    = G.EconItem
    type FunItem   = G.StrItem


    (* Additional types *)

    type AppExp = Exp
    type InfExp = Exp

    type Fmatch = Match
    type Fmrule = Mrule
    type Fpat   = Pat

    type TyReaDesc = (G.Info * G.TyVarSeq * G.LongTyCon * G.Ty) list

    (* Some helpers *)

    fun INTAtExp(I, n)		= G.SCONAtExp(I, G.SCon(I,
						SCon.INT(LargeInt.fromInt n)))
    fun STRINGAtExp(I, s)	= G.SCONAtExp(I, G.SCon(I, SCon.STRING s))

    fun strid_PERVASIVE(I)	= G.StrId(I, StrId.fromString "__pervasive")
    fun longstrid_PERVASIVE(I)	= G.SHORTLong(I, strid_PERVASIVE(I))
    fun longvid(I, vid)		= G.DOTLong(I, longstrid_PERVASIVE(I), vid)
    fun longtycon(I, tycon)	= G.DOTLong(I, longstrid_PERVASIVE(I), tycon)

    fun vid_FALSE(I)		= G.VId(I, VId.fromString "false")
    fun vid_TRUE(I)		= G.VId(I, VId.fromString "true")
    fun vid_NIL(I)		= G.VId(I, VId.fromString "nil")
    fun vid_CONS(I)		= G.VId(I, VId.fromString "::")
    fun vid_ASSERT(I)		= G.VId(I, VId.fromString "Assert")
    fun longvid_FALSE(I)	= longvid(I, vid_FALSE(I))
    fun longvid_TRUE(I)		= longvid(I, vid_TRUE(I))
    fun longvid_NIL(I)		= longvid(I, vid_NIL(I))
    fun longvid_CONS(I)		= longvid(I, vid_CONS(I))
    fun longvid_ASSERT(I)	= longvid(I, vid_ASSERT(I))

    fun LONGVIDAtExp(I,longvid)	= G.LONGVIDAtExp(I, G.WITHOp, longvid)
    fun LONGVIDAtPat(I,longvid)	= G.LONGVIDAtPat(I, G.WITHOp, longvid)
    fun LONGVIDExp(I, longvid)	= G.ATEXPExp(I, LONGVIDAtExp(I, longvid))
    fun LONGVIDPat(I, longvid)	= G.ATPATPat(I, LONGVIDAtPat(I, longvid))
    fun VIDAtExp(I, vid)	= LONGVIDAtExp(I, G.SHORTLong(I, vid))
    fun VIDAtPat(I, vid)	= LONGVIDAtPat(I, G.SHORTLong(I, vid))
    fun VIDExp(I, vid)		= LONGVIDExp(I, G.SHORTLong(I, vid))
    fun VIDPat(I, vid)		= LONGVIDPat(I, G.SHORTLong(I, vid))
    fun STRIDAtStrExp(I, strid)	= G.LONGSTRIDAtStrExp(I, G.SHORTLong(I, strid))
    fun STRIDStrExp(I, strid)	= G.ATSTREXPStrExp(I, STRIDAtStrExp(I, strid))
    fun SIGIDAtSigExp(I, sigid)	= G.LONGSIGIDAtSigExp(I, G.SHORTLong(I, sigid))
    fun SIGIDSigExp(I, sigid)	= G.ATSIGEXPSigExp(I, SIGIDAtSigExp(I, sigid))

    fun FALSEExp(I)		= LONGVIDExp(I, longvid_FALSE(I))
    fun TRUEExp(I)		= LONGVIDExp(I, longvid_TRUE(I))
    fun NILExp(I)		= LONGVIDExp(I, longvid_NIL(I))
    fun CONSExp(I)		= LONGVIDExp(I, longvid_CONS(I))
    fun FALSEPat(I)		= LONGVIDPat(I, longvid_FALSE(I))
    fun TRUEPat(I)		= LONGVIDPat(I, longvid_TRUE(I))
    fun NILPat(I)		= LONGVIDPat(I, longvid_NIL(I))
    fun CONSPat(I)		= LONGVIDPat(I, longvid_CONS(I))
    fun NILAtExp(I)		= G.LONGVIDAtExp(I, G.WITHOp, longvid_NIL(I))
    fun NILAtPat(I)		= G.LONGVIDAtPat(I, G.WITHOp, longvid_NIL(I))

    fun tycon_EXN(I)		= G.TyCon(I, TyCon.fromString "exn")
    fun longtycon_EXN(I)	= longtycon(I, tycon_EXN(I))


    (* Functions to handle rewriting of withtype declarations *)

    fun equalTyCon(G.TyCon(_,tycon1), G.TyCon(_,tycon2)) = tycon1 = tycon2
    fun equalTyVar(G.TyVar(_,tyvar1), G.TyVar(_,tyvar2)) = tyvar1 = tyvar2

    fun lookupTyCon(tycon, G.NEWTypBind(i, tyvarseq, tycon', typbind_opt)) =
	    E.error(i, E.WithtypeInvalid)

      | lookupTyCon(tycon, G.EQUALTypBind(_,tyvarseq,tycon', ty, typbind_opt)) =
	    if equalTyCon(tycon, tycon') then
		(tyvarseq, ty)
	    else
	  	lookupTyCon(tycon, Option.valOf typbind_opt)
		(* may raise Option *)


    fun replaceTy tyvarseq_tyseq (ty as G.WILDCARDTy _) =
	    ty

      | replaceTy (G.Seq(_,tyvars), G.Seq(_,tys)) (ty as G.TYVARTy(i, tyvar)) =
	let
	    fun loop(tyvar'::tyvars', ty'::tys') =
		    if equalTyVar(tyvar, tyvar') then
			ty'
		    else
			loop(tyvars', tys')
	      | loop([], _) =
		    ty
	      | loop(_, []) =
		    E.error(i, E.WithtypeArityMismatch)
	in
	    loop(tyvars, tys)
	end

      | replaceTy tyvarseq_tyseq (G.RECORDTy(I, tyrow_opt)) =
	    G.RECORDTy(I, Option.map (replaceTyRow tyvarseq_tyseq) tyrow_opt)

      | replaceTy tyvarseq_tyseq (G.TUPLETy(I, tys)) =
	    G.TUPLETy(I, List.map (replaceTy tyvarseq_tyseq) tys)

      | replaceTy tyvarseq_tyseq (G.TYCONTy(I, tyseq', tycon)) =
	    G.TYCONTy(I, replaceTySeq tyvarseq_tyseq tyseq', tycon)

      | replaceTy tyvarseq_tyseq (G.ARROWTy(I, ty1, ty2)) =
	    G.ARROWTy(I, replaceTy tyvarseq_tyseq ty1,
			 replaceTy tyvarseq_tyseq ty2)

      | replaceTy tyvarseq_tyseq (G.PARTy(I, ty)) =
	    G.PARTy(I, replaceTy tyvarseq_tyseq ty)

    and replaceTyRow tyvarseq_tyseq (G.DOTSTyRow(I, ty)) =
	    G.DOTSTyRow(I, replaceTy tyvarseq_tyseq ty)
      | replaceTyRow tyvarseq_tyseq (G.ROWTyRow(I, lab, ty, tyrow_opt)) =
	    G.ROWTyRow(I, lab, replaceTy tyvarseq_tyseq ty, 
			  Option.map (replaceTyRow tyvarseq_tyseq) tyrow_opt)

    and replaceTySeq tyvarseq_tyseq (G.Seq(I, tys)) =	  
	    G.Seq(I, List.map (replaceTy tyvarseq_tyseq) tys)


    fun rewriteTy typbind (ty as G.WILDCARDTy _) = ty

      | rewriteTy typbind (ty as G.TYVARTy _) = ty

      | rewriteTy typbind (G.RECORDTy(I, tyrow_opt)) =
	    G.RECORDTy(I, Option.map (rewriteTyRow typbind) tyrow_opt)

      | rewriteTy typbind (G.TUPLETy(I, tys)) =
	    G.TUPLETy(I, List.map (rewriteTy typbind) tys)

      | rewriteTy typbind (ty as G.TYCONTy(I, tyseq, longtycon as G.DOTLong _))=
	    G.TYCONTy(I, rewriteTySeq typbind tyseq, longtycon)

      | rewriteTy typbind (ty as G.TYCONTy(I, tyseq,
					  longtycon as G.SHORTLong(_, tycon))) =
	let 
	    val tyseq' = rewriteTySeq typbind tyseq
	in
	    let
		val (tyvarseq', ty') = lookupTyCon(tycon, typbind)
	    in
		replaceTy (tyvarseq',tyseq') ty'
	    end
	    handle Option.Option => G.TYCONTy(I, tyseq', longtycon)
	end

      | rewriteTy typbind (G.ARROWTy(I, ty1, ty2)) =
	    G.ARROWTy(I, rewriteTy typbind ty1, rewriteTy typbind ty2)

      | rewriteTy typbind (G.PARTy(I, ty)) =
	    G.PARTy(I, rewriteTy typbind ty)

    and rewriteTyRow typbind (G.DOTSTyRow(I, ty)) =
	    G.DOTSTyRow(I, rewriteTy typbind ty)
      | rewriteTyRow typbind (G.ROWTyRow(I, lab, ty, tyrow_opt)) =
	    G.ROWTyRow(I, lab, rewriteTy typbind ty,
			  Option.map (rewriteTyRow typbind) tyrow_opt)

    and rewriteTySeq typbind (G.Seq(I, tys)) =
	    G.Seq(I, List.map (rewriteTy typbind) tys)

    fun rewriteConBind typbind (G.ConBind(I, op_opt, vid, ty_opt, conbind_opt))=
	    G.ConBind(I, op_opt, vid,
			 Option.map (rewriteTy typbind) ty_opt,
			 Option.map (rewriteConBind typbind) conbind_opt)

    fun rewriteDatBind typbind (G.DatBind(I, tyvarseq, tycon, conbind,
							      datbind_opt)) =
	    G.DatBind(I, tyvarseq, tycon, rewriteConBind typbind conbind,
			 Option.map (rewriteDatBind typbind) datbind_opt)


    fun toTy tyvar = G.TYVARTy(G.infoTyVar tyvar, tyvar)

    fun toTypBind(G.NEWTypDesc(I, tyvarseq, tycon, typdesc_opt)) =
	    G.NEWTypBind(I, tyvarseq, tycon, Option.map toTypBind typdesc_opt)

      | toTypBind(G.EQUALTypDesc(I, tyvarseq, tycon, ty, typdesc_opt)) =
	    G.EQUALTypBind(I, tyvarseq, tycon, ty,
			      Option.map toTypBind typdesc_opt)

    (* Functions to handle rewriting of withtype specifications *)

    fun rewriteConDesc typbind (G.ConDesc(I, op_opt, vid, ty_opt, condesc_opt))=
	    G.ConDesc(I, op_opt, vid,
			 Option.map (rewriteTy typbind) ty_opt,
			 Option.map (rewriteConDesc typbind) condesc_opt)

    fun rewriteDatDesc typbind (G.DatDesc(I, tyvarseq, tycon, condesc,
							      datdesc_opt)) =
	    G.DatDesc(I, tyvarseq, tycon, rewriteConDesc typbind condesc,
			 Option.map (rewriteDatDesc typbind) datdesc_opt)


    (* Rewriting of abstype *)

    fun toTy tyvar = G.TYVARTy(G.infoTyVar tyvar, tyvar)

    fun redeclare(G.DatBind(I, tyvarseq, tycon, _, datbind_opt)) =
	let
	    val G.Seq(I',tyvarseq') = tyvarseq
	    val tyseq     = G.Seq(I', List.map toTy tyvarseq')
	    val I_tycon   = G.infoTyCon tycon
	    val longtycon = G.SHORTLong(I_tycon, tycon)
	    val ty        = G.TYCONTy(I_tycon, tyseq,longtycon)
	in
	    G.EQUALTypBind(I, tyvarseq, tycon, ty,
			      Option.map redeclare datbind_opt)
	end



    (* Patterns *)

    fun UNITAtPat(I) = G.TUPLEAtPat(I, [])

    val TUPLEAtPat   = G.TUPLEAtPat
    val WITHFUNPat   = G.WITHFUNPat

    fun LISTAtPat(I, []) = NILAtPat(I)
      | LISTAtPat(I, pats as pat::_) =
	let
	    val I' = Source.span(I, Source.at(G.infoPat pat))
	    fun toPatList []          = NILPat(I')
	      | toPatList(pat::pats') =
		let
		    val I'' = G.infoPat pat
		in
		    G.APPPat(I'', CONSPat(I'),
			     TUPLEAtPat(I'', [pat,toPatList pats']))
		end
	in
	    G.PARAtPat(I, toPatList pats)
	end


    fun DOTSPatRow(I, SOME pat, NONE) =
	    G.DOTSPatRow(Source.span(I, G.infoPat pat), pat)
      | DOTSPatRow(I, NONE, NONE)     =
	    G.DOTSPatRow(I, G.ATPATPat(I, G.WILDCARDAtPat(I)))
      | DOTSPatRow(I, pat_opt, SOME(G.ROWPatRow(I', lab, pat, patrow_opt))) =
	    G.ROWPatRow(I', lab, pat,
			SOME(DOTSPatRow(Source.at I, pat_opt, patrow_opt)))
      | DOTSPatRow(I, pat_opt, SOME(G.DOTSPatRow(I', _))) =
	    E.error(I', E.PatRowEllipses)

    fun VIDPatRow(I, vid as G.VId(I',vid'), ty_opt, pat_opt, patrow_opt) =
	let
	    val lab    = G.Lab(I', Lab.fromString(VId.toString vid'))
	    val vidPat = VIDPat(I', vid)
	    val pat1   = case ty_opt
			   of NONE    => vidPat
			    | SOME ty => G.TYPEDPat(I, vidPat, ty)
	    val pat    = case pat_opt
			   of NONE      => pat1
			    | SOME pat' => G.ASPat(I, pat1, pat')
	in
	    G.ROWPatRow(I, lab, pat, patrow_opt)
	end


    (* Expressions *)

    fun UNITAtExp(I) = G.TUPLEAtExp(I, [])

    val TUPLEAtExp   = G.TUPLEAtExp
    val HASHAtExp    = G.HASHAtExp
    val CASEExp      = G.CASEExp
    val ORELSEExp    = G.ORELSEExp
    val ANDALSOExp   = G.ANDALSOExp
    val SEQAtExp     = G.SEQAtExp

    fun IFExp(I, exp1, exp2, SOME exp3) = G.IFExp(I, exp1, exp2, exp3)
      | IFExp(I, exp1, exp2, NONE) =
	    G.IFExp(I, exp1, exp2,
		    G.ATEXPExp(Source.at I, UNITAtExp(Source.at I)))

    fun LETAtExp(I, dec, [exp]) = G.LETAtExp(I, dec, exp)
      | LETAtExp(I, dec,  exps) =
	    G.LETAtExp(I, dec, G.ATEXPExp(I, SEQAtExp(I, exps)))

    fun LISTAtExp(I, []) = NILAtExp(I)
      | LISTAtExp(I, exps as exp::_) =
	let
	    val I' = Source.span(I, Source.at(G.infoExp exp))
	    fun toExpList []          = NILExp(I')
	      | toExpList(exp::exps') =
		let
		    val I'' = G.infoExp exp
		in
		    G.APPExp(I'', CONSExp(I'),
			     TUPLEAtExp(I'', [exp, toExpList exps']))
		end
	in
	    G.PARAtExp(I, toExpList exps)
	end

    fun UPDATEAtExp(I, atexp, exprow) =
        let
            val I'  = G.infoAtExp atexp
            val vid = G.VId(Source.at I', VId.invent())

            fun toPatRow NONE =
                    SOME(G.DOTSPatRow(I', VIDPat(Source.at I', vid)))
              | toPatRow(SOME(G.ROWExpRow(I, G.Lab(I2,l), exp, exprow_opt))) =
                    SOME(G.ROWPatRow(I, G.Lab(Source.at I2, l),
                                G.ATPATPat(I, G.WILDCARDAtPat(Source.at I')),
                                toPatRow exprow_opt))
              | toPatRow(SOME(G.DOTSExpRow(I, _))) =
                    E.error(I, E.UpdExpInvalid)

            fun extendExpRow NONE =
                    SOME(G.DOTSExpRow(I', VIDExp(Source.at I', vid)))
              | extendExpRow(SOME(G.ROWExpRow(I, lab, exp, exprow_opt))) =
                    SOME(G.ROWExpRow(I, lab, exp, extendExpRow exprow_opt))
              | extendExpRow(SOME(G.DOTSExpRow(I, _))) =
                    E.error(I, E.UpdExpInvalid)

            val pat = G.ATPATPat(I', G.RECORDAtPat(I', toPatRow(SOME exprow)))
            val dec = G.VALDec(I', G.Seq(I', []),
                               G.PLAINValBind(I', pat,
					      G.ATEXPExp(I', atexp), NONE))
            val exp = G.ATEXPExp(I, G.RECORDAtExp(I, extendExpRow(SOME exprow)))
        in
            G.LETAtExp(I, dec, exp)
        end

    fun RECExp(I, pat, exp) =
	let
	    val I'      = G.infoPat pat
	    val I''     = Source.span(I,Source.at I')
	    val vid     = G.VId(I'', VId.invent())
	    val asPat   = G.ASPat(I', VIDPat(I'', vid), pat)
	    val valbind = G.RECValBind(I, G.PLAINValBind(I, asPat, exp, NONE))
	    val dec     = G.VALDec(I, G.Seq(I',[]), valbind)
	in
	    G.ATEXPExp(I, G.LETAtExp(I, dec, VIDExp(I'', vid)))
	end

    fun WHILEExp(I, exp1, exp2) =
	let
	    val I'        = Source.at I
	    val vid       = G.VId(I', VId.invent())
	    val longvid   = G.SHORTLong(I', vid)
	    val vidExp    = G.ATEXPExp(I', G.LONGVIDAtExp(I', G.WITHOp, longvid))
	    val unitAtExp = UNITAtExp(I)
	    val unitExp   = G.ATEXPExp(I, unitAtExp)
	    val callVid   = G.APPExp(I, vidExp, unitAtExp)

	    val seqExp    = G.ATEXPExp(I, G.SEQAtExp(I, [exp2, callVid]))
	    val fnBody    = G.IFExp(I, exp1, seqExp, unitExp)
	    val pat       = G.ATPATPat(I, G.WILDCARDAtPat(Source.at I))
	    val mrule     = G.Mrule(I, pat, fnBody)
	    val fnExp     = G.FNExp(I, G.Match(I, mrule, NONE))
	    val fnBind    = G.PLAINValBind(I, VIDPat(I', vid), fnExp, NONE)
	    val valbind   = G.RECValBind(I, fnBind)
	    val dec       = G.VALDec(I, G.Seq(I, []), valbind)
	in
	    G.ATEXPExp(I, G.LETAtExp(I, dec, callVid))
	end

    fun FINALLYExp(I, exp1, exp2) =
	let
	    val I'         = Source.at I
	    val vid1       = G.VId(I', VId.invent())
	    val vid2       = G.VId(I', VId.invent())
	    val vid3       = G.VId(I', VId.invent())
	    val longvid1   = G.SHORTLong(I', vid1)
	    val longvid2   = G.SHORTLong(I', vid2)
	    val longvid3   = G.SHORTLong(I', vid3)
	    val vidExp1    = G.ATEXPExp(I',G.LONGVIDAtExp(I',G.WITHOp,longvid1))
	    val vidExp2    = G.ATEXPExp(I',G.LONGVIDAtExp(I',G.WITHOp,longvid2))
	    val vidExp3    = G.ATEXPExp(I',G.LONGVIDAtExp(I',G.WITHOp,longvid3))

	    val appExp     = G.APPExp(I, vidExp2, UNITAtExp(I))
	    val letBody    = G.ATEXPExp(I, G.SEQAtExp(I, [appExp, vidExp1]))

	    val mrule2     = G.Mrule(I, G.ATPATPat(I, G.WILDCARDAtPat(I)), exp2)
	    val fnExp      = G.FNExp(I, G.Match(I, mrule2, NONE))
	    val valbind2   = G.PLAINValBind(I, VIDPat(I', vid2), fnExp, NONE)
	    val dec2       = G.VALDec(I, G.Seq(I, []), valbind2)

	    val raiseExp   = G.RAISEExp(I, vidExp3)
	    val handleBody = G.ATEXPExp(I, G.SEQAtExp(I, [appExp, raiseExp]))
	    val mrule1     = G.Mrule(I, VIDPat(I',vid3), handleBody)
	    val handleExp  = G.HANDLEExp(I, exp1, G.Match(I, mrule1, NONE))
	    val valbind1   = G.PLAINValBind(I, VIDPat(I',vid1), handleExp, NONE)
	    val dec1       = G.VALDec(I, G.Seq(I, []), valbind1)
	in
	    G.ATEXPExp(I, G.LETAtExp(I, G.SEQDec(I, dec2, dec1), letBody))
	end
(*
let
    val vid2 = fn _ => exp2
    val vid1 = exp1 handle vid3 => (vid2(); raise vid3)
in
    vid2(); vid1
end
*)
    val TRANSPACKExp = G.PACKExp

    fun OPAQPACKExp(I, atstrexp, atsigexp) =
	let
	    val I1     = G.infoAtStrExp atstrexp
	    val I2     = G.infoAtSigExp atsigexp
	    val I3     = Source.at I2

	    val sigid  = G.SigId(I3, SigId.invent())
	    val sigexp = G.ATSIGEXPSigExp(I2, atsigexp)
	    val dec    = G.SIGNATUREDec(I2, G.SigBind(I2,sigid,[],sigexp, NONE))

	    val atsigexp' = G.LONGSIGIDAtSigExp(I3, G.SHORTLong(I3, sigid))
	    val strexp    = G.ATSTREXPStrExp(I1, atstrexp)
	    val sigexp'   = G.ATSIGEXPSigExp(I3, atsigexp')
	    val strexp'   = G.OPAQStrExp(I, strexp, sigexp')
	    val atstrexp' = G.PARAtStrExp(I, strexp')
	    val exp       = G.PACKExp(I, atstrexp', atsigexp')
	in
	    G.ATEXPExp(I, G.LETAtExp(I, dec, exp))
	end

    fun COMPAtExp(I, SOME ann, spec, dec) =
	    G.COMPAtExp(I, ann, spec, dec)
      | COMPAtExp(I, NONE, spec, dec) =
	    G.COMPAtExp(I, G.EMPTYLocalAnn(Source.at I), spec, dec)

    fun FILEAtExp(I, desc) =
	let
	    val file = case Source.sourceUrl desc
			of NONE     => ""
			 | SOME url => Url.toStringRaw url
	in
	    STRINGAtExp(I, file)
	end

    fun LINEAtExp(I as ((line,_), _), desc) = INTAtExp(I, line)

    fun raiseAssertExp(I, desc) =
	let
	    val tupExp = G.TUPLEAtExp(I, [G.ATEXPExp(I, FILEAtExp(I, desc)),
					  G.ATEXPExp(I, LINEAtExp(I, desc))])
	in
	    G.RAISEExp(I, G.APPExp(I, LONGVIDExp(I, longvid_ASSERT(I)), tupExp))
	end

    fun ASSERTDOExp(I, desc, NONE, exp1, exp2) =
	    ASSERTDOExp(I, desc, SOME 0, exp1, exp2)
      | ASSERTDOExp(I, desc, SOME n, exp1, exp2) =
	if n > !Switches.Language.assertionLevel
	then exp2
	else G.IFExp(I, exp1, exp2, raiseAssertExp(I, desc))

    fun ASSERTOFDOExp(I, desc, d_opt, exp1, pat, exp2) =
	let
	    val I'     = Source.at I
	    val mrule1 = G.Mrule(G.infoPat pat, pat, TRUEExp(G.infoPat pat))
	    val mrule2 = G.Mrule(I', G.ATPATPat(I', G.WILDCARDAtPat(I')),
				 FALSEExp(I'))
	    val match  = G.Match(I, mrule1, SOME(G.Match(I', mrule2, NONE)))
	in
	    ASSERTDOExp(I, desc, d_opt, G.CASEExp(I, exp1, match), exp2)
	end

    fun ASSERTRAISEDOExp(I, desc, d_opt, exp1,
			 pat as G.ATPATPat(I', G.WILDCARDAtPat(_)), exp2) =
	let
	    val I'     = Source.at I
	    val seqExp = G.ATEXPExp(I, G.SEQAtExp(I, [exp1, FALSEExp(I')]))
	    val mrule  = G.Mrule(G.infoPat pat, pat, TRUEExp(I'))
	    val match  = G.Match(G.infoPat pat, mrule, NONE)
	in
	    ASSERTDOExp(I, desc, d_opt, G.HANDLEExp(I, seqExp, match), exp2)
	end
      | ASSERTRAISEDOExp(I, desc, d_opt, exp1, pat, exp2) =
	let
	    val I'     = Source.at I
	    val seqExp = G.ATEXPExp(I, G.SEQAtExp(I, [exp1, FALSEExp(I')]))
	    val mrule1 = G.Mrule(G.infoPat pat, pat, TRUEExp(I'))
	    val mrule2 = G.Mrule(I', G.ATPATPat(I', G.WILDCARDAtPat(I')),
				    FALSEExp(I'))
	    val match  = G.Match(I, mrule1, SOME(G.Match(I', mrule2, NONE)))
	in
	    ASSERTDOExp(I, desc, d_opt, G.HANDLEExp(I, seqExp, match), exp2)
	end

    fun ASSERTExp(I, desc, d_opt, exp) =
	ASSERTDOExp(I, desc, d_opt, exp, G.LAZYExp(I, raiseAssertExp(I, desc)))
    
    fun ASSERTOFExp(I, desc, d_opt, exp, pat) =
	ASSERTOFDOExp(I, desc, d_opt, exp, pat, G.ATEXPExp(I, UNITAtExp(I)))
    
    fun ASSERTRAISEExp(I, desc, d_opt, exp, pat) =
	ASSERTRAISEDOExp(I, desc, d_opt, exp, pat, G.ATEXPExp(I, UNITAtExp(I)))

    fun DOTSExpRow(I, exp, NONE) =
	    G.DOTSExpRow(I, exp)
      | DOTSExpRow(I, exp, exprow_opt as SOME exprow) =
	let
	    val I'     = G.infoExp exp
	    val vid    = G.VId(I', VId.invent())
	    val dec    = G.VALDec(I', G.Seq(I, []),
				  G.PLAINValBind(I', VIDPat(I',vid), exp, NONE))
	    val I''    = G.infoExpRow exprow
	    val exprow'= DOTSExpRow'(I, vid, exprow_opt)
	    val recExp = G.ATEXPExp(I'', G.RECORDAtExp(I'', SOME exprow'))
	    val letExp = G.ATEXPExp(I'', G.LETAtExp(I'', dec, recExp))
	in
	    G.DOTSExpRow(Source.at I, letExp)
	end
    and DOTSExpRow'(I, vid, NONE) =
	    G.DOTSExpRow(Source.span(I, G.infoVId vid),
			 VIDExp(G.infoVId vid, vid))
      | DOTSExpRow'(I, vid, SOME(G.ROWExpRow(I', lab, exp, exprow_opt))) =
	    G.ROWExpRow(I', lab, exp, SOME(DOTSExpRow'(I, vid, exprow_opt)))
      | DOTSExpRow'(I, vid, SOME(G.DOTSExpRow(I', _))) =
	    E.error(I', E.ExpRowEllipses)

    fun VIDExpRow(I, vid as G.VId(I',vid'), ty_opt, exprow_opt) =
	let
	    val lab    = G.Lab(I', Lab.fromString(VId.toString vid'))
	    val vidExp = VIDExp(I', vid)
	    val exp    = case ty_opt
			   of NONE    => vidExp
			    | SOME ty => G.TYPEDExp(I, vidExp, ty)
	in
	    G.ROWExpRow(I, lab, exp, exprow_opt)
	end


    (* Types *)

    fun TUPLETy(I, [ty]) = ty
      | TUPLETy(I,  tys) = G.TUPLETy(I, tys)

    fun DOTSTyRow(I, ty, NONE) =
	    G.DOTSTyRow(Source.span(I, G.infoTy ty), ty)
      | DOTSTyRow(I, ty, SOME(G.ROWTyRow(I', lab, ty', tyrow_opt))) =
	    G.ROWTyRow(I', lab, ty', SOME(DOTSTyRow(I, ty, tyrow_opt)))
      | DOTSTyRow(I, ty, SOME(G.DOTSTyRow(I', _))) =
	    E.error(I', E.TyRowEllipses)


    (* Signature expressions (Part 1) *)

    val SPECAtSigExp = G.SIGAtSigExp

    fun FCTSigExp(I, strpat as G.StrPat(I1, G.StrId(I2, strid'), sigexp1),
		     sigexp) =
	if StrId.toString strid' <> "" then
	    G.FCTSigExp(I, strpat, sigexp)
	else
	let
	    val I3     = G.infoSigExp sigexp
	    val strid  = G.StrId(I2, StrId.invent())

	    val dec    = G.OPENDec(I3, G.SHORTLong(I3, strid))
	    val letexp = G.ATSIGEXPSigExp(I3, G.LETAtSigExp(I3, dec, sigexp))
	in
	    G.FCTSigExp(I, G.StrPat(I1, strid, sigexp1), letexp)
	end

    fun ARROWSigExp(I, atsigexp, sigexp) =
	let
	    val I1      = G.infoAtSigExp atsigexp
	    val strid   = G.StrId(Source.at I1, StrId.invent())
	    val sigexp1 = G.ATSIGEXPSigExp(I1, atsigexp)
	in
	    G.FCTSigExp(I, G.StrPat(I1, strid, sigexp1), sigexp)
	end


    (* Declarations *)

    val FUNDec			= G.FUNDec
    val EXCEPTIONDec		= G.CONSTRUCTORDec
    val FUNCTORDec		= G.STRUCTUREDec
    val PRIMITIVEFUNDec		= G.PRIMITIVEVALDec
    val PRIMITIVEEQTYPEDec	= G.PRIMITIVETYPEDec
    val PRIMITIVEEQEQTYPEDec	= G.PRIMITIVETYPEDec
    val FvalBind		= G.FvalBind
    val EQUALExBind		= G.EQUALEconBind
    val Fmatch			= G.Match
    val Fmrule			= G.Mrule

    fun Fpat p			= p

    fun DODec(I, exp) =
	let
	    val I'  = Source.at I
	    val ty  = G.RECORDTy(I', NONE)
	    val pat = G.TYPEDPat(I', G.ATPATPat(I', G.WILDCARDAtPat(I')),ty)
	in
	    G.VALDec(I, G.Seq(I, []), G.PLAINValBind(I, pat, exp, NONE))
	end

    fun DATATYPEDec(I, datbind, NONE)         = G.DATATYPEDec(I, datbind)
      | DATATYPEDec(I, datbind, SOME typbind) =
	let
	    val datbind' = rewriteDatBind typbind datbind
	in
	    G.SEQDec(I, G.DATATYPEDec(G.infoDatBind datbind, datbind'),
			G.TYPEDec(G.infoTypBind typbind, typbind))
	end

    fun ABSTYPEDec(I, datbind, NONE, dec) =
	let
	    val datatypeDec = G.DATATYPEDec(I, datbind)
	    val typeDec     = G.TYPEDec(I, redeclare datbind)
	in
	    G.LOCALDec(I, datatypeDec, G.SEQDec(I, typeDec, dec))
	end

      | ABSTYPEDec(I, datbind, SOME typbind, dec) =
	let
	    val I'          = G.infoTypBind typbind
	    val datbind'    = rewriteDatBind typbind datbind
	    val datatypeDec = G.DATATYPEDec(I, datbind')
	    val typeDec     = G.TYPEDec(I, redeclare datbind')
	in
	    G.SEQDec(I, G.TYPEDec(I', typbind),
			G.LOCALDec(I, datatypeDec, G.SEQDec(I, typeDec, dec)))
	end


    fun OPENMULTIDec(I, G.ATSTREXPStrExp(_,G.LONGSTRIDAtStrExp(I',longstrid))) =
	     SOME(G.OPENDec(I', longstrid))
      | OPENMULTIDec(I, G.APPStrExp(_, strexp,
				       G.LONGSTRIDAtStrExp(I', longstrid))) =
	(case OPENMULTIDec(I, strexp)
	   of NONE     => NONE
	    | SOME dec => SOME(G.SEQDec(I, dec, G.OPENDec(I', longstrid)))
	)
      | OPENMULTIDec(I, _) = NONE

    fun OPENDec(I, strexp) =
	case OPENMULTIDec(I, strexp)
	  of SOME dec => dec
	   | NONE =>
	     let
		 val strid = G.StrId(I, StrId.invent())
		 val dec   = G.STRUCTUREDec(I, G.StrBind(I, strid,strexp, NONE))
	     in
(* Leads to strange bug (Bugzille #187) for lib/system/MkPolicy...
		G.LOCALDec(I, dec, G.OPENDec(I, G.SHORTLong(I, strid)))
*)
		G.SEQDec(I, dec, G.OPENDec(I, G.SHORTLong(I, strid)))
	     end

    fun INFIXMULTIDec(I, _, [])          = G.EMPTYDec(I)
      | INFIXMULTIDec(I, NONE, longvids) = INFIXMULTIDec(I, SOME 0, longvids)
      | INFIXMULTIDec(I, SOME d, longvid::longvids) =
	    G.SEQDec(I, G.INFIXDec(I, d, longvid),
			INFIXMULTIDec(I, SOME d, longvids))

    fun INFIXRMULTIDec(I, _, [])          = G.EMPTYDec(I)
      | INFIXRMULTIDec(I, NONE, longvids) = INFIXRMULTIDec(I, SOME 0, longvids)
      | INFIXRMULTIDec(I, SOME d, longvid::longvids) =
	    G.SEQDec(I, G.INFIXRDec(I, d, longvid),
			INFIXRMULTIDec(I, SOME d, longvids))

    fun NONFIXMULTIDec(I, [])                = G.EMPTYDec(I)
      | NONFIXMULTIDec(I, longvid::longvids) =
	    G.SEQDec(I, G.NONFIXDec(I,longvid), NONFIXMULTIDec(I,longvids))

    fun PRIMITIVEEXCEPTIONDec(I, op_opt, vid, ty_opt, string) =
	    G.PRIMITIVECONSTRUCTORDec(I, op_opt, vid, ty_opt,
				      G.Seq(I,[]), longtycon_EXN(I), string)

    fun PRIMITIVEFUNCTORDec(I, strid, strpats, sigexp, string) =
	let
	    val I' = G.infoSigExp sigexp

	    fun buildSigExp       []         = sigexp
	      | buildSigExp(strpat::strpats) =
		    FCTSigExp(Source.span(G.infoStrPat strpat, I'),
			      strpat, buildSigExp strpats)
	in
	    G.PRIMITIVESTRUCTUREDec(I, strid, buildSigExp strpats, string)
	end


    fun NEWExBind(I, op_opt, vid, ty_opt, econbind_opt) =
	    G.NEWEconBind(I, op_opt, vid, ty_opt, G.Seq(I,[]),
			     longtycon_EXN(Source.at I), econbind_opt)
 

    (* Structure bindings *)

    fun TRANSStrBind(I, strid, NONE, strexp, strbind_opt) =
	    G.StrBind(I, strid, strexp, strbind_opt)

      | TRANSStrBind(I, strid, SOME sigexp, strexp, strbind_opt) =
	    G.StrBind(I, strid, G.TRANSStrExp(I, strexp, sigexp), strbind_opt)

    fun OPAQStrBind(I, strid, sigexp, strexp, strbind_opt) =
	    G.StrBind(I, strid, G.OPAQStrExp(I, strexp, sigexp), strbind_opt)

    fun WILDCARDStrBind(I, sigexp_opt, strexp, strbind_opt) =
	    TRANSStrBind(I, G.StrId(I, StrId.invent()),
			 sigexp_opt, strexp, strbind_opt)


    (* Structure expressions *)

    val DECAtStrExp = G.STRUCTAtStrExp

    fun FCTStrExp(I, strpat as G.StrPat(I1, G.StrId(I2, strid'), sigexp),
		     strexp) =
	if StrId.toString strid' <> "" then
	    G.FCTStrExp(I, strpat, strexp)
	else
	let
	    val I3     = G.infoStrExp strexp
	    val strid  = G.StrId(I2, StrId.invent())

	    val dec    = G.OPENDec(I3, G.SHORTLong(I3, strid))
	    val letexp = G.ATSTREXPStrExp(I3, G.LETAtStrExp(I3, dec, strexp))
	in
	    G.FCTStrExp(I, G.StrPat(I1, strid, sigexp), letexp)
	end

    (* Structure patterns *)

    val STRIDAtStrPat = G.StrPat

    fun WILDCARDAtStrPat(I, sigexp) =
	    G.StrPat(I, G.StrId(I, StrId.invent()), sigexp)

    fun SPECAtStrPat(I, spec) =
	let
	    val I' = G.infoSpec spec
	in
	    G.StrPat(I, G.StrId(Source.at I, StrId.fromString ""),
		     G.ATSIGEXPSigExp(I', G.SIGAtSigExp(I', spec)))
	end

    val ATSTRPATStrPat = Pair.snd
    val STRIDStrPat    = G.StrPat
    val WILDCARDStrPat = WILDCARDAtStrPat


    (* Functor bindings *)

    fun FunBind(I, lazy_opt, strid, strpats, strexp, funbind_opt) =
	let
	    val I' = G.infoStrExp strexp

	    fun buildStrExp [] =
		    (case lazy_opt
		      of G.SANSLazy => strexp
		       | G.WITHLazy => G.LAZYStrExp(I', strexp)
		       | G.WITHSpawn => G.SPAWNStrExp(I', strexp)
		    )
	      | buildStrExp(strpat::strpats) =
		    FCTStrExp(Source.span(G.infoStrPat strpat, I'),
			      strpat, buildStrExp strpats)
	in
	    G.StrBind(I, strid, buildStrExp strpats, funbind_opt)
	end

    fun TRANSFunBind(I, lazy_opt, strid, strpats, NONE, strexp, funbind_opt) =
	    FunBind(I, lazy_opt, strid, strpats, strexp, funbind_opt)

      | TRANSFunBind(I, lazy_opt, strid, strpats, SOME sigexp, strexp, funbind_opt) =
	    FunBind(I, lazy_opt, strid, strpats,
		       G.TRANSStrExp(I, strexp, sigexp), funbind_opt)

    fun OPAQFunBind(I, lazy_opt, strid, strpats, sigexp, strexp, funbind_opt) =
	    FunBind(I, lazy_opt, strid, strpats,
		       G.OPAQStrExp(I, strexp, sigexp), funbind_opt)


    (* Specifications *)

    val FUNSpec			= G.VALSpec
    val SHARINGSpec		= G.SHARINGSpec
    val EXCEPTIONSpec		= G.CONSTRUCTORSpec
    val FUNCTORSpec		= G.STRUCTURESpec
    val EQUALExDesc		= G.EQUALEconDesc

    fun DATATYPESpec(I, datdesc, NONE)         = G.DATATYPESpec(I, datdesc)
      | DATATYPESpec(I, datdesc, SOME typdesc) =
	let
	    val datdesc' = rewriteDatDesc (toTypBind typdesc) datdesc
	in
	    G.SEQSpec(I, G.DATATYPESpec(G.infoDatDesc datdesc, datdesc'),
			 G.TYPESpec(G.infoTypDesc typdesc, typdesc))
	end

    fun INCLUDEMULTISpec(I, [])             = G.EMPTYSpec(I)
      | INCLUDEMULTISpec(I, longsigid::longsigids') =
	let
	    val sigexp = G.ATSIGEXPSigExp(I, G.LONGSIGIDAtSigExp(I, longsigid))
	    val spec1  = G.INCLUDESpec(I, sigexp)
	in
	    G.SEQSpec(I, spec1, INCLUDEMULTISpec(I, longsigids'))
	end

    fun INFIXMULTISpec(I, _, [])          = G.EMPTYSpec(I)
      | INFIXMULTISpec(I, NONE, longvids) = INFIXMULTISpec(I, SOME 0, longvids)
      | INFIXMULTISpec(I, SOME d, longvid::longvids) =
	    G.SEQSpec(I, G.INFIXSpec(I, d, longvid),
			 INFIXMULTISpec(I, SOME d, longvids))

    fun INFIXRMULTISpec(I, _, [])          = G.EMPTYSpec(I)
      | INFIXRMULTISpec(I, NONE, longvids) = INFIXRMULTISpec(I, SOME 0,longvids)
      | INFIXRMULTISpec(I, SOME d, longvid::longvids) =
	    G.SEQSpec(I, G.INFIXRSpec(I, d, longvid),
			 INFIXRMULTISpec(I, SOME d, longvids))

    fun NONFIXMULTISpec(I, [])                = G.EMPTYSpec(I)
      | NONFIXMULTISpec(I, longvid::longvids) =
	    G.SEQSpec(I, G.NONFIXSpec(I,longvid), NONFIXMULTISpec(I,longvids))


    fun NEWExDesc(I, op_opt, vid, ty_opt, econdesc_opt) =
	    G.NEWEconDesc(I, op_opt, vid, ty_opt, G.Seq(I,[]),
			  longtycon_EXN(Source.at I), econdesc_opt)

    fun FunDesc(I, strid, strpats, sigexp, fundesc_opt) =
	let
	    val I' = G.infoSigExp sigexp

	    fun buildSigExp       []         = sigexp
	      | buildSigExp(strpat::strpats) =
		    FCTSigExp(Source.span(G.infoStrPat strpat, I'),
			      strpat, buildSigExp strpats)
	in
	    G.NEWStrDesc(I, strid, buildSigExp strpats, fundesc_opt)
	end


    (* Signature expressions (Part 2) *)

    datatype Rea =
	  SIGRea         of Info * Spec * Rea option
	| VALRea         of Info * Op * LongVId * Op * LongVId * Rea option
	| CONSTRUCTORRea of Info * Op * LongVId * Op * LongVId * Rea option
	| TYPERea        of Info * TyVarSeq * LongTyCon * Ty * Rea option
	| EQTYPERea      of Info * TyVarSeq * LongTyCon * Rea option
	| EQEQTYPERea    of Info * TyVarSeq * LongTyCon * Rea option
	| STRUCTURERea   of Info * LongStrId * SigExp option * LongStrId
							     * Rea option
	| SIGNATURERea   of Info * LongSigId * StrPat list * AppSigExp
							   * Rea option

    val FUNRea       = VALRea
    val EXCEPTIONRea = CONSTRUCTORRea
    val FUNCTORRea   = STRUCTURERea


    fun buildValSpec (op_opt1, op_opt2, longvid) (I, vid) =
	    G.VALSpec(I, G.EQUALValDesc(I, op_opt1, vid,
					   op_opt2, longvid, NONE))
    fun buildEconSpec (op_opt1, op_opt2, longvid) (I, vid) =
	    G.CONSTRUCTORSpec(I, G.EQUALEconDesc(I, op_opt1, vid,
						    op_opt2, longvid, NONE))
    fun buildTypSpec (tyvarseq, ty) (I, tycon) =
	    G.TYPESpec(I, G.EQUALTypDesc(I, tyvarseq, tycon, ty, NONE))
    fun buildEqTypSpec (tyvarseq) (I, tycon) =
	    G.EQTYPESpec(I, G.NEWTypDesc(I, tyvarseq, tycon, NONE))
    fun buildEqEqTypSpec (tyvarseq) (I, tycon) =
	    G.EQEQTYPESpec(I, G.NEWTypDesc(I, tyvarseq, tycon, NONE))
    fun buildStrSpec (sigexp_opt, longstrid) (I, strid) =
	    G.STRUCTURESpec(I, G.EQUALStrDesc(I, strid, sigexp_opt,
						 longstrid, NONE))
    fun buildSigSpec (strpats, sigexp) (I, sigid) =
	    G.SIGNATURESpec(I, G.EQUALSigDesc(I, sigid, strpats, sigexp, NONE))

    fun buildSigExp(buildInnerSpec, I, longid, rea_opt) =
	let
	    val (strids,id) = G.explodeLong longid

	    fun buildSpec      []        = buildInnerSpec(I, id)
	      | buildSpec(strid::strids) =
		  G.STRUCTURESpec(I,
			G.NEWStrDesc(I, strid, buildSigExp strids, NONE))

	    and buildSigExp strids =
		  G.ATSIGEXPSigExp(I,
			G.SIGAtSigExp(I, buildSpec strids))
	in
	    ( buildSigExp strids, rea_opt )
	end


    fun Rea(SIGRea(I, spec, rea_opt)) =
	    ( G.ATSIGEXPSigExp(I, G.SIGAtSigExp(I, spec)), rea_opt )
      | Rea(VALRea(I, op_opt1, longvid1, op_opt2, longvid2, rea_opt)) =
	    buildSigExp(buildValSpec(op_opt1, op_opt2, longvid2),
			I, longvid1, rea_opt)
      | Rea(CONSTRUCTORRea(I, op_opt1, longvid1, op_opt2, longvid2, rea_opt)) =
	    buildSigExp(buildEconSpec(op_opt1, op_opt2, longvid2),
			I, longvid1, rea_opt)
      | Rea(TYPERea(I, tyvarseq, longtycon, ty, rea_opt)) =
	    buildSigExp(buildTypSpec(tyvarseq, ty), I, longtycon, rea_opt)
      | Rea(EQTYPERea(I, tyvarseq, longtycon, rea_opt)) =
	    buildSigExp(buildEqTypSpec(tyvarseq), I, longtycon, rea_opt)
      | Rea(EQEQTYPERea(I, tyvarseq, longtycon, rea_opt)) =
	    buildSigExp(buildEqEqTypSpec(tyvarseq), I, longtycon, rea_opt)
      | Rea(STRUCTURERea(I, longstrid1, sigexp_opt, longstrid2, rea_opt)) =
	    buildSigExp(buildStrSpec(sigexp_opt, longstrid2),
			I, longstrid1, rea_opt)
      | Rea(SIGNATURERea(I, longsigid, strpats, sigexp, rea_opt)) =
	    buildSigExp(buildSigSpec(strpats, sigexp), I, longsigid, rea_opt)

    fun WHEREREASigExp'(I, sigexp, NONE)     = sigexp
      | WHEREREASigExp'(I, sigexp, SOME rea) =
	let
	    val (sigexp2,rea_opt) = Rea rea
	    val  I'               = Source.span(I, G.infoSigExp sigexp2)
	    val  sigexp'          = G.WHERESigExp(I', sigexp, sigexp2)
	in
	    WHEREREASigExp'(I, sigexp', rea_opt)
	end

    fun WHEREREASigExp(I, sigexp, rea) = WHEREREASigExp'(I, sigexp, SOME rea)


    fun WHERELONGSTRIDSigExp(I, sigexp, longstrid1, longstrid2) =
	let
	    val I' = Source.span(G.infoLong longstrid1, G.infoLong longstrid2)
	in
	    WHEREREASigExp(I, sigexp,
			   STRUCTURERea(I', longstrid1, NONE, longstrid2, NONE))
	end



    (* Imports *)

    val FUNImp		= G.VALImp
    val EXCEPTIONImp	= G.CONSTRUCTORImp
    val FUNCTORImp	= G.STRUCTUREImp
    val PLAINExItem	= G.PLAINEconItem
    val PLAINFunItem	= G.PLAINStrItem

    fun INFIXMULTIImp(I, _, [])          = G.EMPTYImp(I)
      | INFIXMULTIImp(I, NONE, longvids) = INFIXMULTIImp(I, SOME 0, longvids)
      | INFIXMULTIImp(I, SOME d, longvid::longvids) =
	    G.SEQImp(I, G.INFIXImp(I, d, longvid),
			INFIXMULTIImp(I, SOME d, longvids))

    fun INFIXRMULTIImp(I, _, [])          = G.EMPTYImp(I)
      | INFIXRMULTIImp(I, NONE, longvids) = INFIXRMULTIImp(I, SOME 0, longvids)
      | INFIXRMULTIImp(I, SOME d, longvid::longvids) =
	    G.SEQImp(I, G.INFIXRImp(I, d, longvid),
			INFIXRMULTIImp(I, SOME d, longvids))

    fun NONFIXMULTIImp(I, [])                = G.EMPTYImp(I)
      | NONFIXMULTIImp(I, longvid::longvids) =
	    G.SEQImp(I, G.NONFIXImp(I,longvid), NONFIXMULTIImp(I,longvids))


    fun DESCExItem(I, op_opt, vid, ty, econitem_opt) =
	    G.DESCEconItem(I, op_opt, vid, SOME ty, G.Seq(I,[]),
			      longtycon_EXN(I), econitem_opt)

    fun DESCFunItem(I, strid, strpats, sigexp, funitem_opt) =
	let
	    val I' = G.infoSigExp sigexp

	    fun buildSigExp       []         = sigexp
	      | buildSigExp(strpat::strpats) =
		    FCTSigExp(Source.span(G.infoStrPat strpat, I'),
			      strpat, buildSigExp strpats)
	in
	    G.DESCStrItem(I, strid, buildSigExp strpats, funitem_opt)
	end


    (* Programs *)

    fun DECProgram(I, dec, program_opt) =
	    G.Program(I, dec, program_opt)

    fun EXPProgram(I, exp, program_opt) =
	let
	    val I'      = Source.at I
	    val longvid = G.SHORTLong(I', G.VId(I', VId.fromString "it"))
	    val pat     = G.ATPATPat(I', G.LONGVIDAtPat(I', G.SANSOp, longvid))
	    val valbind = G.PLAINValBind(I, pat, exp, NONE)
	    val dec     = G.VALDec(I, G.Seq(I, []), valbind)
	in
	    G.Program(I, dec, program_opt)
	end
end
