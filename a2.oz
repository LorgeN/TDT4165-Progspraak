/* \insert ./List.oz */

/* List.oz included here for convenience (avoids multiple files in hand in) :) */
declare Length Take Drop Append Member Position Reverse

fun {Length List} A in 
    case List of Element1|Rest then
        A = 1 + {Length Rest}
    else
        A = 0
    end
    A
end

fun {Take List Count} R in
    if Count > {Length List} then
        R = List
    elseif Count < 1 then
        R = nil
    else
        case List of Element1|Rest then
            R = Element1|{Take Rest Count - 1}
        else
            R = nil
        end
    end
    R
end

fun {Drop List Count} R in
    if Count > {Length List} then
        R = nil
    elseif Count < 1 then
        R = List
    else
        case List of Element1|Rest then
            R = {Drop Rest Count -1}
        end
    end
    R
end

fun {Append List1 List2} R in
    case List1 of nil then
        R = List2
    [] L|Lr then
        R = L|{Append Lr List2}
    end 
    R
end

fun {Member List Element} R in
    case List of nil then
        R = false
    [] Element1|Rest then
        if Element1 == Element then
            R = true
        else
            R = {Member Rest Element}
        end
    end
    R
end

fun {Position List Element} R in
    case List of Element1|Rest then
        if Element1 == Element then
            R = 1
        else
            R = 1 + {Position Rest Element}
        end
    end
    R
end

fun {Reverse List} 
    fun {DoReverse List1 List2}
        case List1 of nil then List2
        [] X|Xr then {DoReverse Xr X|List2}
        end
    end
in
    {DoReverse List nil}
end

/* List.oz end */

local Lex Tokenize Interpret Infix in
    fun {Lex Input}
       {String.tokens Input & }
    end

    {Browse 'Task 2a'}
    {Browse {Lex "1 2 + 3 *"}}

    fun {Tokenize Lexemes}
        fun {TokenizeSingle Lexeme}
            if {String.isInt Lexeme} then
                number({String.toInt Lexeme $})
            elseif {String.isFloat Lexeme} then
                number({String.toFloat Lexeme $})    
            else 
                case Lexeme of "+" then
                    operator(type:plus)
                [] "-" then
                    operator(type:minus)
                [] "*" then
                    operator(type:multiply)
                [] "/" then
                    operator(type:divide)
                [] "i" then
                    operator(type:flip)
                [] "^" then
                    operator(type:invert)
                [] "p" then
                    command(print)
                [] "d" then
                    command(duplicate)
                else
                    raise invalidOperator(Lexeme) end
                end
            end
        end
    in
        case Lexemes of Head|Tail then
            {TokenizeSingle Head}|{Tokenize Tail}
        else
            nil
        end
    end

    {Browse 'Task 2b'}
    {Browse {Tokenize {Lex "1 2 + 3 *"}}}

    fun {Interpret Tokens}
        /* Helper function to perform single operation on the stack */
        fun {Operate T Stack} V in
            /* Consider unary operators first */
            case T of flip then
                case Stack of number(Head)|Tail then
                    number(~Head)|Tail
                else
                    raise invalidCommand(T) end
                end
            [] invert then
                case Stack of number(Head)|Tail then
                    number(1.0 / Head)|Tail
                else
                    raise invalidCommand(T) end
                end
            else
                /* Consider binary operators */
                case Stack of number(N1)|number(N2)|Tail then
                    case T of plus then
                        V = number(N2 + N1)
                    [] minus then
                        V = number(N2 - N1)
                    [] multiply then
                        V = number(N2 * N1)
                    [] divide then
                        V = number(N2 / N1)
                    else
                        raise unknownOperator(T) end
                    end
                    V|Tail
                else
                    Stack
                end
            end
        end

        /* Helper function to execute a single command */
        fun {Command T Stack}
            case T of print then
                /* Using browse instead of System.showInfo to 
                keep everything in one place */
                /* Reverse the stack to satisfy expected output from task */
                {Browse {Reverse Stack}}
                Stack
            [] duplicate then
                case Stack of Head|Tail then
                    Head|Stack
                else
                    raise invalidCommand(T) end
                end
            else
                raise unknownCommand(T) end
            end
        end
        
        /* Recursive helper function for interpreting the tokens */
        fun {Eval Tokens Stack}
            case Tokens of number(N)|Tail then
                {Eval Tail number(N)|Stack}
            [] operator(type:T)|Tail then
                {Eval Tail {Operate T Stack}}
            [] command(T)|Tail then
                {Eval Tail {Command T Stack}}
            else
                Stack
            end
        end
    in
        /* Reverse the results to satisfy expected output from task */
        {Reverse {Eval Tokens nil}}
    end

    {Browse 'Task 2c'}
    {Browse {Interpret {Tokenize {Lex "1 2 3 +"}}}}

    {Browse 'Task 2d'}
    {Browse {Interpret {Tokenize {Lex "1 2 3 p +"}}}}

    {Browse 'Task 2e'}
    {Browse {Interpret {Tokenize {Lex "1 2 3 + d"}}}}

    {Browse 'Task 2f'}
    {Browse {Interpret {Tokenize {Lex "-3.0 i"}}}}

    {Browse 'Task 2g'}
    {Browse {Interpret {Tokenize {Lex "3.0 ^"}}}}

    fun {Infix Tokens}
        fun {InfixSingle T Expressions} V in
            /* Consider unary operators first */
            case T of flip then
                case Expressions of Head|Tail then
                    ~Head|Tail
                else
                    raise invalidCommand(T) end
                end
            [] invert then
                case Expressions of Head|Tail then
                    ('1/'#Head)|Tail
                else
                    raise invalidCommand(T) end
                end
            else
                /* Consider binary operators */
                case Expressions of N1|N2|Tail then 
                    case T of plus then
                        V = '('#N2#' + '#N1#')'
                    [] minus then
                        V = '('#N2#' - '#N1#')'
                    [] multiply then
                        V = '('#N2#' * '#N1#')'
                    [] divide then
                        V = '('#N2#' / '#N1#')'
                    else
                        raise unknownOperator(T) end
                    end
                    V|Tail
                else
                    Expressions
                end
            end
        end

        fun {InfixInternal Tokens Expressions}
            case Tokens of number(N)|Tail then
                {InfixInternal Tail N|Expressions}
            [] operator(type:T)|Tail then
                {InfixInternal Tail {InfixSingle T Expressions}}
            [] command(T)|Tail then
                /* Ignore commands, not relevant here */
                {InfixInternal Tail Expressions}
            else
                Expressions
            end
        end
    in
        {InfixInternal Tokens nil}.1
    end

    {Browse 'Task 3'}
    {Browse {Infix {Tokenize {Lex "3.0 10.0 9.0 * - 0.3 +"}}}}
end

/*

Task 4

a)

V = {v, n, d, o}
S = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ., *, /, +, -, p, d, ^, i}
v_s = v
R = {
    n -> 0n
    n -> 1n
    n -> 2n
    n -> 3n
    n -> 4n
    n -> 5n
    n -> 6n
    n -> 7n
    n -> 8n
    n -> 9n
    n -> .d
    d -> 0d
    d -> 1d
    d -> 2d
    d -> 3d
    d -> 4d
    d -> 5d
    d -> 6d
    d -> 7d
    d -> 8d
    d -> 9d
    o -> +
    o -> -
    o -> *
    o -> /
    o -> p
    o -> d
    o -> ^
    o -> i
    v -> n v
    v -> o v
}

b)

<number> ::= {0|1|2|3|4|5|6|7|8|9}+[.{0|1|2|3|4|5|6|7|8|9}]
<operator-high> ::= *|/
<operator-low> ::= +|-
<expression ::= <expression> <operator-low> <term> | <term>
<term> ::= (<expression>) | <number> | <term> <operator-high> <term>

This grammar is not ambigious. In expression, if we had let the 3rd "part" be
any number strings such as "1 + 2 + 3" would've had multiple parse trees,
but by limiting that to "term" there is only one. 

c)

A context-sensitive has limitations for situations in which certain rules
can be applied (Only applicable in certain contexts). This is not the case
for context-free grammars.

d)

This will happen because Oz does not permit operations on different types,
and considers integers and floats to be different. This can be useful to
detect issues such as numbers that have been represented using the wrong
type (e. g. a number that is always an integer represented as a float), or
to see if you are using the wrong variable somewhere. They also have very
different representations at a binary level, so if you are going to be
performing operations on them it will be useful that they are in the same
format.
*/