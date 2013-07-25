val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2001
 *
 * Last change:
 *   $Date: 2004-05-07 15:09:16 $ by $Author: rossberg $
 *   $Revision: 1.36 $
 *)











signature SIMPLIFY_MATCH =
    sig
	structure I: INTERMEDIATE_GRAMMAR = IntermediateGrammar
	structure O: FLAT_GRAMMAR = FlatGrammar

	datatype selector =
	    LABEL of Label.t
	  | LONGID of Stamp.t * Label.t list
	  | REF of Stamp.t
	type pos = selector list

	datatype test =
	    LitTest of I.lit
	  | TagTest of Label.t vector * int * unit O.args * Arity.t
	  | ConTest of I.longid * unit O.args * Arity.t
	  | RefTest of Stamp.t
	  | TupTest of int
	  | ProdTest of Label.t vector
	    (* sorted, all labels distinct, no tuple *)
	  | VecTest of int
	  | GuardTest of Stamp.t * mapping * I.exp
	  | DecTest of Stamp.t * mapping * I.dec vector
	withtype mapping = (pos * I.id) list

	val longidToSelector: I.longid -> selector

	structure PosMap: MAP where type key = pos
	type testMap = test list PosMap.t

	datatype testGraph =
	    Node of pos * test * testGraph ref * testGraph ref * nodeStatus ref
	  | Leaf of O.body * O.body option ref
	  | Fail
	  | Default
	  | Unreachable of testGraph
	and nodeStatus =
	    Initial
	  | Raw of testGraph list * testGraph list
	  | Cooked of {thenTrue: testMap, thenFalse: testMap,
		       elseTrue: testMap, elseFalse: testMap}
	  | Translated of O.body

	type consequent = Source.region * O.body option ref
	type mapping' = (pos * O.idRef) list

	val buildGraph: Source.region *
			(Source.region * I.pat * O.body) vector *
			O.body * bool -> testGraph * consequent list

	val buildFunArgs: Source.region *
			(Source.region * I.pat * O.body) vector * O.body ->
			O.idDef O.args * testGraph * mapping' * consequent list
    end
