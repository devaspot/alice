val assert=General.assert;
(*
 * Authors:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2001
 *   Andreas Rossberg, 2000-2005
 *
 * Last change:
 *   $Date: 2005-03-04 10:35:09 $ by $Author: rossberg $
 *   $Revision: 1.13 $
 *)





signature TARGET =
sig
    datatype t =
	COMPONENT of {component: unit -> Component.t,
		      eval: Url.t -> Package.t}
      | FOREIGN of {inf: Inf.t,
		    save: string -> unit}
end
