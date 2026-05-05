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

    fun lazy {Producer I Limit}
        {Time.delay {GetRandomDelay}}
        if I =< Limit then
            {System.show produce(I)}
            I|{Producer I+1 Limit}
        else nil end
    end

    fun lazy {Consumer Stream Accumulator}
        {Time.delay {GetRandomDelay}}
        case Stream of Head|Tail then
            X = Accumulator+Head
        in
            {System.show consume(X)}
            X|{Consumer Tail X}
        [] nil then nil end
    end

    fun {BoundedBuffer Stream MaxSize}
        % Touch 'Limit' first elements
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
                % Returns elements on needs
                Head|{Loop Tail
                    thread
                        if End == nil then nil
                        % Ask producer to make
                        % an advance
                        else End.2 end
                    end}
            end
        end

        End
    in
        % Defines the buffer size
        End = {Touch Stream MaxSize} % Oups no thread
        {Loop Stream End}
    end

    S0 S1 S2

    proc {InfiniteTouch Stream}
        case Stream of Head|Tail then
            X = Head + 1
        in
            {InfiniteTouch Tail}
        end
    end
in
    {Browser.browse s0(S0)}
    {Browser.browse s1(S1)}
    {Browser.browse s2(S2)}
    S0 = {Producer 0 100}
    S1 = {BoundedBuffer S0 5}
    S2 = {Consumer S1 0}
    {InfiniteTouch S2}
end