val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2002
 *
 * Last change:
 *   $Date: 2005-07-26 18:39:21 $ by $Author: rossberg $
 *   $Revision: 1.8 $
 *)




signature RESOLVER =
    sig
	structure Handler: RESOLVER_HANDLER

	type resolver
	type t = resolver

	datatype result =
	    FILE of string
	  | STRING of string
	  | DELEGATE of Url.t

	val resolver: {name: string, handlers: Handler.t list,
		       memoize: bool} -> resolver
	val localize: resolver -> Url.t -> result option
    end
