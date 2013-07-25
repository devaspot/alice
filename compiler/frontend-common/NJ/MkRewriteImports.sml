val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2005-05-03 14:26:05 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)






















(*DEBUG






*)

functor MkRewriteImports(val loadImports : Source.desc * Url.t ->
					      (Url.t * Inf.sign) vector
			 val loadMod: Source.desc * Url.t -> Reflect.module
			 structure Switches : SWITCHES) : REWRITE_IMPORTS =
struct
    structure O = TypedGrammar
    structure E = ElaborationError

    open TypedInfo
    nonfix mod

  (* Error *)

    val error = E.error
    val warn  = E.warn

    fun warnUnused(region as (_,(lin,_)), warning) =
	warn(!Switches.Warn.unusedImport andalso lin > 0, region, warning)

  (* Stripping of import signatures *)

    fun stripAnns(E, anns') =
	Vector.fromList
	  (List.mapPartial (fn ann' => stripAnn(E, ann')) (Vector.toList anns'))

    and stripAnn(E, ann as O.ImpAnn({region,sign}, imps', url, b)) =
	if Vector.all O.hasDesc imps' then (* explicit import *) SOME ann else
	let
	    val UE     = UseEnv.env()
	    val imps'' = stripImps(E, UE, imps')
	in
	    if UseEnv.isEmpty UE then NONE else (* avoid requesting sign! *)
	    let
		val sign' = Inf.narrowSigExt(sign, stripSig(UE,sign))
	    in
		if Vector.length imps'' = 0
		then NONE
		else SOME(O.ImpAnn({region=region, sign=sign'}, imps'', url, b))
	    end
	end

    and stripImps(E, UE, imps') =
	Vector.fromList (List.mapPartial (fn imp' => stripImp(E, UE, imp'))
					 (Vector.toList imps'))

    and stripImp(E, UE, imp' as O.ValImp(i, valid', _)) =
	let
	    val {use, ...} = Env.lookupVal(E, O.stamp valid')
	    val  l         = Label.fromName(O.name valid')
	in
	    if !use then
		( UseEnv.insertVal(UE, l)
		; SOME imp'
		)
	    else
		( warnUnused(#region i, E.ValImpUnused l)
		; NONE
		)
	end

      | stripImp(E, UE, imp' as O.TypImp(i, typid', _)) =
	let
	    val {use, ...} = Env.lookupTyp(E, O.stamp typid')
	    val  l         = Label.fromName(O.name typid')
	in
	    if !use then
		( UseEnv.insertTyp(UE, l)
		; SOME imp'
		)
	    else
		( warnUnused(#region i, E.TypImpUnused l)
		; NONE
		)
	end

      | stripImp(E, UE, imp' as O.ModImp(i, modid', desc')) =
	let
	    val {use, ...} = Env.lookupMod(E, O.stamp modid')
	    val  l         = Label.fromName(O.name modid')
	in
	    case !use
	      of UseEnv.FULL =>
		 ( UseEnv.insertMod(UE, l, !use)
		 ; SOME imp'
		 )
	       | UseEnv.PARTIAL UE' =>
		 if not(UseEnv.isEmpty UE') then
		    ( UseEnv.insertMod(UE, l, case desc' of O.NoDesc _ => !use
		    				 | O.SomeDesc _ => UseEnv.FULL)
		    ; SOME imp'
		    )
		 else
		    ( warnUnused(#region i, E.ModImpUnused l)
		    ; NONE
		    )
	end

      | stripImp(E, UE, imp' as O.InfImp(i, infid', _)) =
	let
	    val {use, ...} = Env.lookupInf(E, O.stamp infid')
	    val  l         = Label.fromName(O.name infid')
	in
	    if !use then
		( UseEnv.insertInf(UE, l)
		; SOME imp'
		)
	    else
		( warnUnused(#region i, E.InfImpUnused l)
		; NONE
		)
	end

      | stripImp(E, UE, imp' as O.FixImp _) =
	    NONE

      | stripImp(E, UE, O.RecImp(i, imps')) =
	let
	    val imps'' = stripImps(E, UE, imps')
	in
	    if Vector.length imps'' = 0 then
		NONE
	    else
		SOME(O.RecImp(i, imps''))
	end

    (* Now this is real ugly... *)

    and stripInf(UseEnv.FULL,       j) = j
      | stripInf(UseEnv.PARTIAL UE, j) = Inf.sign(stripSig(UE, Inf.asSig j))
(*DEBUG*)handle e => raise e

    and stripSig(UE, s) =
	let
	    val s' = Inf.emptySig()
	in
	    List.app (stripItem (UE,s,s')) (Inf.items s);
	    s'
	end

    and stripItem (UE,s,s') item =
	case Inf.inspectItem item
	 of (Inf.FixItem _ | Inf.HiddenItem _) =>
		()
	  | Inf.ValItem(l,t) =>
		if not(UseEnv.lookupVal(UE, l)) then ()
		else Inf.extendVal(s', l, t)
	  | Inf.TypItem(p,k) =>
		if not(UseEnv.lookupTyp(UE, Path.toLab p)) then ()
		else Inf.extendTyp(s', p, k)
	  | Inf.ModItem(p,j) =>
		(case UseEnv.lookupMod(UE, Path.toLab p)
		 of NONE     => ()
		  | SOME use => Inf.extendMod(s', p, stripInf(use, j))
		)
	  | Inf.InfItem(p,k) =>
		if not(UseEnv.lookupInf(UE, Path.toLab p)) then ()
		else Inf.extendInf(s', p, k)


  (* Closing imports wrt transitive imports *)

    datatype sort = TYP of Type.kind | MOD of Inf.t | INF of Inf.kind

    fun checkExportPaths(r, url, s) =
	let
	    val {typ,mod,inf} = Inf.boundPaths(Inf.sign s)
	in
	    PathMap.appi (fn (p,(pso,_)) => if Option.isSome pso then () else
			  error(r, E.ImplicitImpHiddenTyp(url,p))) typ;
	    PathMap.appi (fn (p,(pso,_)) => if Option.isSome pso then () else
			  error(r, E.ImplicitImpHiddenMod(url,p))) mod;
	    PathMap.appi (fn (p,(pso,_)) => if Option.isSome pso then () else
			  error(r, E.ImplicitImpHiddenInf(url,p))) inf
	end

    fun importPaths imports =
	Vector.map (fn(url,s) => importPaths'(url,s)) imports
    and importPaths'(url, s) =
	let
	    val map = PathMap.map()
	    val {typ,mod,inf} = Inf.boundPaths(Inf.sign s)
	in
	    PathMap.appi (fn(p,(pso,k)) =>
			  if Type.isSingKind k then () else
			  PathMap.insert(map, p, (url, pso, TYP k))) typ;
	    PathMap.appi (fn(p,(pso,j)) =>
			  if Inf.isSing j then () else
			  PathMap.insert(map, p, (url, pso, MOD j))) mod;
	    PathMap.appi (fn(p,(pso,k)) =>
			  if Inf.isSingKind k then () else
			  PathMap.insert(map, p, (url, pso, INF k))) inf;
	    map
	end

    fun insertImportSig(r, viaUrl, url, s, TYP k, [], p) =
	(not(Type.isSingKind(Inf.lookupTyp(s, Path.toLab p))) andalso
	 Type.equal(Inf.lookupTyp'(s, Path.toLab p), Type.con(p,k))
	 handle Inf.Lookup _ =>
	    ( warn(!Switches.Warn.insertedImport, r,
		   E.TypImpInserted(url,p,viaUrl))
	    ; Inf.extendTyp(s, p, k)
	    ; true
	    ))
      | insertImportSig(r, viaUrl, url, s, MOD j, [], p) =
	(not(Inf.isSing(Inf.lookupMod(s, Path.toLab p))) andalso
	 ((Inf.match(Inf.sing(Inf.lookupMod'(s, Path.toLab p)),
		     Inf.sing(Inf.mod(p,j)))
	  ; true) handle Inf.Mismatch _ => false)
	 handle Inf.Lookup _ =>
	    ( warn(!Switches.Warn.insertedImport, r,
		   E.InfImpInserted(url,p,viaUrl))
	    ; Inf.extendMod(s, p, j) (*UNFINISHED: depended on items? *)
	    ; true
	    ))
      | insertImportSig(r, viaUrl, url, s, INF k, [], p) =
	(not(Inf.isSingKind(Inf.lookupInf(s, Path.toLab p))) andalso
	 Inf.equal(Inf.lookupInf'(s, Path.toLab p), Inf.con(p,k))
	 handle Inf.Lookup _ =>
	    ( warn(!Switches.Warn.insertedImport, r,
		   E.InfImpInserted(url,p,viaUrl))
	    ; Inf.extendInf(s, p, k) (*UNFINISHED: depended on items? *)
	    ; true
	    ))
      | insertImportSig(r, viaUrl, url, s, sort, p'::ps, p) =
	let
	    val s' = Inf.asSig(Inf.lookupMod(s, Path.toLab p'))
		     handle Inf.Interface =>
			    error(r, E.ImplicitImpInconsistent(url,p',viaUrl))
		          | Inf.Lookup _ =>
		     let
			 val s' = Inf.emptySig()
		     in
			 Inf.extendMod(s, p', Inf.sign s') ; s'
		     end
	in
	    insertImportSig(r, viaUrl, url, s', sort, ps, p)
	end

    fun insertImportAnn(ranns, region, viaUrl, url, sort, ps, p) =
	if List.exists (fn(ann as O.ImpAnn(i, _, url', isStatic)) =>
			 url = url' andalso not isStatic andalso
			 insertImportSig(region,viaUrl, url, #sign i, sort,ps,p)
		        ) ranns
	then ranns else
	let
	    val s   = Inf.emptySig()
	    val ann = O.ImpAnn(sigInfo(region,s), #[], url, false)
	in
	    insertImportSig(region, viaUrl, url, s, sort, ps, p);
	    ann::ranns
	end

    fun closeAnns(desc, anns) =
	let
	    val  ranns       = Vector.toList(Vector.rev anns)
	    val (ranns',_,b) = closeAnns'(desc, ranns)
	in
	    (Vector.rev(Vector.fromList ranns'), b)
	end
    and closeAnns'(desc, []) = ([], Inf.rea(), Inf.boundPaths(Inf.top()))
      | closeAnns'(desc, O.ImpAnn(i, imps, url, false)::ranns) =
	if Vector.all O.hasDesc imps then (* explicit import *) 
	let
	    val (ranns',rea,b) = closeAnns'(desc, ranns)
(*DEBUG
val _=TextIO.print("### checking closed imports for \"" ^ Url.toStringRaw url ^ "\"\n")
*)
	    val region = #region i
	    val j'   = Inf.realise(rea, Inf.sign(#sign i))
	    val j''  = if PathMap.isEmpty(#mod b) then j' else
		       Option.valOf(Inf.avoid(b,j'))
	    val ann' = O.ImpAnn(sigInfo(region,Inf.asSig j''), imps, url, false)
	in
	    (ann'::ranns', rea, b)
	end
	else
	let
	    val (ranns',rea,b) = closeAnns'(desc, ranns)
(*DEBUG
val _=TextIO.print("### checking imports for \"" ^ Url.toStringRaw url ^ "\"\n")
*)
	    val _           = checkExportPaths(#region i, url, #sign i)
	    val imports     = loadImports(desc, url)
	    val imports'    = Vector.map (Pair.mapFst(Url.resolve url)) imports
	    val importPaths = importPaths imports'

	    val region      = #region i
	    val paths       = Inf.paths(Inf.sign(#sign i))
(*DEBUG
fun prPath p = TextIO.print(" " ^ PrettyPrint.toString(PPPath.ppPath p, 100) ^ "#" ^ Int.toString(Path.hash p))
val _=TextIO.print("free export paths:")
val _=PathSet.app prPath paths
val _=TextIO.print("\ntransitive import paths:")
val _=Vector.app (PathMap.appi (prPath o Pair.fst)) importPaths
val _=TextIO.print("\n")
*)
	    val ranns''     =
		Vector.foldl (fn(map, ranns) =>
		    PathMap.foldi (fn(p, (url', pso, sort), ranns) =>
			if not(PathSet.member(paths, p)) then ranns else
			case pso
			 of SOME ps =>
			    insertImportAnn(ranns, region, url,url', sort, ps,p)
			  | NONE => (* should never happen! *)
			     error(region,
				   (case sort
				    of TYP _ => E.ImplicitImpHiddenTransTyp
				     | MOD _ => E.ImplicitImpHiddenTransMod
				     | INF _ => E.ImplicitImpHiddenTransInf)
				   (url',p,url))
		    ) ranns map
		) ranns' importPaths
(*obsolete
		PathSet.fold
		(fn(p,ranns) =>
		 case PathMap.lookup(map, p)
		  of NONE => ranns
		   | SOME(url',SOME ps,sort) =>
		     insertImportAnn(ranns, region, url, url', sort, ps, p)
		   | SOME(url',NONE,sort) => (* should never happen! *)
		     error(region, (case sort
				    of TYP _ => E.ImplicitImpHiddenTransTyp
				     | MOD _ => E.ImplicitImpHiddenTransMod
				     | INF _ => E.ImplicitImpHiddenTransInf)
				   (url',p,url))
		) ranns' paths
*)

	    val j'   = Inf.realise(rea, Inf.sign(#sign i))
	    val j''  = if PathMap.isEmpty(#mod b) then j' else
		       Option.valOf(Inf.avoid(b,j'))
	    val ann' = O.ImpAnn(sigInfo(region,Inf.asSig j''), imps, url, false)
	in
	    (ann'::ranns'', rea, b)
	end
      | closeAnns'(desc, O.ImpAnn(i, imps, url, true)::ranns) =
	let
	    val (ranns',rea,b) = closeAnns'(desc, ranns)
(*DEBUG
val _=TextIO.print("### checking static \"" ^ Url.toStringRaw url ^ "\"\n")
*)
	    val region         = #region i

(*DEBUG
fun prInf j = TextIO.print(PrettyPrint.toString(PPInf.ppInf j, 75))
val _=TextIO.print("import signature:\n")
val _=prInf(Inf.sign(#sign i))
val _=TextIO.print("\n")
*)
	    val j    = Inf.realise(rea, Inf.sign(#sign i))
(*DEBUG
fun prInf j = TextIO.print(PrettyPrint.toString(PPInf.ppInf j, 75))
val _=TextIO.print("substituted import signature:\n")
val _=prInf j
val _=TextIO.print("\n")
*)
	    val b'   = Inf.boundPaths j
(*DEBUG
fun prPath p = TextIO.print(" " ^ PrettyPrint.toString(PPPath.ppPath p, 100) ^ "#" ^ Int.toString(Path.hash p))
val _=TextIO.print("bound paths:")
val _=PathMap.appi (prPath o Pair.fst) b
val _=TextIO.print("\n")
*)
	    val _    = PathMap.union(#mod b, #mod b')
	    val _    = if not(!Switches.Language.supportRtt) then () else
		       DynMatch.matchWith(rea, loadMod(desc,url), j)
(*DEBUG
fun prPath p = TextIO.print(" " ^ PrettyPrint.toString(PPPath.ppPath p, 100) ^ "#" ^ Int.toString(Path.hash p))
fun prTyp t = TextIO.print(PrettyPrint.toString(PPType.ppTyp t, 75))
val _=TextIO.print("type realisation:\n")
val _=PathMap.appi (fn(p,t) => (prPath p; TextIO.print " -> "; prTyp t; TextIO.print"\n")) (#typ_rea rea)
val _=TextIO.print("\n")
*)
	    val j'   = Inf.realise(rea,j)
	    val ann' = O.ImpAnn(sigInfo(region, Inf.asSig j'), imps, url, true)
	in
	    (ann'::ranns', rea, b)
	end


  (* Empty all import signatures
   * (for interactive toplevel, to achieve lazy loading) *)

    fun trivialiseSigAnns anns = Vector.map trivialiseSigAnn anns
    and trivialiseSigAnn(O.ImpAnn(i, imps, url, b)) =
	let
	    val s' = Inf.emptySig()
	in
	    O.ImpAnn(sigInfo(#region i, s'), imps, url, b)
	end

  (* Main *)

    fun rewriteAnns(desc, E, anns, s) =
	let
	    val anns'  = if !Switches.Language.retainFullImport
			 then anns
			 else stripAnns(E, anns)
	    val (anns'',b) = if !Switches.Language.unsafeImport
			 then (trivialiseSigAnns anns', Inf.boundPaths(Inf.top()))
			 else closeAnns(desc, anns')
	    val s'     = if !Switches.Language.unsafeImport
			 then s (* avoid triggering imports thru re-exports *)
			 else Inf.avoidHidden s
	    val s''    = if PathMap.isEmpty(#mod b) then s' else
			 Inf.asSig(Option.valOf(Inf.avoid(b, Inf.sign s')))
			 handle Option.Option => s'
(*DEBUG
before TextIO.print "couldn't avoid imports!\n"
*)
	in
	    (anns'',s')
	end
end
