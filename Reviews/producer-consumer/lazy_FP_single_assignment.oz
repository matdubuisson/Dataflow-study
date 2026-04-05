functor
import
    OS
    Browser
define
    fun lazy {Producer I Limit}
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

    % In a lazy stream, it is the consumer that determines
    % when elements are sent.
    % Termination is decided by the consumer.

    % Lazy programs allow to compute infinite lists as only needed elements are computed

    S1 S2
in
    {Browser.browse S1}
    {Browser.browse S2}
    S1 = {Producer 0 5}
    S2 = {Consumer S1 0}
end