# 06-jcup

1. Criar o arquivo `exemplo.flex`:
- `touch exemplo.flex`

2. Informar o conteúdo do arquivo `exemplo.flex`:
```java
/* Definição: seção para código do usuário. */

import java_cup.runtime.Symbol;

%%

/* Opções e Declarações: seção para diretivas e macros. */

// Diretivas:
%cup
%unicode
%line
%column
%class MeuScanner

// Macros:
digito = [0-9]
inteiro = {digito}+

%%

/* Regras e Ações Associadas: seção de instruções para o analisador léxico. */

{inteiro} {
            Integer numero = Integer.valueOf(yytext());
            return new Symbol(sym.INTEIRO, yyline, yycolumn, numero);
          }
"+"       { return new Symbol(sym.MAIS); }
"-"       { return new Symbol(sym.MENOS); }
"("       { return new Symbol(sym.PARENTESQ); }
")"       { return new Symbol(sym.PARENTDIR); }
";"       { return new Symbol(sym.PTVIRG); }
\n        { /* Ignora nova linha. */ }
[ \t\r]+  { /* Ignora espaços. */ }
.         { System.err.println("\n Caractere inválido: " + yytext() +
                               "\n Linha: " + yyline +
                               "\n Coluna: " + yycolumn + "\n"); 
            return null; 
          }
```

3. Criar o arquivo `exemplo.cup`:
- `touch exemplo.cup`

4. Informar o conteúdo do arquivo `exemplo.cup`:
```java
import java_cup.runtime.*;

terminal Integer INTEIRO;
terminal MAIS, MENOS, MENOSUNARIO, PTVIRG, PARENTESQ, PARENTDIR;

non terminal inicio;
non terminal Integer expr;

precedence left MAIS, MENOS;
precedence right MENOSUNARIO; // Menos unário com maior precedência, associatividade à direita.

start with inicio;

inicio ::= expr:e PTVIRG {: System.out.println(e); :}
         ;

expr ::= expr:a MAIS expr:b         {: RESULT = a.intValue() + b.intValue(); :}
       | expr:a MENOS expr:b        {: RESULT = a.intValue() - b.intValue(); :}
       | MENOS expr:a               {: RESULT = -a; :} %prec MENOSUNARIO       
       | PARENTESQ expr:a PARENTDIR {: RESULT = a.intValue(); :}
       | INTEIRO:a                  {: RESULT = a.intValue(); :}
       ;

/*
Usar %prec:
É importante quando um mesmo token tem dois significados diferentes (como o - unário e binário).
Evita conflitos de precedência.
Garante a construção correta da árvore sintática e a avaliação da expressão.

=> Usar %prec MENOSUNARIO para informar:
   "Essa regra tem a precedência do token MENOSUNARIO, 
    que foi declarado separadamente na seção de precedência".
*/
```

5. Criar o arquivo `Main.java`:
- `touch Main.java`

6. Informar o conteúdo do arquivo `Main.java`:
```java
import java.io.*;

public class Main {
  public static void main(String[] args) throws Exception {
    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
    System.out.println("Digite expressões (termine com ';') e pressione ENTER. Ctrl+C para sair.");

    while (true) {
      System.out.print("> ");
      
      String linha = bufferedReader.readLine();

      if (linha == null || linha.trim().isEmpty()) 
        continue;

      // Adicionar um \n no final para garantir que o analisador leia a linha completa:
      StringReader stringReader = new StringReader(linha + "\n");

      MeuParser meuParser = new MeuParser(new MeuScanner(stringReader));
      
      try {
        meuParser.parse();
      } catch (Exception e) {
        System.err.println("Erro na expressão: " + e.getMessage());
      }
    }
  }
}
```

7. Dar permissão de execução para o arquivo de script `executar.sh` (torná-lo executável):
- `chmod +x executar.sh`

8. Executar o `executar.sh`:
- `./executar.sh`

9. Informar expressões matemáticas do tipo: 
- `1 + (2 - 7);` (é necessário terminar com ";")

- `1 * 7;` (é necessário terminar com ";")

- ```
  1 + (2
  - 7);
  ```
  (é necessário terminar com ";")