module TestJs

import ParseTree;
import vis::Text;
import IO;
import JsSyntax;
import Exception;
import JsAst;

void main() {
    try{
        loc FileLoc = |project://pythonsyntax/src/resources/js.tap|;

        str jsfunct = readFile(FileLoc);
        Tree floop = parse(#start[ForLoop], jsfunct);
        //print parsetree
        println(prettyTree(floop));

        //ast implode
        ForLoop adtfunc = implode(#ForLoop, floop);
        println(adtfunc);

    }catch ParseError(e): println("error failed at <e>");
}