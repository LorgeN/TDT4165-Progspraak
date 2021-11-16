/* Task 1 */
payment(0, []).
payment(Amount, [coin(Count,Value,Limit)|Tail]) :-
    Count in 0..Limit,
    payment(Remaining, Tail),
    Amount #= Count * Value + Remaining.

/* Task 2 */
member(E,[E|_]).
member(E,[_|R]) :- 
       member(E,R).

plan(Cabin, Cabin, [Cabin], 0).
plan(Cabin1, Cabin2, Path, TotalDistance) :-
    not(Cabin1 = Cabin2),
    not(member(Cabin1, RestOfPath)),
    append([Cabin1], RestOfPath, Path),
    TotalDistance #= DistanceToNext + RestOfDistance,
    distance(Cabin1, NextCabin, DistanceToNext, 1),
    plan(NextCabin, Cabin2, RestOfPath, RestOfDistance).