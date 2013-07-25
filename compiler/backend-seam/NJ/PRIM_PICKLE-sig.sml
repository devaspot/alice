val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Contributor:
 *   Guido Tack <tack@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 2000-2002
 *   Guido Tack, 2003
 *
 * Last change:
 *   $Date: 2004-12-13 16:06:49 $ by $Author: tack $
 *   $Revision: 1.11 $
 *)

(*  pickle        ::=  init instrs ENDOFSTREAM
 *  init	  ::=  INIT stackSize noOfLocals
 *  stackSize     ::= <uint>
 *  noOfLocals    ::= <uint>
 *  instrs        ::=  instr instrs
 *	            |  (* empty *)
 *  instr	  ::=  simpleInstr
 *                  |  complexInstr
 *  simpleInstr   ::=  STORE address
 *	            |  LOAD address
 *                  |  POSINT <uint>
 *                  |  NEGINT <uint>
 *                  |  CHUNK size <byte>*size
 *                  |  UNIQUE
 *  complexInstr  ::=  ANNOUNCE complexInstr' address
 *	            |  FULFILL address
 *                  |  complexInstr'
 *  complexInstr' ::=  BLOCK label size
 *                  |  TUPLE size
 *                  |  CLOSURE size
 *                  |  TRANSFORM
 *  address       ::=  <uint>
 *  size          ::=  <uint>
 *  label         ::=  <uint>
 *)



signature PRIM_PICKLE =
    sig
	type outstream
	type register

	type label = int
	type size = int

	val openOut: string -> outstream
	val nextRegister: outstream -> register
	val outputInt: outstream * int -> unit
	val outputFixedInt: outstream * FixedInt.int -> unit
	val outputChunk: outstream * Word8Vector.t -> unit
	val outputMChunk: outstream * Word8Vector.t -> unit
	val outputUnique: outstream -> unit
	val outputBlock: outstream * label * size -> unit
	val outputMBlock: outstream * label * size -> unit
	val outputTuple: outstream * size -> unit
	val outputClosure: outstream * size -> unit
	val outputLoad: outstream * register -> unit
	val outputStore: outstream * register -> unit
	val outputString: outstream * string -> unit
	val outputAtom: outstream * Atom.t -> unit
	val outputTransform: outstream -> unit
	val closeOut: outstream -> unit
    end
