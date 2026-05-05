functor
import
    OS
    System
    Browser
define
    fun {GenerateIncrementalStream}
        fun lazy {Aux I}
            I|{Aux I + 1}
        end
    in
        {Aux 0}
    end

    fun lazy {Times L N}
        thread L.1 * N end|{Times thread L.2 end N}
    end

    fun lazy {Merge L0 L1}
        case L0#L1 of (H0|T0)#(H1|T1) then
            if H0 < H1 then
                H0|{Merge T0 L1}
            elseif H0 > H1 then
                H1|{Merge L0 T1}
            else
                H0|{Merge T0 T1}
            end
        end
    end

    proc {Touch S N}
        {Time.delay 1000}
        if N == 0 then skip
        else
            {Wait S}
            {Touch S.2 N - 1}
        end
    end

    S1 S2 S3 S4 S
in
    {Browser.browse s1(S1)}
    {Browser.browse s2(S2)}
    S1 = _ % {GenerateIncrementalStream}
    S2 = {Times S1 2}
    {Touch S2 10}
end