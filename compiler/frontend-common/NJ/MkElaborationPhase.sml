val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-03 11:33:00 $ by $Author: rossberg $
 *   $Revision: 1.146 $
 *)

(*******************************************************************************

We assume complete binding analysis and alpha conversion has been
performed on the input program. So we would not need to bother with scoping.
Nevertheless, we sometimes use scopes to reduce the size of the symbol table.

TODO: Replace Tag{Exp,Pat} annotations with general downward propagation of
annotation types, which would extend to recursive products and arrows.

TODO: Eliminate SingTyp in abstract grammar by proper encoding of datatypes.

*******************************************************************************)
































(*DEBUG




*)


functor MkElaborationPhase(val loadSig: Source.desc * Url.t -> Inf.sign
			   val loadMod: Source.desc * Url.t -> Reflect.module
			   val loadImports: Source.desc * Url.t -> (Url.t * Inf.sign) vector
			   structure Switches: SWITCHES)
    :> ELABORATION_PHASE =
struct

    structure C = Env
    structure I = AbstractGrammar
    structure O = TypedGrammar
    structure E = ElaborationError

    open TypedInfo

    nonfix mod

  (* Error *)

    val error = E.error
    val warn  = E.warn

    (*DEBUG helpers

    fun prStamp name z =
	(TextIO.print name; TextIO.print " = ";
	 TextIO.print(Stamp.toString z);
	 TextIO.print "\n")

    fun prLab name l =
	(TextIO.print name; TextIO.print " = ";
	 TextIO.print(Label.toString l);
	 TextIO.print "\n")

    fun prPath name p =
	(TextIO.print name; TextIO.print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPPath.ppPath p, 76 - size name);
	 TextIO.print "\n")

    fun prTyp name t =
	(TextIO.print name; TextIO.print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPType.ppTyp t, 76 - size name);
	 TextIO.print "\n")

    fun prTKind name k =
	(TextIO.print name; TextIO.print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPType.ppKind k, 76 - size name);
	 TextIO.print "\n")

    fun prInf name j =
	(TextIO.print name; TextIO.print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPInf.ppInf j, 76 - size name);
	 TextIO.print "\n")

    fun prPaths name u =
	(TextIO.print name; TextIO.print " = ";
	 PrettyPrint.output(TextIO.stdOut,
		PPMisc.brace(PPMisc.ppCommaList PPPath.ppPath (PathSet.toList u)),
		76 - size name);
	 TextIO.print "\n")

    fun nest 0 = ""
      | nest n = "  " ^ nest(n-1)

    fun prUE UE = prUE' 0 UE
    and prUE' n UE =
	(UseEnv.appVals (prUEVal n) UE;
	 UseEnv.appTyps (prUETyp n) UE;
	 UseEnv.appInfs (prUEInf n) UE;
	 UseEnv.appMods (prUEMod n) UE)
    and prUEVal n lab =
	TextIO.print(nest n ^ "val " ^ Label.toString lab ^ "\n")
    and prUETyp n lab =
	TextIO.print(nest n ^ "typ " ^ Label.toString lab ^ "\n")
    and prUEInf n lab =
	TextIO.print(nest n ^ "inf " ^ Label.toString lab ^ "\n")
    and prUEMod n (lab, UseEnv.FULL) =
	TextIO.print(nest n ^ "mod " ^ Label.toString lab ^ "\n")
      | prUEMod n (lab, UseEnv.PARTIAL UE) =
	(TextIO.print(nest n ^ "mod " ^ Label.toString lab ^ ":\n");
	 prUE' (n+1) UE)

    *)

  (* Annotations *)

    datatype annot =
	  ValAnnot of Type.t
	| TypAnnot of Type.t
	| ModAnnot of Inf.t
	| InfAnnot of Inf.t

    val annots : (Source.region * annot) list ref = ref []

    fun collectAnnot {vals,typs,mods,infs} (r : Source.region, annot) =
	if #1(#1 r) = 0 then () else
	case annot of
	    ValAnnot t =>
	    let
		val s = PrettyPrint.toString(PPType.ppTyp t, 80)
	    in
		StringMap.insertWith op@ (vals, s, [r])
	    end
	  | TypAnnot t =>
	    let
		val t = if Type.isAbbrev t then #2(Type.asAbbrev t) else t
		val s = PrettyPrint.toString(PPType.ppTyp t, 80)
	    in
		StringMap.insertWith op@ (typs, s, [r])
	    end
	  | ModAnnot j =>
	    let
		val s = PrettyPrint.toString(PPInf.ppInf j, 80)
	    in
		StringMap.insertWith op@ (mods, s, [r])
	    end
	  | InfAnnot j =>
	   let
		val j = if Inf.isAbbrev j then #2(Inf.asAbbrev j) else j
		val s = PrettyPrint.toString(PPInf.ppInf j, 80)
	    in
		StringMap.insertWith op@ (infs, s, [r])
	    end

    fun dumpRegion r =
	TextIO.output(Switches.Global.annotOut, " " ^ Source.regionToString r)

    fun dumpSort(map, prefix) =
	StringMap.appi (fn(s,is) => (
	    TextIO.output(Switches.Global.annotOut, "#" ^ prefix);
	    List.app dumpRegion is;
	    TextIO.output(Switches.Global.annotOut, "\n");
	    TextIO.output(Switches.Global.annotOut, s);
	    TextIO.output(Switches.Global.annotOut, "\n")
	)) map

    fun dumpAnnots() =
	if not(!Switches.Global.dumpAnnotations) then () else
	let
	    val vals = StringMap.map()
	    val typs = StringMap.map()
	    val mods = StringMap.map()
	    val infs = StringMap.map()
	in
	    List.app (collectAnnot {vals=vals, typs=typs, mods=mods, infs=infs})
		     (!annots);
	    dumpSort(vals, "V");
	    dumpSort(typs, "T");
	    dumpSort(mods, "M");
	    dumpSort(infs, "S");
	    annots := []
	end


  (* Predefined types *)

    val localName	= "_local"

    fun nonlocalPath NONE    = true
      | nonlocalPath(SOME p) =
	case Path.inspect p
	 of Path.Name n => n <> Name.ExId localName
	  | _           => true

    fun boolTyp E	= PervasiveType.typ_bool
    fun exnTyp E	= PervasiveType.typ_exn

    fun intTyp E	= PervasiveType.typ_int
    fun wordTyp E	= PervasiveType.typ_word
    fun charTyp E	= PervasiveType.typ_char
    fun stringTyp E	= PervasiveType.typ_string
    fun realTyp E	= PervasiveType.typ_real

    fun strictTyp(E,t)	= Type.apply(PervasiveType.typ_strict, t)
    fun refTyp(E,t)	= Type.apply(PervasiveType.typ_ref, t)
    fun vecTyp(E,t)	= Type.apply(PervasiveType.typ_vec, t)

    fun conarrowTyp(E,t1,t2) =
	Type.apply(PervasiveType.typ_conarrow, Type.arrow(t1,t2))

  (* Unification of vectors *)

    exception MismatchVec of int * Env.typ * Env.typ

    fun unifyVec ts =
	if Vector.length ts = 0 then
	    ()
	else let
	    val t0 = Vector.sub(ts,0)
	in
	    Vector.appi (fn(i,t) => Type.unify(t0,t)
				    handle Type.Mismatch(t1,t2) =>
					raise MismatchVec(i,t1,t2)
			) ts
	end


  (* Literals *)

    fun elabLit(E, I.IntLit n)		= ( intTyp E, O.IntLit n )
      | elabLit(E, I.WordLit w)		= ( wordTyp E, O.WordLit w )
      | elabLit(E, I.CharLit c)		= ( charTyp E, O.CharLit c )
      | elabLit(E, I.StringLit s)	= ( stringTyp E, O.StringLit s )
      | elabLit(E, I.RealLit x)		= ( realTyp E, O.RealLit x )

  (* Fixity *)

    fun elabFix(E, I.Fix(i,f))		= (f, O.Fix(fixInfo(i,f), f))

  (* Rows (polymorphic, thus put here) *)

    fun elabLab(E, I.Lab(i, l)) = ( l, O.Lab(nonInfo(i), l) )

    fun elabRow(elabX, infoX, E, I.Row(i, flds, xo)) =
	let
	    val (r0,xo')  = elabEll(elabX, infoX, E, xo)
	    val (r,flds') = elabFlds(elabX, E, r0, flds)
	in
	    ( r, O.Row(nonInfo(i), flds', xo') )
	end

    and elabEll(elabX, infoX, E, NONE) =
	    ( Type.emptyRow(), NONE )
      | elabEll(elabX, infoX, E, SOME x) =
	let
	    val (t,x') = elabX(E, x)
	    val  t0    = Type.prod(Type.unknownRow())
	    val  _     = Type.unify(t,t0) handle Type.Mismatch _ =>
			 error(infoX x, E.EllRowType t)
	in
	    ( Type.asProd t, SOME x' )
	end

    and elabFlds(elabX, E, r, flds) =
	let
	    val ltflds' = Vector.map (fn fld => elabFld(elabX,E,fld)) flds
	    val flds'   = Vector.map #3 ltflds'
	    val r       = Vector.foldl (fn((l,t,fld), r) => Type.extendRow(l,t,r)
					handle Type.Row =>
					    E.error(#region(O.infoFld fld),
						    E.FldRowDuplicate l))
					r ltflds'
	in
	    ( r, flds' )
	end

    and elabFld(elabX, E, I.Fld(i, vallab, x)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (t,x')      = elabX(E, x)
	in
	    annots := (I.infoLab vallab, ValAnnot t) :: !annots;
	    ( l, t, O.Fld(nonInfo(i), vallab', x') )
	end


  (* Value identifiers *)

    fun elabValid_bind(E, s, valid as I.Id(i, stamp, name)) =
	let
	    val  qt      = Type.unknown(Type.starKind())
	    val  t       = Type.unknown(Type.starKind())
	    val  u       = ref false
	    val (t',qt') = ( Env.insertVal(E, stamp,
				 {id=valid, typ=t, qtyp=qt, use=u});
			     (t,qt)
			   ) handle Env.Collision _ =>	(* val rec or alt pat *)
			     let val {typ=t', qtyp=qt', ...} =
				 Env.lookupVal(E, stamp)
			     in (t',qt') end
	in
	    annots := (i, ValAnnot qt') :: !annots;
	    ( t', qt', O.Id(typInfo(i,qt'), stamp, name) )
	end

    fun elabValid(E, I.Id(i, stamp, name)) =
	let
	    val {typ=t, qtyp=qt, use, ...} = Env.lookupVal(E, stamp)
	in
	    use := true;
	    ( t, qt, O.Id(typInfo(i,qt), stamp, name) )
	end

    and elabVallongid(E, I.ShortId(i, id)) =
	let
	    val (t,qt,valid') = elabValid(E, id)
	in
	    annots := (i, ValAnnot qt) :: !annots;
	    ( t, O.ShortId(typInfo(i,qt), valid') )
	end

      | elabVallongid(E, I.LongId(i, modlongid, vallab)) =
	let
	    val (s,use,modlongid') = elabModlongid_sig(E, modlongid)
	    val (l,vallab')        = elabLab(E, vallab)
	    val  t                 = Inf.lookupVal(s, l)
	in
	    if not(UseEnv.isPartial use) then () else
		UseEnv.insertVal(UseEnv.inner use, l);
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.LongId(typInfo(i,t), modlongid', vallab') )
	end


  (* Expressions *)

    and elabExp(E, I.LitExp(i, lit)) =
	let
	    val (t,lit') = elabLit(E, lit)
	in
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.LitExp(typInfo(i,t), lit') )
	end

      | elabExp(E, I.VarExp(i, vallongid)) =
	let
	    val (t,vallongid') = elabVallongid(E, vallongid)
	    val  t'            = Type.instance t
	in
	    ( t', O.VarExp(typInfo(i,t'), vallongid') )
	end

      | elabExp(E, I.PrimExp(i, s, typ)) =
	let
	    val (t,typ') = elabStarTyp(E, false, typ)
	in
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.PrimExp(typInfo(i,t), s, typ') )
	end

      | elabExp(E, I.NewExp(i, typ)) =
	let
	    val (t,typ') = elabStarTyp(E, false, typ)
	    val (t',t3)  = Type.asApply t handle Type.Type =>
				error(i, E.NewExpTyp t)
	    val (t1,t2)  = Type.asArrow t3 handle Type.Type =>
				error(i, E.NewExpTyp t3)
	    val _        = if Type.equal(t', PervasiveType.typ_conarrow)
			   then () else
				error(i, E.NewExpTyp t')
	    val _        = if Type.isExtKind(Type.kind t2) then () else
				error(i, E.NewExpResTyp t2)
	in
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.NewExp(typInfo(i,t), typ') )
	end

      | elabExp(E, I.TagExp(i, vallab, exp)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (t1,exp')   = elabExp(E, exp)
	    val  r          = Type.extendRow(l, t1, Type.unknownRow())
	    val  t          = Type.sum r
	in
	    annots := (I.infoLab vallab, ValAnnot t) :: !annots;
	    ( t, O.TagExp(typInfo(i,t), vallab', exp') )
	end
(*OBSOLETE
      | elabExp(E, I.TagExp(i, vallab, SOME typ, exp)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (t,typ')    = elabStarTyp(E, true, typ)
	    val (t1,exp')   = elabExp(E, exp)
	    val  t2         = Type.lookupRow(Type.asSum t,l)
			      handle (Type.Type | Type.Row) =>
				    error(I.infoLab vallab, E.TagExpLab l)
	    val  _          = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				    error(i, E.TagExpArgMismatch(t1,t2, t3,t4))
	in
	    annots := (I.infoLab vallab, ValAnnot t) :: !annots;
	    ( t, O.TagExp(typInfo(i,t), vallab', SOME typ', exp') )
	end
*)
      | elabExp(E, I.ConExp(i, vallongid, exp)) =
	let
	    val (t1,vallongid') = elabVallongid(E, vallongid)
	    val  t1'            = Type.instance t1
	    val (t2,exp')       = elabExp(E, exp)
	    val  t11            = Type.unknown(Type.starKind())
	    val  t12            = Type.unknown(Type.starKind())
	    val  t3             = conarrowTyp(E, t11, t12)
	    val  _              = Type.unify(t3,t1')
				  handle Type.Mismatch(t4,t5) =>
				    error(I.infoLongid vallongid,
					  E.ConExpConMismatch(t3, t1', t4, t5))
	    val  _              = Type.unify(t11,t2)
				  handle Type.Mismatch(t4,t5)=>
				    error(i, E.ConExpArgMismatch(t11, t2, t4, t5))
	in
	    annots := (I.infoLongid vallongid, ValAnnot t12) :: !annots;
	    ( t12, O.ConExp(typInfo(i,t12), vallongid', exp') )
	end

      | elabExp(E, I.RefExp(i, exp)) =
	let
	    val (t1,exp') = elabExp(E, exp)
	    val  t        = refTyp(E, t1)
	in
	    annots := (Source.span(i, Source.at(I.infoExp exp)),
		       ValAnnot t) :: !annots;
	    ( t, O.RefExp(typInfo(i,t), exp') )
	end

      | elabExp(E, I.RollExp(i, exp, typ)) =
	let
	    val (t1,exp') = elabExp(E, exp)
	    val (t2,typ') = elabStarTyp(E, true, typ)
	    val  t2'      = Type.unroll t2
	    val  _        = Type.unify(t1,t2') handle Type.Mismatch(t3,t4) =>
				error(i, E.RollExpMismatch(t1, t2', t3, t4))
	in
	    ( t2, O.RollExp(typInfo(i,t2), exp', typ') )
	end

      | elabExp(E, I.StrictExp(i, exp)) =
	let
	    val (t1,exp') = elabExp(E, exp)
	    val  t        = strictTyp(E, t1)
	in
	    ( t, O.StrictExp(typInfo(i,t), exp') )
	end

      | elabExp(E, I.TupExp(i, exps)) =
	let
	    val (ts,exps') = elabExps(E, exps)
	    val  t         = Type.tuple ts
	in
	    (* Bad interference with derived forms... :-(
	    annots := (Source.span(i, Source.at(I.infoExp(Vector.sub(exps,0))))
		       handle Subscript => i,
		       ValAnnot t) :: !annots;
	    *)
	    ( t, O.TupExp(typInfo(i,t), exps') )
	end

      | elabExp(E, I.ProdExp(i, exprow)) =
	let
	    val (r,exprow') = elabRow(elabExp, I.infoExp, E, exprow)
	    val  t          = Type.prod r
	in
	    (* Bad interference with derived forms... :-(
	    annots := (Source.span(i, Source.at(I.infoRow exprow)),
		       ValAnnot t) :: !annots;
	    *)
	    ( t, O.ProdExp(typInfo(i,t), exprow') )
	end

      | elabExp(E, I.SelExp(i, vallab, exp')) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (t1,exp')   = elabExp(E, exp')
	    val  t          = Type.unknown(Type.starKind())
	    val  r          = Type.extendRow(l, t, Type.unknownRow())
	    val  t2         = Type.prod r
	    val  _          = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.SelExpMismatch(t1, t2, t3, t4))
	in
	    annots := (Source.span(i, I.infoLab vallab),
		       ValAnnot(Type.arrow(t1,t))) :: !annots;
	    ( t, O.SelExp(typInfo(i,t), vallab', exp') )
	end

      | elabExp(E, I.VecExp(i, exps)) =
	let
	    val (ts,exps') = elabExps(E, exps)
	    val  t0        = case ts of #[] => Type.unknown(Type.starKind())
				      |  _  => Vector.sub(ts,0)
	    val  t         = vecTyp(E, t0)
	    val  _         = unifyVec ts handle MismatchVec(n,t1,t2) =>
				error(I.infoExp(Vector.sub(exps,n)),
				      E.VecExpMismatch(t, Vector.sub(ts,n), t1,t2))
	in
	    annots := (Source.span(i, Source.at(I.infoExp(Vector.sub(exps,0))))
		       handle Subscript => i,
		       ValAnnot t) :: !annots;
	    ( t, O.VecExp(typInfo(i,t), exps') )
	end

      | elabExp(E, I.FunExp(i, mats)) =
	let
	    val  t1        = Type.unknown(Type.starKind())
	    val (t2,mats') = elabMats(E, t1, mats)
	    val  t         = Type.arrow(t1,t2)
	in
	    annots := (Source.span(i, Source.at(I.infoMat(Vector.sub(mats,0))
						handle Subscript => i)),
		       ValAnnot t) :: !annots;
	    ( t, O.FunExp(typInfo(i,t), mats') )
	end

      | elabExp(E, I.AppExp(i, exp1, exp2)) =
	let
	    val (t1,exp1') = elabExp(E, exp1)
	    val (t2,exp2') = elabExp(E, exp2)
	    val  t11       = Type.unknown(Type.starKind())
	    val  t12       = Type.unknown(Type.starKind())
	    val  t1'       = Type.arrow(t11,t12)
	    val  _         = Type.unify(t1,t1') handle Type.Mismatch(t3,t4) =>
				error(I.infoExp exp1,
				      E.AppExpFunMismatch(t1, t1', t3, t4))
	    val  _         = Type.unify(t2,t11) handle Type.Mismatch(t3,t4) =>
				error(i, E.AppExpArgMismatch(t2, t11, t3, t4))
	in
	    ( t12, O.AppExp(typInfo(i,t12), exp1', exp2') )
	end

      | elabExp(E, I.AndExp(i, exp1, exp2)) =
	let
	    val (t1,exp1') = elabExp(E, exp1)
	    val (t2,exp2') = elabExp(E, exp2)
	    val  t         = boolTyp E
	    val  _         = Type.unify(t1,t) handle Type.Mismatch(t3,t4) =>
				error(I.infoExp exp1, E.AndExpMismatch(t1,t,t3,t4))
	    val  _         = Type.unify(t2,t) handle Type.Mismatch(t3,t4) =>
				error(I.infoExp exp2, E.AndExpMismatch(t2,t,t3,t4))
	in
	    ( t, O.AndExp(typInfo(i,t), exp1', exp2') )
	end

      | elabExp(E, I.OrExp(i, exp1, exp2)) =
	let
	    val (t1,exp1') = elabExp(E, exp1)
	    val (t2,exp2') = elabExp(E, exp2)
	    val  t         = boolTyp E
	    val  _         = Type.unify(t1,t) handle Type.Mismatch(t3,t4) =>
				error(I.infoExp exp1, E.OrExpMismatch(t1,t,t3,t4))
	    val  _         = Type.unify(t2,t) handle Type.Mismatch(t3,t4) =>
				error(I.infoExp exp2, E.OrExpMismatch(t2,t,t3,t4))
	in
	    ( t, O.OrExp(typInfo(i,t), exp1', exp2') )
	end

      | elabExp(E, I.IfExp(i, exp1, exp2, exp3)) =
	let
	    val (t1,exp1') = elabExp(E, exp1)
	    val (t2,exp2') = elabExp(E, exp2)
	    val (t3,exp3') = elabExp(E, exp3)
	    val  tb        = boolTyp E
	    val  _         = Type.unify(t1,tb) handle Type.Mismatch(t4,t5) =>
				error(I.infoExp exp1,
				      E.IfExpCondMismatch(t1, tb, t4, t5))
	    val  _         = Type.unify(t2,t3) handle Type.Mismatch(t4,t5) =>
				error(i, E.IfExpBranchMismatch(t2, t3, t4, t5))
	in
	    annots := (Source.span(i, Source.at(I.infoExp exp1)),
		       ValAnnot t2) :: !annots;
	    ( t2, O.IfExp(typInfo(i,t2), exp1', exp2', exp3') )
	end

      | elabExp(E, I.SeqExp(i, exp1, exp2)) =
	let
	    val (t1,exp1') = elabExp(E, exp1)
	    val (t2,exp2') = elabExp(E, exp2)
	in
	    ( t2, O.SeqExp(typInfo(i,t2), exp1', exp2') )
	end

      | elabExp(E, I.CaseExp(i, exp, mats)) =
	let
	    val (t1,exp')  = elabExp(E, exp)
	    val (t2,mats') = elabMats(E, t1, mats)
	in
	    annots := (Source.span(i, Source.at(I.infoExp exp)),
		       ValAnnot(Type.arrow(t1,t2))) :: !annots;
	    ( t2, O.CaseExp(typInfo(i,t2), exp', mats') )
	end

      | elabExp(E, I.FailExp(i)) =
	let
	    val  t = Type.unknown(Type.starKind())
	in
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.FailExp(typInfo(i,t)) )
	end

      | elabExp(E, I.LazyExp(i, exp)) =
	let
	    val (t,exp') = elabExp(E, exp)
	in
	    annots := (Source.span(i, Source.at(I.infoExp exp)),
		       ValAnnot t) :: !annots;
	    ( t, O.LazyExp(typInfo(i,t), exp') )
	end

      | elabExp(E, I.SpawnExp(i, exp)) =
	let
	    val (t,exp') = elabExp(E, exp)
	in
	    annots := (Source.span(i, Source.at(I.infoExp exp)),
		       ValAnnot t) :: !annots;
	    ( t, O.SpawnExp(typInfo(i,t), exp') )
	end

      | elabExp(E, I.RaiseExp(i, exp)) =
	let
	    val (t1,exp') = elabExp(E, exp)
	    val  te       = exnTyp E
	    val  t        = Type.unknown(Type.starKind())
	    val  _        = Type.unify(t1,te) handle Type.Mismatch(t2,t3) =>
				error(I.infoExp exp,
				      E.RaiseExpMismatch(t1, te, t2, t3))
	in
	    ( t, O.RaiseExp(typInfo(i,t), exp') )
	end

      | elabExp(E, I.HandleExp(i, exp, mats)) =
	let
	    val (t1,exp')  = elabExp(E, exp)
	    val  te        = exnTyp E
	    val (t2,mats') = elabMats(E, te, mats)
	    val  _         = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.HandleExpMismatch(t1, t2, t3, t4))
	in
	    annots := (Source.between(I.infoExp exp, I.infoMat(Vector.sub(mats,0))),
		       ValAnnot(Type.arrow(te,t1))) :: !annots
		       handle Subscript => ();
	    ( t1, O.HandleExp(typInfo(i,t1), exp', mats') )
	end

      | elabExp(E, I.AnnExp(i, exp, typ)) =
	let
	    val (t1,exp') = elabExp(E, exp)
	    val (t2,typ') = elabStarTyp(E, true, typ)
	    val  _        = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.AnnExpMismatch(t1, t2, t3, t4))
	in
	    ( t2, O.AnnExp(typInfo(i,t2), exp', typ') )
	end

      | elabExp(E, I.LetExp(i, decs, exp)) =
	let
	    val  _       = Env.insertScope E
	    val  s       = Inf.emptySig()
	    val  p       = Path.fromString localName
	    val  decs'   = elabDecs(E, s, SOME p, decs)
	    val (t,exp') = elabExp(E, exp)
	    val  _       = Env.removeScope E
	    val  s2      = Inf.emptySig()
	    val  _       = Inf.extendVal(s2, Label.fromInt 0, t)
	    val  j       = Inf.exist(p, Inf.sign s, Inf.sign s2) (* maximises *)
	    val  _       = if not(Inf.isExist j) then () else
				error(i, E.LetExpGenerative(#2(Inf.asExist j)))
	in
	    (* Bad interference with derived forms... :-(
	    annots := (Source.span(i, Source.at(I.infoDec(Vector.sub(decs,0))
						handle Subscript => I.infoExp exp)),
		       ValAnnot t) :: !annots;
	    *)
	    ( t, O.LetExp(typInfo(i,t), decs', exp') )
	end

      | elabExp(E, I.PackExp(i, mod, inf)) =
	let
	    val (j1,mod') = elabMod(E, NONE, mod)
	    val (j2,inf') = elabGroundInf(E, NONE, inf)
	    val  _        = Type.enterLevel()
	    val  _        = Inf.match(j1,j2) handle Inf.Mismatch mismatch =>
				error(i, E.AnnModMismatch mismatch)
	    val  _        = Type.exitLevel()
	    val  t        = PervasiveType.typ_package
	in
	    annots := (Source.span(i, Source.at(I.infoMod mod)),
		       ValAnnot t) :: !annots;
	    ( t, O.PackExp(typInfo(i,t), mod', inf') )
	end

      | elabExp(E, I.OverExp(i, exps, varid, typlongids, typ)) =
	let
	    val  _ = if Vector.length exps = Vector.length typlongids then ()
		     else error(i, E.OverExpArity)
	    val (ts1,exps') =
		VectorPair.unzip(Vector.map (fn x => elabExp(E,x)) exps)
	    val (ts2,typlongids') =
		VectorPair.unzip(Vector.map (fn x => elabTyplongid(E,x))
					    typlongids)
	    val _  = Env.insertScope E
	    val ks = Vector.map Type.kind ts2
	    val ps = Vector.map (fn t => Type.asCon t handle Type.Type =>
				    error(i, E.OverExpNonPrimTyp t)) ts2
	    val c  = case Vector.toList ps
		     of nil   => error(i, E.OverExpEmpty)
		      | p::ps => Type.Extensional(p,ps)
	    val k  = Vector.sub(ks, 0)
	    val m  = PathMap.map()
	    val _  = Vector.appi
		     (fn(j,k') =>
		      let
			  val i' = I.infoLongid(Vector.sub(typlongids,j))
		      in
			  if not(Type.equalKind(k,k')) then
			      error(i', E.OverExpKind(Vector.sub(ts2,j)))
			  else
			      PathMap.insertDisjoint(m, Vector.sub(ps,j), j)
			      handle PathMap.Collision p =>
				 error(i', E.OverExpOverlap(Vector.sub(ts2,j),
				   Vector.sub(ts2,PathMap.lookupExistent(m,p))))
		      end) ks
	    val (a,varid') = elabVarid_bind(E, k, c, varid)
	    val (t1,typ')  = elabTyp(E, typ)
	    val  _         = Env.removeScope E
	    val  t         = Type.all(a,t1)
	in
	    Vector.appi (fn(j,t1) =>
			 let
			     val t2 = Type.instanceWith(t, Vector.sub(ts2,j))
			 in
			     Type.unify(t1, t2) handle Type.Mismatch(t3,t4) =>
			         error(I.infoExp(Vector.sub(exps,j)),
				       E.OverExpMismatch(t1,t2,t3,t4))
			 end) ts1;
	    ( t, O.OverExp(typInfo(i,t), exps', varid', typlongids', typ') )
	end

      | elabExp(E, I.OverallExp(i, exp, varid, typ)) =
	let
	    val (t1,exp')  = elabExp(E,exp)
	    val  _         = Env.insertScope E
	    val  k         = Type.starKind()
	    val (a,varid') = elabVarid_bind(E, k, Type.Intensional, varid)
	    val (t2,typ')  = elabTyp(E, typ)
	    val  _         = Env.removeScope E
	    val  t         = Type.all(a,t2)
	    val  t0        = Type.arrow(Type.unknown(Type.starKind()), t2)
					(*UNFINISEHD: use typ_typ *)
	    (*TODO: hack as long as we don't have 1st class polymorphism *)
	    val exp' = case exp'
			of O.VarExp(i,y) => O.VarExp(O.infoLongid y, y)
			 | _ => raise Fail "elabExp OverallExp"
	in
	    Type.unify(t0, t1) handle Type.Mismatch(t3,t4) =>
		error(I.infoExp exp, E.OverallExpMismatch(t0,t2,t3,t4));
	    ( t, O.OverallExp(typInfo(i,t), exp', varid', typ') )
	end

    and elabExps(E, exps) =
	VectorPair.unzip(Vector.map (fn exp => elabExp(E,exp)) exps)


  (* Matches *)

    and elabMat(E, t1, t2, I.Mat(i, pat, exp)) =
	let
	    val  _        = Env.insertScope E
	    val (t3,pat') = elabPat(E, Inf.emptySig(), pat)
	    val  _        = Type.unify(t1,t3) handle Type.Mismatch(t5,t6) =>
				error(I.infoPat pat,
				      E.MatPatMismatch(t1, t3, t5, t6))
	    val (t4,exp') = elabExp(E, exp)
	    val  _        = Type.unify(t2,t4) handle Type.Mismatch(t5,t6) =>
				error(I.infoExp exp,
				      E.MatExpMismatch(t2, t4, t5, t6))
	    val  E'       = Env.splitScope E
	    val  _        = monomorphiseVals E'
	in
	    O.Mat(nonInfo(i), pat', exp')
	end

    and elabMats(E, t1, mats) =
	let
	    val t2    = Type.unknown(Type.starKind())
	    val mats' = Vector.map (fn mat => elabMat(E, t1, t2, mat)) mats
	in
	    ( t2, mats' )
	end


  (* Patterns *)

    and elabPat(E, s, I.JokPat(i)) =
	let
	    val t = Type.unknown(Type.starKind())
	in
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.JokPat(typInfo(i,t)) )
	end

      | elabPat(E, s, I.LitPat(i, lit)) =
	let
	    val (t,lit') = elabLit(E, lit)
	in
	    annots := (i, ValAnnot t) :: !annots;
	    ( t, O.LitPat(typInfo(i,t), lit') )
	end

      | elabPat(E, s, I.VarPat(i, valid)) =
	let
	    val (t,qt,valid') = elabValid_bind(E, s, valid)
	in
	    ( t, O.VarPat(typInfo(i,t), valid') )
	end

      | elabPat(E, s, I.TagPat(i, vallab, pat)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (t1,pat')   = elabPat(E, s, pat)
	    val  r          = Type.extendRow(l, t1, Type.unknownRow())
	    val  t          = Type.sum r
	in
	    annots := (I.infoLab vallab, ValAnnot t) :: !annots;
	    ( t, O.TagPat(typInfo(i,t), vallab', pat') )
	end
(*OBSOLETE
      | elabPat(E, s, I.TagPat(i, vallab, SOME typ, pat)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (t,typ')    = elabStarTyp(E, true, typ)
	    val (t1,pat')   = elabPat(E, s, pat)
	    val  t2         = Type.lookupRow(Type.asSum t,l)
			      handle (Type.Type | Type.Row) =>
				    error(I.infoLab vallab, E.TagPatLab l)
	    val  _          = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				    error(i, E.TagPatArgMismatch(t1, t2, t3, t4))
	in
	    ( t, O.TagPat(typInfo(i,t), vallab', SOME typ', pat') )
	end
*)
      | elabPat(E, s, I.ConPat(i, vallongid, pat)) =
	let
	    val (t1,vallongid') = elabVallongid(E, vallongid)
	    val  t1'            = Type.instance t1
	    val (t2,pat')       = elabPat(E, s, pat)
	    val  t11            = Type.unknown(Type.starKind())
	    val  t12            = Type.unknown(Type.starKind())
	    val  t3             = conarrowTyp(E, t11, t12)
	    val  _              = Type.unify(t3,t1')
				  handle Type.Mismatch(t4,t5) =>
				    error(I.infoLongid vallongid,
					  E.ConPatConMismatch(t3, t1', t4, t5))
	    val  _              = Type.unify(t11,t2)
				  handle Type.Mismatch(t4,t5)=>
				    error(i, E.ConPatArgMismatch(t11, t2, t4, t5))
	in
	    annots := (I.infoLongid vallongid, ValAnnot t12) :: !annots;
	    ( t12, O.ConPat(typInfo(i,t12), vallongid', pat') )
	end

      | elabPat(E, s, I.RefPat(i, pat)) =
	let
	    val (t1,pat') = elabPat(E, s, pat)
	    val  t        = refTyp(E, t1)
	in
	    annots := (Source.span(i, Source.at(I.infoPat pat)),
		       ValAnnot t) :: !annots;
	    ( t, O.RefPat(typInfo(i,t), pat') )
	end

      | elabPat(E, s, I.RollPat(i, pat, typ)) =
	let
	    val (t1,pat') = elabPat(E, s, pat)
	    val (t2,typ') = elabStarTyp(E, true, typ)
	    val  t2'      = Type.unroll t2
	    val  _        = Type.unify(t1,t2') handle Type.Mismatch(t3,t4) =>
				error(i, E.RollPatMismatch(t1, t2', t3, t4))
	in
	    ( t2, O.RollPat(typInfo(i,t2), pat', typ') )
	end

      | elabPat(E, s, I.StrictPat(i, pat)) =
	let
	    val (t1,pat') = elabPat(E, s, pat)
	    val  t        = strictTyp(E, t1)
	in
	    ( t, O.StrictPat(typInfo(i,t), pat') )
	end

      | elabPat(E, s, I.TupPat(i, pats)) =
	let
	    val (ts,pats') = elabPats(E, s, pats)
	    val  t         = Type.tuple ts
	in
	    (* Bad interference with derived forms... :-(
	    annots := (Source.span(i, Source.at(I.infoPat(Vector.sub(pats,0))))
		       handle Subscript => i,
		       ValAnnot t) :: !annots;
	    *)
	    ( t, O.TupPat(typInfo(i,t), pats') )
	end

      | elabPat(E, s, I.ProdPat(i, patrow)) =
	let
	    val (r,patrow') = elabRow(fn(E,pat) => elabPat(E,s,pat), I.infoPat,
				      E, patrow)
	    val  t          = Type.prod r
	in
	    (* Bad interference with derived forms... :-(
	    annots := (Source.span(i, Source.at(I.infoRow patrow)),
		       ValAnnot t) :: !annots;
	    *)
	    ( t, O.ProdPat(typInfo(i,t), patrow') )
	end

      | elabPat(E, s, I.VecPat(i, pats)) =
	let
	    val (ts,pats') = elabPats(E, s, pats)
	    val  t0        = case ts of #[] => Type.unknown(Type.starKind())
				      |  _  => Vector.sub(ts,0)
	    val  t         = vecTyp(E, t0)
	    val  _         = unifyVec ts handle MismatchVec(n,t1,t2) =>
				error(I.infoPat(Vector.sub(pats,n)),
				      E.VecPatMismatch(t, Vector.sub(ts,n), t1,t2))
	in
	    annots := (Source.span(i, Source.at(I.infoPat(Vector.sub(pats,0))))
		       handle Subscript => i,
		       ValAnnot t) :: !annots;
	    ( t, O.VecPat(typInfo(i,t), pats') )
	end

      | elabPat(E, s, I.AsPat(i, pat1, pat2)) =
	let
	    val (t1,pat1') = elabPat(E, s, pat1)
	    val (t2,pat2') = elabPat(E, s, pat2)
	    val  _         = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.AsPatMismatch(t1, t2, t3, t4))
	in
	    ( t2, O.AsPat(typInfo(i,t2), pat1', pat2') )
	end

      | elabPat(E, s, I.AltPat(i, pat1, pat2)) =
	let
	    val (t1,pat1') = elabPat(E, s, pat1)
	    val (t2,pat2') = elabPat(E, s, pat2)
	    val  _         = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.AltPatMismatch(t1, t2, t3, t4))
	in
	    ( t2, O.AltPat(typInfo(i,t2), pat1', pat2') )
	end

      | elabPat(E, s, I.NegPat(i, pat)) =
	let
	    val (t,pat') = elabPat(E, s, pat)
	in
	    annots := (Source.span(i, Source.at(I.infoPat pat)),
		       ValAnnot t) :: !annots;
	    ( t, O.NegPat(typInfo(i,t), pat') )
	end

      | elabPat(E, s, I.GuardPat(i, pat, exp)) =
	let
	    val (t1,pat') = elabPat(E, s, pat)
	    val (t2,exp') = elabExp(E, exp)
	    val  tb       = boolTyp E
	    val  _        = Type.unify(t2,tb) handle Type.Mismatch(t3,t4) =>
				error(i, E.GuardPatMismatch(t2, tb, t3, t4))
	in
	    ( t1, O.GuardPat(typInfo(i,t1), pat', exp') )
	end

      | elabPat(E, s, I.AnnPat(i, pat, typ)) =
	let
	    val (t1,pat') = elabPat(E, s, pat)
	    val (t2,typ') = elabStarTyp(E, true, typ)
	    val  _        = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.AnnPatMismatch(t1, t2, t3, t4))
	in
	    ( t2, O.AnnPat(typInfo(i,t2), pat', typ') )
	end

      | elabPat(E, s, I.WithPat(i, pat, decs)) =
	let
	    val (t,pat') = elabPat(E, s, pat)
	    val  decs'   = elabDecs(E, s, NONE, decs)
	in
	    ( t, O.WithPat(typInfo(i,t), pat', decs') )
	end


    and elabPats(E, s, pats) =
	VectorPair.unzip(Vector.map (fn pat => elabPat(E,s,pat)) pats)



  (* Type identifiers *)

    and elabVarid_bind'(E, k, c, (I.Id(i, stamp, name), eq)) =
	let
	    val k = if eq then Type.eqKind k else k
	    val a = Type.newVar(k,c)
	in
	    ( O.Id(varInfo(i,a), stamp, name), eq )
	end

    and elabVarid_bind(E, k, c, varid as (I.Id(i, stamp, name), eq)) =
	let
	    val k = if eq then Type.eqKind k else k
	    val a = Type.newVar(k,c)
	    val u = ref false
	    val _ = Env.insertVar(E, stamp, {id=(#1 varid), var=a, use=u})
	in
	    ( a, ( O.Id(varInfo(i,a), stamp, name), eq ) )
	end

    and elabVarid(E, (I.Id(i, stamp, name), eq)) =
	let
	    val {var=a, use, ...} = Env.lookupVar(E, stamp)
	in
	    use := true;
	    ( a, ( O.Id(varInfo(i,a), stamp, name), eq ) )
	end


    and elabTypid_bind(E, p, abbrev, t, typid as I.Id(i, stamp, name)) =
	let
	    val t' = if not abbrev then t else
		     Type.abbrev(Type.con(p, Type.kind t), t)
	    val u  = ref false
	    val _  = Env.insertTyp(E, stamp, {id=typid, path=p, typ=t', use=u})
	in
	    annots := (i, TypAnnot t) :: !annots;
	    ( t', O.Id(typInfo(i,t'), stamp, name) )
	end

    and elabTypid(E, I.Id(i, stamp, name)) =
	let
	    val {typ=t, path=p, use, ...} = Env.lookupTyp(E, stamp)
	in
	    use := true;
	    ( t, p, O.Id(typInfo(i,t), stamp, name) )
	end

    and elabTyplongid(E, I.ShortId(i, typid)) =
	let
	    val (t,_,typid') = elabTypid(E, typid)
	in
	    annots := (i, TypAnnot t) :: !annots;
	    ( t, O.ShortId(typInfo(i,t), typid') )
	end

      | elabTyplongid(E, I.LongId(i, modlongid, typlab)) =
	let
	    val (s,use,modlongid') = elabModlongid_sig(E, modlongid)
	    val (l,typlab')        = elabLab(E, typlab)
	    val  t                 = Inf.lookupTyp'(s, l)
	in
	    if not(UseEnv.isPartial use) then () else
		UseEnv.insertTyp(UseEnv.inner use, l);
	    annots := (i, TypAnnot t) :: !annots;
	    ( t, O.LongId(typInfo(i,t), modlongid', typlab') )
	end


  (* Kinds of types (without elaborating the full type) *)

    (* These are needed to elaborate recursive type bindings.
     * ASSUMPTION: under recursion we do not have higher-order bindings.
     * ASSUMPTION: type lambdas are first order.
     *)

    and elabTypKind(E, typ) =
	case elabTypKind'(E, typ)
	 of (k, false) => k
	  | (k, true)  => Type.eqKind k

    and elabTypKind'(E, I.FunTyp(i, varid, typ)) =
	let
	    val k1 = Type.starKind()
	    val (k2,eq) = elabTypKind'(E, typ)
	in
	    (Type.arrowKind(k1, k2), eq)
	end

      | elabTypKind'(E, I.ConTyp(i, typlongid)) =
	let
	    val (t,_) = elabTyplongid(E, typlongid)
	in
	    (Type.kind t, false)
	end

      | elabTypKind'(E, I.PrimTyp(i, s)) =
	let
	    val t = PervasiveType.lookup s handle PervasiveType.Lookup _ =>
			error(i, E.PervasiveTypUnknown s)
	in
	    (Type.kind t, false)
	end

      | elabTypKind'(E, I.VarTyp(i, varid)) =
	let
	    val (a,_) = elabVarid(E, varid)
	in
	    (Type.kindVar a, false)
	end

      | elabTypKind'(E, I.AppTyp(i, typ1, typ2)) =
	let
	    val (k,eq)  = elabTypKind'(E, typ1)
	    val (k1,k2) = Type.asArrowKind k handle Type.Kind =>
				error(i, E.AppTypFunKind(k))
	in
	    (k2, false)
	end

      | elabTypKind'(E, I.AbsTyp(i, eq, isExt)) =
	let
	    val k = if isExt then Type.extKind() else Type.starKind()
	in
	    case eq
	     of NONE       => (k, false)
	      | SOME false => (Type.eqKind k, false)
	      | SOME true  => (k, true)
	end

      | elabTypKind'(E, _) =
	    (Type.starKind(), false)


  (* Types *)

    and elabTyp(E, typ) = elabTyp'(E, false, typ)

    and elabTyp'(E, allowJok, I.JokTyp(i)) =
	let
	    val t = Type.unknown(Type.starKind())
	in
	    annots := (i, TypAnnot t) :: !annots;
	    if allowJok
	    then ( t, O.JokTyp(typInfo(i,t)) )
	    else error(i, E.JokTyp)
	end

      | elabTyp'(E, allowJok, I.VarTyp(i, varid)) =
	let
	    val (a,varid') = elabVarid(E, varid)
	    val  t         = Type.var a
	in
	    ( t, O.VarTyp(typInfo(i,t), varid') )
	end

      | elabTyp'(E, allowJok, I.PrimTyp(i, s))=
	let
	    val t = PervasiveType.lookup s handle PervasiveType.Lookup _ =>
			error(i, E.PervasiveTypUnknown s)
	in
	    ( t, O.PrimTyp(typInfo(i,t), s) )
	end

      | elabTyp'(E, allowJok, I.ConTyp(i, typlongid)) =
	let
	    val (t,typlongid') = elabTyplongid(E, typlongid)
	in
	    ( t, O.ConTyp(typInfo(i,t), typlongid') )
	end

      | elabTyp'(E, allowJok, I.FunTyp(i, varid, typ)) =
	let
	    val (a,varid') = elabVarid_bind(E, Type.starKind(),
					       Type.Unconstrained, varid)
	    val (t1,typ')  = elabTyp'(E, allowJok, typ)
	    val  t         = Type.lambda(a,t1)
	in
	    ( t, O.FunTyp(typInfo(i,t), varid', typ') )
	end

      | elabTyp'(E, allowJok, I.AppTyp(i, typ1, typ2)) =
	let
	    val (t1,typ1') = elabTyp'(E, allowJok, typ1)
	    val (t2,typ2') = elabTyp'(E, allowJok, typ2)
	    val  k1        = Type.kind t1
	    val (k11,k12)  = Type.asArrowKind k1 handle Type.Kind =>
				error(i, E.AppTypFunKind(k1))
	    val  t         = Type.apply(t1,t2) handle Type.Kind =>
				error(i, E.AppTypArgKind(k11, Type.kind t2))
	in
	    ( t, O.AppTyp(typInfo(i,t), typ1', typ2') )
	end

      | elabTyp'(E, allowJok, I.TupTyp(i, typs)) =
	let
	    val (ts,typs') = elabStarTyps(E, allowJok, typs)
	    val  t         = Type.tuple ts
	in
	    ( t, O.TupTyp(typInfo(i,t), typs') )
	end

      | elabTyp'(E, allowJok, I.ProdTyp(i, typrow)) =
	let
	    val (r,typrow') = elabRow(fn(E,t) => elabStarTyp(E, allowJok, t),
				      I.infoTyp, E, typrow)
	    val  t          = Type.prod r
	in
	    ( t, O.ProdTyp(typInfo(i,t), typrow') )
	end

      | elabTyp'(E, allowJok, I.SumTyp(i, typrow)) =
	let
	    val (r,typrow') = elabRow(fn(E,t) => elabStarTyp(E, allowJok, t),
				      I.infoTyp, E, typrow)
	    val  t          = Type.sum r
	in
	    ( t, O.SumTyp(typInfo(i,t), typrow') )
	end

      | elabTyp'(E, allowJok, I.ArrTyp(i, typ1, typ2)) =
	let
	    val (t1,typ1') = elabStarTyp(E, allowJok, typ1)
	    val (t2,typ2') = elabStarTyp(E, allowJok, typ2)
	    val  t         = Type.arrow(t1,t2)
	in
	    ( t, O.ArrTyp(typInfo(i,t), typ1', typ2') )
	end

      | elabTyp'(E, allowJok, I.AllTyp(i, varid, typ)) =
	let
	    val (a,varid') = elabVarid_bind(E, Type.starKind(),
					       Type.Unconstrained, varid)
	    val (t1,typ')  = elabStarTyp(E, allowJok, typ)
	    val  t         = Type.all(a,t1)
	in
	    ( t, O.AllTyp(typInfo(i,t), varid', typ') )
	end

      | elabTyp'(E, allowJok, I.ExTyp(i, varid, typ)) =
	let
	    val (a,varid') = elabVarid_bind(E, Type.starKind(),
					       Type.Unconstrained, varid)
	    val (t1,typ')  = elabStarTyp(E, allowJok, typ)
	    val  t         = Type.exist(a,t1)
	in
	    ( t, O.ExTyp(typInfo(i,t), varid', typ') )
	end

      | elabTyp'(E, allowJok, I.SingTyp(i, vallongid)) =
	let
	    val (t,vallongid') = elabVallongid(E, vallongid)
	in
	    ( t, O.SingTyp(typInfo(i,t), vallongid') )
	end

      | elabTyp'(E, allowJok, I.AbsTyp _) =
	raise Crash.Crash "Elab.elabTyp: AbsTyp"


  (* Types in positions where they may not be higher order *)

    and elabStarTyp(E, allowJok, typ) =
	let
	    val ttyp' as (t,typ') = elabTyp'(E, allowJok, typ)
	    val k                 = Type.kind t
	in
	    if Type.isStarKind k
	    then ttyp'
	    else error(I.infoTyp typ, E.StarTypKind(k))
	end

    and elabStarTyps(E, allowJok, typs) =
	VectorPair.unzip(Vector.map (fn typ=> elabStarTyp(E,allowJok,typ)) typs)



  (* Type representations (RHSs of type bindings) *)

    and elabTypRep(E, p, mkKind, I.FunTyp(i, varid, typ)) =
	let
	    val  k            = Type.starKind()
	    val (a,varid')    = elabVarid_bind(E, k, Type.Unconstrained, varid)
	    val (t1,gen,typ') = elabTypRep(E, p,
				     fn k' => mkKind(Type.arrowKind(k,k')), typ)
            val  t            = if gen then t1 else Type.lambda(a,t1)
				   (* If the type is generative then we
				    * get a constructor with appropriate kind
				    * and do not need to insert lambdas.
				    *)
	in
	    ( t, gen, O.FunTyp(typInfo(i,t), varid', typ') )
	end

      | elabTypRep(E, p, mkKind, I.AbsTyp(i, eq, isExt)) =
	let
	    val k0 = (if isExt then Type.extKind else Type.starKind)()
	    val k  = case eq of NONE       => mkKind k0
			      | SOME false => mkKind(Type.eqKind k0)
			      | SOME true  => Type.eqKind(mkKind k0)
	    val t  = Type.con(p, k)
	in
	    ( t, true, O.AbsTyp(typInfo(i,t), eq, isExt) )
	end

      | elabTypRep(E, p, mkKind, typ) =
	let
	    val (t,typ') = elabTyp(E, typ)
	in
	    ( t, false, typ' )
	end


  (* Module identifiers *)

    and elabModid_bind(E, p, doSingleton, j, modid as I.Id(i, stamp, name)) =
	let
(*DEBUG
val _ = (
TextIO.print("elabModid_bind " ^ Name.toString name ^ ":");
prInf "j" j;
())
*)
	    val j' = Future.byneed(fn() => Inf.sing(Inf.mod(p,j)))
	    val u  = ref(if name = PervasiveType.name_pervasive
			 then UseEnv.FULL
			 else UseEnv.PARTIAL(UseEnv.env()))
	    val _  = Env.insertMod(E, stamp, {id=modid, path=p, inf=j', use=u})
	in
	    (* EXPERIMENTAL: make arguments non-generative
	    if doSingleton then () else Path.hide p; *)
	    annots := (i, ModAnnot j) :: !annots;
	    ( j, O.Id(infInfo(i,j'), stamp, name) )
	end

    and elabModid(E, I.Id(i, stamp, name)) =
	let
	    val {inf=j, use, ...} = Env.lookupMod(E, stamp)
	in
	    ( j, use, O.Id(infInfo(i,j), stamp, name) )
	end

    and elabModlongid(E, I.ShortId(i, modid)) =
	let
	    val (j,use,modid') = elabModid(E, modid)
	in
	    use := UseEnv.FULL;
	    annots := (i, ModAnnot j) :: !annots;
	    ( j, O.ShortId(infInfo(i,j), modid') )
	end

      | elabModlongid(E, I.LongId(i, modlongid, modlab)) =
	let
	    val (s,use,modlongid') = elabModlongid_sig(E, modlongid)
	    val (l,modlab')        = elabLab(E, modlab)
	    val  j                 = Inf.sing(Inf.lookupMod'(s, l))
	in
	    if not(UseEnv.isPartial use) then () else
		UseEnv.insertMod(UseEnv.inner use, l, UseEnv.FULL);
	    annots := (i, ModAnnot j) :: !annots;
	    ( j, O.LongId(infInfo(i,j), modlongid', modlab') )
	end

    and elabModlongid_sig(E, modlongid as I.ShortId(i, modid)) =
	let
	    val (j,use,modid') = elabModid(E, modid)
	    val  s             = Inf.asSig j handle Inf.Interface =>
					error(i, E.ModlongidInf(modlongid, j))
	in
	    ( s, !use, O.ShortId(infInfo(i,j), modid') )
	end

      | elabModlongid_sig(E, modlongid0 as I.LongId(i, modlongid, modlab)) =
	let
	    val (s,use,modlongid') = elabModlongid_sig(E, modlongid)
	    val (l,modlab')        = elabLab(E, modlab)
	    val  j                 = Inf.sing(Inf.lookupMod'(s, l))
	    val  s                 = Inf.asSig j handle Inf.Interface =>
					error(i, E.ModlongidInf(modlongid0, j))
	    val use' =
		case use
		  of UseEnv.FULL => use
		   | UseEnv.PARTIAL UE =>
		case UseEnv.lookupMod(UE,l)
		  of SOME use' => use'
		   | NONE =>
		     let val use' = UseEnv.PARTIAL(UseEnv.env())
		     in UseEnv.insertMod(UE, l, use') ; use' end
	in
	    ( s, use', O.LongId(infInfo(i,j), modlongid', modlab') )
	end


  (* Modules *)

    and elabMod(E, po, I.PrimMod(i, s, inf)) =
	let
	    val  p       = case po of SOME p => p | NONE => Path.fromString s
	    val (j,inf') = elabGroundInf(E, SOME p, inf)
	in
	    ( j, O.PrimMod(infInfo(i,j), s, inf') )
	end

      | elabMod(E, po, I.VarMod(i, modlongid)) =
	let
	    val (j,modlongid') = elabModlongid(E, modlongid)
	in
	    ( j, O.VarMod(infInfo(i,j), modlongid') )
	end

      | elabMod(E, po, I.StrMod(i, decs)) =
	let
	    val s     = Inf.emptySig()
	    val decs' = elabDecs(E, s,po, decs)
(*UNFINISHED: results in incomplete type inference
	    val _     = Inf.close s handle Inf.Unclosed lt =>
			    error(i, E.StrModUnclosed lt)
*)
	    val j     = Inf.sign(Inf.avoidHidden s)
(*DEBUG
val _ =(TextIO.print "ElabMod StrMod:\n";
prInf "s1" (Inf.sign s);
prInf "s2" j;
())
*)
	in
	    (*
	    annots := (Source.span(i, Source.at(I.infoDec(Vector.sub(decs,0))))
		       handle Subscript => i,
		       ModAnnot j) :: !annots;
	    *)
	    ( j, O.StrMod(infInfo(i,j), decs') )
	end

      | elabMod(E, po, I.SelMod(i, modlab, mod)) =
	let
	    val (l,modlab') = elabLab(E, modlab)
	    val (j1,mod')   = elabMod(E, po, mod)
	    val  s          = Inf.asSig j1 handle Inf.Interface =>
				error(I.infoMod mod, E.SelModInf j1)
	    val  j          = Inf.sing(Inf.lookupMod'(s, l))
	in
	    ( j, O.SelMod(infInfo(i,j), modlab', mod') )
	end

      | elabMod(E, po, I.FunMod(i, modid, inf, mod)) =
	let
	    val  _           = Env.insertScope E
	    val  p           = elabNewPath(NONE, I.name modid)
	    val (j1,inf')    = elabGroundInf(E, SOME p, inf)
	    val (j1',modid') = elabModid_bind(E, p, false, j1, modid)
	    val (j2,mod')    = elabMod(E, NONE, mod)
	    val  _           = Env.removeScope E
	    val  j           = Inf.arrow(p, j1', j2)
	in
(*DEBUG
TextIO.print "ElabMod FunMod:\n";
prInf "j" j;
*)
	    annots := (Source.span(i, Source.at(I.infoId modid)),
		       ModAnnot j) :: !annots;
	    ( j, O.FunMod(infInfo(i,j), modid', inf', mod') )
	end

      | elabMod(E, po, I.AppMod(i, mod1, mod2)) =
	let
	    val (j1,mod1')  = elabMod(E, NONE, mod1)
	    val (m2,mod2')  = elabMod'(E, mod2)
	    val (p2,j2)     = Inf.asMod m2
	    val (p,j11,j12) = Inf.asArrow j1 handle Inf.Interface =>
				error(I.infoMod mod1, E.AppModFunMismatch j1)
(*DEBUG
val _ = (
TextIO.print "elabMod AppMod: matching...\n";
prInf "j_arg" j2;
prInf "j_param" j11;
())
*)
	    val  _          = Type.enterLevel()
	    val  rea        = Inf.match(j2,j11) handle Inf.Mismatch mismatch =>
(*DEBUG
(TextIO.print "elabMod AppMod: mismatch\n";
prInf "j2" j2;
prInf "j11" j11;
*)
				error(i, E.AppModArgMismatch mismatch)
	    val  _          = Type.exitLevel()
	    val  _          = PathMap.insertDisjoint(#mod_rea rea, p,
						     Inf.narrowMod(m2,j11))
(*DEBUG
handle e =>
(TextIO.print "elabMod AppMod: mismatch narrowing:\n";
prInf "j2" j2;
prInf "j11" j11;
raise e)
*)
	    val  j'         = Inf.realise(rea, j12)
	    val  j          = case po of NONE   => j'
				       | SOME p => #1(Inf.instance(p,j'))
	in
(*DEBUG
TextIO.print "ElabMod AppMod:\n";
prInf "j" j;
*)
	    ( j, O.AppMod(infInfo(i,j), mod1', mod2') )
	end

      | elabMod(E, po, I.AnnMod(i, mod, inf)) =
	let
	    val (j1,mod') = elabMod(E, po, mod)
	    val (j2,inf') = elabGroundInf(E, NONE, inf)
	    val  _        = Type.enterLevel()
	    val  _        = Inf.match(j1,j2) handle Inf.Mismatch mismatch =>
				error(i, E.AnnModMismatch mismatch)
	    val  _        = Type.exitLevel()
	    val  j        = Inf.narrow(j1,j2)
	    val  j'       = case Inf.inspect j
			     of Inf.Sig s => Inf.sign(Inf.avoidHidden s)
			      | _ => j
(*DEBUG*) handle e => raise e
	in
(*DEBUG
TextIO.print "ElabMod AnnMod:\n";
prInf "j1" j1;
prInf "j2" j2;
prInf "j" j;
prInf "j'" j';
*)
	    ( j', O.AnnMod(infInfo(i,j'), mod', inf') )
	end

      | elabMod(E, po, I.SealMod(i, mod, inf)) =
	let
	    val (j1,mod') = elabMod(E, NONE, mod)
	    val (j2,inf') = elabGroundInf(E, po, inf)
	    val  _        = Type.enterLevel()
	    val  _        = Inf.match(j1,j2) handle Inf.Mismatch mismatch =>
				error(i, E.AnnModMismatch mismatch)
	    val  _        = Type.exitLevel()
	    val  j        = j2
(*DEBUG
val _ = (
TextIO.print "ElabMod SealMod:\n";
prInf "j1" j1;
prInf "j2" j2;
())
*)
	in
	    ( j, O.SealMod(infInfo(i,j), mod', inf') )
	end

      | elabMod(E, po, I.LazyMod(i, mod)) =
	let
	    val (j,mod') = elabMod(E, po, mod)
	in
	    ( j, O.LazyMod(infInfo(i,j), mod') )
	end

      | elabMod(E, po, I.SpawnMod(i, mod)) =
	let
	    val (j,mod') = elabMod(E, po, mod)
	in
	    ( j, O.SpawnMod(infInfo(i,j), mod') )
	end

      | elabMod(E, po, I.LetMod(i, decs, mod)) =
	let
	    val  _        = Env.insertScope E
	    val  p        = Path.fromString localName
	    val  s        = Inf.emptySig()
	    val  decs'    = elabDecs(E, s, SOME p, decs)
	    val  j1       = Inf.sign s
	    val (j2,mod') = elabMod(E, po, mod)
	    val  _        = Env.removeScope E
	    val  j        = Inf.exist(p,j1,j2)
(*DEBUG
val _ = (
TextIO.print "ElabMod LetMod:\n";
prPath "p" p;
prInf "j1" j1;
prInf "j2" j2;
prPaths "paths j2" (Inf.paths j2);
prInf "j" j;
())
*)
	in
	    annots := (Source.span(i, Source.at(I.infoDec(Vector.sub(decs,0))
						handle Subscript => I.infoMod mod)),
		       ModAnnot j) :: !annots;
	    ( j, O.LetMod(infInfo(i,j), decs', mod') )
	end

      | elabMod(E, po, I.UnpackMod(i, exp, inf)) =
	let
	    val (t,exp') = elabExp(E, exp)
	    val (j,inf') = elabInf(E, po, inf)
	    val  t2      = PervasiveType.typ_package
	    val  _       = Type.unify(t,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.UnpackModMismatch(t,t2, t3,t4))
	in
	    ( j, O.UnpackMod(infInfo(i,j), exp', inf') )
	end


  (* Modules without external path *)

    and elabMod'(E, mod) =
	let
	    val  p       = Path.fromString localName
	    val (j,mod') = elabMod(E, SOME p, mod)
	    val  m       = if Inf.isSing j then Inf.asSing j
			   else Inf.mod(p,j)
	in
	    (m,mod')
	end


  (* Interface identifiers *)

    and elabInfid_bind(E, p, abbrev, j, infid as I.Id(i, stamp, name)) =
	let
	    val j' = if not abbrev then j else
		     Future.byneed(fn() => Inf.abbrev(Inf.con(p,Inf.kind j), j))
	    val u  = ref false
	    val _  = Env.insertInf(E, stamp, {id=infid, path=p, inf=j', use=u})
	in
	    annots := (i, InfAnnot j) :: !annots;
	    ( j', O.Id(infInfo(i,j'), stamp, name) )
	end

    and elabInfid(E, I.Id(i, stamp, name)) =
	let
	    val {inf=j, use, ...} = Env.lookupInf(E, stamp)
	in
	    use := true;
	    ( j, O.Id(infInfo(i,j), stamp, name) )
	end

    and elabInflongid(E, I.ShortId(i, infid)) =
	let
	    val (j,infid') = elabInfid(E, infid)
	in
	    annots := (i, InfAnnot j) :: !annots;
	    ( j, O.ShortId(infInfo(i,j), infid') )
	end

      | elabInflongid(E, I.LongId(i, modlongid, inflab)) =
	let
	    val (s,use,modlongid') = elabModlongid_sig(E, modlongid)
	    val (l,inflab')        = elabLab(E, inflab)
	    val  j                 = Inf.lookupInf'(s, l)
	in
	    if not(UseEnv.isPartial use) then () else
		UseEnv.insertInf(UseEnv.inner use, l);
	    annots := (i, InfAnnot j) :: !annots;
	    ( j, O.LongId(infInfo(i,j), modlongid', inflab') )
	end


  (* Interfaces *)

    and elabInf(E, po, I.TopInf(i)) =
	let
	    val j = Inf.top()
	in
	    ( j, O.TopInf(infInfo(i,j)) )
	end

      | elabInf(E, po, I.PrimInf(i, s)) =
	let
	    (* No pervasive interfaces yet... *)
	    val j = (*PervasiveInf.lookup s handle PervasiveInf.Lookup _ =>*)
			error(i, E.PervasiveInfUnknown s)
	in
	    ( j, O.PrimInf(infInfo(i,j), s) )
	end

      | elabInf(E, po, I.ConInf(i, inflongid)) =
	let
	    val (j',inflongid') = elabInflongid(E, inflongid)
	    val  j              = case po of NONE   => j'
					   | SOME p => #1(Inf.instance(p,j'))
(*DEBUG
val _ = (
TextIO.print "elabInf ConInf: j =\n";
PrettyPrint.output(TextIO.stdOut, PPInf.ppInf j, 80);
TextIO.print "\n";
())
*)
	in
	    ( j, O.ConInf(infInfo(i,j), inflongid') )
	end

      | elabInf(E, po, I.SigInf(i, specs)) =
	let
	    val s      = Inf.emptySig()
	    val specs' = elabSpecs(E, s,po, specs)
	    val j      = Inf.sign s
	in
	    ( j, O.SigInf(infInfo(i,j), specs') )
	end

      | elabInf(E, po, I.ArrInf(i, modid, inf1, inf2)) =
	let
	    val  _           = Env.insertScope E
	    val  p           = elabNewPath(NONE, I.name modid)
	    val (j1,inf1')   = elabGroundInf(E, SOME p, inf1)
	    val (j1',modid') = elabModid_bind(E, p, false, j1, modid)
	    val (j2,inf2')   = elabGroundInf(E, NONE, inf2)
	    val  _           = Env.removeScope E
	    val  j           = Inf.arrow(p, j1', j2)
	in
	    ( j, O.ArrInf(infInfo(i,j), modid', inf1', inf2') )
	end

      | elabInf(E, po, I.FunInf(i, modid, inf1, inf2)) =
	let
	    val  _           = Env.insertScope E
	    val  p           = elabNewPath(NONE, I.name modid)
	    val (j1,inf1')   = elabGroundInf(E, SOME p, inf1)
	    val (j1',modid') = elabModid_bind(E, p, false, j1, modid)
	    val (j2,inf2')   = elabInf(E, NONE, inf2)
	    val  _           = Env.removeScope E
	    val  j           = Inf.lambda(p, j1', j2)
	in
	    ( j, O.FunInf(infInfo(i,j), modid', inf1', inf2') )
	end

      | elabInf(E, po, I.AppInf(i, inf, mod)) =
	let
	    val (j1,inf')   = elabInf(E, NONE, inf)
	    val (m2,mod')   = elabMod'(E, mod)
	    val (p2,j2)     = Inf.asMod m2
	    val (p,j11,k12) = Inf.asDepKind(Inf.kind j1) handle Inf.Interface =>
				error(I.infoMod mod, E.AppInfFunMismatch j1)
	    val  _          = Type.enterLevel()
	    val  _          = Inf.match(j2,j11) handle Inf.Mismatch mismatch =>
				error(i, E.AppInfArgMismatch mismatch)
	    val  _          = Type.exitLevel()
	    val  j'         = Inf.apply(j1,m2)
	    val  j          = case po of NONE   => j'
				       | SOME p => #1(Inf.instance(p,j'))
	in
	    ( j, O.AppInf(infInfo(i,j), inf', mod') )
	end

      | elabInf(E, po, I.InterInf(i, inf1, inf2)) =
	let
	    val (j1,inf1') = elabGroundInf(E, po, inf1)
	    val (j2,inf2') = elabGroundInf(E, po, inf2)
	    val  j         = Inf.infimum(j1,j2) handle Inf.Mismatch mismatch =>
				error(i, E.InterInfMismatch mismatch)
	in
	    ( j, O.InterInf(infInfo(i,j), inf1', inf2') )
	end

      | elabInf(E, po, I.LetInf(i, decs, inf)) =
	let
	    val  _        = Env.insertScope E
	    val  p        = Path.fromString localName
	    val  s        = Inf.emptySig()
	    val  decs'    = elabDecs(E, s, SOME p, decs)
	    val  j1       = Inf.sign s
	    val (j2,inf') = elabInf(E, po, inf)
	    val  _        = Env.removeScope E
	    val  j        = Inf.exist(p,j1,j2)	(* maximises *)
	    val  _        = if not(Inf.isExist j) then () else
				error(i, E.LetInfGenerative(#2(Inf.asExist j)))
	in
	    ( j, O.LetInf(infInfo(i,j), decs', inf') )
	end

      | elabInf(E, po, I.SingInf(i, mod)) =
	let
	    val (j,mod') = elabMod(E, po, mod)
	    val  _       = if Inf.isSing j andalso
			      (* EXPERIMENTAL: make arguments non-generative *)
			      not(Path.isHidden(#1(Inf.asMod(Inf.asSing j))))
			   then () else error(i, E.SingInfNonSing j)
	in
	    ( j, O.SingInf(infInfo(i,j), mod') )
	end

      | elabInf(E, po, I.AbsInf _) =
	    raise Crash.Crash "Elab.elabInf: AbsInf"

  (* Interfaces in positions where they not may be higher order *)

    and elabGroundInf(E, po, inf) =
	let
	    val (j,inf') = elabInf(E, po, inf)
	    val  k       = Inf.kind j
	in
	    if Inf.isGroundKind k
	    then (j,inf')
	    else error(I.infoInf inf, E.GroundInfKind(k))
	end


  (* Interfaces representations (RHSs of bindings) *)

    and elabInfRep(E, p, mkKind, I.FunInf(i, modid, inf1, inf2)) =
	let
	    val  _             = Env.insertScope E
	    val  p'            = elabNewPath(NONE, I.name modid)
	    val (j1,inf1')     = elabGroundInf(E, SOME p', inf1)
	    val (j1',modid')   = elabModid_bind(E, p', false, j1, modid)
	    val (j2,gen,inf2') = elabInfRep(E, p,
				     fn k => mkKind(Inf.depKind(p',j1,k)),
				     inf2)
	    val  _             = Env.removeScope E
	    val  j             = if gen then j2 else Inf.lambda(p', j1', j2)
				   (* If interface is generative we get back
				    * a constructor with appropriate kind
				    * and do not need to insert lambdas.
				    *)
	in
	    ( j, gen, O.FunInf(infInfo(i,j), modid', inf1', inf2') )
	end

      | elabInfRep(E, p, mkKind, I.AbsInf(i)) =
	let
	    val j = Inf.con(p, mkKind(Inf.groundKind()))
	in
	    ( j, true, O.AbsInf(infInfo(i,j)) )
	end

      | elabInfRep(E, p, mkKind, I.ConInf(i, inflongid)) =
	(* avoid instantiation for mere rebindings *)
	let
	    val (j,inflongid') = elabInflongid(E, inflongid)
	in
	    ( j, false, O.ConInf(infInfo(i,j), inflongid') )
	end

      | elabInfRep(E, p, mkKind, inf) =
	let
	    val (j,inf') = elabInf(E, NONE, inf)
	in
	    ( j, false, inf' )
	end


  (* Declarations *)

    and elabNewPath(NONE,   name) = Path.name name
      | elabNewPath(SOME p, name) = Path.dot(p, Label.fromName name)

    and elabDecs(E, s, po, decs)          = elabDecs'(E, s, po, [], decs)
    and elabDecs'(E, s, po, varids, decs) =
	    Vector.map (fn dec => elabDec(E, s, po, varids, dec)) decs

    and elabDec(E, s,po,varids, I.FixDec(i, vallab, fix)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (f,fix')    = elabFix(E, fix)
	    val  _          = Inf.extendFix(s, l, f)
	in
	    O.FixDec(nonInfo(i), vallab', fix')
	end

      | elabDec(E, s,po,varids, I.ValDec(i, I.VarPat(i1, valid),
					    I.VarExp(i2, vallongid))) =
	let
	    (* Keep full polymorphism (esp. wrt overloading!) *)
	    val (t1,qt1,valid') = elabValid_bind(E, s, valid)
	    val (t2,vallongid') = elabVallongid(E, vallongid)
	    val  qt2            = case vallongid'
				    of (O.ShortId(i,_) | O.LongId(i,_,_)) =>
					  #typ i
	    val  _              = Type.unify(t1, Type.rename t2)
	    val  _              = Type.unify(qt1, Type.rename qt2)
	    val  pat'           = O.VarPat(typInfo(i,t1), valid')
	    val  exp'           = O.VarExp(typInfo(i,t2), vallongid')
	    val  l              = Label.fromName(I.name valid)
	    val  _              = Inf.extendVal(s, l, qt1)
	in
	    O.ValDec(nonInfo(i), pat', exp')
	end

      | elabDec(E, s,po,varids, I.ValDec(i, pat, exp)) =
	let
	    val  _        = Env.insertScope E
	    val  _        = Type.enterLevel()
	    val  az       = enterVarids(E, varids)
	    val  _        = Env.insertScope E
	    val (t2,exp') = elabExp(E, exp)
	    val  _        = Env.removeScope E
	    val (t1,pat') = elabPat(E, s, pat)
	    val  _        = Type.exitLevel()
	    val  E'       = Env.splitScope E
	    val  _        = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.ValDecMismatch(t1, t2, t3, t4))
	    val  _        = if I.isValue exp then generaliseVals(i,E, s, az, E')
					     else liftVals(E, s, az, E')
	in
	    O.ValDec(nonInfo(i), pat', exp')
	end

      | elabDec(E, s,po,varids, I.TypDec(i, typid, typ)) =
	let
	    val abbrev = (case typ of I.ConTyp(_,I.ShortId(_,typid')) =>
				     I.name typid' <> I.name typid
				   | I.PrimTyp _ => false
				   | _ => true) andalso nonlocalPath po
	    val  p           = elabNewPath(po, I.name typid)
	    val (t,gen,typ') = elabTypRep(E, p, Fn.id, typ)
	    val (t',typid')  = elabTypid_bind(E, p, abbrev, t, typid)
	    val  k           = (if gen then Type.kind else Type.singKind) t'
	    val  _           = Inf.extendTyp(s, p, k)
	in
(*DEBUG
print("{"^(if Type.isEqKind k then "eq" else "")^"type "^Name.toString(I.name typid)^"}\n");
*)
	    O.TypDec(nonInfo(i), typid', typ')
	end

      | elabDec(E, s,po,varids, I.ModDec(i, modid, mod)) =
	let
	    val  p          = elabNewPath(po, I.name modid)
	    val (j,mod')    = elabMod(E, SOME p, mod)
	    val (j',modid') = elabModid_bind(E, p, true, j, modid)
(*DEBUG
val _ = (
TextIO.print("elabDec ModDec:\n";
prPath "p" p;
prInf "j'" j';
())
*)
	    val  _          = Inf.extendMod(s, p, j')
	in
	    O.ModDec(nonInfo(i), modid', mod')
	end

      | elabDec(E, s,po,varids, I.InfDec(i, infid, inf)) =
	let
	    val abbrev = (case inf of I.ConInf(_,I.ShortId(_,infid')) =>
				     I.name infid' <> I.name infid
				   | I.PrimInf _ => false
				   | _ => true) andalso nonlocalPath po
	    val  p           = elabNewPath(po, I.name infid)
	    val (j,gen,inf') = elabInfRep(E, p, Fn.id, inf)
	    val (j',infid')  = elabInfid_bind(E, p, abbrev, j, infid)
	    val  k           = Future.byneed(fn() =>
			       (if gen then Inf.kind else Inf.singKind) j')
	    val  _           = Inf.extendInf(s, p, k)
(*DEBUG
val _ = (
TextIO.print("elabDec InfDec:\n";
prPath "p" p;
prInf "j'" j';
())
*)
	in
	    O.InfDec(nonInfo(i), infid', inf')
	end

      | elabDec(E, s,po,varids, I.VarDec(i, varid, dec)) =
	let
	    val varid'  = elabVarid_bind'(E, Type.starKind(),
					     Type.Unconstrained, varid)
	    val dec'    = elabDec(E, s,po,varid::varids, dec)
	in
	    O.VarDec(nonInfo(i), varid', dec')
	end

      | elabDec(E, s,po,varids, I.RecDec(i, decs)) =
	let
	    val _      = Env.insertScope E
	    val _      = Type.enterLevel()
	    val az     = enterVarids(E, varids)
	    val tpats' = elabLHSRecDecs(E, s,po, decs)
	    val (decs',eqs) = elabRHSRecDecs(E, s, ref tpats', decs)
	    val _      = Type.fix eqs
	    val _      = Type.exitLevel()
	    val E'     = Env.splitScope E
	    (* ASSUME that only ValDec or TypDec are under RecDec *)
	    (* ASSUME that recursive ValDecs are never expansive *)
	    val _      = Env.appTyps (fn(x,entry)=> Env.insertTyp(E,x,entry)) E'
(*DEBUG
val _ = Env.appTyps (fn(x,entry as {id,typ,...})=> 
let val k = Type.kind typ in
print("{"^(if Type.isEqKind k then "eq" else "")^"type "^Name.toString(I.name id)^"}\n");
Env.insertTyp(E,x,entry)end) E'
*)
	    val _      = generaliseVals(i, E, s, az, E')
	in
	    O.RecDec(nonInfo(i), decs')
	end

      | elabDec(E, s,po,varids, I.LocalDec(i, decs)) =
	let
	    val p'     = Path.fromString localName
	    val s'     = Inf.emptySig()
	    val decs'  = elabDecs(E, s', SOME p', decs)
	    val s''    = Inf.emptySig()
	in
	    List.appr (fn item => case Inf.inspectItem item
		       of Inf.TypItem(p,k) =>
			  if Type.isSingKind k then ()
			  else Inf.extendTyp(s'',p,k)
			| Inf.ModItem(p,j) =>
			  if Inf.isSing j then ()
			  else Inf.extendMod(s'',p,j)
			| Inf.InfItem(p,k) =>
			  if Inf.isSingKind k then ()
			  else Inf.extendInf(s'',p,k)
			| _ => ()
		      ) (Inf.items s');
	    if List.null(Inf.items s'') then ()
	    else Inf.extendHiddenMod(s, p', Inf.sign s'');
	    O.LocalDec(nonInfo(i), decs')
	end

    and enterVarids(E, varids) =
	List.map (fn varid as (I.Id(_, stamp, name), eq) =>
		  let
		      val k = Type.starKind()
		      val k = if eq then Type.eqKind k else k
		      val a = Type.newVar(k, Type.Unconstrained)
		  in
		      Env.insertVar(E,stamp, {id=(#1 varid), var=a, use=ref false});
		      a
		  end
		 ) varids

    and monomorphiseVals E =
	Env.appVals (fn(x, entry as {typ=t, qtyp=qt, ...}) =>
			Type.unify(qt,t) handle Type.Mismatch _ => ()) E
			(* may already be generalised through WithPat *)

    and liftVals(E, s, az, E') =
	Env.appVals (fn(x, entry as {id=id, typ=t, qtyp, ...}) =>
		     let
			val l  = Label.fromName(I.name id)
		     in
			Type.lift t handle Type.Lift a =>
			    error(I.infoId id, E.ValDecLift(id, a));
			Type.unify(qtyp,t) handle Type.Mismatch _ => ();
			    (* may already be generalised through WithPat *)
			Env.insertVal(E, x, entry);
			Inf.extendVal(s, l, t)
		     end
		    ) E'

    and generaliseVals(i, E, s, az, E') =
	let
	    val xes = Env.foldVals (fn(x,e,xes) => (x,e)::xes) [] E'
	    val ts  = List.map (#typ o #2) xes
	    val ts' = Type.close ts handle Type.Close t =>
			error(i, E.ValDecUnclosed t)
	in
	    ListPair.app (fn((x, {id=id, use=u, qtyp=qt, ...}), t) =>
			  let
			     val l  = Label.fromName(I.name id)
			     val t' = List.foldl Type.all t az
			  in
			     Type.unify(qt,t') handle Type.Mismatch _ => ();
			     (* may already be generalised through WithPat *)
			     Env.insertVal(E, x, {id=id,use=u, typ=t',qtyp=t'});
			     Inf.extendVal(s, l, t')
			  end
			 ) (xes,ts')
	end


  (* Recursive declarations *)

    and elabLHSRecDecs(E, s,po, decs) =
	    Vector.foldr (fn(dec,xs) => elabLHSRecDec(E,s,po,dec) @ xs) [] decs

    and elabLHSRecDec(E, s,po, I.ValDec(i, pat, exp)) =
	    [elabPat(E, s, pat)]

      | elabLHSRecDec(E, s,po, I.TypDec(i, typid, typ)) =
	let
	    val p = elabNewPath(po, I.name typid)
	    val k = elabTypKind(E, typ)
	    val t = Type.unknown k
	    val _ = elabTypid_bind(E, p, true, t, typid)
	in
	    []
	end

      | elabLHSRecDec(E, s,po, I.RecDec(i, decs)) =
	    elabLHSRecDecs(E, s,po, decs)

      | elabLHSRecDec(E, s,po, _) = raise Crash.Crash "elabLHSRecDec"


    and elabRHSRecDecs(E, s, rtpats', decs) =
	let
	    val (decs',ttss) =
		VectorPair.unzip
		 (Vector.map (fn dec => elabRHSRecDec(E, s, rtpats', dec)) decs)
	in
	    ( decs', Vector.fromList(Vector.foldl op@ [] ttss) )
	end

    and elabRHSRecDec(E, s, r as ref((t1,pat')::tpats'), I.ValDec(i, pat, exp))=
	let
	    val  _        = Env.insertScope E
	    val (t2,exp') = elabExp(E, exp)
	    val  _        = Env.removeScope E
	    val  _        = r := tpats'
	    val  _        = Type.unify(t1,t2) handle Type.Mismatch(t3,t4) =>
				error(i, E.ValDecMismatch(t1, t2, t3, t4))
	    val  _        = if I.isValue exp then () else
				error(I.infoExp exp, E.RecValDecNonValue)
	in
	    ( O.ValDec(nonInfo(i), pat', exp'), [] )
	end

      | elabRHSRecDec(E, s, rtpats', I.TypDec(i, typid, typ)) =
	let
	    val (t0,p,typid') = elabTypid(E, typid)
	    val (t,gen,typ')  = elabTypRep(E, p, Fn.id, typ)
	    val  k            = (if gen then Type.kind else Type.singKind) t0
	    val  _            = Inf.extendTyp(s, p, k)
	    (* ASSUME typ is wellformed for fix *)
	in
	    ( O.TypDec(nonInfo(i), typid', typ'), [(t0,t)] )
	end

      | elabRHSRecDec(E, s, rtpats', I.RecDec(i, decs)) =
	let
	    val (decs',tts) = elabRHSRecDecs(E, s, rtpats', decs)
	in
	    ( O.RecDec(nonInfo(i), decs'), Vector.toList tts )
	end

      | elabRHSRecDec(E, s, rtpats', dec) =
	    raise Crash.Crash "elabRHSRecDec"



  (* Specifications *)

    and elabSpecs(E, s,po, specs) =
	    Vector.map (fn spec => elabSpec(E, s,po, spec)) specs

    and elabSpec(E, s,po, I.FixSpec(i, vallab, fix)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (f,fix')    = elabFix(E, fix)
	    val  _          = Inf.extendFix(s, l, f)
	in
	    O.FixSpec(nonInfo(i), vallab', fix')
	end

      | elabSpec(E, s,po, I.ValSpec(i, valid, typ)) =
	let
	    val  l             = Label.fromName(I.name valid)
	    val (t0,qt,valid') = elabValid_bind(E, s, valid)
	    val (t,typ')       = elabStarTyp(E, false, typ)
	    val  _             = Type.unify(t0,t)
(*DEBUG*)handle e => raise e
	    val  _             = Type.unify(qt,t)
	    val  _             = Inf.extendVal(s, l, t)
	in
	    O.ValSpec(nonInfo(i), valid', typ')
	end

      | elabSpec(E, s,po, I.TypSpec(i, typid, typ)) =
	let
	    val abbrev = case typ of I.ConTyp(_,I.ShortId(_,typid')) =>
				     I.name typid' <> I.name typid
				   | _ => true
	    val  p           = elabNewPath(po, I.name typid)
	    val (t,gen,typ') = elabTypRep(E, p, Fn.id, typ)
	    val (t',typid')  = elabTypid_bind(E, p, abbrev, t, typid)
	    val  k           = (if gen then Type.kind else Type.singKind) t'
	    val  _           = Inf.extendTyp(s, p, k)
	in
(*DEBUG
print("{"^(if Type.isEqKind k then "eq" else "")^"type "^Name.toString(I.name typid)^"}\n");
*)
	    O.TypSpec(nonInfo(i), typid', typ')
	end

      | elabSpec(E, s,po, I.ModSpec(i, modid, inf)) =
	let
	    val  p          = elabNewPath(po, I.name modid)
	    val (j,inf')    = elabGroundInf(E, SOME p, inf)
	    val (j',modid') = elabModid_bind(E, p, true, j, modid)
	    val  _          = Inf.extendMod(s, p, j')
	in
	    O.ModSpec(nonInfo(i), modid', inf')
	end

      | elabSpec(E, s,po, I.InfSpec(i, infid, inf)) =
	let
	    val abbrev = case inf of I.ConInf(_,I.ShortId(_,infid')) =>
				     I.name infid' <> I.name infid
				   | _ => true
	    val  p           = elabNewPath(po, I.name infid)
	    val (j,gen,inf') = elabInfRep(E, p, Fn.id, inf)
	    val (j',infid')  = elabInfid_bind(E, p, abbrev, j, infid)
	    val  k           = (if gen then Inf.kind else Inf.singKind) j'
	    val  _           = Inf.extendInf(s, p, k)
	in
	    O.InfSpec(nonInfo(i), infid', inf')
	end

      | elabSpec(E, s,po, I.RecSpec(i, specs)) =
	let
	    val _            = elabLHSRecSpecs(E, s,po, specs)
	    val (specs',eqs) = elabRHSRecSpecs(E, s, specs)
	    val _            = Type.fix eqs
	    (* ASSUME that only TypSpec is under RecSpec *)
	in
(*DEBUG
Env.appTyps (fn(x,entry as {id,typ,...})=> 
let val k = Type.kind typ in
print("{"^(if Type.isEqKind k then "eq" else "")^"type "^Name.toString(I.name id)^"}\n")
end) (Env.cloneScope E);
*)
	    O.RecSpec(nonInfo(i), specs')
	end

      | elabSpec(E, s,po, I.ExtSpec(i, inf)) =
	let
	    val (j,inf') = elabGroundInf(E, po, inf)
	(*UNFINISHED: insert stuff*)
	in
	    E.unfinished(i, "elabSpec", "signature extension");
	    O.ExtSpec(nonInfo(i), inf')
	end


  (* Recursive specifications *)

    and elabLHSRecSpecs(E, s,po, specs) =
	    Vector.app (fn spec => elabLHSRecSpec(E,s,po,spec)) specs

    and elabLHSRecSpec(E, s,po, I.TypSpec(i, typid, typ)) =
	let
	    val p = elabNewPath(po, I.name typid)
	    val k = elabTypKind(E, typ)
	    val t = Type.unknown k
	    val _ = elabTypid_bind(E, p, true, t, typid)
	in
	    ()
	end

      | elabLHSRecSpec(E, s,po, I.RecSpec(i, specs)) =
	    elabLHSRecSpecs(E, s,po, specs)

      | elabLHSRecSpec(E, s,po, _) =
	    raise Crash.Crash "elabLHSRecSpec"


    and elabRHSRecSpecs(E, s, specs) =
	let
	    val (specs',ttss) =
		VectorPair.unzip
		    (Vector.map (fn spec => elabRHSRecSpec(E, s, spec)) specs)
	in
	    ( specs', Vector.fromList(Vector.foldl op@ [] ttss) )
	end

    and elabRHSRecSpec(E, s, I.TypSpec(i, typid, typ)) =
	let
	    val (t0,p,typid') = elabTypid(E, typid)
	    val (t,gen,typ')  = elabTypRep(E, p, Fn.id, typ)
	    (* ASSUME typ is wellformed for fix *)
	    val  k            = (if gen then Type.kind else Type.singKind) t0
	    val  _            = Inf.extendTyp(s, p, k)
	in
(*DEBUG
print("{"^(if Type.isEqKind k then "eq" else "")^"type "^Name.toString(I.name typid)^"}\n");
*)
	    ( O.TypSpec(nonInfo(i), typid', typ'), [(t0,t)] )
	end

      | elabRHSRecSpec(E, s, I.RecSpec(i, specs)) =
	let
	    val (specs',tts) = elabRHSRecSpecs(E, s, specs)
	in
	    ( O.RecSpec(nonInfo(i), specs'), Vector.toList tts )
	end

      | elabRHSRecSpec(E, s, _) =
	    raise Crash.Crash "elabRHSRecSpec"


  (* Announcements *)

    (* Be careful to not make any lookups unless strictly needed!
     * In particular, we cannot fully rely on laziness, because "byneed"
     * is just a dummy for Fn.id during bootstrap build 1. Still we have to
     * avoid access, otherwise the recursive import of ComponentManager in
     * component lib/system/Component will loop.
     *)

    fun elabAnn(E, desc, I.ImpAnn(i, imps, url, b)) =
	let
	    val isExplicit = Vector.all I.hasDesc imps
	    val s          = if isExplicit then Inf.emptySig()
			     else Future.byneed(fn() => loadSig(desc, url))
	    val s'         = Inf.emptySig()
	    val imps'      = elabImps(E, s, s', isExplicit, imps)
	    val s''        = if isExplicit then s'
			     else if !Switches.Language.retainFullImport then s
			     else Future.byneed(fn() => Inf.narrowSigExt(s,s'))
(*DEBUG*) handle e => raise e
	in
	    O.ImpAnn(sigInfo(i,s''), imps', url, b)
	end

    and elabAnns(E, desc, anns) =
	Vector.map (fn ann => elabAnn(E, desc, ann)) anns


  (* Imports *)

    and elabImps(E, s, s', isExplicit, imps) =
	Vector.map (fn imp => elabImp(E, s, s', isExplicit, imp)) imps

    and elabImp(E, s, s', isExplicit, I.FixImp(i, vallab, desc)) =
	let
	    val (l,vallab') = elabLab(E, vallab)
	    val (f2,desc')   =
		case desc
		 of I.NoDesc(i')       =>
		    let
			val f1 = Future.byneed(fn() =>
				 Inf.lookupFix(s, l) handle Inf.Lookup _ =>
				     error(i, E.ImpMismatch(Inf.MissingFix l)))
		    in
			(f1, O.NoDesc(fixInfo(i',f1)))
		    end
		  | I.SomeDesc(i',fix) =>
		    let
			val (f2,fix') = elabFix(E, fix)
		    in
			if isExplicit then () else
			let
			    val f1 = Future.byneed(fn() =>
				 Inf.lookupFix(s, l) handle Inf.Lookup _ =>
				     error(i, E.ImpMismatch(Inf.MissingFix l)))
			in
			    if f1 = f2 then () else
			    error(i, E.ImpMismatch(Inf.MismatchFix(l,f1,f2)))
			end;
			(f2, O.SomeDesc(fixInfo(i',f2), fix'))
		    end
	in
	    Inf.extendFix(s', l, f2);
	    O.FixImp(nonInfo(i), vallab', desc')
	end

      | elabImp(E, s, s', isExplicit, I.ValImp(i, valid, desc)) =
	let
	    val (t0,qt,valid') = elabValid_bind(E, s, valid)
	    val  l             = Label.fromName(O.name valid')
	    val (t2,desc')     =
		case desc
		 of I.NoDesc(i')       =>
		    let
			val  t1 = Future.byneed(fn() =>
				  Inf.lookupVal(s, l) handle Inf.Lookup _ =>
				      error(i, E.ImpMismatch(Inf.MissingVal l)))
		    in
			(t1, O.NoDesc(typInfo(i',t1)))
		    end
		  | I.SomeDesc(i',typ) =>
		    let
			val (t2,typ') = elabStarTyp(E, false, typ)
		    in
			if isExplicit then () else
			let
			    val  t1 = Future.byneed(fn() =>
				  Inf.lookupVal(s, l) handle Inf.Lookup _ =>
				      error(i, E.ImpMismatch(Inf.MissingVal l)))
			in
			    Type.enterLevel();
			    Type.match(t1,t2) handle Type.Mismatch m =>
			    error(i, E.ImpMismatch(Inf.MismatchVal(l,t1,t2,m)));
			    Type.exitLevel()
			end;
			(t2, O.SomeDesc(typInfo(i',t2),typ'))
		    end
	    val  _          = Type.unify(t0,t2)
	    val  _          = Type.unify(qt,t2)
	in
	    Inf.extendVal(s', l, t2);
	    O.ValImp(nonInfo(i), valid', desc')
	end

      | elabImp(E, s, s', isExplicit, I.TypImp(i, typid, desc)) =
	let
	    val l  = Label.fromName(I.name typid)
	    val p  = elabNewPath(NONE, I.name typid)
	    val (k2,t2,desc') =
		case desc
		 of I.NoDesc(i')       =>
		    let
			val k1 = Future.byneed(fn() =>
				 Inf.lookupTyp(s, l) handle Inf.Lookup _ =>
				    error(i, E.ImpMismatch(Inf.MissingTyp l)))
			val t1 = Future.byneed(fn() => Inf.lookupTyp'(s, l))
		    in
			(k1, t1, O.NoDesc(typInfo(i', t1)))
		    end
		  | I.SomeDesc(i',typ) =>
		    let
			val (t2,_,typ') = elabTypRep(E, p, Fn.id, typ)
			val  k2         = Type.kind t2
		    in
			if isExplicit then () else
			let
			    val k1 = Future.byneed(fn() =>
				 Inf.lookupTyp(s, l) handle Inf.Lookup _ =>
				    error(i, E.ImpMismatch(Inf.MissingTyp l)))
			in
			    Type.enterLevel();
			    Type.matchKind(k1,k2) handle Type.KindMismatch m =>
			    error(i, E.ImpMismatch(Inf.MismatchTyp(l,k1,k2,m)));
			    Type.exitLevel()
			end;
			(k2, t2, O.SomeDesc(typInfo(i',t2), typ'))
		    end
	    val (_,typid') = elabTypid_bind(E, p, true, t2, typid)
	in
	    Inf.extendTyp(s', p, k2);
	    O.TypImp(nonInfo(i), typid', desc')
	end

      | elabImp(E, s, s', isExplicit, I.ModImp(i, modid, desc)) =
	let
	    val l  = Label.fromName(I.name modid)
	    val p  = elabNewPath(NONE, I.name modid)
	    val (j2,jm2,desc') =
		case desc
		 of I.NoDesc(i') =>
		    let
			val j1 = Future.byneed(fn() =>
				 Inf.lookupMod(s, l) handle Inf.Lookup _ =>
				    error(i, E.ImpMismatch(Inf.MissingMod l)))
			val m1 = Future.byneed(fn() => Inf.lookupMod'(s, l))
			val jm1 = Future.byneed(fn() => Inf.sing m1)
		    in
			(j1, jm1, O.NoDesc(infInfo(i', jm1)))
		    end
		  | I.SomeDesc(i',inf) =>
		    if isExplicit then
			let
			    val (j2,inf') = elabGroundInf(E, SOME p, inf)
			in
			    (j2, j2, O.SomeDesc(infInfo(i',j2), inf'))
			end
		    else
		    let
			val j1 = Future.byneed(fn() =>
				 Inf.lookupMod(s, l) handle Inf.Lookup _ =>
				    error(i, E.ImpMismatch(Inf.MissingMod l)))
			val m1 = Future.byneed(fn() => Inf.lookupMod'(s, l))
			val (j2,inf') = elabGroundInf(E, SOME p, inf)
			val _   = Type.enterLevel()
			val _   = Inf.match(j1,j2) handle Inf.Mismatch m =>
				   error(i, E.ImpMismatch(Inf.MismatchMod(l,m)))
			val _   = Type.exitLevel()
			val jm2 = Inf.sing(Inf.narrowMod(m1,j2))
(*DEBUG*) handle e => raise e
		    in
			(j2, jm2, O.SomeDesc(infInfo(i',jm2),inf'))
		    end
	    val (_,modid') = elabModid_bind(E, p, true, jm2, modid)
	in
	    Inf.extendMod(s', p, j2);
	    O.ModImp(nonInfo(i), modid', desc')
	end

      | elabImp(E, s, s', isExplicit, I.InfImp(i, infid, desc)) =
	let
	    val l  = Label.fromName(I.name infid)
	    val p  = elabNewPath(NONE, I.name infid)
	    val (k2,j2,desc') =
		case desc
		 of I.NoDesc(i')       =>
		    let
			val k1 = Future.byneed(fn() =>
				 Inf.lookupInf(s, l) handle Inf.Lookup _ =>
				    error(i, E.ImpMismatch(Inf.MissingInf l)))
			val j1 = Future.byneed(fn() => Inf.lookupInf'(s, l))
		    in
			(k1, j1, O.NoDesc(infInfo(i',j1)))
		    end
		  | I.SomeDesc(i',inf) =>
		    let
			val (j2,_,inf') = elabInfRep(E, p, Fn.id, inf)
			val  k2         = Inf.kind j2
		    in
			if isExplicit then () else
			let
			    val k1 = Future.byneed(fn() =>
				 Inf.lookupInf(s, l) handle Inf.Lookup _ =>
				    error(i, E.ImpMismatch(Inf.MissingInf l)))
			in
			    Type.enterLevel();
			    Inf.matchKind(k1,k2) handle Inf.KindMismatch m =>
				error(i, E.ImpMismatch(Inf.MismatchInf(l,m)));
			    Type.exitLevel()
			end;
			(k2, j2, O.SomeDesc(infInfo(i',j2),inf'))
		    end
	    val (_,infid') = elabInfid_bind(E, p, true, j2, infid)
	in
	    Inf.extendInf(s', p, k2);
	    O.InfImp(nonInfo(i), infid', desc')
	end

      | elabImp(E, s, s', isExplicit, I.RecImp(i, imps)) =
	let
	    val _     = elabLHSRecImps(E, s, isExplicit, imps)
	    val imps' = elabRHSRecImps(E, s, s', isExplicit, imps)
	    (* ASSUME that only TypImp is under RecImp *)
	in
	    O.RecImp(nonInfo(i), imps')
	end


  (* Recursive specifications *)

    and elabLHSRecImps(E, s, isExplicit, imps) =
	    Vector.app (fn imp => elabLHSRecImp(E,s,isExplicit,imp)) imps

    and elabLHSRecImp(E, s, isExplicit, I.TypImp(i, typid, desc)) =
	let
	    val l  = Label.fromName(I.name typid)
	    val p  = elabNewPath(NONE, I.name typid)
	    val k1 = Future.byneed(fn() =>
		     Inf.lookupTyp(s, l) handle Inf.Lookup _ =>
			error(i, E.ImpMismatch(Inf.MissingTyp l)))
	    val t1 = Future.byneed(fn() => Inf.lookupTyp'(s, l))
	    val _  =
		case desc
		 of I.NoDesc(i')       => ()
		  | I.SomeDesc(i',typ) =>
		    let
			val k2 = elabTypKind(E, typ)
		    in
			if isExplicit then () else
			(Type.enterLevel();
			 Type.matchKind(k1,k2) handle Type.KindMismatch m =>
			    error(i, E.ImpMismatch(Inf.MismatchTyp(l,k1,k2,m)));
			 Type.exitLevel())
		    end
	    val _  = elabTypid_bind(E, p, true, t1, typid)
	in
	    ()
	end

      | elabLHSRecImp(E, s, isExplicit, I.RecImp(i, imps)) =
	    elabLHSRecImps(E, s, isExplicit, imps)

      | elabLHSRecImp(E, s, isExplicit, _) = ()


    and elabRHSRecImps(E, s, s', isExplicit, imps) =
	    Vector.map (fn imp => elabRHSRecImp(E, s, s', isExplicit, imp)) imps

    and elabRHSRecImp(E, s, s', isExplicit, I.RecImp(i, imps)) =
	let
	    val imps' = elabRHSRecImps(E, s, s', isExplicit, imps)
	in
	    O.RecImp(nonInfo(i), imps')
	end

      | elabRHSRecImp(E, s, s', isExplicit, I.TypImp(i, typid, desc)) =
	let
	    (*UNFINISHED *)
	    val (t1,p,typid') = elabTypid(E, typid)
	    val  k1           = Future.byneed(fn() =>
				Inf.lookupTyp(s, Label.fromName(I.name typid)))
	    val (k2,t2,desc') =
		case desc
		 of I.NoDesc(i')       => (k1, t1, O.NoDesc(typInfo(i',t1)))
		  | I.SomeDesc(i',typ) =>
		    let
			val (t2,_,typ') = elabTypRep(E, p, fn k'=>k', typ)
			val  k2         = Type.kind t2
		    in
			(k2, t2, O.SomeDesc(typInfo(i',t2),typ'))
		    end
	in
	    Inf.extendTyp(s', p, k2);
	    O.TypImp(nonInfo(i), typid', desc')
	end

      | elabRHSRecImp(E, s, s', isExplicit, imp) =
	    elabImp(E, s, s', isExplicit, imp)


  (* Components *)

    structure RewriteImports = MkRewriteImports(val loadImports = loadImports
						val loadMod = loadMod
						structure Switches = Switches)

    fun elabCom(E, desc, I.Com(i, anns, decs)) =
	let
	    val _       = Env.insertScope E
	    val anns'   = elabAnns(E, desc, anns)
	    val s       = Inf.emptySig()
	    val decs'   = elabDecs(E, s, NONE, decs)
	    val _       = Env.mergeScope E
	    val _       = if !Switches.Language.allowUnclosedComponents then ()
			  else Inf.close s handle Inf.Unclosed lnt =>
			      error(i, E.ExportUnclosed lnt)
	    val (anns'',s') = RewriteImports.rewriteAnns(desc, E, anns', s)
	in
	    if not(!Switches.Warn.inaccessibleExport) then () else
	    let
		val bound = Inf.boundPaths(Inf.sign s')
	    in
		PathMap.appi (fn(p,(pso,_)) =>
			      if Option.isSome pso then () else
				 warn(!Switches.Warn.inaccessibleExport, i,
				      E.ExportHiddenTyp p)) (#typ bound);
		PathMap.appi (fn(p,(pso,_)) =>
			      if Option.isSome pso then () else
				 warn(!Switches.Warn.inaccessibleExport, i,
				      E.ExportHiddenMod p)) (#mod bound);
		PathMap.appi (fn(p,(pso,_)) =>
			      if Option.isSome pso then () else
				 warn(!Switches.Warn.inaccessibleExport, i,
				      E.ExportHiddenInf p)) (#inf bound)
	    end;
	    O.Com(sigInfo(i,s'), anns'', decs')
	end

    fun translate(desc, E, com) =
	let
	    val E' = Env.clone E
	in
	    annots := [];
	    (E', elabCom(E', desc, com))
	    before dumpAnnots()
	end
	handle e as Error.Error _ =>
	    ( Type.resetLevel() ; dumpAnnots() ; raise e )
end
