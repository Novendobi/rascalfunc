module Test

import PYLex;
import ParseTree;
import vis::Text;
import IO;
import PYSyntax;
import Exception;
import Ast;

void main() {
    try{
        loc FileLoc = |project://pythonsyntax/src/resources/test.tap|;

        str pyfunct = readFile(FileLoc);
        Tree func = parse(#start[Pystate], pyfunct);
        //print parsetree
        println(prettyTree(func));

        //ast implode
        Pystate adtfunc = implode(#Pystate, func);
        println(adtfunc);
        
    }catch ParseError(e): println("error failed at <e>");
}
