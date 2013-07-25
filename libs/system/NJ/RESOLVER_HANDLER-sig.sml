val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002-2003
 *
 * Last change:
 *   $Date: 2003-01-08 13:30:40 $ by $Author: kornstae $
 *   $Revision: 1.5 $
 *)



signature RESOLVER_HANDLER =
    sig
	type handler
	type t = handler

	exception Syntax

	val default: handler
	val root: Url.t -> handler
	val cache: Url.t -> handler
	val prefix: string * string -> handler
	val pattern: string * string -> handler    (* Syntax *)
	val custom: string * (Url.t -> Url.t option) -> handler

	val parse: string -> handler list          (* Syntax *)

	val apply: Url.t -> handler list -> (Url.t * handler list) option
	val tracingApply: (string -> unit) -> Url.t -> handler list ->
			  (Url.t * handler list) option
    end
