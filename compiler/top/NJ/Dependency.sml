val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2003
 *
 * Last change:
 *   $Date: 2007-02-12 16:20:27 $ by $Author: rossberg $
 *   $Revision: 1.5 $
 *)

(*
 * The format of dependency files resembles (a subset of) makefile syntax:
 *
 * dep-file ::= {dep-line}*
 * dep-line ::= \n
 *           |  file-name : {file-name}* \n
 *
 * File names are arbitrary sequences of non-whitespace characters,
 * excluding "#". They are separated by white space. White space
 * between the first file name and the colon is optional (this implies
 * that the first file name after the colon cannot be ":" if the white
 * space is omitted).
 * A backslash at the end of a line escapes the subsequent newline,
 * turning it into ordinary white space.
 * "#" starts a comment, stretching until the end of the line. Comments
 * are ignored completely (including contained backslashes).
 *)






structure Dependency :> DEPENDENCY =
struct
    structure Map = MkRedBlackMap(String)

    type dependency = string list Map.t
    type t = dependency

    exception Format

    val empty = Map.empty

    fun lookup(d,f) = Option.getOpt(Map.lookup(d,f), [])

    fun isLineSpace c		= c = #" " orelse c = #"\t"
    fun isLineBreak c		= Char.isSpace c andalso not(isLineSpace c)
    fun isNotTokenTerminator c	= not(Char.isSpace c) andalso c <> #"\\"
						      andalso c <> #"#"

    fun parseComment s =
	Substring.dropl (not o isLineBreak) (Substring.triml 1 s)

    fun parseTokenFragments(s, ss) =
	let
	    val (s1,s2) = Substring.splitl isNotTokenTerminator s
	in
	    if Substring.isEmpty s2 then
		(Substring.span(ss,s1), s2, false)
	    else if Substring.sub(s2,0) = #"#" then
		(Substring.span(ss,s1), parseComment s2, false)
	    else if Substring.sub(s2,0) <> #"\\" then
		(Substring.span(ss,s1), s2, false)
	    else if Substring.size s2 = 1
	    orelse isLineSpace(Substring.sub(s2,1)) then
		let val (s3,s4) = Substring.splitAt(s2,1) in
		    (Substring.span(ss,s3), s4, false)
		end
	    else if isLineBreak(Substring.sub(s2,1)) then
		(Substring.span(ss,s1), Substring.triml 2 s2, true)
	    else
		let val (s3,s4) = Substring.splitAt(s2,2) in
		    parseTokenFragments(s4, Substring.span(ss,s3))
		end
	end

    fun parseToken s =
	let
	    val  s'        = Substring.dropl isLineSpace s
	    val  ss0       = Substring.slice(s', 0, SOME 0)
	    val (ss,s'',b) = parseTokenFragments(s', ss0)
	in
	    if Substring.isEmpty ss andalso b
	    then parseToken s''
	    else (Substring.string ss, s'')
	end

    fun parseHeadToken s =
	case parseToken s
	 of ("", _) => raise Format
	  | (f, s') =>
	    let
		val (colon, s'') = parseToken s'
	    in
		if colon = ":" then (f, s'')
		else if String.sub(f, String.size f-1) = #":" then
		    (String.substring(f, 0, String.size f-1), s')
		else raise Format
	    end

    fun parseTokens(s, fs) =
	case parseToken s
	 of ("", s') => (fs,s')
	  | (f,  s') => parseTokens(s', f::fs)

    val cwd = OS.FileSys.getDir()

    fun normalize root path =
	OS.Path.base(OS.Path.mkAbsolute{path = path, relativeTo = root})

    fun parseLine(s, d, path) =
	let
	    val (f,s')   = parseHeadToken s
	    val (fs,s'') = parseTokens(s', nil)
	    val  f'      = normalize path f
	    val  fs'     = List.map (normalize path) fs
	in
	    (s'', Map.insertWith op@ (d, f', fs'), path)
	end

    fun parseFile(s, d, path) =
	let
	    val s' = Substring.dropl Char.isSpace s
	in
	    if Substring.isEmpty s' then d
	    else if Substring.sub(s',0) = #"#" then
		parseFile(parseComment s', d, path)
	    else parseFile(parseLine(s', d, path))
	end

    fun load(d, file) =
	let
	    val is   = TextIO.openIn file
	    val s    = TextIO.inputAll is
	    val path = OS.Path.dir(OS.Path.mkAbsolute{path = file,
						      relativeTo = cwd})
	in
	    TextIO.closeIn is;
	    parseFile(Substring.full s, d, path)
	end
end
