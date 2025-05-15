import java_cup.runtime.Symbol;

%%

%public
%unicode
%line
%column
%cup
%class MeuScanner

PLUS = \+
NUM  = [0-9]+

%%

{NUM}     { return new Symbol(sym.NUM, Integer.parseInt(yytext())); }
{PLUS}    { return new Symbol(sym.PLUS); }
\n        { /* ignora nova linha */ }
[ \t\r]+  { /* ignora espaços */ }
.         { System.err.println("Caractere inválido: " + yytext()); return null; }