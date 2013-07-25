(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2005
 *
 * Last change:
 *   $Date: 2005-03-08 14:34:43 $ by $Author: rossberg $
 *   $Revision: 1.1 $
 *)

changequote([[,]])

ifdef([[SEAM]],[[
import "SMLToSeamRecursiveCompiler"
]],[[
import "SMLToSeamMozartCompiler"
]])

structure RecursiveCompiler = RecursiveCompiler
