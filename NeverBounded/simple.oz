functor
import
    OS
    System
define
    % Simple detection case => ERROR
    % The dataflow variable is never assigned so all pennding operations on X won't terminate

    {System.show start}

    local X in
        thread
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