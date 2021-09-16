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