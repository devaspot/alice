val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2001
 *
 * Last change:
 *   $Date: 2001-04-04 15:49:03 $ by $Author: rossberg $
 *   $Revision: 1.35 $
 *)





signature BATCH_COMPILER =
    sig
	val main : string list -> OS.Process.status
    end
