functor
import
    OS
    Browser
define
    fun {NewPortObject InitState Transition}
        Port
        proc {Loop Stream State}
            case Stream of nil then skip
            [] Action|Tail then
                {Loop Tail {Transition State Action}}
            end
        end
    in
        thread
            Stream
        in
            Port = {NewPort Stream}
            {Loop Stream InitState}
        end

        Port
    end

    fun {CounterProcess Value Operation}
        {Browser.browse request(Operation)}
        case Operation
        of rand() then {OS.rand ?} mod 10
        [] add(A) then Value + A
        [] sub(A) then Value - A
        [] show() then
            {Browser.browse Value}
            Value
        else Value end
    end

    Counter = {NewPortObject 0 CounterProcess}
in
    for Operation in [show() rand() show() add(14) show() sub(16) show()] do
       {Send Counter Operation}
       {Time.delay 500}
    end
end