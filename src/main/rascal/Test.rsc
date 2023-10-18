module Test

import PYLex;
import ParseTree;
import vis::Text;
import IO;
import PYSyntax;
import Exception;
import Ast;
import JsAst;
import JsSyntax;

public JsAst::ForLoop transformLoop(Ast::ForLoop pyForLoop) {
    return JsAst::forLoop(JsAst::init(
        pyForLoop.fidentifier, pyForLoop.for_params.begin),
    JsAst::cond(pyForLoop.fidentifier, pyForLoop.for_params.end),
    JsAst::update(pyForLoop.fidentifier, 1), 
    JsAst::print(pyForLoop.fidentifier)
    );
}

public Ast::Pystate transformPystate(Ast::Pystate pythonAst) {
    return visit(pythonAst){
        case forloop(
            fidentifier, for_params, block
        ) => transformLoop(Ast::forloop("<fidentifier>", for_params, block))
    }
}

str prettyPrint(Pystate fl) {
    result = visit(fl){
        case forLoop(init, cond, update, print): return "
        for(let <init.var> = <init.Int>; <cond.cId> \< <cond.cInt>; <update.id> + <update.uInt>){
            \n\t\tprint(<print.pId>)
        }";
    }
    return "<result>";
}

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

        //transformLoop

        jsAst = transformPystate(adtfunc);
        println("\nthis is the Javascript Ast: \n\n<jsAst>");

        str code = prettyPrint(jsAst);
        println(code);
        writeFile(|project://pythonsyntax/src/main/rascal/modeltotext/pytoJs.js|, code);
        
    }catch ParseError(e): println("error failed at <e>");
}
