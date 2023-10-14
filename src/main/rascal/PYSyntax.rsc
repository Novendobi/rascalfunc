module PYSyntax

extend PYLex;

start syntax Pystate 
                = funcDef: FuncDef+ 
                | statement: Statement+
                ;
syntax FuncDef 
                = funct: Funct 
                | class: Class
                ;
syntax Funct 
                = def: "def" Identifier "(" Parameters? ")" ":" FBlock
                ;
syntax FBlock 
                = fblock: "{" StatOrRet "}"
                ;
syntax StatOrRet
                 = stat: Statement 
                 | returnStatement: ReturnStatement
                 ;
syntax Class 
                = class: "class" Identifier "(" Parameters? ")" ":" "{" FuncOrStatement "}"
                ;
syntax FuncOrStatement 
                = func: FuncDef 
                | stmt: Statement
                ;
syntax Parameters 
                = parameters: Identifier ("," Identifier)*
                ;
syntax Statement 
                = forLoop: ForLoop
                | expr: Expression 
                | assign: Assignment
                | ifStat: IfStatement
                | printStat: PrintStatement
                ;
syntax Assignment
                = assignment: Identifier "=" Value
                ;
syntax Value 
                = integer: Integer 
                | string_val: String 
                | boolean: Boolean
                ;
syntax ReturnStatement 
                = returnStatement: "return" Expression
                ;
syntax Expression 
                = identifier: Identifier
                | integer: Integer
                | boolean: Boolean
                > bracket Bracket: "(" Expression ")"
                > left division: Expression "/" Expression
                > left multiplication: Expression "*" Expression
                > left addition: Expression "+" Expression
                > left subtraction: Expression "-" Expression
                > left greaterThan: Expression "\>" Expression
                > left lessThan: Expression "\<" Expression
                > left equal: Expression "==" Expression
                > left greaterThanOrEqual: Expression "\>=" Expression
                > left lessThanOrEqual: Expression "\<=" Expression
                ;
syntax ForLoop 
                = forloop: "for" Identifier "in" "range" "(" ForParameter ")" ":" Block
                ;
syntax ForParameter 
                = forparameter: Integer "," Integer
                ;

syntax PrintStatement 
                = printstatement: "print" "(" PRValues ")"
                ;
syntax PRValues 
                = string: String 
                | expression: "(" Expression ")"
                | id: Identifier
                | conc: Concat
                ;
syntax Concat 
                = concat: String "~" String
                ;
syntax IfStatement
                = ifstatement: "if" Expression ":" Block ElseStat?
                ;
syntax ElseStat 
                = elsestat: "else" ":" Block
                ;
syntax Block
        = block: "{" Statement "}"
        ;