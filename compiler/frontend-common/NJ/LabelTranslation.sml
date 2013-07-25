val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2004
 *
 * Last change:
 *   $Date: 2004-04-11 19:33:54 $ by $Author: rossberg $
 *   $Revision: 1.4 $
 *)





structure LabelTranslation : LABEL_TRANSLATION =
struct
    open NameTranslation

    fun trValLabel lab = Label.fromName(trValName(Label.toName lab))
    fun trTypLabel lab = Label.fromName(trTypName(Label.toName lab))
    fun trModLabel lab = Label.fromName(trModName(Label.toName lab))
    fun trInfLabel lab = Label.fromName(trInfName(Label.toName lab))
end
