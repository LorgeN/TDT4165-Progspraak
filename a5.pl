/* Task 1 */
payment(0, []).
payment(Amount, [coin(Count,Value,Limit)|Tail]) :-
    Count in 0..Limit,
    payment(Remaining, Tail),
    Amount #= Count * Value + Remaining.