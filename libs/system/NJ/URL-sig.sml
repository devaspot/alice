val assert=General.assert;
(*
 * Authors:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2003
 *   Andreas Rossberg, 2000
 *
 * Last change:
 *   $Date: 2003-01-08 13:31:56 $ by $Author: kornstae $
 *   $Revision: 1.7 $
 *)

signature URL =
    sig
	eqtype url
	type t = url

	type scheme = string option
	type authority = string option
	type device = char option
	type path = string list
	type query = string option
	type fragment = string option

	exception Malformed
	exception NotLocal

	(* Constructing URLs *)

	val empty: url
	val setScheme: url * scheme -> url         (* Malformed *)
	val setAuthority: url * authority -> url   (* Malformed *)
	val setDevice: url * device -> url         (* Malformed *)
	val makeAbsolutePath: url -> url
	val makeRelativePath: url -> url
	val setPath: url * path -> url
	val setQuery: url * query -> url           (* Malformed *)
	val setFragment: url * fragment -> url

	(* Accessing URL Constituents *)

	val getScheme: url -> scheme
	val getAuthority: url -> authority
	val getDevice: url -> device
	val isAbsolutePath: url -> bool
	val getPath: url -> path
	val getQuery: url -> query
	val getFragment: url -> fragment

	(* Operations on URLs *)

	val fromString: string -> url              (* Malformed *)
	val toString: url -> string
	val toStringRaw: url -> string
	val toLocalFile: url -> string             (* NotLocal *)
	val isAbsolute: url -> bool
	val resolve: url -> url -> url
	val equal: url * url -> bool
	val compare: url * url -> order
	val hash: url -> int
    end
