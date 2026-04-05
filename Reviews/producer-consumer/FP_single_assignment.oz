functor
import
    OS
    Browser
define
    fun {Producer I Limit}
        {Time.delay 1000}
        if I =< Limit then
            R
        in
            I|{Producer I+1 Limit}
        else nil end
    end

    fun {Consumer Stream Accumulator}
        case Stream of Head|Tail then
            Accumulator+Head|{Consumer Tail Accumulator+Head}
        [] nil then nil end
    end

    S1 S2
in
    {Browser.browse S1}
    {Browser.browse S2}
    S1 = {Producer 0 5}
    S2 = {Consumer S1 0}
end