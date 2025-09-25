functor
import
    OS
    System
define
    % Detection case => ERROR/WARNING
    % The dataflow variable couldn't be assigned and then all pending oprations on it won't terminate

    {System.show start}

    local X in
        thread
            if {OS.rand ?} mod 2 == 0 then
                X = 1
            end

            {System.show thread0}
        end

        thread
            local Y in
                Y = X + 1
                {System.show Y}
            end

            {System.show thread1}
        end
    end

    {Time.delay 500}
end