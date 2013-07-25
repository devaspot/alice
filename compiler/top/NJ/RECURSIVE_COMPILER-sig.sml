val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2001-2002
 *
 * Last change:
 *   $Date: 2005-03-04 10:35:16 $ by $Author: rossberg $
 *   $Revision: 1.19 $
 *)











signature RECURSIVE_COMPILER =
    sig
	structure Switches: SWITCHES
	structure Context: CONTEXT
	val isCrossCompiler: bool

	exception Error
	exception Crash of string

	val extension: string

	datatype target =
	    COMPONENT of {component: unit -> Component.t,
			  eval: Url.t -> Package.t}
	  | FOREIGN   of {inf: Inf.t,
			  save: string -> unit}

	val compileFileToFile: string * string -> unit     (* IO.Io *)
	val acquireSig: Source.desc * Url.t -> Inf.sign
	val acquireMod: Source.desc * Url.t -> Reflect.module
	val acquireImports: Source.desc * Url.t -> (Url.t * Inf.sign) vector

	val compileFile: Context.t * string -> Context.t * target
	val compileString: Context.t * string -> Context.t * target

	(*DEBUG*)
	val processFile: (Source.desc * string -> 'a) -> string * string option -> 'a
	val processString: (Source.desc * string -> 'a) -> string -> 'a
    end

signature RECURSIVE_COMPILER' =
    sig
	structure Switches: SWITCHES
	structure Context: CONTEXT

	exception Error
	exception Crash of string

	datatype target =
	    COMPONENT of {component: unit -> Component.t,
			  eval: Url.t -> Package.t}
	  | FOREIGN   of {inf: Inf.t,
			  save: string -> unit}

	val isCrossCompiler: bool
	val compileFileToFile: string * string -> unit
	val compileFile: Context.t * string -> Context.t * target
	val compileString: Context.t * string -> Context.t * target
    end
