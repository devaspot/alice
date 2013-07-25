signature Parser_TOKENS =
sig
type ('a,'b) token
type svalue
val ETYVAR: (string) *  'a * 'a -> (svalue,'a) token
val TYVAR: (string) *  'a * 'a -> (svalue,'a) token
val STAR:  'a * 'a -> (svalue,'a) token
val SYMBOL: (string) *  'a * 'a -> (svalue,'a) token
val ALPHA: (string) *  'a * 'a -> (svalue,'a) token
val CHAR: (WideChar.char) *  'a * 'a -> (svalue,'a) token
val STRING: (WideString.string) *  'a * 'a -> (svalue,'a) token
val REAL: (LargeReal.real) *  'a * 'a -> (svalue,'a) token
val WORD: (LargeWord.word) *  'a * 'a -> (svalue,'a) token
val INT: (LargeInt.int) *  'a * 'a -> (svalue,'a) token
val NUMERIC: (LargeInt.int) *  'a * 'a -> (svalue,'a) token
val DIGIT: (int) *  'a * 'a -> (svalue,'a) token
val ZERO:  'a * 'a -> (svalue,'a) token
val PERVASIVE:  'a * 'a -> (svalue,'a) token
val REFTYPE:  'a * 'a -> (svalue,'a) token
val EQEQTYPE:  'a * 'a -> (svalue,'a) token
val OVERLOAD:  'a * 'a -> (svalue,'a) token
val PRIMITIVE:  'a * 'a -> (svalue,'a) token
val COMP:  'a * 'a -> (svalue,'a) token
val FROM:  'a * 'a -> (svalue,'a) token
val IMPORT:  'a * 'a -> (svalue,'a) token
val UNPACK:  'a * 'a -> (svalue,'a) token
val PACK:  'a * 'a -> (svalue,'a) token
val FCT:  'a * 'a -> (svalue,'a) token
val ANY:  'a * 'a -> (svalue,'a) token
val COLONGREATER:  'a * 'a -> (svalue,'a) token
val WHERE:  'a * 'a -> (svalue,'a) token
val STRUCTURE:  'a * 'a -> (svalue,'a) token
val STRUCT:  'a * 'a -> (svalue,'a) token
val SIGNATURE:  'a * 'a -> (svalue,'a) token
val SIG:  'a * 'a -> (svalue,'a) token
val SHARING:  'a * 'a -> (svalue,'a) token
val INCLUDE:  'a * 'a -> (svalue,'a) token
val FUNCTOR:  'a * 'a -> (svalue,'a) token
val EQTYPE:  'a * 'a -> (svalue,'a) token
val SPAWN:  'a * 'a -> (svalue,'a) token
val LAZY:  'a * 'a -> (svalue,'a) token
val WITHVAL:  'a * 'a -> (svalue,'a) token
val WITHFUN:  'a * 'a -> (svalue,'a) token
val NON:  'a * 'a -> (svalue,'a) token
val CONSTRUCTOR:  'a * 'a -> (svalue,'a) token
val EXTTYPE:  'a * 'a -> (svalue,'a) token
val LINE:  'a * 'a -> (svalue,'a) token
val FILE:  'a * 'a -> (svalue,'a) token
val ASSERT: (int option) *  'a * 'a -> (svalue,'a) token
val FINALLY:  'a * 'a -> (svalue,'a) token
val HASHBRACK:  'a * 'a -> (svalue,'a) token
val DOT:  'a * 'a -> (svalue,'a) token
val HASH:  'a * 'a -> (svalue,'a) token
val ARROW:  'a * 'a -> (svalue,'a) token
val DARROW:  'a * 'a -> (svalue,'a) token
val EQUALS:  'a * 'a -> (svalue,'a) token
val BAR:  'a * 'a -> (svalue,'a) token
val UNDERBAR:  'a * 'a -> (svalue,'a) token
val DOTS:  'a * 'a -> (svalue,'a) token
val SEMICOLON:  'a * 'a -> (svalue,'a) token
val COLON:  'a * 'a -> (svalue,'a) token
val COMMA:  'a * 'a -> (svalue,'a) token
val RBRACE:  'a * 'a -> (svalue,'a) token
val LBRACE:  'a * 'a -> (svalue,'a) token
val RBRACK:  'a * 'a -> (svalue,'a) token
val LBRACK:  'a * 'a -> (svalue,'a) token
val RPAR:  'a * 'a -> (svalue,'a) token
val LPAR:  'a * 'a -> (svalue,'a) token
val WHILE:  'a * 'a -> (svalue,'a) token
val WITHTYPE:  'a * 'a -> (svalue,'a) token
val WITH:  'a * 'a -> (svalue,'a) token
val VAL:  'a * 'a -> (svalue,'a) token
val TYPE:  'a * 'a -> (svalue,'a) token
val THEN:  'a * 'a -> (svalue,'a) token
val REC:  'a * 'a -> (svalue,'a) token
val RAISE:  'a * 'a -> (svalue,'a) token
val ORELSE:  'a * 'a -> (svalue,'a) token
val OPEN:  'a * 'a -> (svalue,'a) token
val OP:  'a * 'a -> (svalue,'a) token
val OF:  'a * 'a -> (svalue,'a) token
val NONFIX:  'a * 'a -> (svalue,'a) token
val LOCAL:  'a * 'a -> (svalue,'a) token
val LET:  'a * 'a -> (svalue,'a) token
val INFIXR:  'a * 'a -> (svalue,'a) token
val INFIX:  'a * 'a -> (svalue,'a) token
val IN:  'a * 'a -> (svalue,'a) token
val IF:  'a * 'a -> (svalue,'a) token
val HANDLE:  'a * 'a -> (svalue,'a) token
val FUN:  'a * 'a -> (svalue,'a) token
val FN:  'a * 'a -> (svalue,'a) token
val EXCEPTION:  'a * 'a -> (svalue,'a) token
val END:  'a * 'a -> (svalue,'a) token
val ELSE:  'a * 'a -> (svalue,'a) token
val DATATYPE:  'a * 'a -> (svalue,'a) token
val DO:  'a * 'a -> (svalue,'a) token
val CASE:  'a * 'a -> (svalue,'a) token
val AS:  'a * 'a -> (svalue,'a) token
val ANDALSO:  'a * 'a -> (svalue,'a) token
val AND:  'a * 'a -> (svalue,'a) token
val ABSTYPE:  'a * 'a -> (svalue,'a) token
val EOF:  'a * 'a -> (svalue,'a) token
end
signature Parser_LRVALS=
sig
structure Tokens : Parser_TOKENS
structure ParserData:PARSER_DATA
sharing type ParserData.Token.token = Tokens.token
sharing type ParserData.svalue = Tokens.svalue
end
