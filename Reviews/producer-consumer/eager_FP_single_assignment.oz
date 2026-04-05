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

    % In an eager stream, it is the producer that determines
    % when elements are sent.
    % Termination is decided by the producer.

    S1 S2
in
    {Browser.browse S1}
    {Browser.browse S2}
    thread S1 = {Producer 0 5} end
    thread S2 = {Consumer S1 0} end
end