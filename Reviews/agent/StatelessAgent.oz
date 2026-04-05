functor
import
    OS
    Browser
define
    % With this version the program is in dead-lock because the first operation can never finished
    % proc {ForAll Stream Process}
    %     case Stream of nil then skip
    %     [] Head|Tail then
    %         {Process Head}
    %         {ForAll Tail Process}
    %     end
    % end
    proc {ForAll Stream Process}
        case Stream of nil then skip
        [] Head|Tail then
            thread {Process Head} end % It's better
            {ForAll Tail Process}
        end
    end

    fun {NewPortObject Process}
        Port
        Stream
    in
        Port = {NewPort Stream}
        thread {ForAll Stream Process} end
        Port
    end

    proc {MathProcess Operation}
        {Browser.browse request(Operation)}
        case Operation
        of rand(?V) then V = {OS.rand ?} mod 10
        [] add(A B ?V) then V = A + B
        [] sub(A B ?V) then V = A - B
        else skip end
    end

    Agent = {NewPortObject MathProcess}
in
    local A B C D E in
        {Browser.browse [A B C D E]}
        {Send Agent add(C D E)}
        {Time.delay 1000}
        {Send Agent sub(B C D)}
        {Time.delay 1000}
        {Send Agent add(A B C)}
        {Time.delay 1000}
        {Send Agent sub(A 1 B)}
        {Time.delay 1000}
        {Send Agent rand(A)}
    end
end