module pythonsyntax

import IO;
import vis::Text;
import ParseTree;

lexical Identifier = [a-zA-Z_][a-zA-Z0-9_]*;
lexical Integer = [0-9]+;
layout WS = [\t-\n\r\ ]*;

// a python like syntax that can parse a basic featured python function and a forloop. ##morefeaturesloading

start syntax FuncDef = "def" Identifier "(" Parameters? ")" ":" "{" Statement+ "}";
syntax Parameters = Identifier ("," Identifier)*;
syntax Statement = ReturnStatement | ForLoop;
syntax ReturnStatement = "return" Expression;
syntax Expression = Identifier "+" Identifier;
syntax ForLoop = "for" Identifier "in" "range" "(" IntParameter ")" ":" "{" PrintStatement "}";
syntax IntParameter = Integer "," Integer;
syntax PrintStatement = "print" "(" (Identifier | Integer) ")";

void main() {
    str pyfunct = "def add(x, y): {return x + y}";
    start[FuncDef] func = parse(#start[FuncDef], pyfunct);

    print("this is " + pyfunct + " parsetree");
    println(prettyTree(func));
    
    str pyloop = "def loop(): {for i in range(1,10): { print(i)}}";
    start[FuncDef] loopfunc = parse(#start[FuncDef], pyloop);

    //print("this is " + pyloop + " parsetree");
    println(prettyTree(loopfunc));
}