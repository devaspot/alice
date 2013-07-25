val assert=General.assert;
(*
 * Author:
 *   Guido Tack <tack@ps.uni-sb.de>
 *
 * Copyright:
 *   Guido Tack, 2003
 *
 * Last change:
 *   $Date: 2003-06-11 11:37:02 $ by $Author: tack $
 *   $Revision: 1.1 $
 *)




signature WORD8_BUFFER =
    sig
	type t
	val output1 : t * Word8.word -> unit
	val buffer : unit -> t
	val getVector : t -> Word8Vector.vector
	val bufferSize : t -> int
    end
