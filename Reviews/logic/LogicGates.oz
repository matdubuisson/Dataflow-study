functor
import
    OS
    System
    Browser
define
    fun {NotOp V}
        if V == 1 then 0 else 1 end
    end

    fun {AndOp V0 V1}
        if V0 == 1 andthen V1 == 1 then 1 else 0 end
    end

    fun {OrOp V0 V1}
        if V0 == 1 orelse V1 == 1 then 1 else 0 end
    end

    fun {XorOp V0 V1}
        if V0 \= V1 then 1 else 0 end
    end

    fun {MakeUnaryLogicGate Op}
        fun {$ S0}
            fun {Aux S0}
                case S0 of (V0|T0) then
                    {Op V0}|{Aux T0}
                end
            end
        in
            thread {Aux S0} end
        end
    end

    fun {MakeBinaryLogicGate Op}
        fun {$ S0 S1}
            fun {Aux S0 S1}
                case S0#S1 of (V0|T0)#(V1|T1) then
                    {Op V0 V1}|{Aux T0 T1}
                end
            end
        in
            thread {Aux S0 S1} end
        end
    end

    NotGate = {MakeUnaryLogicGate
        fun {$ B} 1-B end}
    AndGate = {MakeBinaryLogicGate
        fun {$ B0 B1} B0*B1 end}
    OrGate = {MakeBinaryLogicGate
        fun {$ B0 B1} B0+B1-B0*B1 end}
    XorGate = {MakeBinaryLogicGate
        fun {$ B0 B1} (B0+B1) mod 2 end}

    fun {MakeRandomBinaryStream}
        fun {Aux}
            {Time.delay 1000}
            if {OS.rand $} mod 2 == 0 then 0|{Aux}
            else 1|{Aux} end
        end
    in
        thread {Aux} end
    end

    proc {FullAdderGate X Y Z ?C ?S}
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

    S0 S1 S2 C S
in
    % local S0 S1 in
    %     S0 = {MakeRandomBinaryStream}
    %     S1 = {MakeRandomBinaryStream}
    %     {Browser.browse S0}
    %     {Browser.browse S1}
    %     {Browser.browse 'not'({NotGate S0})}
    %     {Browser.browse 'and'({AndGate S0 S1})}
    %     {Browser.browse 'or'({OrGate S0 S1})}
    %     {Browser.browse 'xor'({XorGate S0 S1})}
    % end

    {Browser.browse s0(S0)}
    {Browser.browse s1(S1)}
    {Browser.browse s2(S2)}
    {Browser.browse c(C)}
    {Browser.browse s(S)}
        
    S0 = {MakeRandomBinaryStream}
    S1 = {MakeRandomBinaryStream}
    S2 = {MakeRandomBinaryStream}
    {FullAdderGate S0 S1 S2 C S}
end