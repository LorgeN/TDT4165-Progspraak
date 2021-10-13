/*
Note here that the assignment says to use declare x in <stmt> end, but when using the
in keyword at the end it simply does not work, and results in an error.
 */
declare QuadraticEquation Sum RightFold LengthFold SumFold Quadratic LazyNumberGenerator SumTailRec

/* Task 1 */
proc {QuadraticEquation A B C ?RealSol ?X1 ?X2} D in
    D = B * B - 4.0 * A * C
    RealSol = D >= 0.0
    if RealSol then
        X1 = ~B + {Sqrt D} / (2.0 * A)
        X2 = ~B - {Sqrt D} / (2.0 * A)
    end
end

/* Task 1a */
{Browse 'Task 1a'}
local RealSol X1 X2 in
    {Browse 'A = 2. B = 1, C = -1'}
    {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
    {Browse 'Real solution? '#RealSol}
    {Browse 'X1='#X1}
    {Browse 'X2='#X2}
end

local RealSol X1 X2 in
    {Browse 'A = 2. B = 1, C = 1'}
    {QuadraticEquation 2.0 1.0 1.0 RealSol X1 X2}
    {Browse 'Real solution? '#RealSol}
    {Browse 'X1='#X1}
    {Browse 'X2='#X2}
end

/*
Task 1b

Procedural abstraction is useful because
 - It can help move certain logic elsewhere, so that you 
    can focus on the task at hand
 - Allows us to reuse that logic if we wish to complete the
    same task in a different situation, possibly with different
    values (such as different values for A, B and C) without
    copying the code

Task 1c

A procedure doesn't necessarily have a return value, but a function
does. A function in Oz is just syntactic sugar, and we can emulate
a function by using the ? operator on our arguments in a procedure,
allowing the caller to pass arguments we can assign values to. This
is done automatically when using a function.
*/

/* Task 2 */
fun {Sum List}
    case List of Head|Tail then
        Head + {Sum Tail}
    else
        0
    end
end

{Browse 'Task 2'}
{Browse {Sum [1 2 3]}}

/* Task 3 */
fun {RightFold List Op U}
    /* Perform pattern matching to get the first element of the
    list separated from the rest */
    case List of Head|Tail then
        /* Evaluate this (Head = the current leftmost element)
          towards the tail of the list recursively by calling Op
          on Head and the result of the recursive call
        */
        {Op Head {RightFold Tail Op U}}
    else
        /* If the list is empty we return the "neutral" case */
        U
    end
end

fun {LengthFold List}
    {RightFold List fun {$ X Y} 1 + Y end 0}
end

fun {SumFold List}
    {RightFold List fun {$ X Y} X + Y end 0}
end

{Browse 'Task 3c'}
{Browse {LengthFold [1 2 3 4]}}
{Browse {SumFold [1 2 3 4]}}

/*
Task 3d

Additions is a commutative operation. It does not matter if you do 
(((1 + 2) + 3) + 4) or otherwise. Since both of our operations are
based on addition they are also commutative. Subtraction on the other
hand does not share this property, i. e. ((1 - 2) - 3) = -4 and 
(1 - (2 - 3)) = 2 are not the same. This means that for addition (and
multiplication) right fold and left fold will be equvivalent operations,
but for subtraction (and division) they are not.

Task 3e

A good value for U here would 1, since X * 1 = X for any X.
*/

/* Task 4 */
fun {Quadratic A B C}
    fun {$ X} A * X * X + B * X + C end
end

{Browse 'Task 4'}
{Browse {{Quadratic 3 2 1} 2}}

/* Task 5 */
fun {LazyNumberGenerator StartValue}
    element(StartValue fun {$} {LazyNumberGenerator StartValue + 1} end)
end

{Browse 'Task 5'}
{Browse {LazyNumberGenerator 0}.1}
{Browse {{LazyNumberGenerator 0}.2}.1}
{Browse {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1}

/*
Task 5b

The solution works by creating a record with 2 elements; The first element
is the current value, gotten from StartValue. The 2nd element is a function
that calls the LazyNumberGenerator recursively with StartValue incremented
by 1. This means that the 2nd element has to be called before the next element
is created, making this list lazy and infinite. 

This is not actually a list in Oz, and I do not believe it will properly support
pattern matching, making a lot of our previously implemented functions difficult
to use.
*/

/*
Task 6

Task 6a

Our function from task 2 is not tail recursive, as the last thing executed by the
function is not the recursive call, but instead the result of adding Head and
the result of the recursive call.

To resolve this issue I have created an internal function that will accept the
current sum as an input, so that the call to this function is the last we do.
*/

fun {SumTailRec List}
    fun {SumInternal List Res}
        case List of Head|Tail then
            {SumInternal Tail Head + Res}
        else
            Res
        end
    end
in
    {SumInternal List 0}
end

/*
Task 6b

This allows the stack size to remain constant, which reduces memory consumption. We
can also remove a lot of variables from the store, since they are not needed any more
(as they are only present in the caller).

Task 6c

This has to be implemented by the language, so not necessarily all languages support
this optimization, but it is indeed a very useful one and most languages do support it.
It is a necessity for declarative languages.

Languages such as JavaScript will not do this always (Some browsers do support it now),
but it still supports recursive calls.

There is a memory management benefit to doing this either way, even in garbage collected
languages, because you may avoid running the garbage collector and that can improve
performance.
*/