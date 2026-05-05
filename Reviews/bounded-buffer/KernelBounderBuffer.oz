functor
import
    OS
    System
    Browser
define
    proc {GetRandomDelay ?R}
        local I in
            {OS.rand I}
            R = (I mod 20) * 100
        end
    end

    proc {Producer I Limit ?Stream}
        thread
            {WaitNeeded Stream}

            local R in
                {GetRandomDelay R}
                {Time.delay R}
            end

            if I =< Limit then
                {System.show produce(I)}
                local Tail in
                    Stream = I|Tail
                    {Producer I+1 Limit Tail}
                end
            else Stream = nil end
        end
    end

    proc {Consumer InStream Accumulator ?OutStream}
        thread
            {WaitNeeded OutStream}

            local R in
                {GetRandomDelay R}
                {Time.delay R}
            end

            {Wait InStream}
            local X in
                if InStream.1 == nil then
                    OutStream = nil
                else
                    X = Accumulator + InStream.1
                    {System.show consume(X)}
                    local NewOutStream in
                        OutStream = X|NewOutStream
                        {Consumer InStream.2 X NewOutStream}
                    end
                end
            end
        end
    end

    proc {BoundedBuffer InStream MaxSize ?OutStream}
        proc {Touch Stream Limit ?StreamOffset}
            if Limit == 0 then StreamOffset = Stream
            else
                local X in
                    X = Stream.1 + 1 % I need the first element
                end
                {Touch Stream.2 Limit - 1 StreamOffset}
            end
        end

        proc {Loop InStream InStreamOffset ?OutStream}
            thread
                {WaitNeeded OutStream}
                local NewInStreamOffset in
                    {Wait InStream}

                    thread
                        {Wait InStreamOffset}
                        if InStreamOffset == nil then NewInStreamOffset = unit
                        else NewInStreamOffset = InStreamOffset.2 end
                    end

                    local NewOutStream in
                        OutStream = InStream.1|NewOutStream
                        {Loop InStream.2 NewInStreamOffset NewOutStream}
                    end
                end
            end
        end
    in
        local InStreamOffset in
            thread
                {Touch InStream MaxSize InStreamOffset}
            end

            {Loop InStream InStreamOffset OutStream}
        end
    end

    proc {InfiniteTouch Stream}
        local X in
            X = Stream.1 + 1
            {InfiniteTouch Stream.2}
        end
    end
in
    local S0 S1 S2 in
        {Browser.browse s0(S0)}
        {Browser.browse s1(S1)}
        {Browser.browse s2(S2)}
        {Producer 0 100 S0}
        {BoundedBuffer S0 5 S1}
        {Consumer S1 0 S2}
        {InfiniteTouch S2}
    end
end