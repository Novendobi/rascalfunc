module Checker

import PYSyntax;
extend analysis::typepal::TypePal;

data AType 
        = intType()
        | boolType()
        | stringType()
        | functionType()
        ;

data IdRole 
        = functionId()
        ;

str prettyAType(intType()) = "int";
str prettyAType(boolType()) = "bool";
str prettyAType(stringType()) = "str";
str prettyAType(functionType()) = "function";

void collect(current: (Funct) `def <Identifier name> ( <Parameters params> ) : <FBlock fblock>`, Collector c){
    c.define("<name>", functionId(), current, defType(functionType()));
    
    collect(params, c);
    
    collect(fblock, c);
}

void collect(current: (Parameters pm) `<{Identifier ","}* param>`, Collector c){
    for(p <- param){
        c.define("<p>", variableId(), p, defType(stringType()));
    }
}

void collect(current: (FBlock) `{ <StatOrRet statOrRet> }`, Collector c){
    collect(statOrRet, c);
}

void collect(current: (Statement) `<Assignment assign>`, Collector c){
    collect(assign, c);
}

void collect(current: (Statement) `<IfStatement ifStat>`, Collector c){
    collect(ifStat, c);
}

void collect(current: (ReturnStatement) `return <Expression exp>`, Collector c){
    collect(exp, c);
}

void collect(current: (Expression) `<Identifier id>`, Collector c){
    c.use(id, {variableId()});
}

void collect(current: (Expression) `<Integer integer>`, Collector c){
    c.fact(current, intType());
}

void collect(current: (Expression) `<Boolean boolean>`, Collector c){
    c.fact(current, boolType());
}

void collect(current: (Expression) `( <Expression  e> )`, Collector c){
    c.fact(current, e);
    collect(e, c);
}

void collect(current: (Expression) `<Expression e1> / <Expression e2>`, Collector c){
    c.calculate(
        "division", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`/` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> * <Expression e2>`, Collector c){
    c.calculate(
        "multiplication", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                default:{
                    s.report(error(current, "`*` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> + <Expression e2>`, Collector c){
    c.calculate("addition", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                case <stringType(), stringType()>: return stringType();
                default:{
                    s.report(error(current, "`+` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> - <Expression e2>`, Collector c){
    c.calculate(
        "subtraction", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`-` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> \> <Expression e2>`, Collector c){
    c.calculate(
        "greaterThan", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`\>` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> \< <Expression e2>`, Collector c){
    c.calculate(
        "lessThan", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`\<` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> == <Expression e2>`, Collector c){
    c.calculate(
        "equal", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`==` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> \>= <Expression e2>`, Collector c){
    c.calculate(
        "greaterThanOrEqual", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`\>=` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (Expression) `<Expression e1> \<= <Expression e2>`, Collector c){
    c.calculate(
        "lessThanOrEqual", current, [e1, e2],
        AType (Solver s) {
            switch(<s.getType(e1), s.getType(e2)>){
                case <intType(), intType()>: return intType();
                case <boolType(), boolType()>: return boolType();
                default:{
                    s.report(error(current, "`\<=` not defined for %t and %t", e1, e2));
                    return intType();
                }
            }
        }
    );
    collect(e1, e2, c);
}
