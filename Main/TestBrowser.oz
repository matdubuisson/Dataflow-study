functor
import
    OS
    Browser
define
    local R in
        R = {OS.localTime $}
        {Browser.browse R}
    end

    local A in
        fun lazy {Compute S}
            case S of H|T then
                H*H|{Compute T}
            end
        end

        thread
            local Repeat in
                proc {Repeat I L}
                    local T in
                        {Time.delay 500}
                        L=I|T
                        {Repeat I+1 T}
                    end
                end

                {Repeat 0 A}
            end
        end

        {Browser.browse A}

        local B in
            B = {Compute A}
            {Browser.browse B}

            proc {Walk A}
                case A of H|T then
                    {Time.delay 1000}

                    local X in
                        X=H+1
                    end

                    {Walk T}
                end
            end

            {Walk B}
        end
    end
end