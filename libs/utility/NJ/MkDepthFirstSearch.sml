val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *
 * Last change:
 *   $Date: 2004-02-03 09:50:48 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)

(*
 * An implementation of Tarjan's Depth-First Search algorithm.
 * Takes a map describing a directed graph as input,
 * returns a topological ordering of all strongly connected components.
 *)





functor MkDepthFirstSearch
    (structure Key: HASHABLE
     structure Map: IMP_MAP where type key = Key.t): DEPTH_FIRST_SEARCH =
    struct
	structure Map = Map

	type state =
	     {currentId: int ref,
	      stack: Key.t list ref,
	      done: int Map.t,
	      sorted: Key.t list list ref,
	      maxId: int}

	fun newState maxId: state =
	    {currentId = ref 0,
	     stack = ref nil,
	     done = Map.map (),
	     sorted = ref nil,
	     maxId = maxId}

	fun getCycle (key::keyr, key', state: state) =
	    (Map.insert (#done state, key, #maxId state);
	     if Key.equal (key, key') then (#stack state := keyr; [key])
	     else key::getCycle (keyr, key', state))
	  | getCycle (nil, _, _) = assert false

	fun visit (map, key, state as {currentId, stack, done, sorted, ...}) =
	    let
		val id = !currentId
		val _ = Map.insertDisjoint (done, key, id)
		val _ = currentId := id + 1
		val _ = stack := key::(!stack)
		val minId =
		    List.foldl
		    (fn (key', minId) =>
		     Int.min (case Map.lookup (done, key') of
				  SOME id => id
				| NONE => visit (map, key', state), minId))
		    id (Map.lookupExistent (map, key))
	    in
		if minId = id then
		    (Map.insert (done, key, Map.size map);
		     sorted := getCycle (!stack, key, state)::(!sorted))
		else ();
		minId
	    end

	fun search map =
	    let
		val state as {done, sorted, ...} = newState (Map.size map)
	    in
		Map.appi (fn (key, _) =>
			  if Map.member (done, key) then ()
			  else ignore (visit (map, key, state))) map;
		!sorted
	    end
    end
