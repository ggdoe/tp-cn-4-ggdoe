function [v] = dotcsr(AA, JA, IA, x)
    n = size(x)(1)
    v = zeros(x)
    k = 1
    for i=1:n
        v(k) = v(k) + AA(JA(i)) * x(JA(i))
        if(i+1 == IA(k+1))
            k = k + 1
        end
    end
endfunction
