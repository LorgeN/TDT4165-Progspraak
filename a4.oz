declare RightFold GenerateOdd Product GenerateOddLazy HammerFactory RandomInt ConsumerRec HammerConsumer BoundedBuffer

/* Task 1 */
fun {GenerateOdd S E}
    if S > E then
        nil
    % Check if the number is odd
    elseif {Abs S} mod 2 == 1 then
        S|{GenerateOdd S + 2 E}
    elseif S + 1 > E then
        nil
    else
        S + 1|{GenerateOdd S + 3 E}
    end
end

{Browse 'Task 1'}
{Browse {GenerateOdd ~3 10}}
{Browse {GenerateOdd 3 3}}
{Browse {GenerateOdd 2 2}}

/* Task 3 from assignment 3 */
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

/* Task 2 */
fun {Product S}
    {RightFold S fun {$ X Y} X * Y end 1}
end

{Browse 'Task 2'}
{Browse {Product [1 2 3 4]}}

/* Task 3 */
{Browse 'Task 3'}
local Vals Prod in
    thread Vals = {GenerateOdd 0 1000} end
    thread Prod = {Product Vals} end
    {Browse Prod}
end
/*
The first three digits are 100.

The benefit of doing this on two separate threads is that the multiplication
process can begin before we are done generating the list, which significantly
speeds up the total time the execution of our program takes.
*/

/* Task 4 */
fun lazy {GenerateOddLazy S E}
    if S > E then
        nil
    % Check if the number is odd
    elseif {Abs S} mod 2 == 1 then
        S|{GenerateOdd S + 2 E}
    elseif S + 1 > E then
        nil
    else
        S + 1|{GenerateOdd S + 3 E}
    end
end

{Browse 'Task 4'}

local Vals Prod in
    thread Vals = {GenerateOddLazy 0 1000} end
    thread Prod = {Product Vals} end
    {Browse Prod}
end
/*
Using lazy here means that the list will not be generated until it is needed.
Earlier the list was being generated as fast as possible, even if the product
function call could not keep up. Here (using the lazy annotation) the list will
not be generated (by calling the GeneratedOdd function recursively) until the
value is needed in the Product call.

This can reduce throughput, as the values are not ready when the Product function
needs them. Due to the implementation of our Product function (It is not tail
recursive) we do not benefit from it resource wise. If we changed our Product
function to be tail recursive we could benefit of a constant size list, since
the earlier and already processed elements are discarded.
*/

/* Task 5 */
fun {RandomInt Min Max}
    X = {OS.rand}
    MinOS
    MaxOS
in
    {OS.randLimits ?MinOS ?MaxOS}
    Min + X * (Max - Min) div (MaxOS - MinOS)
end

/* Task 5a */
fun lazy {HammerFactory}
    /* Confused why the assignment says 88% working and 10% defect (98%????) */
    Hammer = if {RandomInt 0 100} =< 10 then defect else working end
in
    {Delay 1000}
    Hammer|{HammerFactory}
end

{Browse 'Task 5a'}
local HammerTime B in
    HammerTime = {HammerFactory}
    B = HammerTime.2.2.2.1
    {Browse HammerTime}
end

/* Task 5b */
fun {ConsumerRec Stream N Res}
    if N =< 0 then
        Res
    else
        case Stream of working|Tail then
            {ConsumerRec Tail N - 1 Res + 1}
        [] Head|Tail then
            {ConsumerRec Tail N - 1 Res}
        end
    end
end

fun {HammerConsumer HammerStream N}
    {ConsumerRec HammerStream N 0}
end

{Browse 'Task 5b'}
local HammerTime Consumer in
    HammerTime = {HammerFactory}
    Consumer = {HammerConsumer HammerTime 10}
   {Browse Consumer}
end

/* Task 5c */
fun {BoundedBuffer HammerStream N}
    /* Skip N elements ahead in the list. Use thread to avoid blocking */
    Tail = thread {List.drop HammerStream N} end
    /* Use a lazy function so it wont recursively skip ahead instantly 
    when its called */
    fun lazy {BufferInternal Stream Tail}
        /* Our stream still contains our original elements, so we can still
        access those using the original reference even if we have calculated
        a few elements ahead */
        case Stream of Hammer|NewTail then
            /* Return the head of the stream, and then append a new recursive
            call as tail. This new call also spawns a new thread to evauluate
            the next element in the tail so that we always maintain N elements */
            Hammer|{BufferInternal NewTail thread Tail.2 end}
        end
    end
in
    {BufferInternal HammerStream Tail}
end

{Browse 'Task 5c'}

local HammerStream Buffer in
    {Browse 'With buffer'}
    HammerStream = {HammerFactory}
    Buffer = {BoundedBuffer HammerStream 6}
    {Delay 6000}
    Consumer = {HammerConsumer Buffer 10}
    {Browse Consumer}
end

local HammerStream in
    {Browse 'Without buffer'}
    HammerStream = {HammerFactory}
    {Delay 6000}
    Consumer = {HammerConsumer HammerStream 10}
    {Browse Consumer}
end