/*
Task 2 worked fine when using \insert. Not sure what was supposed to be included
for that.
 */

/* Task 3a: */
local X Y Z in
    Y = 30
    Z = 300
    X = Y * Z
    { Show X }
end

/* Task 3b */
local X Y in
    X = "This is a string"
    thread {System.showInfo Y} end
    Y = X
    /* System.showInfo call is spawned on a new thread, and appears
     * to be blocking the thread until Y is assigned a value, meaning
     * it is not actually printing before it is assigned, but rather
     * waiting for it to be assigned a value. 
     * 
     * Since the assignment of Y is done on a different thread it is not
     * affected by the blocking nature of the call, and simply continues 
     * as normal. Y = X simply assigns Y whatever value X has. 
     * 
     * This can be useful for many purposes, where we dont know when
     * a variable is assigned a value or where, but when it happens we
     * wish to execute some code
     */
end

/* Task 4 */
local Max PrintGreater in
    /* Task 4a */
    fun {Max Number1 Number2}
        if Number1 > Number2 then
            Number1
        else
            Number2
        end
    end

    /* Task 4b */
    proc {PrintGreater Number1 Number2}
        {Show {Max Number1 Number2}}
    end

    {PrintGreater 1 2}
end

/* Task 5 */
local Circle Pi in
    Pi = 355.0/113.0

    proc {Circle R} A D C in
        A = Pi * R * R
        D = 2.0 * R
        C = Pi * D
        {System.showInfo 'Area: '#A}
        {System.showInfo 'Diameter: '#D}
        {System.showInfo 'Circumference: '#C}
    end

    {Circle 2.0}
end

/* Task 6 */
local Factorial in
    fun {Factorial N} R in        
        if N < 2 then
            R = 1
        else
            R = N * {Factorial N-1}
        end
        R
    end

    {System.showInfo "Factorial of 3: "#{Factorial 3}}
end

/* Task 7 */
local Length Take Drop Append Member Position in
    /* Task 7a */
    fun {Length List} A in 
        case List of Element1|Rest then
            A = 1 + {Length Rest}
        else
            A = 0
        end
        A
    end

    /* Task 7b */
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

    /* Task 7c */
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

    /* Task 7d */
    fun {Append List1 List2} R in
        case List1 of nil then
            R = List2
        [] L|Lr then
            R = L|{Append Lr List2}
        end 
        R
    end

    /* Task 7e */
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

    /* Task 7f */
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
end