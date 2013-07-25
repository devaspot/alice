val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt and Andreas Rossberg, 1999-2004
 *
 * Last change:
 *   $Date: 2005-02-15 10:35:07 $ by $Author: rossberg $
 *   $Revision: 1.63 $
 *)












functor MkBatchCompiler(structure RecursiveCompiler: RECURSIVE_COMPILER'
			val executableHeader: string
			val extension: string): BATCH_COMPILER =
    struct
	fun basename filename =
	    let
		fun cutPath ((#"/" | #"\\")::rest) = nil
		  | cutPath (c::rest) = c::cutPath rest
		  | cutPath nil = nil
		val cs = cutPath (List.rev (String.explode filename))
		fun cutExtension (#"."::rest) =
		    (case rest of
			 (#"/" | #"\\")::_ => cs
		       | _::_ => rest
		       | nil => cs)
		  | cutExtension ((#"/" | #"\\")::_) = cs
		  | cutExtension (_::rest) = cutExtension rest
		  | cutExtension nil = cs
	    in
		String.implode (List.rev (case cs of
					      #"."::_ => cs
					    | _ => cutExtension cs))
	    end

	fun matchWith (rea, SOME inf1, SOME inf2) =
		Inf.matchWith (rea, inf1, inf2)
	  | matchWith (rea, _, _) = ()

	fun t1 < t2 = Time.compare (t1, t2) = LESS

	fun uptodate (srcfile, dstfile) =
	    let
		val url = Url.fromString dstfile
		val component = Component.load url
		val imports = Vector.map (Pair.mapFst (Url.resolve url))
					 (Component.imports component)
		val srctime = OS.FileSys.modTime srcfile
		val dsttime = OS.FileSys.modTime dstfile
		val rea = Inf.rea ()
	    in
		srctime < dsttime andalso
		(Vector.all (fn (importUrl, importInf) => (* quick test *)
		    let
			val importFile = 
			    case Resolver.localize Component.defaultResolver
						   importUrl of
				SOME (Resolver.FILE file) => file
			      | _ => raise Domain
		    in
			OS.FileSys.modTime importFile < dsttime
		    end
		 ) imports orelse
		 Vector.all (fn (importUrl, importInf) =>
		    let
			val importComponent = Component.load importUrl
			val exportInf = Component.inf importComponent
		    in
			matchWith (rea, exportInf, importInf);
			true
		    end
		 ) imports
		)
	    end
	    handle _ => false

	fun main_c (infile, outfile) =
	    RecursiveCompiler.compileFileToFile (infile, outfile)
(*--** handle IO.Io {...} => *)

	fun main_r (infile, outfile) =
	    if uptodate (infile, outfile) then
		(TextIO.output (TextIO.stdErr, outfile ^ " is up to date\n");
		 TextIO.flushOut TextIO.stdErr)
	    else
		 main_c (infile, outfile)

	fun main_x (infile, outfile) =
	    (*--** respect executableHeader *)
	    (RecursiveCompiler.compileFileToFile (infile, outfile);
	     case Config.platform of
		 Config.WIN32 => ()
	       | Config.UNIX => (OS.Process.system ("chmod +x " ^ outfile); ()))
(*--** handle IO.Io {...} => *)

	structure OptionParser = MkOptionParser (RecursiveCompiler.Switches)

	fun usage fail =
	    TextIO.output
	    (if fail then TextIO.stdErr else TextIO.stdOut,
	     "Usage: alicec [<option> ...] [-c|-r|-x] <input file> \
	      \[-o <output file>]\n" ^ OptionParser.helpText)

	fun main' [] = (usage true; OS.Process.failure)
	  | main' ("--version"::_) =
	    (TextIO.output (TextIO.stdOut, OptionParser.banner ^ "\n");
	     TextIO.output (TextIO.stdOut, OptionParser.copyright ^ "\n");
	     OS.Process.success)
	  | main' ["--dryrun"] =
	    let
		val s = TextIO.inputAll TextIO.stdIn
	    in
		RecursiveCompiler.compileString
		(RecursiveCompiler.Context.empty, s);
		OS.Process.success
	    end
	  | main' ["--print-component-extension"] =
	    (TextIO.print (Component.extension ^ "\n");
	     OS.Process.success)
	  | main' (("--help"|"-h"|"-?")::_) = (usage false; OS.Process.success)
	  | main' ("-c"::(rest as _::_)) = main'' (main_c, rest)
	  | main' ("-r"::(rest as _::_)) = main'' (main_r, rest)
	  | main' ("-x"::(rest as _::_)) = main'' (main_x, rest)
	  | main' rest = main'' (main_c, rest)
	and main'' (main_, infile::"-o"::outfile::rest) =
	    (main_ (infile, outfile);
	     main'' (main_, rest))
	  | main'' (main_, infile::rest) =
	    (main_ (infile, basename infile ^ "." ^ extension);
	     main'' (main_, rest))
	  | main'' (main_, []) = OS.Process.success

	fun defaults () = (* override defaults from MkSwitches here *)
	    RecursiveCompiler.Switches.Language.implicitImportFile :=
		SOME "x-alice:/alicec.import"

	fun main arguments =
	    (defaults ();
	     main' (OptionParser.parse arguments))
	     handle RecursiveCompiler.Error => OS.Process.failure
    end
