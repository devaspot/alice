val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:37 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)




functor MkCodeGenContext(type value): CONTEXT =
    struct
	type t = value StampMap.t
	val empty = StampMap.map() : t
    end
