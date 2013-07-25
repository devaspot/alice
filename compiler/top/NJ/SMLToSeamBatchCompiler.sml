val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2001-2003
 *
 * Last change:
 *   $Date: 2005-03-08 14:34:43 $ by $Author: rossberg $
 *   $Revision: 1.8 $
 *)




structure SMLToSeamBatchCompiler =
    MkBatchCompiler(structure RecursiveCompiler = RecursiveCompiler
		    val executableHeader =
			"#!/bin/sh\nexec alicerun $0 \"$@\"\n"
		    val extension = "alc")
