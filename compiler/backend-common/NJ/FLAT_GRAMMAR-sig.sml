val assert=General.assert;
(*
 * Author:
 *   Leif Kornstaedt <kornstae@ps.uni-sb.de>
 *
 * Copyright:
 *   Leif Kornstaedt, 1999-2002
 *
 * Last change:
 *   $Date: 2005-03-21 15:14:15 $ by $Author: rossberg $
 *   $Revision: 1.85 $
 *)











signature FLAT_GRAMMAR =
    sig
	(* Annotations *)

	type lit_info = Source.region
	type id_info = {region: Source.region, typ: Type.t}
	type stm_info = Source.region
	type exp_info = Source.region

	(* Statements and Expressions *)

	datatype lit = (*--** need to annotate widths *)
	    IntLit of lit_info * LargeInt.int
	  | WordLit of lit_info * LargeWord.word
	  | CharLit of lit_info * WideChar.char
	  | StringLit of lit_info * WideString.string
	  | RealLit of lit_info * LargeReal.real

	type stamp = Stamp.t
	type name = Name.t
	type label = Label.t

	datatype id = Id of id_info * Stamp.t * Name.t

	datatype idDef =
	    IdDef of id
	  | Wildcard

	datatype idRef =
	    IdRef of id
	  | LastIdRef of id
	  | Lit of lit
	  | Prim of string
	  | Value of Reflect.value * bool

	datatype funFlag =
	    PrintName of string
	  | AuxiliaryOf of stamp
	  | IsToplevel

	datatype 'a args =
	    OneArg of 'a
	  | TupArgs of 'a vector
	    (* may be unary only for Tag and Con *)
	  | ProdArgs of (label * 'a) vector
	    (* sorted, all labels distinct, no tuple *)

	datatype prod =
	    Tuple of int
	  | Product of label vector

	datatype entry_point =
	    ConEntry of Type.t * idRef * idRef args
	  | SelEntry of prod * label * int * Type.t * idRef
	  | StrictEntry of Type.t * idRef
	  | AppEntry of Type.t * idRef * idRef args
	  | CondEntry of Type.t * idRef
	  | RaiseEntry of idRef
	  | HandleEntry of idRef
	  | SpawnEntry

	datatype exit_point =
	    ConExit
	  | SelExit of Type.t
	  | StrictExit
	  | AppExit
	  | CondExit of Type.t
	  | RaiseExit of Type.t
	  | HandleExit of Type.t
	  | SpawnExit of Type.t

	datatype stm =
	  (* the following may never be last *)
	    Entry of stm_info * entry_point
	  | Exit of stm_info * exit_point * idRef
	  | LastUse of stm_info * id vector
	  | ValDec of stm_info * idDef * exp
	  | RecDec of stm_info * (idDef * exp) vector
	  | RefDec of stm_info * idDef * idRef
	  | TupDec of stm_info * idDef vector * idRef
	  | ProdDec of stm_info * (label * idDef) vector * idRef
	    (* sorted, all labels distinct, no tuple *)
	  (* the following must always be last *)
	  | RaiseStm of stm_info * idRef
	  | ReraiseStm of stm_info * idRef
	  | TryStm of stm_info * body * idDef * idDef * body
	  | EndTryStm of stm_info * body
	  | EndHandleStm of stm_info * body
	    (* all bodies of EndTryStm/EndHandleStm corresponding to an
	     * exception handler are identical (and - if necessary - are
	     * marked by a SharedStm node) *)
	  | TestStm of stm_info * idRef * tests * body
	  | SharedStm of stm_info * body * stamp
	  | ReturnStm of stm_info * exp
	  | IndirectStm of stm_info * body option ref
	  | ExportStm of stm_info * exp
	and tests =
	    LitTests of (lit * body) vector
	  | TagTests of label vector * (int * idDef args * body) vector
	  | ConTests of (idRef * idDef args * body) vector
	  | VecTests of (idDef vector * body) vector
	and exp =
	    NewExp of exp_info * Name.t
	  | VarExp of exp_info * idRef
	  | TagExp of exp_info * label vector * int * idRef args
	  | ConExp of exp_info * idRef * idRef args
	  | RefExp of exp_info * idRef
	  | TupExp of exp_info * idRef vector
	  | ProdExp of exp_info * (label * idRef) vector
	    (* sorted, all labels distinct, no tuple *)
	  | PolyProdExp of exp_info * (label * idRef) vector
	    (* sorted, all labels distinct *)
	  | VecExp of exp_info * idRef vector
	  | FunExp of exp_info * stamp * funFlag list *
		      Type.t * idDef args * Arity.t option * body
 	  | PrimAppExp of exp_info * string * idRef vector
 	    (* no calling convention required conversion for in-arguments *)
	  | VarAppExp of exp_info * idRef * idRef args
	  | DirectAppExp of exp_info * idRef * idRef args
	    (* no calling convention required conversion for in-arguments *)
	  | SelExp of exp_info * prod * label * int * idRef
	  | LazyPolySelExp of exp_info * label * idRef
	  | FunAppExp of exp_info * idRef * stamp * idRef args
	    (* no calling convention required conversion for in-arguments *)
	  | FailExp of exp_info
	withtype body = stm list

	type sign = IntermediateGrammar.sign
	type component =
	     {imports: (id * sign * Url.t * bool) vector,
	      body: body,
	      exports: (label * id) vector,
	      sign: sign}
	type t = component

	val freshId: Source.region -> id
	val infoStm: stm -> stm_info
	val litEq: lit * lit -> bool
    end
