val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2001
 *
 * Last change:
 *   $Date: 2005-03-04 10:35:09 $ by $Author: rossberg $
 *   $Revision: 1.7 $
 *)






structure Target =
struct
    datatype t =
	COMPONENT of {component: unit -> Component.t,
		      eval: Url.t -> Package.t}
      | FOREIGN of {inf: Inf.t,
		    save: string -> unit}
end
