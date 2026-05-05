functor
import
    OS
    System
    Browser
define
    proc {GenerateIncrementalStream ?Stream}
        proc {Aux I ?Stream}
            thread
                {WaitNeeded Stream}
                local NewStream in
                    Stream = I|NewStream
                    {Aux I+1 NewStream}
                end
            end
        end
    in
        {Aux 0 Stream}
    end

    proc {Times InStream N ?OutStream}
        thread
            % {WaitNeeded OutStream} % Oups
            local NewOutStream in
                {Wait InStream}
                local Value in
                    Value = InStream.1 * N
                    OutStream = Value|NewOutStream
                end
                {Times InStream.2 N NewOutStream}
            end
        end
    end

    proc {Merge InStream0 InStream1 ?OutStream}
        thread
            {WaitNeeded OutStream}
            {Wait InStream0}
            {Wait InStream1}

            local V0 V1 NewOutStream in
                V0 = InStream0.1
                V1 = InStream1.1
                if V0 < V1 then
                    OutStream = V0|NewOutStream
                    {Merge InStream0.2 InStream1 NewOutStream}
                elseif V0 > V1 then
                    OutStream = V1|NewOutStream
                    {Merge InStream0 InStream1.2 NewOutStream}
                else
                    OutStream = V0|NewOutStream
                    {Merge InStream0.2 InStream1.2 NewOutStream}
                end
            end
        end
    end

    proc {Touch Stream N}
        {Time.delay 1000}
        if N == 0 then skip
        else
            {Wait Stream}
            {Touch Stream.2 N - 1}
        end
    end
in
    local S0 S1 S2 S3 S4 S5 in
        {Browser.browse s0(S0)}
        {Browser.browse s1(S1)}
        {Browser.browse s2(S2)}
        {Browser.browse s3(S3)}
        {Browser.browse s4(S4)}
        {Browser.browse s5(S5)}
        {GenerateIncrementalStream S0}
        {Times S0 2 S1}
        {Times S0 3 S2}
        {Times S0 5 S3}
        {Merge S1 S2 S4}
        {Merge S3 S4 S5}
        {Touch S5 20}
    end
end
