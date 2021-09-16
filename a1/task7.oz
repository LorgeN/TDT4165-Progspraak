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