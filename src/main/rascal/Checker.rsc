module Checker

import PYSyntax;
extend analysis::typepal::TypePal;

data AType 
        = intType()
        | boolType()
        | stringType()
        | listType(AType elemType)
        | functionType(list[AType] paramTypes, AType returnType)
        | classType(str className, map[str, AType] methods)
        ;

str prettyAType(intType()) = "int";
str prettyAType(boolType()) = "bool";
str prettyAType(stringType()) = "str";
str prettyAType(listType(AType elemType)) = "list of " + prettyAType(elemType);
str prettyAType(functionType(list[AType] paramTypes, AType returnType)) = 
    "function(" + [prettyAType(t) | t <- paramTypes] + ") -\> " + prettyAType(returnType);
str prettyAType(classType(str className, map[str, AType] methods)) = 
    "class " + className + " { " + [k + ": " + prettyAType(v) | k <- keySet(methods), v <- methods[k]] + " }";

void collect(
        current: (Funct) `def <Identifier name>( <Parameters params> ) : <FBlock fblock>`, Collector c
){
        list[AType] paramTypes = [getType(p) | p <- params];
        AType returnType = getType(fblock);
        c.define(name, functionId(), current, functionType(paramTypes, returnType));

        collect(params, c);
        collect(fblock, c);
}
void collect(
        current: (Class)
         `class <Identifier name> ( <Parameters params> ) : { <FuncOrStatement funcOrstmt> }`,
         Collector c
){
        map[str, AType] methodTypes = {(getName(m): getType(m)) | m <- funcOrstmt, isFunction(m)};
        c.define(name, classId(), current, classType(name, methodTypes));
        for(m <- funcOrstmt, isFunction(m)){
                collect(m, c);
        }
}

void collect(
        current: (ForLoop) 
        `for <Identifier var> in range ( <ForParameter params> ) : { <Statement stmt> }`,
        Collector c
){
        c.define(var, variableId(), current, stringType());
        collect(stmt, c);
}

void collect(
        current: (IfStatement)
        `if <Expression cond> : { <Statement thenStmt> } else : { <Statement elseStmt> }`,
        Collector c
){
        collect(cond, c);
        collect(thenStmt, c);
        collect(elseStmt, c);
}

void collect(current: (Statement) `<Assignment assign>`, Collector c){
    collect(assign, c);
}

void collect(current: (Assignment) `<Identifier var> = <Value val>`, Collector c){
    c.define(var, variableId(), current, getType(val));
}

void collect(current: (Value) `<Integer intVal>`, Collector c){
    c.fact(current, intType());
}

void collect(current: (ReturnStatement) `return <Expression expr>`, Collector c){
    collect(expr, c);
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

void collect(current: (Block) `{ <Statement stmt> }`, Collector c){
    collect(stmt, c);
}

void collect(current: (ForParameter) `<Integer begin>, <Integer end>`, Collector c){
    c.fact(current, intType());
}

void collect(current: (PrintStatement) `print ( <PRValues values> )`, Collector c){
    collect(values, c);
}

void collect(current: (PRValues) `<String strg>`, Collector c){
    c.fact(current, stringType());
}

void collect(current: (Concat) `<String s1> ~ <String s2>`, Collector c){
    c.calculate(
        "concat", current, [s1, s2],
        AType (Solver s) {
            switch(<s.getType(s1), s.getType(s2)>){
                case <stringType(), stringType()>: return stringType();
                default:
                    s.report(error(current, "`concat` not defined for %t and %t", e1, e2));
            }
        }
    );
    collect(e1, e2, c);
}

void collect(current: (ElseStat) `else : <Block block>`, Collector c){
    collect(block, c);
}

void collect(current: (Block) `{ <Statement stmts> }`, Collector c){
    for(stmt <- stmts) {
        collect(stmt, c);
    }
}