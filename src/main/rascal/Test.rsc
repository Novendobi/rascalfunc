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

//forloop
public JsAst::ForLoop transformLoop(Ast::ForLoop pyForLoop) {
    return JsAst::forLoop(JsAst::init(
        pyForLoop.fidentifier, pyForLoop.for_params.begin),
    JsAst::cond(pyForLoop.fidentifier, pyForLoop.for_params.end),
    JsAst::update(pyForLoop.fidentifier, 1), 
    JsAst::print(pyForLoop.fidentifier)
    );
}

public JsAst::Funct transformFunc(Ast::Funct pyFunct){
    return JsAst::function(
        pyFunct.identifier, JsAst::fParamId(pyFunct.funcparams.moreidentifiers),
        JsAst::ret(pyFunct.fblock.stat_or_ret.r_stat.exp));
}

public Ast::Pystate transformPystate(Ast::Pystate pythonAst) {
    return visit(pythonAst){
        case forloop(
            fidentifier, for_params, block
        ) => transformLoop(Ast::forloop("<fidentifier>", for_params, block))

        case def(identifier, funcparams, fblock)
        => transformFunc(Ast::def(identifier, funcparams, fblock))
    }
}

//prettyPrint
str prettyPrint(Pystate fl) {
    result = visit(fl){
        case forLoop(init, cond, update, print): return 
"for(let <init.var> = <init.Int>; <cond.cId> \< <cond.cInt>; <update.id> + <update.uInt>){
    print(<print.pId>)
}";
        case function(fuId, fParamId, ret):{
            str params = intercalate(",", [f | f <- fParamId.Fpar]);
            str retExp = "";
            visit(ret.fbexp){
                case addition(identifier(left), identifier(right)):
                retExp += "<left> + <right>";
                case addition(integer(left), integer(right)):
                retExp += "<left> + <right>";
            }    
        return
"function <fuId>(<params>){
    return <retExp>
}";
        }
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

        //transformJS

        jsAst = transformPystate(adtfunc);
        println("\nthis is the Javascript Ast: \n\n<jsAst>");

        str code = prettyPrint(jsAst);
        println("this is the code\n\n<code>");
        writeFile(|project://pythonsyntax/src/main/rascal/modeltotext/pytoJs.js|, code);
        
    }catch ParseError(e): println("error failed at <e>");
}
