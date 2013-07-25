val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-09-09 19:23:44 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)



signature INF_LIB =
sig
    val modlab_inf :		Label.t
    val typlab_mod :		Label.t
    val typlab_sig :		Label.t
    val typlab_inf :		Label.t
    val typlab_kind :		Label.t
    val typlab_rea :		Label.t

    val lab_emptySig :		Label.t
    val lab_extendFix :		Label.t
    val lab_extendVal :		Label.t
    val lab_extendTyp :		Label.t
    val lab_extendMod :		Label.t
    val lab_extendInf :		Label.t

    val lab_lookupFix :		Label.t
    val lab_lookupVal :		Label.t
    val lab_lookupTyp :		Label.t
    val lab_lookupMod :		Label.t
    val lab_lookupInf :		Label.t
    val lab_lookupTyp' :	Label.t
    val lab_lookupMod' :	Label.t
    val lab_lookupInf' :	Label.t

    val lab_mod :		Label.t
    val lab_asMod :		Label.t

    val lab_top :		Label.t
    val lab_con :		Label.t
    val lab_sig :		Label.t
    val lab_sing :		Label.t
    val lab_arrow :		Label.t
    val lab_lambda :		Label.t
    val lab_apply :		Label.t

    val lab_asCon :		Label.t
    val lab_asSig :		Label.t
    val lab_asArrow :		Label.t
    val lab_asSing :		Label.t
    val lab_asLambda :		Label.t
    val lab_asApply :		Label.t

    val lab_groundKind :	Label.t
    val lab_depKind :		Label.t
    val lab_singKind :		Label.t

    val lab_kind :		Label.t
    val lab_instance :		Label.t
    val lab_realise :		Label.t
    val lab_match :		Label.t
    val lab_infimum :		Label.t
    val lab_mismatch :		Label.t
end
