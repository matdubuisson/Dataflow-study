functor
import
    OS
    System
    Browser
define
    proc {NotOp Input ?Output}
        Output = 1 - Input
    end

    proc {AndOp Input0 Input1 ?Output}
        Output = Input0 * Input1
    end

    proc {OrOp Input0 Input1 ?Output}
        Output = Input0 + Input1 - Input0 * Input1
    end

    proc {XorOp Input0 Input1 ?Output}
        Output = (1 - Input0) * Input1 + Input0 * (1 - Input1)
    end

    proc {MakeRandomBinaryStream ?Stream}
        local Aux in
            Aux = proc {$ ?Stream}
                {Time.delay 500}

                local Value Bit in
                    {OS.rand Value}
                    Bit = Value mod 2
                    local NewStream in
                        Stream = Bit|NewStream
                        {Aux NewStream}
                    end
                end
            end
            thread {Aux Stream} end
        end
    end

    proc {MakeUnaryLogicGate Op ?Gate}
        Gate = proc {$ InStream ?OutStream}
            local Aux in
                Aux = proc {$ InStream ?OutStream}
                    {Wait InStream}
                    local Bit NewOutStream in
                        {Op InStream.1 Bit}
                        OutStream = Bit|NewOutStream
                        {Aux InStream.2 NewOutStream}
                    end
                end
                thread
                    {Aux InStream OutStream}
                end
            end
        end
    end

    proc {MakeBinaryLogicGate Op ?Gate}
        Gate = proc {$ InStream0 InStream1 ?OutStream}
            local Aux in
                Aux = proc {$ InStream0 InStream1 ?OutStream}
                    {Wait InStream0}
                    {Wait InStream1}
                    local Bit NewOutStream in
                        {Op InStream0.1 InStream1.1 Bit}
                        OutStream = Bit|NewOutStream
                        {Aux InStream0.2 InStream1.2 NewOutStream}
                    end
                end
                thread
                    {Aux InStream0 InStream1 OutStream}
                end
            end
        end
    end

    NotGate AndGate OrGate XorGate
    FullAdderGate
in
    {MakeUnaryLogicGate NotOp NotGate}
    {MakeBinaryLogicGate AndOp AndGate}
    {MakeBinaryLogicGate OrOp OrGate}
    {MakeBinaryLogicGate XorOp XorGate}

    FullAdderGate = proc {$ X Y Z ?C ?S}
        C = {OrGate
            {AndGate X Y}
            {OrGate
                {AndGate Y Z}
                {AndGate X Z}
            }
        }
        S = {XorGate
            Z
            {XorGate X Y}
        }
    end

    local X Y Z C S in
        {Browser.browse x(X)}
        {Browser.browse y(Y)}
        {Browser.browse z(Z)}
        {Browser.browse c(C)}
        {Browser.browse s(S)}
            
        {MakeRandomBinaryStream X}
        {MakeRandomBinaryStream Y}
        {MakeRandomBinaryStream Z}
        {FullAdderGate X Y Z C S}
    end
end