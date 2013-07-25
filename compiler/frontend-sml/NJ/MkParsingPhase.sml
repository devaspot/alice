val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001-2005
 *
 * Last change:
 *   $Date: 2005-03-11 13:16:36 $ by $Author: rossberg $
 *   $Revision: 1.19 $
 *)
















functor MkParsingPhase(Switches : SWITCHES) :> PARSING_PHASE =
struct

    (* Import *)

    structure C = EmptyContext
    structure I = Source
    structure O = InputGrammar
    structure E = ParsingError


    (* Build Yacc parser *)

    structure DerivedForms = MkDerivedForms (Switches)

    structure LrVals = MkLrVals(structure Token        = LrParser.Token
				structure DerivedForms = DerivedForms)
				
    structure LexerError = MkLexerError(structure Tokens = LrVals.Tokens
					type error       = ParsingError.error)

    structure Lexer  = MkLexer( structure Tokens     = LrVals.Tokens
				structure LexerError = LexerError)

    structure Lexer' = MkCountPosLexer(structure Lexer      = Lexer
				       structure LexerError = LexerError
				       val error            = ParsingError.error
				       val startLine        = 0)

    structure Parser = Join(structure LrParser   = LrParser
		    structure ParserData = LrVals.ParserData
		    structure Lex        = Lexer')


    (* The actual parsing function *)

    fun parse (desc, source) =
	let
	    val yyread = ref false
	    fun yyinput _ =
		if !yyread then
		    ""
		else
		    ( yyread := true; Source.toString source )

	    val lexer = Parser.makeLexer yyinput

	    fun onError(s, pos1, pos2) = E.error((pos1,pos2), E.SyntaxError s)
	in
	    #1 (Parser.parse(0, lexer, onError, desc))
	end

    fun translate(desc, _, source) = ((), parse (desc, source))
end
