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