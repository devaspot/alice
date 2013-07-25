val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-04-02 14:43:48 $ by $Author: rossberg $
 *   $Revision: 1.17 $
 *)

(*
Invariants of the typed grammar:
- every node is annotated with its type.
- exp and pat nodes carry their instantiated type.
- typ nodes carry their type function.
- mod nodes carry their interface.
- inf nodes carry their interface function.
- similarly for id and longid nodes, with the exception that
  valid and vallongid nodes carry the generalized type.
  Ie. for every val(long)id embedded into an exp or pat
  node the type annotating the id must be more general than the
  type annotating the exp/pat (exp and pat types may still be
  quantified in the case of higher-order quantification).
*)








structure TypedInfo =
struct
    type fix_info	= { region: Source.region, fix: Fixity.t }
    type vallab_info	= { region: Source.region }
    type typlab_info	= { region: Source.region }
    type modlab_info	= { region: Source.region }
    type inflab_info	= { region: Source.region }
    type valid_info	= { region: Source.region, typ: Type.t }
    type typid_info	= { region: Source.region, typ: Type.t }
    type varid_info	= { region: Source.region, var: Type.var }
    type modid_info	= { region: Source.region, inf: Inf.t  }
    type infid_info	= { region: Source.region, inf: Inf.t  }
    type vallongid_info	= { region: Source.region, typ: Type.t }
    type typlongid_info	= { region: Source.region, typ: Type.t }
    type modlongid_info	= { region: Source.region, inf: Inf.t  }
    type inflongid_info	= { region: Source.region, inf: Inf.t  }
    type exp_info	= { region: Source.region, typ: Type.t }
    type pat_info	= { region: Source.region, typ: Type.t }
    type 'a row_info	= { region: Source.region }
    type 'a fld_info	= { region: Source.region }
    type mat_info	= { region: Source.region }
    type typ_info	= { region: Source.region, typ: Type.t }
    type mod_info	= { region: Source.region, inf: Inf.t }
    type inf_info	= { region: Source.region, inf: Inf.t }
    type dec_info	= { region: Source.region }
    type spec_info	= { region: Source.region }
    type imp_info	= { region: Source.region }
    type ann_info	= { region: Source.region, sign: Inf.sign }
    type com_info	= { region: Source.region, sign: Inf.sign }

    fun nonInfo r	= { region = r }
    fun fixInfo(r,f)	= { region = r, fix = f }
    fun typInfo(r,t)	= { region = r, typ = t }
    fun varInfo(r,a)	= { region = r, var = a }
    fun infInfo(r,j)	= { region = r, inf = j }
    fun sigInfo(r,s)	= { region = r, sign = s }
end

structure TypedGrammar = MkAbstractGrammar(TypedInfo)
