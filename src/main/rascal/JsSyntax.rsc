module JsSyntax

extend PYLex;

start syntax ForLoop
        = forLoop: "for" "(" Initialization ";" Condition ";" Update ")" Statement
        | funct: Funct
        ;
syntax Initialization
        = init: "let" Identifier "=" Integer
        ;
syntax Condition
        = cond: Identifier "\<" Integer
        ;
syntax Update
        = update: Identifier "+" Integer
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
syntax Statement
        = statm: Identifier "=" Expression ";"
        | print: "print" "(" Identifier ")" ";"
        | exp: Expression ";"
        | statement: "{" {Statement ","}* "}"
        ;
syntax Funct
        = function: "function" Identifier "(" FParameter ")" Fblock
        ;
syntax FParameter
        = fParamId: {Identifier ","}*
        | fParamInt: {Integer ","}*
        ;
syntax Fblock
        = stat: Statement
        | ret: "{" "return" Expression "}"
        ;