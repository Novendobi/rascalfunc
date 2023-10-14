module Ast

import PYSyntax;
import PYLex;

data Pystate 
            = funcDef(list[FuncDef] f)
            | statement(list[Statement] s)
            ;
data FuncDef 
            = funct(Funct f)
            | class(Class c)
            ;
data Funct 
            = def(str identifier, list[Parameters] funcparams, FBlock fblock)
            ;
data FBlock 
            = fblock(StatOrRet stat_or_ret)
            ;
data StatOrRet 
            = stat(Statement s)
            | returnStatement(ReturnStatement r_stat)
            ; 
data Class
            = class(str identifier, list[Parameters] classparams, FuncOrStatement funcorstmt)
            ;
data FuncOrStatement 
            = func(FuncDef fd)
            | stmt(Statement sm)
            ;
data Parameters
            = parameters(str identifier, list[str] moreidentifiers)
            ;
data Statement
            = forLoop(ForLoop for_loop)
            | expr(Expression exp)
            | assign(Assignment assign)
            | ifStat(IfStatement if_stat)
            | printStat(PrintStatement print_stat)
            ;
data Assignment 
            = assignment(str identifier, Value val)
            ;
data Value
            = integer(int i)
            | string_val(str s)
            | boolean(str b)
            ;
data ReturnStatement 
            = returnStatement(Expression exp)
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
data ForLoop
            = forloop(str identifier, ForParameter for_params, Block block)
            ;
data ForParameter
            = forparameter(int begin, int end)
            ;
data PrintStatement
            = printstatement(PRValues pr_val)
            ;
data PRValues
            = string(str strval)
            | expression(Expression exp)
            | id(str identifier)
            | conc(Concat conct)
            ;
data Concat
            = concat(str string1, str string2)
            ;
data IfStatement
            = ifstatement(Expression exp, Block block, ElseStat? else_stat)
            ;
data ElseStat
            = elsestat(Block block)
            ;
data Block 
            = block(Statement stmt)
            ;