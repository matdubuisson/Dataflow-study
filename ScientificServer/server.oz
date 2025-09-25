functor
import
    OS
    System
    Browser
define 
    % fun {MultiplyMatrix M0 M1}
    %     fun {}
    % end
    % local A in
    %     A = {Array.new 0 10 14 ?}

    %     for I in 0; I < {Array.high A ?}; I + 1 do
    %         {System.show elem(I {Array.get A I ?})}
    %         {Time.delay 500}
    %     end
    % end
    

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