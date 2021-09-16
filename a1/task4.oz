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