val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2003-2004
 *
 * Last change:
 *   $Date: 2004-09-14 11:37:26 $ by $Author: rossberg $
 *   $Revision: 1.3 $
 *)










local
    open IntermediateGrammar
    open TranslationEnv
    type region = Source.region
in

signature INTERMEDIATE_CONS =
sig

  (* Accessors *)

    val regionOfId	: id -> region
    val regionOfLongid	: longid -> region
    val regionOfExp	: exp -> region
    val regionOfPat	: pat -> region

    val typOfId		: id -> Type.t
    val typOfLongid	: longid -> Type.t
    val typOfExp	: exp -> Type.t
    val typOfPat	: pat -> Type.t

  (* General expressions *)

    val auxId		: id_info -> id
    val shortId		: id -> longid

    val lazyExp		: exp -> exp
    val strictExp	: exp -> exp
    val strictPat	: pat -> pat
    val seqExp		: exp * exp -> exp
    val letExp		: dec vector * exp -> exp

    val stringExp	: region * string -> exp
    val unitExp		: region -> exp
    val unitPat		: region -> pat
    val tupExp		: region * exp vector -> exp
    val tupPat		: region * pat vector -> pat
    val vecExp		: region * Type.t * exp vector -> exp
    val selExp		: region * int * exp -> exp
    val fld		: region * Label.t * 'a -> 'a fld

    val idExp		: id -> exp
    val idPat		: id -> pat
    val idFld		: (id -> 'a) -> id -> 'a fld
    val longidExp	: longid -> exp
    val idUnsealDec	: longid * id -> dec
    val auxDec		: id * exp -> dec
    val expDec		: exp -> dec

  (* RTT expressions *)

    val pathId		: env * region -> id
    val typId		: env * region -> id
    val infId		: env * region -> id

    val rttExp		: env * region * Label.t * Label.t -> exp
    val rttAppExp	: env * region * Label.t * Label.t * exp -> exp

    val fixExp		: env * region * Fixity.t -> exp
    val labExp		: env * region * Label.t -> exp
    val pathExp		: env * region * Name.t -> exp
    val pathInventExp	: env * region -> exp
    val kindExp		: env * region * Type.kind -> exp	(* Domain *)
    val unconstrainedExp : env * region -> exp
    val pervTypExp	: env * region * string -> exp
    val pervInfExp	: env * region * string -> exp

    val typExp		: env * Label.t * exp -> exp
    val infExp		: env * Label.t * exp -> exp
end

end (* local *)
