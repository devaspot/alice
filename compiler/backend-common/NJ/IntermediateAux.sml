val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2002
 *
 * Last change:
 *   $Date: 2006-07-06 15:10:52 $ by $Author: rossberg $
 *   $Revision: 1.99 $
 *)















structure IntermediateAux :> INTERMEDIATE_AUX =
    struct
	structure I = IntermediateGrammar
	structure O = FlatGrammar

	open I

	fun freshIntermediateId info = Id (info, Stamp.stamp (), Name.InId)

	fun translateLit (info, I.IntLit i) = O.IntLit (info, i)
	  | translateLit (info, I.WordLit w) = O.WordLit (info, w)
	  | translateLit (info, I.CharLit c) = O.CharLit (info, c)
	  | translateLit (info, I.StringLit s) = O.StringLit (info, s)
	  | translateLit (info, I.RealLit r) = O.RealLit (info, r)

	fun litEq (IntLit i1, IntLit i2) = i1 = i2
	  | litEq (WordLit w1, WordLit w2) = w1 = w2
	  | litEq (CharLit c1, CharLit c2) = c1 = c2
	  | litEq (StringLit s1, StringLit s2) = s1 = s2
	  | litEq (RealLit r1, RealLit r2) = Real.== (r1, r2)
	  | litEq (_, _) = raise Crash.Crash "IntermediateAux.litEq"

	type subst = (Stamp.t * Stamp.t) list

	fun lookup ((stamp, stamp')::subst, id0 as Id (info, stamp0, name)) =
	    if stamp = stamp0 then Id (info, stamp', name)
	    else lookup (subst, id0)
	  | lookup (nil, id0) = id0

	fun substLongId (ShortId (info, id), subst) =
	    ShortId (info, lookup (subst, id))
	  | substLongId (longid as LongId (_, _, _), _) = longid

	fun substDecs' (decs, subst) =
	    Vector.map (fn dec => substDec' (dec, subst)) decs
	and substDec' (ValDec (info, pat, exp), subst) =
	    ValDec (info, substPat' (pat, subst), substExp' (exp, subst))
	  | substDec' (RecDec (info, decs), subst) =
	    RecDec (info, Vector.map (fn dec => substDec' (dec, subst)) decs)
	and substExp' (exp as LitExp (_, _), _) = exp
	  | substExp' (exp as PrimExp (_, _), _) = exp
	  | substExp' (exp as ImmExp (_, _), _) = exp
	  | substExp' (exp as NewExp _, _) = exp
	  | substExp' (VarExp (info, longid), subst) =
	    VarExp (info, substLongId (longid, subst))
	  | substExp' (TagExp (info, lab, exp), subst) =
	    TagExp (info, lab, substExp' (exp, subst))
	  | substExp' (ConExp (info, longid, exp), subst) =
	    ConExp (info, longid, substExp' (exp, subst))
	  | substExp' (RefExp (info, exp), subst) =
	    RefExp (info, substExp' (exp, subst))
	  | substExp' (RollExp (info, exp), subst) =
	    RollExp (info, substExp' (exp, subst))
	  | substExp' (StrictExp (info, exp), subst) =
	    StrictExp (info, substExp' (exp, subst))
	  | substExp' (TupExp (info, exps), subst) =
	    TupExp (info, Vector.map (fn exp => substExp' (exp, subst)) exps)
	  | substExp' (ProdExp (info, expFlds), subst) =
	    ProdExp (info,
		     Vector.map (fn Fld (info, lab, exp) =>
				 Fld (info, lab, substExp' (exp, subst)))
		     expFlds)
	  | substExp' (SelExp (info, lab, exp), subst) =
	    SelExp (info, lab, substExp' (exp, subst))
	  | substExp' (VecExp (info, exps), subst) =
	    VecExp (info, Vector.map (fn exp => substExp' (exp, subst)) exps)
	  | substExp' (FunExp (info, mats), subst) =
	    FunExp (info, substMats' (mats, subst))
	  | substExp' (AppExp (info, exp1, exp2), subst) =
	    AppExp (info, substExp' (exp1, subst), substExp' (exp2, subst))
	  | substExp' (AndExp (info, exp1, exp2), subst) =
	    AndExp (info, substExp' (exp1, subst), substExp' (exp2, subst))
	  | substExp' (OrExp (info, exp1, exp2), subst) =
	    OrExp (info, substExp' (exp1, subst), substExp' (exp2, subst))
	  | substExp' (IfExp (info, exp1, exp2, exp3), subst) =
	    IfExp (info, substExp' (exp1, subst),
		   substExp' (exp2, subst), substExp' (exp3, subst))
	  | substExp' (SeqExp (info, exp1, exp2), subst) =
	    SeqExp (info, substExp' (exp1, subst), substExp' (exp2, subst))
	  | substExp' (CaseExp (info, exp, mats), subst) =
	    CaseExp (info, substExp' (exp, subst),
		     substMats' (mats, subst))
	  | substExp' (RaiseExp (info, exp), subst) =
	    RaiseExp (info, substExp' (exp, subst))
	  | substExp' (HandleExp (info, exp, mats), subst) =
	    HandleExp (info, substExp' (exp, subst),
		       substMats' (mats, subst))
	  | substExp' (exp as FailExp _, _) = exp
	  | substExp' (LazyExp (info, exp), subst) =
	    LazyExp (info, substExp' (exp, subst))
	  | substExp' (SpawnExp (info, exp), subst) =
	    SpawnExp (info, substExp' (exp, subst))
	  | substExp' (LetExp (info, decs, exp), subst) =
	    LetExp (info, substDecs' (decs, subst), substExp' (exp, subst))
	  | substExp' (SealExp (info, exp), subst) =
	    SealExp (info, substExp' (exp, subst))
	  | substExp' (UnsealExp (info, exp), subst) =
	    UnsealExp (info, substExp' (exp, subst))
	and substMats' (mats, subst) =
	    Vector.map (fn Mat (info, pat, exp) =>
			Mat (info, substPat' (pat, subst),
			     substExp' (exp, subst))) mats
	and substPat' (pat as JokPat _, _) = pat
	  | substPat' (pat as LitPat (_, _), _) = pat
	  | substPat' (pat as VarPat (_, _), _) = pat
	  | substPat' (TagPat (info, lab, pat), subst) =
	    TagPat (info, lab, substPat' (pat, subst))
	  | substPat' (ConPat (info, longid, pat), subst) =
	    ConPat (info, longid, substPat' (pat, subst))
	  | substPat' (RefPat (info, pat), subst) =
	    RefPat (info, substPat' (pat, subst))
	  | substPat' (RollPat (info, pat), subst) =
	    RollPat (info, substPat' (pat, subst))
	  | substPat' (StrictPat (info, pat), subst) =
	    StrictPat (info, substPat' (pat, subst))
	  | substPat' (TupPat (info, pats), subst) =
	    TupPat (info, Vector.map (fn pat => substPat' (pat, subst)) pats)
	  | substPat' (ProdPat (info, patFlds), subst) =
	    ProdPat (info,
		     Vector.map (fn Fld (info, lab, pat) =>
				 Fld (info, lab, substPat' (pat, subst)))
		     patFlds)
	  | substPat' (VecPat (info, pats), subst) =
	    VecPat (info, Vector.map (fn pat => substPat' (pat, subst)) pats)
	  | substPat' (AsPat (info, pat1, pat2), subst) =
	    AsPat (info, substPat' (pat1, subst), substPat' (pat2, subst))
	  | substPat' (AltPat (info, pat1, pat2), subst) =
	    AltPat (info, substPat' (pat1, subst), substPat' (pat2, subst))
	  | substPat' (NegPat (info, pat), subst) =
	    NegPat (info, substPat' (pat, subst))
	  | substPat' (GuardPat (info, pat, exp), subst) =
	    GuardPat (info, substPat' (pat, subst), substExp' (exp, subst))
	  | substPat' (WithPat (info, pat, decs), subst) =
	    WithPat (info, substPat' (pat, subst), substDecs' (decs, subst))

	fun substDecs (decs, subst as _::_) = substDecs' (decs, subst)
	  | substDecs (decs, nil) = decs
	fun substDec (dec, subst as _::_) = substDec' (dec, subst)
	  | substDec (dec, nil) = dec
	fun substExp (exp, subst as _::_) = substExp' (exp, subst)
	  | substExp (exp, nil) = exp

	(* If the same test occurs in two patterns at the same position,
	 * then these may be merged by the pattern matching compiler.
	 * In this process, a global substitution is built such that the
	 * identifiers bound at each pattern position are all mapped to
	 * common identifiers.
	 * In the presence of disjunctive patterns, such a substitution can
	 * in general only be made consistent with all pattern bindings by
	 * first uniquely renaming, then binding all the original identifiers
	 * by `with' declarations.  `with' declarations are not affected by
	 * the substitution because they are never merged.
	 *
	 * `separateAlt' moves all bindings to `with' declarations.  These
	 * are placed right at the end of each alternative pattern to allow
	 * for a maximum of merging possibilities.
	 * In principle, it is sufficient to do so only within disjunctive
	 * patterns.  If we apply this on the toplevel as well however,
	 * we need not substitute into the right hand side of a match.
	 *)

	fun separateAlt pat =
	    let
		val (pat', subst) = relax (pat, nil)
		val decs =
		    List.map
		    (fn (id, id', info) =>
		     ValDec ({region = #region info,
			      origin = IntermediateInfo.Aux},
			     VarPat (info, id),
			     VarExp (info, ShortId (info, id')))) subst
	    in
		case decs of
		    nil => pat'
		  | _::_ => WithPat (infoPat pat', pat', Vector.fromList decs)
	    end
	and relax (pat as JokPat _, subst) = (pat, subst)
	  | relax (pat as LitPat (_, _), subst) = (pat, subst)
	  | relax (VarPat (info, id), subst) =
	    let
		val id' = freshIntermediateId info
	    in
		(VarPat (info, id'), (id, id', info)::subst)
	    end
	  | relax (TagPat (info, lab, pat), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
	    in
		(TagPat (info, lab, pat'), subst')
	    end
	  | relax (ConPat (info, longid, pat), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
	    in
		(ConPat (info, longid, pat'), subst')
	    end
	  | relax (RefPat (info, pat), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
	    in
		(RefPat (info, pat'), subst')
	    end
	  | relax (RollPat (info, pat), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
	    in
		(RollPat (info, pat'), subst')
	    end
	  | relax (StrictPat (info, pat), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
	    in
		(StrictPat (info, pat'), subst')
	    end
	  | relax (TupPat (info, pats), subst) =
	    let
		val (pats', subst') =
		    Vector.foldr (fn (pat, (pats, subst)) =>
				  let
				      val (pat', subst') = relax (pat, subst)
				  in
				      (pat'::pats, subst')
				  end) (nil, subst) pats
	    in
		(TupPat (info, Vector.fromList pats'), subst')
	    end
	  | relax (ProdPat (info, patFlds), subst) =
	    let
		val (patFlds', subst') =
		    Vector.foldr
		    (fn (Fld (info, lab, pat), (patFlds, subst)) =>
		     let
			 val (pat', subst') = relax (pat, subst)
		     in
			 (Fld (info, lab, pat')::patFlds, subst')
		     end) (nil, subst) patFlds
	    in
		(ProdPat (info, Vector.fromList patFlds'), subst')
	    end
	  | relax (VecPat (info, pats), subst) =
	    let
		val (pats', subst') =
		    Vector.foldr (fn (pat, (pats, subst)) =>
				  let
				      val (pat', subst') = relax (pat, subst)
				  in
				      (pat'::pats, subst')
				  end) (nil, subst) pats
	    in
		(VecPat (info, Vector.fromList pats'), subst')
	    end
	  | relax (AsPat (info, pat1, pat2), subst) =
	    let
		val (pat1', subst') = relax (pat1, subst)
		val (pat2', subst'') = relax (pat2, subst')
	    in
		(AsPat (info, pat1', pat2'), subst'')
	    end
	  | relax (AltPat (info, pat1, pat2), subst) =
	    (AltPat (info, separateAlt pat1, separateAlt pat2), subst)
	  | relax (NegPat (info, pat), subst) =
	    (NegPat (info, separateAlt pat), subst)
	  | relax (GuardPat (info, pat, exp), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
		val subst'' =
		    List.map (fn (Id (_, stamp1, _), Id (_, stamp2, _), _) =>
			      (stamp1, stamp2)) subst'
	    in
		(GuardPat (info, pat', substExp (exp, subst'')), subst')
	    end
	  | relax (WithPat (info, pat, decs), subst) =
	    let
		val (pat', subst') = relax (pat, subst)
		val subst'' =
		    List.map (fn (Id (_, stamp1, _), Id (_, stamp2, _), _) =>
			      (stamp1, stamp2)) subst'
	    in
		(WithPat (info, pat', substDecs (decs, subst'')), subst')
	    end

	fun idEq (O.Id (_, stamp1, _), O.Id (_, stamp2, _)) = stamp1 = stamp2

	structure IdKey =
	    struct
		type t = O.id
		val equal = idEq
		fun hash (O.Id (_, stamp, _)) = Stamp.hash stamp
	    end
	structure IdSet = MkHashImpSet(IdKey)

	fun usedVarsId (id, set, used) =
	    if IdSet.member (set, id) then IdSet.insert (used, id) else ()

	fun usedVarsIdRef ((O.IdRef id | O.LastIdRef id), set, used) =
	    usedVarsId (id, set, used)
	  | usedVarsIdRef ((O.Lit _ | O.Prim _ | O.Value (_, _)), _, _) = ()

	fun usedVarsArgs (O.OneArg idRef, set, used) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsArgs (O.TupArgs idRefs, set, used) =
	    Vector.app (fn idRef => usedVarsIdRef (idRef, set, used)) idRefs
	  | usedVarsArgs (O.ProdArgs labelIdRefVec, set, used) =
	    Vector.app (fn (_, idRef) => usedVarsIdRef (idRef, set, used))
		       labelIdRefVec

	fun usedVarsEntryPoint (O.ConEntry (_, idRef, args), set, used) =
	    (usedVarsIdRef (idRef, set, used); usedVarsArgs (args, set, used))
	  | usedVarsEntryPoint (O.SelEntry (_, _, _, _, idRef), set, used) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsEntryPoint (O.StrictEntry (_, idRef), set, used) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsEntryPoint (O.AppEntry (_, idRef, args), set, used) =
	    (usedVarsIdRef (idRef, set, used); usedVarsArgs (args, set, used))
	  | usedVarsEntryPoint (O.CondEntry (_, idRef), set, used) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsEntryPoint (O.RaiseEntry idRef, set, used) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsEntryPoint (O.HandleEntry idRef, set, used) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsEntryPoint (O.SpawnEntry, _, _) = ()

	fun usedVarsStm (O.Entry (_, entryPoint), set, used, _) =
	    usedVarsEntryPoint (entryPoint, set, used)
	  | usedVarsStm (O.Exit (_, _, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsStm (O.LastUse (_, ids), set, used, _) =
	    Vector.app (fn id => usedVarsId (id, set, used)) ids
	  | usedVarsStm (O.ValDec (_, _, exp), set, used, shared) =
	    usedVarsExp (exp, set, used, shared)
	  | usedVarsStm (O.RecDec (_, idDefExpVec), set, used, shared) =
	    Vector.app (fn (_, exp) => usedVarsExp (exp, set, used, shared))
		       idDefExpVec
	  | usedVarsStm (O.RefDec (_, _, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsStm (O.TupDec (_, _, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsStm (O.ProdDec (_, _, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsStm (O.RaiseStm (_, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsStm (O.ReraiseStm (_, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsStm (O.TryStm (_, tryBody, _, _, handleBody),
			 set, used, shared) =
	    (usedVarsBody (tryBody, set, used, shared);
	     usedVarsBody (handleBody, set, used, shared))
	  | usedVarsStm (O.EndTryStm (_, body), set, used, shared) =
	    usedVarsBody (body, set, used, shared)
	  | usedVarsStm (O.EndHandleStm (_, body), set, used, shared) =
	    usedVarsBody (body, set, used, shared)
	  | usedVarsStm (O.TestStm (_, idRef, tests, body),
			 set, used, shared) =
	    (usedVarsIdRef (idRef, set, used);
	     case tests of
		 O.LitTests vec =>
		     Vector.app (fn (_, body) =>
				 usedVarsBody (body, set, used, shared)) vec
	       | O.TagTests (_, vec) =>
		     Vector.app (fn (_, _, body) =>
				 usedVarsBody (body, set, used, shared)) vec
	       | O.ConTests vec =>
		     Vector.app (fn (_, _, body) =>
				 usedVarsBody (body, set, used, shared)) vec
	       | O.VecTests vec =>
		     Vector.app (fn (_, body) =>
				 usedVarsBody (body, set, used, shared)) vec;
	     usedVarsBody (body, set, used, shared))
	  | usedVarsStm (O.SharedStm (_, body, stamp), set, used, shared) =
	    if StampSet.member (shared, stamp) then ()
	    else
		(StampSet.insert (shared, stamp);
		 usedVarsBody (body, set, used, shared))
	  | usedVarsStm (O.ReturnStm (_, exp), set, used, shared) =
	    usedVarsExp (exp, set, used, shared)
	  | usedVarsStm (O.IndirectStm (_, ref bodyOpt), set, used, shared) =
	    usedVarsBody (valOf bodyOpt, set, used, shared)
	  | usedVarsStm (O.ExportStm (_, exp), set, used, shared) =
	    usedVarsExp (exp, set, used, shared)
	and usedVarsExp (O.NewExp _, _, _, _) = ()
	  | usedVarsExp (O.VarExp (_, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsExp (O.TagExp (_, _, _, args), set, used, _) =
	    usedVarsArgs (args, set, used)
	  | usedVarsExp (O.ConExp (_, idRef, args), set, used, _) =
	    (usedVarsIdRef (idRef, set, used); usedVarsArgs (args, set, used))
	  | usedVarsExp (O.RefExp (_, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsExp (O.TupExp (_, idRefs), set, used, _) =
	    Vector.app (fn idRef => usedVarsIdRef (idRef, set, used)) idRefs
	  | usedVarsExp (O.ProdExp (_, labelIdRefVec), set, used, _) =
	    Vector.app (fn (_, idRef) => usedVarsIdRef (idRef, set, used))
		       labelIdRefVec
	  | usedVarsExp (O.PolyProdExp (_, labelIdRefVec), set, used, _) =
	    Vector.app (fn (_, idRef) => usedVarsIdRef (idRef, set, used))
		       labelIdRefVec
	  | usedVarsExp (O.VecExp (_, idRefs), set, used, _) =
	    Vector.app (fn idRef => usedVarsIdRef (idRef, set, used)) idRefs
	  | usedVarsExp (O.FunExp (_, _, _, _, _, _, body), 
			 set, used, shared) =
	    usedVarsBody (body, set, used, shared)
	  | usedVarsExp (O.PrimAppExp (_, _, idRefs), set, used, _) =
	    Vector.app (fn idRef => usedVarsIdRef (idRef, set, used)) idRefs
	  | usedVarsExp (O.VarAppExp (_, idRef, args), set, used, _) =
	    (usedVarsIdRef (idRef, set, used); usedVarsArgs (args, set, used))
	  | usedVarsExp (O.DirectAppExp (_, idRef, args), set, used, _) =
	    (usedVarsIdRef (idRef, set, used); usedVarsArgs (args, set, used))
	  | usedVarsExp (O.SelExp (_, _, _, _, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsExp (O.LazyPolySelExp (_, _, idRef), set, used, _) =
	    usedVarsIdRef (idRef, set, used)
	  | usedVarsExp (O.FunAppExp (_, idRef, _, args), set, used, _) =
	    (usedVarsIdRef (idRef, set, used); usedVarsArgs (args, set, used))
	  | usedVarsExp (O.FailExp _, _, _, _) = ()
	and usedVarsBody (stm::stms, set, used, shared) =
	    (usedVarsStm (stm, set, used, shared);
	     usedVarsBody (stms, set, used, shared))
	  | usedVarsBody (nil, _, _, _) = ()

	fun getUsedVars (exp, set) =
	    let
		val used = IdSet.set ()
	    in
		usedVarsExp (exp, set, used, StampSet.set ()); used
	    end

	fun rowLabels row =
	    case Type.inspectRow row of
		(Type.EmptyRow | Type.UnknownRow _) => nil
	      | Type.FieldRow (label, _, row') => label::rowLabels row'

	fun isTuple (label::labels, i) =
	    if label = Label.fromInt i then isTuple (labels, i + 1)
	    else NONE
	  | isTuple (nil, i) = SOME (i - 1)

	structure LabelMap = MkHashImpMap(Label)

	val typToArityMap: (Arity.t * int LabelMap.t option) Type.Map.t =
	    Type.Map.map ()

	fun rowToArity (row, typ, makeMap) =
	    let
		val typ = Type.canonical typ
	    in
		case Type.Map.lookup (typToArityMap, typ) of
		    SOME entry => entry
		  | NONE =>
			let
			    val labels = rowLabels row
			    val (arity, makeMap) =
				case isTuple (labels, 1) of
				    SOME n => (Arity.Tuple n, false)
				  | NONE =>
					(Arity.Product
					     (Vector.fromList labels), makeMap)
			    val mapOpt =
				if makeMap then
				    let
					val map = LabelMap.map ()
				    in
					List.appi
					    (fn (i, label) =>
						LabelMap.insert
						    (map, label, i)) labels;
					SOME map
				    end
				else NONE
			    val entry = (arity, mapOpt)
			in
			    Type.Map.insert (typToArityMap, typ, entry); entry
			end
	    end

	fun typToArity' (typ, makeMap) =
	    case Type.inspect typ of
		( Type.Var _ | Type.Con _ | Type.Arrow _ ) =>
		    (Arity.Unary, NONE)
	      | ( Type.Mu typ' | Type.All (_, typ') | Type.Exist (_, typ')
		| Type.Lambda (_, typ') | Type.Apply (typ', _) ) =>
		    typToArity' (typ', makeMap) 
	      | Type.Prod row =>
		    if Type.isTupleRow row then
			(Arity.Tuple (Vector.length (Type.asTupleRow row)),
			 NONE)
		    else
			rowToArity (row, typ, makeMap)
	      | Type.Sum row =>
		    rowToArity (row, typ, makeMap)
	      | Type.Unknown _ =>
		    raise Crash.Crash "IntermediateAux.typToArity"

	fun typToArity typ = #1 (typToArity' (typ, false))

	fun find (labels, label', i, n) =
	    if i = n then
		raise Crash.Crash ("IntermediateAux.find " ^
				   Label.toString label')
	    else if Vector.sub (labels, i) = label' then (O.Product labels, i)
	    else find (labels, label', i + 1, n)

	fun findLabel (Arity.Unary, label) =
	    raise Crash.Crash ("IntermediateAux.findLabel 1 " ^
			       Label.toString label)
	  | findLabel (Arity.Tuple n, label) =
	    (case Label.toInt label of
		 SOME i =>
		     if i <= n then (O.Tuple n, i - 1)
		     else
			 raise Crash.Crash ("IntermediateAux.findLabel 2 " ^
					    Label.toString label)
	       | NONE =>
		     raise Crash.Crash ("IntermediateAux.findLabel 3 " ^
					Label.toString label))
	  | findLabel (Arity.Product labels, label) =
	    find (labels, label, 0, Vector.length labels)

	fun labelToIndex (typ, label) =
	    case typToArity' (typ, true) of
		(Arity.Tuple n, SOME map) =>
		    (O.Tuple n, LabelMap.lookupExistent (map, label))
	      | (Arity.Product labels, SOME map) =>
		    (O.Product labels, LabelMap.lookupExistent (map, label))
	      | (Arity.Unary, _) =>
		    raise Crash.Crash ("IntermediateAux.labelToIndex")
	      | (arity, NONE) => findLabel (arity, label)

	fun prodToLabels (O.Tuple n) =
	    Vector.tabulate (n, fn i => Label.fromInt (i + 1))
	  | prodToLabels (O.Product labels) = labels

	fun reset () = Type.Map.removeAll typToArityMap
    end
