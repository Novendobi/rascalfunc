module Test

import ParseTree;
import vis::Text;
import IO;
import PYSyntax;
import PYLex;
import Exception;

void main() {
    try{
        str pyfunct = "def add(x, y): {return x + y}";
        start[Pystate] func = parse(#start[Pystate], pyfunct);

        //print("this is " + pyfunct + " parsetree");
        println(prettyTree(func));
        
        str pyloop = "def loop(): {for i in range(0, 5): {print(i)}} ";
        start[Pystate] loopfunc = parse(#start[Pystate], pyloop);

        //print("this is " + pyloop + " parsetree");
        println(prettyTree(loopfunc));
    }catch ParseError(e): println("error failed at <e>");
}
