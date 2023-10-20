module JsAst

import JsSyntax;

data ForLoop 
        = forLoop(Initialization init, Condition cond, Update update, Statement stat)
        | funct(Funct funFl)
        ;
data Initialization
        = init(str var, int Int)
        ;
data Condition 
        = cond(str cId, int cInt)
        ;
data Update 
        = update(str id, int uInt)
        ;
data Expression
            = identifier(str identifier)
            | integer(int integer)
            | boolean(bool boolean)
            | Bracket(Expression exp)
            | division(Expression left, Expression right)
            | multiplication(Expression left, Expression right)
            | addition(Expression left, Expression right)
            | subtraction(Expression left, Expression right)
            | greaterThan(Expression left, Expression right)
            | lessThan(Expression left, Expression right)
            | equal(Expression left, Expression right)
            | greaterThanOrEqual(Expression left, Expression right)
            | lessThanOrEqual(Expression left, Expression right)
            ;
data Statement
        = statm(str stId, Expression stExp)
        | print(str pId)
        | exp(Expression expSt)
        | statement(list[str] morestats)
        ;
data Funct
        = function(str fuId, FParameter fpar, Fblock fbloc)
        ;
data FParameter
        = fParamId(list[str] Fpar)
        | fParamInt(list[int] FparInt)
        ;
data Fblock
        = stat(Statement fbstat)
        | ret(Expression fbexp)
        ;