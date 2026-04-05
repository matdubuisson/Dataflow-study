functor
import
    OS
    Browser
define
    fun lazy {Inc L}
        case L of H|T then H+1|{Inc T}
        [] nil then nil end
    end

    % Is equivalent to :

    fun {Inc2 L}
        case L of H|T then
            local X in
                thread
                    {WaitNeeded X}
                    X = H+1|{Inc2 T}
                end
                X
            end
        [] nil then nil end
    end

    proc {Touch L}
        case L of H|T then
            {Time.delay 1000}
            local X in
                X = H + 1
                {Touch T}
            end
        [] nil then skip end
    end
in
    local A B C in
        A = [1 2 3 4]
        B = {Inc A}
        C = {Inc2 A}

        {Browser.browse B}
        {Browser.browse C}
        {Touch B}
        {Touch C}
    end
end
