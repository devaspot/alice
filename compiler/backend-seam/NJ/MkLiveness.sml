val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002-2003
 *
 * Last change:
 *   $Date: 2004-04-08 09:00:17 $ by $Author: bruni $
 *   $Revision: 1.11 $
 *)






functor MkLiveness(AbstractCodeGrammar: ABSTRACT_CODE_GRAMMAR): LIVENESS =
    struct
	structure AbstractCodeGrammar = AbstractCodeGrammar

	open AbstractCodeGrammar

	fun compareInterval ((id, min, max), (id', min', max')) =
	    case Int.compare (min, min') of
		EQUAL => Int.compare (id, id')
	      | order => order

	fun analyze (idDefs, instr) =
	    let
		val ranges = IntMap.map ()
		val shared = StampSet.set ()

		fun lId (id, i) =
		    (case IntMap.lookup (ranges, id) of
			 NONE => IntMap.insertDisjoint (ranges, id, (i, i))
		       | SOME (min, max) =>
			     IntMap.insert (ranges, id,
					    (if i < min then i else min,
					     if i > max then i else max)); i)
		fun lIds (ids, i) = Vector.foldl lId i ids

		fun lIdDef (IdDef id, i) = lId (id, i)
		  | lIdDef (Wildcard, i) = i
		fun lIdDefs (idDefs, i) = Vector.foldl lIdDef i idDefs
		fun lIdDefsOpt (SOME idDefs, i) = lIdDefs (idDefs, i)
		  | lIdDefsOpt (NONE, i) = i

		fun lIdRef ((Local id | LastUseLocal id), i) = lId (id, i)
		  | lIdRef (_, i) = i
		fun lIdRefs (idRefs, i) = Vector.foldl lIdRef i idRefs

		fun lEntryPoint (ConEntry (_, idRef, idRefs), i) =
		    lIdRef (idRef, lIdRefs (idRefs, i))
		  | lEntryPoint (SelEntry (_, _, idRef), i) =
		    lIdRef (idRef, i)
		  | lEntryPoint (StrictEntry (_, idRef), i) =
		    lIdRef (idRef, i)
		  | lEntryPoint (AppEntry (_, idRef, idRefs), i) =
		    lIdRef (idRef, lIdRefs (idRefs, i))
		  | lEntryPoint (CondEntry (_, idRef), i) =
		    lIdRef (idRef, i)
		  | lEntryPoint (RaiseEntry idRef, i) =
		    lIdRef (idRef, i)
		  | lEntryPoint (HandleEntry idRef, i) =
		    lIdRef (idRef, i)
		  | lEntryPoint (SpawnEntry, i) = i

 		(*
 		 * lInstr enumerates program points important for liveness
 		 * analysis, determining between which range of program points
 		 * each identifier is live.  If two identifiers are live at
 		 * the same program point, then they may not be assigned the
 		 * same register.  Program points are numbered from last
 		 * instruction to first instruction.
 		 *)
 
 		fun lInstr (Kill (_, instr), i) =
 		    (* no program points *)
 		    lInstr (instr, i)
		  | lInstr (Entry (_, entryPoint, instr), i) =
		    lEntryPoint (entryPoint, lInstr (instr, i) + 1)
		  | lInstr (Exit (_, _, idRef, instr), i) =
		    lIdRef (idRef, lInstr (instr, i) + 1)
		  | lInstr (PutVar (id, idRef, instr), i) =
		    (* two program points: id and idRef may be same register *)
		    lIdRef (idRef, lId (id, lInstr (instr, i) + 1) + 1)
		  | lInstr (PutNew (id, _, instr), i) =
		    lId (id, lInstr (instr, i) + 1)
		  | lInstr (PutTag (id, _, _, idRefs, instr), i) =
		    (* two program points: first a node is allocated and
		     * initialized in a temporary, then it is moved to id *)
		    lId (id, lIdRefs (idRefs, lInstr (instr, i) + 1) + 1)
		  | lInstr (PutCon (id, idRef, idRefs, instr), i) =
		    (* same as PutTag *)
		    lId (id, lIdRef (idRef,
				     lIdRefs (idRefs,
					      lInstr (instr, i) + 1)) + 1)
		  | lInstr (PutRef (id, idRef, instr), i) =
		    (* same as PutTag *)
		    lId (id, lIdRef (idRef, lInstr (instr, i) + 1) + 1)
		  | lInstr (PutTup (id, idRefs, instr), i) =
		    (* same as PutTag *)
		    lId (id, lIdRefs (idRefs, lInstr (instr, i) + 1) + 1)
		  | lInstr (PutPolyRec (id, _, idRefs, instr), i) =
		    (* same as PutTag *)
		    lId (id, lIdRefs (idRefs, lInstr (instr, i) + 1) + 1)
		  | lInstr (PutVec (id, idRefs, instr), i) =
 		    (* same as PutTag *)
 		    lId (id, lIdRefs (idRefs, lInstr (instr, i) + 1) + 1)
  		  | lInstr (Close (id, idRefs, _, instr), i) =
 		    (* same as PutTag *)
 		    lId (id, lIdRefs (idRefs, lInstr (instr, i) + 1) + 1)
  		  | lInstr (Specialize (id, idRefs, _, instr), i) =
 		    (* same as PutTag *)
 		    lId (id, lIdRefs (idRefs, lInstr (instr, i) + 1) + 1)
  		  | lInstr (AppPrim (_, idRefs, SOME (idDef, instr)), i) =
 		    (* two program points: first arguments are loaded and
 		     * the primitive is applied, then the result is stored *)
 		    lIdRefs (idRefs, lIdDef (idDef, lInstr (instr, i) + 1) + 1)
  		  | lInstr (AppPrim (_, idRefs, NONE), i) =
 		    lIdRefs (idRefs, i + 1)
 		  | lInstr (AppVar (idRef, idRefs, _,
 				    SOME (idDefs, instr)), i) =
 		    (* same as AppPrim *)
  		    let
 			val i = lIdDefs (idDefs, lInstr (instr, i) + 1)
  		    in
 			lIdRef (idRef, lIdRefs (idRefs, i + 1))
  		    end
 		  | lInstr (AppVar (idRef, idRefs, _, NONE), i) =
 		    lIdRef (idRef, lIdRefs (idRefs, i + 1))
  		  | lInstr (GetRef (id, idRef, instr), i) =
 		    (* two program points: first the selection is done into
 		     * a temporary, then the temporary is moved to id *)
 		    lIdRef (idRef, lId (id, lInstr (instr, i) + 1) + 1)
  		  | lInstr (GetTup (idDefs, idRef, instr), i) =
 		    (* one program point: idRef is still needed until all
 		     * selections are performed, no order is fixed *)
  		    lIdDefs (idDefs, lIdRef (idRef, lInstr (instr, i) + 1))
  		  | lInstr (Sel (id, idRef, _, instr), i) =
 		    (* two program points: first the tuple is selected into
 		     * a temporary, then the temporary is moved to id *)
 		    lIdRef (idRef, lId (id, lInstr (instr, i) + 1) + 1)
  		  | lInstr (LazyPolySel (ids, idRef, _, instr), i) =
 		    (* two program points: first the record is moved into
 		     * a temporary, then the selections are performed *)
 		    lIds (ids, lIdRef (idRef, lInstr (instr, i) + 1) + 1)
 		  | lInstr (Raise idRef, i) = lIdRef (idRef, i + 1)
 		  | lInstr (Reraise idRef, i) = lIdRef (idRef, i + 1)
  		  | lInstr (Try (tryInstr, idDef1, idDef2, handleInstr), i) =
  		    let
 			val i = lInstr (handleInstr, i) + 1
  			val i = lIdDef (idDef1, lIdDef (idDef2, i))
  		    in
 			lInstr (tryInstr, i)
  		    end
 		  | lInstr (EndTry instr, i) = lInstr (instr, i)
 		  | lInstr (EndHandle instr, i) = lInstr (instr, i)
  		  | lInstr (IntTest (idRef, tests, elseInstr), i) =
 		    (* one program point: patterns bind no identifiers *)
  		    lIdRef (idRef,
  			    Vector.foldr (fn ((_, thenInstr), i) =>
  					     lInstr (thenInstr, i))
  					 (lInstr (elseInstr, i)) tests + 1)
  		  | lInstr (CompactIntTest (idRef, _, tests, elseInstr), i) =
 		    (* one program point: patterns bind no identifiers *)
  		    lIdRef (idRef,
  			    Vector.foldr lInstr (lInstr (elseInstr, i))
  					 tests + 1)
  		  | lInstr (RealTest (idRef, tests, elseInstr), i) =
 		    (* one program point: patterns bind no identifiers *)
  		    lIdRef (idRef,
  			    Vector.foldr (fn ((_, thenInstr), i) =>
  					     lInstr (thenInstr, i))
  					 (lInstr (elseInstr, i)) tests + 1)
  		  | lInstr (StringTest (idRef, tests, elseInstr), i) =
 		    (* one program point: patterns bind no identifiers *)
  		    lIdRef (idRef,
  			    Vector.foldr (fn ((_, thenInstr), i) =>
  					     lInstr (thenInstr, i))
					 (lInstr (elseInstr, i)) tests + 1)
		  | lInstr (TagTest (idRef, _, nullaryTests, naryTests,
				     elseInstr), i) =
		    let
			val i =
			    Vector.foldr
				(fn ((_, idDefs, thenInstr), i) =>
				    (* one program point per bound identifiers.
				     * idRef has been moved into a temporary;
				     * its register may be reused. *)
				    lIdDefs (idDefs,
					     lInstr (thenInstr, i) + 1))
				(lInstr (elseInstr, i)) naryTests
			val i =
			    Vector.foldr
				(fn ((_, thenInstr), i) =>
				    lInstr (thenInstr, i)) i nullaryTests
		    in
			lIdRef (idRef, i + 1)
		    end
		  | lInstr (CompactTagTest (idRef, _, tests, elseInstrOpt), i) =
		    (* same as TagTest *)
		    lIdRef (idRef,
			    Vector.foldr
				(fn ((SOME idDefs, thenInstr), i) =>
				    lIdDefs (idDefs, lInstr (thenInstr, i) + 1)
				  | ((NONE, thenInstr), i) =>
				    lInstr (thenInstr, i))
				(case elseInstrOpt of
				     SOME elseInstr =>
					 lInstr (elseInstr, i)
				   | NONE => i) tests + 1)
		  | lInstr (ConTest (idRef, nullaryTests, naryTests,
				     elseInstr), i) =
		    let
			val i =
			    Vector.foldr
				(fn ((_, idDefs, thenInstr), i) =>
				    (* same as in TagTest *)
				    lIdDefs (idDefs,
					     lInstr (thenInstr, i) + 1))
				(lInstr (elseInstr, i)) naryTests
			val i =
			    Vector.foldr
				(fn ((idRef, thenInstr), i) =>
				    lInstr (thenInstr, i))
				i nullaryTests + 1
		    in
			(* the constructor idRefs are only needed to perform
			 * the dispatch and need not be kept live thereafter *)
			Vector.app (fn (idRef', _, _) =>
				       ignore (lIdRef (idRef', i)))
				   naryTests;
			Vector.app (fn (idRef', _) =>
				       ignore (lIdRef (idRef', i)))
				   nullaryTests;
			lIdRef (idRef, i)
		    end
		  | lInstr (VecTest (idRef, tests, elseInstr), i) =
		    (* same as TagTest *)
		    lIdRef (idRef,
			    Vector.foldr
				(fn ((#[], thenInstr), i) =>
				    lInstr (thenInstr, i)
				  | ((idDefs, thenInstr), i) =>
				    lIdDefs (idDefs,
					     lInstr (thenInstr, i) + 1))
				(lInstr (elseInstr, i)) tests + 1)
		  | lInstr (Shared (stamp, instr), i) =
		    (* no program points: no identifier occurrences *)
		    if StampSet.member (shared, stamp) then i
		    else
			(StampSet.insert (shared, stamp);
			 lInstr (instr, i))
		  | lInstr (Return idRefs, i) =
		    lIdRefs (idRefs, i + 1)

		val n = lIdDefs (idDefs, lInstr (instr, 0))

		val intervals =
		    List.sort compareInterval
			      (IntMap.foldi
				   (fn (id, (min, max), rest) =>
				       (id, n - max, n - min)::rest)
				   nil ranges)
	    in
(*
		List.app (fn (id, min, max) =>
			     (TextIO.print ("id " ^ Int.toString id ^ " -> [" ^
					    Int.toString min ^ ", " ^
					    Int.toString max ^ "]\n")))
			 intervals;
*)
		Vector.fromList (List.foldr (fn ((id, min, max), rest) =>
						id::min::max::rest)
					    nil intervals)
	    end
    end
