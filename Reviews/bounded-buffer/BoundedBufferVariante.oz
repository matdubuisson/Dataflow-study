functor
import
    OS
    System
    Browser
define
    fun {GetRandomDelay}
        I = {OS.rand $} mod 20
        D = I * 100
    in
        %{System.show delay(D)}
        D
    end

    fun lazy {Producer Stream I Limit}
        {Time.delay {GetRandomDelay}}
        if I =< Limit then
            case Stream of Head|Tail then
                {System.show produce(I)}
                I*Head mod Limit|{Producer Tail I+1 Limit}
            end
        else nil end
    end

    fun {Consumer Stream Accumulator}
        {Time.delay {GetRandomDelay}}
        case Stream of Head|Tail then
            X = Accumulator+Head % Oups
        in
            {System.show consume(X)}
            X|{Consumer Tail Accumulator+Head}
        [] nil then nil end
    end

    fun {BoundedBuffer Stream MaxSize}
        fun {Touch Stream Limit}
            if Limit == 0 then Stream
            else
                X = Stream.1 + 1
            in
                {Touch Stream.2 Limit - 1}
            end
        end
        
        fun lazy {Loop Stream End}
            case Stream of Head|Tail then
                Head|{Loop Tail thread if End == nil then unit else End.2 end end}
            end
        end

        End
    in
        thread End = {Touch Stream MaxSize} end
        {Loop Stream End}
    end

    S0 S1 S2
in
    %S0 = {Producer S2 0 100}
    S0 = {Producer 1|S2 0 100}
    S1 = {BoundedBuffer S0 5}
    S2 = {Consumer S1 0}
end