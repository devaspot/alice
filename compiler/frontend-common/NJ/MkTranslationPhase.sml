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
 *   $Revision: 1.175 $
 *)





































(*DEBUG








*)

functor MkTranslationPhase(Switches: SWITCHES) : TRANSLATION_PHASE =
struct

    structure C = TranslationEnv
    structure I = TypedGrammar
    structure O = IntermediateGrammar

    open TypedInfo
    open IntermediateInfo
    open IntermediateCons
    nonfix mod

    open PervasiveType
    open InfLib
    open TypeLib
    open PervasiveTypeLib
    open PathLib
    open LabelLib
    open FixityLib
    open DynMatchLib
    open TypeTranslation


  (* UNFINISHED... *)

    fun unfinished r funname casename =
	Error.unfinished(r, "Translation." ^ funname, casename)

  (* Helpers *)

    fun concatVec vs     = Vector.concat(Vector.toList vs)
    fun concatMapVec f v = concatVec(Vector.map f v)

    fun findFld (isXxxName, t) = findFld'(isXxxName, Type.asProd t)
    and findFld'(isXxxName, r) =
	let
	    val (l,t,r') = Type.asFieldRow r
	in
	    if isXxxName(Label.toName l)
	    then (l,t)
	    else findFld'(isXxxName, r')
	end

    (*DEBUG helpers

    fun prStamp name z =
	(print name; print " = ";
	 print(Stamp.toString z);
	 print "\n")

    fun prLab name l =
	(print name; print " = ";
	 print(Label.toString l);
	 print "\n")

    fun prPath name p =
	(print name; print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPPath.ppPath p, 76 - size name);
	 print "\n")

    fun prTyp name t =
	(print name; print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPType.ppTyp t, 76 - size name);
	 print "\n")

    fun prInf name j =
	(print name; print " = ";
	 PrettyPrint.output(TextIO.stdOut, PPInf.ppInf j, 76 - size name);
	 print "\n")

    *)


  (* Management of __pervasive reference *)

    (* We have to insert id before we can do type translation! *)

    fun updatePervasive1(env, id as I.Id(i,z,n)) =
	if n <> name_pervasive then () else
	TranslationEnv.insertPervasive(env, id)

    fun updatePervasive2(env, id as I.Id(i,z,n) : I.modid) =
	if n <> name_pervasive then () else
	let
	    val i'      = typInfo(#region i, infToTyp(env, #inf i))
	    val longid' = shortId(O.Id(i', z, NameTranslation.trModName n))
	in
	    TranslationEnv.insertPervasive'(env, longid')
	end


  (* Literals *)

    fun trLit(I.IntLit n)    = O.IntLit n
      | trLit(I.WordLit w)   = O.WordLit w
      | trLit(I.CharLit c)   = O.CharLit c
      | trLit(I.StringLit s) = O.StringLit s
      | trLit(I.RealLit x)   = O.RealLit x


  (* Identifiers *)

    fun trValInfo(env, {region, typ}) = {region=region, typ=typToTyp(env,typ)}
    fun trTypInfo(env, {region, typ}) = {region=region, typ=typ_typ env}
    fun trVarInfo(env, {region, var}) = {region=region, typ=typ_var env}
    fun trModInfo(env, {region, inf}) = {region=region, typ=infToTyp(env,inf)}
    fun trInfInfo(env, {region, inf}) = {region=region, typ=typ_inf env}

    fun trVallab(I.Lab(i,l)) = O.Lab(i, LabelTranslation.trValLabel l)
    fun trTyplab(I.Lab(i,l)) = O.Lab(i, LabelTranslation.trTypLabel l)
    fun trModlab(I.Lab(i,l)) = O.Lab(i, LabelTranslation.trModLabel l)
    fun trInflab(I.Lab(i,l)) = O.Lab(i, LabelTranslation.trInfLabel l)

    exception VirtualModule

    fun trValid(env, I.Id(i,z,n)) =
	O.Id(trValInfo(env,i), z, NameTranslation.trValName n)
    fun trTypid(env, I.Id(i,z,n)) =
	O.Id(trTypInfo(env,i), z, NameTranslation.trTypName n)
    fun trVarid(env, (I.Id(i,z,n), eq)) =
	O.Id(trVarInfo(env,i), z, NameTranslation.trTypName n)
    fun trInfid(env, I.Id(i,z,n)) =
	O.Id(trInfInfo(env,i), z, NameTranslation.trInfName n)
    fun trModid(env, I.Id(i,z,n)) =
	if TranslationEnv.memberMod(env, z) then raise VirtualModule else
	O.Id(trModInfo(env,i), z, NameTranslation.trModName n)

    fun trModlongid(env, I.ShortId(i, id)) =
	O.ShortId(trModInfo(env, i), trModid(env, id))
      | trModlongid(env, I.LongId(i, longid, lab)) =
	O.LongId(trModInfo(env, i), trModlongid(env, longid), trModlab lab)

    fun trVallongid(env, I.ShortId(i, id)) =
	O.ShortId(trValInfo(env, i), trValid(env, id))
      | trVallongid(env, I.LongId(i, longid, lab)) =
	O.LongId(trValInfo(env, i), trModlongid(env, longid), trVallab lab)

    fun trTyplongid(env, I.ShortId(i, id)) =
	O.ShortId(trTypInfo(env, i), trTypid(env, id))
      | trTyplongid(env, I.LongId(i, longid, lab)) =
	O.LongId(trTypInfo(env, i), trModlongid(env, longid), trTyplab lab)

    fun trInflongid(env, I.ShortId(i, id)) =
	O.ShortId(trInfInfo(env, i), trInfid(env, id))
      | trInflongid(env, I.LongId(i, longid, lab)) =
	O.LongId(trInfInfo(env, i), trModlongid(env, longid), trInflab lab)


  (* Ids bound inside interfaces *)

    fun trVirtModid(env, I.Id(i,z,n) : I.modid) =
	(* [id] = $id *)
	O.Id(typInfo(#region i, typ_inf env), z, NameTranslation.trModName n)

    fun trVirtModlongid(env, I.ShortId(i, id)) =
	(* [id] = [id] *)
	idExp(trVirtModid(env, id))

      | trVirtModlongid(env, I.LongId(i, longid, I.Lab(_,l)) : I.modlongid) =
	(* [longid.lab] =
	 *   __pervasive.Inf.lookupMod(__pervasive.Inf.asSig [longid],
	 *			       __pervasive.Label.fromString "lab")
	 *)
	let
	    val r    = #region i
	    val exp1 = infExp(env, lab_asSig, trVirtModlongid(env, longid))
	    val exp2 = labExp(env, r, l)
	in
	    infExp(env, lab_lookupMod, tupExp(r, #[exp1, exp2]))
	end

    fun trVirtTyplongid(env, I.ShortId(i, id)) = assert false
      | trVirtTyplongid(env, I.LongId(i, longid, I.Lab(_,l)) : I.typlongid) =
	(* [longid.lab] =
	 *   __pervasive.Inf.lookupTyp'(__pervasive.Inf.asSig [longid],
	 *				__pervasive.Label.fromString "lab")
	 *)
	let
	    val r     = #region i
	    val exp1 = infExp(env, lab_asSig, trVirtModlongid(env, longid))
	    val exp2 = labExp(env, r, l)
	in
	    infExp(env, lab_lookupTyp', tupExp(r, #[exp1, exp2]))
	end

    fun trVirtInflongid(env, I.ShortId(i, id)) = assert false
      | trVirtInflongid(env, I.LongId(i, longid, I.Lab(_,l)) : I.inflongid) =
	(* [longid.lab] =
	 *   __pervasive.Inf.lookupInf'(__pervasive.Inf.asSig [longid],
	 *				__pervasive.Label.fromString "lab")
	 *)
	let
	    val r    = #region i
	    val exp1 = infExp(env, lab_asSig, trVirtModlongid(env, longid))
	    val exp2 = labExp(env, r, l)
	in
	    infExp(env, lab_lookupInf', tupExp(r, #[exp1, exp2]))
	end


  (* Extract bound ids from declarations. *)

    fun idsId'(id as O.Id(_,_,Name.ExId s), ids') = StringMap.insert(ids',s,id)
      | idsId'(id, ids') = ()

    fun idsDecs(env, decs, ids') =
	Vector.app (fn dec => idsDec(env, dec, ids')) decs
    and idsDec(env, I.ValDec(_,pat,_), ids') = idsPat(env, pat, ids')
      | idsDec(env, I.TypDec(_,id,_), ids')  = idsId'(trTypid(env, id), ids')
      | idsDec(env, I.ModDec(_,id,_), ids')  = (idsId'(trModid(env, id), ids')
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region(I.infoId id), Name.toString(I.name id) ^"[" ^ Stamp.toString(I.stamp id) ^ "] 10\n"); raise VirtualModule))
      | idsDec(env, I.InfDec(_,id,_), ids')  = idsId'(trInfid(env, id), ids')
      | idsDec(env, I.VarDec(_,_,dec), ids') = idsDec(env, dec, ids')
      | idsDec(env, I.RecDec(_,decs), ids')  = idsDecs(env, decs, ids')
      | idsDec(env, (I.FixDec _|I.LocalDec _), ids') = ()

    and idsPats(env, pats, ids') =
	Vector.app (fn pat => idsPat(env, pat, ids')) pats
    and idsRow(env, I.Row(_, flds, pato), ids') =
	(Vector.app (fn fld => idsFld(env, fld, ids')) flds;
	 Option.app (fn pat => idsPat(env, pat, ids')) pato)
    and idsPat(env, ( I.JokPat _
		    | I.LitPat _), ids')	= ()
      | idsPat(env, I.VarPat(_, id), ids')	= idsId'(trValid(env, id), ids')
      | idsPat(env, ( I.TagPat(_, _, pat)
		    | I.ConPat(_, _, pat)
		    | I.RefPat(_, pat)
		    | I.RollPat(_, pat, _)
		    | I.StrictPat(_, pat)
		    | I.AltPat(_, pat, _)
		    | I.NegPat(_, pat)
		    | I.GuardPat(_, pat, _)
		    | I.AnnPat(_, pat, _)),
		    ids')			= idsPat(env, pat, ids')
      | idsPat(env, ( I.TupPat(_, pats)
		    | I.VecPat(_, pats)), ids') = idsPats(env, pats, ids')
      | idsPat(env, I.ProdPat(_, row), ids')	= idsRow(env, row, ids')
      | idsPat(env, I.AsPat(_,pat1,pat2), ids')	= (idsPat(env, pat1, ids');
						   idsPat(env, pat2, ids'))
      | idsPat(env, I.WithPat(_,pat,decs),ids')	= (idsPat(env, pat, ids');
						   idsDecs(env, decs, ids'))
    and idsFld(env, I.Fld(_, _, pat), ids')	= idsPat(env, pat, ids')

    fun ids(env, decs) =
	let
	    val ids' = StringMap.map()
	in
	    idsDecs(env, decs, ids');
	    Vector.fromList(StringMap.fold op:: [] ids')
	end


  (* Expressions *)

    fun trExps(env, exps) =
	(* [exp1,...,expN] = [exp1],...,[expN] *)
	Vector.map (fn exp => trExp(env, exp)) exps

    and trExp(env, I.LitExp(i, lit)) =
	(* [lit] = [lit] *)
	O.LitExp(i, trLit lit)

      | trExp(env, I.VarExp(i, longid)) =
	(* [longid] =  (if longid not overloaded)
	 *   [longid]
	 * [longid] =  (if longid intensionally overloaded)
	 *   [longid] <t>
	 * [longid] =  (if longid extensionally overloaded with t1,...,tN)
	 *   [longid].i  (where t = ti)
	 *)
	(let
	    val r  = #region i
	    val t1 = #typ i
	    val t2 = #typ(I.infoLongid longid)
	    val longid' = trVallongid(env, longid)
	in
	    case Type.inspect t2
	     of Type.All(a,t) =>
		(case Type.inspect t1
		 of Type.All _ => O.VarExp(i, longid')
		  | _ =>
		 case Type.constraintVar a
		 of Type.Unconstrained => O.VarExp(i, longid')
		  | Type.Intensional =>
		    let
			val t' = Type.arrow(typ_typ env, t1)
			val t0 = Type.unknown(Type.kindVar a)
		    in
			Type.unify(t1, Type.instanceWith(t2,t0));
			O.AppExp(i,
			    O.VarExp(typInfo(r,t'), longid'),
			    O.ImmExp(typInfo(r,typ_typ env), Reflect.reflect t0)
			)
		    end
		  | Type.Extensional(p,ps) =>
		    let
			val  k    = Type.kindVar a
			val (n,_) = Option.valOf(List.findi
					(fn(_,p) => 
					 Type.equal(t1, Type.instanceWith
							    (t2, Type.con(p,k)))
					) (p::ps))
		    in
			O.SelExp(i,
			    O.Lab(nonInfo r, Label.fromInt(n+1)),
			    O.VarExp(O.infoLongid longid', longid')
			)
		    end
		)
	      | _ => O.VarExp(i, longid')
	end
(* may happen with functor derived form...
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region i, "15\n"); raise VirtualModule))
*))
      | trExp(env, I.PrimExp(i, s, typ)) =
	(* [prim s : typ] = prim s *)
	O.PrimExp(i, s)

      | trExp(env, I.NewExp(i, typ)) =
	(* [new : typ] = new *)
	O.NewExp(i)

      | trExp(env, I.TagExp(i, lab, exp)) =
	(* [`lab exp] = `[lab] [exp] *)
	O.TagExp(i, trVallab lab, trExp(env, exp))

      | trExp(env, I.ConExp(i, longid, exp)) =
	(* [@longid exp] = @[longid] [exp] *)
	(O.ConExp(i, trVallongid(env, longid), trExp(env, exp))
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region i, "16\n"); raise VirtualModule))

      | trExp(env, I.RefExp(i, exp)) =
	(* [ref exp] = ref [exp] *)
	O.RefExp(i, trExp(env, exp))

      | trExp(env, I.RollExp(i, exp, typ)) =
	(* [roll exp] = roll [exp] *)
	O.RollExp(i, trExp(env, exp))

      | trExp(env, I.StrictExp(i, exp)) =
	(* [strict exp] = strict [exp] *)
	O.StrictExp(i, trExp(env, exp))

      | trExp(env, I.TupExp(i, exps)) =
	(* [(exps)] = ([exps]) *)
	O.TupExp(i, trExps(env, exps))

      | trExp(env, I.ProdExp(i, row)) =
	(* [{row}] = {[row]}
	 * [{row,exp}] =
	 *   let id = [exp] in {[row],lab1=#lab1 id,...,labN=#labN id}
	 * (where lab_i in type of exp)
	 *)
	let
	    val (flds',expo') = trExpRow(env, row)
	in
	    case expo'
	      of NONE => O.ProdExp(i, flds')
	       | SOME exp' =>
		 let
		     val id'    = auxId(O.infoExp exp')
		     val dec'   = auxDec(id', exp')
		     val idexp' = idExp id'

		     fun extFlds(r, flds2') =
			 case Type.inspectRow r
			   of Type.UnknownRow _ =>
			      raise Crash.Crash "TranslationPhase.trExp"
			    | Type.EmptyRow => Vector.fromList flds2'
			    | Type.FieldRow(l,t,r') =>
			      let
				  val r1   = regionOfExp exp'
				  val lab' = O.Lab(nonInfo r1, l)
				  val exp' = O.SelExp(typInfo(r1,t), lab', idexp')
				  val fld' = O.Fld(nonInfo r1, lab', exp')
			      in
				  extFlds(r', fld'::flds2')
			      end
		     val flds2' = extFlds(Type.asProd(typOfExp exp'), [])
		 in
		     letExp(#[dec'], O.ProdExp(i, Vector.concat[flds',flds2']))
		 end
	end

      | trExp(env, I.SelExp(i, lab, exp)) =
	(* [#lab exp] = #[lab] [exp] *)
	O.SelExp(i, trVallab lab, trExp(env, exp))

      | trExp(env, I.VecExp(i, exps)) =
	(* [#[exps]] = #[[exps]] *)
	O.VecExp(i, trExps(env, exps))

      | trExp(env, I.FunExp(i, mats))	=
	(* [fn mats] = fn [mats] *)
	O.FunExp(i, trMats(env, mats))

      | trExp(env, I.AppExp(i, exp1, exp2)) =
	(* [exp1 exp2] = [exp1] [exp2] *)
	O.AppExp(i, trExp(env, exp1), trExp(env, exp2))

      | trExp(env, I.AndExp(i, exp1, exp2)) =
	(* [exp1 and exp2] = [exp1] and [exp2] *)
	O.AndExp(i, trExp(env, exp1), trExp(env, exp2))

      | trExp(env, I.OrExp(i, exp1, exp2)) =
	(* [exp1 or exp2] = [exp1] or [exp2] *)
	O.OrExp(i, trExp(env, exp1), trExp(env, exp2))

      | trExp(env, I.IfExp(i, exp1, exp2, exp3)) =
	(* [if exp1 then exp2 else exp3] = if [exp1] then [exp2] else [exp3] *)
	O.IfExp(i, trExp(env, exp1), trExp(env, exp2), trExp(env, exp3))

      | trExp(env, I.SeqExp(i, exp1, exp2)) =
	(* [exp1 ; exp2] = [exp1] ; [exp2] *)
	O.SeqExp(i, trExp(env, exp1), trExp(env, exp2))

      | trExp(env, I.CaseExp(i, exp, mats)) =
	(* [case exp of mats] = case [exp] of [mats] *)
	O.CaseExp(i, trExp(env, exp), trMats(env, mats))

      | trExp(env, I.FailExp(i)) =
	(* [fail] = fail *)
	O.FailExp(i)

      | trExp(env, I.LazyExp(i, exp)) =
	(* [lazy exp] = lazy [exp] *)
 	O.LazyExp(i, trExp(env, exp))

      | trExp(env, I.SpawnExp(i, exp)) =
	(* [spawn exp] = spawn [exp] *)
	O.SpawnExp(i, trExp(env, exp))

      | trExp(env, I.RaiseExp(i, exp)) =
	(* [raise exp] = raise [exp] *)
	O.RaiseExp(i, trExp(env, exp))

      | trExp(env, I.HandleExp(i, exp, mats)) =
	(* [try exp handle mats] = try [exp] handle [mats] *)
	O.HandleExp(i, trExp(env, exp), trMats(env, mats))

      | trExp(env, I.AnnExp(i, exp, typ)) =
	(* [exp : typ] = [exp] *)
	trExp(env, exp)

      | trExp(env, I.LetExp(i, decs, exp)) =
	(* [let decs in exp] = let [decs] in [exp] *)
	O.LetExp(i, trDecs(env, decs), trExp(env, exp))

      | trExp(env, I.PackExp(i, mod, inf)) =
	(* [pack mod : inf] =
	 *   let id1 = [mod]
	 *   in seal __Package(strict(id1,
	 *		lazy __pervasive.DynMatch.strengthen(seal id1, [inf])))
	 *)
	let
	    val r     = #region i
	    val r1    = #region(I.infoMod mod)
	    val r2    = #region(I.infoInf inf)

	    val exp1' = trMod(env, mod)
	    val id1'  = auxId(O.infoExp exp1')
	    val dec1' = auxDec(id1', exp1')

	    val exp2' = trInf(env, inf)
	    val exp3' = O.SealExp(typInfo(r1, typ_module env), idExp id1')
	    val exp4' = if not(!Switches.Language.supportRtt) then exp2' else
			rttAppExp(env, r, modlab_dynmatch, lab_strengthen,
				  tupExp(r, #[exp3', exp2']))
	    val exp5' = lazyExp exp4'

	    val exp6' = O.TagExp(typInfo(r, typ_package(env, typOfExp exp1')),
				 O.Lab(nonInfo r, lab_package),
				 strictExp(tupExp(r, #[idExp id1', exp5'])))
	in
	    letExp(#[dec1'], O.SealExp(i, exp6'))
	end

      | trExp(env, I.OverExp(i, exps, typid, typlongids, typ)) =
	(* [overload exps : (typid as typlongids).typ] = ([exps]) *)
	tupExp(#region i, trExps(env, exps))

      | trExp(env, I.OverallExp(i, exp, typid, typ)) =
	(* Type.t is from different builds! *)
	(* [overload exp : typid.typ] = unseal [exp] *)
	O.UnsealExp(trValInfo(env,i), trExp(env, exp))

    and trExpRow(env, I.Row(i, flds, expo)) =
	(* [fld1,...,fldN] = [fld1],...,[fldN] *)
	(Vector.map (fn fld => trExpFld(env, fld)) flds,
	 Option.map (fn exp => trExp(env, exp)) expo)

    and trExpFld(env, I.Fld(i, lab, exp)) =
	(* [lab = exp] = ([lab] = [exp]) *)
	O.Fld(i, trVallab lab, trExp(env, exp))


  (* Matches and Patterns *)

    and trMats(env, mats) =
	(* [mat1|...|matN] = [mat1]|...|[matN] *)
	Vector.map (fn mat => trMat(env, mat)) mats

    and trMat(env, I.Mat(i, pat, exp)) =
	(* [pat -> exp] = [pat] -> [exp] *)
	O.Mat(i, trPat(env, pat), trExp(env, exp))

    and trPats(env, pats) =
	(* [pat1,...,patN] = [pat1],...,[patN] *)
	Vector.map (fn pat => trPat(env, pat)) pats

    and trPat(env, I.JokPat(i)) =
	(* [_] = _ *)
	O.JokPat(i)

      | trPat(env, I.LitPat(i, lit)) =
	(* [lit] = [lit] *)
	O.LitPat(i, trLit lit)

      | trPat(env, I.VarPat(i, id)) =
	(* [id] = [id] *)
	O.VarPat(trValInfo(env,i), trValid(env, id))
 
      | trPat(env, I.TagPat(i, lab, pat)) =
	(* [`lab pat] = `[lab] [pat] *)
	O.TagPat(i, trVallab lab, trPat(env, pat))

      | trPat(env, I.ConPat(i, longid, pat)) =
	(* [@longid pat] = @[longid] [pat] *)
	(O.ConPat(i, trVallongid(env, longid), trPat(env, pat))
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region i, "17\n"); raise VirtualModule))

      | trPat(env, I.RefPat(i, pat)) =
	(* [ref pat] = ref [pat] *)
	O.RefPat(i, trPat(env, pat))

      | trPat(env, I.RollPat(i, pat, typ)) =
	(* [roll pat] = roll [pat] *)
	O.RollPat(i, trPat(env, pat))

      | trPat(env, I.StrictPat(i, pat)) =
	(* [strict pat] = strict [pat] *)
	O.StrictPat(i, trPat(env, pat))

      | trPat(env, I.TupPat(i, pats)) =
	(* [(pats)] = ([pats]) *)
	O.TupPat(i, trPats(env, pats))

      | trPat(env, I.ProdPat(i, row)) =
	(* [{row}] = {[row]}
	 * [{row,pat}] =
	 *   {[row],lab1=id1,...,labN=idN} with [pat]={lab1=id1,...,labN=idN}
	 * (where lab_i in type of pat)
	 *)
	let
	    val (flds',pato') = trPatRow(env, row)
	in
	    case pato'
	      of NONE => O.ProdPat(i, flds')
	       | SOME pat' =>
		 let
		     fun extFlds(r, pflds', eflds') =
			 case Type.inspectRow r
			   of Type.UnknownRow _ =>
			      raise Crash.Crash "TranslationPhase.trExp"
			    | Type.EmptyRow =>
			      (Vector.fromList pflds', Vector.fromList eflds')
			    | Type.FieldRow(l,t,r') =>
			      let
				  val r1    = regionOfPat pat'
				  val id'   = auxId(typInfo(r1,t))
				  val lab'  = O.Lab(nonInfo r1, l)
				  val pat'  = idPat id'
				  val exp'  = idExp id'
				  val pfld' = O.Fld(nonInfo r1, lab', pat')
				  val efld' = O.Fld(nonInfo r1, lab', exp')
			      in
				  extFlds(r', pfld'::pflds', efld'::eflds')
			      end
		     val (pflds',eflds') =
			 extFlds(Type.asProd(typOfPat pat'), [], [])
		     val exp' = O.ProdExp(O.infoPat pat', eflds')
		     val dec' = O.ValDec(origInfo(regionOfPat pat', Aux),
					 pat', exp')
		 in
		     O.WithPat(i, O.ProdPat(i, Vector.concat[flds',pflds']),
			       #[dec'])
		 end
	end

      | trPat(env, I.VecPat(i, pats)) =
	(* [#[pats]] = #[[pats]] *)
	O.VecPat(i, trPats(env, pats))

      | trPat(env, I.AsPat(i, pat1, pat2)) =
	(* [pat1 as pat2] = [pat1] as [pat2] *)
	O.AsPat(i, trPat(env, pat1), trPat(env, pat2))

      | trPat(env, I.AltPat(i, pat1, pat2)) =
	(* [pat1 | pat2] = [pat1] | [pat2] *)
	O.AltPat(i, trPat(env, pat1), trPat(env, pat2))

      | trPat(env, I.NegPat(i, pat)) =
	(* [non pat] = non [pat] *)
	O.NegPat(i, trPat(env, pat))

      | trPat(env, I.GuardPat(i, pat, exp)) =
	(* [pat where exp] = [pat] where [exp] *)
	O.GuardPat(i, trPat(env, pat), trExp(env, exp))

      | trPat(env, I.AnnPat(i, pat, typ)) =
	(* [pat : typ] = [pat] *)
	trPat(env, pat)

      | trPat(env, I.WithPat(i, pat, decs)) =
	(* [pat with decs] = [pat] with [decs] *)
	O.WithPat(i, trPat(env, pat), trDecs(env, decs))

    and trPatRow(env, I.Row(i, flds, (NONE | SOME(I.JokPat _)))) =
	(* [fld1,...,fldN] = [fld1],...,[fldN] *)
	(Vector.map (fn fld => trPatFld(env, fld)) flds, NONE)
      | trPatRow(env, I.Row(i, flds, SOME pat)) =
	(* [fld1,...,fldN] = [fld1],...,[fldN] *)
	(Vector.map (fn fld => trPatFld(env, fld)) flds,
	 SOME(trPat(env, pat)))

    and trPatFld(env, I.Fld(i, lab, pat)) =
	(* [lab = pat] = ([lab] = [pat]) *)
	O.Fld(i, trVallab lab, trPat(env, pat))


  (* Modules *)

    and trMod(env, I.VarMod(i, longid)) =
	(* [longid] = [longid] *)
(	O.VarExp(trModInfo(env,i), trModlongid(env, longid))
(* may happen with functor derived form...
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region i, "11\n"); raise VirtualModule))
*))
      | trMod(env, I.StrMod(i, decs)) =
	(* [struct decs end] = let [decs] in {id1=id1,...,idN=idN}
	 *   (where id_i bound by decs)
	 *)
	let
	    val decs' = trDecs(env, decs)
	    val flds' = Vector.map (idFld idExp) (ids(env, decs))
	in
	    letExp(decs', O.ProdExp(trModInfo(env,i), flds'))
	end

      | trMod(env, I.SelMod(i, lab, mod)) =
	(* [mod.lab] = #[lab] [mod] *)
	O.SelExp(trModInfo(env,i), trModlab lab, trMod(env, mod))

      | trMod(env, I.FunMod(i, id, inf, mod)) =
	(* [fun (id:inf) -> mod] = fun [id] -> [mod] *)
	let
	    val r    = #region i
	    val exp' = trMod(env, mod)
	    val pat' = idPat(trModid(env, id))
(*DEBUG*)handle VirtualModule => (Error.warn'(true, r, Name.toString(I.name id) ^"[" ^ Stamp.toString(I.stamp id) ^ "] 2\n"); raise VirtualModule)
	in
	    O.FunExp(trModInfo(env,i), #[O.Mat(nonInfo r, pat', exp')])
	end

      | trMod(env, I.AppMod(i, mod1, mod2)) =
	(* [mod1 mod2] = unseal (mod1 (seal [mod2 : j_mod1.1])) *)
(* Does not work, because of implicit quantifier removal through subtyping...
   (typechecking of intermediate would fail)
	let
	    val i1        = I.infoMod mod1
	    val i2        = I.infoMod mod2
	    val t1        = infToTyp(env, #inf i1)
	    val (t11,t12) = Type.asArrow t1

	    val exp1'     = trMod(env, mod1)
	    val exp2'     = trMod(env, mod2)
	    val exp3'     = O.SealExp(typInfo(#region i2,t11), exp2')
	    val exp'      = O.AppExp(typInfo(#region i,t12), exp1', exp3')
	in
	    O.UnsealExp(trModInfo(env,i), exp')
	end
*)
	let
	    val i1        = I.infoMod mod1
	    val i2        = I.infoMod mod2
	    val j1        = #inf i1
	    val j2        = #inf i2
	    val t1        = infToTyp(env, j1)
	    val (t11,t12) = Type.asArrow t1

	    val j2'       = Inf.narrow(j2, #2(Inf.asArrow j1))
(*DEBUG*)handle e => (Error.warn'(true, #region i, "4\n"); raise e)
	    val exp2'     = trTransCoerceMod(env, #region i2, mod2, j2')
	    val exp1'     = trMod(env, mod1)

	    val exp3'     = O.SealExp(typInfo(#region i2,t11), exp2')
	    val exp'      = O.AppExp(typInfo(#region i,t12), exp1', exp3')
	in
	    O.UnsealExp(trModInfo(env,i), exp')
	end

      | trMod(env, I.AnnMod(i, mod, inf)) =
	(* [mod : inf] =
	 *   let id1 = [mod] in [id1 : j_mod :> _ = j_inf]
	 *)
	trTransCoerceMod(env, #region i, mod, #inf i)

      | trMod(env, I.SealMod(i, mod, inf)) =
	(* [mod :> inf] =
	 *   let id1 = [mod]; id2 = [inf] in seal [id1 : j_mod :> id2 = j_inf]
	 *)
	trOpaqCoerceMod(env, #region i, mod, trInf(env, inf), #inf i)

      | trMod(env, I.LazyMod(i, mod)) =
	(* [lazy mod] = lazy [mod] *)
	O.LazyExp(trModInfo(env,i), trMod(env, mod))

      | trMod(env, I.SpawnMod(i, mod)) =
	(* [spawn mod] = spawn [mod] *)
	O.SpawnExp(trModInfo(env,i), trMod(env, mod))

      | trMod(env, I.LetMod(i, decs, mod)) =
	(* [let decs in mod] = let [decs] in seal [mod] *)
	(* We must seal, because of a possible avoidance transformation
	 * on the result signature! *)
	let
	    val i'    = trModInfo(env,i)
	    val decs' = trDecs(env, decs)
	    val exp'  = trMod(env, mod)
	in
	    O.LetExp(i', decs', O.SealExp(i', exp'))
	end

      | trMod(env, I.UnpackMod(i, exp, inf)) =
	(* [unpack exp : inf] =
	 *   let __Package(strict(id1,id2)) = unseal [exp]
	 *   in unseal __pervasive.DynMatch.unpackMatch(id1, id2, [inf])
	 *)
	(* Note that we thread the module id1 through the unpackMatch call
	 * instead of returning it directly in order to prevent value
	 * propagation phase from hoisting subsequent selections on it across
	 * the type check, resulting in unsound code! *)
	let
	    val r     = #region i
	    val t1'   = infToTyp(env, #inf(I.infoInf inf))
	    val i'    = typInfo(r, typ_package(env,t1'))

	    val exp1' = O.UnsealExp(i', trExp(env, exp))
	    val id1'  = auxId(typInfo(r, t1'))
	    val id2'  = auxId(typInfo(r, typ_inf env))
	    val pat'  = O.TagPat(i', O.Lab(nonInfo r, lab_package),
			strictPat(tupPat(r, #[idPat id1', idPat id2'])))
	    val dec'  = O.ValDec(origInfo(r,Aux), pat', exp1')
	    val exp'  = if not(!Switches.Language.supportRtt)
			then idExp id1' else
			rttAppExp(env, r, modlab_dynmatch, lab_unpackMatch,
				  tupExp(r, #[idExp id1', idExp id2',
					      trInf(env, inf)]))
	in
	    letExp(#[dec'], O.UnsealExp(typInfo(r,t1'), exp'))
	end

      | trMod(env, I.PrimMod(i, "Cast", inf)) =
	(* [prim "Cast" : (module lab1 : inf; interface lab2) -> lab2] =
	 *   fun id -> seal __pervasive.DynMatch.seal(seal id1.lab1, id2.lab2)
	 *)
	if !Switches.Language.supportRtt then
	let
	    val  r        = #region i
	    val  i'       = trModInfo(env,i)
	    val (t1,t2)   = Type.asArrow(#typ i')
	    val (l1,t11)  = findFld(NameTranslation.isModName, t1)
	    val (l2,t12)  = findFld(NameTranslation.isInfName, t1)
	    val  id'      = auxId(typInfo(r,t1))
	    val  lab1'    = O.Lab(nonInfo r, l1)
	    val  lab2'    = O.Lab(nonInfo r, l2)
	    val  longid1' = O.LongId(typInfo(r,t11), shortId id', lab1')
	    val  longid2' = O.LongId(typInfo(r,t12), shortId id', lab2')
	    val  exp1'    = O.SealExp(typInfo(r, typ_module env),
				      longidExp longid1')
	    val  exp2'    = rttAppExp(env, r, modlab_dynmatch, lab_seal,
				     tupExp(r, #[exp1', longidExp longid2']))
	    val  exp'     = O.SealExp(typInfo(r,t2), exp2')
	in
	    O.FunExp(i', #[O.Mat(nonInfo r, idPat id', exp')])
	end
	else
	(* [prim "Cast" : (module lab1 : inf; interface lab2) -> lab2] =
	 *   fun id -> seal id.lab1
	 *)
	let
	    val  r       = #region i
	    val  i'      = trModInfo(env,i)
	    val (t1,t2)  = Type.asArrow(#typ i')
	    val (l1,t11) = findFld(NameTranslation.isModName, t1)
	    val  id'     = auxId(typInfo(r,t1))
	    val  lab'    = O.Lab(nonInfo r, l1)
	    val  longid' = O.LongId(typInfo(r,t11), shortId id', lab')
	    val  exp'    = O.SealExp(typInfo(r,t2), longidExp longid')
	in
	    O.FunExp(i', #[O.Mat(nonInfo r, idPat id', exp')])
	end

      | trMod(env, I.PrimMod(i, "Reflect", inf)) =
	(* [prim "Reflect" : (interface lab1; module lab2 : lab1) -> (lab3 : Value.t)] =
	 *   fun {[lab2]=id,...} -> {[lab3]=id}
	 *)
	(let
	    val  r       = #region i
	    val  i'      = trModInfo(env,i)
	    val (t1,t2)  = Type.asArrow(#typ i')
	    val (l1,t11) = findFld(NameTranslation.isModName, t1)
	    val (l2,t21) = findFld(NameTranslation.isValName, t2)
	    val  id'     = auxId(typInfo(r,t11))
	    val  pat'    = O.ProdPat(typInfo(r,t1), #[fld(r, l1, idPat id')])
	    val  exp'    = O.ProdExp(typInfo(r,t2), #[fld(r, l2, idExp id')])
	in
	    O.FunExp(i', #[O.Mat(nonInfo r, pat', exp')])
	end
	handle Type.Type => raise Crash.Crash "trPrimMod: Reflect")

      | trMod(env, I.PrimMod(i, "Reify", inf)) =
	(* [prim "Reify" : (lab1 : Value.t; interface lab2) -> lab2] =
	 *   fun {[lab1]=id,...} -> id
	 *)
	(let
	    val  r       = #region i
	    val  i'      = trModInfo(env,i)
	    val (t1,t2)  = Type.asArrow(#typ i')
	    val (l1,t11) = findFld(NameTranslation.isValName, t1)
	    val (l2,t21) = findFld(NameTranslation.isInfName, t2)
	    val  id'     = auxId(typInfo(r,t11))
	    val  pat'    = O.ProdPat(typInfo(r,t1), #[fld(r, l1, idPat id')])
	    val  exp'    = idExp id'
	in
	    O.FunExp(i', #[O.Mat(nonInfo r, pat', exp')])
	end
	handle Type.Type => raise Crash.Crash "trPrimMod: Reflect")

      | trMod(env, I.PrimMod(i, "ReflectSig", inf)) =
	(* [prim "ReflectSig" : (interface id1) -> (id2 : Inf.t)] =
	 *   fun {[id1]=id} -> {[id2]=id}
	 *)
	(let
	    val  r       = #region i
	    val  i'      = trModInfo(env,i)
	    val (t1,t2)  = Type.asArrow(#typ i')
	    val (l1,t11) = findFld(NameTranslation.isInfName, t1)
	    val (l2,t21) = findFld(NameTranslation.isValName, t2)
	    val  id'     = auxId(typInfo(r,t11))
	    val  pat'    = O.ProdPat(typInfo(r,t1), #[fld(r, l1, idPat id')])
	    val  exp'    = O.ProdExp(typInfo(r,t2), #[fld(r, l2, idExp id')])
	in
	    O.FunExp(i', #[O.Mat(nonInfo r, pat', exp')])
	end
	handle Type.Type => raise Crash.Crash "trPrimMod: Reflect")

      | trMod(env, I.PrimMod(i, "ReifySig", inf)) =
	(* [prim "ReifySig" : (lab1 : Inf.t) -> (interface lab2)] =
	 *   fun {[lab1]=id} -> {[lab2]=id}
	 *)
	(let
	    val  r       = #region i
	    val  i'      = trModInfo(env,i)
	    val (t1,t2)  = Type.asArrow(#typ i')
	    val (l1,t11) = findFld(NameTranslation.isValName, t1)
	    val (l2,t21) = findFld(NameTranslation.isInfName, t2)
	    val  id'     = auxId(typInfo(r,t11))
	    val  pat'    = O.ProdPat(typInfo(r,t1), #[fld(r, l1, idPat id')])
	    val  exp'    = O.ProdExp(typInfo(r,t2), #[fld(r, l2, idExp id')])
	in
	    O.FunExp(i', #[O.Mat(nonInfo r, pat', exp')])
	end
	handle Type.Type => raise Crash.Crash "trPrimMod: Reflect")

      | trMod(env, I.PrimMod(i, s, inf)) =
	(* [prim s : inf] = prim s *)
	O.PrimExp(trModInfo(env,i), s)


  (* Signature coercions *)

    (*
     * We use the following transformation rules:
     *
     *	[x1 : j1 :> x2 = any] = fail
     *	[x1 : j1 :> x2 = c] = ...
     *	[x1 : sig item1* end :> x2 = sig item2* end] =
     *	   let x2' = Inf.asSig x2 in struct [x1 . item1 :> x2' . item2]* end
     *	[x1 : fct(x11:j11)->j12 :> x2 = fct(x21:j21)->j22] =
     *	   fct(y:j21) => let z = x1(seal [y : j21 :> _ = j11])
     *                       x3 = x2 y
     *                   in unseal [z : j12 :> x3 = j22]
     *  [x1 : (x1':j1) :> x2 = j2] = [x1 : j1 :> x2 = j2]
     *  [x1 : j1 :> x2 = (x2':j2)] = [x1 : j1 :> x2 = j2]
     *
     *	[x1 . val y:t1 :> x2 . val y:t2] = val y = x1.y
     *	[x1 . constructor y:t1 :> x2 . val y:t2] = val y = x1.y
     *  [x1 . type y:k1 :> x2 . type y:k2 = t2] =
     *     type y = lazy Inf.lookupTyp(x2,"y")
     *	[x1 . structure y:j1 :> x2 . structure y:j2] =
     *	   structure y = [x1.y : j1 :> x2.y = j2]
     *  [x1 . interface y:k1 :> x2 . interface y:k2 = j2] =
     *     interface y = lazy Inf.lookupInf(x2,"y")
     *
     * Here in [x1 : j1 :> x2 = j2] the structure is bound to x1 and has
     * signature j1, while the runtime representation of interface j2 is
     * bound to x2.
     *
     * Note that the contravariant coercion of a functor argument is always
     * transparent and so no interface representation is needed. We can thus
     * pass whatever we want for x2, it remains unused.
     *
     * Moreover, we apply the optimization that - if the transformation is the
     * identity function - the coercion is a no-op.
     *)

    and trTransCoerceMod(env,r,m,j2) =
	(* [m : j] = let val x1 = [m]
	 *           in [x1 : j1 :> _ = j2]
	 *)
	let
	    val e1' = trMod(env,m)
	    val x1' = auxId(O.infoExp e1')
	    val x1  = shortId x1'
	    val j1  = #inf(I.infoMod m)
	in
	    case coerceMod(env, r, x1,j1,NONE,j2,j2, false)
	      of NONE    => e1'
	       | SOME e' =>
		 let
		     val d' = auxDec(x1', e1')
		 in
		     letExp(#[d'], e')
		 end
	end

    and trOpaqCoerceMod(env,r,m,e2',j2) =
	(* [m :> j] = let val x1 = [m]
	 *                val x2 = lazy [j]
	 *            in seal [x1 : j1 :> x2 = j2]
	 *)
	if not(!Switches.Language.supportRtt) then
	    let
		val j1  = #inf(I.infoMod m)
		val j2' = Inf.narrow(j1,j2)
(*DEBUG*)handle e as Inf.Mismatch _ => (Error.warn'(true, r,"match5\n");raise e)
	    in
		O.SealExp(typInfo(r,infToTyp(env,j2)),
			  trTransCoerceMod(env,r,m,j2'))
	    end
	else let
	    val i'  = typInfo(r,infToTyp(env,j2))

	    val e1' = trMod(env,m)
	    val x1' = auxId(O.infoExp e1')
	    val x1  = shortId x1'
	    val j1  = #inf(I.infoMod m)

	    val x2' = auxId(typInfo(r, typ_inf env))
	    val x2  = shortId x2'
	    val j2' = Inf.narrow(j1,j2)
(*DEBUG*)handle e as Inf.Mismatch _ => (Error.warn'(true, r,"match1\n");raise e)
	in
	    case coerceMod(env, r, x1,j1,SOME x2,j2,j2', false)
	      of NONE    => O.SealExp(i', e1')
	       | SOME e' =>
		 let
		     val d1' = auxDec(x1', e1')
		     val d2' = auxDec(x2', lazyExp e2')
		 in
		     letExp(#[d1',d2'], O.SealExp(i', e'))
		 end
	end

    and coerceMod(env, r, x1,j1,x2o,j2,j2', isntIdentity) =
	(* [x1 : j1 :> x2 = j2]
	 * Generates a coercion for the module bound to x1 at runtime, which
	 * has interface j1, to interface j2, which is bound to x2 at runtime.
	 * j2' is the transparent (matched) version of j2, ie. the result of
	 * Inf.match(j1,j2). x2 may be absent (indicated by _ in the rules
	 * below) if we are doing a transparent coercion.
	 *)
	case (Inf.inspect j1, Inf.inspect j2)
	 of (_, Inf.Top) =>
	    (* [x1 : j1 :> x2 = any] = () *)
	    (case x2o
	     of NONE    => NONE
	      | SOME x2 => SOME(unitExp r)
	    )
	  | (_, Inf.Con p2) =>
	    (case x2o
	     of NONE =>
		(* [x1 : p1 :> _ = p2] = x1 *)
		(*UNFINISHED: this should not be...*)
		(* Note: If we match transparently and have two constructors
		 * then they are necessarily the same at runtime.
		 * However, it is not necessarily the case during translation
		 * because we do transparent coercions for functor sig arguments
		 * even in the opaque case, so that no proper substitution has
		 * been performed to equalize them. Example:
		 *   fct(signature S) -> ()  :>  fct(signature S) -> ()
		 * So we cannot put in an assertion here!
		(*ASSERT assert Path.equal(p1,p2) do *)
		if not(Path.equal(Inf.asCon j1, Inf.asCon j2')))
		then assert false else
		 *)
		(*TODO: Should perform dynamic thinning here. However,
		 *      that would require computing signatures for transparent
		 *      annotations (costly). To obscure for now. *)
		NONE
	      | SOME x2 =>
		(* [x1 : j1 :> x2 = p] =
		 *      unseal __pervasive.DynMatch.seal(seal x1, x2)
		 *)
		let
		    val e1 = O.SealExp(typInfo(r, typ_module env), longidExp x1)
		    val e2 = rttAppExp(env, r, modlab_dynmatch, lab_seal,
				       tupExp(r, #[e1, longidExp x2]))
		    val e3 = O.UnsealExp(typInfo(r, infToTyp(env,j2)), e2)
		in
		    SOME e3
		end
	    )
	  | (Inf.Sig s1, Inf.Sig s2) =>
	    (* [x1 : sig item1* end :> x2 = sig item2* end] =
	     *     let x3 = lazy Inf.asSig x2 in
	     *     struct [x1 . item1 :> x3 . item2]* end
	     * [x1 : sig item1* end :> _ = sig item2* end] =
	     *     struct [x1 . item1 :> _ . item2]* end
	     *)
	    let
		val s2' = Inf.asSig j2'
		val x3' = auxId(typInfo(r, typ_sig env))
		val x3o = Option.map (fn _ => shortId x3') x2o
		val (isntIdentity',flds,row) =
		    coerceStr(env, r, x1,s1, x3o, List.rev(Inf.items s2), s2',
			      isntIdentity, [], Type.unknownRow())
	    in
		if isntIdentity'
		orelse List.length(Inf.items s1)<>List.length(Inf.items s2) then
		    let
			val e = O.ProdExp(typInfo(r,Type.prod row), flds)
		    in
			SOME(
			    case x2o of NONE => e | SOME x2 =>
			    let
				val e1 = infExp(env, lab_asSig, longidExp x2)
				val e2 = lazyExp e1
				val d1 = auxDec(x3', e2)
			    in
				letExp(#[d1], e)
			    end)
		    end
		else
		    NONE
	    end
	  | (Inf.Arrow(p1,j11,j12), Inf.Arrow(p2,j21,j22)) =>
	    (* [x1 : fct(x11:j11)->j12 :> x2 = fct(x21:j21)->j22] =
	     *     fct(x3:j21) =>
	     *        let x4 = (unseal x1)(seal [x3 : j21 :> _ = j11])
	     *            x5 = Inf.realise([rea x3 : j22] (*UNFINISHED*), j22)
	     *        in unseal [x4 : j12 :> x5 = j22]
	     * [x1 : fct(x11:j11)->j12 :> _ = fct(x21:j21)->j22] =
	     *     fct(x3:j21) =>
	     *        let x4 = (unseal x1)(seal [x3 : j21 :> _ = j11])
	     *        in unseal [x4 : j12 :> _ = j22]
	     *)
	    let
		val (_,j21',j22') = Inf.asArrow j2'
		val  rea          = Inf.match(j21',j11)
(*DEBUG*)handle e as Inf.Mismatch _ => (Error.warn'(true, r,"match2\n");raise e)
		val  j11'         = Inf.narrow(j21',j11)
		val  _            = PathMap.insert(#mod_rea rea, p1,
						   Inf.mod(p2,j11'))
		val  j12'         = Inf.realise(rea, j12)
		val  j22'         = Inf.narrow(j12',j22')
(*DEBUG*)handle e as Inf.Mismatch _ => (Error.warn'(true, r,"match3\n");raise e)

		val i11 = typInfo(r, infToTyp(env,j11'))
		val i12 = typInfo(r, infToTyp(env,j12'))
		val i21 = typInfo(r, infToTyp(env,j21'))
		val i22 = typInfo(r, infToTyp(env,j22'))
		val i1  = typInfo(r, Type.arrow(#typ i11, #typ i12))
		val i2  = typInfo(r, Type.arrow(#typ i21, #typ i22))
		val i'  = nonInfo r

		val x3' = auxId i21
		val x4' = auxId i12
		val x5' = auxId(typInfo(r, typ_inf env))
		val x3  = shortId x3'
		val x4  = shortId x4'
		val x5o = Option.map (fn _ => shortId x5') x2o
		val isntIdentity' = isntIdentity orelse not(Inf.isEmptyRea rea)
	    in
		case (coerceMod(env, r, x3,j21', NONE,j11,j11', false),
		      coerceMod(env, r, x4,j12', x5o,j22',j22', isntIdentity))
		 of (NONE, NONE) =>
		     (* Optimized: unseal x1 *)
			if isntIdentity orelse not(Inf.isEmptyRea rea)
			then SOME(O.UnsealExp(i2, longidExp x1))
			else NONE
		  | (SOME e1, NONE) =>
		     (* Optimized:
		      * unseal (unseal x1)(seal [x3 : j21 :> _ = j11]) *)
		     let
			val e3 = O.SealExp(i11, e1)
			val e4 = O.AppExp(i12, O.UnsealExp(i1,longidExp x1), e3)
			val e  = O.UnsealExp(i22, e4)
		     in
			SOME(O.FunExp(i2, #[O.Mat(i', idPat x3', e)]))
		     end
		  | (e1o, SOME e2) =>
		    let
			val e3 = case e1o of SOME e1 => O.SealExp(i11, e1)
					   | NONE => O.SealExp(i11, idExp x3')
			val e4 = O.AppExp(i12, O.UnsealExp(i1,longidExp x1), e3)
			val e6 = O.UnsealExp(i22, e2)
			val d1 = auxDec(x4', e4)
			val ds = case x2o of NONE => #[d1] | SOME x2 =>
				 let
				     val e51 = infExp(env, lab_asArrow,
						      longidExp x2)
				     val e52 = selExp(r,3,e51)
				     val e5  = lazyExp e52
				     (*UNFINISHED: realise *)
				     val d2  = auxDec(x5', e5)
				 in
				     #[d1,d2]
				 end
			val e  = letExp(ds, e6)
		    in
			SOME(O.FunExp(i2, #[O.Mat(i', idPat x3', e)]))
		    end
	    end
	  | (Inf.Exist(_,_,j12), _) =>
		coerceMod(env, r, x1,j12,x2o,j2,j2', isntIdentity)
	  | (_, Inf.Exist(_,_,j22)) =>
		coerceMod(env, r, x1,j1,x2o,j22,j2', isntIdentity)
	  | (Inf.Sing m1, _) =>
		coerceMod(env, r, x1,#2(Inf.asMod m1),x2o,j2,j2', isntIdentity)
	  | (_, Inf.Sing m2) =>
		coerceMod(env, r, x1,j1,x2o,#2(Inf.asMod m2),j2', isntIdentity)
	  | (_, (Inf.Sig _ | Inf.Arrow _ | Inf.Lambda _ | Inf.Apply _)) =>
		assert false

    and coerceStr(env, r, x1,s1, x2o,[],s2', isntIdentity, flds, row) =
	    (isntIdentity, Vector.fromList flds, row)
      | coerceStr(env, r, x1,s1, x2o,item::items,s2', isntIdentity, flds, row) =
	(* [x1 . item1 :> x2 . item2]
	 * Generates a coercion for the field item1 of the structure bound to
	 * x1 at runtime, to the form item2 as found in the interface s2, which
	 * is bound to x2 at runtime.
	 * s2' is the transparent (matched) version of s2, ie. the result of
	 * Inf.match(s1,s2). x2 may be absent (indicated by _ in the rules
	 * below) if we are doing a transparent coercion.
	 *)
	case Inf.inspectItem item
	 of Inf.ValItem(l,_) =>
	    (* [x1 . val y:t1 :> x2 . val y:t2] = val y = x1.y
	     *)
	    let
		val t1  = Inf.lookupVal(s1,l)
		val t2  = Inf.lookupVal(s2',l)
		val i'  = nonInfo r
		val l'  = LabelTranslation.trValLabel l
		val ll' = O.Lab(i',l')
		val y1  = O.LongId(typInfo(r,t1), x1, ll')
		val exp = O.VarExp(typInfo(r,t2), y1)
		val isntIdentity' = isntIdentity orelse not(Type.equal(t1,t2))
	    in
		coerceStr(env, r, x1,s1, x2o,items,s2', isntIdentity',
			  O.Fld(i',ll',exp)::flds, Type.extendRow(l',t2,row))
	    end
	  | Inf.TypItem(p,k) =>
	    (* [x1 . type y:k1 :> x2 . type y:k2 = t2] =
	     *     type y = lazy Inf.lookupTyp'(x2, Label.fromString "y")
	     * [x1 . type y:k1 :> _ . type y:k2 = t2] =
	     *     type y = x1.y
	     *)
	    let
		val l   = Path.toLab p
		val i'  = nonInfo r
		val t'  = typ_typ env
		val i   = typInfo(r,t')
		val l'  = LabelTranslation.trTypLabel l
		val ll' = O.Lab(i',l')
		val (isntIdentity',exp) =
		    case x2o of NONE =>
			let
			    val y  = O.LongId(i, x1, ll')
			    val e  = longidExp y
			in
			    (isntIdentity, e)
			end
		    | SOME x2 =>
			let
			    val e1 = longidExp x2
			    val e2 = labExp(env, r, l)
			    val e3 = tupExp(r, #[e1,e2])
			    val e  = lazyExp(infExp(env, lab_lookupTyp', e3))
			in
			    (true, e)
			end
	    in
		coerceStr(env, r, x1,s1, x2o,items,s2', isntIdentity',
			  O.Fld(i',ll',exp)::flds, Type.extendRow(l',t',row))
	    end
	  | Inf.ModItem(p,j2) =>
	    (*	[x1 . structure y:j1 :> x2 . structure y:j2] =
	     *	   structure y =
	     *         let x3 = lazy Inf.lookupMod(x2, Label.fromString "y")
	     *         in [x1.y : j1 :> x3 = j2]
	     *	[x1 . structure y:j1 :> _ . structure y:j2] =
	     *	   structure y = [x1.y : j1 :> _ = j2]
	     *)
	    let
		val    l      = Path.toLab p
		val    j1     = Inf.lookupMod(s1,l)
		val    j2'    = Inf.lookupMod(s2',l)
		val    t1     = infToTyp(env,j1)
		val    i1     = typInfo(r,t1)
		val    i'     = nonInfo r
		val    l'     = LabelTranslation.trModLabel l
		val    ll'    = O.Lab(i', l')
		val    y1     = O.LongId(i1,x1,ll')
		val (x3o,mkE) = case x2o of NONE => (NONE, fn e=>e) | SOME x2 =>
				let
				    val i3 = typInfo(r, typ_inf env)
				    val x3 = auxId i3
				in
				   (SOME(O.ShortId(i3,x3)),
				    fn e0 =>
				    let
					val e1 = longidExp x2
					val e2 = labExp(env, r, l)
					val e3 = tupExp(r, #[e1,e2])
					val e  = lazyExp(
						  infExp(env, lab_lookupMod, e3))
					val d  = auxDec(x3, e)
				    in
					letExp(#[d], e0)
				    end)
				end
		val (isntIdentity',exp) =
		    case coerceMod(env, r, y1,j1, x3o,j2,j2', isntIdentity)
		      of NONE     => (isntIdentity, longidExp y1)
		       | SOME exp => (true, mkE exp)
		val t' = #typ(O.infoExp exp)
	    in
		coerceStr(env, r, x1,s1, x2o,items,s2', isntIdentity',
			  O.Fld(i',ll',exp)::flds, Type.extendRow(l',t',row))
	    end
	  | Inf.InfItem(p,k) =>
	    (*  [x1 . interface y:k1 :> x2 . interface y:k2 = j2] =
	     *     interface y = lazy Inf.lookupInf'(x2, Label.fromString "y")
	     *  [x1 . interface y:k1 :> _ . interface y:k2 = j2] =
	     *     interface y = x1.y
	     *)
	    let
		val l   = Path.toLab p
		val i'  = nonInfo r
		val t'  = typ_inf env
		val i   = typInfo(r,t')
		val l'  = LabelTranslation.trInfLabel l
		val ll' = O.Lab(i',l')
		val (isntIdentity',exp) =
		    case x2o of NONE =>
			let
			    val y  = O.LongId(i, x1, ll')
			    val e  = longidExp y
			in
			    (isntIdentity, e)
			end
		    | SOME x2 =>
			let
			    val e1 = longidExp x2
			    val e2 = labExp(env, r, l)
			    val e3 = tupExp(r, #[e1,e2])
			    val e  = lazyExp(infExp(env, lab_lookupInf', e3))
			in
			    (true, e)
			end
	    in
		coerceStr(env, r, x1,s1, x2o,items,s2', isntIdentity',
			  O.Fld(i',ll',exp)::flds, Type.extendRow(l',t',row))
	    end
	  | (Inf.FixItem _ | Inf.HiddenItem _) =>
		coerceStr(env, r, x1,s1, x2o,items,s2', isntIdentity, flds, row)



  (* Types *)

    and trTyp(env, typ) =
	if not(!Switches.Language.supportRtt)
	then O.FailExp(trTypInfo(env, I.infoTyp typ))
	else trTyp'(env, typ)

    and trTyp'(env, I.JokTyp _) =
	raise Crash.Crash "TranslationPhase.trTyp: JokTyp"

      | trTyp'(env, I.VarTyp(i, id)) =
	(* ['id] = __pervasive.Type.var [id] *)
	let
	    val id' = trVarid(env, id)
	in
	    typExp(env, lab_var, idExp id')
	end

      | trTyp'(env, I.PrimTyp(i, s)) =
	(* [prim s] = __pervasive.PervasiveType.lookup s *)
	let
	    val r = #region i
	in
	    pervTypExp(env, #region i, s)
	end

      | trTyp'(env, I.ConTyp(i, longid)) =
	(* [longid] = $longid   (if longid not anchored virtually)
	 * [longid] = [longid]_virt (if longid anchored virtually)
	 *)
	(let
	    val longid' = trTyplongid(env, longid)
	in
	    longidExp longid'
	end
	handle VirtualModule => trVirtTyplongid(env, longid))

      | trTyp'(env, I.FunTyp(i, id, typ)) =
	(* [fun id -> t] =
	 *   let $id = __pervasive.Type.newVar(k_id, Unconstrained)
	 *   in __pervasive.Type.lambda($id, [typ])
	 *)
	let
	    val (k1,k2) = Type.asArrowKind(Type.kind(#typ i))
	in
	    trBindTyp(env, lab_lambda, i, id, k1, typ)
	end

      | trTyp'(env, I.AppTyp(i, typ1, typ2)) =
	(* [typ1 typ2] = __pervasive.Type.apply([typ1], [typ2]) *)
	let
	    val exp1' = trTyp'(env, typ1)
	    val exp2' = trTyp'(env, typ2)
	in
	    typExp(env, lab_apply, tupExp(#region i, #[exp1', exp2']))
	end

      | trTyp'(env, I.TupTyp(i, typs)) =
	(* [(typ1,...,typN)] = __pervasive.Type.tuple #[[typ1],...,[typN]] *)
	let
	    val exps' = Vector.map (fn typ => trTyp'(env, typ)) typs
	in
	    typExp(env, lab_tuple, vecExp(#region i, typ_typ env, exps'))
	end

      | trTyp'(env, I.ProdTyp(i, row)) =
	(* [{row}] = __pervasive.Type.prod [row] *)
	let
	    val exp' = trTypRow(env, row)
	in
	    typExp(env, lab_prod, exp')
	end

      | trTyp'(env, I.SumTyp(i, row)) =
	(* [<row>] = __pervasive.Type.sum [row] *)
	let
	    val exp' = trTypRow(env, row)
	in
	    typExp(env, lab_sum, exp')
	end

      | trTyp'(env, I.ArrTyp(i, typ1, typ2)) =
	(* [typ1 -> typ2] = __pervasive.Type.arrow([typ1], [typ2]) *)
	let
	    val exp1' = trTyp'(env, typ1)
	    val exp2' = trTyp'(env, typ2)
	in
	    typExp(env, lab_arrow, tupExp(#region i, #[exp1', exp2']))
	end

      | trTyp'(env, I.AllTyp(i, id, typ)) =
	(* [!id -> typ] =
	 *   let $id = __pervasive.Type.newVar(k_id, Unconstrained)
	 *   in __pervasive.Type.all($id, [typ])
	 *)
	let
	    val (a,_) = Type.asAll(#typ i)
	in
	    trBindTyp(env, lab_all, i, id, Type.kindVar a, typ)
	end

      | trTyp'(env, I.ExTyp(i, id, typ)) =
	(* [?id -> typ] =
	 *   let $id = __pervasive.Type.newVar(k_id, Unconstrained)
	 *   in __pervasive.Type.exists($id, [typ])
	 *)
	let
	    val (a,_) = Type.asExist(#typ i)
	in
	    trBindTyp(env, lab_exist, i, id, Type.kindVar a, typ)
	end

      | trTyp'(env, I.SingTyp(i, longid)) =
	(* [sing longid] = __pervasive.Type.sing [longid] *)
	(*UNFINISHED*)
	unfinished (#region i) "trTyp" "runtime singleton types"

      | trTyp'(env, I.AbsTyp _) =
	raise Crash.Crash "TranslationPhase.trTyp: AbsTyp"

    and trTypRep(env, id, typ) =
	if not(!Switches.Language.supportRtt)
	then O.FailExp(trTypInfo(env, I.infoTyp typ))
	else
	    let
		val pathexp' = pathExp(env, #region(I.infoId id), I.name id)
	    in
		case trTypRep'(env, pathexp', typ)
		  of NONE      => trTyp'(env, typ)
		   | SOME exp' => exp'
	    end

    and trTypRep'(env, pathexp', I.FunTyp(i, id, typ)) =
	(* [fun id -> typ]_p = [typ]_p *)
	trTypRep'(env, pathexp', typ)

      | trTypRep'(env, pathexp', I.AbsTyp(i, eq, isExt)) =
	(* [abstract]_p = __pervasive.Type.con(p, k) *)
	let
	    val r    = #region i
	    val exp' = kindExp(env, r, Type.kind(#typ i))
	in
	    SOME(typExp(env, lab_con, tupExp(r, #[pathexp', exp'])))
	end

      | trTypRep'(env, pathexp', typ) = NONE

    and trTypRow(env, I.Row(i, flds, typo)) =
	(* [fld1,...,fldN]     =
	 *   [fld1](...([fldN](__pervasive.Type.emptyRow())...)
	 * [fld1,...,fldN,typ] =
	 *   [fld1](...([fldN](__pervasive.Type.asProd[typ])...)
	 *)
	let
	    val exp' = case typo
			 of NONE => typExp(env, lab_emptyRow,unitExp(#region i))
			  | SOME typ => typExp(env, lab_asProd, trTyp(env, typ))
	in
	    Vector.foldl (fn(fld, exp') => trTypFld(env, fld, exp')) exp' flds
	end

    and trTypFld(env, I.Fld(i1, I.Lab(i2,l), typ), tailexp') =
	(* [lab : typ]_e =
	 *   __pervasive.Type.extendRow(Label.fromString "lab", [typ], e)
	 *)
	let
	    val r     = #region i1
	    val exp1' = labExp(env, #region i2, l)
	    val exp2' = trTyp'(env, typ)
	in
	    typExp(env, lab_extendRow, tupExp(r, #[exp1', exp2', tailexp']))
	end

    and trBindTyp(env, lab_binder, i, id, k_id, typ) =
	(* [binder id -> typ] =
	 *   let $id = __pervasive.newVar(k_id, Unconstrained)
	 *   in __pervasive.Type.binder($id, [typ])
	 *)
	let
	    val r     = #region i
	    val exp0' = typExp(env, lab_newVar,
			       tupExp(r, #[kindExp(env, r, k_id),
					   unconstrainedExp(env, r)]))
	    val id'   = trVarid(env, id)
	    val dec'  = auxDec(id', exp0')

	    val exp2' = trTyp'(env, typ)
	    val exp'  = typExp(env, lab_binder, tupExp(r, #[idExp id', exp2']))
	in
	    letExp(#[dec'], exp')
	end


  (* Interfaces *)

    (* TODE: Currently, paths are always flat and hence do not preserve the
     * same invariants as in the static semantics.
     *)

    and trInf(env, inf) =
	if not(!Switches.Language.supportRtt)
	then O.FailExp(trInfInfo(env, I.infoInf inf))
	else trInf'(env, inf)

    and trInf'(env, I.TopInf(i)) =
	(* [any] = __pervasive.Inf.top() *)
	let
	    val r = #region i
	in
	    infExp(env, lab_top, unitExp r)
	end

      | trInf'(env, I.PrimInf(i, s)) =
	(* [prim s] = __pervasive.PervasiveInf.lookup s *)
	let
	    val r = #region i
	in
	    pervInfExp(env, r, s)
	end

      | trInf'(env, I.ConInf(i, longid)) =
	(* [longid] =
	 *   #1(__pervasive.Inf.instance(__pervasive.Path.fromString "_dynamic",
	 *				 [longid]))
	 *)
	let
	    val r     = #region i
	    val exp1' = pathExp(env, r, name_dynamic)
	    val exp2' = longidExp(trInflongid(env, longid))
			handle VirtualModule => trVirtInflongid(env, longid)
	    val exp'  = infExp(env, lab_instance, tupExp(r, #[exp1', exp2']))
	in
	    selExp(r, 1, exp')
	end

      | trInf'(env, I.SigInf(i, specs)) =
	(* [sig specs end] =
	 *   let id = __pervasive.Inf.emptySig()
	 *       [specs]_id
	 *   in __pervasive.Inf.sig id
	 *)
	let
	    val r     = #region i
	    val exp0' = infExp(env, lab_emptySig, unitExp r)
	    val id'   = auxId(typInfo(r, typ_sig env))
	    val dec'  = auxDec(id', exp0')
	    val decs' = trSpecs(env, idExp id', specs)
	    val exp'  = infExp(env, lab_sig, idExp id')
	in
	    letExp(Vector.concat[#[dec'], decs'], exp')
	end

      | trInf'(env, I.FunInf(i, id, inf1, inf2)) =
	(* [fun id : inf1 -> inf2] =
	 *   let id0 = __pervasive.Path.invent()
	 *       id$ = [inf1]
	 *       id2 = [inf2]
	 *   in __pervasive.Inf.lambda(id0, id$, id2)
	 *)
	trBindInf(env, lab_lambda, i, id, inf1, inf2)

      | trInf'(env, I.AppInf(i, inf, mod)) =
	(* [inf mod] = __pervasive.Inf.apply([inf], [mod]) *)
	let
	    val r     = #region i
	    val exp1' = trInf'(env, inf)
	    val exp2' = trInfMod(env, mod)
	in
	    infExp(env, lab_apply, tupExp(r, #[exp1', exp2']))
	end

      | trInf'(env, I.InterInf(i, inf1, inf2)) =
	(* [inf1 where inf2] = __pervasive.Inf.infimum([inf1], [inf2])
	 *)
	let
	    val r     = #region i
	    val exp1' = trInf'(env, inf1)
	    val exp2' = trInf'(env, inf2)
	in
	    infExp(env, lab_infimum, tupExp(r, #[exp1', exp2']))
	end

      | trInf'(env, I.ArrInf(i, id, inf1, inf2)) =
	(* [id:inf1 -> inf2] =
	 *   let id0 = __pervasive.Path.invent()
	 *       id$ = [inf1]
	 *       id2 = [inf2]
	 *   in __pervasive.Inf.arrow(id0, id$, id2)
	 *)
	trBindInf(env, lab_arrow, i, id, inf1, inf2)

      | trInf'(env, I.LetInf(i, decs, inf)) =
	(* [let decs in inf] = let [decs] in [inf] *)
	(*TODO: Don't we have to build an existential here? *)
	O.LetExp(trInfInfo(env,i), trDecs(env, decs), trInf'(env, inf))

      | trInf'(env, I.SingInf(i,(I.AnnMod(_,mod,inf) | I.SealMod(_,mod,inf)))) =
	(* [sing mod : inf] =
	 *   __pervasive.DynMatch.strengthen(seal [mod], [inf])
	 *)
	let
	    val r     = #region i
	    val r1    = #region(I.infoMod mod)
	    val exp1' = O.SealExp(typInfo(r1, typ_module env), trMod(env, mod))
	    val exp2' = trInf'(env, inf)
	in
	    rttAppExp(env, r, modlab_dynmatch, lab_strengthen,
		      tupExp(r, #[exp1', exp2']))
	end

      | trInf'(env, I.SingInf(i, mod)) =
	(* [sing mod] = __pervasive.Inf.sing [mod] *)
	let
	    val exp' = trInfMod(env, mod)
	in
	    infExp(env, lab_sing, exp')
	end

      | trInf'(env, I.AbsInf(i)) =
	raise Crash.Crash "TranslationPhase.trInf: AbsInf"

    and trInfRep(env, id, inf) =
	if not(!Switches.Language.supportRtt)
	then O.FailExp(trInfInfo(env, I.infoInf inf))
	else
	    let
		val pathexp' = pathExp(env, #region(I.infoId id), I.name id)
	    in
		case trInfRep'(env, fn k => k, pathexp', inf)
		  of NONE      => trInf'(env, inf)
		   | SOME exp' => exp'
	    end

    and trInfRep'(env, mkKind, pathexp', I.FunInf(i, id, inf1, inf2)) =
	(* [fun id : inf1 -> inf2]_p =
	 *   let id1 = __pervasive.Path.fromString "id"
	 *       id$ = [inf1]
	 *   in __pervasive.Inf.depKind(id1, id$, [inf2]_p)
	 *)
	let
	    fun mkKind' k =
		let
		    val r     = #region i
		    val r1    = #region(I.infoId id)
		    val exp1' = pathExp(env, r1, I.name id)
		    val id1'  = auxId(typInfo(r1, typ_path env))
		    val dec1' = auxDec(id1', exp1')

		    val id'   = trModid(env, id)
(*DEBUG*)handle VirtualModule => (Error.warn'(true, r, Name.toString(I.name id) ^"[" ^ Stamp.toString(I.stamp id) ^ "] 3\n"); raise VirtualModule)
		    val dec2' = auxDec(id', trInf(env, inf1))

		    val exp'  = infExp(env, lab_depKind,
				       tupExp(r, #[idExp id1', idExp id', k]))
		in
		    mkKind(letExp(#[dec1', dec2'], exp'))
		end
	in
	    TranslationEnv.insertMod(env, I.stamp id);
	    case trInfRep'(env, mkKind', pathexp', inf2)
	     of NONE => (TranslationEnv.removeMod(env, I.stamp id); NONE)
	      | some => some
	end

      | trInfRep'(env, mkKind, pathexp', I.AbsInf(i)) =
	(* [abstract]_p =
	 *   __pervasive.Inf.con(p, k<__pervasive.Inf.groundKind()>)
	 *)
	let
	    val r     = #region i
	    val exp1' = mkKind(infExp(env, lab_groundKind, unitExp r))
	    val exp'  = infExp(env, lab_con, tupExp(r, #[pathexp', exp1']))
	in
	    SOME exp'
	end

      | trInfRep'(env, mkKind, pathexp', I.ConInf(i, longid)) =
	(* [longid]_p = [longid] *)
	SOME(longidExp(trInflongid(env, longid))
	     handle VirtualModule => trVirtInflongid(env, longid))

      | trInfRep'(env, mkKind, pathexp', inf) = NONE

    and trBindInf(env, lab_binder, i, id, inf1, inf2) =
	(* [binder id : inf1 -> inf2] =
	 *   let id0 = __pervasive.Path.fromString "id";
	 *       id$ = [inf1]
	 *   in __pervasive.Inf.binder(id0, id$, [inf2]) end
	 *)
	let
	    val r     = #region i
	    val r0    = #region(I.infoId id)
	    val exp0' = pathExp(env, r0, I.name id)
	    val id0'  = auxId(typInfo(r0, typ_path env))
	    val dec0' = auxDec(id0', exp0')

	    val exp1' = trInf'(env, inf1)
	    val id'   = trVirtModid(env, id)
	    val dec1' = auxDec(id', exp1')

	    val _     = TranslationEnv.insertMod(env, I.stamp id)
	    val exp2' = trInf'(env, inf2)
	    val exp'  = infExp(env, lab_binder,
			       tupExp(r, #[idExp id0', idExp id', exp2']))
	in
	    letExp(#[dec0', dec1'], exp')
	end

    and trInfMod(env, mod) =
	(*TODO*)
	(*DEBUG*)
	let
	    val r = #region(I.infoMod mod)
	    val s = case mod of I.VarMod _    => "VarMod"
			      | I.PrimMod _   => "PrimMod"
			      | I.StrMod _    => "StrMod"
			      | I.SelMod _    => "SelMod"
			      | I.FunMod _    => "FunMod"
			      | I.AppMod _    => "AppMod"
			      | I.AnnMod _    => "AnnMod"
			      | I.SealMod _   => "SealMod"
			      | I.LazyMod _   => "LazyMod"
			      | I.SpawnMod _  => "SpawnMod"
			      | I.LetMod _    => "LetMod"
			      | I.UnpackMod _ => "UnpackMod"
	in
	    unfinished r "trInfMod" ("runtime singleton interfaces (" ^ s ^ ")")
	end


  (* Declarations *)

    and trDecs(env, decs) =
	(* [dec1;...;decN] = [dec1];...;[decN] *)
	concatMapVec (fn dec => trDec(env, dec)) decs

    and trDec(env, I.ValDec(i, pat, exp)) =
	(* [value pat = exp] =
	 *   [pat] = [exp]
	 *)
	(let
	    val dec' = O.ValDec(origInfo(#region i, Val),
				trPat(env, pat), trExp(env, exp))
	in
	    #[dec']
	end handle VirtualModule => #[]) (*TODO, hack to deal with inf lets *)

      | trDec(env, I.TypDec(i, id, typ)) =
	(* [type id = typ] =
	 *   $id = lazy [typ]_(__pervasive.Path.fromLab(Label.fromString "id"))
	 *)
	let
	    val exp' = trTypRep(env, id, typ)
	    val dec' = O.ValDec(origInfo(#region i, Typ),
				idPat(trTypid(env, id)), lazyExp exp')
	in
	    #[dec']
	end

      | trDec(env, I.ModDec(i, id, mod)) =
	(* [module id = mod] =
	 *   val id$ = seal [mod]
	 *)
	(let
	    val _ = updatePervasive1(env, id)
	    val (exp',id') =
		(trMod(env, mod), trModid(env, id)) handle VirtualModule =>
		(*TODO, ugly hack to deal with inf lets *)
		case mod of I.VarMod(_, longid) =>
			    (trVirtModlongid(env, longid), trVirtModid(env, id))
			    before TranslationEnv.insertMod(env, I.stamp id)
			  | _ => raise VirtualModule
	    val dec' = O.ValDec(origInfo(#region i, Mod),
				idPat id', O.SealExp(O.infoId id', exp'))
	in
	    updatePervasive2(env, id);
	    #[dec']
	end
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region(I.infoId id), Name.toString(I.name id) ^"[" ^ Stamp.toString(I.stamp id) ^ "] 4\n"); raise VirtualModule))

      | trDec(env, I.InfDec(i, id, inf)) =
	(* [interface id = inf] =
	 *   $id$ = lazy [inf]_(__pervasive.Path.fromLab(Label.fromString "id"))
	 *)
	let
	    val exp' = trInfRep(env, id, inf)
	    val dec' = O.ValDec(origInfo(#region i, Inf),
				idPat(trInfid(env, id)), lazyExp exp')
	in
	    #[dec']
	end

      | trDec(env, I.RecDec(i, decs)) =
	(* [rec decs] =
	 *   [decs]_recl
	 *   id = lazy __pervasive.Type.fix #[[decs]_recr]
	 *   rec [decs]'
	 *   id1 = lazy case id of () -> id1'
	 *            ...
	 *   idN = lazy case id of () -> idN'
	 * (where id_i' are typids bound by [decs]_recl)
	 *)
	let
	    val map    = StampMap.map()
	    val _      = freshTypids(env, map, decs)
	    val decs1' = trLHSRecDecs(env, map, decs)
	    val dec3'  = O.RecDec(origInfo(#region i,Aux), trRecDecs(env, decs))
	in
	    if Vector.length decs1' = 0 then
		#[dec3']
	    else if not(!Switches.Language.supportRtt) then
		Vector.concat[decs1', #[dec3']]
	    else let
		val r      = #region i
		val t'     = typ_typ env
		val exps'  = trRHSRecDecs(env, map, decs)
		val exp'   = typExp(env, lab_fix,
				    vecExp(r, Type.tuple #[t',t'], exps'))
		val id'    = auxId(typInfo(r, typ_unit))
		val dec2'  = auxDec(id', lazyExp exp')

		val i'     = origInfo(r,Typ)
		val i0'    = i
		val i1'    = typInfo(r,t')
		val idexp' = idExp id'
		val pat'   = unitPat r
		val decs4' = StampMap.foldi
			     (fn(z1, (_, id2' as O.Id(i,z2,n)), decs') =>
				 let
				    val id1' = O.Id(i,z1,n)
				    val mat' = O.Mat(i0', pat', idExp id2')
				    val exp' = O.CaseExp(i1', idexp', #[mat'])
				 in
				    O.ValDec(i', idPat id1', lazyExp exp')
				    :: decs'
				 end
			     ) [] map
	    in
		Vector.concat[decs1', #[dec2', dec3'], Vector.fromList decs4']
	    end
	end

      | trDec(env, I.FixDec(i, id, fix)) =
	(* [fixity id : fix] = . *)
	#[]

      | trDec(env, I.VarDec(i, id, dec)) =
	(* [var id in dec] = [dec] *)
	trDec(env, dec)

      | trDec(env, I.LocalDec(i, decs)) =
	(* [local decs] = [decs] *)
	trDecs(env, decs)

    and trRecDecs(env, decs) =
	(* [dec1;...;decN]' = [dec1];...;[decN]
	 * (where the RHS omits all type declarations)
	 *)
	concatMapVec (fn dec => trRecDec(env, dec)) decs

    and trRecDec(env, I.TypDec(i, id, typ)) = #[]
      | trRecDec(env, I.RecDec(i, decs))    = trRecDecs(env, decs)
      | trRecDec(env, dec)                  = trDec(env, dec)

    and trLHSRecDecs(env, map, decs) =
	(* [dec1;...;decN]_recl = [dec1]_recl;...;[decN]_recl *)
	concatMapVec (fn dec => trLHSRecDec(env, map, dec)) decs

    and trLHSRecDec(env, map, I.TypDec(i, id, typ)) =
	(* [type id = typ]_recl =
	 *   $id' = __pervasive.Type.abbrev(__pervasive.Type.con(p_id, k_typ),
	 *                                  __pervasive.Type.unknown k_typ)
	 *)
	let
	    val r = #region i
	    val (id', exp') =
		if not(!Switches.Language.supportRtt)
		then (trTypid(env, id),
		      O.FailExp(trTypInfo(env, I.infoTyp typ)))
		else (#2(StampMap.lookupExistent(map, I.stamp id)),
(*
		      typExp(env, lab_unknown,
			     kindExp(env, r, Type.kind(#typ(I.infoTyp typ)))))
*)
		      let
			  val pathexp' = pathExp(env, r, I.name id)
			  val kindexp' = kindExp(env, r,
						 Type.kind(#typ(I.infoTyp typ)))
			  val exp1' = typExp(env, lab_con,
					     tupExp(r, #[pathexp', kindexp']))
			  val exp2' = typExp(env, lab_unknown, kindexp')
		      in
			  typExp(env, lab_abbrev,
				 tupExp(r, #[exp1', exp2']))
		      end)
	    val dec' = auxDec(id', exp')
	in
	    #[dec']
        end

      | trLHSRecDec(env, map, I.RecDec(i, decs)) =
	(* [rec decs]_recl = [decs]_recl *)
	trLHSRecDecs(env, map, decs)

      | trLHSRecDec(env, map, dec) = #[]

    and trRHSRecDecs(env, map, decs) =
	(* [dec1;...;decN]_recr = [dec1]_recr,...,[decN]_recr *)
	concatMapVec (fn dec => trRHSRecDec(env, map, dec)) decs

    and trRHSRecDec(env, map, I.TypDec(i, id, typ)) =
	(* [type id = typ]_recr = ($id2, [typ[id2/id]]) *)
	let
	    val id2'  = #2(StampMap.lookupExistent(map, I.stamp id))
	    val exp2' = trTypRep(env, id, renameTyp(map, typ))
	    val exp'  = tupExp(#region i, #[idExp id2', exp2'])
	in
	    #[exp']
	end

      | trRHSRecDec(env, map, I.RecDec(i, decs)) =
	(* [rec decs]_recr = [decs]_recr *)
	trRHSRecDecs(env, map, decs)

      | trRHSRecDec(env, map, dec) = #[]


    and freshTypids(env, map, decs) =
	Vector.app (fn dec => freshTypid(env, map, dec)) decs
    and freshTypid(env, map, I.TypDec(_, I.Id(i,z,n), typ)) =
	let
	    val id = I.Id(i, Stamp.stamp(), n)
	in
	    StampMap.insert(map, z, (id, trTypid(env, id)))
	end
      | freshTypid(env, map, I.RecDec(_, decs)) =
	freshTypids(env, map, decs)
      | freshTypid(env, map, dec) = ()

    and renameTyp(map, typ as (I.JokTyp _ | I.VarTyp _ | I.PrimTyp _ |
			       I.SingTyp _| I.AbsTyp _ )) =
	typ
      | renameTyp(map, I.ConTyp(i, longid)) =
	I.ConTyp(i, renameTyplongid(map, longid))
      | renameTyp(map, I.FunTyp(i, id, typ)) =
	I.FunTyp(i, id, renameTyp(map, typ))
      | renameTyp(map, I.AppTyp(i, typ1, typ2)) =
	I.AppTyp(i, renameTyp(map, typ1), renameTyp(map, typ2))
      | renameTyp(map, I.TupTyp(i, typs)) =
	I.TupTyp(i, Vector.map (fn typ => renameTyp(map, typ)) typs)
      | renameTyp(map, I.ProdTyp(i, row)) =
	I.ProdTyp(i, renameRow(map, row))
      | renameTyp(map, I.SumTyp(i, row)) =
	I.SumTyp(i, renameRow(map, row))
      | renameTyp(map, I.ArrTyp(i, typ1, typ2)) =
	I.ArrTyp(i, renameTyp(map, typ1), renameTyp(map, typ2))
      | renameTyp(map, I.AllTyp(i, id, typ)) =
	I.AllTyp(i, id, renameTyp(map, typ))
      | renameTyp(map, I.ExTyp(i, id, typ)) =
	I.ExTyp(i, id, renameTyp(map, typ))

    and renameRow(map, I.Row(i, flds, b)) =
	I.Row(i,Vector.map (fn fld => renameFld(map, fld)) flds, b)
    and renameFld(map, I.Fld(i, lab, typ)) =
	I.Fld(i, lab, renameTyp(map, typ))

    and renameTyplongid(map, longid as I.LongId _) =
	longid
      | renameTyplongid(map, I.ShortId(i, id)) =
	I.ShortId(i, renameTypid(map, id))
    and renameTypid(map, id as I.Id(i,z,n)) =
	case StampMap.lookup(map, z)
	 of NONE      => id
	  | SOME ids' => #1 ids'


  (* Specifications *)

    and trSpecs(env, sigidexp', specs) =
	(* [spec1;...;specN] = [spec1];...;[specN] *)
	concatMapVec (fn spec => trSpec(env, sigidexp', spec)) specs

    and trSpec(env, sigidexp', I.FixSpec(i, I.Lab(i1, l), I.Fix(i2, f))) =
	(* [fixity lab : fix]_s =
	 *    _ = __pervasive.Inf.extendFix(s, Label.fromString "lab", [fix])
	 *)
	let
	    val r     = #region i
	    val exp1' = labExp(env, #region i1, l)
	    val exp2' = fixExp(env, #region i2, f)
	    val exp'  = infExp(env, lab_extendFix,
			       tupExp(r, #[sigidexp', exp1', exp2']))
	in
	    #[expDec exp']
	end

      | trSpec(env, sigidexp', I.ValSpec(i, id, typ)) =
	(* [value id : typ] =
	 *  _ = __pervasive.Inf.extendVal(s, Label.fromString "lab", lazy [typ])
	 *)
	let
	    val r     = #region i
	    val exp1' = labExp(env, #region(I.infoId id),
			       Label.fromName(I.name id))
	    val exp2' = lazyExp(trTyp'(env, typ))
	    val exp'  = infExp(env, lab_extendVal,
			       tupExp(r, #[sigidexp', exp1', exp2']))
	in
	    #[expDec exp']
	end

      | trSpec(env, sigidexp', I.TypSpec(i, id, typ)) =
	(* [type id = typ] =
	 *    id1 = __pervasive.Path.fromString "id"
	 *    $id = lazy [typ]_id1
	 *    _   = __pervasive.Inf.extendTyp(s, id1,
	 *                                    __pervasive.Type.singKind $id)
	 *)
	let
	    val r     = #region i
 	    val r1    = #region(I.infoId id)
	    val exp1' = pathExp(env, r1, I.name id)
	    val id1'  = auxId(typInfo(r1, typ_path env))
	    val dec1' = auxDec(id1', exp1')

	    val id'   = trTypid(env, id)
	    val (exp2',l) = case trTypRep'(env, idExp id1', typ)
			     of NONE      => (trTyp'(env, typ), lab_singKind)
			      | SOME exp' => (exp', lab_kind) (* generative *)
	    val dec2' = auxDec(id', lazyExp exp2')

	    val exp4' = typExp(env, l, idExp id')
	    val exp3' = infExp(env, lab_extendTyp,
			       tupExp(r, #[sigidexp', idExp id1', exp4']))
	    val dec3' = expDec exp3'
	in
	    #[dec1', dec2', dec3']
	end

      | trSpec(env, sigidexp', I.ModSpec(i, id, inf)) =
	(* [module id : inf] =
	 *  id$ = [inf]
	 *  _  = __pervasive.Inf.extendMod(s,
	 *				   __pervasive.Path.fromString "id", id$)
	 *)
	let
	    val r     = #region i
	    val exp1' = trInf'(env, inf)
	    val id'   = trVirtModid(env, id)
	    val dec1' = auxDec(id', exp1')

	    val exp3' = pathExp(env, #region(I.infoId id), I.name id)
	    val exp2' = infExp(env, lab_extendMod,
			       tupExp(r, #[sigidexp', exp3', idExp id']))
	    val dec2' = expDec exp2'
	in
	    TranslationEnv.insertMod(env, I.stamp id);
	    #[dec1', dec2']
	end

      | trSpec(env, sigidexp', I.InfSpec(i, id, inf)) =
	(* [interface id = inf] =
	 *    id1  = _pervasive.Path.fromString "id"
	 *    $id$ = lazy [inf]_id1
	 *    _    = __pervasive.Inf.extendInf(s, id1,
	 *				     lazy __pervasive.Inf.singKind $id$)
	 *)
	let
	    val r     = #region i
 	    val r1    = #region(I.infoId id)
	    val id1'  = auxId(typInfo(r1, typ_path env))
	    val exp1' = pathExp(env, r1, I.name id)
	    val dec1' = auxDec(id1', exp1')

	    val id'   = trInfid(env, id)
	    val (exp2',l) = case trInfRep'(env, Fn.id, idExp id1', inf)
			     of NONE      => (trInf'(env, inf), lab_singKind)
			      | SOME exp' => (exp', lab_kind)  (* generative *)
	    val dec2' = auxDec(id', lazyExp exp2')

	    val exp4' = lazyExp(infExp(env, l, idExp id'))
	    val exp3' = infExp(env, lab_extendInf,
			       tupExp(r, #[sigidexp', idExp id1', exp4']))
	    val dec3' = expDec exp3'
	in
	    #[dec1', dec2', dec3']
	end

      | trSpec(env, sigidexp', I.RecSpec(i, specs)) =
	(* [rec specs] =
	 *    [specs]_recl
	 *    _ = __pervasive.Type.fix #[[specs]_recr]
	 *)
	let
	    val r      = #region i
	    val decs1' = trLHSRecSpecs(env, sigidexp', specs)
	    val exps'  = trRHSRecSpecs(env, sigidexp', specs)
	    val t'     = typ_typ env
	    val exp'   = typExp(env, lab_fix,
				vecExp(r, Type.tuple #[t',t'], exps'))
	    val dec2'  = expDec exp'
	in
	    if not(!Switches.Language.supportRtt)
	    then decs1'
	    else Vector.concat[decs1', #[dec2']]
	end

      | trSpec(env, sigidexp', I.ExtSpec(i, inf)) =
	unfinished (#region i) "trSpec" "signature extension"

    and trLHSRecSpecs(env, sigidexp', specs) =
	(* [spec1;...;specN]_recl = [spec1]_recl;...;[specN]_recl *)
	concatMapVec (fn spec => trLHSRecSpec (env, sigidexp', spec)) specs

    and trLHSRecSpec(env, sigidexp', I.TypSpec(i, id, typ)) =
	(* [type id = typ]_recl =
	 *   $id = __pervasive.Type.unknown k_typ *)
	let
	    val r    = #region i
	    val id'  = trTypid(env, id)
(*
	    val exp' = typExp(env, lab_unknown,
			      kindExp(env, r, Type.kind(#typ(I.infoTyp typ))))
*)
	    val pathexp' = pathExp(env, r, I.name id)
	    val kindexp' = kindExp(env, r, Type.kind(#typ(I.infoTyp typ)))
	    val exp1' = typExp(env, lab_con, tupExp(r, #[pathexp', kindexp']))
	    val exp2' = typExp(env, lab_unknown, kindexp')
	    val exp' = typExp(env, lab_abbrev, tupExp(r, #[exp1', exp2']))
	    val dec' = auxDec(id', exp')
	in
	    #[dec']
	end

      | trLHSRecSpec(env, sigidexp', I.RecSpec(i, specs)) =
	(* [rec specs]_recl = [specs]_recl *)
	trLHSRecSpecs(env, sigidexp', specs)

      | trLHSRecSpec(env, sigidexp', spec) =
	raise Crash.Crash "TranslationPhase.trLHSRecSpec: invalid spec"

    and trRHSRecSpecs(env, sigidexp', specs) =
	(* [spec1;...;specN]_recr = [spec1]_recr,...,[specN]_recr *)
	concatMapVec (fn spec => trRHSRecSpec (env, sigidexp', spec)) specs

    and trRHSRecSpec(env, sigidexp', I.TypSpec(i, id, typ)) =
	(* [type id = typ] =
	 *    let id1 = __pervasive.Path.fromString "id" in
	 *    __pervasive.Inf.extendTyp(s, id1, __pervasive.Type.singKind $id);
	 *    ($id, [typ]_id1)
	 *)
	let
	    val r     = #region i
 	    val r1    = #region(I.infoId id)
	    val exp1' = pathExp(env, r1, I.name id)
	    val id1'  = auxId(typInfo(r1, typ_path env))
	    val dec'  = auxDec(id1', exp1')

	    val id'   = trTypid(env, id)
	    val (exp4',l) = case trTypRep'(env, idExp id1', typ)
			     of NONE      => (trTyp'(env, typ), lab_singKind)
			      | SOME exp' => (exp', lab_kind)  (* generative *)
	    val exp5' = typExp(env, l, idExp id')
	    val exp2' = infExp(env, lab_extendTyp,
			       tupExp(r, #[sigidexp', idExp id1', exp5']))
	    val exp3' = tupExp(r, #[idExp id', exp4'])
	    val exp'  = letExp(#[dec'], seqExp(exp2', exp3'))
	in
	    #[exp']
	end

      | trRHSRecSpec(env, sigidexp', I.RecSpec(i, specs)) =
	(* [rec specs]_recr = [specs]_recr *)
	trRHSRecSpecs(env, sigidexp', specs)

      | trRHSRecSpec(env, sigidexp', spec) =
	raise Crash.Crash "TranslationPhase.trRHSRecSpec: invalid spec"


  (* Imports and annotations *)

    fun trAnns(env, anns) =
	(* [ann1;...;annN] = [ann1];...;[annN] *)
	let
	    val (idjus', decss') =
		VectorPair.unzip(Vector.map (fn ann => trAnn(env, ann)) anns)
	in
	    ( idjus', concatVec decss' )
	end

    and trAnn(env, I.ImpAnn(i, imps, url, b)) =
	(* [import imps from s] = import id from s; [imps]_id *)
	let
	    val r      = #region i
	    val isPerv = (TranslationEnv.lookupPervasive env; false)
			 handle TranslationEnv.Pervasive => true
	    val j      = Future.byneed(fn() => Inf.sign(#sign i))
	    val t'     = infToTyp(env,j)
	    val t      = if isPerv then Type.unknown(Type.starKind()) else t'
			 (* to allow import of pervasive *)
	    val id'    = auxId(typInfo(r,t))
	    val decs'  = trImps(env, shortId id', imps)
	in
	    if isPerv then Type.unify(t',t) else ();
	    ( (id',j,url,b), decs' )
	end

    and trImps(env, longid', imps) =
	(* [imp1;...;impN]_id = [imp1]_id;...;[impN]_id *)
	concatMapVec (fn imp => trImp(env, longid', imp)) imps

    and trImp(env, longid', I.FixImp(i, id, desc)) =
	(* [fixity id : fix] = . *)
	#[]

      | trImp(env, longid', I.ValImp(i, id, desc)) =
	(* [value id : typ] = (value id = longid.id) *)
	#[idUnsealDec(longid', trValid(env, id))]

      | trImp(env, longid', I.TypImp(i, id, desc)) =
	(* [type id : kind] = (type id = longid.id) *)
	#[idUnsealDec(longid', trTypid(env, id))]

      | trImp(env, longid', I.ModImp(i, id, desc)) =
	(* [module id : inf] = (module id = longid.id) *)
	((updatePervasive1(env, id);
	 #[idUnsealDec(longid', trModid(env, id))]
	 before updatePervasive2(env, id))
(*DEBUG*)handle VirtualModule => (Error.warn'(true, #region i, Name.toString(I.name id) ^"[" ^ Stamp.toString(I.stamp id) ^ "] 5\n"); raise VirtualModule)
)
      | trImp(env, longid', I.InfImp(i, id, desc)) =
	(* [interface id : kind] = (interface id = longid.id) *)
	#[idUnsealDec(longid', trInfid(env, id))]

      | trImp(env, longid', I.RecImp(i, imps)) =
	trImps(env, longid', imps)


  (* Components *)

    fun trCom(env, I.Com(i, anns, decs)) =
	(* [anns; decs] = [anns]; [decs] *)
	let
	    val (idjus',decs1') = trAnns(env, anns)
	    val  decs2'         = trDecs(env, decs)
	    val  decs'          = Vector.concat[decs1', decs2']
	    val  flds'          = Vector.map (idFld Fn.id) (ids(env, decs))
	    val  s              = #sign i
	in
	    if !Switches.Language.retainFullImport then () else
	    ( Inf.compressSig s
	    ; Vector.app (fn(id,j,u,b) => Inf.compress j) idjus'
	    );
	    ( idjus', decs', flds', Inf.sign s )
	end

    fun translate(desc, env, com) =
	let
	    val _    = TypeTranslation.clear()
	    val env' = TranslationEnv.clone env
	    val _    = TranslationEnv.setRtt(env', !Switches.Language.supportRtt)
	    val com' = trCom(env', com)
	in
	    (env', com')
	end
(*DEBUG
handle Inf.Mismatch m =>
(Error.warn'(true, Source.nowhere, "UNHANDLED in TRANSLATION:\n");
ElaborationError.error(#region(I.infoCom com), ElaborationError.AnnModMismatch m))
*)
end
