val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2006
 *
 * Last change:
 *   $Date: 2006-07-06 15:10:56 $ by $Author: rossberg $
 *   $Revision: 1.59 $
 *)























structure ElaborationError :> ELABORATION_ERROR =
struct

  (* Pretty printer *)

    open PrettyPrint
    open PPMisc

    infixr ^^ ^/^
    nonfix mod

  (* Types *)

    type url       = Url.t
    type lab       = Label.t
    type path      = Path.t
    type typ       = Type.t
    type var       = Type.var
    type kind      = Type.kind
    type inf       = Inf.t
    type fix       = Fixity.t
    type valid     = AbstractGrammar.valid
    type modlongid = AbstractGrammar.modlongid

    type typ_mismatch = typ * typ * typ * typ
    type inf_mismatch = Inf.mismatch

    datatype error =
	(* Expressions *)
	  NewExpTyp		of typ
	| NewExpResTyp		of typ
	| VecExpMismatch	of typ_mismatch
	| TagExpLab		of lab
	| TagExpArgMismatch	of typ_mismatch
	| ConExpConMismatch	of typ_mismatch
	| ConExpArgMismatch	of typ_mismatch
	| RollExpMismatch	of typ_mismatch
	| UpdExpMismatch	of typ_mismatch
	| SelExpMismatch	of typ_mismatch
	| AppExpFunMismatch	of typ_mismatch
	| AppExpArgMismatch	of typ_mismatch
	| AndExpMismatch	of typ_mismatch
	| OrExpMismatch		of typ_mismatch
	| IfExpCondMismatch	of typ_mismatch
	| IfExpBranchMismatch	of typ_mismatch
	| RaiseExpMismatch	of typ_mismatch
	| HandleExpMismatch	of typ_mismatch
	| AnnExpMismatch	of typ_mismatch
	| MatPatMismatch	of typ_mismatch
	| MatExpMismatch	of typ_mismatch
	| LetExpGenerative	of inf
	| OverExpEmpty
	| OverExpArity
	| OverExpNonPrimTyp	of typ
	| OverExpOverlap	of typ * typ
	| OverExpKind		of typ
	| OverExpMismatch	of typ_mismatch
	| OverallExpMismatch	of typ_mismatch
	(* Patterns *)
	| TagPatLab		of lab
	| TagPatArgMismatch	of typ_mismatch
	| ConPatConMismatch	of typ_mismatch
	| ConPatArgMismatch	of typ_mismatch
	| RollPatMismatch	of typ_mismatch
	| VecPatMismatch	of typ_mismatch
	| AsPatMismatch		of typ_mismatch
	| AltPatMismatch	of typ_mismatch
	| GuardPatMismatch	of typ_mismatch
	| AnnPatMismatch	of typ_mismatch
	(* Types *)
	| JokTyp
	| StarTypKind		of kind
	| AppTypFunKind		of kind
	| AppTypArgKind		of kind * kind
	| RefTypKind		of kind
	| PervasiveTypUnknown	of string
	(* Rows *)
	| FldRowDuplicate	of lab
	| EllRowType		of typ
	(* Declarations *)
	| ValDecMismatch	of typ_mismatch
	| ValDecUnclosed	of typ
	| ValDecLift		of valid * var
	| RecValDecNonValue
	(* Long ids *)
	| ModlongidInf		of modlongid * inf
	(* Modules *)
	| StrModUnclosed	of lab * typ
	| SelModInf		of inf
	| AppModFunMismatch	of inf
	| AppModArgMismatch	of inf_mismatch
	| AnnModMismatch	of inf_mismatch
	| UnpackModMismatch	of typ_mismatch
	(* Interfaces *)
	| GroundInfKind		of Inf.kind
	| AppInfFunMismatch	of inf
	| AppInfArgMismatch	of inf_mismatch
	| InterInfMismatch	of inf_mismatch
	| LetInfGenerative	of inf
	| SingInfNonSing	of inf
	| PervasiveInfUnknown	of string
	(* Imports *)
	| ImpMismatch		of inf_mismatch
	| ImplicitImpHiddenTyp	of url * path
	| ImplicitImpHiddenMod	of url * path
	| ImplicitImpHiddenInf	of url * path
	| ImplicitImpInconsistent of url * path * url
	| ImplicitImpHiddenTransTyp of url * path * url
	| ImplicitImpHiddenTransMod of url * path * url
	| ImplicitImpHiddenTransInf of url * path * url
	(* Exports *)
	| ExportUnclosed	of lab * typ

    datatype warning =
	(* Imports *)
	  ValImpUnused		of lab
	| TypImpUnused		of lab
	| ModImpUnused		of lab
	| InfImpUnused		of lab
	| TypImpInserted	of url * path * url
	| InfImpInserted	of url * path * url
	(* Exports *)
	| ExportNotGeneralized	of valid * typ
	| ExportHiddenTyp	of path
	| ExportHiddenMod	of path
	| ExportHiddenInf	of path


  (* Pretty printing *)

    fun ppUrl u = Url.toStringRaw u

    fun ppQuoted s = "`" ^ s ^ "'"

    fun ppLab'(AbstractGrammar.Lab(_,l)) = Label.toString l

    fun ppId'(AbstractGrammar.Id(_,_,n)) = Name.toString n
    fun ppId x = ppQuoted(ppId' x)

    fun ppLongid'(AbstractGrammar.ShortId(_,x))  = ppId' x
      | ppLongid'(AbstractGrammar.LongId(_,y,l)) = ppLongid' y ^ "." ^ ppLab' l
    fun ppLongid y = ppQuoted(ppLongid' y)

    fun ppLab l = Label.toString l

    val ppPath = PPPath.ppPath
    val ppTyp  = PPType.ppTyp
    val ppInf  = PPInf.ppInf

    val ppInfMismatch = PPMismatch.ppMismatch'

    fun ppTypMismatch2(d1, d2, (t1,t2,t3,t4)) =
	vbox(
	    d1 ^^ indent(PPType.ppTyp t1) ^/^
	    d2 ^^ indent(PPType.ppTyp t2)
	)

    fun ppTypMismatch4(d1, d2, (t1,t2,t3,t4)) =
	let
	    val td1 = PPType.ppTyp t1
	    val td2 = PPType.ppTyp t2
	    val td3 = PPType.ppTyp t3
	    val td4 = PPType.ppTyp t4
	in
	    if td3 = td1 andalso td4 = td2 then
		vbox(
		    d1 ^^ indent td1 ^/^
		    d2 ^^ indent td2
		)
	    else
		vbox(
		    d1 ^^ indent td1 ^/^
		    d2 ^^ indent td2 ^/^
		    textpar["because","type"] ^^ indent td3 ^/^
		    textpar["does","not","unify","with"] ^^ indent td4
		)
	end

    fun unstrict1 t =
	case Type.inspect t
	 of Type.Apply(t1,t2) =>
	    if Type.equal(t1, PervasiveType.typ_strict)
	    then t2
	    else t
	  | _ => t

    fun unstrict(t1,t2,t3,t4) =
	(unstrict1 t1, unstrict1 t2, unstrict1 t3, unstrict1 t4)

    fun ppRollTypMismatch(ue as (t1,t2,t3,t4)) =
	let
	    val (l,t1',r) = Type.asFieldRow(Type.asSum t1)
	    val  t2'      = Type.lookupRow(Type.asSum(Type.unroll t2), l)
	    val  ue'      = unstrict(t1',t2',t3,t4)
	in
	    ppTypMismatch4(textpar["ill-typed","constructor","argument:"],
			   textpar["does","not","match","argument","type"], ue')
	end
	handle (Type.Type | Type.Row) =>
	    ppTypMismatch4(textpar["ill-typed","recursive","value:"],
			   textpar["does","not","match","recursive","type"], ue)


    fun ppUnclosed(d, (l,t)) =
	vbox(
	    d ^^
	    indent(
		fbox(nest(
		    text(Label.toString l) ^/^
		    text ":" ^/^
		    below(PPType.ppTyp t)
		))
	    ) ^/^
	    textpar["contains","free","type","variable"]
	)


    fun ppError(NewExpTyp t) =
	vbox(
	    textpar["new","constructor","is","not","of","function","type:"] ^^
	    indent(PPType.ppTyp t)
	)
      | ppError(NewExpResTyp t) =
	vbox(
	    textpar["type","is","not","extensible:"] ^^
	    indent(PPType.ppTyp t)
	)
      | ppError(VecExpMismatch ue) =
	ppTypMismatch2(
	  textpar["inconsistent","types","in","vector","expression:"],
	  textpar["does","not","agree","with","previous","element","type"], ue)
      | ppError(TagExpLab l) =
	  textpar["label",ppQuoted(ppLab l),"is","not","contained","in","type"]
      | ppError(TagExpArgMismatch ue | ConExpArgMismatch ue) =
	ppTypMismatch4(
	  textpar["mismatch","on","constructor","application:",
		  "expression","type"],
	  textpar["does","not","match","constructor's","argument","type"],
	  unstrict ue)
      | ppError(ConExpConMismatch ue) =
	ppTypMismatch2(
	  textpar["applied","value","is","not","a","constructor","function:"],
	  textpar["does","not","match","function","type"], ue)
      | ppError(RollExpMismatch ue) =
	ppRollTypMismatch ue
      | ppError(UpdExpMismatch ue) =
	ppTypMismatch4(
	  textpar["mismatch","on","record","update:","expression","type"],
	  textpar["does","not","match","field","type"], ue)
      | ppError(SelExpMismatch ue) =
	ppTypMismatch2(
	  textpar["mismatch","on","selection:","expression","type"],
	  textpar["does","not","match","selector's","argument","type"], ue)
      | ppError(AppExpFunMismatch ue) =
	ppTypMismatch2(
	  textpar["applied","value","is","not","a","function:"],
	  textpar["does","not","match","function","type"], ue)
      | ppError(AppExpArgMismatch ue) =
	ppTypMismatch4(
	  textpar["mismatch","on","application:","expression","type"],
	  textpar["does","not","match","function's","argument","type"], ue)
      | ppError(AndExpMismatch ue) =
	ppTypMismatch2(
	  textpar["operand","of","`andalso'","is","not","a","boolean:"],
	  textpar["does","not","match","type"], ue)
      | ppError(OrExpMismatch ue) =
	ppTypMismatch2(
	  textpar["operand","of","`orelse'","is","not","a","boolean:"],
	  textpar["does","not","match","type"], ue)
      | ppError(IfExpCondMismatch ue) =
	ppTypMismatch2(
	  textpar["operand","of","`if'","is","not","a","boolean:"],
	  textpar["does","not","match","type"], ue)
      | ppError(IfExpBranchMismatch ue) =
	ppTypMismatch4(
	  textpar["inconsistent","types","in","branches","of","`if':"],
	  textpar["does","not","agree","with","type"], ue)
      | ppError(RaiseExpMismatch ue) =
	ppTypMismatch2(
	  textpar["operand","of","`raise'","is","not","an","exception:"],
	  textpar["does","not","match","type"], ue)
      | ppError(HandleExpMismatch ue) =
	ppTypMismatch4(
	  textpar["inconsistent","types","in","branches","of","`handle':"],
	  textpar["does","not","agree","with","type"], ue)
      | ppError(AnnExpMismatch ue) =
	ppTypMismatch4(
	  textpar["expression","does","not","match","annotation:"],
	  textpar["does","not","match","type"], ue)
      | ppError(MatPatMismatch ue) =
	ppTypMismatch4(
	  textpar["inconsistent","types","in","`case'","patterns:"],
	  textpar["does","not","agree","with","previous","type"], ue)
      | ppError(MatExpMismatch ue) =
	ppTypMismatch4(
	  textpar["inconsistent","types","in","branches","of","`case':"],
	  textpar["does","not","agree","with","previous","type"], ue)
      | ppError(LetExpGenerative j) =
	let
	    val {typ,mod,inf} = Inf.boundPaths j
	    val doc1 = PathMap.foldi (fn(p,_,doc) =>
			text "type " ^^ PPPath.ppPath p ^/^ doc) empty typ
	    val doc2 = PathMap.foldi (fn(p,_,doc) =>
			text "structure " ^^ PPPath.ppPath p ^/^ doc) empty mod
	    val doc3 = PathMap.foldi (fn(p,_,doc) =>
			text "signature " ^^ PPPath.ppPath p ^/^ doc) empty inf
	in
	    vbox(
		textpar["type","of","let","body","contains","local","names:"] ^^
		indent(
		    doc1 ^/^ (*doc2 ^/^*) doc3
		)
	    )
	end
      | ppError(OverExpEmpty) =
	  textpar["empty","overloading"]
      | ppError(OverExpArity) =
	  textpar["number","of","overloaded","types","does","not",
		  "match","number","of","cases"]
      | ppError(OverExpNonPrimTyp t) =
	vbox(
	    textpar["non-abstract","overloaded","type:"] ^^
	    indent(PPType.ppTyp t)
	)
      | ppError(OverExpOverlap(t1,t2)) =
	vbox(
	    textpar["overlapping","overload,","because", "type"] ^^
	    indent(PPType.ppTyp t1) ^/^
	    textpar["is","the","same","as","type"] ^^
	    indent(PPType.ppTyp t2)
	)
      | ppError(OverExpKind t) =
	vbox(
	    textpar["inconsistent","kinds","in","overloading:"] ^^
	    indent(PPType.ppTyp t) ^/^
	    textpar["does","not","agree","with","previous","type"]
	)
      | ppError(OverExpMismatch ue) =
	ppTypMismatch4(
	  textpar["type","mismatch","in","overloading:"],
	  textpar["does","not","match","instance","type"], ue)
      | ppError(OverallExpMismatch ue) =
	ppTypMismatch4(
	  textpar["type","mismatch","in","intensional","overloading:"],
	  textpar["does","not","match","implementation","type"], ue)
      (* Patterns *)
      | ppError(TagPatLab l) =
	  textpar["label",ppQuoted(ppLab l),"is","not","contained","in","type"]
      | ppError(TagPatArgMismatch ue | ConPatArgMismatch ue) =
	ppTypMismatch4(
	  textpar["ill-typed","constructor","argument:"],
	  textpar["does","not","match","argument","type"], unstrict ue)
      | ppError(ConPatConMismatch ue) =
	ppTypMismatch2(
	  textpar["applied","identifier","is","not","a","constructor",
		  "function:"],
	  textpar["does","not","match","function","type"], ue)
      | ppError(RollPatMismatch ue) =
	ppRollTypMismatch ue
      | ppError(VecPatMismatch ue) =
	ppTypMismatch2(
	  textpar["inconsistent","types","in","vector","pattern:"],
	  textpar["does","not","agree","with","previous","element","type"], ue)
      | ppError(AsPatMismatch ue) =
	ppTypMismatch4(
	  textpar["inconsistent","types","in","`as'","pattern:"],
	  textpar["does","not","agree","with","type"], ue)
      | ppError(AltPatMismatch ue) =
	ppTypMismatch4(
	  textpar["inconsistent","types","in","pattern","alternatives:"],
	  textpar["does","not","agree","with","previous","type"], ue)
      | ppError(GuardPatMismatch ue) =
	ppTypMismatch2(
	  textpar["pattern","guard","is","not","a","boolean:"],
	  textpar["does","not","match","type"], ue)
      | ppError(AnnPatMismatch ue) =
	ppTypMismatch4(
	  textpar["pattern","does","not","match","annotation:"],
	  textpar["does","not","match","type"], ue)
      (* Types *)
      | ppError(JokTyp) =
	  textpar["misplaced","type","wildcard"]
      | ppError(StarTypKind k) =
	  textpar["missing","arguments","in","type","expression"]
      | ppError(AppTypFunKind k) =
	  textpar["type","expression","is","not","a","type","function"]
      | ppError(AppTypArgKind(k1,k2)) =
	  textpar["missing","arguments","in","type","expression"]
      | ppError(RefTypKind k) =
	  textpar["missing","arguments","in","type","expression"]
      | ppError(PervasiveTypUnknown s) =
	  textpar["unknown","pervasive","type","\""^s^"\""]
      (* Rows *)
      | ppError(FldRowDuplicate l) =
	  textpar["duplicate","label",ppQuoted(ppLab l),"in","record"]
      | ppError(EllRowType t) =
	vbox(
	    textpar["non-record","type","at","ellipses:"] ^^
	    indent(PPType.ppTyp t)
	)
      (* Declarations *)
      | ppError(ValDecMismatch ue) =
	ppTypMismatch4(
	  textpar["expression","does","not","match","pattern","type:"],
	  textpar["does","not","match","type"], ue)
      | ppError(ValDecUnclosed t) =
	vbox(
	    textpar["unresolved","type","in","declaration:"] ^^
	    indent(PPType.ppTyp t)
	)
      | ppError(ValDecLift(x,l)) =
	  textpar["could not generalize","type","of",ppId x,
	      "due","to","value","restriction",
	      "although","it","contains","explicit","type","variables"]
      | ppError(RecValDecNonValue) =
	  textpar["recursive","declaration's","right-hand","side","is","not",
		  "a","value"]
      (* Modules *)
      | ppError(ModlongidInf(y,j)) =
	vbox(
	    textpar["module",ppLongid y,"is","not","a","structure,",
		    "it","has","signature"] ^^
	    indent(PPInf.ppInf j)
	)
      | ppError(StrModUnclosed lt) =
	ppUnclosed(
	  textpar["structure","is","not","closed:"], lt)
      | ppError(SelModInf j) =
	  textpar["module","expression","is","not","a","structure"]
      | ppError(AppModFunMismatch j) =
	  textpar["applied","module","is","not","a","functor"]
      | ppError(AppModArgMismatch im) =
	ppInfMismatch(
	  textpar["module","expression","does","not","match",
	      "functor","parameter","signature:"], im)
      | ppError(AnnModMismatch im) =
	ppInfMismatch(
	  textpar["module","expression","does","not","match","signature:"], im)
      | ppError(UnpackModMismatch ue) =
	ppTypMismatch2(
	  textpar["operand","of","`unpack'","is","not","a","package:"],
	  textpar["does","not","match","type"], ue)
      (* Interfaces *)
      | ppError(GroundInfKind k) =
	  textpar["missing","arguments","in","signature","expression"]
      | ppError(AppInfFunMismatch j) =
	  textpar["applied","signature","is","not","parameterised"]
      | ppError(AppInfArgMismatch im) =
	ppInfMismatch(
	  textpar["module","expression","does","not","match",
		  "signature","parameter:"], im)
      | ppError(InterInfMismatch im) =
	ppInfMismatch(
	  textpar["inconsistency","at","signature","specialization:"], im)
      | ppError(LetInfGenerative j) =
	vbox(
	    textpar["signature","contains","local","names:"] ^^
	    indent(PPInf.ppSig(Inf.asSig j))
	)
      | ppError(SingInfNonSing j) =
	  textpar["module","expression","is","not","a","valid","singleton"]
      | ppError(PervasiveInfUnknown s) =
	  textpar["unknown","pervasive","signature","\""^s^"\""]
      (* Imports *)
      | ppError(ImpMismatch im) =
	ppInfMismatch(
	  textpar["component","does","not","match","import,","because"], im)
      | ppError(ImplicitImpHiddenTyp(url,p)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\"")) ^/^
	    textpar["refers","to","inaccessible"] ^^
	    indent(text "type " ^^ PPPath.ppPath p)
	)
      | ppError(ImplicitImpHiddenMod(url,p)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\"")) ^/^
	    textpar["refers","to","inaccessible"] ^^
	    indent(text "structure " ^^ PPPath.ppPath p)
	)
      | ppError(ImplicitImpHiddenInf(url,p)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\"")) ^/^
	    textpar["refers","to","inaccessible"] ^^
	    indent(text "signature " ^^ PPPath.ppPath p)
	)
      | ppError(ImplicitImpHiddenTransTyp(url,p,viaUrl)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^^
	    indent(text("\"" ^ ppUrl viaUrl ^ "\"")) ^/^
	    textpar["refers","to","inaccessible"] ^^
	    indent(text "type " ^^ PPPath.ppPath p) ^/^
	    textpar["which","is","stemming","from","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\""))
	)
      | ppError(ImplicitImpHiddenTransMod(url,p,viaUrl)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^^
	    indent(text("\"" ^ ppUrl viaUrl ^ "\"")) ^/^
	    textpar["refers","to","inaccessible"] ^^
	    indent(text "structure " ^^ PPPath.ppPath p) ^/^
	    textpar["which","is","stemming","from","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\""))
	)
      | ppError(ImplicitImpHiddenTransInf(url,p,viaUrl)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^^
	    indent(text("\"" ^ ppUrl viaUrl ^ "\"")) ^/^
	    textpar["refers","to","inaccessible"] ^^
	    indent(text "signature " ^^ PPPath.ppPath p) ^/^
	    textpar["which","is","stemming","from","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\""))
	)
      | ppError(ImplicitImpInconsistent(url,p,viaUrl)) =
	vbox(
	    textpar["implicit","import","signature","for","component"] ^/^
	    indent(text("\"" ^ ppUrl viaUrl ^ "\"")) ^/^
	    textpar["refers","to"] ^^
	    indent(text "structure " ^^ PPPath.ppPath p) ^/^
	    textpar["which","is","stemming","from","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\"")) ^/^
	    textpar["but","is","no","longer","exported","by","it",
		    "(please","try","recompiling","the","former","component)"]
	)
      (* Exports *)
      | ppError(ExportUnclosed lt) =
	ppUnclosed(
	  textpar["component","signature","is","not","closed:"], lt)

    fun ppWarning(ValImpUnused l) =
	  textpar["imported","value",ppLab l,"is","not","used",
		  "and","has","been","dropped"]
      | ppWarning(TypImpUnused l) =
	  textpar["imported","type",ppLab l,"is","not","used",
		  "and","has","been","dropped"]
      | ppWarning(ModImpUnused l) =
	  textpar["imported","structure",ppLab l,"is","not","used",
		  "and","has","been","dropped"]
      | ppWarning(InfImpUnused l) =
	  textpar["imported","signature",ppLab l,"is","not","used",
		  "and","has","been","dropped"]
      | ppWarning(TypImpInserted(url,p,viaUrl)) =
	vbox(
	    textpar["inserting","import","for"] ^^
	    indent(text "type " ^^ PPPath.ppPath p) ^/^
	    textpar["from","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\"")) ^/^
	    textpar["referred","to","by","implicit","import","signature","for",
		    "component"] ^^
	    indent(text("\"" ^ ppUrl viaUrl ^ "\""))
	)
      | ppWarning(InfImpInserted(url,p,viaUrl)) =
	vbox(
	    textpar["inserting","import","for"] ^^
	    indent(text "signature " ^^ PPPath.ppPath p) ^/^
	    textpar["from","component"] ^^
	    indent(text("\"" ^ ppUrl url ^ "\"")) ^/^
	    textpar["referred","to","by","implicit","import","signature","for",
		    "component"] ^^
	    indent(text("\"" ^ ppUrl viaUrl ^ "\""))
	)
      (* Exports *)
      | ppWarning(ExportNotGeneralized(x,t)) =
	vbox(
	    textpar["type","of",ppId x,"cannot","be","generalized","due","to",
		"value","restriction:"] ^^
	    indent(PPType.ppTyp t)
	)
      | ppWarning(ExportHiddenTyp p) =
	vbox(
	    textpar["component","export","signature","refers","to",
		    "inaccessible","local"] ^^
	    indent(text "type " ^^ PPPath.ppPath p)
	)
      | ppWarning(ExportHiddenMod p) =
	vbox(
	    textpar["component","export","signature","refers","to",
		    "inaccessible","local"] ^^
	    indent(text "structure " ^^ PPPath.ppPath p)
	)
      | ppWarning(ExportHiddenInf p) =
	vbox(
	    textpar["component","export","signature","refers","to",
		    "inaccessible","local"] ^^
	    indent(text "signature " ^^ PPPath.ppPath p)
	)

  (* Export *)

    fun error(region, e)   = Error.error(region, ppError e)
    fun warn(b, region, w) = Error.warn(b, region, ppWarning w)

    (*UNFINISHED*)
    fun unfinished(region, funname, casename) =
	Error.warn(true, region, text("Elab." ^ funname ^ ": " ^ casename ^
				      " not checked yet"))
end
