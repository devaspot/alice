val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2002-08-21 14:02:48 $ by $Author: rossberg $
 *   $Revision: 1.18 $
 *)

(*
Invariants of type annotations:
- exp and pat nodes carry their instantiated type.
- id and longid nodes carry their generalized type.
  Ie. for every (long)id embedded into an exp or pat
  node the type annotating the id must be more general than the
  type annotating the exp/pat (exp and pat types may still be
  quantified).
*)









structure IntermediateInfo =
struct
    datatype origin	= Val | Mod | Typ | Inf | Aux

    type lab_info	= { region: Source.region }
    type id_info	= { region: Source.region, typ: Type.t }
    type longid_info	= { region: Source.region, typ: Type.t }
    type exp_info	= { region: Source.region, typ: Type.t }
    type pat_info	= { region: Source.region, typ: Type.t }
    type 'a fld_info	= { region: Source.region }
    type mat_info	= { region: Source.region }
    type dec_info	= { region: Source.region, origin: origin }

    fun origInfo(r,or)	= { region = r, origin = or }
end

structure IntermediateGrammar = MkIntermediateGrammar(
	open IntermediateInfo
	type sign = Inf.t)

structure PPIntermediateGrammar = MkPPIntermediateGrammar(
	structure IntermediateGrammar = IntermediateGrammar
	fun ppInfo _	= PrettyPrint.empty
	val ppLabInfo	= ppInfo
	val ppIdInfo	= ppInfo
	val ppLongidInfo = ppInfo
	val ppExpInfo	= ppInfo
	val ppPatInfo	= ppInfo
	val ppFldInfo	= fn _ => ppInfo
	val ppMatInfo	= ppInfo
	val ppDecInfo	= ppInfo
	val ppSig	= ppInfo)
