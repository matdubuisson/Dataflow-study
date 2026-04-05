functor
import
    OS
    Browser
define
    % FoldL can be used to be the body of an agent but it needs to be put inside a thread
    fun {FoldL Stream Function Result}
        case Stream of nil then Result
        [] Head|Tail then
            {FoldL Tail Function {Function Result Head}}
        end
    end

    % proc {Append Xs Ys ?Zs}
    %     choice
    %         Xs = nil Ys = Zs
    %     [] X Xr Zr in
    %         Xs = X|Xr Zs = X|Zr
    %         {Append Xr Ys Zr}
    %     end
    % end

    X
in
    % {Browser.browse {Append [1 2 3 4 5] [6 7 8 9 10] $}}

    X = {FoldL
        [0 1 2 3 4 5 6 7 8 9]
        fun {$ Value NewValue}
            (Value*Value + NewValue) mod 1000
        end
        0
    }

    {Browser.browse X}
end