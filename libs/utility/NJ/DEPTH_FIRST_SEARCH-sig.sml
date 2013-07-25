val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000
 *
 * Last change:
 *   $Date: 2003-05-07 12:09:00 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)





signature DEPTH_FIRST_SEARCH =
    sig
	structure Map: IMP_MAP

	val search: Map.key list Map.t -> Map.key list list
    end
