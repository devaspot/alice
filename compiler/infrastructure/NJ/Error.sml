val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2005
 *
 * Last change:
 *   $Date: 2005-08-03 14:37:49 $ by $Author: rossberg $
 *   $Revision: 1.22 $
 *)

(* Error handling. *)








structure Error :> ERROR =
struct
    open PrettyPrint
    infixr ^^ ^/^

    (* Import *)

    type region = Source.region

    (* Export *)

    exception Error of region * doc

    val outWidth  = ref 79
    val outstream = TextIO.mkOutstream (TextIO.getOutstream TextIO.stdErr)
    fun setOutWidth n   = outWidth := n
    fun setOutstream os = TextIO.setOutstream (outstream, os)

    val currentUrl : Url.t option ref = ref NONE
    fun setCurrentUrl uo = currentUrl := uo

    fun resolveWrtCwd url =
	let
	    val base = Url.setScheme(Url.fromString(OS.FileSys.getDir() ^ "/"),
				     SOME "file")
	in
	    Url.resolve base url
	end

    fun urlToString url =
	case (Url.getScheme url, Url.getAuthority url) of
	    ((NONE | SOME "file"), NONE) =>
	    let
		val cwd  = OS.FileSys.getDir()
		val file = Url.toLocalFile url
		val file' = if OS.Path.getVolume file = ""
			    then OS.Path.getVolume cwd ^ file else file
		val file'' = OS.Path.mkCanonical file'
		val path1 = OS.Path.fromString file''
		val path2 = OS.Path.fromString cwd
		val disjointPaths = #isAbs path1 andalso #isAbs path2 andalso
				    case (#arcs path1, #arcs path2)
				     of (d1::_, d2::_) => d1 <> d2
				      | _ => false
	    in
		if disjointPaths
		then file'
		else OS.Path.mkRelative{path = file'', relativeTo = cwd}
		     handle OS.Path.Path => file'
	    end
	  | _ =>
	    Url.toStringRaw url

    fun print(reg, doc) =
	output(outstream,
	       fbox(
		   (case !currentUrl of NONE   => empty
			| SOME f => text(urlToString f) ^^ text ":") ^^
		   text(Source.regionToString reg) ^^ text ":" ^^ break
		) ^^ doc ^^ break, !outWidth)

    fun error(reg, message)   = ( print(reg,message) ; raise Error(reg,message) )
    fun warn(b, reg, message) = if not b then () else
				print(reg, fbox(text "warning:" ^^ break) ^^
					   message)

    (*UNFINISHED: provisory*)
    fun error'(reg, s)   = error(reg, text s)
    fun warn'(b, reg, s) = warn(b, reg, text s)
    fun unfinished(region, phasename, casename) =
	error(region, text(phasename ^ ": "^ casename ^ " not implemented yet"))
end
