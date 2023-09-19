module PYSyntax

import PYLex;

start syntax Pystate = FuncDef | Statement;
syntax FuncDef = Funct | Class;
syntax Funct = "def" Identifier "(" Parameters? ")" Colon FBlock;
syntax FBlock = "{" StatOrRet "}";
syntax StatOrRet =  Statement | ReturnStatement;
syntax Class = "class" Identifier "(" Parameters? ")" Colon "{" (FuncDef | Statement) "}";
syntax Parameters = Identifier ("," Identifier)*;
syntax Statement 
                = ForLoop
                | Expression 
                | Assignment
                | IfStatement
                | PrintStatement
                ;
syntax Assignment = Identifier "=" (Integer | String_Char | Boolean);
syntax ReturnStatement = "return" Expression;
syntax Expression 
                = Identifier
                > left bracket "(" Expression ")"
                > left Expression "/" Expression
                > left Expression "*" Expression
                > left Expression "+" Expression
                > left Expression "-" Expression
                > left Expression "\>" Expression
                > left Expression "\<" Expression
                > left Expression "==" Expression
                > left Expression "\>=" Expression
                > left Expression "\<=" Expression
                ;
syntax ForLoop 
        = "for" Identifier "in" "range" "(" ForParameter ")" Colon Block;
syntax ForParameter = Integer "," Integer;

syntax PrintStatement = "print" "(" PRValues ")";
syntax PRValues 
                = String 
                | "(" Expression ")"
                | Identifier
                | Concat
                ;
syntax Concat = String "~" String;
syntax IfStatement
                = If Expression Colon Block ElseStat?;
syntax ElseStat = "else" Colon Block;
syntax Block
        = "{" Statement "}"
        ;

