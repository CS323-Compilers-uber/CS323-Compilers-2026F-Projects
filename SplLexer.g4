lexer grammar SplLexer;

// Ordering constraint: keywords MUST precede Identifier, because on an
// equal-length match ANTLR picks the rule defined first. All other conflicts
// (= vs ==, / vs // vs /*, int vs integer) are resolved by longest match.

// ---- Keywords ----
INT    : 'int';
STRUCT : 'struct';
RETURN : 'return';
IF     : 'if';
ELSE   : 'else';
WHILE  : 'while';

// ---- Operators ----
ASSIGN : '=';
PLUS   : '+';
MINUS  : '-';
MUL    : '*';
DIV    : '/';
MOD    : '%';
POW    : '^';
LT     : '<';
LE     : '<=';
GT     : '>';
GE     : '>=';
EQ     : '==';
NEQ    : '!=';
AND    : '&&';
OR     : '||';
NOT    : '!';
DOT    : '.';

// ---- Separators ----
SEMI   : ';';
COMMA  : ',';
LPAREN : '(';
RPAREN : ')';
LBRACE : '{';
RBRACE : '}';
LBRACK : '[';
RBRACK : ']';

// ---- Number: decimal, non-negative, no leading zero (01234 -> 0, 1234) ----
Number : '0' | [1-9] [0-9]*;

// ---- Identifier: ASCII letter or underscore first ----
Identifier : [a-zA-Z_] [a-zA-Z0-9_]*;

// ---- Skipped ----
WS            : [ \t\r\n]+ -> skip;
LINE_COMMENT  : '//' ~[\r\n]* -> skip;
// Non-greedy: ends at the FIRST */ after /*, so comments do not nest.
BLOCK_COMMENT : '/*' .*? '*/' -> skip;

// No catch-all error rule: unmatched chars use ANTLR's default error handling.
