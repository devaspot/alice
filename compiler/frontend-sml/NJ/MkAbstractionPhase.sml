val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-03 11:33:04 $ by $Author: rossberg $
 *   $Revision: 1.142 $
 *)

(*
On Datatypes and Constructors:

The abstract language only provides unary constructors. Nullary constructors
are mapped into constructors with a strict unit argument type. Constructor
arguments of tuple or product type are wrapped into strict types as well.

Moreover, the abstract grammar has no constructor declarations. Instead,
it provides first-class constructors. We have to map this as well. First-class
constructors use the special type conarrow, which also encodes argument
strictness.

The following table shows how constructor related declarations, expressions,
and patterns are mapped into the abstract syntax:

Declarations:
datatype 'a t =			type t = fun 'a -> [A:strict(unit), B:'a, C:strict(int*int)]
             A			val  A = roll `A() : t(_)
           | B of 'a		val  B = fun x -> roll `B(x) : t(_)
	   | C of int * int	val  C = fun x -> roll `C(x) : t(_)
exttype 'a u			type u = fun 'a -> ext
constructor D : 'a u		val 'D = new : conarrow(strict(unit)->u('a))
				val  D = @'D()
constructor E of 'a : 'a u	val 'E = new : conarrow('a -> u('a))
				val  E = fun x -> @'E(x)
constructor F of int * int:'a u	val 'F = new : conarrow(strict(int*int)->u('a))
				val  F = fun x -> @'F(x)
datatype t = datatype M.t	type t = M.t
				val  A = M.A
				val  B = M.B
				val  C = M.C
constructor D = D		val 'D = 'D  val D = D
__primitive
constructor G : 'a u = "s"	val 'G = prim "s": conarrow (strict unit->u('a))
				val  G = @'G()
__primitive
constructor H of 'a: 'a u = "s"	val 'H = prim "s": conarrow ('a -> u('a))
				val  H = fun x -> @'H(x)
__primitive
__reftype 'a r = ref of 'a	val  ref = fun x -> Ref(x)

Expressions:
A				roll `A()
B 0				roll `B(0)
B				B
C(0,1)				roll `C(0,1)
C				C
D				@'E()
E 0				@'E(0)
E				E
F(0,1)				@'F(0,1)
F				F
ref 0				Ref(0)
ref				ref

Patterns:
A				roll `A()
B 0				roll `B(0)
C(0,1)				roll `C(0,1)
D				@'D(_)
E 0				@'E(0)
F(0,1)				@'F(0,1)
ref 0				Ref(0)

Ideally, we would like to generalise the treatment of strictness by providing
StrictExp's and StrictPat's to inject and project into the strict type. This
would avoid the special strictness coercion hacks in the elaborator. A StrictExp
would be a representation of the await function. However, we currently lack
backend support for general strictness.

*)






























structure SigLoader =
struct
    type t = Source.desc * Url.t -> BindEnvFromSig.sign
end

functor MkAbstractionPhase(
		val loadSig :        SigLoader.t
		structure Switches : SWITCHES
	) :> ABSTRACTION_PHASE =
struct

    structure C   = BindEnv
    structure I   = InputGrammar
    structure O   = AbstractGrammar
    structure E   = AbstractionError

    open BindEnv
    open I

    val empty = env()

  (* Error handling *)

    val error = E.error
    val warn  = E.warn

    fun errorVId(E, vid', Error) =
	error((#1 o Option.valOf o lookupVal)(E, vid'), Error vid')


  (* Miscellanous helpers *)

    fun self E = case lookupSelf E
		   of SOME z => z
		    | NONE   => raise Crash.Crash "AbstractionPhase.self"

    fun infStatusToFixity(NONE)			= Fixity.NONFIX
      | infStatusToFixity(SOME(Infix.LEFT, n))	= Fixity.INFIX(n, Fixity.LEFT)
      | infStatusToFixity(SOME(Infix.RIGHT, n))	= Fixity.INFIX(n, Fixity.RIGHT)

    fun conName s  = "'" ^ s
    fun conVId vid = VId.fromString(conName(VId.toString vid))

    fun inventId i = O.Id(i, Stamp.stamp(), Name.InId)

    fun idToLab(O.Id(i, _, name))        = O.Lab(i, Label.fromName name)
    fun longidToLab(O.ShortId(_, id))    = idToLab id
      | longidToLab(O.LongId(_, _, lab)) = lab

    fun varToTyp varid = O.VarTyp(O.infoId(#1 varid), varid)

    val lab_ref		= Label.fromString "ref"
    val lab_strict	= Label.fromString "strict"
    val lab_conarrow	= Label.fromString "conarrow"
    val strid_pervasive	= StrId.fromString
				(Name.toString(PervasiveType.name_pervasive))

    fun contyp E (i, lab) =
	case lookupStr(E, strid_pervasive)
	  of NONE            => error(i, E.StrIdUnbound strid_pervasive)
	   | SOME(_,stamp,_) =>
		O.ConTyp(i,
		  O.LongId(i,
		     O.ShortId(i, O.Id(i, stamp, PervasiveType.name_pervasive)),
		     O.Lab(i, lab)))

    fun reftyp E (i, typ) =
	O.AppTyp(i, contyp E (i, lab_ref), typ)

    fun conarrowtyp E (i, typ1, typ2) =
	O.AppTyp(i, contyp E (i, lab_conarrow), O.ArrTyp(i, typ1, typ2))

    fun stricttyp E (typ, ( NULLARY | NARY)) =
	O.AppTyp(O.infoTyp typ, contyp E (O.infoTyp typ, lab_strict), typ)
      | stricttyp E (typ, UNARY) = typ

    fun tupexp(i, #[exp]) = exp
      | tupexp(i,   exps) = O.TupExp(i, exps)

    fun tuppat(i, #[pat]) = pat
      | tuppat(i,   pats) = O.TupPat(i, pats)

    fun annexp(exp, typs) =
	List.foldl (fn(typ,exp) => O.AnnExp(O.infoTyp typ, exp, typ)) exp typs

    fun seqexp []          = raise Crash.Crash "AbstractionPhase.seqexp"
      | seqexp [exp]       = exp
      | seqexp(exp1::exps) =
	let val exp2 = seqexp exps in
	    O.SeqExp(Source.span(O.infoExp exp1, O.infoExp exp2), exp1, exp2)
	end

    fun altpat []          = raise Crash.Crash "AbstractionPhase.altpat"
      | altpat [pat]       = pat
      | altpat(pat1::pats) =
	let val pat2 = altpat pats in
	    O.AltPat(Source.span(O.infoPat pat1, O.infoPat pat2), pat1, pat2)
	end

    fun funexp(valids, exp) =
	List.foldr (fn(valid,exp) =>
	     let val i = Source.span(O.infoId valid, O.infoExp exp) in
		O.FunExp(i, #[O.Mat(i, O.VarPat(O.infoId valid, valid), exp)])
	     end
	    ) exp valids

    fun alltyp(varids, typ) =
	List.foldr (fn(varid,typ) =>
		O.AllTyp(O.infoTyp typ, varid, typ)
	    ) typ varids

    fun funtyp(varids, typ) =
	List.foldr (fn(varid,typ) =>
		O.FunTyp(O.infoTyp typ, varid, typ)
	    ) typ varids

    fun apptyp(typs, typ) =
	List.foldl (fn(typ1,typ2) =>
	      O.AppTyp(Source.span(O.infoTyp typ1, O.infoTyp typ2), typ2, typ1)
	    ) typ typs

    fun jokapptyp(k, typ) =
	let val i = O.infoTyp typ in
	    apptyp(List.tabulate(k, fn _ => O.JokTyp(i)), typ)
	end

    fun arrtyp(typs, typ) =
	List.foldr (fn(typ1,typ2) =>
	      O.ArrTyp(Source.span(O.infoTyp typ1, O.infoTyp typ2), typ1, typ2)
	    ) typ typs

    fun funinf(modid_infs, inf) =
	List.foldr (fn((modid,inf1),inf2) =>
	      O.FunInf(Source.span(O.infoId modid, O.infoInf inf2),
		       modid, inf1, inf2)
	    ) inf modid_infs

    fun vardec(varids, dec) =
	List.foldr (fn(varid,dec) =>
		O.VarDec(O.infoId(#1 varid), varid, dec)
	    ) dec varids


    fun renameVarids E =
	List.map (fn(O.Id(i, _, name), eq) =>
		  let
		      val stamp' = Stamp.stamp()
		  in
		      insertVar(E, TyVar.fromString(Name.toString name),
				   (i, stamp', eq));
		      (O.Id(i, stamp', name), eq)
		  end)

    fun lookupIdStatus(E, vid') =
	case lookupVal(E, vid')
	  of NONE             => V
	   | SOME(i,stamp,is) => is



  (* Constants and identifiers *)

    fun isPrime c     = c = #"'"
    fun isDigit' c    = Char.isDigit c orelse c = #"_"
    fun isLowerNum' c = Char.isLower c orelse isDigit' c
    fun isUpperNum' c = Char.isUpper c orelse isDigit' c
    fun isAlphaNum' c = Char.isAlpha c orelse isDigit' c

    fun unprime s = Substring.dropr isPrime (Substring.full s)

    fun isConventionalLab s	= not(Char.isAlpha(String.sub(s,0))) orelse
				  Char.isLower(String.sub(s,0)) andalso
				  CharVectorSlice.all isAlphaNum' (unprime s)
    fun isConventionalTyVar s	= let val ss = Substring.dropl isPrime
						     (unprime s)
				  in
				      Substring.size ss > 0 andalso
				      Char.isLower(Substring.sub(ss,0)) andalso
				      CharVectorSlice.all isLowerNum' ss
				  end
    fun isConventionalVId s	= not(Char.isAlpha(String.sub(s,0))) orelse
				  CharVectorSlice.all isAlphaNum' (unprime s)
    fun isConventionalValVId s	= not(Char.isAlpha(String.sub(s,0))) orelse
				  Char.isLower(String.sub(s,0)) andalso
				  CharVectorSlice.all isAlphaNum' (unprime s)
    fun isConventionalConVId s	= not(Char.isAlpha(String.sub(s,0))) orelse
				  Char.isUpper(String.sub(s,0)) andalso
				  CharVectorSlice.all isAlphaNum' (unprime s)
    fun isConventionalTyCon s	= CharVectorSlice.all isLowerNum' (unprime s)
    fun isConventionalStrId s	= String.sub(s,0) = #"_" orelse
				  Char.isUpper(String.sub(s,0)) andalso
				  CharVectorSlice.all Char.isAlphaNum(unprime s)
    fun isConventionalSigId s	= String.sub(s,0) = #"_" orelse
				  Char.isUpper(String.sub(s,0)) andalso
				  CharVectorSlice.all isUpperNum' (unprime s)

    fun isEqTyVar s		= String.isPrefix "''" s

    fun trSCon E =
	fn SCon(i, SCon.INT n)		=> O.IntLit n
	 | SCon(i, SCon.WORD w)		=> O.WordLit w
	 | SCon(i, SCon.CHAR c)		=> O.CharLit c
	 | SCon(i, SCon.STRING s)	=> O.StringLit s
	 | SCon(i, SCon.REAL x)		=> O.RealLit x

    fun trLab E (Lab(i, lab)) =
	let
	    val name = Lab.toString lab
	in
	    warn(!Switches.Warn.conventions andalso not(isConventionalLab name),
		 i, E.LabConvention lab);
	    O.Lab(i, Label.fromString name)
	end

    fun trId (lookup,infoId,idId,toString,Unbound) E id =
	let
	    val i   = infoId id
	    val id' = idId id
	    val (_,stamp,x) = case lookup(E, id')
				of SOME xx => xx
				 | NONE    => error(i, Unbound id')
	in
	    ( O.Id(i, stamp, Name.ExId(toString id')), x )
	end

    val trVId   = trId(lookupVal, infoVId, idVId, VId.toString, E.VIdUnbound)
    val trTyVar = trId(lookupVar, infoTyVar, idTyVar,
			TyVar.toString, E.TyVarUnbound)
    val trTyCon = trId(lookupTy, infoTyCon, idTyCon,
			TyCon.toString, E.TyConUnbound)
    val trStrId = trId(lookupStr, infoStrId, idStrId,
			StrId.toString, E.StrIdUnbound)
    val trSigId = trId(lookupSig, infoSigId, idSigId,
			SigId.toString, E.SigIdUnbound)

    fun trTyVarEq tyvar = isEqTyVar(TyVar.toString tyvar)

    fun trId_bind (lookup,infoId,idId,toString,isConventional,
		   Convention,Shadowed) E id =
	let
	    val i     = infoId id
	    val id'   = idId id
	    val name  = toString id'
	    val stamp = Stamp.stamp()
	in
	    warn(!Switches.Warn.shadowing andalso Option.isSome(lookup(E, id')),
		 i, Shadowed id');
	    warn(!Switches.Warn.conventions andalso not(isConventional name),
		 i, Convention id');
	    ( O.Id(i, stamp, Name.ExId name), stamp )
	end


    val trVId_bind   = trId_bind(lookupVal, infoVId,   idVId,   VId.toString,
				 isConventionalVId,
				 E.VIdConvention, E.VIdShadowed)
    val trValVId_bind = trId_bind(lookupVal, infoVId,   idVId,   VId.toString,
				 isConventionalValVId,
				 E.ValVIdConvention, E.VIdShadowed)
    val trConVId_bind = trId_bind(lookupVal, infoVId,   idVId,   VId.toString,
				 isConventionalConVId,
				 E.ConVIdConvention, E.VIdShadowed)
    val trTyVar_bind = trId_bind(lookupVar, infoTyVar, idTyVar, TyVar.toString,
				 isConventionalTyVar,
				 E.TyVarConvention, E.TyVarShadowed)
    val trTyCon_bind = trId_bind(lookupTy,  infoTyCon, idTyCon, TyCon.toString,
				 isConventionalTyCon,
				 E.TyConConvention, E.TyConShadowed)
    val trStrId_bind = trId_bind(lookupStr, infoStrId, idStrId, StrId.toString,
				 isConventionalStrId,
				 E.StrIdConvention, E.StrIdShadowed)
    val trSigId_bind = trId_bind(lookupSig, infoSigId, idSigId, SigId.toString,
				 isConventionalSigId,
				 E.SigIdConvention, E.SigIdShadowed)

    fun trVId_bind' E (VId(i, vid')) =
	let
	    val name = VId.toString vid'
	in
	    O.Lab(i, Label.fromString name)
	end

    fun trConVId_bind' E (VId(i, vid')) =
	let
	    val name  = conName(VId.toString vid')
	    val stamp = Stamp.stamp()
	in
	    ( O.Id(i, stamp, Name.ExId name), stamp )
	end


    (* With polymorphic recursion we could avoid the following code
       duplication... *)

    fun trLongStrId' E =
	fn SHORTLong(i, strid) =>
	   let
		val (modid',E') = trStrId E strid
	   in
		( SOME(O.ShortId(i,modid')), E' )
	   end

	 | DOTLong(i, longstrid, strid) =>
	   let
		val (modlongido',F) = trLongStrId' E longstrid
		val  E'             = case F of PLAIN E' => E'
					      | _ => error(I.infoLong longstrid,
							   E.LongStrIdNonStruct)
		val (modid',x)      = trStrId E' strid
		val  modlongid'     =
		     case modlongido'
		       of NONE            => O.ShortId(i, modid')
			| SOME modlongid' => O.LongId(i, modlongid',
							 idToLab modid')
	   in
		( SOME modlongid', x )
	   end

    fun trLongId trId E =
	fn SHORTLong(i, id) =>
	   let
		val (id',x) = trId E id
	   in
		( O.ShortId(i,id'), x )
	   end

	 | DOTLong(i, longstrid, id) =>
	   let
		val (modlongido',F) = trLongStrId' E longstrid
		val  E'             = case F of PLAIN E' => E'
					      | _ => error(I.infoLong longstrid,
							   E.LongStrIdNonStruct)
		val (id',x)          = trId E' id
		val  longid'         =
		     case modlongido'
		       of NONE            => O.ShortId(i, id')
			| SOME modlongid' => O.LongId(i, modlongid',idToLab id')
	   in
		( longid', x )
	   end

    fun trLongVId E   = trLongId trVId E
    fun trLongTyCon E = trLongId trTyCon E
    fun trLongStrId E = trLongId trStrId E
    fun trLongSigId E = trLongId trSigId E

    fun trConLongVId E longvid =
	case #1(trLongVId E longvid)
	  of O.LongId(i1, modid', O.Lab(i2, lab')) =>
		O.LongId(Source.at i1, modid',
		    O.Lab(Source.at i2,
			  Label.fromString(conName(Label.toString lab'))))

	   | O.ShortId(i1, O.Id(i2, stamp, name)) =>
	     let
		val name' = conName(Name.toString name)
	     in
		case lookupVal(E, VId.fromString name')
		  of NONE => raise Crash.Crash "AbstractionPhase.trConLongVId"
		   | SOME(i, stamp', is) =>
			O.ShortId(Source.at i1,
				  O.Id(Source.at i2, stamp', Name.ExId name'))
	     end

    fun trLongVIdTyCon E (longvid, tycon', k) =
	let
	    val i               = Source.at(I.infoLong longvid)
	    val tycon           = TyCon(i, tycon')
	    val (vid,longtycon) = case longvid
				    of SHORTLong(_, vid) =>
					( vid, SHORTLong(i, tycon) )
				     | DOTLong(_, longstrid, vid) =>
					( vid, DOTLong(i, longstrid, tycon) )
	    val (typlongid',{CE=E',...}) = trLongTyCon E longtycon
	    val VId(_, vid')    = vid
	in
	    case lookupVal(E', vid')
	      of NONE => error(infoLong longvid,E.ConTyConShadowed(tycon',vid'))
	       | SOME _ => jokapptyp(k, O.ConTyp(infoTyCon tycon, typlongid'))
	end


  (* Calculate sets of unguarded explicit type variables [Section 4.6] *)

    fun ? tyvarsX E  NONE    = []
      | ? tyvarsX E (SOME x) = tyvarsX E x

    fun unguardedTyVarsAtExp E ( SCONAtExp _
			       | LONGVIDAtExp _
			       | HASHAtExp _ ) = []

      | unguardedTyVarsAtExp E (RECORDAtExp(_, exprow_opt)) =
	    ?unguardedTyVarsExpRow E exprow_opt

      | unguardedTyVarsAtExp E ( TUPLEAtExp(_, exps)
			       | VECTORAtExp(_, exps)
			       | SEQAtExp(_, exps) ) =
	    List.concat(List.map (unguardedTyVarsExp E) exps)

      | unguardedTyVarsAtExp E (LETAtExp(_, dec, exp)) =
	    unguardedTyVarsDec E dec @ unguardedTyVarsExp E exp

      | unguardedTyVarsAtExp E (COMPAtExp(_, _, _, dec)) =
	    unguardedTyVarsDec E dec

      | unguardedTyVarsAtExp E (PARAtExp(_, exp)) =
	    unguardedTyVarsExp E exp

    and unguardedTyVarsExpRow E (DOTSExpRow(_, exp)) =
	    unguardedTyVarsExp E exp
      | unguardedTyVarsExpRow E (ROWExpRow(_, lab, exp, exprow_opt)) =
	    unguardedTyVarsExp E exp @ ?unguardedTyVarsExpRow E exprow_opt

    and unguardedTyVarsExp E (ATEXPExp(_, atexp)) =
	    unguardedTyVarsAtExp E atexp

      | unguardedTyVarsExp E (APPExp(_, exp, atexp)) =
	    unguardedTyVarsExp E exp @ unguardedTyVarsAtExp E atexp

      | unguardedTyVarsExp E (TYPEDExp(_, exp, ty)) =
	    unguardedTyVarsExp E exp @ unguardedTyVarsTy E ty

      | unguardedTyVarsExp E ( ANDALSOExp(_, exp1, exp2)
			     | ORELSEExp(_, exp1, exp2) ) =
	    unguardedTyVarsExp E exp1 @ unguardedTyVarsExp E exp2

      | unguardedTyVarsExp E (HANDLEExp(_, exp, match)) =
	    unguardedTyVarsExp E exp @ unguardedTyVarsMatch E match

      | unguardedTyVarsExp E (RAISEExp(_, exp)) =
	    unguardedTyVarsExp E exp

      | unguardedTyVarsExp E (LAZYExp(_, exp)) =
	    unguardedTyVarsExp E exp

      | unguardedTyVarsExp E (SPAWNExp(_, exp)) =
	    unguardedTyVarsExp E exp

      | unguardedTyVarsExp E (IFExp(_, exp1, exp2, exp3)) =
	    unguardedTyVarsExp E exp1 @ unguardedTyVarsExp E exp2 @
	    unguardedTyVarsExp E exp3

      | unguardedTyVarsExp E (CASEExp(_, exp, match)) =
	    unguardedTyVarsExp E exp @ unguardedTyVarsMatch E match

      | unguardedTyVarsExp E (FNExp(_, match)) =
	    unguardedTyVarsMatch E match

      | unguardedTyVarsExp E (PACKExp(_, atstrexp, _)) =
	    unguardedTyVarsAtStrExp E atstrexp

    and unguardedTyVarsMatch E (Match(_, mrule, match_opt)) =
	    unguardedTyVarsMrule E mrule @ ?unguardedTyVarsMatch E match_opt

    and unguardedTyVarsMrule E (Mrule(_, pat, exp)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsExp E exp

    and unguardedTyVarsDec E (CONSTRUCTORDec(_, econbind)) =
	    unguardedTyVarsEconBind E econbind

      | unguardedTyVarsDec E (STRUCTUREDec(_, strbind)) =
	    unguardedTyVarsStrBind E strbind

      | unguardedTyVarsDec E ( LOCALDec(_, dec1, dec2)
			     | SEQDec(_, dec1, dec2) ) =
	    unguardedTyVarsDec E dec1 @ unguardedTyVarsDec E dec2

      | unguardedTyVarsDec E _ = []

    and unguardedTyVarsValBind E (PLAINValBind(_, pat, exp, valbind_opt)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsExp E exp @
	    ?unguardedTyVarsValBind E valbind_opt

      | unguardedTyVarsValBind E (RECValBind(_, valbind)) =
	    unguardedTyVarsValBind E valbind

    and unguardedTyVarsFvalBind E (FvalBind(_, _, match, fvalbind_opt)) =
	    unguardedTyVarsMatch E match @
	    ?unguardedTyVarsFvalBind E fvalbind_opt

    and unguardedTyVarsEconBind E (NEWEconBind(_, _, vid, ty_opt, tyvarseq,
						     longtycon, econbind_opt)) =
	let
	    val  _   = insertScope E
	    val  _   = trTyVarSeq E tyvarseq
	    val  _   = insertScope E
	    val ids' = ?unguardedTyVarsTy E ty_opt
	    val  E'  = splitScope E
	    val  _   = removeScope E
	    val  _   = union(E,E')
	in
	    ids' @ ?unguardedTyVarsEconBind E econbind_opt
	end

      | unguardedTyVarsEconBind E (EQUALEconBind(_, _,vid, _,longvid,
								econbind_opt)) =
	    ?unguardedTyVarsEconBind E econbind_opt

    and unguardedTyVarsStrBind E (StrBind(_, strid, strexp, strbind_opt)) =
	    unguardedTyVarsStrExp E strexp @
	    ?unguardedTyVarsStrBind E strbind_opt

    and unguardedTyVarsAtPat E (RECORDAtPat(_, patrow_opt)) =
	    ?unguardedTyVarsPatRow E patrow_opt

      | unguardedTyVarsAtPat E ( TUPLEAtPat(_, pats)
			       | VECTORAtPat(_, pats)
			       | ALTAtPat(_, pats) ) =
	    List.concat(List.map (unguardedTyVarsPat E) pats)

      | unguardedTyVarsAtPat E (PARAtPat(_, pat)) =
	    unguardedTyVarsPat E pat

      | unguardedTyVarsAtPat E _ = []

    and unguardedTyVarsPatRow E (DOTSPatRow(_, pat)) =
	    unguardedTyVarsPat E pat
      | unguardedTyVarsPatRow E (ROWPatRow(_, lab, pat, patrow_opt)) =
	    unguardedTyVarsPat E pat @ ?unguardedTyVarsPatRow E patrow_opt

    and unguardedTyVarsPat E (ATPATPat(_, atpat)) =
	    unguardedTyVarsAtPat E atpat

      | unguardedTyVarsPat E (APPPat(_, pat, atpat)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsAtPat E atpat

      | unguardedTyVarsPat E (TYPEDPat(_, pat, ty)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsTy E ty

      | unguardedTyVarsPat E (NONPat(_, pat)) =
	    unguardedTyVarsPat E pat

      | unguardedTyVarsPat E (ASPat(_, pat1, pat2)) =
	    unguardedTyVarsPat E pat1 @ unguardedTyVarsPat E pat2

      | unguardedTyVarsPat E (IFPat(_, pat, atexp)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsAtExp E atexp

      | unguardedTyVarsPat E (WITHVALPat(_, pat, valbind)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsValBind E valbind

      | unguardedTyVarsPat E (WITHFUNPat(_, pat, fvalbind)) =
	    unguardedTyVarsPat E pat @ unguardedTyVarsFvalBind E fvalbind

    and unguardedTyVarsTy E (WILDCARDTy(_)) =
	    []

      | unguardedTyVarsTy E (TYVARTy(_, tyvar as TyVar(i,tyvar'))) =
	if Option.isSome(lookupVar(E, tyvar')) then
	    []
	else
	let
	    val (id',stamp) = trTyVar_bind E tyvar
	    val  eq         = trTyVarEq tyvar'
	    val  _          = insertVar(E, tyvar', (i, stamp, eq))
	in
	    [(id',eq)]
	end

      | unguardedTyVarsTy E (RECORDTy(_, tyrow_opt)) =
	    ?unguardedTyVarsTyRow E tyrow_opt

      | unguardedTyVarsTy E (TUPLETy(_, tys)) =
	    List.concat(List.map (unguardedTyVarsTy E) tys)

      | unguardedTyVarsTy E (TYCONTy(_, tyseq, longtycon)) =
	    unguardedTyVarsTyseq E tyseq

      | unguardedTyVarsTy E (ARROWTy(_, ty, ty')) =
	    unguardedTyVarsTy E ty @ unguardedTyVarsTy E ty'

      | unguardedTyVarsTy E (PARTy(_, ty)) =
	    unguardedTyVarsTy E ty

    and unguardedTyVarsTyRow E (DOTSTyRow(_, ty)) =
	    unguardedTyVarsTy E ty
      | unguardedTyVarsTyRow E (ROWTyRow(_, lab, ty, tyrow_opt)) =
	    unguardedTyVarsTy E ty @ ?unguardedTyVarsTyRow E tyrow_opt

    and unguardedTyVarsTyseq E (Seq(_, tys)) =
	    List.concat(List.map (unguardedTyVarsTy E) tys)

    and unguardedTyVarsAtStrExp E (STRUCTAtStrExp(_, dec)) =
	    unguardedTyVarsDec E dec

      | unguardedTyVarsAtStrExp E (LONGSTRIDAtStrExp(_, longstrid)) =
	    []

      | unguardedTyVarsAtStrExp E (LETAtStrExp(_, dec, strexp)) =
	    unguardedTyVarsDec E dec @ unguardedTyVarsStrExp E strexp

      | unguardedTyVarsAtStrExp E (PARAtStrExp(_, strexp)) =
	    unguardedTyVarsStrExp E strexp

    and unguardedTyVarsStrExp E (ATSTREXPStrExp(_, atstrexp)) =
	    unguardedTyVarsAtStrExp E atstrexp

      | unguardedTyVarsStrExp E (APPStrExp(_, strexp, atstrexp)) =
	    unguardedTyVarsStrExp E strexp @ unguardedTyVarsAtStrExp E atstrexp

      | unguardedTyVarsStrExp E ( TRANSStrExp(_, strexp, _)
				| OPAQStrExp(_, strexp, _)
				| LAZYStrExp(_, strexp)
				| SPAWNStrExp(_, strexp)
				| FCTStrExp(_, _, strexp) ) =
	    unguardedTyVarsStrExp E strexp

      | unguardedTyVarsStrExp E (UNPACKStrExp(_, exp, sigexp)) =
	    unguardedTyVarsExp E exp

      (*UNFINISHED: if we have LETSigExp then we must check sigexps as well*)



  (* Expressions *)

    and trAtExp E =
	fn SCONAtExp(i, scon)          => O.LitExp(i, trSCon E scon)
	 | LONGVIDAtExp(i, _, longvid) =>
	   (case trLongVId E longvid
	      of (vallongid', T(NULLARY, tycon, kty)) =>
		  O.RollExp(i, O.TagExp(i, longidToLab vallongid',
					O.StrictExp(Source.at i,
					   O.TupExp(Source.at i, #[]))),
			       trLongVIdTyCon E (longvid, tycon, kty))
	       | (vallongid', C NULLARY) =>
		  O.ConExp(i, trConLongVId E longvid,
			   O.StrictExp(Source.at i,
			      O.TupExp(Source.at i, #[])))
	       | (vallongid', _) =>
		  O.VarExp(i, vallongid')
	   )
	 | RECORDAtExp(i, exprowo) =>
	   let
		val  _   = insertScope E
		val row' = trExpRowo E exprowo
		val  _   = removeScope E
	   in
		O.ProdExp(i, row')
	   end
	 | HASHAtExp(i, lab) =>
	   let
		val id'  = O.Id(i, Stamp.stamp(), Name.InId)
		val pat' = O.VarPat(i, id')
		val exp' = O.VarExp(i, O.ShortId(i, id'))
		val mat' = O.Mat(i, pat', O.SelExp(i, trLab E lab, exp'))
	   in
		O.FunExp(i, #[mat'])
	   end
	 | TUPLEAtExp(i, exps)		=> O.TupExp(i, trExps E exps)
	 | VECTORAtExp(i, exps)		=> O.VecExp(i, trExps E exps)
	 | SEQAtExp(i, exps)		=> seqexp(List.map (trExp E) exps)
	 | LETAtExp(i, dec, exp)	=>
	   let
		val  _   = insertScope E
		val dec' = trDec E dec
		val exp' = trExp E exp
		val  _   = removeScope E
	   in
		O.LetExp(i, dec', exp')
	   end
	 | COMPAtExp(i, ann, spec, dec)	=>
	   (* Hack alert... *)
	   let
		val i0         = Source.at i
		val modid1'    = O.Id(i0, Stamp.stamp(), Name.ExId "_CM")
		val linklab'   = O.Lab(i0, Label.fromString "link")
		val modlongid' = O.LongId(i0, O.ShortId(i0, modid1'), linklab')
		val  _         = insertScope E
		val decs1'     = trLocalAnn (E,modlongid') ann
		val E'         = cloneScope E

		val i1         = Source.at(I.infoDec dec)
		val decs2'     = trDec E dec
		val  _         = removeScope E
(*
		val decs3'     = expandImport(i1, O.ShortId(i0, modid1'), E')
*)
		val decs'      = Vector.concat[decs1', decs2'(*, decs3'*)]

		val  _         = insertScope E
(*
		val spec0      = expandInclude(i0, E')
		val (inf',_)   = trSig(E, i0, I.SEQSpec(i0, spec0, spec))
*)
		val (inf',_)   = trSig(E, i0, spec)
		val  _         = removeScope E

		val sInfid'    = O.Id(i0, Stamp.stamp(), Name.ExId "S")
		val dec1'      = O.InfDec(i0, sInfid', inf')
		val (managerlongid',_) =
		    trLongSigId E
			(I.SHORTLong(i0,
			   I.SigId(i0, SigId.fromString "COMPONENT_MANAGER")))
		val inf1'      = O.ConInf(i0, managerlongid')
		val body'      = O.StrMod(i0, decs')
		val fModid'    = O.Id(i0, Stamp.stamp(), Name.ExId "F")
		val dec2'      = O.ModDec(i0, fModid', O.FunMod(i0, modid1',
								inf1', body'))
		val mod2'      = O.StrMod(i0, #[dec1',dec2'])

		val (createlongid',_) =
		    trLongStrId E
			(I.DOTLong(i0,
				   I.SHORTLong(i0,
				     I.StrId(i0, StrId.fromString "Component")),
				   I.StrId(i0, StrId.fromString "Create")))
		val mod1'      = O.VarMod(i0, createlongid')
		val mod'       = O.AppMod(i0, mod1', mod2')

		val modid2'    = O.Id(i0, Stamp.stamp(), Name.ExId "_Comp")
		val dec'       = O.ModDec(i0, modid2', mod')
		val comlab'    = O.Lab(i0, Label.fromString "component")
		val vallongid' = O.LongId(i0, O.ShortId(i0, modid2'), comlab')
		val exp'       = O.VarExp(i, vallongid')
	   in
		O.LetExp(i, #[dec'], exp')
	   end
	 | PARAtExp(i, exp)		=> trExp E exp


    and expandImport(i, modlongid', E) =
	Vector.fromList(
	    BindEnv.foldri (#3, #3, #3, #3, expandImportTy(i, modlongid'),
			    expandImportStr(i, modlongid'),
			    expandImportSig(i, modlongid')) [] E)

    and expandImportTy (i,modlongid') (tycon, _, acc) =
	let
	    val name = TyCon.toString tycon
	    val lab' = O.Lab(i, Label.fromString name)
	    val typ' = O.ConTyp(i, O.LongId(i, modlongid', lab'))
	in
	    O.TypDec(i, O.Id(i, Stamp.stamp(), Name.ExId name), typ') :: acc
	end

    and expandImportSig (i,modlongid') (sigid, _, acc) =
	let
	    val name = SigId.toString sigid
	    val lab' = O.Lab(i, Label.fromString name)
	    val inf' = O.ConInf(i, O.LongId(i, modlongid', lab'))
	in
	    O.InfDec(i, O.Id(i, Stamp.stamp(), Name.ExId name), inf') :: acc
	end

    and expandImportStr (i,modlongid') (strid, (_,_,F), acc) =
	(case F
	   of PLAIN E =>
	      let
		  val name  = StrId.toString strid
		  val lab'  = O.Lab(i, Label.fromString name)
		  val decs' = expandImport(i, O.LongId(i, modlongid', lab'), E)
		  val mod'  = O.StrMod(i, decs')
	      in
		  O.ModDec(i, O.Id(i, Stamp.stamp(), Name.ExId name), mod')
		  :: acc
	      end
	    | _ => acc
	)


    and trExpRowo E exprowo =
	let
	    val (i, flds', expo') = trExpRowo' E exprowo
	in
	    O.Row(i, Vector.fromList flds', expo')
	end
    and trExpRowo' E =
	fn NONE => (Source.nowhere, [], NONE)

	 | SOME(DOTSExpRow(i, exp)) =>
	   let
		val exp' = trExp E exp
	   in
		(i, [], SOME exp')
	   end

	 | SOME(ROWExpRow(i, lab as Lab(i',lab'), exp, exprowo)) =>
	   let
		val i1'  = Source.span(i', infoExp exp)
		val fld' = O.Fld(i1', trLab E lab, trExp E exp)
		val _    = insertDisjointFld(E, lab', i')
			   handle CollisionFld _ =>
				error(i', E.ExpRowLabDuplicate lab')
		val (_,flds',expo') = trExpRowo' E exprowo
	   in
		(i, fld'::flds', expo')
	   end



    and trExps E exps = Vector.fromList(List.map (trExp E) exps)

    and trExp E =
	fn exp as (ATEXPExp _|APPExp _)	=> trAppExp E (Infix.exp (infEnv E) exp)
 	 | TYPEDExp(i, exp, ty)		=> O.AnnExp(i,trExp E exp, trTy E ty)
	 | ANDALSOExp(i, exp1, exp2)	=> O.AndExp(i,trExp E exp1,trExp E exp2)
	 | ORELSEExp(i, exp1, exp2)	=> O.OrExp(i,trExp E exp1, trExp E exp2)
	 | HANDLEExp(i, exp, match)	=>
		O.HandleExp(i, trExp E exp, trMatcho E (SOME match))

	 | RAISEExp(i, exp)		=> O.RaiseExp(i, trExp E exp)
	 | LAZYExp(i, exp)		=> O.LazyExp(i, trExp E exp)
	 | SPAWNExp(i, exp)		=> O.SpawnExp(i, trExp E exp)
	 | IFExp(i, exp1, exp2, exp3)	=>
		O.IfExp(i, trExp E exp1, trExp E exp2, trExp E exp3)

	 | CASEExp(i, exp, match) =>
		O.CaseExp(i, trExp E exp, trMatcho E (SOME match))

	 | FNExp(i, match) =>
	   let
		val i'    = infoMatch match
		val mats' = trMatcho E (SOME match)
	   in
		O.FunExp(i, mats')
	   end

	 | PACKExp(i, atstrexp, atsigexp) =>
	   let
		val (mod',F1) = trAtStrExp E atstrexp
		val (inf',F2) = trAtSigExp E atsigexp
	   in
		O.PackExp(i, mod', inf')
	   end


    and trAppExp E =
	fn APPExp(i, exp, atexp) => (trAppliedAppExp E exp) (i, trAtExp E atexp)
	 | ATEXPExp(i, atexp)    => trAtExp E atexp
	 | exp                   => trExp E exp

    and trAppliedAppExp E =
	fn APPExp(i, exp, atexp) =>
	   let
		val exp1' = (trAppliedAppExp E exp) (i, trAtExp E atexp)
	   in
		fn(i',exp2') => O.AppExp(i', exp1', exp2')
	   end
	 | ATEXPExp(i, atexp) =>
	        trAppliedAtExp E atexp
	 | exp =>
	   let
	        val exp1' = trExp E exp
	   in
		fn(i',exp2') => O.AppExp(i', exp1', exp2')
	   end

    and trAppliedAtExp E =
	fn LONGVIDAtExp(i, _, longvid)	=>
	   (case trLongVId E longvid
	      of (vallongid', V) =>
		 ( fn(i',exp') => O.AppExp(i', O.VarExp(i, vallongid'), exp') )

	       | (vallongid', (T(NULLARY,_,_) | C NULLARY)) =>
		 ( fn(i',exp') => error(i', E.ExpConArgSuperfluous) )

	       | (vallongid', T(NARY,tycon,kty)) =>
		 ( fn(i',exp') => O.RollExp(i',
					O.TagExp(i', longidToLab vallongid',
						 O.StrictExp(O.infoExp exp', exp')),
					trLongVIdTyCon E (longvid,tycon,kty)) )
	       | (vallongid', T(UNARY,tycon,kty)) =>
		 ( fn(i',exp') => O.RollExp(i',
					O.TagExp(i', longidToLab vallongid',
						 exp'),
					trLongVIdTyCon E (longvid,tycon,kty)) )
	       | (vallongid', C NARY) =>
		 ( fn(i',exp') => O.ConExp(i', trConLongVId E longvid,
					   O.StrictExp(O.infoExp exp', exp')) )
	       | (vallongid', C UNARY) =>
		 ( fn(i',exp') => O.ConExp(i', trConLongVId E longvid, exp') )

	       | (vallongid', R) =>
		 ( fn(i',exp') => O.RefExp(i', exp') )
	   )
	 | HASHAtExp(i, lab) =>
	   let
		val lab' = trLab E lab
	   in
		fn(i',exp') => O.SelExp(i', lab', exp')
	   end
	 | PARAtExp(i, exp) =>
		trAppliedExp E exp
	 | atexp =>
	   let
		val exp1' = trAtExp E atexp
	   in
		fn(i',exp2') => O.AppExp(i', exp1', exp2')
	   end

    and trAppliedExp E =
	fn exp as (ATEXPExp _|APPExp _)	=>
		trAppliedAppExp E (Infix.exp (infEnv E) exp)
 	 | exp =>
	   let
		val exp1' = trExp E exp
	   in
		fn(i',exp2') => O.AppExp(i', exp1', exp2')
	   end


  (* Matches and patterns *)

    and trMatcho  E matcho = Vector.rev(Vector.fromList(trMatcho'(E,[]) matcho))
    and trMatcho'(E,acc) =
	fn NONE => acc
	 | SOME(Match(i, mrule, matcho)) =>
	   let
		val mat' = trMrule E mrule
	   in
		trMatcho' (E, mat'::acc) matcho
	   end

    and trMrule E (Mrule(i, pat, exp)) =
	let
		val E'   = env()
		val pat' = trPat (E,E') pat
		val  _   = inheritScope(E,E')
		val exp' = trExp E exp
		val  _   = removeScope E
	in
		O.Mat(i, pat', exp')
	end


    and trAtPat (E,E') =
	fn WILDCARDAtPat(i)	=> O.JokPat(i)
	 | SCONAtPat(i, scon)	=> O.LitPat(i, trSCon E scon)
	 | LONGVIDAtPat(_, _, longvid as SHORTLong(i, vid as VId(i',vid'))) =>
	   (case lookupIdStatus(E, vid')
	      of T(NULLARY, tycon, kty) =>
		 O.RollPat(i, O.TagPat(i, idToLab(#1(trVId E vid)),
				       O.StrictPat(Source.at i,
				          O.TupPat(Source.at i, #[]))),
			   trLongVIdTyCon E (longvid,tycon,kty))
	       | C NULLARY =>
		 O.ConPat(i, trConLongVId E longvid,
			  O.StrictPat(Source.at i,
			     O.TupPat(Source.at i, #[])))
	       | V =>
		 let
		    (* If inside an alternative pattern then E' contains
		     * an upper scope where the variable is already bound.
		     * We have to reuse the stamp found there.
		     *)
		    val (valid',stamp) =
			case lookupVal(E', vid')
			  of NONE            => trValVId_bind E vid
			   | SOME(_,stamp,_) => ( O.Id(i', stamp,
						   Name.ExId(VId.toString vid'))
						, stamp )
		    val _ = insertDisjointVal(E', vid', (i',stamp,V))
			    handle CollisionVal _ =>
				error(i', E.PatVIdDuplicate vid')
		 in
		    O.VarPat(i, valid')
		 end
	       | (T _ | C _ | R) => error(i, E.PatConArgMissing)
	   )
	 | LONGVIDAtPat(i, _, longvid) =>
	   (case trLongVId E longvid
	      of (vallongid', T(NULLARY, tycon, kty)) =>
		 O.RollPat(i, O.TagPat(i, longidToLab vallongid',
				       O.StrictPat(Source.at i,
				          O.TupPat(Source.at i, #[]))),
			   trLongVIdTyCon E (longvid,tycon,kty))
	       | (vallongid', C NULLARY) =>
		 O.ConPat(i, trConLongVId E longvid,
			  O.StrictPat(Source.at i,
			     O.TupPat(Source.at i, #[])))
	       | (vallongid', V)   => error(i, E.PatLongVIdVar)
	       | (vallongid', _)   => error(i, E.PatConArgMissing)
	   )
	 | RECORDAtPat(i, patrowo) =>
	   let
		val  _   = insertScope E
		val row' = trPatRowo (E,E') patrowo
		val  _   = removeScope E
	   in
		O.ProdPat(i, row')
	   end

	 | TUPLEAtPat(i, pats)     => O.TupPat(i, trPats (E,E') pats)
	 | VECTORAtPat(i, pats)    => O.VecPat(i, trPats (E,E') pats)
	 | ALTAtPat(i, pats)       =>
	   let
		val  _    = insertScope E'
		val pat'  = trPat (E,E') (List.hd pats)
		val pats' = trAltPats (E,E') (List.tl pats)
		val  _    = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		altpat(pat'::pats')
	   end

	 | PARAtPat(i, pat) => trPat (E,E') pat


    and trPatRowo (E,E') patrowo =
	let
	    val (i, flds', pato') = trPatRowo' (E,E') patrowo
	in
	    O.Row(i, Vector.fromList flds', pato')
	end
    and trPatRowo' (E,E') =
	fn NONE => (Source.nowhere, [], NONE)

	 | SOME(DOTSPatRow(i, pat)) =>
	   let
	       val pat' = trPat (E,E') pat
	   in
	       (i, [], SOME pat')
	   end

	 | SOME(ROWPatRow(i, lab as Lab(i',lab'), pat, patrowo)) =>
	   let
		val i1'  = Source.span(i', infoPat pat)
		val fld' = O.Fld(i1', trLab E lab, trPat (E,E') pat)
		val _    = insertDisjointFld(E, lab', i')
			   handle CollisionFld _ =>
				error(i', E.PatRowLabDuplicate lab')
		val (_,flds',pato') = trPatRowo' (E,E') patrowo
	   in
		(i, fld'::flds', pato')
	   end


    and trPat (E,E') =
	fn pat as (ATPATPat _ | APPPat _) =>
		trAppPat (E,E') (Infix.pat (infEnv E) pat)

	 | TYPEDPat(i, pat, ty)	=> O.AnnPat(i, trPat (E,E') pat, trTy E ty)
	 | NONPat(i, pat)	=> O.NegPat(i, trPat (E,env()) pat)
	 | ASPat(i, pat1, pat2) => O.AsPat(i,trPat (E,E') pat1,trPat(E,E') pat2)
	 | IFPat(i, pat, atexp) =>
	   let
		val  _   = insertScope E'
		val pat' = trPat (E,E') pat
		val  _   = inheritScope(E, cloneScope E')
		val exp' = trAtExp E atexp
		val  _   = removeScope E
		val  _   = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		O.GuardPat(i, pat', exp')
	   end

	 | WITHVALPat(i, pat, valbind) =>
	   let
		val  _   = insertScope E'
		val pat' = trPat (E,E') pat
		val  _   = inheritScope(E, cloneScope E')
		val  _   = insertScope E'
		val decs'= trValBindo (E,E') (SOME valbind)
		val  _   = removeScope E
		val  _   = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.WithPatVIdDuplicate)
		val  _   = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		O.WithPat(i, pat', Vector.fromList decs')
	   end

	 | WITHFUNPat(i, pat, fvalbind) =>
	   let
		val  _      = insertScope E'
		val pat'    = trPat (E,E') pat
		val  _      = inheritScope(E, cloneScope E')
		val  _      = insertScope E'
		val valids' = trFvalBindo_lhs (E,E') (SOME fvalbind)
		val  _      = inheritScope(E, cloneScope E')
		val exps'   = trFvalBindo_rhs E (SOME fvalbind)
		val decs'   = VectorPair.map
				(fn(valid',exp') =>
				 O.ValDec(O.infoExp exp',
					  O.VarPat(O.infoId valid', valid'),
					  exp'))
				(valids',exps')
		val  _      = removeScope E
		val  _      = removeScope E
		val  _      = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.WithPatVIdDuplicate)
		val  _      = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		O.WithPat(i, pat', #[O.RecDec(infoFvalBind fvalbind, decs')])
	   end

    and trAppPat (E,E') =
	fn APPPat(i, pat, atpat) => (trAppliedAppPat (E,E') pat)
				    (i, trAtPat (E,E') atpat)
	 | ATPATPat(i, atpat)    => trAtPat (E,E') atpat
	 | pat                   => trPat (E,E') pat

    and trAppliedAppPat (E,E') =
	fn ATPATPat(i, atpat) => trAppliedAtPat (E,E') atpat
	 | pat                => error(I.infoPat pat, E.AppPatNonCon)

    and trAppliedAtPat (E,E') =
	fn LONGVIDAtPat(i, _, longvid) =>
	   (case trLongVId E longvid
	      of (vallongid', V) => error(i, E.AppPatNonCon)

	       | (vallongid', (T(NULLARY,_,_) | C NULLARY)) =>
		 ( fn(i',pat') => error(i', E.PatConArgSuperfluous) )

	       | (vallongid', T(NARY,tycon,kty)) =>
		 ( fn(i',pat') => O.RollPat(i',
					O.TagPat(i', longidToLab vallongid',
						 O.StrictPat(O.infoPat pat', pat')),
					trLongVIdTyCon E (longvid,tycon,kty)) )
	       | (vallongid', T(UNARY,tycon,kty)) =>
		 ( fn(i',pat') => O.RollPat(i',
					O.TagPat(i', longidToLab vallongid',
						 pat'),
					trLongVIdTyCon E (longvid,tycon,kty)) )
	       | (vallongid', C NARY) =>
		 ( fn(i',pat') => O.ConPat(i', trConLongVId E longvid,
					   O.StrictPat(O.infoPat pat', pat')) )

	       | (vallongid', C UNARY) =>
		 ( fn(i',pat') => O.ConPat(i', trConLongVId E longvid, pat') )

	       | (vallongid', R) =>
		 ( fn(i',pat') => O.RefPat(i', pat') )
	   )
	 | PARAtPat(i, pat) =>
		trAppliedPat (E,E') pat
	 | atpat =>
		error(I.infoAtPat atpat, E.AppPatNonCon)

    and trAppliedPat (E,E') =
	fn pat as (ATPATPat _|APPPat _)	=>
		trAppliedAppPat (E,E') (Infix.pat (infEnv E) pat)
	 | pat =>
		error(I.infoPat pat, E.AppPatNonCon)


    and trPats (E,E') pats =
	    Vector.map (trPat(E,E')) (Vector.fromList pats)

    and trAltPats (E,E') =
	    List.map(trAltPat(E,E'))

    and trAltPat (E,E') pat =
	let
	    val _    = insertScope E'
	    val pat' = trPat (E,E') pat
	    val E''  = splitScope E'
	    val _    = if BindEnv.sizeScope E' = BindEnv.sizeScope E'' then ()
		       else error(infoPat pat, E.AltPatInconsistent)
	    val _    = BindEnv.appiScopeVals
			    (fn(vid,_) =>
				if Option.isSome(lookupVal(E'',vid)) then ()
				else error(infoPat pat, E.AltPatInconsistent)
			    ) E'
	in
	    pat'
	end



  (* Types *)

    and trTyWithEnv E =
	fn TYCONTy(i, tyseq, longtycon) =>
	   let
		val (typlongid',{CE=E',...}) = trLongTyCon E longtycon
		val  typs'                   = trTySeq E tyseq
	   in
		( apptyp(typs', O.ConTyp(i, typlongid')), E' )
	   end
	 | PARTy(i, ty) => trTyWithEnv E ty
	 | ty => ( trTy E ty, env() )


    and trTy E =
	fn WILDCARDTy(i) =>
		O.JokTyp(i)

	 | TYVARTy(i, tyvar as TyVar(i',tyvar')) =>
		O.VarTyp(i, trTyVar E tyvar)

	 | TYCONTy(i, tyseq, longtycon) =>
	   let
		val (typlongid',_) = trLongTyCon E longtycon
		val  typs'         = trTySeq E tyseq
	   in
		apptyp(typs', O.ConTyp(i, typlongid'))
	   end

	 | RECORDTy(i, tyrowo) =>
	   let
		val  _   = insertScope E
		val row' = trTyRowo E tyrowo
		val  _   = removeScope E
	   in
		O.ProdTyp(i, row')
	   end

	 | TUPLETy(i, tys) =>
	   let
		val typs' = trTys E tys
	   in
		O.TupTyp(i, typs')
	   end

	 | ARROWTy(i, ty1, ty2) => O.ArrTyp(i, trTy E ty1, trTy E ty2)

	 | PARTy(i, ty) => trTy E ty

    and trTys E tys = Vector.map (trTy E) (Vector.fromList tys)


    and trTyRowo E tyrowo =
	let
	    val (i, flds', typo') = trTyRowo' E tyrowo
	in
	    O.Row(i, Vector.fromList flds', typo')
	end
    and trTyRowo' E =
	fn NONE => (Source.nowhere, [], NONE)

	 | SOME(DOTSTyRow(i, ty)) =>
	   let
		val typ' = trTy E ty
	   in
		(i, [], SOME typ')
	   end

	 | SOME(ROWTyRow(i, lab as Lab(i',lab'), ty, tyrowo)) =>
	   let
		val i1'  = Source.span(i', infoTy ty)
		val fld' = O.Fld(i1', trLab E lab, trTy E ty)
		val _    = insertDisjointFld(E, lab', i')
			   handle CollisionFld _ =>
				error(i', E.TyRowLabDuplicate lab')
		val (_,flds',typo') = trTyRowo' E tyrowo
	   in
		(i, fld'::flds',typo')
	   end



    and trTySeq E (Seq(i, tys)) = List.map (trTy E) tys

    and trLongTyConSeq E (Seq(i, longtycons)) =
	List.map (#1 o trLongTyCon E) longtycons

    and trLongVIdSeq E (Seq(i, longvids)) =
	List.map (#1 o trLongVId E) longvids

    and trTyVarSeqArity (Seq(i, tyvars)) = List.length tyvars
    and trTyVarSeq E (Seq(i, tyvars)) = List.map (trSeqTyVar E) tyvars

    and trSeqTyVar E (tyvar as TyVar(i, tyvar')) =
	let
	    val (varid',stamp) = trTyVar_bind E tyvar
	    val  eq            = trTyVarEq tyvar'
	    val  _             = insertDisjointVar(E, tyvar', (i, stamp, eq))
				 handle CollisionVar _ =>
				     error(i, E.TyVarSeqDuplicate tyvar')
	in
	    (varid',eq)
	end


    (* Tyvarseqs at a val or fun *)

    and trValTyVarSeq E (Seq(i, tyvars)) = List.map (trValSeqTyVar E) tyvars

    and trValSeqTyVar E (tyvar as TyVar(i, tyvar')) =
	(* No shadowing is allowed for tyvars *)
	if Option.isSome(lookupVar(E, tyvar')) then
	    error(i, E.ValTyVarSeqDuplicate tyvar')
	else
	let
	    val (varid',stamp) = trTyVar_bind E tyvar
	    val  eq            = trTyVarEq tyvar'
	    val  _             = insertDisjointVar(E, tyvar', (i, stamp, eq))
	in
	    (varid',eq)
	end


    (* Extract type variables from a type (as implicitly quantified) *)

    and trAllTy E =
	fn WILDCARDTy(i) => []
	 | TYVARTy(i, tyvar as TyVar(i',tyvar')) =>
	   if Option.isSome(lookupScopeVar(E, tyvar')) then
		[]
	   else
	   let
		val (varid',stamp) = trTyVar_bind E tyvar
		val  eq            = trTyVarEq tyvar'
		val  _             = insertDisjointVar(E, tyvar', (i,stamp,eq))
	   in
		[(varid',eq)]
	   end
	 | TYCONTy(i, tyseq, longtycon) => trAllTySeq E tyseq
	 | RECORDTy(i, tyrowo)   => trAllTyRowo E tyrowo
	 | TUPLETy(i, tys)       => List.concat(List.map (trAllTy E) tys)
	 | ARROWTy(i, ty1, ty2)  => trAllTy E ty1 @ trAllTy E ty2
	 | PARTy(i, ty)          => trAllTy E ty

    and trAllTyRowo E =
	fn NONE                               => []
	 | SOME(DOTSTyRow(i, ty))             => trAllTy E ty
	 | SOME(ROWTyRow(i, lab, ty, tyrowo)) =>
		trAllTy E ty @ trAllTyRowo E tyrowo

    and trAllTySeq E (Seq(i, tys)) = List.concat(List.map (trAllTy E) tys)



  (* Declarations *)

    and trDec  E dec  = Vector.rev(Vector.fromList(trDec' (E,[]) dec))
    and trDec'(E,acc) =
	fn VALDec(i, tyvarseq, valbind) =>
	   let
		val  E'     = env()
		val  _      = insertScope E
		val varids' = trValTyVarSeq E tyvarseq @
			      unguardedTyVarsValBind E valbind
		val decs'   = (if List.null varids'
			       then trValBindo'(E,E',acc)
			       else trValBindo (E,E') ) (SOME valbind)
		val  _      = removeScope E
		val  _      = union(E,E')
	   in
		if List.null varids'
		then decs'
		else List.map (fn dec' => vardec(varids', dec')) decs' @ acc
	   (* UNFINISHED: violates uniqueness of stamps in bindings *)
	   end

	 | FUNDec(i, tyvarseq, fvalbind) =>
	   let
		val  E'      = env()
		val valids'  = trFvalBindo_lhs (E,E') (SOME fvalbind)
		val  _       = union(E,E')
		val  _       = insertScope E
		val valids'' = trValTyVarSeq E tyvarseq @
			       unguardedTyVarsFvalBind E fvalbind
		val exps'    = trFvalBindo_rhs E (SOME fvalbind)
		val  _       = removeScope E
		val decs'    = VectorPair.map
				(fn(valid',exp') =>
				 O.ValDec(O.infoExp exp',
					  O.VarPat(O.infoId valid', valid'),
					  exp'))
				(valids',exps')
	   in
		vardec(valids'', O.RecDec(i, decs')) :: acc
	   end

	 | TYPEDec(i, typbind) =>
	   let
		val E'    = env()
		val decs' = trTypBindo' (E,E',NONE,acc) (SOME typbind)
		val  _    = union(E,E')
	   in
		decs'
	   end

	 | EQTYPEDec(i, typbind) =>
	   let
		val E'    = env()
		val decs' = trTypBindo' (E,E',SOME true,acc) (SOME typbind)
		val  _    = union(E,E')
	   in
		decs'
	   end

	 | EQEQTYPEDec(i, typbind) =>
	   let
		val E'    = env()
		val decs' = trTypBindo' (E,E',SOME false,acc) (SOME typbind)
		val  _    = union(E,E')
	   in
		decs'
	   end

	 | DATATYPEDec(i, datbind) =>
	   let
		val  E'             = env()
		val  _              = trDatBindo_lhs (E,E') (SOME datbind)
		val  _              = union(E,E')
		val (tdecs',cdecs') = trDatBindo_rhs (E,E') (SOME datbind)
		val  _              = union(E,E')
	   in
		cdecs' @ O.RecDec(i, tdecs') :: acc
	   end

	 | REPLICATIONDec(i, tycon as TyCon(i',tycon'), longtycon) =>
	   let
		val (typid',stamp)  = trTyCon_bind E tycon
		val (typlongid',{CE=E',arity=n,def,eq,ext})
				    = trLongTyCon E longtycon
		val  modlongido'    = case typlongid'
					of O.LongId(_,modlongid',_) =>
						SOME modlongid'
					 | O.ShortId _ => NONE
(*
		val  E'struct       = case longtycon
					of SHORTLong(i, _) => E
					 | DOTLong(i, longstrid, _) =>
				      case #2(trLongStrId E longstrid)
					of PLAIN E => E
					 | _ => raise Crash.Crash("AbstractionPhase.trDec: REPLICATIONDec")
		val E''             = env()
		val ts              = {CE=E'', arity=n, eq=eq, ext=ext}
		val _               = insertTy(E, tycon', (i', stamp, ts))
*)
		val dec' = O.TypDec(i, typid',
				    O.ConTyp(infoLong longtycon, typlongid'))
		fun checkCons E0 =
		    appiVals (fn(vid,(_,z,_)) =>
			  case lookupVal(E0, vid)
			   of NONE => error(i, E.ReplicationDecConShadowed vid)
			    | SOME(_,z',_) => if z = z' then () else
				error(i, E.ReplicationDecConShadowed vid)) E'
		fun condecs() =
		    let
			val E'' = env()
			val ts  = {CE=E'', arity=n, def=NONE, eq=eq, ext=ext}
		    in
			insertTy(E, tycon', (i', stamp, ts));
			foldiVals (trOpenDecVal (E,i,modlongido',SOME tycon'))
				  (dec' :: acc) E'
			before
			appiVals (fn(vid,_) => insertDisjointVal(E'',vid,
					    Option.valOf(lookupVal(E,vid)))) E'
		    end
	   in
		case longtycon
		 of SHORTLong(_, TyCon(_, tycon)) =>
		    (checkCons E;
		     if Option.isSome(lookupScopeTy(E, tycon))
		     then let val ts = {CE=E', arity=n, def=NONE, eq=eq, ext=ext} in
			      insertTy(E, tycon', (i', stamp, ts));
			      dec' :: acc
			  end
		     else condecs())
		  | DOTLong(_, longstrid, _) =>
		case #2(trLongStrId E longstrid)
		 of PLAIN E => (checkCons E; condecs())
		  | _ =>
		    raise Crash.Crash("AbstractionPhase.trDec: REPLICATIONDec")
(*
		appiVals (fn(vid,(_,z,_)) =>
			  case lookupVal(E'struct, vid)
			   of NONE => error(i, E.ReplicationDecConShadowed vid)
			    | SOME(_,z',_) => if z = z' then () else
				error(i, E.ReplicationDecConShadowed vid)) E';
		foldiVals (trOpenDecVal (E,i,modlongido',SOME tycon'))
		    (O.TypDec(i, typid',
			      O.ConTyp(infoLong longtycon, typlongid')) :: acc)
		    E'
		before
		appiVals (fn(vid,_) => insertDisjointVal(E'',vid,
					    Option.valOf(lookupVal(E,vid)))) E'
*)
	   end

	 | EXTTYPEDec(i, extbind) =>
	   let
		val E'    = env()
		val decs' = trExtBindo' (E,E',acc) (SOME extbind)
		val  _    = union(E,E')
	   in
		decs'
	   end

	 | CONSTRUCTORDec(i, econbind) =>
	   let
		val E'    = env()
		val decs' = trEconBindo' (E,E',acc) (SOME econbind)
		val  _    = union(E,E')
	   in
		decs'
	   end

	 | STRUCTUREDec(i, strbind) =>
	   let
		val E'    = env()
		val decs' = trStrBindo' (E,E',acc) (SOME strbind)
		val  _    = union(E,E')
	   in
		decs'
	   end

	 | SIGNATUREDec(i, sigbind) =>
	   let
		val E'    = env()
		val decs' = trSigBindo' (E,E',acc) (SOME sigbind)
		val _     = union(E,E')
	   in
		decs'
	   end

	 | LOCALDec(i, dec1, dec2) =>
	   let
		val  _     = insertScope E
		val decs1' = trDec E dec1
		val  _     = insertScope E
		val decs2' = trDec' (E, O.LocalDec(i, decs1')::acc) dec2
		val  E'    = splitScope E
		val  _     = removeScope E
		val  _     = union(E,E')
	   in
		decs2'
	   end

	 | OPENDec(i, longstrid) =>
	   let
		val (modlongid', F) = trLongStrId E longstrid
		val   E'            = case F of PLAIN E' => E'
					      | _ => error(I.infoLong longstrid,
							   E.OpenDecNonStruct)
		val   _             = unionInf(E,E')
	   in
		trOpenDec (E,i,SOME modlongid') (E',acc)
	   end

	 | EMPTYDec(i) =>
		acc

	 | SEQDec(i, dec1, dec2) =>
		trDec' (E, trDec' (E,acc) dec1) dec2

	 | INFIXDec(i, n, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.INFIX(n, Fixity.LEFT)
		val fix'    = O.Fix(i, fix)
		val dec'    = O.FixDec(i, vallab', fix')
		val _       = insertInf(E, vid', (i', SOME(Infix.LEFT, n)))
	   in
		dec' :: acc
	   end

	 | INFIXRDec(i, n, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.INFIX(n, Fixity.RIGHT)
		val fix'    = O.Fix(i, fix)
		val dec'    = O.FixDec(i, vallab', fix')
		val _       = insertInf(E, vid', (i', SOME(Infix.RIGHT, n)))
	   in
		dec' :: acc
	   end

	 | NONFIXDec(i, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.NONFIX
		val fix'    = O.Fix(i, fix)
		val dec'    = O.FixDec(i, vallab', fix')
		val _       = insertInf(E, vid', (i', NONE))
	   in
		dec' :: acc
	   end

	 | OVERLOADDec(i, tyvar as TyVar(i1,tyvar'), longtyconseq,
		          _, vid as VId(i2,vid'), ty, longvidseq) =>
	   let
		val  E'             = env()
		val  _              = insertScope E
		val (varid',stamp1) = trTyVar_bind E tyvar
		val  eq             = trTyVarEq tyvar'
		val  _              = insertDisjointVar(E, tyvar', (i,stamp1,eq))
		(* TODO: check that typlongids match eq *)
		val  typlongids'    = Vector.fromList
					(trLongTyConSeq E longtyconseq)
		val (valid',stamp2) = trValVId_bind E vid
		val  typ'           = trTy E ty
		val  vallongids'    = Vector.fromList(trLongVIdSeq E longvidseq)
		val  _              = removeScope E
		val  pat'           = O.VarPat(i2, valid')
		val  exps'          = Vector.map (fn vallongid' =>
					O.VarExp(O.infoLongid vallongid',
						 vallongid')) vallongids'
		val  exp'           = O.OverExp(i, exps',
					        (varid',eq), typlongids', typ')
		val  dec'           = O.ValDec(i, pat', exp')
		val  _              = insertVal(E, vid', (i, stamp2, V))
	   in
		dec' :: acc
	   end

	 | OVERLOADALLDec(i, tyvar as TyVar(i1,tyvar'),
		          _, vid as VId(i2,vid'), ty, longvid) =>
	   let
		val  E'             = env()
		val  _              = insertScope E
		val (varid',stamp1) = trTyVar_bind E tyvar
		val  eq             = trTyVarEq tyvar'
		val  _              = insertDisjointVar(E, tyvar', (i,stamp1,eq))
		val (valid',stamp2) = trValVId_bind E vid
		val  typ'           = trTy E ty
		val (vallongid',_)  = trLongVId E longvid
		val  _              = removeScope E
		val  pat'           = O.VarPat(i2, valid')
		val  exp0'          = O.VarExp(O.infoLongid vallongid',
					       vallongid')
		val  exp'           = O.OverallExp(i, exp0', (varid',eq), typ')
		val  dec'           = O.ValDec(i, pat', exp')
		val  _              = insertVal(E, vid', (i, stamp2, V))
	   in
		dec' :: acc
	   end

	 | PRIMITIVEVALDec(i, _, vid as VId(i',vid'), ty, s) =>
	   let
		val (valid',stamp) = trValVId_bind E vid
		val  _             = insertScope E
		val  varids'       = trAllTy E ty
		val  typ'          = trTy E ty
		val  _             = removeScope E
		val  pat'          = O.VarPat(i', valid')
		val  exp'          = O.PrimExp(i, s, typ')
		val  dec'          = O.ValDec(i, pat', exp')
		val  _             = insertVal(E, vid', (i, stamp, V))
	   in
		vardec(varids', dec') :: acc
	   end

	 | PRIMITIVETYPEDec(i, tyvarseq, tycon as TyCon(i',tycon'), s) =>
	   let
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq	(* ignore *)
		val  _             = removeScope E
		val  dec'          = O.TypDec(i, typid', O.PrimTyp(i,s))
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=env(), arity=n, def=NONE, eq=NONE, ext=false}
		val  _             = insertTy(E, tycon', (i, stamp, ts))
	   in
		dec' :: acc
	   end

	 | PRIMITIVEEXTTYPEDec(i, tyvarseq, tycon as TyCon(i',tycon'), s) =>
	   let
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq	(* ignore *)
		val  _             = removeScope E
		val  dec'          = O.TypDec(i, typid', O.PrimTyp(i,s))
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=env(), arity=n, def=NONE, eq=NONE, ext=true}
		val  _             = insertTy(E, tycon', (i, stamp, ts))
	   in
		dec' :: acc
	   end

	 | PRIMITIVEREFTYPEDec(i, tyvar, tycon as TyCon(i1',tycon'),
				  _, vid as VId(i2',vid'), tyvar2) =>
	   let
		val (typid',stamp1) = trTyCon_bind E tycon
		val (valid',stamp2) = trConVId_bind E vid
		val  _              = insertScope E
		val  varid'         = trSeqTyVar E tyvar
		val  _              = removeScope E
		val  typ'           = reftyp E (i1', varToTyp varid')
		val  dec1'          = O.TypDec(i, typid',
						  O.FunTyp(i, varid', typ'))
		val  id'            = O.Id(i2', Stamp.stamp(), Name.InId)
		val  pat'           = O.VarPat(i2', id')
		val  exp'           = O.VarExp(i2', O.ShortId(i2', id'))
		val  mat'           = O.Mat(i2', pat', O.RefExp(i2', exp'))
		val  dec2'          = O.ValDec(i, O.VarPat(i2', valid'),
						  O.FunExp(i, #[mat']))
		val  E'             = env()
		val  _              = insertVal(E', vid', (i2', stamp2, R))
		val  ts             = {CE=E', arity=1, def=NONE, eq=SOME false, ext=false}
		val  _              = insertTy(E, tycon', (i1', stamp1, ts))
		val  _              = union(E,E')
	   in
		dec2' :: dec1' :: acc
	   end

	 | PRIMITIVECONSTRUCTORDec
		(i, _, vid as VId(i',vid'), tyo, tyvarseq, longtycon, s) =>
	   let
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  vallongid1'     = O.ShortId(i, valid1')
		val  _               = insertScope E
		val (varids',typ12') = trTyVarSeqLongTyCon E
						(tyvarseq,longtycon)
		val (typ11',k)       = trTyo (E,i') tyo
		val  _               = removeScope E
		val  typ1'           = conarrowtyp E (O.infoTyp typ12',
					stricttyp E (typ11',k), typ12')
		val  exp1'           = O.PrimExp(i, s, typ1')
		val  dec1'           = O.ValDec(i, O.VarPat(i', valid1'), exp1')
		val  exp2'           =
		     if k = NULLARY then
			O.ConExp(i, vallongid1', O.StrictExp(i,O.TupExp(i,#[])))
		     else
		     let
			val validM'     = O.Id(i, Stamp.stamp(), Name.InId)
			val vallongidM' = O.ShortId(i, validM')
			val patM'       = O.VarPat(i, validM')
			val exp0M'      = O.VarExp(i, vallongidM')
			val expM'       = O.ConExp(i, vallongid1',
						   if k = UNARY then exp0M' else
						   O.StrictExp(i, exp0M'))
		     in
			O.FunExp(i, #[O.Mat(i, patM', expM')])
		     end
		val  dec2'           = O.ValDec(i, O.VarPat(i', valid2'), exp2')
		val  _               = insertVal(E, conVId vid', (i',stamp1,V))
		val  _               = insertVal(E, vid', (i', stamp2, C k))
	   in
		dec2' :: vardec(varids', dec1') :: acc
	   end

	 | PRIMITIVESTRUCTUREDec(i, strid as StrId(i',strid'), sigexp, s) =>
	   let
		val (modid',stamp) = trStrId_bind E strid
		val (inf',F)       = trSigExp E sigexp
		val  mod'          = O.PrimMod(i, s, inf')
		val  dec'          = O.ModDec(i, modid', mod')
		val  F'            = strengthen(stamp,F)
		val  _             = insertStr(E, strid', (i,stamp,F'))
	   in
		dec' :: acc
	   end

	 | PRIMITIVESIGNATUREDec(i, sigid as SigId(i',sigid'), strpats, s) =>
	   let
		val (infid',stamp) = trSigId_bind E sigid
		val  _             = insertScope E
		val  modid_infs'   = trStrPats E strpats	(* ignore *)
		val  _             = removeScope E
		val  dec'          = O.InfDec(i', infid', O.PrimInf(i,s))
		val  F             = ABSTR(self E, [], sigid', [])
		val  _             = insertSig(E, sigid', (i', stamp, F))
	   in
		dec' :: acc
	   end


    and trOpenDec (E,i,modlongido') (E',acc) =
	(foldiSigs(trOpenDecSig(E,i,modlongido'))
	(foldiStrs(trOpenDecStr(E,i,modlongido'))
	(foldiTys (trOpenDecTy (E,i,modlongido'))
	(foldiVals(trOpenDecVal(E,i,modlongido',NONE))
	(foldiInfs(trOpenDecInf(E,i)) acc E') E') E') E') E')

    and trOpenDecInf (E,i) (vid', (_,inf), acc) =
	let
	    val i'      = Source.at i
	    val name    = VId.toString vid'
	    val vallab' = O.Lab(i, Label.fromString name)
	    val fix'    = O.Fix(i, infStatusToFixity inf)
	    val _       = insertInf(E, vid', (i',inf))
	in
	    O.FixDec(i, vallab', fix') :: acc
	end

    and trOpenDecVal (E,i,modlongido',tycono) (vid', (_,stamp1,is), acc) =
	let
	    val i'         = Source.at i
	    val name       = VId.toString vid'
	    val stamp2     = Stamp.stamp()
	    val valid1'    = O.Id(i', stamp1, Name.ExId name)
	    val valid2'    = O.Id(i', stamp2, Name.ExId name)
	    val vallongid' = case modlongido'
			       of NONE            => O.ShortId(i', valid1')
			        | SOME modlongid' =>
				   O.LongId(i', modlongid',
					    O.Lab(i', Label.fromString name))
	    val is'        = case (is, tycono)
			       of (T(k,_,kty), SOME tycon) => T(k,tycon,kty)
			        | _ => is
	    val pat'       = O.VarPat(i', valid2')
	    val exp'       = O.VarExp(i', vallongid')
	    val _          = insertVal(E, vid', (i',stamp2,is'))
	in
	    O.ValDec(i, pat', exp') :: acc
	end

    and trOpenDecTy (E,i,modlongido')
		    (tycon', (_,stamp1,{CE=E',arity=n,def,eq,ext}), acc) =
	let
	    val i'         = Source.at i
	    val name       = TyCon.toString tycon'
	    val stamp2     = Stamp.stamp()
	    val typid1'    = O.Id(i', stamp1, Name.ExId name)
	    val typid2'    = O.Id(i', stamp2, Name.ExId name)
	    val typlongid' = case modlongido'
			       of NONE            => O.ShortId(i', typid1')
			        | SOME modlongid' =>
				   O.LongId(i', modlongid',
					    O.Lab(i', Label.fromString name))
	    val E''        = env()
	    val _          = appiVals (fn(vid,(I,z,is)) =>
				insertDisjointVal(E'',vid,
				    case lookupVal(E,vid)
				      of SOME(x as (_,z',_)) => if z = z' then x
						else (I,Stamp.stamp(),is)
				       | NONE => (I,Stamp.stamp(),is))) E'
	    val typ'       = O.ConTyp(i', typlongid')
	    val ts         = {CE=E'', arity=n, def=NONE, eq=eq, ext=ext}
	    val _          = insertTy(E, tycon', (i',stamp2,ts))
	in
	    O.TypDec(i, typid2', typ') :: acc
	end

    and trOpenDecStr (E,i,modlongido') (strid', (_,stamp1,F), acc) =
	let
	    val i'         = Source.at i
	    val name       = StrId.toString strid'
	    val stamp2     = Stamp.stamp()
	    val modid1'    = O.Id(i', stamp1, Name.ExId name)
	    val modid2'    = O.Id(i', stamp2, Name.ExId name)
	    val modlongid' = case modlongido'
			       of NONE            => O.ShortId(i', modid1')
			        | SOME modlongid' =>
				   O.LongId(i', modlongid',
					    O.Lab(i', Label.fromString name))
	    val mod'       = O.VarMod(i', modlongid')
	    val _          = insertStr(E, strid', (i',stamp2,F))
	in
	    O.ModDec(i, modid2', mod') :: acc
	end

    and trOpenDecSig (E,i,modlongido') (sigid', (_,stamp1,F), acc) =
	let
	    val i'         = Source.at i
	    val name       = SigId.toString sigid'
	    val stamp2     = Stamp.stamp()
	    val infid1'    = O.Id(i', stamp1, Name.ExId name)
	    val infid2'    = O.Id(i', stamp2, Name.ExId name)
	    val inflongid' = case modlongido'
			       of NONE            => O.ShortId(i', infid1')
			        | SOME modlongid' =>
				   O.LongId(i', modlongid',
					    O.Lab(i', Label.fromString name))
	    val inf'       = O.ConInf(i', inflongid')
	    val _          = insertSig(E, sigid', (i',stamp2,F))
	in
	    O.InfDec(i, infid2', inf') :: acc
	end



  (* Value bindings *)

    and trValBindo (E,E') valbindo = List.rev(trValBindo' (E,E',[]) valbindo)
    and trValBindo'(E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINValBind(_, pat, exp, valbindo)) =>
	   let
		val i    = Source.span(infoPat pat, infoExp exp)
		val pat' = trPat (E,E') pat
		val exp' = trExp E exp
		val dec' = O.ValDec(i, pat', exp')
	   in
		trValBindo' (E,E', dec'::acc) valbindo
	   end

	| SOME(RECValBind(i, valbind)) =>
	   let
		val pats' = trRecValBindo_lhs (E,E') (SOME valbind)
		val  _    = union(E,E')
		val exps' = trRecValBindo_rhs E (SOME valbind)
		val decs' = VectorPair.map
				(fn(pat',exp') =>
				 O.ValDec(Source.span(O.infoPat pat',
						      O.infoExp exp'),
					  pat', exp'))
				(pats',exps')
	   in
		O.RecDec(i, decs') :: acc
	   end


    and trRecValBindo_lhs (E,E') valbindo =
	    Vector.rev(Vector.fromList(trRecValBindo_lhs' (E,E',[]) valbindo))

    and trRecValBindo_lhs' (E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINValBind(i, pat, exp, valbindo)) =>
	   let
		val pat' = trPat (E,E') pat
	   in
		trRecValBindo_lhs' (E,E', pat'::acc) valbindo
	   end

	 | SOME(RECValBind(i, valbind)) =>
		trRecValBindo_lhs' (E,E',acc) (SOME valbind)


    and trRecValBindo_rhs E valbindo =
	    Vector.rev(Vector.fromList(trRecValBindo_rhs' (E,[]) valbindo))

    and trRecValBindo_rhs' (E,acc) =
	fn NONE => acc

	 | SOME(PLAINValBind(i, pat, exp, valbindo)) =>
	   (* BUG: no check for admissibility *)
	   let
		val exp' = trExp E exp
	   in
		trRecValBindo_rhs' (E, exp'::acc) valbindo
	   end

	 | SOME(RECValBind(i, valbind)) =>
		trRecValBindo_rhs' (E,acc) (SOME valbind)



  (* Function bindings *)

    and trFvalBindo_lhs (E,E') fvalbindo =
	    Vector.rev(Vector.fromList(trFvalBindo_lhs' (E,E',[]) fvalbindo))

    and trFvalBindo_lhs'(E,E',acc) =
	fn NONE => acc
	 | SOME(FvalBind(i, _, fmatch, fvalbindo)) =>
	   let
		val valid' = trFmatch_lhs (E,E') fmatch
	   in
		trFvalBindo_lhs' (E,E', valid'::acc) fvalbindo
	   end


    and trFmatch_lhs (E,E') (Match(i, fmrule, fmatcho)) =
	   let
		val vid as VId(i',vid') = trFmrule_lhs E fmrule
		val (valid',stamp)      = trValVId_bind E vid
		val _ = trFmatcho_lhs (E,vid) fmatcho
		val _ = insertDisjointVal(E', vid', (i',stamp,V))
			handle CollisionVal _ =>
			       error(i', E.FvalBindDuplicate vid')
	   in
		valid'
	   end

    and trFmatcho_lhs (E,vid1) =
	fn NONE => ()
	 | SOME(Match(i, fmrule, fmatcho)) =>
	   let
		val vid2 as VId(i',vid2') = trFmrule_lhs E fmrule
	   in
		if idVId vid1 = idVId vid2 then
		    trFmatcho_lhs (E,vid1) fmatcho
		else
		    error(i', E.FvalBindNameInconsistent vid2')
	   end

    and trFmrule_lhs E (Mrule(i, fpat, exp)) =
	   trFpat_lhs E fpat

    and trFpat_lhs E =
	fn fpat as (ATPATPat _ | APPPat _) =>
		trFappPat_lhs E (Infix.pat (infEnv E) fpat)
	 | ( TYPEDPat(i, fpat, _)
	   | IFPat(i, fpat, _)
	   | WITHVALPat(i, fpat, _)
	   | WITHFUNPat(i, fpat, _) )	=> trFpat_lhs E fpat
	 | ( NONPat(i,_)
	   | ASPat(i,_,_) )		=> error(i, E.FvalBindPatInvalid)

    and trFappPat_lhs E =
	fn APPPat(i, fpat, atpat)	=> trFappPat_lhs E fpat
	 | ATPATPat(i, atpat)		=> trFatPat_lhs E atpat
	 | fpat				=> trFpat_lhs E fpat

    and trFatPat_lhs E =
	fn LONGVIDAtPat(i, _, SHORTLong(_, vid as VId(i', vid'))) =>
	   (case lookupIdStatus(E, vid')
	      of  V              => vid
	       | (R | C _ | T _) => error(i', E.FvalBindNameCon vid')
	   )

	 | ALTAtPat(i, fpats) =>
	   let
		val vids               = trFpats_lhs E fpats
		val vid as VId(_,vid') = List.hd vids
	   in
		case List.find (fn(VId(_,vid'')) => vid'<>vid'') (List.tl vids)
		  of NONE                => vid
		   | SOME(VId(i',vid2')) =>
			error(i', E.FvalBindNameInconsistent vid2')
	   end

	 | PARAtPat(i, fpat) =>
		trFpat_lhs E fpat

	 | atpat =>
		error(infoAtPat atpat, E.FvalBindNameMissing)

    and trFpats_lhs E = List.map(trFpat_lhs E)



    and trFvalBindo_rhs E fvalbindo =
	    Vector.rev(Vector.fromList(trFvalBindo_rhs' (E,[]) fvalbindo))

    and trFvalBindo_rhs'(E,acc) =
	fn NONE => acc
	 | SOME(FvalBind(i, laz, fmatch, fvalbindo)) =>
	   let
		val exp' = trFmatch_rhs (E,laz) fmatch
	   in
		trFvalBindo_rhs' (E, exp'::acc) fvalbindo
	   end

    and trFmatch_rhs (E,laz) (Match(i, fmrule, fmatcho)) =
	   let
		val (mat',arity) = trFmrule_rhs E fmrule
		val  mats'       = Vector.fromList
				     (mat' :: trFmatcho_rhs (E,arity) fmatcho)
		val  i'          = O.infoMat mat'
	   in
		if arity = 1 andalso laz = SANSLazy then
		    O.FunExp(i', mats')
		else
		    let
			val valids'  = Vector.tabulate(arity,
						fn _ => inventId(Source.at i))
			val exps'    = Vector.map(fn valid' =>
					  O.VarExp(Source.at i',
					     O.ShortId(Source.at i', valid')))
					  valids'
			val tupexp'  = tupexp(i', exps')
			val caseexp' = O.CaseExp(i', tupexp', mats')
			val exp'     = case laz
					 of SANSLazy  => caseexp'
					  | WITHLazy  => O.LazyExp(i', caseexp')
					  | WITHSpawn => O.SpawnExp(i',caseexp')
		    in
			funexp(Vector.toList valids', exp')
		    end
	   end

    and trFmatcho_rhs (E,arity) fmatcho =
	    List.rev(trFmatcho_rhs' (E,arity,[]) fmatcho)

    and trFmatcho_rhs' (E,arity,acc) =
	fn NONE => acc

	 | SOME(Match(i, fmrule, fmatcho)) =>
	   let
		val (mat',arity') = trFmrule_rhs E fmrule
	   in
		if arity <> arity' then
		    error(infoMrule fmrule, E.FvalBindArityInconsistent)
		else
		    trFmatcho_rhs' (E, arity, mat'::acc) fmatcho
	   end

    and trFmrule_rhs E (Mrule(i, fpat, exp)) =
	   let
		val  E'                = env()
		val (pat',arity,typs') = trFpat_rhs (E,E') fpat
		val  _                 = inheritScope(E,E')
		val  exp'              = trExp E exp
		val  _                 = removeScope E
	   in
		( O.Mat(i, pat', annexp(exp',typs')), arity )
	   end

    and trFpat_rhs (E,E') =
	fn fpat as (ATPATPat _ | APPPat _) =>
		trFappPat_rhs (E,E') (Infix.pat (infEnv E) fpat)

	 | TYPEDPat(i, fpat, ty) =>
	   let
		val (pat',arity,typs') = trFpat_rhs (E,E') fpat
		val  typ'              = trTy E ty
	   in
		( pat', arity, typ'::typs' )
	   end

	 | IFPat(i, fpat, atexp) =>
	   let
		val  _   = insertScope E'
		val (pat',arity,typs') = trFpat_rhs (E,E') fpat
		val  _   = inheritScope(E, cloneScope E')
		val exp' = trAtExp E atexp
		val  _   = removeScope E
		val  _   = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		( O.GuardPat(i, pat', exp'), arity, typs' )
	   end

	 | WITHVALPat(i, pat, valbind) =>
	   let
		val  _   = insertScope E'
		val (pat',arity,typs') = trFpat_rhs (E,E') pat
		val  _   = inheritScope(E, cloneScope E')
		val  _   = insertScope E'
		val decs'= Vector.fromList(trValBindo (E,E') (SOME valbind))
		val  _   = removeScope E
		val  _   = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.WithPatVIdDuplicate)
		val  _   = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		( O.WithPat(i, pat', decs'), arity, typs' )
	   end

	 | WITHFUNPat(i, pat, fvalbind) =>
	   let
		val  _      = insertScope E'
		val (pat',arity,typs') = trFpat_rhs (E,E') pat
		val  _      = inheritScope(E, cloneScope E')
		val  _      = insertScope E'
		val valids' = trFvalBindo_lhs (E,E') (SOME fvalbind)
		val  _      = inheritScope(E, cloneScope E')
		val exps'   = trFvalBindo_rhs E (SOME fvalbind)
		val decs'   = VectorPair.map
				(fn(valid',exp') =>
				 O.ValDec(O.infoExp exp',
					  O.VarPat(O.infoId valid', valid'),
					  exp'))
				(valids',exps')
		val  _      = removeScope E
		val  _      = removeScope E
		val  _      = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.WithPatVIdDuplicate)
		val  _      = mergeDisjointScope E' handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		( O.WithPat(i, pat', #[O.RecDec(infoFvalBind fvalbind, decs')]),
		  arity, typs' )
	   end

	 | ( NONPat(i,_) | ASPat(i,_,_) ) =>
		error(i, E.FvalBindPatInvalid)

    and trFappPat_rhs (E,E') =
	fn fpat as APPPat _	=>
	   let
		val pats' = Vector.fromList(trAppliedFappPat_rhs (E,E') fpat)
	   in
		( tuppat(infoPat fpat, pats'), Vector.length pats', [] )
	   end
	 | ATPATPat(i, atpat)	=> trFatPat_rhs (E,E') atpat
	 | fpat			=> trFpat_rhs (E,E') fpat

    and trFatPat_rhs (E,E') =
	fn ALTAtPat(i, fpats) =>
	   let
		val  _                 = insertScope E'
		val (pat',arity,typs') = trFpat_rhs (E,E') (List.hd fpats)
		val  pat'aritytyps's   = trAltFpats_rhs (E,E') (List.tl fpats)
		val (pats',arities,typs'') =
			 List.foldr (fn((p,a,ts), (pl,al,tl)) =>
					(p::pl, a::al, ts@tl)
				    ) ([],[],[]) pat'aritytyps's
		val  _ = mergeDisjointScope E'
			 handle CollisionVal vid' =>
				errorVId(E', vid', E.PatVIdDuplicate)
	   in
		case List.find (fn(_,arity',_) => arity<>arity') pat'aritytyps's
		  of NONE =>
			( altpat(pat'::pats'), arity, typs' @ typs'' )
		   | SOME(pat',_,_) =>
			error(O.infoPat pat', E.FvalBindArityInconsistent)
	   end
	 | PARAtPat(i, fpat)	=> trFpat_rhs (E,E') fpat
	 | LONGVIDAtPat(i,_,_)	=> error(i, E.FvalBindArityZero)
	 | fatpat		=> error(infoAtPat fatpat, E.FvalBindPatInvalid)

    and trAltFpats_rhs (E,E') =
	    List.map(trAltFpat_rhs (E,E'))

    and trAltFpat_rhs (E,E') fpat =
	let
	    val _    = insertScope E'
	    val pat'aritytyps' = trFpat_rhs (E,E') fpat
	    val E''  = splitScope E'
	    val _    = if BindEnv.sizeScope E' = BindEnv.sizeScope E'' then ()
		       else error(infoPat fpat, E.AltPatInconsistent)
	    val _    = BindEnv.appiVals
			    (fn(vid,_) =>
				if Option.isSome(lookupVal(E'',vid)) then ()
				else error(infoPat fpat, E.AltPatInconsistent)
			    ) E'
	in
	    pat'aritytyps'
	end


    and trAppliedFpat_rhs (E,E') =
	fn fpat as (ATPATPat _ | APPPat _) =>
		trAppliedFappPat_rhs (E,E') (Infix.pat (infEnv E) fpat)
	 | fpat => error(infoPat fpat, E.FvalBindPatInvalid)

    and trAppliedFappPat_rhs (E,E') =
	fn ATPATPat(i, fatpat)	  => trAppliedFatPat_rhs (E,E') fatpat
	 | APPPat(i, fpat, atpat) => trAppliedFappPat_rhs (E,E') fpat
				     @ [trAtPat (E,E') atpat]
	 | fpat => error(infoPat fpat, E.FvalBindPatInvalid)

    and trAppliedFatPat_rhs (E,E') =
	fn LONGVIDAtPat _	=> []
	 | PARAtPat(i, fpat)	=> trAppliedFpat_rhs (E,E') fpat
	 | fatpat => error(infoAtPat fatpat, E.FvalBindPatInvalid)



  (* Type and constructor bindings *)

    and trTypBindo' (E,E',eq,acc) =
	fn NONE => acc

	 | SOME(NEWTypBind(_, tyvarseq, tycon as TyCon(i',tycon'), typbindo)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', O.AbsTyp(i',eq,false))
		val  dec'          = O.TypDec(i, typid', funtyp')
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=env(), arity=n, def=NONE, eq=eq, ext=false}
		val  _             = insertDisjointTy(E', tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.TypBindDuplicate tycon')
	   in
		trTypBindo' (E,E',eq, dec'::acc) typbindo
	   end

	 | SOME(EQUALTypBind(_, tyvarseq, tycon as TyCon(i',tycon'), ty,
								typbindo)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, infoTy ty)
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val (typ',E'')     = trTyWithEnv E ty
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', typ')
		val  dec'          = O.TypDec(i', typid', funtyp')
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=E'', arity=n, def=NONE, eq=NONE, ext=false}
		val  _             = insertDisjointTy(E', tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.TypBindDuplicate tycon')
	   in
		trTypBindo' (E,E',eq, dec'::acc) typbindo
	   end

    and trDatBindo_lhs (E,E') =
	fn NONE => ()

	 | SOME(DatBind(i, tyvarseq, tycon, _, datbindo)) =>
	   let
		val TyCon(i',tycon') = tycon
		val (typid',stamp)   = trTyCon_bind E tycon
		val  n               = trTyVarSeqArity tyvarseq
		val  ts              = {CE=env(), arity=n, def=NONE, eq=NONE, ext=false}
		val  _               = insertDisjointTy(E', tycon',
							(i',stamp,ts))
				       handle CollisionTy _ =>
					   error(i', E.DatBindDuplicate tycon')
	   in
		trDatBindo_lhs (E,E') datbindo
	   end

    and trDatBindo_rhs (E,E') datbindo =
	let
	    val (tdecs',cdecs') = trDatBindo_rhs' (E,E',[],[]) datbindo
	in
	    (Vector.rev(Vector.fromList tdecs'), cdecs')
	end

    and trDatBindo_rhs'(E,E',acc1,acc2) =
	fn NONE => (acc1,acc2)

	 | SOME(DatBind(_, tyvarseq, tycon as TyCon(_, tycon'), conbind,
								datbindo)) =>
	   let
		val  i'           = infoConBind conbind
		val  i            = Source.span(infoSeq tyvarseq, i')
		val (typid',{CE=E'',...}) = trTyCon E tycon  (* bound before *)
		val  _            = insertScope E
		val  varids'      = trTyVarSeq E tyvarseq
		val  i_typid      = O.infoId typid'
		val  typ'         = O.ConTyp(i_typid, O.ShortId(i_typid,typid'))
		val (flds',decs') = trConBindo (E,E'',tycon',varids',typ')
					       (SOME conbind)
		val  _            = removeScope E
		val  sumtyp'      = O.SumTyp(i', O.Row(i', flds', NONE))
		val  dec'         = O.TypDec(i, typid', funtyp(varids',sumtyp'))
		val  _            = unionDisjoint(E',E'')
				    handle CollisionVal vid' =>
				      errorVId(E'', vid', E.DatBindConDuplicate)
	   in
		trDatBindo_rhs' (E,E', dec'::acc1, decs'@acc2) datbindo
	   end

    and trConBindo (E,E',tycon',varids',typ') conbindo =
	let
	    val (flds',decs') =
		trConBindo' (E,E',tycon',varids',typ',[],[]) conbindo
	in
	    (Vector.rev(Vector.fromList flds'), decs')
	end

    and trConBindo'(E,E',tycon',varids',typ',acc1,acc2) =
	fn NONE => (acc1,acc2)

	 | SOME(ConBind(i, _, vid as VId(i',vid'), tyo, conbindo)) =>
	   let
		val (valid',stamp) = trConVId_bind E vid
		val (typ1',k)      = trTyo (E,i') tyo
		val  vallab'       = idToLab valid'
		val  fld'          = O.Fld(i, vallab', stricttyp E (typ1',k))
		(* elaborate type again with fresh varids *)
		val  _             = insertScope E
		val  varids2'      = renameVarids E varids'
		val (typ1',k)      = trTyo (E,i') tyo
		val  typ2'         = apptyp(List.map varToTyp varids2', typ')
		val  kty           = List.length varids'
		val  exp'          =
		     if k = NULLARY then
			O.RollExp(i, O.TagExp(i, vallab',
					      O.StrictExp(i, O.TupExp(i, #[]))),
				     typ2')
		     else
		     let
			val validM'     = O.Id(i, Stamp.stamp(), Name.InId)
			val vallongidM' = O.ShortId(i, validM')
			val patM'       = O.VarPat(i, validM')
			val exp0M'      = O.VarExp(i, vallongidM')
			val expM'       = O.RollExp(i, O.TagExp(i, vallab',
							if k = UNARY then exp0M'
							else
							O.StrictExp(i, exp0M')),
						    typ2')
		     in
			O.FunExp(i, #[O.Mat(i, patM', expM')])
		     end
		val  dec'          = O.ValDec(i, O.VarPat(i', valid'), exp')
		val  _             = removeScope E
	   in
		insertDisjointVal(E', vid', (i', stamp, T(k,tycon',kty)))
		handle CollisionVal _ => error(i', E.ConBindDuplicate vid');
		trConBindo' (E,E', tycon',varids',typ', fld'::acc1,
			     vardec(varids2', dec')::acc2) conbindo
	   end


    and trExtBindo' (E,E',acc) =
	fn NONE => acc

	 | SOME(ExtBind(_, tyvarseq, tycon as TyCon(i',tycon'), extbindo)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', O.AbsTyp(i',NONE,true))
		val  dec'          = O.TypDec(i, typid', funtyp')
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=env(), arity=n, def=NONE, eq=NONE, ext=true}
		val  _             = insertDisjointTy(E', tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.ExtBindDuplicate tycon')
	   in
		trExtBindo' (E,E', dec'::acc) extbindo
	   end

    and trEconBindo' (E,E',acc) =
	fn NONE => acc

	 | SOME(NEWEconBind(_, _, vid as VId(i',vid'), tyo, tyvarseq, longtycon,
								 econbindo)) =>
	   let
		val  i               = Source.span(i', infoLong longtycon)
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  vallongid1'     = O.ShortId(i, valid1')
		val  _               = insertScope E
		val (varids',typ12') = trTyVarSeqLongTyCon E
						(tyvarseq, longtycon)
		val (typ11',k)       = trTyo (E,i') tyo
		val  _               = removeScope E
		val  typ1'           = conarrowtyp E (O.infoTyp typ12',
					stricttyp E (typ11',k), typ12')
		val  exp1'           = O.NewExp(i, typ1')
		val  dec1'           = O.ValDec(i, O.VarPat(i', valid1'), exp1')
		val  exp2'           =
		     if k = NULLARY then
			O.ConExp(i, vallongid1', O.StrictExp(i,O.TupExp(i,#[])))
		     else
		     let
			val validM'     = O.Id(i, Stamp.stamp(), Name.InId)
			val vallongidM' = O.ShortId(i, validM')
			val patM'       = O.VarPat(i, validM')
			val exp0M'      = O.VarExp(i, vallongidM')
			val expM'       = O.ConExp(i, vallongid1',
						   if k = UNARY then exp0M' else
						   O.StrictExp(i, exp0M'))
		     in
			O.FunExp(i, #[O.Mat(i, patM', expM')])
		     end
		val  dec2'           = O.ValDec(i, O.VarPat(i', valid2'), exp2')
	   in
		( insertDisjointVal(E', conVId vid', (i', stamp1, V))
		; insertDisjointVal(E', vid',  (i', stamp2, C k))
		) handle CollisionVal _ => error(i', E.EconBindDuplicate vid');
		trEconBindo' (E,E',
			      dec2' :: vardec(varids', dec1') :: acc) econbindo
	   end

	 | SOME(EQUALEconBind(_, _, vid as VId(i',vid'), _,
							longvid, econbindo)) =>
	   let
		val  i               = Source.span(i', infoLong longvid)
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  vallongid1'     = trConLongVId E longvid
		val (vallongid2',is) = trLongVId E longvid
		val  i1              = infoLong longvid
		val  exp1'           = O.VarExp(i1, vallongid1')
		val  dec1'           = O.ValDec(i, O.VarPat(i', valid1'), exp1')
		val  exp2'           = O.VarExp(i1, vallongid2')
		val  dec2'           = O.ValDec(i, O.VarPat(i', valid2'), exp2')
	   in
		case is
		  of C _ =>
		      ( ( insertDisjointVal(E', conVId vid', (i', stamp1, V))
			; insertDisjointVal(E', vid', (i', stamp2, is))
			) handle CollisionVal _ =>
				error(i', E.EconBindDuplicate vid')
		      ; trEconBindo' (E,E', dec2'::dec1'::acc) econbindo
		      )
		   | R =>
		      ( insertDisjointVal(E', vid', (i', stamp2, is))
			handle CollisionVal _ =>
				error(i', E.EconBindDuplicate vid')
		      ; trEconBindo' (E,E', dec2'::acc) econbindo
		      )
		   | (T _ | V) => error(i, E.EconBindNonCon)
	   end


    and trTyo (E,i) (SOME(PARTy(_, typ))) =
	    trTyo (E,i) (SOME typ)
      | trTyo (E,i) (SOME(typ as (TUPLETy _ | RECORDTy _))) =
	let
	    val typ' = trTy E typ
	in
	    ( typ', NARY )
	end
      | trTyo (E,i) (SOME typ) =
	let
	    val typ' = trTy E typ
	in
	    ( typ', UNARY )
	end
      | trTyo (E,i) NONE =
	let
	    val typ' = O.TupTyp(i, #[])
	in
	    ( typ', NULLARY )
	end


    and trTyVarSeqLongTyCon E (tyvarseq, longtycon) =
	let
	    val (typlongid',_) = trLongTyCon E longtycon
	    val  typ'          = O.ConTyp(O.infoLongid typlongid', typlongid')
	    val  varids'       = trTyVarSeq E tyvarseq
	    val  typs'         = List.map (fn varid' =>
	    			      O.VarTyp(O.infoId(#1 varid'), varid')) varids'
	in
	    ( varids', apptyp(typs', typ') )
	end


  (* Structure and signature bindings *)

    and trStrBindo' (E,E',acc) =
	fn NONE => acc

	 | SOME(StrBind(_, strid as StrId(i',strid'), strexp, strbindo)) =>
	   let
		val  i             = Source.span(i', infoStrExp strexp)
		val (modid',stamp) = trStrId_bind E strid
		val (mod',F)       = trStrExp E strexp
		val  F'            = strengthen(stamp,F)
		val  dec'          = O.ModDec(i, modid', mod')
		val  _             = insertDisjointStr(E',strid',(i',stamp,F'))
				     handle CollisionStr _ =>
					error(i', E.StrBindDuplicate strid')
	   in
		trStrBindo' (E,E', dec'::acc) strbindo
	   end


    and trSigBindo' (E,E',acc) =
	fn NONE => acc

	 | SOME(SigBind(_, sigid as SigId(i',sigid'), strpats, sigexp,
								sigbindo)) =>
	   let
		val  i             = Source.span(i', infoSigExp sigexp)
		val (infid',stamp) = trSigId_bind E sigid
		val  _             = insertScope E
		val  modid_infs'   = trStrPats E strpats
		val (inf',F)       = trSigExp E sigexp
		val  _             = removeScope E
		val  dec'          = O.InfDec(i,infid',funinf(modid_infs',inf'))
		val  _             = insertDisjointSig(E', sigid', (i',stamp,F))
				     handle CollisionSig _ =>
					error(i', E.SigBindDuplicate sigid')
	   in
		trSigBindo' (E,E', dec'::acc) sigbindo
	   end


  (* Structure expressions *)

    and trAtStrExp E =
	fn STRUCTAtStrExp(i, dec) =>
	   let
		val _     = insertScope E
		val _     = insertSelf E
		val decs' = trDec E dec
		val E'    = splitScope E
		val F     = PLAIN E'
	   in
		( O.StrMod(i, decs'), F )
	   end

	 | LONGSTRIDAtStrExp(i, longstrid) =>
	   let
		val (modlongid',F) = trLongStrId E longstrid
	   in
		( O.VarMod(i, modlongid'), F )
	   end

	 | LETAtStrExp(i, dec, strexp) =>
	   let
		val  _       = insertScope E
		val  decs'   = trDec E dec
		val (mod',F) = trStrExp E strexp
		val  _       = removeScope E
	   in
		( O.LetMod(i, decs', mod'), F )
	   end

	 | PARAtStrExp(i, strexp) => trStrExp E strexp

    and trStrExp E =
	fn ATSTREXPStrExp(i, atstrexp) => trAtStrExp E atstrexp

	 | APPStrExp(i, strexp, atstrexp) =>
	   let
		val (mod1',F1) = trStrExp E strexp
		val (mod2',F2) = trAtStrExp E atstrexp
		val  F         = apply(F1,F2)
	   in
		( O.AppMod(i, mod1', mod2'), F )
	   end

	 | TRANSStrExp(i, strexp, sigexp) =>
	   let
		val (mod',F1) = trStrExp E strexp
		val (inf',F2) = trSigExp E sigexp
		val  F        = match(F1,F2)
	   in
		( O.AnnMod(i, mod', inf'), F )
	   end

	 | OPAQStrExp (i, strexp, sigexp) =>
	   let
		val (mod',F1) = trStrExp E strexp
		val (inf',F2) = trSigExp E sigexp
	   in
		( O.SealMod(i, mod', inf'), F2 )
	   end

	 | FCTStrExp(i, strpat, strexp) =>
	   let
		val  _            = insertScope E
		val (modid',inf') = trStrPat E strpat
		val (mod',F')     = trStrExp E strexp
		val  _            = removeScope E
		val  F            = PARAM(O.stamp modid', F')
	   in
		( O.FunMod(i, modid', inf', mod'), F )
	   end

	 | UNPACKStrExp(i, exp, sigexp) =>
	   let
		val  exp'    = trExp E exp
		val (inf',F) = trSigExp E sigexp
	   in
		( O.UnpackMod(i, exp', inf'), F )
	   end

	 | LAZYStrExp(i, strexp) =>
	   let
		val (mod',F) = trStrExp E strexp
	   in
		( O.LazyMod(i, mod'), F )
	   end

	 | SPAWNStrExp(i, strexp) =>
	   let
		val (mod',F) = trStrExp E strexp
	   in
		( O.SpawnMod(i, mod'), F )
	   end


    and trStrPat E (StrPat(i, strid as StrId(i', strid'), sigexp)) =
	let
	    val (modid',stamp) = trStrId_bind E strid
	    val (inf',F)       = trSigExp E sigexp
	    val  F'            = strengthen(stamp,F)
	    val  _             = insertStr(E, strid', (i',stamp,F'))
	in
	    (modid', inf')
	end

    and trStrPats E = List.map (trStrPat E)



  (* Signatures and specifications *)

    and expandInclude(i, E) =
	BindEnv.foldri (#3, #3, #3, #3, expandIncludeTy i, expandIncludeStr i,
			expandIncludeSig i) (EMPTYSpec i) E

    and expandIncludeTy i (tycon, (_,_,{def=SOME(tyvarseq,ty),...}), acc) =
	let
	    val typdesc = EQUALTypDesc(i, tyvarseq, TyCon(i, tycon), ty, NONE)
	in
	    SEQSpec(i, TYPESpec(i, typdesc), acc)
	end

      | expandIncludeTy i (tycon, (_,_,{arity,eq,ext=false,...}), acc) =
	let
	    val tyvarseq = Seq(i, List.tabulate(arity, expandIncludeTyVar i))
	    val typdesc  = NEWTypDesc(i, tyvarseq, TyCon(i, tycon), NONE)
	in
	    SEQSpec(i, (case eq of NONE => TYPESpec
				 | SOME true => EQTYPESpec
				 | SOME false => EQEQTYPESpec)(i, typdesc), acc)
	end

      | expandIncludeTy i (tycon, (_,_,{arity,eq,ext=true,...}), acc) =
	let
	    val tyvarseq = Seq(i, List.tabulate(arity, expandIncludeTyVar i))
	    val extdesc  = ExtDesc(i, tyvarseq, TyCon(i, tycon), NONE)
	in
	    SEQSpec(i, EXTTYPESpec(i, extdesc), acc)
	end

    and expandIncludeTyVar i j =
	TyVar(i, TyVar.fromString("'" ^ Int.toString(j+1)))

    and expandIncludeStr i (strid, (_,_,F), acc) =
	(case F
	   of PLAIN E =>
	      let
		  val spec    = expandInclude(i, E)
		  val sigexp  = ATSIGEXPSigExp(i, SIGAtSigExp(i, spec))
		  val strdesc = NEWStrDesc(i, StrId(i, strid), sigexp, NONE)
	      in
		  SEQSpec(i, STRUCTURESpec(i, strdesc), acc)
	      end
	    | _ => acc
	)

    and expandIncludeSig i (sigid, (_,_,F), acc) =
	(case F
	   of (EMPTY | PLAIN _ | ABSTR(_, [], _, [])) =>
	      let
		  val sigdesc = NEWSigDesc(i, SigId(i, sigid), [], NONE)
	      in
		  SEQSpec(i, SIGNATURESpec(i, sigdesc), acc)
	      end
	    | _ =>
	      raise Crash.Crash "AbstractionPhase.expandIncludeSig"
	)

    and induceIncludePrefix(E, sigexp) =
	let
	    val spec = expandInclude(infoSigExp sigexp, E)
	in
	    induceIncludePrefixSigExp(spec, sigexp)
	end

    and induceIncludePrefixAtSigExp(spec, atsigexp) =
	case atsigexp
	 of (ANYAtSigExp _ | LONGSIGIDAtSigExp _) =>
		atsigexp

	 | SIGAtSigExp(i, spec') =>
		SIGAtSigExp(i, SEQSpec(i, spec, spec'))

	 | LETAtSigExp _ =>
		atsigexp	(* not allowed to contain dependencies *)

	 | PARAtSigExp(i, sigexp) =>
		PARAtSigExp(i, induceIncludePrefixSigExp(spec, sigexp))

    and induceIncludePrefixSigExp(spec, sigexp) =
	case sigexp
	 of ATSIGEXPSigExp(i, atsigexp) =>
		ATSIGEXPSigExp(i, induceIncludePrefixAtSigExp(spec, atsigexp))

	  | (APPSigExp _ | FCTSigExp _) =>
		sigexp		(* not allowed to contain dependencies *)

	  | WHERESigExp(i, sigexp1, sigexp2) =>
		WHERESigExp(i, induceIncludePrefixSigExp(spec, sigexp1),
			       induceIncludePrefixSigExp(spec, sigexp2))

    and trAtSigExp E =
	fn ANYAtSigExp(i) =>
	   let
		val F = EMPTY
	   in
		( O.TopInf(i), F )
	   end

	 | SIGAtSigExp(i, spec) =>
	   let
	       val (inf',E') = trSig(E, i, spec)
	   in
	       ( inf', PLAIN E' )
	   end

	 | LONGSIGIDAtSigExp(i, sigid) =>
	   let
		val (inflongid',F) = trLongSigId E sigid
	   in
		( O.ConInf(i, inflongid'), instance F )
	   end

	 | LETAtSigExp(i, dec, sigexp) =>
	   let
		val  _       = insertScope E
		val  decs'   = trDec E dec
		val (inf',F) = trSigExp E sigexp
		val  _       = removeScope E
	   in
		( O.LetInf(i, decs', inf'), F )
	   end

	 | PARAtSigExp(i, sigexp) => trSigExp E sigexp


    and trSigExp E =
	fn ATSIGEXPSigExp(i, atsigexp) => trAtSigExp E atsigexp

	 | APPSigExp(i, sigexp, atstrexp) =>
	   let
		val (inf',F1) = trSigExp E sigexp
		val (mod',F2) = trAtStrExp E atstrexp
		val  F        = apply(F1,F2)
	   in
		( O.AppInf(i, inf', mod'), F )
	   end

	 | FCTSigExp(i, strpat, sigexp) =>
	   let
		val  _             = insertScope E
		val (modid',inf1') = trStrPat E strpat
		val (inf2',F2)     = trSigExp E sigexp
		val  _             = removeScope E
		val  F             = PARAM(O.stamp modid', F2)
	   in
		( O.ArrInf(i, modid', inf1', inf2'), F )
	   end

	 | WHERESigExp(i, sigexp1, sigexp2) =>
	   let
		val (inf1',F1) = trSigExp E sigexp1
		val (inf2',F2) = trSigExp E sigexp2
		val  _         = BindEnv.composeEnvFn(F1,F2)
	   in
		( O.InterInf(i, inf1', inf2'), F1 )
	   end

    and trSig(E, i, spec) =
	let
	    val _  = insertScope E
	    val _  = insertSelf E
	    val (specs', includes) = trSpec E spec
	    val E' = splitScope E
	in
	    List.foldr (fn((Eincl,sigexp),(inf'',E'')) =>
			let
			    val sigexp' = induceIncludePrefix(Eincl, sigexp)
			    val (inf',F') = trSigExp E sigexp'
			    val E' = case F' of PLAIN E' => E'
					      | _ => raise Crash.Crash "trSig"
			    val _ = BindEnv.unionCompose(E',E'')
			in
			    ( O.InterInf(i, inf', inf''), E' )
			end)
		       (O.SigInf(i, specs'), E') includes
	end

    and trSpec  E spec =
	let
	    val (specs',includes) = trSpec' (E,([],[])) spec
	in
	    (Vector.rev(Vector.fromList specs'), List.rev includes)
	end
    and trSpec'(E, acc as (acc1,acc2)) =
	fn VALSpec(i, valdesc) =>
		(trValDesco' (E,acc1) (SOME valdesc), acc2)

	 | TYPESpec(i, typdesc) =>
		(trTypDesco' (E,NONE,acc1) (SOME typdesc), acc2)

	 | EQTYPESpec(i, typdesc) =>
		(trTypDesco' (E,SOME true,acc1) (SOME typdesc), acc2)

	 | EQEQTYPESpec(i, typdesc) =>
		(trTypDesco' (E,SOME false,acc1) (SOME typdesc), acc2)

	 | DATATYPESpec(i, datdesc) =>
	   let
		val  _                = trDatDesco_lhs E (SOME datdesc)
		val (tspecs',cspecs') = trDatDesco_rhs E (SOME datdesc)
	   in
		(cspecs' @ O.RecSpec(i, tspecs') :: acc1, acc2)
	   end

	 | REPLICATIONSpec(i, tycon as TyCon(i', tycon'), longtycon) =>
	   let
		val (typid',stamp)  = trTyCon_bind E tycon
		val (typlongid',{CE=E',arity=n,def,eq,ext})
				    = trLongTyCon E longtycon
		val  modlongido'    = case typlongid'
					of O.ShortId _              => NONE
					 | O.LongId(_,modlongid',_) =>
						SOME modlongid'
(*
		val  E'struct       = case longtycon
					of SHORTLong(i, _) => E
					 | DOTLong(i, longstrid, _) =>
				      case #2(trLongStrId E longstrid)
					of PLAIN E => E
					 | _ => raise Crash.Crash("AbstractionPhase.trSpec: REPLICATIONSpec")
		val E''             = env()
		val ts              = {CE=E'', arity=n, eq=eq, ext=ext}
		val  _              = insertDisjointTy(E, tycon', (i',stamp,ts))
				      handle CollisionTy _ =>
					error(i', E.SpecTyConDuplicate tycon')
*)
		val spec' = O.TypSpec(i, typid',
				      O.ConTyp(infoLong longtycon, typlongid'))
		fun checkCons E0 =
		    appiVals (fn(vid,(_,z,_)) =>
			  case lookupVal(E0, vid)
			   of NONE => error(i, E.ReplicationSpecConShadowed vid)
			    | SOME(_,z',_) => if z = z' then () else
				error(i, E.ReplicationSpecConShadowed vid)) E'
		fun conspecs() =
		    let
			val E'' = env()
			val ty  = TYCONTy(i, Seq(i,[]), longtycon)
			val ts  = {CE=E'', arity=n, def=SOME(Seq(i,[]),ty), eq=eq, ext=ext}
		    in
			insertTy(E, tycon', (i', stamp, ts));
			( foldiVals (trOpenSpecVal (E,i,modlongido',tycon'))
				    (spec' :: acc1) E'
			, acc2 )
			before
			appiVals (fn(vid,_) => insertDisjointVal(E'',vid,
					    Option.valOf(lookupVal(E,vid)))) E'
		    end
	   in
		case longtycon
		 of SHORTLong(_, TyCon(_, tycon)) =>
		    (checkCons E;
		     if Option.isSome(lookupScopeTy(E, tycon))
		     then let val ty  = TYCONTy(i, Seq(i,[]), longtycon)
			      val ts = {CE=E', arity=n, def=SOME(Seq(i,[]),ty), eq=eq, ext=ext} in
			      insertTy(E, tycon', (i', stamp, ts));
			      ( spec'::acc1, acc2 )
			  end
		     else conspecs())
		  | DOTLong(_, longstrid, _) =>
		case #2(trLongStrId E longstrid)
		 of PLAIN E => (checkCons E; conspecs())
		  | _ =>
		    raise Crash.Crash("AbstractionPhase.trSpec: REPLICATIONSpec")
(*
		appiVals (fn(vid,(_,z,_)) =>
			  case lookupVal(E'struct, vid)
			   of NONE => error(i, E.ReplicationSpecConShadowed vid)
			    | SOME(_,z',_) => if z = z' then () else
				error(i, E.ReplicationDecConShadowed vid)) E';
		(foldiVals (trOpenSpecVal (E,i,modlongido',tycon'))
		    (O.TypSpec(i, typid',
			       O.ConTyp(infoLong longtycon, typlongid'))
		    :: acc1) E', acc2)
		before
		appiVals (fn(vid,_) => insertDisjointVal(E'',vid,
					    Option.valOf(lookupVal(E,vid)))) E'
*)
	   end

	 | EXTTYPESpec(i, extdesc) =>
		(trExtDesco' (E,acc1) (SOME extdesc), acc2)

	 | CONSTRUCTORSpec(i, econdesc) =>
		(trEconDesco' (E,acc1) (SOME econdesc), acc2)

	 | STRUCTURESpec(i, strdesc) =>
		(trStrDesco' (E,acc1) (SOME strdesc), acc2)

	 | SIGNATURESpec(i, sigdesc) =>
		(trSigDesco' (E,acc1) (SOME sigdesc), acc2)

	 | INCLUDESpec(i, sigexp) =>
	   let
		val Einclude = BindEnv.cloneScope E
		val (inf',F) = trSigExp E sigexp
		val E'       = case F of PLAIN E' => E'
				       | _ => error(i, E.IncludeSpecNonStruct)
	   in
	       trSpec' (E, (acc1,(Einclude,sigexp)::acc2))
		  (expandInclude(i,E'))
	       (*before union(E,E')	(* to include values etc. *)*)
	   end

	 | EMPTYSpec(i) =>
		(acc1, acc2)

	 | SEQSpec(i, spec1, spec2) =>
		trSpec' (E, trSpec' (E,acc) spec1) spec2

	 | SHARINGTYPESpec(i, spec, longtycons) =>
	   let
		val (specs',includes) = trSpec' (E,([],[])) spec
		val specs'' = List.rev specs'
		val typlongids' = List.map (#1 o trLongTyCon E) longtycons
		val rspecs' = List.rev(Sharing.shareTyp(specs'', typlongids'))
	   in
		(rspecs' @ acc1, includes @ acc2)
	   end

	 | SHARINGSIGNATURESpec(i, spec, longsigids) =>
	   let
		val (specs',includes) = trSpec' (E,([],[])) spec
		val specs'' = List.rev specs'
		val inflongids' = List.map (#1 o trLongSigId E) longsigids
		val rspecs' = List.rev(Sharing.shareSig(specs'', inflongids'))
	   in
		(rspecs' @ acc1, includes @ acc2)
	   end

	 | SHARINGSpec(i, spec, longstrids) =>
	   let
		val (specs',includes) = trSpec' (E,([],[])) spec
		val specs'' = List.rev specs'
		val modlongids' = List.map (#1 o trLongStrId E) longstrids
		val rspecs' = List.rev(Sharing.shareStr(specs'', modlongids'))
	   in
		(rspecs' @ acc1, includes @ acc2)
	   end

	 | INFIXSpec(i, n, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.INFIX(n, Fixity.LEFT)
		val fix'    = O.Fix(i, fix)
		val spec'   = O.FixSpec(i, vallab', fix')
		val _       = insertDisjointInf(E,vid', (i',SOME(Infix.LEFT,n)))
			      handle CollisionInf vid' =>
				error(i', E.SpecFixDuplicate vid')
	   in
		(spec' :: acc1, acc2)
	   end

	 | INFIXRSpec(i, n, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.INFIX(n, Fixity.RIGHT)
		val fix'    = O.Fix(i, fix)
		val spec'   = O.FixSpec(i, vallab', fix')
		val _       = insertDisjointInf(E,vid',(i',SOME(Infix.RIGHT,n)))
			      handle CollisionInf vid' =>
				error(i', E.SpecFixDuplicate vid')
	   in
		(spec' :: acc1, acc2)
	   end

	 | NONFIXSpec(i, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.NONFIX
		val fix'    = O.Fix(i, fix)
		val spec'   = O.FixSpec(i, vallab', fix')
		val _       = insertDisjointInf(E, vid', (i', NONE))
			      handle CollisionInf vid' =>
				error(i', E.SpecFixDuplicate vid')
	   in
		(spec' :: acc1, acc2)
	   end


    and trOpenSpecVal (E,i,modlongido',tycon) (vid', (_,stamp1,is), acc) =
	let
	    val i'         = Source.at i
	    val name       = VId.toString vid'
	    val stamp2     = Stamp.stamp()
	    val valid1'    = O.Id(i', stamp1, Name.ExId name)
	    val valid2'    = O.Id(i', stamp2, Name.ExId name)
	    val vallongid' = case modlongido'
			       of NONE            => O.ShortId(i', valid1')
			        | SOME modlongid' =>
				   O.LongId(i', modlongid',
					    O.Lab(i', Label.fromString name))
	    val typ'       = O.SingTyp(i, vallongid')
	    val is'        = case is of T(k,_,kty) => T(k,tycon,kty) | _ => is
	    val _          = insertDisjointVal(E, vid', (i,stamp2,is'))
			     handle CollisionVal _ =>
				error(i, E.SpecVIdDuplicate vid')
	in
	    O.ValSpec(i, valid2', typ') :: acc
	end




  (* Descriptions *)

    and trValDesco' (E,acc) =
	fn NONE => acc

	 | SOME(NEWValDesc(_, _, vid as VId(i',vid'), ty, valdesco)) =>
	   let
		val  i             = Source.span(i', infoTy ty)
		val (valid',stamp) = trVId_bind E vid
		val  _             = insertScope E
		val  varids'       = trAllTy E ty
		val  typ'          = alltyp(varids', trTy E ty)
		val  _             = removeScope E
		val  spec'         = O.ValSpec(i, valid', typ')
		val  _             = insertDisjointVal(E, vid', (i', stamp, V))
				     handle CollisionVal vid' =>
					error(i', E.SpecVIdDuplicate vid')
	   in
		trValDesco' (E, spec'::acc) valdesco
	   end

	 | SOME(EQUALValDesc(i, _, vid as VId(i',vid'), _, longvid, valdesco))=>
	   let
		val (valid',stamp)  = trVId_bind E vid
		val (vallongid',is) = trLongVId E longvid
		val  typ'           = O.SingTyp(O.infoLongid vallongid',
						vallongid')
		val  spec'          = O.ValSpec(i, valid', typ')
		val  _              = insertDisjointVal(E, vid', (i', stamp, V))
				      handle CollisionVal vid' =>
					error(i', E.SpecVIdDuplicate vid')
	   in
		trValDesco' (E, spec'::acc) valdesco
	   end


    and trTypDesco' (E,eq,acc) =
	fn NONE => acc

	 | SOME(NEWTypDesc(_, tyvarseq, tycon as TyCon(i',tycon'), typdesco)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', O.AbsTyp(i',eq,false))
		val  spec'         = O.TypSpec(i, typid', funtyp')
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=env(), arity=n, def=NONE, eq=eq, ext=false}
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.SpecTyConDuplicate tycon')
	   in
		trTypDesco' (E,eq, spec'::acc) typdesco
	   end

	 | SOME(EQUALTypDesc(_, tyvarseq, tycon as TyCon(i',tycon'),
							ty, typdesco)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, infoTy ty)
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val (typ',E')      = trTyWithEnv E ty
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', typ')
		val  spec'         = O.TypSpec(i, typid', funtyp')
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=E', arity=n, def=SOME(tyvarseq,ty), eq=eq, ext=false}
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.SpecTyConDuplicate tycon')
	   in
		trTypDesco' (E,eq, spec'::acc) typdesco
	   end


    and trDatDesco_lhs E =
	fn NONE => ()

	 | SOME(DatDesc(i, tyvarseq, tycon, _, datdesco)) =>
	   let
		val TyCon(i',tycon') = tycon
		val (typid',stamp)   = trTyCon_bind E tycon
		val n                = trTyVarSeqArity tyvarseq
		val ts               = {CE=env(), arity=n, def=NONE, eq=NONE, ext=false}
		val _                = insertDisjointTy(E, tycon',(i',stamp,ts))
				       handle CollisionTy _ =>
					 error(i', E.SpecTyConDuplicate tycon')
	   in
		trDatDesco_lhs E datdesco
	   end

    and trDatDesco_rhs E datdesco =
	let
	    val (tspecs',cspecs') = trDatDesco_rhs' (E,[],[]) datdesco
	in
	    (Vector.rev(Vector.fromList tspecs'), cspecs')
	end

    and trDatDesco_rhs' (E,acc1,acc2) =
	fn NONE => (acc1,acc2)

	 | SOME(DatDesc(_, tyvarseq, tycon as TyCon(_, tycon'), condesc,
								datdesco)) =>
	   let
		val  i'            = infoConDesc condesc
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',{CE=E',...}) = trTyCon E tycon  (* bound before *)
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  i_typid       = O.infoId typid'
		val  typ'          = O.ConTyp(i_typid,O.ShortId(i_typid,typid'))
		val (flds',specs') = trConDesco (E,E',tycon',varids',typ')
						(SOME condesc)
		val  _             = removeScope E
		val  sumtyp'       = O.SumTyp(i', O.Row(i', flds', NONE))
		val  spec'         = O.TypSpec(i, typid',
						  funtyp(varids', sumtyp'))
		val  _             = unionDisjoint(E,E')
				     handle CollisionVal vid' =>
					errorVId(E', vid', E.SpecVIdDuplicate)
	   in
		trDatDesco_rhs' (E, spec'::acc1, specs'@acc2) datdesco
	   end


    and trConDesco (E,E',tycon',varids',typ') condesco =
	let
	    val (flds',specs') =
		trConDesco'(E,E',tycon',varids',typ',[],[]) condesco
	in
	    (Vector.rev(Vector.fromList flds'), specs')
	end

    and trConDesco'(E,E',tycon',varids',typ',acc1,acc2) =
	fn NONE => (acc1,acc2)

	 | SOME(ConDesc(i, _, vid as VId(i',vid'), tyo, condesco)) =>
	   let
		val (valid',stamp) = trConVId_bind E vid
		val  vallab'       = idToLab valid'
		val (typ1',k)      = trTyo (E,i') tyo
		val  fld'          = O.Fld(i, vallab', stricttyp E (typ1',k))
		val  kty           = List.length varids'
		(* elaborate type again with fresh varids *)
		val  _             = insertScope E
		val  varids2'      = renameVarids E varids'
		val (typ11',k)     = trTyo (E,i') tyo
		val  typ12'        = apptyp(List.map varToTyp varids2', typ')
		val  typ2'         = alltyp(varids2',
					    if k = NULLARY then typ12' else
					    O.ArrTyp(O.infoTyp typ',
						     typ11', typ12'))
		val  spec'         = O.ValSpec(i, valid', typ2')
		val  _             = removeScope E
	   in
		insertDisjointVal(E', vid',  (i', stamp, T(k,tycon',kty)))
		handle CollisionVal _ => error(i', E.ConDescDuplicate vid');
		trConDesco' (E,E',tycon',varids',typ', fld'::acc1,
			     spec'::acc2) condesco
	   end


    and trExtDesco' (E,acc) =
	fn NONE => acc

	 | SOME(ExtDesc(_, tyvarseq, tycon as TyCon(i',tycon'), extdesco)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', O.AbsTyp(i',NONE,true))
		val  spec'         = O.TypSpec(i, typid', funtyp')
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=env(), arity=n, def=NONE, eq=NONE, ext=true}
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.SpecTyConDuplicate tycon')
	   in
		trExtDesco' (E, spec'::acc) extdesco
	   end

    and trEconDesco' (E,acc) =
	fn NONE => acc

	 | SOME(NEWEconDesc(_, _, vid as VId(i',vid'), tyo, tyvarseq, longtycon,
								 econdesco)) =>
	   let
		val  i               = Source.span(i', infoLong longtycon)
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  _               = insertScope E
		val (varids',typ12') = trTyVarSeqLongTyCon E
						(tyvarseq, longtycon)
		val (typ11',k)       = trTyo (E,i') tyo
		val  _               = removeScope E
		val  typ1'           = alltyp(varids',
					      conarrowtyp E (O.infoTyp typ12',
						stricttyp E (typ11',k), typ12'))
		val  spec1'          = O.ValSpec(i, valid1', typ1')
		(* elaborate type again with fresh varids *)
		val  _               = insertScope E
		val (varids',typ12') = trTyVarSeqLongTyCon E
						(tyvarseq, longtycon)
		val (typ11',k)       = trTyo (E,i') tyo
		val  _               = removeScope E
		val  typ2'           = alltyp(varids',
					      if k = NULLARY then typ12' else
					      O.ArrTyp(O.infoTyp typ12',
						       typ11', typ12'))
		val  spec2'          = O.ValSpec(i, valid2', typ2')
	   in
		( insertDisjointVal(E, conVId vid', (i', stamp1, V))
		; insertDisjointVal(E, vid',  (i', stamp2, C k))
		) handle CollisionVal _ => error(i', E.SpecVIdDuplicate vid');
		trEconDesco' (E, spec2'::spec1'::acc) econdesco
	   end

	 | SOME(EQUALEconDesc(_, _, vid as VId(i',vid'), _, longvid,
								econdesco)) =>
	   let
		val  i               = Source.span(i', infoLong longvid)
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  vallongid1'     = trConLongVId E longvid
		val (vallongid2',is) = trLongVId E longvid
		val  typ1'           = O.SingTyp(O.infoLongid vallongid1',
						vallongid1')
		val  spec1'          = O.ValSpec(i, valid1', typ1')
		val  typ2'           = O.SingTyp(O.infoLongid vallongid2',
						vallongid2')
		val  spec2'          = O.ValSpec(i, valid2', typ2')
		val  k               = case is
					 of C k => k
					  | _   => error(i, E.EconDescNonCon)
	   in
		( insertDisjointVal(E, conVId vid', (i', stamp1, V))
		; insertDisjointVal(E, vid',  (i', stamp2, C k))
		) handle CollisionVal _ => error(i', E.SpecVIdDuplicate vid');
		trEconDesco' (E, spec2'::spec1'::acc) econdesco
	   end



    and trStrDesco' (E,acc) =
	fn NONE => acc

	 | SOME(NEWStrDesc(_, strid as StrId(i',strid'), sigexp, strdesco)) =>
	   let
		val  i             = Source.span(i', infoSigExp sigexp)
		val (modid',stamp) = trStrId_bind E strid
		val (inf',F)       = trSigExp E sigexp
		val  F'            = strengthen(stamp,F)
		val  spec'         = O.ModSpec(i, modid', inf')
		val  _             = insertDisjointStr(E, strid', (i',stamp,F'))
				     handle CollisionStr strid' =>
					error(i', E.SpecStrIdDuplicate strid')
	   in
		trStrDesco' (E, spec'::acc) strdesco
	   end

	 | SOME(EQUALStrDesc(_, strid as StrId(i',strid'), sigexpo, longstrid,
								strdesco)) =>
	   let
		val  i2             = infoLong longstrid
		val  i              = Source.span(i', i2)
		val (modid',stamp)  = trStrId_bind E strid
		val (modlongid',F)  = trLongStrId E longstrid
		val  mod'           = O.VarMod(i2, modlongid')
		val  F'             = strengthen(stamp,F)
		val (mod'',F'')     = case sigexpo
					of NONE => (mod',F')
					 | SOME sigexp =>
					let
					    val (inf',F'') = trSigExp E sigexp
					    val i''   = Source.span
							 (infoSigExp sigexp, i2)
					    val mod'' = O.AnnMod(i'', mod',inf')
					in
					    (mod'', match(F',F''))
					end
		val  inf'          = O.SingInf(O.infoMod mod'', mod'')
		val  spec'         = O.ModSpec(i, modid', inf')
		val  _             = insertDisjointStr(E, strid',(i',stamp,F''))
				      handle CollisionStr strid' =>
					error(i', E.SpecStrIdDuplicate strid')
	   in
		trStrDesco' (E, spec'::acc) strdesco
	   end


    and trSigDesco' (E,acc) =
	fn NONE => acc

	 | SOME(NEWSigDesc(_, sigid as SigId(i',sigid'), strpats, sigdesco)) =>
	   let
		val (infid',stamp) = trSigId_bind E sigid
		val  _             = insertScope E
		val  modid_infs'   = trStrPats E strpats
		val  inf'          = funinf(modid_infs', O.AbsInf(i'))
		val  _             = removeScope E
		val  spec'         = O.InfSpec(i', infid', inf')
		val  F             = ABSTR(self E, [], sigid', [])
		val  _             = insertDisjointSig(E, sigid', (i',stamp,F))
				     handle CollisionSig _ =>
					error(i', E.SpecSigIdDuplicate sigid')
	   in
		trSigDesco' (E, spec'::acc) sigdesco
	   end

	 | SOME(EQUALSigDesc(_, sigid as SigId(i',sigid'), strpats, sigexp,
								sigdesco)) =>
	   let
		val  i             = Source.span(i', infoSigExp sigexp)
		val (infid',stamp) = trSigId_bind E sigid
		val  _             = insertScope E
		val  modid_infs'   = trStrPats E strpats
		val (inf',F)       = trSigExp E sigexp
		val  inf''         = funinf(modid_infs', inf')
		val  _             = removeScope E
		val  spec'         = O.InfSpec(i', infid', inf'')
		val  _             = insertDisjointSig(E, sigid', (i',stamp,F))
				     handle CollisionSig _ =>
					error(i', E.SpecSigIdDuplicate sigid')
	   in
		trSigDesco' (E, spec'::acc) sigdesco
	   end



  (* Imports *)

    and trImp (E,E') imp = Vector.rev(Vector.fromList(trImp' (E,E',[]) imp))
    and trImp'(E,E',acc) =
	fn VALImp(i, valitem) =>
		trValItemo' (E,E',acc) (SOME valitem)

	 | TYPEImp(i, typitem) =>
		trTypItemo' (E,E',NONE,acc) (SOME typitem)

	 | EQTYPEImp(i, typitem) =>
		trTypItemo' (E,E',SOME true,acc) (SOME typitem)

	 | EQEQTYPEImp(i, typitem) =>
		trTypItemo' (E,E',SOME false,acc) (SOME typitem)

	 | DATATYPEImp(i, datitem) =>
	   let
		val   _             = trDatItemo_lhs (E,E') (SOME datitem)
		val (timps',cimps') = trDatItemo_rhs (E,E') (SOME datitem)
	   in
		cimps' @ O.RecImp(i, timps') :: acc
	   end

	 | EXTTYPEImp(i, extitem) =>
		trExtItemo' (E,E',acc) (SOME extitem)

	 | CONSTRUCTORImp(i, econitem) =>
		trEconItemo' (E,E',acc) (SOME econitem)

	 | STRUCTUREImp(i, stritem) =>
		trStrItemo' (E,E',acc) (SOME stritem)

	 | SIGNATUREImp(i, sigitem) =>
		trSigItemo' (E,E',acc) (SOME sigitem)

	 | EMPTYImp(i) =>
		acc

	 | SEQImp(i, imp1, imp2) =>
		trImp' (E,E', trImp' (E,E',acc) imp1) imp2

	 | INFIXImp(i, n, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.INFIX(n, Fixity.LEFT)
		val fix'    = O.Fix(i, fix)
		val imp'    = O.FixImp(i, vallab', O.SomeDesc(i,fix'))
		val _       = insertDisjointInf(E, vid',(i',SOME(Infix.LEFT,n)))
			      handle CollisionInf vid' =>
				error(i', E.ImpFixDuplicate vid')
	   in
		imp' :: acc
	   end

	 | INFIXRImp(i, n, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.INFIX(n, Fixity.RIGHT)
		val fix'    = O.Fix(i, fix)
		val imp'    = O.FixImp(i, vallab', O.SomeDesc(i,fix'))
		val _       = insertDisjointInf(E,vid',(i',SOME(Infix.RIGHT,n)))
			      handle CollisionInf vid' =>
				error(i', E.ImpFixDuplicate vid')
	   in
		imp' :: acc
	   end

	 | NONFIXImp(i, vid as VId(i',vid')) =>
	   let
		val vallab' = trVId_bind' E vid
		val fix     = Fixity.NONFIX
		val fix'    = O.Fix(i, fix)
		val imp'    = O.FixImp(i, vallab', O.SomeDesc(i,fix'))
		val _       = insertDisjointInf(E, vid', (i', NONE))
			      handle CollisionInf vid' =>
				error(i', E.ImpFixDuplicate vid')
	   in
		imp' :: acc
	   end


    and trOpenImp (E,i) (E',acc) =
	let
	    (* __pervasive has to go first! *)
	    val acc' = case lookupStr(E',strid_pervasive)
			 of NONE     => acc
			  | SOME str =>
			        trOpenImpStr (E,i) (strid_pervasive,str,acc)
	in
	    (foldiSigs(trOpenImpSig(E,i))
	    (foldiStrs(trOpenImpStr'(E,i))
	    (foldiTys (trOpenImpTy (E,i))
	    (foldiVals(trOpenImpVal(E,i))
	    (foldiInfs(trOpenImpInf(E,i)) acc' E') E') E') E') E')
	end

    and trOpenImpInf (E,i) (vid', (_,inf), acc) =
	let
	    val i'      = Source.at i
	    val name    = VId.toString vid'
	    val vallab' = O.Lab(i', Label.fromString name)
	    val fix'    = O.Fix(i, infStatusToFixity inf)
	    val _       = insertDisjointInf(E, vid', (i',inf))
			  handle CollisionInf _ =>
				error(i, E.ImpFixDuplicate vid')
	in
	    O.FixImp(i, vallab', O.NoDesc(i)) :: acc
	end

    and trOpenImpVal (E,i) (vid', (_,_,is), acc) =
	let
	    val i'     = Source.at i
	    val name   = VId.toString vid'
	    val stamp  = Stamp.stamp()
	    val valid' = O.Id(i', stamp, Name.ExId name)
	    val _      = insertDisjointVal(E, vid', (i',stamp,is))
			 handle CollisionVal _ =>
				error(i, E.ImpVIdDuplicate vid')
	in
	    O.ValImp(i, valid', O.NoDesc(i)) :: acc
	end

    and trOpenImpTy (E,i) (tycon', (_,_,{CE=E',arity=n,def,eq,ext}), acc) =
	let
	    val i'     = Source.at i
	    val name   = TyCon.toString tycon'
	    val stamp  = Stamp.stamp()
	    val typid' = O.Id(i', stamp, Name.ExId name)
	    val E''    = env()
	    val _      = appiVals (fn(vid,_) =>
			    insertDisjointVal(E'',vid,
			    	Option.valOf(lookupVal(E,vid)))) E'
	    val ts     = {CE=E'', arity=n, def=NONE, eq=eq, ext=ext}
	    val _      = insertDisjointTy(E, tycon', (i',stamp,ts))
			 handle CollisionTy _ =>
				error(i, E.ImpTyConDuplicate tycon')
	in
	    O.TypImp(i, typid', O.NoDesc(i)) :: acc
	end

    and trOpenImpStr (E,i) (strid', (_,_,F), acc) =
	let
	    val i'     = Source.at i
	    val name   = StrId.toString strid'
	    val stamp  = Stamp.stamp()
	    val modid' = O.Id(i', stamp, Name.ExId name)
	    val _      = insertDisjointStr(E, strid', (i',stamp,F))
			 handle CollisionStr _ =>
				error(i, E.ImpStrIdDuplicate strid')
	in
	    O.ModImp(i, modid', O.NoDesc(i)) :: acc
	end

    and trOpenImpStr' (E,i) (strid', str, acc) =
	if strid' = strid_pervasive
	then acc
	else trOpenImpStr (E,i) (strid', str, acc)

    and trOpenImpSig (E,i) (sigid', (_,_,F), acc) =
	let
	    val i'     = Source.at i
	    val name   = SigId.toString sigid'
	    val stamp  = Stamp.stamp()
	    val infid' = O.Id(i', stamp, Name.ExId name)
	    val _      = insertDisjointSig(E, sigid', (i',stamp,F))
			 handle CollisionSig _ =>
				error(i, E.ImpSigIdDuplicate sigid')
	in
	    O.InfImp(i, infid', O.NoDesc(i)) :: acc
	end


  (* Items *)

    and trValItemo' (E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINValItem(_, _, vid as VId(i',vid'), valitemo)) =>
	   let
		val (valid',stamp) = trVId_bind E vid
		val  imp'          = O.ValImp(i', valid', O.NoDesc(i'))
		val  is            = Future.byneed(fn() =>
				     if isSome(lookupVal(E', vid'))
				     then V
				     else error(i', E.ValItemUnbound vid'))
		val  _             = insertDisjointVal(E, vid', (i',stamp,is))
				     handle CollisionVal vid' =>
					error(i', E.ImpVIdDuplicate vid')
	   in
		trValItemo' (E,E', imp'::acc) valitemo
	   end

	 | SOME(DESCValItem(_, _, vid as VId(i',vid'), ty, valitemo)) =>
	   let
		val  i             = Source.span(i', infoTy ty)
		val (valid',stamp) = trVId_bind E vid
		val  _             = insertScope E
		val  varids'       = trAllTy E ty
		val  typ'          = alltyp(varids', trTy E ty)
		val  _             = removeScope E
		val  desc'         = O.SomeDesc(O.infoTyp typ', typ')
		val  imp'          = O.ValImp(i, valid', desc')
		val  is            = V
		val  _             = insertDisjointVal(E, vid', (i',stamp,V))
				     handle CollisionVal vid' =>
					error(i', E.ImpVIdDuplicate vid')
	   in
		trValItemo' (E,E', imp'::acc) valitemo
	   end


    and trTypItemo' (E,E',eq,acc) =
	fn NONE => acc

	 | SOME(PLAINTypItem(_, tycon as TyCon(i',tycon'), typitemo)) =>
	   let
		val (typid',stamp) = trTyCon_bind E tycon
		val  imp'          = O.TypImp(i', typid', O.NoDesc(i'))
		val ts             = Future.byneed(fn() =>
				     if Option.isSome(lookupTy(E',tycon'))
				     then {CE=env(),arity=0,def=NONE,eq=eq,ext=false}
				     else error(i', E.TypItemUnbound tycon'))
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.ImpTyConDuplicate tycon')
	   in
		trTypItemo' (E,E',eq, imp'::acc) typitemo
	   end

	 | SOME(DESCTypItem(_, tyvarseq, tycon as TyCon(i',tycon'), typitemo)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', O.AbsTyp(i',NONE,false))
		val  desc'         = O.SomeDesc(O.infoTyp funtyp', funtyp')
		val  imp'          = O.TypImp(i, typid', desc')
		val  E''           = env()
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=E'', arity=n, def=NONE, eq=eq, ext=false}
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.SpecTyConDuplicate tycon')
	   in
		trTypItemo' (E,E',eq, imp'::acc) typitemo
	   end


    and trDatItemo_lhs (E,E') =
	fn NONE => ()

	 | SOME(PLAINDatItem(i, tycon, datitemo)) =>
	   let
		val TyCon(i',tycon') = tycon
		val (typid',stamp)   = trTyCon_bind E tycon
		val  E''             = env()
		val  ts              = {CE=E'', arity=0, def=NONE, eq=NONE, ext=false}
		val  _               = insertDisjointTy(E, tycon',(i',stamp,ts))
				       handle CollisionTy _ =>
					 error(i', E.ImpTyConDuplicate tycon')
	   in
		trDatItemo_lhs (E,E') datitemo
	   end
	 | SOME(DESCDatItem(i, tyvarseq, tycon, _, datitemo)) =>
	   let
		val TyCon(i',tycon') = tycon
		val (typid',stamp)   = trTyCon_bind E tycon
		val  E''             = env()
		val  n               = trTyVarSeqArity tyvarseq
		val  ts              = {CE=E'', arity=n, def=NONE, eq=NONE, ext=false}
		val  _               = insertDisjointTy(E, tycon',(i',stamp,ts))
				       handle CollisionTy _ =>
					 error(i', E.ImpTyConDuplicate tycon')
	   in
		trDatItemo_lhs (E,E') datitemo
	   end

    and trDatItemo_rhs (E,E') datitemo =
	let
	    val (timps',cimps') = trDatItemo_rhs' (E,E',[],[]) datitemo
	in
	    (Vector.rev(Vector.fromList timps'), cimps')
	end

    and trDatItemo_rhs' (E,E',acc1, acc2) =
	fn NONE => (acc1,acc2)

	 | SOME(PLAINDatItem(i, tycon as TyCon(i', tycon'), datitemo)) =>
	   let
		val (typid',{CE=E'',...}) = trTyCon E tycon
		val  imp'        = O.TypImp(i, typid', O.NoDesc(i))
		val  E'''        = case lookupTy(E', tycon')
				    of SOME(_,_,{CE,...}) => CE
				     | NONE => error(i',E.DatItemUnbound tycon')
		val  acc2'       = foldiVals (trOpenImpVal (E'',i)) acc2 E'''
		val  _           = unionDisjoint(E,E'')
				   handle CollisionVal vid' =>
					errorVId(E'', vid', E.ImpVIdDuplicate)
	   in
		trDatItemo_rhs' (E,E', imp'::acc1, acc2') datitemo
	   end

	 | SOME(DESCDatItem(_, tyvarseq, tycon as TyCon(_,tycon'), conitem,
								   datitemo)) =>
	   let
		val  i'           = infoConItem conitem
		val  i            = Source.span(infoSeq tyvarseq, i')
		val (typid',{CE=E'',...}) = trTyCon E tycon
		val  _            = insertScope E
		val  varids'      = trTyVarSeq E tyvarseq
		val  i_typid      = O.infoId typid'
		val  typ'         = O.ConTyp(i_typid, O.ShortId(i_typid,typid'))
		val (flds',imps') = trConItemo (E,E',E'',tycon',varids',typ')
					       (SOME conitem)
		val  _            = removeScope E
		val  sumtyp'      = O.SumTyp(i', O.Row(i', flds', NONE))
		val  desc'        = O.SomeDesc(i', funtyp(varids', sumtyp'))
		val  imp'         = O.TypImp(i, typid', desc')
		val  _            = unionDisjoint(E,E'')
				    handle CollisionVal vid' =>
					errorVId(E'', vid', E.ImpVIdDuplicate)
	   in
		trDatItemo_rhs' (E,E', imp'::acc1, imps'@acc2) datitemo
	   end


    and trConItemo (E,E',E'',tycon',varids',typ') conitemo =
	let
	    val (flds',imps') =
		trConItemo' (E,E',E'',tycon',varids',typ',[],[]) conitemo
	in
	    (Vector.rev(Vector.fromList flds'), imps')
	end

    and trConItemo'(E,E',E'',tycon',varids',typ',acc1,acc2) =
	fn NONE => (acc1,acc2)

	 | SOME(ConItem(i, _, vid as VId(i',vid'), tyo, conitemo)) =>
	   let
		val (valid',stamp) = trConVId_bind E'' vid
		val  vallab'       = idToLab valid'
		val (typ1',k)      = trTyo (E,i') tyo
		val  fld'          = O.Fld(i, vallab', stricttyp E (typ1',k))
		val  kty           = List.length varids'
		(* elaborate type again with fresh varids *)
		val  _             = insertScope E
		val  varids2'      = renameVarids E varids'
		val (typ11',k)     = trTyo (E,i') tyo
		val  typ12'        = apptyp(List.map varToTyp varids2', typ')
		val  typ2'         = alltyp(varids2',
					    if k = NULLARY then typ12' else
					    O.ArrTyp(O.infoTyp typ',
						     typ11', typ12'))
		val  imp'          = O.ValImp(i, valid', O.SomeDesc(i,typ2'))
		val  _             = removeScope E
		val  is            =
		     Future.byneed(fn() =>
		     case lookupVal(E', vid')
		     of SOME(_,_,T _) => T(k,tycon',kty)
		      | SOME(_,_,_)   => error(i', E.ConItemNonCon vid')
		      | NONE          => error(i', E.ConItemUnbound vid'))
	   in
		insertDisjointVal(E'', vid', (i',stamp,is))
		handle CollisionVal _ => error(i', E.ConItemDuplicate vid');
		trConItemo' (E,E',E'',tycon',varids',typ', fld'::acc1,
			     imp'::acc2) conitemo
	   end


    and trExtItemo' (E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINExtItem(_, tycon as TyCon(i',tycon'), extitemo)) =>
	   let
		val (typid',stamp) = trTyCon_bind E tycon
		val  imp'          = O.TypImp(i', typid', O.NoDesc(i'))
		val  ts            = Future.byneed(fn() =>
				     case lookupTy(E',tycon')
				       of SOME(_,_,ts) => ts
				        | NONE =>
					  error(i', E.TypItemUnbound tycon'))
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.ImpTyConDuplicate tycon')
	   in
		trExtItemo' (E,E', imp'::acc) extitemo
	   end

	 | SOME(DESCExtItem(_, tyvarseq, tycon as TyCon(i',tycon'), extitemo)) =>
	   let
		val  i             = Source.span(infoSeq tyvarseq, i')
		val (typid',stamp) = trTyCon_bind E tycon
		val  _             = insertScope E
		val  varids'       = trTyVarSeq E tyvarseq
		val  _             = removeScope E
		val  funtyp'       = funtyp(varids', O.AbsTyp(i',NONE,true))
		val  desc'         = O.SomeDesc(O.infoTyp funtyp', funtyp')
		val  imp'          = O.TypImp(i, typid', desc')
		val  E''           = env()
		val  n             = trTyVarSeqArity tyvarseq
		val  ts            = {CE=E'', arity=n, def=NONE, eq=NONE, ext=true}
		val  _             = insertDisjointTy(E, tycon', (i',stamp,ts))
				     handle CollisionTy _ =>
					error(i', E.SpecTyConDuplicate tycon')
	   in
		trExtItemo' (E,E', imp'::acc) extitemo
	   end

    and trEconItemo' (E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINEconItem(_, _, vid as VId(i',vid'), econitemo)) =>
	   let
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  imp1'           = O.ValImp(i', valid1', O.NoDesc(i'))
		val  imp2'           = O.ValImp(i', valid2', O.NoDesc(i'))
		val  is2             = Future.byneed(fn() =>
				       case lookupVal(E', vid')
				       of SOME(_,_,is as C k) => is
					| SOME(_,_,_) =>
					  error(i', E.EconItemNonCon vid')
					| NONE =>
					  error(i', E.EconItemUnbound vid'))
	   in
		( insertDisjointVal(E, conVId vid', (i',stamp1,V))
		; insertDisjointVal(E, vid', (i',stamp2,is2))
		) handle CollisionVal _ => error(i', E.ImpVIdDuplicate vid');
		trEconItemo' (E,E', imp2'::imp1'::acc) econitemo
	   end

	 | SOME(DESCEconItem(_, _, vid as VId(i',vid'), tyo, tyvarseq,longtycon,
								 econitemo)) =>
	   let
		val  i               = Source.span(i', infoLong longtycon)
		val (valid1',stamp1) = trConVId_bind' E vid
		val (valid2',stamp2) = trConVId_bind E vid
		val  _               = insertScope E
		val (varids',typ12') = trTyVarSeqLongTyCon E
						(tyvarseq, longtycon)
		val (typ11',k)       = trTyo (E,i') tyo
		val  _               = removeScope E
		val  typ1'           = alltyp(varids',
					      conarrowtyp E (O.infoTyp typ12',
						stricttyp E (typ11',k), typ12'))
		val  imp1'           = O.ValImp(i, valid1', O.SomeDesc(i,typ1'))
		val  typ2'           = alltyp(varids',
					      if k = NULLARY then typ12' else
					      O.ArrTyp(O.infoTyp typ12',
						       typ11', typ12'))
		val  imp2'           = O.ValImp(i, valid2', O.SomeDesc(i,typ2'))
		val  is2             = Future.byneed(fn() =>
				       case lookupVal(E', vid')
				       of SOME(_,_,is as C k) => is
					| SOME(_,_,_) =>
					  error(i', E.EconItemNonCon vid')
					| NONE =>
					  error(i', E.EconItemUnbound vid'))
	   in
		( insertDisjointVal(E, conVId vid', (i',stamp1,V))
		; insertDisjointVal(E, vid', (i',stamp2,is2))
		) handle CollisionVal _ => error(i', E.ImpVIdDuplicate vid');
		trEconItemo' (E,E', imp2'::imp1'::acc) econitemo
	   end



    and trStrItemo' (E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINStrItem(_, strid as StrId(i',strid'), stritemo)) =>
	   let
		val (modid',stamp) = trStrId_bind E strid
		val  imp'          = O.ModImp(i', modid', O.NoDesc(i'))
		val  F             = Future.byneed(fn() =>
				     case lookupStr(E', strid')
				     of SOME(_,_,F) => F
				      | NONE =>
					error(i',E.StrItemUnbound strid'))
		val  _             = insertDisjointStr(E, strid', (i',stamp,F))
				     handle CollisionStr strid' =>
					error(i', E.ImpStrIdDuplicate strid')
	   in
		trStrItemo' (E,E', imp'::acc) stritemo
	   end

	 | SOME(DESCStrItem(_, strid as StrId(i',strid'), sigexp, stritemo)) =>
	   let
		val  i             = Source.span(i', infoSigExp sigexp)
		val (modid',stamp) = trStrId_bind E strid
		val (inf',F)       = trSigExp E sigexp
		val  desc'         = O.SomeDesc(O.infoInf inf', inf')
		val  imp'          = O.ModImp(i, modid', desc')
		val  _             = insertDisjointStr(E, strid', (i',stamp,F))
				     handle CollisionStr strid' =>
					error(i', E.ImpStrIdDuplicate strid')
	   in
		trStrItemo' (E,E', imp'::acc) stritemo
	   end



    and trSigItemo' (E,E',acc) =
	fn NONE => acc

	 | SOME(PLAINSigItem(_, sigid as SigId(i',sigid'), sigitemo)) =>
	   let
		val (infid',stamp) = trSigId_bind E sigid
		val  imp'          = O.InfImp(i', infid', O.NoDesc(i'))
		val  F             = Future.byneed(fn() =>
				     case lookupSig(E', sigid')
				       of SOME(_,_,F) => F
					| NONE =>
					  error(i', E.SigItemUnbound sigid'))
		val  _             = insertDisjointSig(E, sigid', (i',stamp,F))
				     handle CollisionSig _ =>
					error(i', E.ImpSigIdDuplicate sigid')
	   in
		trSigItemo' (E,E', imp'::acc) sigitemo
	   end

	 | SOME(DESCSigItem(_, sigid as SigId(i',sigid'), strpats, sigitemo)) =>
	   let
		val (infid',stamp) = trSigId_bind E sigid
		val  _             = insertScope E
		val  modid_infs'   = trStrPats E strpats
		val  inf'          = funinf(modid_infs', O.AbsInf(i'))
		val  _             = removeScope E
		val  desc'         = O.SomeDesc(O.infoInf inf', inf')
		val  imp'          = O.InfImp(i', infid', desc')
		val  F             = Future.byneed(fn() =>
				     case lookupSig(E', sigid')
				     of SOME(_,_,F) => F
				      | NONE =>
					error(i',E.SigItemUnbound sigid'))
		val  _             = insertDisjointSig(E, sigid', (i',stamp,F))
				     handle CollisionSig _ =>
					error(i', E.ImpSigIdDuplicate sigid')
	   in
		trSigItemo' (E,E', imp'::acc) sigitemo
	   end



  (* Announcements *)

    and trAnn (E,E',desc) ann =
	let
	    val (imps',decs') = trAnn' (E,E',desc,[],[]) ann
	in
	    ( Vector.rev(Vector.fromList imps')
	    , Vector.rev(Vector.fromList decs') )
	end

    and trAnn'(E,E',desc,acc1,acc2) =
	fn ann as ( IMPORTAnn(i, imp, s) | PRIMITIVEIMPORTAnn(i, imp, s) ) =>
	   let
		val url   = Url.fromString s
		val E''   = if I.hasAllDescs imp then env() else
			    Future.byneed(fn() =>
			    BindEnvFromSig.envFromSig(i, loadSig(desc, url)))
		val _     = insertScope E
		val imps' = trImp (E,E'') imp
		val E'''  = splitScope E
		val _     = union(E,E''')
		val acc2' = if !Switches.Language.reexportImport then
				trOpenDec (E',i,NONE) (E''',acc2)
			    else
				acc2
		val b     = case ann of IMPORTAnn _ => false | _ => true
	   in
		( O.ImpAnn(i, imps', url, b) :: acc1, acc2' )
	   end

	 | ann as ( IMPORTALLAnn(i, s) | PRIMITIVEIMPORTALLAnn(i, s) ) =>
	   let
		val url   = Url.fromString s
		val E''   = BindEnvFromSig.envFromSig(i, loadSig(desc, url))
		val E'''  = env()
		val imps' = Vector.rev(Vector.fromList
				(trOpenImp (E''',i) (E'',[])))
		val _     = union(E,E''')
		val acc2' = if !Switches.Language.reexportImport then
				trOpenDec (E',i,NONE) (E''',acc2)
			    else
				acc2
		val b     = case ann of IMPORTALLAnn _ => false | _ => true
	   in
		( O.ImpAnn(i, imps', url, b) :: acc1, acc2' )
	   end

	 | EMPTYAnn(i) =>
		(acc1, acc2)

	 | SEQAnn(i, ann1, ann2) =>
	   let
		val (acc1',acc2') = trAnn' (E,E',desc,acc1,acc2) ann1
	   in
		trAnn' (E,E',desc,acc1',acc2') ann2
	   end

    and trLocalAnn (E,vallongid') ann =
	let
	    val decs' = trLocalAnn' (E,vallongid',[]) ann
	in
	    Vector.rev(Vector.fromList decs')
	end

    and trLocalAnn'(E,vallongid',acc) =
	fn IMPORTLocalAnn(i, spec, s) =>
	   let
	       val i0         = Source.at i 
	       val (inf',E')  = trSig(E, infoSpec spec, spec)
	       val urllongvid = DOTLong(i0,
				  SHORTLong(i0, StrId(i0, StrId.fromString "Url")),
				  VId(i0, VId.fromString "fromString"))
	       val (urllongid',_) = trLongVId E urllongvid
	       val exp1'      = O.AppExp(i0, O.VarExp(i0, urllongid'),
					     O.LitExp(i0, O.StringLit s))
	       val exp'       = O.AppExp(i0, O.VarExp(i0, vallongid'), exp1')
	       val mod'       = O.LazyMod(i, O.UnpackMod(i, exp', inf'))
	       val modid'     = O.Id(i0, Stamp.stamp(), Name.ExId "_Import")
	       val dec'       = O.ModDec(i, modid', mod')
	   in
		trOpenDec (E, i0, SOME(O.ShortId(i,modid'))) (E', dec'::acc)
	   end

	 | EMPTYLocalAnn(i) =>
		acc

	 | SEQLocalAnn(i, ann1, ann2) =>
	   let
		val acc' = trLocalAnn' (E,vallongid',acc) ann1
	   in
		trLocalAnn' (E,vallongid',acc') ann2
	   end


  (* Programs and components *)

    fun trProgramo  E programo =
	    Vector.rev(Vector.fromList(trProgramo' (E,[]) programo))

    and trProgramo'(E,acc) =
	fn NONE => acc

	 | SOME(Program(i, dec, programo)) =>
	   let
		val acc' = trDec' (E,acc) dec
	   in
		trProgramo' (E,acc') programo
	   end


    fun trComponent (E,desc) (Component(i, ann, programo)) =
	let
	    val  E'            = env()
	    val  _             = insertSelf E
	    val  _             = insertScope E
	    val (anns',decs1') = trAnn (E,E',desc) ann
	    val  _             = insertScope E
	    val  _             = union(E,E')
	    val  decs2'        = trProgramo E programo
	    val  E''           = splitScope E
	    val  _             = removeScope E
	    val  _             = union(E,E'')
	in
	    O.Com(i, anns', Vector.concat[decs1',decs2'])
	end


    fun translate(desc, E, component) =
	let
	    val E' = BindEnv.clone E
	in
	    (E', trComponent (E',desc) component)
	end
end
