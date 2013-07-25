val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2007
 *
 * Last change:
 *   $Date: 2007-02-18 12:56:00 $ by $Author: rossberg $
 *   $Revision: 1.9 $
 *)



signature TYPE_LIB =
sig
    val modlab_type :		Label.t
    val typlab_kind :		Label.t
    val typlab_typ :		Label.t
    val typlab_var :		Label.t
    val typlab_row :		Label.t
    val typlab_constraint :	Label.t

    val lab_unconstrained :	Label.t
    val lab_intensional :	Label.t
    val lab_extensional :	Label.t

    val lab_starKind :		Label.t
    val lab_extKind :		Label.t
    val lab_singKind :		Label.t
    val lab_eqKind :		Label.t
    val lab_arrowKind :		Label.t

    val lab_unknown :		Label.t
    val lab_var :		Label.t
    val lab_con :		Label.t
    val lab_arrow :		Label.t
    val lab_tuple :		Label.t
    val lab_prod :		Label.t
    val lab_sum :		Label.t
    val lab_all :		Label.t
    val lab_exist :		Label.t
    val lab_lambda :		Label.t
    val lab_apply :		Label.t
    val lab_abbrev :		Label.t

    val lab_newVar :		Label.t
    val lab_kind :		Label.t

    val lab_unknownRow :	Label.t
    val lab_emptyRow :		Label.t
    val lab_extendRow :		Label.t

    val lab_fix :		Label.t

    val lab_asProd :		Label.t
end
