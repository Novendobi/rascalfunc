module PYLex

layout WS = [\t-\n\r\ ]*;

lexical Identifier 
            = ([a-z A-Z 0-9 _] !<< [a-z A-Z][a-z A-Z 0-9 _]* !>> [a-z A-Z 0-9 _]) \ Keywords
	        ;
lexical Integer = [0-9]+;
lexical String = [\"] String_Char* [\"];
lexical String_Char = ![\\ \" \n] | "\\" [\\ \"];
lexical Boolean = "true" | "false";

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
                