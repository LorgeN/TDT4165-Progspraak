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