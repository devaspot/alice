val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-05-12 11:17:44 $ by $Author: rossberg $
 *   $Revision: 1.25 $
 *)



















structure CheckIntermediate :> CHECK_INTERMEDIATE =
struct
    structure Env = MkScopedImpMap(StampMap)

    open IntermediateGrammar


  (* Signalling errors *)

    open PrettyPrint
    infixr ^^ ^/^

    datatype debug_info =
	  INT of int
	| ID of Stamp.t * Name.t
	| LAB of Label.t
	| TYPE of Type.t
	| TYPE_PAIR of Type.t * Type.t
	| KIND of Type.kind
	| LONGID of longid

    fun ppDebugInfo'(s, d) =
	vbox(abox(hbox(text s ^/^ text "=") ^/^ d) ^^ break)

    fun ppDebugInfo(INT n) =
	ppDebugInfo'("n", text(Int.toString n))
      | ppDebugInfo(ID(z,n)) =
	ppDebugInfo'("x", text(Name.toString n ^ "[" ^ Stamp.toString z ^ "]"))
      | ppDebugInfo(LAB l) =
	ppDebugInfo'("l", text(Label.toString l))
      | ppDebugInfo(TYPE t) =
	ppDebugInfo'("t", PPType.ppTyp t)
      | ppDebugInfo(TYPE_PAIR(t1,t2)) =
	ppDebugInfo'("t1", PPType.ppTyp t1) ^^
	ppDebugInfo'("t2", PPType.ppTyp t2)
      | ppDebugInfo(KIND k) =
	ppDebugInfo'("k", PPType.ppKind k)
      | ppDebugInfo(LONGID longid) =
	ppDebugInfo'("y", ppLongid longid)

    and ppLongid(ShortId(_, Id(_,z,n))) =
	text(Name.toString n ^ "[" ^ Stamp.toString z ^ "]")
      | ppLongid(LongId(_, y, Lab(_, l))) =
	ppLongid y ^^ text "." ^^ text(Label.toString l)

    fun fail(r,s,d) =
	(TextIO.output(TextIO.stdErr, "intermediate inconsistency at " ^
				      Source.regionToString r ^ ": "^ s ^ "\n");
	 Vector.app (fn d => PrettyPrint.output(TextIO.stdErr,
						ppDebugInfo d, 78)) d;
	 raise Crash.Crash "intermediate inconsistency")

    fun regionOfNonInfo  {region}        = region  (* I want poly records :-( *)
    fun regionOfTypInfo  {region,typ}    = region
    fun regionOfOrigInfo {region,origin} = region

    fun check true  (i,s,d)  = ()
      | check false (i,s,d)  = fail(regionOfTypInfo i, s, d)

    fun checked f x (i,s,d)  = f x handle _ => fail(regionOfTypInfo i, s, d)

    fun check' true  (i,s,d) = ()
      | check' false (i,s,d) = fail(regionOfOrigInfo i, s, d)

    fun checked' f x (i,s,d) = f x handle _ => fail(regionOfNonInfo i, s, d)


  (* Helpers *)

(*DEBUG
    fun matchesRow(r1,r2) =
	(*UNFINISHED: allow row variables? *)
	case (Type.inspectRow r1, Type.inspectRow r2)
	 of (Type.EmptyRow, _) => true
	  | (Type.FieldRow(l1,t1,r1'), FieldRow(l2,t2,r2') =>
	    (case Label.compare(l1,l2)
	     of EQUAL   => Type.equal(t1,t2) andalso matchesRow(r1',r2')
	      | LESS    => false
	      | GREATER => matchesRow(r1,r2')
	    )
	  | _ => false
*)

    exception HigherKind

    fun seals(t1,t2) =
	(* t1 seals t2 <= exists R . Dom R = paths(t1) /\ t2 > R(t1) *)
	(* Unfortunately, this is undecidable. So we try to be as good as
	 * possible, but simply accept all cases involving higher kinds. 8-P
	 *)
	let
	    val A   = Type.paths t1
	    val rea = PathMap.map()
	    val _   = PathMap.appi
			(fn(p,k) => if Type.isStarKind k
				    then PathMap.insert(rea, p, Type.unknown k)
				    else raise HigherKind) A
	    val t1' = Type.realise(rea, t1)
	in
	    ( Type.unify(t2,t1') ; true ) handle Type.Mismatch(t3,t4) => false
(*DEBUG*)
orelse
let fun prTyp name t =
(TextIO.print name; TextIO.print " = ";
 PrettyPrint.output(TextIO.stdOut, PPType.ppTyp t, 76 - size name);
 TextIO.print "\n")
in
prTyp "t2" t2;
prTyp "t1'" t1';
prTyp "t3" t3;
prTyp "t4" t4;
false
end
	end
	handle HigherKind => true


  (* Literals *)

    fun chLit E =
	(* E |- int => c_int *)
	fn IntLit _	=> PervasiveType.typ_int
	(* E |- word => c_word *)
	 | WordLit _	=> PervasiveType.typ_word
	(* E |- char => c_char *)
	 | CharLit _	=> PervasiveType.typ_char
	(* E |- string => c_string *)
	 | StringLit _	=> PervasiveType.typ_string
	(* E |- float => c_real *)
	 | RealLit _	=> PervasiveType.typ_real


  (* Identifiers *)

    fun chLab E (Lab(i, l)) = l
	(*   lab = l
	 * -----------
	 * |- lab => l
	 *)

    fun chId E (Id(i, z, n)) =
	(* id = z    E(z) = t
	 * ------------------
	 *  E |- id : t => t
	 *)
	let
	    val t  = #typ i
	    val t' = checked Env.lookupExistent(E, z)
		     (i, "Id unknown", #[ID(z,n), TYPE t])
	in
	    check (Type.equal(t',t))
		  (i, "Id type", #[ID(z,n), TYPE_PAIR(t',t)]);
	    t
	end

    fun chBindId E (Id(i, z, n)) =
	(* id = z    z notin Dom E    E' = E,z:t
	 * -------------------------------------
	 *       E |- id : t => t,E'
	 *)
	let
	    val t = #typ i
	in
	    checked Env.insertDisjoint(E, z, t)
		    (i, "Id bound twice", #[ID(z,n), TYPE t]);
	    t
	end

    fun chLongid E =
	(* E |- id => t'    t' > t
	 * -----------------------
	 *    E |- id : t => t
	 *)
	fn ShortId(i, id) =>
	   let
		val t  = #typ i
		val t' = chId E id
	   in
		checked Type.match(t',t)
		      (i, "ShortId type",
			  #[ID(stamp id, name id), TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- lab => l    E |- longid => {l:t',r}    t' > t
	 * --------------------------------------------------
	 *            E |- longid.lab : t => t
	 *)
         | LongId(i, longid, lab) =>
	   let
		val t  = #typ i
		val l  = chLab E lab
		val t1 = chLongid E longid
		val r  = checked Type.asProd t1
			 (i, "LongId sel type", #[LONGID longid, TYPE t1])
		val t' = checked Type.lookupRow(r,l)
			 (i, "LongId label", #[LAB l, TYPE t1])
	   in
		checked Type.match(t',t)
		      (i, "LongId type", #[LAB l, TYPE_PAIR(t',t)]);
		t
	   end


  (* Fields *)

    fun chFlds chX E flds =
	(* |- lab => l    E |- X => t    E |- flds => r    l notin r
	 * ---------------------------------------------------------
	 *             E,r |- lab=X,flds => l:t,r
	 *)
	Vector.foldl (chFld chX E) (Type.unknownRow()) flds

    and chFld chX E (Fld(i, lab, x), r) =
	(* |- lab => l    E |- X => t
	 * --------------------------
	 *  E,r |- lab=X => l:t,r
	 *)
	let
	    val l = chLab E lab
	    val t = chX E x
	in
	    checked' Type.extendRow(l,t,r)
		     (i, "Fld duplicate", #[LAB l, TYPE t])
	end


  (* Expressions *)

    fun chExps E exps = Vector.map (chExp E) exps
    and chExp E =
	(*   E |- lit => t
	 * -----------------
	 * E |- lit : t => t
	 *)
	fn LitExp(i, lit) =>
	   let
		val t  = #typ i
		val t' = chLit E lit
	   in
		check (Type.equal(t',t))
		      (i, "LitExp type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(*          t : *
	 * -------------------------
	 * E |- prim string : t => t
	 *)
	 | PrimExp(i, string) =>
	   let
		val t = #typ i
		val k = Type.kind t
	   in
		check (Type.isStarKind k)
		      (i, "PrimExp kind", #[KIND k, TYPE t]);
		t
	   end

	(*          t : *
	 * -------------------------
	 * E |- 'value' : t => t
	 *)
	 | ImmExp(i, value) =>
	   let
		val t = #typ i
		val k = Type.kind t
	   in
		check (Type.isStarKind k)
		      (i, "ImmExp kind", #[KIND k, TYPE t]);
		t
	   end

	(* t = conarrow (t1->t2)    t2 extensible
	 * --------------------------------------
	 *           E |- new : t => t
	 *)
	 | NewExp(i) =>
	   let
		val  t      = #typ i
		val (t',t3) = checked Type.asApply t
			      (i, "NewExp application type", #[TYPE t])
		val (t1,t2) = checked Type.asArrow t3
			      (i, "NewExp type", #[TYPE t3])
	   in
		check (Type.equal(t', PervasiveType.typ_conarrow))
		      (i, "NewExp conarrow", #[TYPE t']);
		check (Type.isExtKind(Type.kind t2))
		      (i, "NewExp kind", #[KIND(Type.kind t2)]);
		t
	   end

	(* E |- longid => t'    t' > t
	 * ---------------------------
	 *   E |- longid : t => t
	 *)
	 | VarExp(i, longid) =>
	   let
		val t  = #typ i
		val t' = chLongid E longid
	   in
		checked Type.match(t',t)
			(i, "VarExp type", #[LONGID longid, TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- lab => l    E |- exp => t'    t = {l:t',r}
	 * -----------------------------------------------
	 *           E |- `lab(exp) : t => t
	 *)
	 | TagExp(i, lab, exp) =>
	   let
		val t   = #typ i
		val l   = chLab E lab
		val t'  = chExp E exp
		val r   = checked Type.asSum t
			  (i, "TagExp type", #[TYPE t])
		val t1  = checked Type.lookupRow(r,l)
			  (i, "TagExp label", #[LAB l, TYPE t])
	   in
		check (Type.equal(t1,t'))
		      (i, "TagExp argument type", #[TYPE_PAIR(t1,t')]);
		t
	   end

	(*  E |- longid => t1    E |- exp => t2
	 * t1 > conarrow (t2->t)    t extensible
	 * -------------------------------------
	 *    E |- longid(exp) : t => t
	 *)
	 | ConExp(i, longid, exp) =>
	   let
		val  t       = #typ i
		val  t1      = chLongid E longid
		val  t2      = chExp E exp
		val (t4,t3)  = checked Type.asApply(Type.instance t1)
			       (i, "ConExp constructor type 1", #[TYPE t1])
		val (t2',t') = checked Type.asArrow t3
			       (i, "ConExp constructor type", #[TYPE t1])
	   in
		check (Type.equal(t4, PervasiveType.typ_conarrow))
		      (i, "ConExp conarrow", #[TYPE t4]);
		check (Type.isExtKind(Type.kind t))
		      (i, "ConExp constructor kind", #[KIND(Type.kind t)]);
		checked Type.unify(t2,t2')
		      (i, "ConExp argument type", #[TYPE_PAIR(t2,t2')]);
		checked Type.unify(t',t)
		      (i, "ConExp type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- exp => t'    t = c_ref(t')
	 * -------------------------------
	 *    E |- ref(exp) : t => t
	 *)
	 | RefExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
		val t1 = Type.apply(PervasiveType.typ_ref, t')
	   in
		check (Type.equal(t1,t))
		      (i, "RefExp type", #[TYPE_PAIR(t1,t)]);
		t
	   end

	(* E |- exp_i => t_i    t = (t_1,..,t_n)
	 * -------------------------------------
	 *    E |- (exp_1,..,exp_n) : t => t
	 *)
	 | TupExp(i, exps) =>
	   let
		val t  = #typ i
		val ts = chExps E exps
	   in
		check (Type.equal(Type.tuple ts, t))
		      (i, "TupExp type", #[TYPE_PAIR(Type.tuple ts, t)]);
		t
	   end

	(* E |- flds => r    t < {r,...}
	 * -----------------------------
	 *     E |- {flds} : t => t
	 *)
	 | ProdExp(i, flds) =>
	   let
		val t = #typ i
		val r = chFlds chExp E flds
	   in
		checked Type.match(Type.prod r, t)
		      (i, "ProdExp type", #[TYPE_PAIR(Type.prod r, t)]);
		t
	   end

	(* E |- lab => l    E |- exp => {l:t,r}
	 * ------------------------------------
	 *       E |- #lab(exp) : t => t
	 *)
	 | SelExp(i, lab, exp) =>
	   let
		val t  = #typ i
		val l  = chLab E lab
		val t' = chExp E exp
		val r  = checked Type.asProd t'
			 (i, "SelExp type", #[LAB l, TYPE t'])
		val t1 = checked Type.lookupRow(r,l)
			 (i, "SelExp label", #[LAB l, TYPE t'])
	   in
		check (Type.equal(t1,t))
		      (i, "SelExp field type", #[LAB l, TYPE_PAIR(t1,t)]);
		t
	   end

	(* E |- exp_i => t'    t = c_vec(t')
	 * ---------------------------------
	 *  E |- #[exp_1,..,exp_n] : t => t
	 *)
	 | VecExp(i, exps) =>
	   let
		val  t      = #typ i
		val  ts     = chExps E exps
		val (t1,t2) = checked Type.asApply t
			      (i, "VecExp type", #[TYPE t])
	   in
		check (Type.equal(t1, PervasiveType.typ_vec))
		      (i, "VecExp type constructor", #[TYPE t1]);
		check (Vector.all (fn t' => Type.equal(t',t2)) ts)
		      (i, "VecExp component type", #[TYPE t2]);
		t
	   end

	(* E |- exp => t'    t' = unroll t
	 * -------------------------------
	 *     E |- roll exp : t => t
	 *)
	 | RollExp(i, exp) =>
	   let
		val t  = #typ i
		val t1 = chExp E exp
		val t' = Type.unroll t
	   in
		check (Type.equal(t',t1))
		      (i, "RollExp type", #[TYPE_PAIR(t',t1)]);
		t
	   end

	(* E |- exp => t'   t' notin V union C    t = c_strict(t')
	 * -------------------------------------------------------
	 *               E |- strict exp : t => t
	 *)
	 | StrictExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
		val t1 = Type.apply(PervasiveType.typ_strict, t')
	   in
		check (not(Type.isVar t' orelse Type.isCon t'))
		      (i, "StrictExp arg type", #[TYPE t']);
		check (Type.equal(t1,t))
		      (i, "StrictExp type", #[TYPE_PAIR(t1,t)]);
		t
	   end

	(* E |- mat_i => t1,t2    t = t1->t2
	 * ---------------------------------
	 * E |- fun mat_1|..|mat_n : t => t
	 *)
	 | FunExp(i, mats) =>
	   let
		val  t      = #typ i
		val (t1,t2) = checked Type.asArrow t
			      (i, "FunExp type", #[TYPE t])
		val  tts    = chMats E mats
	   in
		check (Vector.all (fn(t1',t2') =>
			Type.equal(t1',t1) andalso Type.equal(t2',t2)) tts)
		      (i, "FunExp match types", #[TYPE t]);
		t
	   end

	(* E |- exp1 => t'->t    E |- exp2 => t'
	 * -------------------------------------
	 *       E |- exp1(exp2) : t => t
	 *)
	 | AppExp(i, exp1, exp2) =>
	   let
		val  t      = #typ i
		val  t0     = chExp E exp1
		val  t'     = chExp E exp2
		val (t1,t2) = checked Type.asArrow t0
			      (i, "AppExp function type", #[TYPE t0])
	   in
		check (Type.equal(t1,t'))
		      (i, "AppExp argument type", #[TYPE_PAIR(t1,t')]);
		check (Type.equal(t2,t))
		      (i, "AppExp type", #[TYPE_PAIR(t2,t)]);
		t
	   end

	(* E |- exp1 => c_bool    E |- exp2 => c_bool    t = c_bool
	 * --------------------------------------------------------
	 *                E |- exp1 and exp2 : t => t
	 *)
	 | AndExp(i, exp1, exp2) =>
	   let
		val t  = #typ i
		val t1 = chExp E exp1
		val t2 = chExp E exp2
	   in
		check (Type.equal(t1, PervasiveType.typ_bool))
		      (i, "AndExp left operand type", #[TYPE t1]);
		check (Type.equal(t2, PervasiveType.typ_bool))
		      (i, "AndExp right operand type", #[TYPE t2]);
		check (Type.equal(t,  PervasiveType.typ_bool))
		      (i, "AndExp type", #[TYPE t]);
		t
	   end

	(* E |- exp1 => c_bool    E |- exp2 => c_bool    t = c_bool
	 * --------------------------------------------------------
	 *                E |- exp1 or exp2 : t => t
	 *)
	 | OrExp(i, exp1, exp2) =>
	   let
		val t  = #typ i
		val t1 = chExp E exp1
		val t2 = chExp E exp2
	   in
		check (Type.equal(t1, PervasiveType.typ_bool))
		      (i, "OrExp left operand type", #[TYPE t1]);
		check (Type.equal(t2, PervasiveType.typ_bool))
		      (i, "OrExp right operand type", #[TYPE t2]);
		check (Type.equal(t,  PervasiveType.typ_bool))
		      (i, "OrExp type", #[TYPE t]);
		t
	   end

	(* E |- exp1 => c_bool    E |- exp2 => t    E |- exp3 => t
	 * -------------------------------------------------------
	 *        E |- if exp1 then exp2 else exp3 : t => t
	 *)
	 | IfExp(i, exp1, exp2, exp3) =>
	   let
		val t  = #typ i
		val t1 = chExp E exp1
		val t2 = chExp E exp2
		val t3 = chExp E exp3
	   in
		check (Type.equal(t1, PervasiveType.typ_bool))
		      (i, "IfExp condition type", #[TYPE t1]);
		check (Type.equal(t2, t))
		      (i, "IfExp then branch type", #[TYPE_PAIR(t2,t)]);
		check (Type.equal(t3, t))
		      (i, "IfExp else branch type", #[TYPE_PAIR(t3,t)]);
		t
	   end

	(* E |- exp1 => t'    E |- exp2 => t
	 * ---------------------------------
	 *     E |- exp1;exp2 : t => t
	 *)
	 | SeqExp(i, exp1, exp2) =>
	   let
		val t  = #typ i
		val t1 = chExp E exp1
		val t2 = chExp E exp2
	   in
		check (Type.equal(t2,t))
		      (i, "SeqExp type", #[TYPE_PAIR(t2,t)]);
		t
	   end

	(*   E |- exp => t'    E |- mat_i => t',t
	 * ----------------------------------------
	 * E |- case exp of mat_1|..|mat_n : t => t
	 *)
	 | CaseExp(i, exp, mats) =>
	   let
		val t   = #typ i
		val t'  = chExp E exp
		val tts = chMats E mats
	   in
		check (Vector.all (fn(t1,t2) =>
			Type.equal(t1,t') andalso Type.equal(t2,t)) tts)
		      (i, "CaseExp match types", #[TYPE(Type.arrow(t',t))]);
		t
	   end

	(* E |- exp => c_exn    t : *
	 * --------------------------
	 *  E |- raise exp : t => t
	 *)
	 | RaiseExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
		val k  = Type.kind t
	   in
		check (Type.equal(t', PervasiveType.typ_exn))
		      (i, "RaiseExp argument type", #[TYPE t']);
		check (Type.isStarKind k)
		      (i, "RaiseExp kind", #[KIND k, TYPE t]);
		t
	   end

	(*    E |- exp => t    E |- mat_i => c_exn,t
	 * -------------------------------------------
	 * E |- try exp handle mat_1|..|mat_n : t => t
	 *)
	 | HandleExp(i, exp, mats) =>
	   let
		val t   = #typ i
		val t'  = chExp E exp
		val tts = chMats E mats
	   in
		check (Type.equal(t',t))
		      (i, "HandleExp type", #[TYPE_PAIR(t',t)]);
		check (Vector.all (fn(t1,t2) =>
			Type.equal(t1, PervasiveType.typ_exn) andalso
			Type.equal(t2,t)) tts)
		      (i, "HandleExp match types", #[TYPE t]);
		t
	   end

	(*      t : *
	 * ------------------
	 * E |- fail : t => t
	 *)
	 | FailExp(i) =>
	   let
		val t = #typ i
		val k = Type.kind t
	   in
		check (Type.isStarKind k)
		      (i, "FailExp kind", #[KIND k, TYPE t]);
		t
	   end

	(*     E |- exp => t
	 * ----------------------
	 * E |- lazy exp : t => t
	 *)
	 | LazyExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
	   in
		check (Type.equal(t',t))
		      (i, "LazyExp type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(*     E |- exp => t
	 * -----------------------
	 * E |- spawn exp : t => t
	 *)
	 | SpawnExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
	   in
		check (Type.equal(t',t))
		      (i, "SpawnExp type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- decs => E'    E' |- exp => t
	 * ---------------------------------
	 *   E |- let decs in exp : t => t
	 *)
	 | LetExp(i, decs, exp) =>
	   let
		val t  = #typ i
		val _  = Env.insertScope E
		val _  = chDecs E decs
		val t' = chExp E exp
		val _  = Env.removeScope E
	   in
		check (Type.equal(t',t))
		      (i, "LetExp type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- exp => t'    t seals t'
	 * ----------------------------
	 *    E |- seal exp : t => t
	 *)
	 | SealExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
	   in
		check (seals(t,t'))
		      (i, "SealExp type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- exp => t'    t' seals t
	 * ----------------------------
	 *   E |- unseal exp : t => t
	 *)
	 | UnsealExp(i, exp) =>
	   let
		val t  = #typ i
		val t' = chExp E exp
	   in
		check (seals(t',t))
		      (i, "UnsealExp type", #[TYPE_PAIR(t',t)]);
		t
	   end


    and chMats E mats = Vector.map (chMat E) mats
    and chMat E (Mat(i, pat, exp)) =
	(* E |- pat => t1,E'    E' |- exp => t2
	 * ------------------------------------
	 *      E |- pat -> exp => t1,t2
	 *)
	let
	    val _  = Env.insertScope E
	    val t1 = chPat E pat
	    val t2 = chExp E exp
	    val _  = Env.removeScope E
	in
	    (t1,t2)
	end


  (* Patterns *)

    and chPats E pats = Vector.map (chPat E) pats
    and chPat E =
	(*       t : *
	 * -----------------
	 * E |- _ : t => t,E
	 *)
	fn JokPat(i) =>
	   let
		val t = #typ i
		val k = Type.kind t
	   in
		check (Type.isStarKind k)
		      (i, "JokPat kind", #[KIND k, TYPE t]);
		t
	   end

	(*   E |- lit => t
	 * -------------------
	 * E |- lit : t => t,E
	 *)
	 | LitPat(i, lit) =>
	   let
		val t  = #typ i
		val t' = chLit E lit
	   in
		check (Type.equal(t',t))
		      (i, "LitPat type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- id => t',E'    t' > t
	 * --------------------------
	 *    E |- id : t => t,E'
	 *)
	 | VarPat(i, id) =>
	   let
		val t  = #typ i
		val t' = chBindId E id
	   in
		checked Type.match(t',t)
			(i, "VarPat type",
			    #[ID(stamp id, name id), TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- lab => l    E |- pat => t',E'    t = {l:t',r}
	 * --------------------------------------------------
	 *           E |- `lab(pat) : t => t,E'
	 *)
	 | TagPat(i, lab, pat) =>
	   let
		val t   = #typ i
		val l   = chLab E lab
		val t'  = chPat E pat
		val r   = checked Type.asSum t
			  (i, "TagPat type", #[TYPE t])
		val t1  = checked Type.lookupRow(r,l)
			  (i, "TagPat label", #[LAB l, TYPE t])
	   in
		check (Type.equal(t1,t'))
		      (i, "TagPat argument type", #[TYPE_PAIR(t1,t')]);
		t
	   end

	(* E |- longid => t1    E |- pat => t2,E'
	 * t1 > conarrow (t2->t)    t extensible
	 * --------------------------------------
	 *     E |- longid(pat) : t => t,E'
	 *)
	 | ConPat(i, longid, pat) =>
	   let
		val  t       = #typ i
		val  t1      = chLongid E longid
		val  t2      = chPat E pat
		val (t4,t3)  = checked Type.asApply(Type.instance t1)
			       (i, "ConPat constructor type 1", #[TYPE t1])
		val (t2',t') = checked Type.asArrow t3
			       (i, "ConPat constructor type", #[TYPE t1])
	   in
		check (Type.equal(t4, PervasiveType.typ_conarrow))
		      (i, "ConExp conarrow", #[TYPE t4]);
		check (Type.isExtKind(Type.kind t))
		      (i, "ConPat constructor kind", #[KIND(Type.kind t)]);
		checked Type.unify(t2,t2')
		      (i, "ConPat argument type", #[TYPE_PAIR(t2,t2')]);
		checked Type.unify(t',t)
		      (i, "ConPat type", #[TYPE_PAIR(t',t)]);
		t
	   end
	(* E |- longid => t''   E |- pat => t',E'    t'' > t'->t    t extensible
	 * ---------------------------------------------------------------------
	 *             E |- longid(pat) : t => t,E'
	 | ConPat(i, longid, pat, isNary) =>
	   let
		val t   = #typ i
		val t'  = chPat E pat
		val t'' = chLongid E longid
		(*UNFINISHED: check isNary *)
	   in
		checked Type.match(t'',Type.arrow(t',t))
		      (i, "ConPat type", #[TYPE_PAIR(t'', Type.arrow(t',t))]);
		check (Type.isExtKind(Type.kind t))
		      (i, "ConPat kind", #[KIND(Type.kind t)]);
		t
	   end
	*)

	(* E |- pat => t',E'    t = c_ref(t')
	 * ---------------------------------
	 *    E |- ref(pat) : t => t,E'
	 *)
	 | RefPat(i, pat) =>
	   let
		val t  = #typ i
		val t' = chPat E pat
		val t1 = Type.apply(PervasiveType.typ_ref, t')
	   in
		check (Type.equal(t1,t))
		      (i, "RefPat type", #[TYPE_PAIR(t1,t)]);
		t
	   end

	(* E |- pat_i => t_i,E_i    t = (t_1,..,t_n)    E' = E,E_1,..,E_n
	 * --------------------------------------------------------------
	 *               E |- (pat_1,..,pat_n) : t => t,E'
	 *)
	 | TupPat(i, pats) =>
	   let
		val t  = #typ i
		val ts = chPats E pats
	   in
		check (Type.equal(Type.tuple ts, t))
		      (i, "TupPat type", #[TYPE_PAIR(Type.tuple ts, t)]);
		t
	   end

	(* E |- flds => r,E'    t < {r,...}
	 * --------------------------------
	 *     E |- {flds} : t => t,E'
	 *)
	 | ProdPat(i, flds) =>
	   let
		val t  = #typ i
		val r  = chFlds chPat E flds
	   in
		checked Type.match(Type.prod r, t)
		      (i, "ProdPat type", #[TYPE_PAIR(Type.prod r, t)]);
		t
	   end

	(* E |- pat_i => t',E_i    t = c_vec(t')    E' = E,E_1,..,E_n
	 * ----------------------------------------------------------
	 *             E |- #[pat_1,..,pat_n] : t => t,E'
	 *)
	 | VecPat(i, pats) =>
	   let
		val  t      = #typ i
		val  ts     = chPats E pats
		val (t1,t2) = checked Type.asApply t
			      (i, "VecPat type", #[TYPE t])
	   in
		check (Type.equal(t1, PervasiveType.typ_vec))
		      (i, "VecPat type constructor", #[TYPE t1]);
		check (Vector.all (fn t' => Type.equal(t',t2)) ts)
		      (i, "VecPat component type", #[TYPE t2]);
		t
	   end

	(* E |- pat => t'    t' = unroll t
	 * -------------------------------
	 *     E |- roll pat : t => t
	 *)
	 | RollPat(i, pat) =>
	   let
		val t  = #typ i
		val t1 = chPat E pat
		val t' = Type.unroll t
	   in
		check (Type.equal(t',t1))
		      (i, "RollPat type", #[TYPE_PAIR(t',t1)]);
		t
	   end

	(* E |- pat => t',E'   t' notin V union C    t = c_strict(t')
	 * ----------------------------------------------------------
	 *               E |- strict pat : t => t,E'
	 *)
	 | StrictPat(i, pat) =>
	   let
		val t  = #typ i
		val t' = chPat E pat
		val t1 = Type.apply(PervasiveType.typ_strict, t')
	   in
		check (not(Type.isVar t' orelse Type.isCon t'))
		      (i, "StrictPat arg type", #[TYPE t']);
		check (Type.equal(t1,t))
		      (i, "StrictPat type", #[TYPE_PAIR(t1,t)]);
		t
	   end

	(* E |- pat1 => t,E1    E |- pat2 => t,E2    E' = E,E1,E2
	 * ------------------------------------------------------
	 *             E |- pat1 as pat2 : t => t,E'
	 *)
	 | AsPat(i, pat1, pat2) =>
	   let
		val t  = #typ i
		val t1 = chPat E pat1
		val t2 = chPat E pat2
	   in
		check (Type.equal(t1,t))
		      (i, "AsPat left operand type", #[TYPE_PAIR(t1,t)]);
		check (Type.equal(t2,t))
		      (i, "AsPat right operand type", #[TYPE_PAIR(t2,t)]);
		t
	   end

	(* E |- pat1 => t,E'    E |- pat2 => t,E'
	 * --------------------------------------
	 *      E |- pat1 | pat2 : t => t,E'
	 *)
	 | AltPat(i, pat1, pat2) =>
	   let
		val t  = #typ i
		val _  = Env.insertScope E
		val t1 = chPat E pat1
		val E' = Env.splitScope E
		val _  = Env.insertScope E
		val t2 = chPat E pat2
	   in
		check (Type.equal(t1,t))
		      (infoPat pat1, "AltPat left type", #[TYPE_PAIR(t1,t)]);
		check (Type.equal(t2,t))
		      (infoPat pat1, "AltPat right type", #[TYPE_PAIR(t2,t)]);
		check (Env.sizeScope E' = Env.sizeScope E)
		      (i, "AltPat bindings", #[INT(Env.sizeScope E'),
					       INT(Env.sizeScope E)]);
		Env.appiScope
		    (fn(z,t1) =>
			let val t2 = checked Env.lookupExistent(E,z)
				     (i, "AltPat bindings", #[ID(z, Name.InId)])
			in check (Type.equal(t1,t2))
				 (i, "AltPat binding types",
				     #[ID(z, Name.InId), TYPE_PAIR(t1,t2)])
			end
		    ) E';
		Env.mergeScope E;
		t
	   end

	(*     E |- pat => t,E'
	 * ------------------------
	 * E |- non pat : t => t,E
	 *)
	 | NegPat(i, pat) =>
	   let
		val t  = #typ i
		val _  = Env.insertScope E
		val t' = chPat E pat
		val _  = Env.removeScope E
	   in
		check (Type.equal(t',t))
		      (i, "NegPat type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- pat => t,E'    E' |- exp => c_bool
	 * ---------------------------------------
	 *     E |- pat where exp : t => t,E'
	 *)
	 | GuardPat(i, pat, exp) =>
	   let
		val t  = #typ i
		val t' = chPat E pat
		val t2 = chExp E exp
	   in
		check (Type.equal(t2, PervasiveType.typ_bool))
		      (i, "GuardPat condition type", #[TYPE t2]);
		check (Type.equal(t',t))
		      (i, "GuardPat type", #[TYPE_PAIR(t',t)]);
		t
	   end

	(* E |- pat => t,E'    E' |- decs => E''
	 * -------------------------------------
	 *  E |- pat with decs end : t => t,E''
	 *)
	 | WithPat(i, pat, decs) =>
	   let
		val t  = #typ i
		val t' = chPat E pat
	   in
		chDecs E decs;
		check (Type.equal(t',t))
		      (i, "WithPat type", #[TYPE_PAIR(t',t)]);
		t
	   end


  (* Declarations *)

    and chDecs E decs = Vector.app (chDec E) decs
    and chDec E =
	(* E |- pat => t,E'    E |- exp => t
	 * ---------------------------------
	 *      E |- pat = exp => E'
	 *)
	fn ValDec(i, pat, exp) =>
	   let
		val t1 = #typ(infoPat pat)
		val t2 = #typ(infoExp exp)
	   in
		chExp E exp;
		chPat E pat;
		check' (Type.equal(t1,t2))
		       (i, "ValDec lhs/rhs type", #[TYPE_PAIR(t1,t2)])
	   end

	(*      E' |- decs => E'
	 * -------------------------
	 * E |- rec decs = exp => E'
	 *)
         | RecDec(i, decs) =>
	   let in
		chRecDecsLHS E decs;
		Env.insertScope E;
		chDecs E decs;
		Env.removeScope E
	   end

    and chRecDecsLHS E decs = Vector.app (chRecDecLHS E) decs
    and chRecDecLHS E =
	fn ValDec(i, pat, exp) =>
		ignore(chPat E pat)
		(*UNFINISHED: check rec restrictions*)

         | RecDec(i, decs) =>
		chRecDecsLHS E decs


  (* Components *)

    fun chImps E imps = Vector.app (chImp E) imps
    and chImp E (id, s, url, b) = ignore(chBindId E id)

    fun check (imps, decs, flds, s) =
	(* |- imps => E    E |- decs => E'    E' |- flds => r
	 * --------------------------------------------------
	 *      |- import imps let decs in flds : s
	 *)
	let
	    val E = Env.map()
	in
	    chImps E imps;
	    chDecs E decs;
	    ignore(chFlds chId E flds)
	end
end
