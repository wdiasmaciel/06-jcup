# 02-jcup

# Analisador Léxico e Sintático com JFlex e JCup

Este projeto demonstra como usar `JFlex` e `JCup` juntos para analisar expressões simples como `1 + 2 + 3`.

## Como usar no GitHub Codespaces

1. Clonar o repositório.

<strong>Ou</strong>

1. Baixar o `JFlex`:
- `wget https://repo1.maven.org/maven2/de/jflex/jflex/1.8.2/jflex-1.8.2.jar -O jflex.jar`

2. Baixa o `JCup`:
- `wget https://repo1.maven.org/maven2/com/github/vbmacher/java-cup/11b-20160615/java-cup-11b-20160615.jar -O jcup.jar`

3. Criar o arquivo `exemplo.flex`:
- `touch exemplo.flex`

4. Informar o conteúdo do arquivo `exemplo.flex`:
```java

package src;
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

```

5. Criar o arquivo `exemplo.cup`:
- `touch exemplo.cup`

6. Informar o conteúdo do arquivo `exemplo.cup`:
```java

import java.io.InputStreamReader;
import java_cup.runtime.*;

parser code {:  
    public static void main(String[] args) throws Exception {
        MeuScanner meuScanner = new MeuScanner(new InputStreamReader(System.in));
        Parser parser = new Parser(meuScanner);
        parser.parse();
    }
:};

terminal PLUS, NUM;
non terminal expr;

start with expr;

expr ::= expr PLUS NUM 
    {: RESULT = ((Integer) $1) + ((Integer) $3);
       System.out.println("Soma atual: " + RESULT); 
    :}
       | NUM 
    {: RESULT = (Integer) $1;
       System.out.println("Número inicial: " + RESULT); 
    :} ;

```

7. Criar o arquivo `Main.java`:
- `touch Main.java`

8. Informar o conteúdo do arquivo `Main.java`:
```java

public class Main {
    public static void main(String[] args) throws Exception {
        Parser.main(args);
    }
}

```

9. Criar um arquivo de script para compilação:
- `touch rodar.sh`

10. Informar o conteúdo do arquivo `compila.sh`:
```bash

#!/bin/bash

java -cp jflex.jar:jcup.jar jflex.Main exemplo.flex
java -cp jcup.jar java_cup.Main -parser Parser -symbols sym exemplo.cup
javac -cp jcup.jar *.java

echo "Digite uma expressão (ex: 1 + 2 + 3):"
java -cp "jcup.jar:." Main

```
11. Dar permissão de execução para o arquivo de script. Executar:
- `chmod +x rodar.sh`

12. Testar a aplicação. Executar:
- `./rodar.sh`

21. Informe expressões como `1 + 2 + 3` para testar.


O parser será gerado com o nome `Parser.java`, e os símbolos com `sym.java`.

Exemplo de arquivo `sym.java` gerado:
```java

public class sym {
  public static final int EOF = 0;
  public static final int error = 1;
  public static final int PLUS = 2;
  public static final int NUM = 3;
  // ... e outros se houverem.
}

```
