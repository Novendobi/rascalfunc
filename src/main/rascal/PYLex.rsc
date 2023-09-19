module PYLex

layout WS = [\t-\n\r\ ]*;

lexical Identifier = ([a-zA-Z_][a-zA-Z0-9_]* ) \ Keywords;
lexical Integer = [0-9]+;
lexical Colon = ":";
lexical String = [\"] String_Char* [\"];
lexical String_Char = ![\\ \" \n] | "\\" [\\ \"];
lexical Boolean = "true" | "false";
lexical If = "if";

lexical Operator = "+" | "-" | "*" | "/" | "\>" | "\<" | "==" | "\>=" | "\<=";

keyword Keywords 
                = "class"
                | "def"
                | "else"
                | "for"
                | "if" 
                | "in"  
                | "while"
                | "range"
                | "return"
                | ":"
                | Boolean
                ;
                