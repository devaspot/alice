val assert=General.assert;
(*
 * Authors:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg and Leif Kornstaedt, 2000-2003
 *
 * Last change:
 *   $Date: 2003-05-09 11:59:38 $ by $Author: rossberg $
 *   $Revision: 1.13 $
 *)

(*
 * Scenarios for compiler usage:
 * 1. Batch: always use empty context, discard result
 * 2. Interactive: use previous resulting context
 * 3. Debugging: context is provided by some outside magic, discard result
 *)






signature COMPILER =
sig
    structure Switches : SWITCHES
    structure Context :  CONTEXT

    exception Error

    val compile : Source.desc * Context.t * Source.t -> Context.t * Target.t
							    (* [Error] *)
    val isCrossCompiler : bool
end
