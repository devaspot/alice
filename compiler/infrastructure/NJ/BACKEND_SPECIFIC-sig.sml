val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002
 *
 * Last change:
 *   $Date: 2004-05-07 15:14:36 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)






signature BACKEND_SPECIFIC =
sig
    (*--** include PHASE where O : TARGET *)
    structure C: CONTEXT
    structure I: REPRESENTATION
    structure O: TARGET

    val translate: Source.desc * C.t * I.t -> C.t * O.t   (* [Error.Error] *)
    val isCross: bool
end
